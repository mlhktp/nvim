local M = {}

local cache_file = vim.fs.joinpath(vim.fn.stdpath("cache"), "weather-karlsruhe.json")
local endpoint = table.concat({
   "https://api.open-meteo.com/v1/forecast",
   "?latitude=49.0069&longitude=8.4037",
   "&current=temperature_2m,apparent_temperature,weather_code,wind_speed_10m",
   "&timezone=Europe%2FBerlin&forecast_days=1",
})

local conditions = {
   [0] = "Clear",
   [1] = "Mostly clear",
   [2] = "Partly cloudy",
   [3] = "Overcast",
   [45] = "Fog",
   [48] = "Fog",
   [51] = "Light drizzle",
   [53] = "Drizzle",
   [55] = "Heavy drizzle",
   [56] = "Freezing drizzle",
   [57] = "Freezing drizzle",
   [61] = "Light rain",
   [63] = "Rain",
   [65] = "Heavy rain",
   [66] = "Freezing rain",
   [67] = "Freezing rain",
   [71] = "Light snow",
   [73] = "Snow",
   [75] = "Heavy snow",
   [77] = "Snow grains",
   [80] = "Light showers",
   [81] = "Showers",
   [82] = "Heavy showers",
   [85] = "Snow showers",
   [86] = "Heavy snow showers",
   [95] = "Thunderstorm",
   [96] = "Thunderstorm with hail",
   [99] = "Thunderstorm with hail",
}

local function decode(value)
   local ok, result = pcall(vim.json.decode, value)
   return ok and type(result) == "table" and result or nil
end

local function round(value)
   value = tonumber(value) or 0
   return value >= 0 and math.floor(value + 0.5) or math.ceil(value - 0.5)
end

function M.read_cache()
   local ok, lines = pcall(vim.fn.readfile, cache_file)
   if not ok then
      return nil
   end
   return decode(table.concat(lines, "\n"))
end

local function write_cache(payload)
   vim.fn.mkdir(vim.fs.dirname(cache_file), "p")
   pcall(vim.fn.writefile, { vim.json.encode(payload) }, cache_file)
end

function M.line(payload)
   local current = payload and payload.current
   if not current then
      return "Karlsruhe  ·  weather syncing…"
   end
   local temperature = round(current.temperature_2m)
   local apparent = round(current.apparent_temperature)
   local wind = round(current.wind_speed_10m)
   local condition = conditions[tonumber(current.weather_code)] or "Current weather"
   return string.format(
      "Karlsruhe   %d°C  ·  %s   feels %d°C  ·  wind %d km/h",
      temperature,
      condition,
      apparent,
      wind
   )
end

function M.fetch(callback)
   if vim.fn.executable("curl") ~= 1 then
      callback(nil, "weather unavailable")
      return
   end

   vim.system(
      { "curl", "--fail", "--silent", "--show-error", "--max-time", "5", endpoint },
      { text = true },
      vim.schedule_wrap(function(result)
         if result.code ~= 0 then
            callback(nil, "weather unavailable")
            return
         end
         local payload = decode(result.stdout)
         if not payload or type(payload.current) ~= "table" then
            callback(nil, "weather unavailable")
            return
         end
         write_cache(payload)
         callback(payload)
      end)
   )
end

return M
