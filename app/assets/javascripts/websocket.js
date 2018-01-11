$(document).ready(function(){
  const socket = io('wss://streamer.cryptocompare.com');
  tmp = 0;
  tmp_2 = 0;
  tmp_3 = 0;
  tmp_4 = 0;

  socket.emit('SubAdd', { subs: ['5~CCCAGG~BTC~USD','5~CCCAGG~ETH~USD','5~CCCAGG~XRP~USD','5~CCCAGG~LTC~USD'] } );

  socket.on("m", function(message) {
    fields = message.split('~');
    if (fields[2] == 'BTC') {
      if (tmp == 0) {
        $('#btc_usd').html(fields[5]);
        tmp += 1;
        chart_btc.data.datasets.forEach((dataset_btc) => {
          if (tmp > 50) {
            dataset_btc.data.splice(0, 1);
            dataset_btc.data.push(fields[5]);
          } else {
            dataset_btc.data.push(fields[5]);
          }
        });
        last_btc_price = fields[5];
      } else if ( fields[4] != 4) {
        $('#btc_usd').html(fields[5]);
        tmp += 1;
        chart_btc.data.datasets.forEach((dataset_btc) => {
          if (tmp > 50) {
            dataset_btc.data.splice(0, 1);
            dataset_btc.data.push(fields[5]);
          } else {
            dataset_btc.data.push(fields[5]);
          }
        });
        last_btc_price = fields[5];
        if (fields[4] == 1) {

        } else if (fields[4] == 2) {

        }
      } else {
        if (typeof last_btc_price !== 'undefined') {
          tmp += 1;
          chart_btc.data.datasets.forEach((dataset_btc) => {
            if (tmp > 50) {
              dataset_btc.data.splice(0, 1);
              dataset_btc.data.push(last_btc_price);
            } else {
              dataset_btc.data.push(last_btc_price);
            }
          });
        }
      }
      chart_btc.update();
    } else if (fields[2] == 'ETH') {
      if (tmp_2 == 0) {
        $('#eth_usd').html(fields[5]);
        tmp_2 += 1;
        chart_eth.data.datasets.forEach((dataset_eth) => {
          if (tmp_2 > 50) {
            dataset_eth.data.splice(0, 1);
            dataset_eth.data.push(fields[5]);
          } else {
            dataset_eth.data.push(fields[5]);
          }
        });
        last_eth_price = fields[5];
      } else if ( fields[4] != 4) {
        $('#eth_usd').html(fields[5]);
        tmp_2 += 1;
        chart_eth.data.datasets.forEach((dataset_eth) => {
          if (tmp_2 > 50) {
            dataset_eth.data.splice(0, 1);
            dataset_eth.data.push(fields[5]);
          } else {
            dataset_eth.data.push(fields[5]);
          }
        });
        last_eth_price = fields[5];
        if (fields[4] == 1) {

        } else if (fields[4] == 2) {

        }
      } else {
        if (typeof last_eth_price !== 'undefined') {
          tmp_2 += 1;
          chart_eth.data.datasets.forEach((dataset_eth) => {
            if (tmp_2 > 50) {
              dataset_eth.data.splice(0, 1);
              dataset_eth.data.push(last_eth_price);
            } else {
              dataset_eth.data.push(last_eth_price);
            }
          });
        }
      }
      chart_eth.update();
    } else if ( fields[2] == 'XRP') {
      if (tmp_3 == 0) {
        $('#xrp_usd').html(fields[5]);
        tmp_3 += 1;
        chart_xrp.data.datasets.forEach((dataset_xrp) => {
          if (tmp_3 > 50) {
            dataset_xrp.data.splice(0, 1);
            dataset_xrp.data.push(fields[5]);
          } else {
            dataset_xrp.data.push(fields[5]);
          }
        });
        last_xrp_price = fields[5];
      } else if ( fields[4] != 4) {
        $('#xrp_usd').html(fields[5]);
        tmp_3 += 1;
        chart_xrp.data.datasets.forEach((dataset_xrp) => {
          if (tmp_3 > 50) {
            dataset_xrp.data.splice(0, 1);
            dataset_xrp.data.push(fields[5]);
          } else {
            dataset_xrp.data.push(fields[5]);
          }
        });
        last_xrp_price = fields[5];
        if (fields[4] == 1) {

        } else if (fields[4] == 2) {

        }
      } else {
        if (typeof last_xrp_price !== 'undefined') {
          tmp_3 += 1;
          chart_xrp.data.datasets.forEach((dataset_xrp) => {
            if (tmp_3 > 50) {
              dataset_xrp.data.splice(0, 1);
              dataset_xrp.data.push(last_xrp_price);
            } else {
              dataset_xrp.data.push(last_xrp_price);
            }
          });
        }
      }
      chart_xrp.update();
    } else if (fields[2] == 'LTC') {
      if (tmp_4 == 0) {
        $('#ltc_usd').html(fields[5]);
        tmp_4 += 1;
        chart_ltc.data.datasets.forEach((dataset_ltc) => {
          if (tmp_4 > 50) {
            dataset_ltc.data.splice(0, 1);
            dataset_ltc.data.push(fields[5]);
          } else {
            dataset_ltc.data.push(fields[5]);
          }
        });
        last_ltc_price = fields[5];
      } else if ( fields[4] != 4) {
        $('#ltc_usd').html(fields[5]);
        tmp_4 += 1;
        chart_ltc.data.datasets.forEach((dataset_ltc) => {
          if (tmp_4 > 50) {
            dataset_ltc.data.splice(0, 1);
            dataset_ltc.data.push(fields[5]);
          } else {
            dataset_ltc.data.push(fields[5]);
          }
        });
        last_ltc_price = fields[5];
        if (fields[4] == 1) {

        } else if (fields[4] == 2) {

        }
      } else {
        if (typeof last_ltc_price !== 'undefined') {
          tmp_4 += 1;
          chart_ltc.data.datasets.forEach((dataset_ltc) => {
            if (tmp_4 > 50) {
              dataset_ltc.data.splice(0, 1);
              dataset_ltc.data.push(last_ltc_price);
            } else {
              dataset_ltc.data.push(last_ltc_price);
            }
          });
        }
      }
      chart_ltc.update();
    }
  });
});