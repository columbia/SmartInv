1 pragma solidity ^0.4.18;
2 
3 contract Phoenix {
4     // If round last more than a year - cancel is activated
5     uint private MAX_ROUND_TIME = 365 days;
6     
7     uint private totalCollected;
8     uint private currentRound;
9     uint private currentRoundCollected;
10     uint private prevLimit;
11     uint private currentLimit;
12     uint private currentRoundStartTime;
13 
14     // That structure describes current user Account    
15     // moneyNew - invested money in currentRound
16     // moneyHidden - invested in previous round and not profit yet
17     // profitTotal - total profit of user account (it never decreases)
18     // profitTaken - profit taken by user
19     // lastUserUpdateRound - last round when account was updated
20     struct Account {
21         uint moneyNew;
22         uint moneyHidden;
23         uint profitTotal;
24         uint profitTaken;
25 
26         uint lastUserUpdateRound;
27     }
28     
29     mapping (address => Account) private accounts;
30 
31 
32     function Phoenix() public {
33         totalCollected = 0;
34         currentRound = 0;
35         currentRoundCollected = 0;
36         prevLimit = 0;
37         currentLimit = 100e18;
38         currentRoundStartTime = block.timestamp;
39     }
40     
41     // This function increments round to next:
42     // - it sets new currentLimit (round)using sequence:
43     //      100e18, 200e18, 4 * currentLImit - 2 * prevLimit
44     function iterateToNextRound() private {
45         currentRound++;
46         uint tempcurrentLimit = currentLimit;
47         
48         if(currentRound == 1) {
49             currentLimit = 200e18;
50         }
51         else {
52             currentLimit = 4 * currentLimit - 2 * prevLimit;
53         }
54         
55         prevLimit = tempcurrentLimit;
56         currentRoundStartTime = block.timestamp;
57         currentRoundCollected = 0;
58     }
59     
60     // That function calculates profit update for user
61     // - if increments from last calculated round to current round and 
62     //   calculates current user Account state
63     // - algorithm:
64     function calculateUpdateProfit(address user) private view returns (Account) {
65         Account memory acc = accounts[user];
66         
67         for(uint r = acc.lastUserUpdateRound; r < currentRound; r++) {
68             acc.profitTotal *= 2;
69 
70             if(acc.moneyHidden > 0) {
71                 acc.profitTotal += acc.moneyHidden * 2;
72                 acc.moneyHidden = 0;
73             }
74             
75             if(acc.moneyNew > 0) {
76                 acc.moneyHidden = acc.moneyNew;
77                 acc.moneyNew = 0;
78             }
79         }
80         
81         acc.lastUserUpdateRound = currentRound;
82         return acc;
83     }
84     
85     // Here we calculate profit and update it for user
86     function updateProfit(address user) private returns(Account) {
87         Account memory acc = calculateUpdateProfit(user);
88         accounts[user] = acc;
89         return acc;
90     }
91 
92     // That function returns canceled status.
93     // If round lasts for more than 1 year - cancel mode is on
94     function canceled() public view returns(bool isCanceled) {
95         return block.timestamp >= (currentRoundStartTime + MAX_ROUND_TIME);
96     }
97     
98     // Fallback function for handling money sending directly to contract
99     function () public payable {
100         require(!canceled());
101         deposit();
102     }
103 
104     // Function for calculating and updating state during user money investment
105     // - first of all we update current user state using updateProfit function
106     // - after that we handle situation of investment that makes 
107     //   currentRoundCollected more than current round limit. If that happen, 
108     //   we set moneyNew to totalMoney - moneyPartForCrossingRoundLimit.
109     // - check crossing round limit in cycle for case when money invested are 
110     //   more than several round limit
111     function deposit() public payable {
112         require(!canceled());
113         
114         updateProfit(msg.sender);
115 
116         uint money2add = msg.value;
117         totalCollected += msg.value;
118         while(currentRoundCollected + money2add >= currentLimit) {
119             accounts[msg.sender].moneyNew += currentLimit - 
120                 currentRoundCollected;
121             money2add -= currentLimit - currentRoundCollected;
122 
123             iterateToNextRound();
124             updateProfit(msg.sender);
125         }
126         
127         accounts[msg.sender].moneyNew += money2add;
128         currentRoundCollected += money2add;
129     }
130     
131     // Returns common information about round
132     // totalCollectedSum - total sum, collected in all rounds
133     // roundCollected - sum collected in current round
134     // currentRoundNumber - current round number
135     // remainsCurrentRound - how much remains for round change
136     function whatRound() public view returns (uint totalCollectedSum, 
137             uint roundCollected, uint currentRoundNumber, 
138             uint remainsCurrentRound) {
139         return (totalCollected, currentRoundCollected, currentRound, 
140             currentLimit - currentRoundCollected);
141     }
142 
143     // Returns current user account state
144     // profitTotal - how much profit is collected during all rounds
145     // profitTaken - how much profit was taken by user during all rounds
146     // profitAvailable (= profitTotal - profitTaken) - how much profit can be 
147     //    taken by user
148     // investmentInProgress - how much money are not profit yet and are invested
149     //    in current or previous round
150     function myAccount() public view returns (uint profitTotal, 
151             uint profitTaken, uint profitAvailable, uint investmentInProgress) {
152         var acc = calculateUpdateProfit(msg.sender);
153         return (acc.profitTotal, acc.profitTaken, 
154                 acc.profitTotal - acc.profitTaken, 
155                 acc.moneyNew + acc.moneyHidden);
156     }
157 
158     // That function handles cancel state. In that case:
159     // - transfer all invested money in current round
160     // - transfer all user profit except money taken
161     // - remainder of 100 ETH is left after returning all invested in current
162     //      round and all profit. Transfer it to users that invest money in 
163     //      previous round. Total investment in previous round = prevLimit.
164     //      So percent of money return = 100 ETH / prevLimit
165     function payback() private {
166         require(canceled());
167 
168         var acc = accounts[msg.sender];
169         uint hiddenpart = 0;
170         if(prevLimit > 0) {
171             hiddenpart = (acc.moneyHidden * 100e18) / prevLimit;
172         }
173         uint money2send = acc.moneyNew + acc.profitTotal - acc.profitTaken + 
174             hiddenpart;
175         if(money2send > this.balance) {
176             money2send = this.balance;
177         }
178         acc.moneyNew = 0;
179         acc.moneyHidden = 0;
180         acc.profitTaken = acc.profitTotal;
181 
182         msg.sender.transfer(money2send);
183     }
184 
185     // Function for taking all profit
186     // If round is canceled than do a payback (see above)
187     // Calculate money left on account = (profitTotal - profitTaken)
188     // Increase profitTaken by money left on account
189     // Transfer money to user
190     function takeProfit() public {
191         Account memory acc = updateProfit(msg.sender);
192 
193         if(canceled()) {
194             payback();
195             return;
196         }
197 
198         uint money2send = acc.profitTotal - acc.profitTaken;
199         acc.profitTaken += money2send;
200         accounts[msg.sender] = acc;
201 
202         if(money2send > 0) {
203             msg.sender.transfer(money2send);
204         }
205     }
206 }