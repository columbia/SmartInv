1 contract SmartVerifying{
2     function SmartVerifying(){
3 
4     }
5 
6     function() payable
7     {
8         if(msg.sender.send(msg.value)==false) throw;
9     }
10 }