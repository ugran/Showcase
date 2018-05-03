$(document).on 'turbolinks:load', -> # use page:change if your on turbolinks < 5
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
          if !$('#btc-loading').hasClass('inactive')
            $('#btc-loading').addClass('inactive')
            $('#btc-loaded').slideDown()
  if document.getElementById("showuser")?
    App.slushpool = App.cable.subscriptions.create { channel: "SlushpoolChannel", user: parseInt(document.getElementsByClassName("showuser").id)},
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
          if !$('#btc-loading').hasClass('inactive')
            $('#btc-loading').addClass('inactive')
            $('#btc-loaded').slideDown()