$ ->
  if document.getElementById("btc-dashboard")
    App.slushpool = App.cable.subscriptions.create "SlushpoolChannel",
      received: (data) ->
        console.log(data)
        $('#btc-total-hashrate').html data.bcast.user_total_hashrate
        $('#btc-confirmed-reward').html data.bcast.user_confirmed_reward
        $('#btc-unconfirmed-reward').html data.bcast.user_unconfirmed_reward
        $('#btc-estimated-reward').html data.bcast.user_estimated_reward
        $('#cur-btc').html data.bcast.user_cur_btc
        for key of data.bcast.hashrate_distribution
          $('#worker-hashrate-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].hashrate/1000000
          $('#worker-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].shares
        data.bcast.user_miners.forEach (element) ->
          $("#"+element["worker_name"].split('.').join("")+'-hashrate').html element["hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-avghashrate').html element["avg_hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-temperature').html element["temperature"]
        if !$('#btc-loading').hasClass('inactive')
          $('#btc-loading').addClass('inactive')
          $('#btc-loaded').slideDown()
  if document.getElementsByClassName("showuser")[0]?
    App.slushpool = App.cable.subscriptions.create { channel: "SlushpoolChannel", user: parseInt(document.getElementsByClassName("showuser")[0].id)},
      received: (data) ->
        console.log(data)
        $('#btc-total-hashrate').html data.bcast.user_total_hashrate
        $('#btc-confirmed-reward').html data.bcast.user_confirmed_reward
        $('#btc-unconfirmed-reward').html data.bcast.user_unconfirmed_reward
        $('#btc-estimated-reward').html data.bcast.user_estimated_reward
        $('#cur-btc').html data.bcast.user_cur_btc
        for key of data.bcast.hashrate_distribution
          $('#worker-shares-'+key.split('.').join("");).html data.bcast.hashrate_distribution[key].shares
        data.bcast.user_miners.forEach (element) ->
          $("#"+element["worker_name"].split('.').join("")+'-hashrate').html element["hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-avghashrate').html element["avg_hashrate"]
          $("#"+element["worker_name"].split('.').join("")+'-temperature').html element["temperature"]
        if !$('#btc-loading').hasClass('inactive')
          $('#btc-loading').addClass('inactive')
          $('#btc-loaded').slideDown()