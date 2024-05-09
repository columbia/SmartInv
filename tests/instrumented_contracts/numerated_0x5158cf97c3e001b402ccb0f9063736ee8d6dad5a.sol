1 contract Ai {
2 
3   struct Participant {
4       address etherAddress;
5       uint amount;
6   }
7 
8   Participant[] public participants;
9 
10   uint public payoutIdx = 0;
11   uint public collectedFees;
12   uint public balance = 0;
13 
14   address public owner;
15 
16   // simple single-sig function modifier
17   modifier onlyowner { if (msg.sender == owner) _ }
18 
19   // this function is executed at initialization and sets the owner of the contract
20   function Ai() {
21     owner = msg.sender;
22   }
23 
24   // fallback function - simple transactions trigger this
25   function() {
26     enter();
27   }
28   
29   function enter() {
30     if (msg.value < 10 finney) {
31         msg.sender.send(msg.value);
32         return;
33     }
34 
35     uint amount;
36     if (msg.value > 100 ether) {  
37       collectedFees += msg.value - 100 ether;
38       amount = 100 ether;
39     }
40     else {
41       amount = msg.value;
42     }
43 
44     // add a new participant to array
45     uint idx = participants.length;
46     participants.length += 1;
47     participants[idx].etherAddress = msg.sender;
48     participants[idx].amount = amount;
49 
50     // collect fees and update contract balance
51     if (idx != 0) {
52       collectedFees += amount / 15;
53       balance += amount - amount / 15;
54     } else {
55       //  first participant has no one above him,
56       //  so it goes all to fees
57       collectedFees += amount;
58     }
59 
60     // while there are enough ether on the balance we can pay out to an earlier participant
61     while (balance > participants[payoutIdx].amount * 2) {
62       uint transactionAmount = participants[payoutIdx].amount *2;
63       participants[payoutIdx].etherAddress.send(transactionAmount);
64 
65       balance -= transactionAmount;
66       payoutIdx += 1;
67     }
68   }
69 
70   function collectFees() onlyowner {
71       if (collectedFees == 0) return;
72       owner.send(collectedFees);
73       collectedFees = 0;
74   }
75 
76   function setOwner(address _owner) onlyowner {
77       owner = _owner;
78   }
79 }