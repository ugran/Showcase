$(document).on 'turbolinks:load', -> # use page:change if your on turbolinks < 5
  if document.getElementById("price-charts") 
    App.price_chart = App.cable.subscriptions.create "PriceChartChannel",
      received: (data) ->
        tmp = 0
        tmp_2 = 0
        tmp_3 = 0
        tmp_4 = 0
        if data.btc_price
          $('#btc_usd').html data.btc_price
          tmp += 1
          chart_btc.data.datasets.forEach (dataset_btc) ->
            dataset_btc.data.splice 0, 1
            dataset_btc.data.push data.btc_price
            return
          chart_btc.update()
        if data.eth_price
          $('#eth_usd').html data.eth_price
          tmp_2 += 1
          chart_eth.data.datasets.forEach (dataset_eth) ->
            dataset_eth.data.splice 0, 1
            dataset_eth.data.push data.eth_price
            return
          chart_eth.update()
        if data.xrp_price
          $('#xrp_usd').html data.xrp_price
          tmp_3 += 1
          chart_xrp.data.datasets.forEach (dataset_xrp) ->
            dataset_xrp.data.splice 0, 1
            dataset_xrp.data.push data.xrp_price
            return
          chart_xrp.update()
        if data.ltc_price
          $('#ltc_usd').html data.ltc_price
          tmp_4 += 1
          chart_ltc.data.datasets.forEach (dataset_ltc) ->
            dataset_ltc.data.splice 0, 1
            dataset_ltc.data.push data.ltc_price
            return
          chart_ltc.update()