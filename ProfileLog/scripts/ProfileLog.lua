--Start of Function and Event Scope---------------------------------------------

local function main()
  local v = View.create()

  local DELAY = 2000 -- ms between each type for demonstration purpose

  -- Data from https://datamarket.com/data/set/1loo
  local temp = Profile.load('resources/temperatures.csv')
  local tempIdx = 0

  -- Emulate capturing of measurement
  local function getMeasurement()
    local value = temp:getValue(tempIdx)
    tempIdx = tempIdx + 1
    return value
  end

  -- Create log object
  local log = Profile.Log.create()

  -- Enable historic statistics with 100 periods
  log:enableHistoricStatistics(100)

  -- Add values to log, one by one. Several values can be sent at once,
  -- using vectors or Profiles.
  for i = 0, 877 do
    local value = getMeasurement()
    local coordinate = i + 0.0 -- convert to float
    log:addValue(value, coordinate)
  end

  print('Log contains ' .. log:getCount() .. ' values.')
  print(string.format('Min: %9.2f', log:getMin()))
  print(string.format('Max: %9.2f', log:getMax()))
  print(string.format('Average: %.2f', log:getMean()))

  -- Plot historic statistics
  local grDec = View.GraphDecoration.create()

  grDec:setLabels('Samples', 'Degrees C')
  print('Each historic period contains ' .. log:getHistoricPeriod() .. ' samples.')

  -- Get historic min as a Profile
  local min = log:getHistoricMin()

  -- Plot
  v:clear()
  grDec:setTitle('Min')
  v:addProfile(min, grDec)
  v:present()

  Script.sleep(DELAY)

  local max = log:getHistoricMax()
  v:clear()
  grDec:setTitle('Max')
  v:addProfile(max, grDec)
  v:present()

  Script.sleep(DELAY)

  local mean = log:getHistoricMean()

  v:clear()
  grDec:setTitle('Average')
  v:addProfile(mean, grDec)
  v:present()
  print('App finished.')
end

--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
