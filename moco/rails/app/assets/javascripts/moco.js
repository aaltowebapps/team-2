var Moco = new function() {
    this.id = -1;
    this.slide = 0; 

    this.init = function(id, poll) {
	this.id = id;
	setInterval(Moco.update, poll);
    };

    this.dispose = function() {
	window.clearInterval(this.interval);
    };

    this.update = function() {
        //alert('updated: ' + Moco.id);
	$.get('http://localhost:3000/presentations/1/status', function(data) {
		if(data.currentSlide > Moco.slide) {
			$("#jmpress").jmpress('next');
			Moco.slide++;
		}	
	});
    };
}
