task :did do	    
  #indexing tweets
	Tire.index 'twitances' do
    delete

  	create :settings => {
      :index => {
        :analysis => {
          :analyzer => {
            :twitance_analyzer => {
              :type => 'snowball',
              :tokenizer => 'snowball',
              :language => 'English',
              :stopwords_path => '/stop.txt'
              #:stopwords => ['is', 'rt', 'you', 'to', 'the' , 't.co', 'me', 'http', 'https']
            }
          }
        }
      }
      },
      :mappings => {
        :twitance => {
          :properties => {    
            :handle   		  	=> { :type => 'string'},
            :followers			=> {:type 	=> 'integer'},
            :friends			=> {:type 	=> 'integer'},
            :name 				=> {:type 	=> 'string'},
            :profile_image_url	=> {:type 	=> 'string'},
            :description		=> {:type 	=> 'string', :analyzer => 'twitance_analyzer'},
            :verified 			=> {:type 	=> 'boolean'},
            :tweet  			=> { :type => 'string', :analyzer => 'twitance_analyzer'}
          }
        }
      }
  end
end