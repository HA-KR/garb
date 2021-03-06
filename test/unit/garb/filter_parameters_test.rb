require 'test_helper'

module Garb
  class FilterParametersTest < MiniTest::Unit::TestCase
    context "A FilterParameters" do
      context "when converting parameters hash into query string parameters" do
        should "parameterize hash operators and join elements with AND" do
          filters = FilterParameters.new({:city.eql => 'New York City', :state.eql => 'New York'})

          params = ['ga:city%3D%3DNew+York+City', 'ga:state%3D%3DNew+York']
          assert_equal params, filters.to_params['filters'].split('%3B').sort
        end

        should "properly encode operators" do
          filters = FilterParameters.new({:page_path.contains => 'New York'})

          params = {'filters' => 'ga:pagePath%3D~New+York'}
          assert_equal params, filters.to_params
        end

        should "escape comma, semicolon in values" do
          filters = FilterParameters.new({:url.eql => 'this;that,thing\other'})

          params = {'filters' => 'ga:url%3D%3Dthis%5C%3Bthat%5C%2Cthing%5Cother'}
          assert_equal params, filters.to_params
        end

        should "handle nested arrays mixed with hashes" do
          filters = FilterParameters.new([{:page_path.contains => 'NYC'}, [{:city.eql => 'New York City'}, {:state.eql => 'New York'}]])

          params = ['ga:pagePath%3D~NYC,ga:city%3D%3DNew+York+City,ga:state%3D%3DNew+York']
          assert_equal params, filters.to_params['filters'].split('%3B').sort
        end
      end
    end
  end
end
