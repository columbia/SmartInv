1 contract bbb{
2     /* Define variable owner of the type address*/
3     address owner;
4 	event EmailSent(address Sender, uint256 PricePaid, string EmailAddress, string Message);
5 	
6     function bbb() { 
7         owner = msg.sender; 
8     }
9     function Kill() { 
10 		if(msg.sender==owner){
11 			suicide(owner); 
12 		}		
13     }
14 	function Withdraw(uint256 AmountToWithdraw){
15 		owner.send(AmountToWithdraw);
16 	}
17     function SendEmail(string EmailAddress, string Message) { 
18         EmailSent(msg.sender, msg.value, EmailAddress, Message);
19     }    
20 }