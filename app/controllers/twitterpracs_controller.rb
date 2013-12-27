class TwitterpracsController < ApplicationController
	def new
		render "new"
	end


	def create 
		@tweet = Twitterprac.new(params[:tweet])
		@tweet.save
		redirect_to @tweet
		#render text: params[:tweet].inspect
	end


	def facets
		@par = params[:term]
		p @par
		if @par 
			p "oh you make it"
		else
			p "does'nt exists"

		end
		@sea = Twitterprac.search do 
			facet 'word', :global => true do
        		terms :tweet
      		end
			#facet('word') {}
		end

		
		@out = Twitterprac.search do
			query{string 'ruby'}#, fuzziness: 0.5} 
		end


		if @out
			p "outexists "
			@out.results.each do |f|
				#p f['tweet']
			end
			p @out
		else
			p "try hard "
		end		
	end
	#end

	def show
		@tweet = Twitterprac.find(params[:id])
		if @tweet
			p "tweet exit"
		else 
			p "not exits"
		end
		#@sea = Twitter.search(params)#all #search(:facet => { })

		@sea = Twitterprac.search do 
			facet 'word', :global => true do
        		terms :tweet
      		end
			#facet('word') {}
		end

		if @sea
			p "sae exists "
			p "#{@sea.facets['word']['terms'][0]['term']}"
			p "#{@sea.facets['word']['terms'][0]['count']}"
		else
			p "try hasd "
		end		
end
end