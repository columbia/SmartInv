1 contract Emailer {
2     /* Define variable owner of the type address*/
3     address owner;
4 	event Sent(address from, uint256 price, string to, string body);
5 	
6     function Emailer() { 
7         owner = msg.sender; 
8     }
9     function kill() { 
10 		suicide(owner); 
11     }
12 	function withdraw(uint256 _amount){
13 		owner.send(_amount);
14 	}
15     function SendEmail(string _Recipient, string _Message) { 
16         Sent(msg.sender, msg.value, _Recipient, _Message);
17     }    
18 }