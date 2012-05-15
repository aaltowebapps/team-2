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
		$.get('http://slidectrl.com/presentations/'+ Moco.id +'/status', function(data) {
				var diff = Moco.slide - data.currentSlide;
				if(diff != 0) { // transition is required
					if(Math.abs(diff) > 1) { // jump
						var selector = '#slide-'+data.currentSlide;
						$("#jmpress").jmpress('goTo', selector);
						Moco.slide = data.currentSlide;
					}
					else if(diff < 0) { // forward
						$("#jmpress").jmpress('next');
						Moco.slide++;
					}
					else if(diff > 0) { // backward
						$("#jmpress").jmpress('prev');
						Moco.slide--;
					}
				}
		});
	};
}
