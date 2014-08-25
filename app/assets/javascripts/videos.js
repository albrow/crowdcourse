// based off of https://developer.vimeo.com/player/js-api


function video_init() {

    //console.log("initializing the video!");

    var source = $(".video-iframe-container").attr("data-video-source");

    if (source == "vimeo") {

        // use the vimeo player API
        //console.log("vimeo video detected");

        var f = $('#video_iframe'),
        url = f.attr('src').split('?')[0];

        var hasStarted = false;
        var view_id = 0; // keep track of the current VideoView object

        // Listen for messages from the player
        if (window.addEventListener){
            window.addEventListener('message', onMessageReceived, false);
        }
        else {
            window.attachEvent('onmessage', onMessageReceived, false);
        }

        // Handle messages received from the player
        function onMessageReceived(e) {
            var data = JSON.parse(e.data);
            
            switch (data.event) {
                case 'ready':
                    onReady();
                    break;

                case 'play' :
                    onPlay();
                    break;
                   
                case 'playProgress':
                    onPlayProgress(data.data);
                    break;
                    
                case 'pause':
                    onPause();
                    break;
                   
                case 'finish':
                    onFinish();
                    break;
            }
        }



        // Helper function for sending a message to the player
        function post(action, value) {
            var data = { method: action };
            
            if (value) {
                data.value = value;
            }
            
            f[0].contentWindow.postMessage(JSON.stringify(data), url);
        }

        function onReady() {
            //status.text('ready');
            
            post('addEventListener', 'pause');
            post('addEventListener', 'finish');
            post('addEventListener', 'playProgress');
            post('addEventListener', 'play');
        }

        function onPause() {
            //status.text('paused');
            //alert("paused");
        }

        function onFinish() {
            //status.text('finished');
            //console.log("video is finished!");
            vid_id = $(".video-iframe-container").attr("data-video-id");
            $.post("/video_view_complete", { video_id: vid_id, view_id: view_id });
        }

        function onPlayProgress(data) {
            //status.text(data.seconds + 's played');
        }

        function onPlay() {
            if (!hasStarted) {
                console.log("started video!");
                vid_id = $(".video-iframe-container").attr("data-video-id");
                $.post("/video_view", { video_id: vid_id }, function(data) {
                    // the server responds with a view id
                    console.log(data);
                    view_id = data;
                });
            }
            hasStarted = true;
        }



    } else if (source == "youtube") {
        
        // use the youtube player API

        // currently this is inline js at views/videos/youtube_embed.html.erb
        // TODO: move it here!



    }

}