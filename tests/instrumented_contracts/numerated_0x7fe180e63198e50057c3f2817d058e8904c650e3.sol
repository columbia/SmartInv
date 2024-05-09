1 pragma solidity ^0.4.6;
2 
3 contract Conference {  // can be killed, so the owner gets sent the money in the end
4 
5 	address public organizer;
6 	mapping (address => uint) public registrantsPaid;
7 	uint public numRegistrants;
8 	uint public quota;
9 
10 	event Deposit(address _from, uint _amount); // so you can log the event
11 	event Refund(address _to, uint _amount); // so you can log the event
12 
13 	function Conference() {
14 		organizer = msg.sender;		
15 		quota = 100;
16 		numRegistrants = 0;
17 	}
18 
19 	function buyTicket() public {
20 		if (numRegistrants >= quota) { 
21 			throw; // throw ensures funds will be returned
22 		}
23 		registrantsPaid[msg.sender] = msg.value;
24 		numRegistrants++;
25 		Deposit(msg.sender, msg.value);
26 	}
27 
28 	function changeQuota(uint newquota) public {
29 		if (msg.sender != organizer) { return; }
30 		quota = newquota;
31 	}
32 
33 	function refundTicket(address recipient, uint amount) public {
34 		if (msg.sender != organizer) { return; }
35 		if (registrantsPaid[recipient] == amount) { 
36 			address myAddress = this;
37 			if (myAddress.balance >= amount) { 
38 				(recipient.send(amount));
39 				Refund(recipient, amount);
40 				registrantsPaid[recipient] = 0;
41 				numRegistrants--;
42 			}
43 		}
44 		return;
45 	}
46 
47 	function destroy() {
48 		if (msg.sender == organizer) { // without this funds could be locked in the contract forever!
49 			suicide(organizer);
50 		}
51 	}
52 }