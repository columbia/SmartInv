1 contract Government {
2 
3     // Global Variables
4     uint32 public lastCreditorPayedOut;
5     uint public lastTimeOfNewCredit;
6     uint public profitFromCrash;
7     address[] public creditorAddresses;
8     uint[] public creditorAmounts;
9     address public corruptElite;
10     mapping (address => uint) buddies;
11     uint constant TWELVE_HOURS = 43200;
12     uint8 public round;
13 
14     function Government() {
15         // The corrupt elite establishes a new government
16         // this is the commitment of the corrupt Elite - everything that can not be saved from a crash
17         profitFromCrash = msg.value;
18         corruptElite = msg.sender;
19         lastTimeOfNewCredit = block.timestamp;
20     }
21 
22     function lendGovernmentMoney(address buddy) returns (bool) {
23         uint amount = msg.value;
24         // check if the system already broke down. If for 12h no new creditor gives new credit to the system it will brake down.
25         // 12h are on average = 60*60*12/12.5 = 3456
26         if (lastTimeOfNewCredit + TWELVE_HOURS < block.timestamp) {
27             // Return money to sender
28             msg.sender.send(amount);
29             // Sends all contract money to the last creditor
30             creditorAddresses[creditorAddresses.length - 1].send(profitFromCrash);
31             corruptElite.send(this.balance);
32             // Reset contract state
33             lastCreditorPayedOut = 0;
34             lastTimeOfNewCredit = block.timestamp;
35             profitFromCrash = 0;
36             creditorAddresses = new address[](0);
37             creditorAmounts = new uint[](0);
38             round += 1;
39             return false;
40         }
41         else {
42             // the system needs to collect at least 1% of the profit from a crash to stay alive
43             if (amount >= 10 ** 18) {
44                 // the System has received fresh money, it will survive at leat 12h more
45                 lastTimeOfNewCredit = block.timestamp;
46                 // register the new creditor and his amount with 10% interest rate
47                 creditorAddresses.push(msg.sender);
48                 creditorAmounts.push(amount * 110 / 100);
49                 // now the money is distributed
50                 // first the corrupt elite grabs 5% - thieves!
51                 corruptElite.send(amount * 5/100);
52                 // 5% are going into the economy (they will increase the value for the person seeing the crash comming)
53                 if (profitFromCrash < 10000 * 10**18) {
54                     profitFromCrash += amount * 5/100;
55                 }
56                 // if you have a buddy in the government (and he is in the creditor list) he can get 5% of your credits.
57                 // Make a deal with him.
58                 if(buddies[buddy] >= amount) {
59                     buddy.send(amount * 5/100);
60                 }
61                 buddies[msg.sender] += amount * 110 / 100;
62                 // 90% of the money will be used to pay out old creditors
63                 if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - profitFromCrash) {
64                     creditorAddresses[lastCreditorPayedOut].send(creditorAmounts[lastCreditorPayedOut]);
65                     buddies[creditorAddresses[lastCreditorPayedOut]] -= creditorAmounts[lastCreditorPayedOut];
66                     lastCreditorPayedOut += 1;
67                 }
68                 return true;
69             }
70             else {
71                 msg.sender.send(amount);
72                 return false;
73             }
74         }
75     }
76 
77     // fallback function
78     function() {
79         lendGovernmentMoney(0);
80     }
81 
82     function totalDebt() returns (uint debt) {
83         for(uint i=lastCreditorPayedOut; i<creditorAmounts.length; i++){
84             debt += creditorAmounts[i];
85         }
86     }
87 
88     function totalPayedOut() returns (uint payout) {
89         for(uint i=0; i<lastCreditorPayedOut; i++){
90             payout += creditorAmounts[i];
91         }
92     }
93 
94     // better don't do it (unless you are the corrupt elite and you want to establish trust in the system)
95     function investInTheSystem() {
96         profitFromCrash += msg.value;
97     }
98 
99     // From time to time the corrupt elite inherits it's power to the next generation
100     function inheritToNextGeneration(address nextGeneration) {
101         if (msg.sender == corruptElite) {
102             corruptElite = nextGeneration;
103         }
104     }
105 
106     function getCreditorAddresses() returns (address[]) {
107         return creditorAddresses;
108     }
109 
110     function getCreditorAmounts() returns (uint[]) {
111         return creditorAmounts;
112     }
113 }