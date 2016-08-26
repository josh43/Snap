The Rest package is responsible for sending and receiving data from the server

Node.js
Server route ---> router.get("/login/:username/:password",function(req,res)
Get.m
+(void) login:(NSString *)username andPass:(NSString *)password
     withComp:(void (^)(BOOL,id)) onCompletion{
        // make a url request for example the request might be http://localhost:3000/login/Edward/McMillan
        // on success call completion(YES,response); // where response is the appropriate data
     }


HTTPHelper $(TLDR)-> Has a couple of methods to help parse the incoming data and check for errors