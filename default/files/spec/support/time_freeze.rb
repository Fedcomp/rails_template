# Time sensitive test
RSpec.configure do |config|
  config.around time: :freeze do |example|
    travel_to Time.current do
      example.call
    end
  end
end
