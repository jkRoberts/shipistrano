# 
# Generic Helpers that are used across test scenarios
#
When(/^I run cap (.*)$/) do |op|
  Dir.chdir(@deploy.app_dir) do
    system "cap " + op
  end
end

When(/^I add (\S*) remotely$/) do |file|
  @deploy.execute_remotely("touch #{file}")
end

When(/^I add (\S*) locally$/) do |file|
  @deploy.execute_locally("touch #{file}")
end

Then(/^cap (\S*) should return true$/) do |command|
  Dir.chdir(@deploy.app_dir) do
    result = `cap #{command}`

    expect(result.to_s.lines.last.strip).to eq("true")
  end
end

Then(/^cap (\S*) should return false$/) do |command|
  Dir.chdir(@deploy.app_dir) do
    result = `cap #{command}`
    puts result.to_s.lines
    expect(result.to_s.lines.last.strip).to eq("false")
  end
end