return {
   {
      "goolord/alpha-nvim",
      event = "VimEnter",
      opts = function()
         local dashboard = require("alpha.themes.dashboard")
         local wakapi = require("config.wakapi")
         local weather = require("config.weather")
         local initial = wakapi.view(nil)

         dashboard.section.weather = {
            type = "text",
            val = weather.line(weather.read_cache()),
            opts = { position = "center", hl = "AlphaZenWeather" },
         }

         dashboard.section.logo = {
            type = "text",
            val = {
               "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
               "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
               "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
               "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
               "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
               "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            },
            opts = { position = "center", hl = "AlphaZenTitle" },
         }

         dashboard.section.header = {
            type = "group",
            val = {
               {
                  type = "text",
                  val = os.date("%A  ·  %d %B"),
                  opts = { position = "center", hl = "AlphaZenMuted" },
               },
               dashboard.section.weather,
            },
            opts = { spacing = 1 },
         }

         dashboard.section.activity = {
            type = "text",
            val = initial.lines,
            opts = { position = "center", hl = initial.highlights },
         }
         dashboard.section.metrics = {
            type = "text",
            val = "Wakapi  ·  syncing…",
            opts = { position = "center", hl = "AlphaZenMetric" },
         }

         dashboard.config.layout = {
            {
               type = "padding",
               val = function()
                  return math.max(1, math.floor((vim.o.lines - 27) / 2) - 4)
               end,
            },
            dashboard.section.logo,
            { type = "padding", val = 1 },
            dashboard.section.header,
            { type = "padding", val = 3 },
            dashboard.section.activity,
            { type = "padding", val = 1 },
            dashboard.section.metrics,
         }
         dashboard.config.opts.margin = 4
         return dashboard
      end,

      config = function(_, dashboard)
         local alpha = require("alpha")
         local wakapi = require("config.wakapi")
         local weather = require("config.weather")

         local function set_activity_highlights()
            local light = vim.o.background == "light"
            local colors = light
                  and {
                     activity = "#343B58",
                     metric = "#4B7165",
                     muted = "#6B7089",
                     title = "#34548A",
                     weather = "#397A83",
                  }
               or {
                  activity = "#DCD7BA",
                  metric = "#A3BE8C",
                  muted = "#8A8980",
                  title = "#7E9CD8",
                  weather = "#7FB4CA",
               }
            local palette = light
                  and { "#D9DCE5", "#BCD6CC", "#8BBEAB", "#5BA58C", "#34836B" }
               or { "#3A3C47", "#395650", "#47736A", "#5B9180", "#78B89B" }

            vim.api.nvim_set_hl(0, "AlphaZenActivity", { fg = colors.activity, bold = true })
            vim.api.nvim_set_hl(0, "AlphaZenMetric", { fg = colors.metric })
            vim.api.nvim_set_hl(0, "AlphaZenMuted", { fg = colors.muted })
            vim.api.nvim_set_hl(0, "AlphaZenTitle", { fg = colors.title, bold = true })
            vim.api.nvim_set_hl(0, "AlphaZenWeather", { fg = colors.weather })
            vim.api.nvim_set_hl(0, "AlphaZenCursor", { blend = 100, nocombine = true })
            for level, color in ipairs(palette) do
               vim.api.nvim_set_hl(0, "AlphaWakapi" .. (level - 1), { fg = color })
            end
         end

         local function redraw()
            if vim.bo.filetype == "alpha" then
               pcall(vim.cmd.AlphaRedraw)
            end
         end

         local function show(payload, message)
            if payload then
               dashboard._wakapi_payload = payload
               local view = wakapi.view(payload)
               dashboard.section.activity.val = view.lines
               dashboard.section.activity.opts.hl = view.highlights
               dashboard.section.metrics.val = view.summary
            elseif message then
               dashboard.section.metrics.val = "Wakapi  ·  " .. message
            end
            redraw()
         end

         local function refresh()
            dashboard.section.metrics.val = "Wakapi  ·  syncing…"
            redraw()
            wakapi.fetch(show)
         end

         local function show_weather(payload, message)
            if payload then
               dashboard.section.weather.val = weather.line(payload)
            elseif message and not weather.read_cache() then
               dashboard.section.weather.val = "Karlsruhe  ·  " .. message
            end
            redraw()
         end

         set_activity_highlights()
         vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
               vim.opt_local.fillchars:append({ eob = " " })
               vim.opt_local.cursorline = false
               vim.opt_local.winhighlight:append("Cursor:AlphaZenCursor")
            end,
         })
         vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
               set_activity_highlights()
               redraw()
            end,
         })
         vim.api.nvim_create_user_command("WakapiRefresh", refresh, { force = true })
         vim.api.nvim_create_user_command("WeatherRefresh", function()
            weather.fetch(show_weather)
         end, { force = true })

         if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
               once = true,
               pattern = "AlphaReady",
               callback = function()
                  require("lazy").show()
               end,
            })
         end

         alpha.setup(dashboard.config)

         local cached = wakapi.read_cache()
         if cached then
            show(cached)
         end
         refresh()
         weather.fetch(show_weather)
      end,
   },
}
