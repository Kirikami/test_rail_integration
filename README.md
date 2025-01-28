# TestRailIntegration

This gem made for interaction between TestRail and Ruby automation framework Cucumber+Watir

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'test_rail_integration'
gem 'thor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install test_rail_integration

## Usage

After installation type

    test_rail_integration perform

This command generate executable file run_test_run.rb. You should run this file with parameter - number on test run in TestRail
Fill all data in test_rail_data.yml.

Add TestRail::Hook.update_test_rail(scenario) into " after |scenario| " hook.

For standard running use command

    ruby run_test_run.rb <run_number>

For generate test run by default use

    ruby run_test_run.rb auto <1st parameter> <2nd parameter>

Command that will generated is placed in test_rail_data.yml :exec_command:

After running command for generating executable file run

    ./cucumber_run.sh

For perform this actions in Jenkins just create Execute shell "ruby run_test_run.rb $Testrun_id ; ./cucumber_run.sh;" where $Testrun_id its string parameter for parameterized builds.
## Contributing

1. Fork it ( https://github.com/kirikami/test_rail_integration/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
