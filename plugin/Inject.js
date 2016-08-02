
window.sendToPlugin = function(data){
    var request = new XMLHttpRequest();
    request.open('POST', 'http://localhost:23330/pluginCall', true);
    request.setRequestHeader('Content-Type', 'application/json');
    request.send(JSON.stringify(data));
}

function replacePlayer(){
    document.getElementById('player').innerHTML = '<div class="player-placeholder" onclick="window.sendToPlugin({action:\'tucao-callVideoProvider\',data: TYPCN_PLAYER_VID})" style="background-color:black; background-image: url(&quot;http://localhost:23330/blur/' + window._bd_share_config.common.bdPic + '&quot;); background-attachment: initial; width: 100%; height: 400px;"></div>';
}

window.BM_TIMER = setInterval(function(){
    if(window.bctnloaded || !document.getElementById('part_lists')){
        clearInterval(window.BM_TIMER);
        return;
    }
    window.TYPCN_PLAYER_VID = location.href + '|' + document.getElementById('player_code').childNodes[0].textContent.split('|')[0];
           
    replacePlayer();

    $('#part_lists a').on('click', function(e){
        var target = e.target;
        while(!target.getAttribute('pid')){
            target = target.parentNode;
        }
        setTimeout(function(){
            var newpid = target.getAttribute('pid');
            window.TYPCN_PLAYER_VID = location.href + '|' + newpid;
            replacePlayer();
        },200);
    });

    window.bctnloaded = true;
},500);