module SocketLabs
    module InjectionApi
        class RetrySettings

            private
            attr_accessor :default_number_of_retries
            attr_accessor :maximum_allowed_number_of_retries
            attr_accessor :minimum_retry_time
            attr_accessor :maximum_retry_time

            public
            attr_accessor :maximum_number_of_retries

            def initialize(maximum_retries=nil)

                @default_number_of_retries = 0
                @maximum_allowed_number_of_retries = 5
                @minimum_retry_time = 1
                @maximum_retry_time = 10

                unless maximum_retries.nil?
                    
                    if maximum_retries < 0
                        raise ArgumentError.new "maximum_number_of_retries must be greater than 0"
                    end
                    
                    if maximum_retries > @maximum_allowed_number_of_retries
                        raise ArgumentError.new "The maximum number of allowed retries is " + @maximum_allowed_number_of_retries
                    end

                    @maximum_number_of_retries = maximum_retries

                else
                    @maximum_number_of_retries = @default_number_of_retries
                end

            end

            def get_next_wait_interval(number_of_attempts)

                interval = [@minimum_retry_time * 1000 + get_retry_delta(number_of_attempts), @maximum_retry_time * 1000].min
                interval
                
            end

            def get_retry_delta(number_of_attempts)
                
                random = Random.new

                min = (1 * 1000 * 0.8).to_i
                max = (1 * 1000 * 1.2).to_i

                ((Math.pow(2.0, number_of_attempts) - 1.0) * random.rand(min..max)).to_i

            end

        end
    end
end