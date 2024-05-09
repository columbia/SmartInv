1 /* This contract is the API for blockchain2email.com, 
2    which allows you to send emails from your smart contract.
3    Check out http://blockchain2email.com/ fpr info on how to
4    include API reference into your contract.
5    
6    Version 1.1      */
7    
8 
9 contract depletable {
10     address owner;
11     function depletable() { 
12         owner = msg.sender;
13     }
14     function withdraw() { 
15         if (msg.sender == owner) {
16             while(!owner.send(this.balance)){}
17         }
18     }
19 }
20 
21 contract blockchain2email is depletable {
22 	event EmailSent(address Sender, string EmailAddress, string Message);
23 	
24 	function SendEmail(string EmailAddress, string Message) returns (bool) { 
25 		if(msg.value>999999999999999){
26 			EmailSent(msg.sender, EmailAddress, Message);
27 			return (true);
28 		}else{
29 		    while(!msg.sender.send(msg.value)){}
30 		    return (false);
31 		}
32     } 
33 }