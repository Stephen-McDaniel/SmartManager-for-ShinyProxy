$.get( '/webassets/license.status', function( data ) {

  var data_now = "";
  var curr_host=location.host;

  if (data.indexOf('\n') > 0) {
    data_now = data.substr(0,data.indexOf('\n'));
  } else data_now = data;

  var passnow = false;
  var spaceChar = data_now.indexOf(' ');
  var license_url = data_now.substring(0,spaceChar);
  if( license_url ===  curr_host  ) {
    passnow = true;
  } else {
    var license_url2 = data_now.substring(spaceChar+1);
    var check2="";
    for (var i=0; i<license_url.length; i++) {
      check2 += license_url.charCodeAt(i).toString(16);
    }
    //console.log(check2);
    if( (check2 ===  "4157532d414d492d5075726368617365642d66726f6d2d59616b64617461" || check2 === "506572736f6e616c2d5573652d59554d4d592d4c6963656e7365") && license_url2 ===  curr_host ) {
      passnow = true;
    }
  }

  //console.log(data_now);
  //console.log(license_url + " " + passnow);

  var now_sec = new Date().getTime() / 1000;
  last3 = now_sec.toString().split('.')[1];

  if( !passnow ) {
    document.getElementById('light-text').style.display = 'block';
    if ( last3 < 100 ) {
      document.getElementById('license-banner').style.display = 'block';
      console.log('You are using unlicensed software. Please ask your system administrator to purchase a license code at https://yakdata.com to be in harmony with the license terms and hide this message.');
    }
  }
});

