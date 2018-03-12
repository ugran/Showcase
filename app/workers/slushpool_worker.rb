class SlushpoolWorker
  include Sidekiq::Worker

  def perform(group_id)
    slush_api = Group.find(group_id).slushpool_api_key
    btc = JSON.parse(URI.parse('https://slushpool.com/accounts/profile/json/'+slush_api).read, :symbolize_names => true)
    total_hashrate = (btc[:hashrate].to_f/1000000).round(2)
    confirmed_reward = btc[:confirmed_reward].to_f.round(6)
    unconfirmed_reward = btc[:unconfirmed_reward].to_f.round(6)
    estimated_reward = btc[:estimated_reward].to_f.round(6)
    btc_workers = btc[:workers]
    Slushpoolstat.find_or_create_by(group_id: group_id).update(total_hashrate: total_hashrate, confirmed_reward: confirmed_reward, unconfirmed_reward: unconfirmed_reward, estimated_reward: estimated_reward, hashrate_distribution: btc_workers.to_json)
    SlushpoolWorker.perform_in(15.seconds, group_id)
  end
end
