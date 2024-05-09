1 /**
2   MAX150-Smoothly growing and long living multiplier without WHALES!, which returns 150% of your Deposit!
3 
4   A small limit on the Deposit eliminates the problems with the WHALES, which is very much inhibited the previous version of the contract and significantly prolongs its life!
5 
6   Automatic payouts!
7   Full reports on the funds spent on advertising in the group!
8   No errors, holes, automated payments do NOT NEED administration!
9   Created and tested by professionals!
10   The code is fully documented in Russian, each line is clear!
11  
12   Website: http://MAX150.com/
13   The group in the telegram: https://t.me/MAX150
14 
15   1. Send any non-zero amount to the contract address
16      - amount from 0.01 to 2 ETH
17      - gas limit minimum 250,000
18      - you'll be in line.
19   2. Wait a little
20   3. ...
21   4. PROFIT! You received 150% of your Deposit.
22 
23   How is that possible?
24   1. The first investor in the queue (you will be the first very soon) receives payments from
25      new investors until they receive 150% of their Deposit
26   2. Payments can come in several parts or all at once
27   3. Once you receive 150% of your Deposit, you are removed from the queue
28   4. You can make multiple deposits at once
29   5. The balance of this contract shall usually be in area 0, because all of the proceeds
30      immediately sent to the payment
31 
32      Thus, the latter pay first, and investors who have reached 150% of the Deposit,
33      are removed from the queue, giving way to the rest
34 
35                 new investor --|               brand new investor --|
36                  investor5     |                 new investor       |
37                  investor4     |     =======>      investor5        |
38                  investor3     |                   investor4        |
39                  investor2    <|                   investor3        |
40                  investor1   <-|                   investor2   <----|  (pay until 150%)
41 
42 */
43 
44 contract MAX150 {
45     // E-wallet to pay for advertising
46     address constant private ADS_SUPPORT = 0x0625b84dBAf2288e7E85ADEa8c5670A3eDEAeEE9;
47 
48     // The address of the wallet to invest back into the project
49     address constant private TECH_SUPPORT = 0xA4bF3B49435F25531f36D219EC65f5eE77fd7a0a;
50 
51     // The percentage of Deposit is 5%
52     uint constant public ADS_PERCENT = 5;
53 
54     // Deposit percentage for investment in the project 2%
55     uint constant public TECH_PERCENT = 2;
56     
57     // Payout percentage for all participants
58     uint constant public MULTIPLIER = 150;
59 
60     // The maximum Deposit amount = 2 ether, so that everyone can participate and whales do not slow down and do not scare investors
61     uint constant public MAX_LIMIT = 2 ether;
62 
63     // The Deposit structure contains information about the Deposit
64     struct Deposit {
65         address depositor; // The owner of the Deposit
66         uint128 deposit;   // Deposit amount
67         uint128 expect;    // Payment amount (instantly 150% of the Deposit)
68     }
69 
70     // Turn
71     Deposit[] private queue;
72 
73     // The number of the Deposit to be processed can be found in the Read contract section
74     uint public currentReceiverIndex = 0;
75 
76     // This function receives all deposits, saves them and makes instant payments
77     function () public payable {
78         // If the Deposit amount is greater than zero
79         if(msg.value > 0){
80             // Check the minimum gas limit of 220 000, otherwise cancel the Deposit and return the money to the depositor
81             require(gasleft() >= 220000, "We require more gas!");
82 
83             // Check the maximum Deposit amount
84             require(msg.value <= MAX_LIMIT, "Deposit is too big");
85 
86             // Add a Deposit to the queue, write down that he needs to pay 150% of the Deposit amount
87             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * MULTIPLIER / 100)));
88 
89             // Send a percentage to promote the project
90             uint ads = msg.value * ADS_PERCENT / 100;
91             ADS_SUPPORT.transfer(ads);
92 
93             // We send a percentage for technical support of the project
94             uint tech = msg.value * TECH_PERCENT / 100;
95             TECH_SUPPORT.transfer(tech);
96 
97             // Call the payment function first in the queue Deposit
98             pay();
99         }
100     }
101 
102     // The function is used to pay first in line deposits
103     // Each new transaction processes 1 to 4+ depositors at the beginning of the queue 
104     // Depending on the remaining gas
105     function pay() private {
106         // We will try to send all the money available on the contract to the first depositors in the queue
107         uint128 money = uint128(address(this).balance);
108 
109         // We pass through the queue
110         for(uint i = 0; i < queue.length; i++) {
111 
112             uint idx = currentReceiverIndex + i;  // We get the number of the first Deposit in the queue
113 
114             Deposit storage dep = queue[idx]; // We get information about the first Deposit
115 
116             if(money >= dep.expect) {  // If we have enough money for the full payment, we pay him everything
117                 dep.depositor.transfer(dep.expect); // Send him money
118                 money -= dep.expect; // Update the amount of remaining money
119 
120                 // the Deposit has been fully paid, remove it
121                 delete queue[idx];
122             } else {
123                 // We get here if we do not have enough money to pay everything, but only part of it
124                 dep.depositor.transfer(money); // Send all remaining
125                 dep.expect -= money;       // Update the amount of remaining money
126                 break;                     // Exit the loop
127             }
128 
129             if (gasleft() <= 50000)         // Check if there is still gas, and if it is not, then exit the cycle
130                 break;                     //  The next depositor will make the payment next in line
131         }
132 
133         currentReceiverIndex += i; // Update the number of the first Deposit in the queue
134     }
135 
136     // Shows information about the Deposit by its number (idx), you can follow in the Read contract section
137     // You can get the Deposit number (idx) by calling the getDeposits function()
138     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
139         Deposit storage dep = queue[idx];
140         return (dep.depositor, dep.deposit, dep.expect);
141     }
142 
143     // Shows the number of deposits of a particular investor
144     function getDepositsCount(address depositor) public view returns (uint) {
145         uint c = 0;
146         for(uint i=currentReceiverIndex; i<queue.length; ++i){
147             if(queue[i].depositor == depositor)
148                 c++;
149         }
150         return c;
151     }
152 
153     // Shows all deposits (index, deposit, expect) of a certain investor, you can follow in the Read contract section
154     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
155         uint c = getDepositsCount(depositor);
156 
157         idxs = new uint[](c);
158         deposits = new uint128[](c);
159         expects = new uint128[](c);
160 
161         if(c > 0) {
162             uint j = 0;
163             for(uint i=currentReceiverIndex; i<queue.length; ++i){
164                 Deposit storage dep = queue[i];
165                 if(dep.depositor == depositor){
166                     idxs[j] = i;
167                     deposits[j] = dep.deposit;
168                     expects[j] = dep.expect;
169                     j++;
170                 }
171             }
172         }
173     }
174     
175     // Shows a length of the queue can be monitored in the Read section of the contract
176     function getQueueLength() public view returns (uint) {
177         return queue.length - currentReceiverIndex;
178     }
179 
180 }