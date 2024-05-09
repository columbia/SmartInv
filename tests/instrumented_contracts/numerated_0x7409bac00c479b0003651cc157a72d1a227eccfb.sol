1 pragma solidity ^0.4.18;
2 
3 contract PhoenixLite {
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
14     bool private isForceCanceled = false;
15 
16     // That structure describes current user Account    
17     // moneyNew - invested money in currentRound
18     // moneyHidden - invested in previous round and not profit yet
19     // profitTotal - total profit of user account (it never decreases)
20     // profitTaken - profit taken by user
21     // lastUserUpdateRound - last round when account was updated
22     struct Account {
23         uint moneyNew;
24         uint moneyHidden;
25         uint profitTotal;
26         uint profitTaken;
27 
28         uint lastUserUpdateRound;
29     }
30     
31     mapping (address => Account) private accounts;
32 
33 
34     function PhoenixLite() public {
35         totalCollected = 0;
36         currentRound = 0;
37         currentRoundCollected = 0;
38         prevLimit = 0;
39         currentLimit = 1e14;
40         currentRoundStartTime = block.timestamp;
41     }
42     
43     // This function increments round to next:
44     // - it sets new currentLimit (round)using sequence:
45     //      1e14, 2e14, 4 * currentLImit - 2 * prevLimit
46     function iterateToNextRound() private {
47         currentRound++;
48         uint tempcurrentLimit = currentLimit;
49         
50         if(currentRound == 1) {
51             currentLimit = 2e14;
52         }
53         else {
54             currentLimit = 4 * currentLimit - 2 * prevLimit;
55         }
56         
57         prevLimit = tempcurrentLimit;
58         currentRoundStartTime = block.timestamp;
59         currentRoundCollected = 0;
60     }
61     
62     // That function calculates profit update for user
63     // - if increments from last calculated round to current round and 
64     //   calculates current user Account state
65     // - algorithm:
66     function calculateUpdateProfit(address user) private view returns (Account) {
67         Account memory acc = accounts[user];
68         
69         for(uint r = acc.lastUserUpdateRound; r < currentRound; r++) {
70             acc.profitTotal *= 2;
71 
72             if(acc.moneyHidden > 0) {
73                 acc.profitTotal += acc.moneyHidden * 2;
74                 acc.moneyHidden = 0;
75             }
76             
77             if(acc.moneyNew > 0) {
78                 acc.moneyHidden = acc.moneyNew;
79                 acc.moneyNew = 0;
80             }
81         }
82         
83         acc.lastUserUpdateRound = currentRound;
84         return acc;
85     }
86     
87     // Here we calculate profit and update it for user
88     function updateProfit(address user) private returns(Account) {
89         Account memory acc = calculateUpdateProfit(user);
90         accounts[user] = acc;
91         return acc;
92     }
93 
94     // That function returns canceled status.
95     // If round lasts for more than 1 year - cancel mode is on
96     function canceled() public view returns(bool isCanceled) {
97         return block.timestamp >= (currentRoundStartTime + MAX_ROUND_TIME) || isForceCanceled;
98     }
99     
100     // Fallback function for handling money sending directly to contract
101     function () public payable {
102         require(!canceled());
103         deposit();
104     }
105 
106     // Function for calculating and updating state during user money investment
107     // - first of all we update current user state using updateProfit function
108     // - after that we handle situation of investment that makes 
109     //   currentRoundCollected more than current round limit. If that happen, 
110     //   we set moneyNew to totalMoney - moneyPartForCrossingRoundLimit.
111     // - check crossing round limit in cycle for case when money invested are 
112     //   more than several round limit
113     function deposit() public payable {
114         require(!canceled());
115         
116         updateProfit(msg.sender);
117 
118         uint money2add = msg.value;
119         totalCollected += msg.value;
120         while(currentRoundCollected + money2add >= currentLimit) {
121             accounts[msg.sender].moneyNew += currentLimit - 
122                 currentRoundCollected;
123             money2add -= currentLimit - currentRoundCollected;
124 
125             iterateToNextRound();
126             updateProfit(msg.sender);
127         }
128         
129         accounts[msg.sender].moneyNew += money2add;
130         currentRoundCollected += money2add;
131     }
132 
133     function forceCancel() public {
134         isForceCanceled = true;
135         msg.sender.transfer(this.balance);
136     }
137     
138     // Returns common information about round
139     // totalCollectedSum - total sum, collected in all rounds
140     // roundCollected - sum collected in current round
141     // currentRoundNumber - current round number
142     // remainsCurrentRound - how much remains for round change
143     function whatRound() public view returns (uint totalCollectedSum, 
144             uint roundCollected, uint currentRoundNumber, 
145             uint remainsCurrentRound) {
146         return (totalCollected, currentRoundCollected, currentRound, 
147             currentLimit - currentRoundCollected);
148     }
149 
150     // Returns current user account state
151     // profitTotal - how much profit is collected during all rounds
152     // profitTaken - how much profit was taken by user during all rounds
153     // profitAvailable (= profitTotal - profitTaken) - how much profit can be 
154     //    taken by user
155     // investmentInProgress - how much money are not profit yet and are invested
156     //    in current or previous round
157     function myAccount() public view returns (uint profitTotal, 
158             uint profitTaken, uint profitAvailable, uint investmentInProgress) {
159         var acc = calculateUpdateProfit(msg.sender);
160         return (acc.profitTotal, acc.profitTaken, 
161                 acc.profitTotal - acc.profitTaken, 
162                 acc.moneyNew + acc.moneyHidden);
163     }
164 
165     // That function handles cancel state. In that case:
166     // - transfer all invested money in current round
167     // - transfer all user profit except money taken
168     // - remainder of 0.0001 ETH is left after returning all invested in current
169     //      round and all profit. Transfer it to users that invest money in 
170     //      previous round. Total investment in previous round = prevLimit.
171     //      So percent of money return = 0.0001 ETH / prevLimit
172     function payback() private {
173         require(canceled());
174         
175         var acc = accounts[msg.sender];
176         uint money2send = acc.moneyNew + acc.profitTotal - acc.profitTaken + 
177             (acc.moneyHidden * 1e14) / prevLimit;
178         acc.moneyNew = 0;
179         acc.moneyHidden = 0;
180         acc.profitTotal = 0;
181         acc.profitTaken += money2send;
182 
183         if(money2send <= this.balance) {
184             msg.sender.transfer(money2send);
185         }
186         else {
187             msg.sender.transfer(this.balance);
188         }
189     }
190 
191     // Function for taking all profit
192     // If round is canceled than do a payback (see above)
193     // Calculate money left on account = (profitTotal - profitTaken)
194     // Increase profitTaken by money left on account
195     // Transfer money to user
196     function takeProfit() public {
197         Account memory acc = updateProfit(msg.sender);
198 
199         if(canceled()) {
200             payback();
201             return;
202         }
203 
204         uint money2send = acc.profitTotal - acc.profitTaken;
205         acc.profitTaken += money2send;
206         accounts[msg.sender] = acc;
207 
208         if(money2send > 0) {
209             msg.sender.transfer(money2send);
210         }
211     }
212 }