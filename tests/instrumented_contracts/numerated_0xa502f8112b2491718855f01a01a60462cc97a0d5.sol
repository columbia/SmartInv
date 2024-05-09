1 contract UfoPonzi {
2 
3     struct Participant {
4         address etherAddress;
5         uint amount;
6     }
7 
8     Participant[] public participants;
9 
10     uint public payoutIdx = 0;
11     uint public collectedFees;
12     uint public balance = 0;
13 
14     address public owner;
15 
16     // simple single-sig function modifier
17     modifier onlyowner { if (msg.sender == owner) _ }
18 
19     // this function is executed at initialization and sets the owner of the contract
20     function UfoPonzi() {
21         owner = msg.sender;
22         balance += msg.value;
23     }
24 
25     // fallback function - simple transactions trigger this
26     function() {
27         enter();
28     }
29     
30     function enter() {
31         if (msg.value < 1 ether) {
32             msg.sender.send(msg.value);
33             return;
34         }
35 
36         // add a new participant to array
37         uint idx = participants.length;
38         participants.length += 1;
39         participants[idx].etherAddress = msg.sender;
40         participants[idx].amount = msg.value;
41         
42         // collect fees and update contract balance
43         if (idx != 0) {
44             collectedFees += msg.value / 10;
45             balance += msg.value;
46         } 
47         else {
48             // first participant has no one above him,
49             // so it goes all to fees
50             collectedFees += msg.value;
51         }
52 
53   // if there are enough ether on the balance we can pay out to an earlier participant
54         if (balance > participants[payoutIdx].amount / 10 + participants[payoutIdx].amount) {
55             uint transactionAmount = (participants[payoutIdx].amount - participants[payoutIdx].amount / 10) / 10 + (participants[payoutIdx].amount - participants[payoutIdx].amount / 10);
56             participants[payoutIdx].etherAddress.send(transactionAmount);
57 
58             balance -= participants[payoutIdx].amount / 10 + participants[payoutIdx].amount;
59             payoutIdx += 1;
60         }
61     }
62 
63     function collectFees() onlyowner {
64         if (collectedFees == 0) return;
65 
66         owner.send(collectedFees);
67         collectedFees = 0;
68     }
69 
70     function setOwner(address _owner) onlyowner {
71         owner = _owner;
72     }
73 }