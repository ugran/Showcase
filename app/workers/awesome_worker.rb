class AwesomeWorker
  require 'uri'
  require 'net/http'
  require 'net/https'
  require 'json'
  include Sidekiq::Worker

  def perform(*args)
    begin
      awesome = URI.parse('http://109.172.247.148:17790/api/miners?key=19a23495fd3e42c4b62e6bca34a90bb1').read
      awesome_miners = []
      JSON.parse(awesome, symbolize_names: true)[:groupList].each do |t|
        t[:minerList].each do |a|
          awesome_miners.push(a)
        end
      end
      arranged = []
      awesome_miners.each do |t|
        hash = {}
        hash[:name] = t[:name]
        hash[:temp] = t[:temperature]
        hash[:hashrate] = t[:speedInfo][:hashrate]
        hash[:accepted] = t[:progressInfo][:line1]
        hash[:rejected] = t[:progressInfo][:line2]
        hash[:hw_errors] = t[:progressInfo][:line3]
        hash[:mining_time] = t[:statusInfo][:statusLine3]
        hash[:avg_hashrate] = t[:speedInfo][:avgHashrate]
        hash[:miner_id] = t[:id]
        arranged.push(hash)
      end
      arranged.each do |t|
        miner = Miner.find_by(worker_name: t[:name].gsub(' ',''))
        if miner.present?
          if miner.accuhash.present?
            accuhash = miner.accuhash+t[:hashrate].to_f
          else
            accuhash = t[:hashrate].to_f
          end
          miner.update(worker_name: t[:name], temperature: t[:temp], hashrate: t[:hashrate], avg_hashrate: t[:avg_hashrate], accepted: t[:accepted], rejected: t[:rejected], hw_errors: t[:hw_errors], mining_time: t[:mining_time], miner_id: t[:miner_id], accuhash: accuhash)
        end
      end
      AwesomeWorker.perform_in(10.seconds)
    rescue
      logger.info 'Error happened in AwesomeMiner background job and the proccess restarted.'
      AwesomeWorker.perform_in(30.seconds)
    end
  end
  
end
