
function cityshow(){
  var timerId = setTimeout(function tick(){
      if(window.active){
        
        if(window.getting_data !== true){
          window.getting_data = true;
          
          qi('citiesshow').disabled = true;
          ws.send(enc(tuple( atom('client'), tuple(atom('sitiesshow') ) )));
        }
        
      }else{
        timerId = setTimeout(tick, 200);
      }
  }, 100);
}


function cityadd(){
  var timerId = setTimeout(function tick(){
      if(window.active){
        
        if(window.sending_data !== true){
          window.sending_data = true;
          
          qi('cityadd').disabled = true;
          ws.send(enc(tuple( atom('client'), tuple(atom('cityadd'), querySource('cityname'), number(qi('citypop').value) ) )));
        }
        
      }else{
        timerId = setTimeout(tick, 200);
      }
  }, 100);
}


window.addEventListener("load", function load1(e0){
  
  qi('citiesshow').addEventListener("click", function(e){
    cityshow();
  },false);
  
  qi('cityadd').addEventListener("click", function(e){
    cityadd();
  },false);
  
},false);

