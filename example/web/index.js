
 /// Entry point of the web platform code for our logic
 window.invokeJSFunction = async (method, param) => {
    if (method == 'start') {
        callDart('processing');
        validateIDForResult(param);
    } else {
        console.log('Method not implemented');
    }
 }

 async function validateIDForResult(id) {
    //let's mock a delay of 3 seconds on platform side
    await new Promise(resolve => setTimeout(resolve, 3000)); 

    if (id != null && id === "WEB") {
        callDart('success');
    } else {
        callDart('error');
    }
 }
  
 /// Function that will be called from the platform side
 function callDart(event) {
    window.callJSHandler(event)
 }

 /// We can test JS Promises to Date Futures conversion here
 async function additionalWebLogic() {
    return new Promise((resolve, reject) => {
        if (Math.round(Math.random()) == 1) {
            return resolve('Web additional result: one');
        } else {
            return resolve('Web additional result: zero');
            // won't pollute the console with errors
        }
    });
 }