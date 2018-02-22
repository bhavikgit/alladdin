class DummyController < ApplicationController

	def success_method(text)
		{
			"sound_file_to_play" => 'success_file.mp3',
			"status" => "success",
			"results" => [
				{
					"url" => 'http://www.housing.com',
					"count" => 20,
					"anchor_text" => 'Housing'
				},
				{
					"url" => 'http://www.makaan.com',
					"count" => 30,
					"anchor_text" => 'Makaan'
				},
				{
					"url" => 'http://www.proptiger.com',
					"count" => 40,
					"anchor_text" => 'Proptiger'
				}
			]
		}	
	end

	def fail_method(text)
		{
			"status" => "missing_fields",
			"results" => [],
			"sound_file_to_play" => 'fail_file.mp3'
		}
	end

	def fetch_results
		if params['results'] == 'true'
			res = success_method(params['text'])
		else
			res = fail_method(params['text'])
		end

		render json: res
	end
end