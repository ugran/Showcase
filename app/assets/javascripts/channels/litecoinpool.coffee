$ ->
  if document.getElementById("ltc-dashboard")
    App.litecoinpool = App.cable.subscriptions.create "LitecoinpoolChannel",
      received: (data) ->
        $('#total-hashrate').html data.bcast.user_total_ltc_hashrate
        $('#total-rewards').html data.bcast.user_total_rewards
        $('#paid-rewards').html data.bcast.user_paid_rewards
        $('#unpaid-rewards').html data.bcast.user_unpaid_rewards
        $('#expected-rewards').html data.bcast.user_expected_rewards
        $('#past-rewards').html data.bcast.user_past_24_rewards
        $('#cur-ltc').html data.bcast.user_cur_ltc
        for key of data.bcast.hashrate_distribution
          $('#valid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].valid_shares
          $('#stale-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].stale_shares
          $('#invalid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].invalid_shares
        data.bcast.user_miners.forEach (element) ->
          $("#"+element["worker_name"].split('.').join("")+'-hashrate').html element["hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-avghashrate').html element["avg_hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-temperature').html element["temperature"]
        if !$('#ltc-loading').hasClass('inactive')
          $('#ltc-loading').addClass('inactive')
          $('#ltc-loaded').slideDown()
  if document.getElementsByClassName("showuser")[0]?
    App.litecoinpool = App.cable.subscriptions.create { channel: "LitecoinpoolChannel", user: parseInt(document.getElementsByClassName("showuser")[0].id)},
      received: (data) ->
        $('#total-hashrate').html data.bcast.user_total_ltc_hashrate
        $('#total-rewards').html data.bcast.user_total_rewards
        $('#paid-rewards').html data.bcast.user_paid_rewards
        $('#unpaid-rewards').html data.bcast.user_unpaid_rewards
        $('#expected-rewards').html data.bcast.user_expected_rewards
        $('#past-rewards').html data.bcast.user_past_24_rewards
        $('#cur-ltc').html data.bcast.user_cur_ltc
        for key of data.bcast.hashrate_distribution
          $('#valid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].valid_shares
          $('#stale-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].stale_shares
          $('#invalid-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].invalid_shares
        data.bcast.user_miners.forEach (element) ->
          $("#"+element["worker_name"].split('.').join("")+'-hashrate').html element["hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-avghashrate').html element["avg_hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-temperature').html element["temperature"]
        if !$('#ltc-loading').hasClass('inactive')
          $('#ltc-loading').addClass('inactive')
          $('#ltc-loaded').slideDown()