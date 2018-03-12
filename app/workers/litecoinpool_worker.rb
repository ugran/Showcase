class LitecoinpoolWorker
  include Sidekiq::Worker

  def perform(group_id)
    ltc_api = Group.find(group_id).litecoinpool_api_key
    ltc = JSON.parse(URI.parse('https://www.litecoinpool.org/api?api_key='+ltc_api).read, :symbolize_names => true)
    total_hashrate = ltc[:user][:hash_rate]/1000
    total_rewards = ltc[:user][:total_rewards]
    paid_rewards = ltc[:user][:paid_rewards]
    unpaid_rewards = ltc[:user][:unpaid_rewards]
    expected_rewards = ltc[:user][:expected_24h_rewards]
    past_24h_rewards = ltc[:user][:past_24h_rewards]
    ltc_workers = ltc[:workers]
    Litecoinpoolstat.find_or_create_by(group_id: group_id).update(total_hashrate: total_hashrate, total_rewards: total_rewards, paid_rewards: paid_rewards, unpaid_rewards: unpaid_rewards, expected_rewards: expected_rewards, past_24_rewards: past_24h_rewards, hashrate_distribution: ltc_workers.to_json)
    LitecoinpoolWorker.perform_in(15.seconds, group_id)
  end

end
