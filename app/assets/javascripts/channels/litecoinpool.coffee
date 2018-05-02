$(document).on 'turbolinks:load', -> # use page:change if your on turbolinks < 5
  if document.getElementById("ltc-dashboard")
    App.litecoinpool = App.cable.subscriptions.create "LitecoinpoolChannel",
      received: (data) ->
        $('#total-hashrate').html data.bcast.user_total_hashrate
        $('#total-rewards').html data.bcast.user_total_rewards
        $('#paid-rewards').html data.bcast.user_paid_rewards
        $('#unpaid-rewards').html data.bcast.user_unpaid_rewards
        $('#expected-rewards').html data.bcast.user_expected_rewards
        $('#past-rewards').html data.bcast.user_past_24_rewards
        $('#cur-ltc').html data.bcast.user_cur_ltc
        for key of data.bcast.hashrate_distribution
          $('#worker-hashrate-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].hash_rate
          $('#worker-hashrate-24-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].hash_rate_24h
          $('#valid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].valid_shares
          $('#stale-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].stale_shares
          $('#invalid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].invalid_shares
          $('#rewards-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].rewards
          $('#rewards-24-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].rewards_24h
          if !$('#ltc-loading').hasClass('inactive')
            $('#ltc-loading').addClass('inactive')
            $('#ltc-loaded').slideDown()
  else if document.getElementsByClassName("showuser")
    App.litecoinpool = App.cable.subscriptions.create { channel: "LitecoinpoolChannel", user: parseInt(document.getElementsByClassName("showuser").id)},
      received: (data) ->
        $('#total-hashrate').html data.bcast.user_total_hashrate
        $('#total-rewards').html data.bcast.user_total_rewards
        $('#paid-rewards').html data.bcast.user_paid_rewards
        $('#unpaid-rewards').html data.bcast.user_unpaid_rewards
        $('#expected-rewards').html data.bcast.user_expected_rewards
        $('#past-rewards').html data.bcast.user_past_24_rewards
        $('#cur-ltc').html data.bcast.user_cur_ltc
        for key of data.bcast.hashrate_distribution
          $('#worker-hashrate-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].hash_rate
          $('#worker-hashrate-24-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].hash_rate_24h
          $('#valid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].valid_shares
          $('#stale-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].stale_shares
          $('#invalid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].invalid_shares
          $('#rewards-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].rewards
          $('#rewards-24-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].rewards_24h
          if !$('#ltc-loading').hasClass('inactive')
            $('#ltc-loading').addClass('inactive')
            $('#ltc-loaded').slideDown()