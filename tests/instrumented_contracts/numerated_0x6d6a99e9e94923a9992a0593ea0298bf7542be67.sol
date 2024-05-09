1 pragma solidity ^0.4.24;
2 
3 contract dapBetting {
4     
5     /* Types */
6     
7     enum eventStatus{ open, finished, closed }
8     
9     struct bid{
10         uint id;
11         bytes32 name;
12         address[] whoBet;
13         uint amountReceived;
14     }
15     
16     struct betEvent{
17         uint id;
18         bytes32 name;
19         address creator;
20         address arbitrator;
21         bytes32 winner;
22         uint arbitratorFee;
23         uint256 endBlock;
24         uint256 minBid;
25         uint256 maxBid;
26         bid[] bids;
27         bet[] bets;
28         eventStatus status;
29     }
30     
31     struct bet{
32         address person;
33         bytes32 bidName;
34         uint amount;
35     }
36     
37     /* Storage */
38     
39     mapping (address => betEvent[]) public betEvents;
40     mapping (address => uint) public pendingWithdrawals;
41     
42     /* Events */
43     
44     event eventCreated(uint id, address creator);
45     event betMade(uint value, uint id);
46     event eventStatusChanged(uint status);
47     event withdrawalDone(uint amount);
48     
49     /* Modifiers */
50     modifier onlyFinished(address creator, uint eventId){
51         if (betEvents[creator][eventId].status == eventStatus.finished || betEvents[creator][eventId].endBlock < block.number){
52             _;
53         }
54     }
55     modifier onlyArbitrator(address creator, uint eventId){
56         if (betEvents[creator][eventId].arbitrator == msg.sender){
57             _;
58         }
59     }
60     /* Methods */
61     
62     function createEvent(bytes32 name, bytes32[] names, address arbitrator, uint fee, uint256 endBlock, uint256 minBid, uint256 maxBid) external{
63         
64         require(fee < 100);
65         /* check whether event with such name already exist */
66         bool found;
67         for (uint8 x = 0;x<betEvents[msg.sender].length;x++){
68             if(betEvents[msg.sender][x].name == name){
69                 found = true;
70             }
71         }
72         require(!found);
73         
74         /* check names for duplicates */
75         for (uint8 y=0;i<names.length;i++){
76             require(names[y] != names[y+1]);
77         }
78         
79         uint newId = betEvents[msg.sender].length++;
80         betEvents[msg.sender][newId].id = newId;
81         betEvents[msg.sender][newId].name = name;
82         betEvents[msg.sender][newId].arbitrator = arbitrator;
83         betEvents[msg.sender][newId].status = eventStatus.open;
84         betEvents[msg.sender][newId].creator = msg.sender;
85         betEvents[msg.sender][newId].endBlock = endBlock;
86         betEvents[msg.sender][newId].minBid = minBid;
87         betEvents[msg.sender][newId].maxBid = maxBid;
88         betEvents[msg.sender][newId].arbitratorFee = fee;
89         
90         for (uint8 i = 0;i < names.length; i++){
91             uint newBidId = betEvents[msg.sender][newId].bids.length++;
92             betEvents[msg.sender][newId].bids[newBidId].name = names[i];
93             betEvents[msg.sender][newId].bids[newBidId].id = newBidId;
94         }
95         
96         emit eventCreated(newId, msg.sender);
97     }
98     
99     function makeBet(address creator, uint eventId, bytes32 bidName) payable external{
100         require(betEvents[creator][eventId].status == eventStatus.open);
101         if (betEvents[creator][eventId].endBlock > 0){
102         	require(block.number > betEvents[creator][eventId].endBlock);
103         }
104         /* check whether bid with given name actually exists */
105         bool found;
106         for (uint8 i=0;i<betEvents[creator][eventId].bids.length;i++){
107             if (betEvents[creator][eventId].bids[i].name == bidName){
108                 bid storage foundBid = betEvents[creator][eventId].bids[i];
109                 found = true;
110             }
111         }
112         require(found);
113         //check for block
114         if (betEvents[creator][eventId].endBlock > 0){
115         	require(betEvents[creator][eventId].endBlock < block.number);
116         }
117         //check for minimal amount
118         if (betEvents[creator][eventId].minBid > 0){
119         	require(msg.value > betEvents[creator][eventId].minBid);
120         }
121         //check for maximal amount
122         if (betEvents[creator][eventId].maxBid > 0){
123         	require(msg.value < betEvents[creator][eventId].maxBid);
124         }
125         foundBid.whoBet.push(msg.sender);
126         foundBid.amountReceived += msg.value;
127         uint newBetId = betEvents[creator][eventId].bets.length++;
128         betEvents[creator][eventId].bets[newBetId].person = msg.sender;
129         betEvents[creator][eventId].bets[newBetId].amount = msg.value;
130         betEvents[creator][eventId].bets[newBetId].bidName = bidName;
131         
132         emit betMade(msg.value, newBetId);
133     }
134     
135     function finishEvent(address creator, uint eventId) external{
136         require(betEvents[creator][eventId].status == eventStatus.open && betEvents[creator][eventId].endBlock == 0);
137         require(msg.sender == betEvents[creator][eventId].arbitrator);
138         betEvents[creator][eventId].status = eventStatus.finished;
139         emit eventStatusChanged(1);
140     }
141     
142     function determineWinner(address creator, uint eventId, bytes32 bidName) external onlyFinished(creator, eventId) onlyArbitrator(creator, eventId){
143         require (findBid(creator, eventId, bidName));
144         betEvent storage cEvent = betEvents[creator][eventId];
145         cEvent.winner = bidName;
146         uint amountLost;
147         uint amountWon;
148         uint lostBetsLen;
149         /*Calculating amount of all lost bets */
150         for (uint x=0;x<betEvents[creator][eventId].bids.length;x++){
151             if (cEvent.bids[x].name != cEvent.winner){
152                 amountLost += cEvent.bids[x].amountReceived;
153             }
154         }
155         
156         /* Calculating amount of all won bets */
157         for (x=0;x<cEvent.bets.length;x++){
158             if(cEvent.bets[x].bidName == cEvent.winner){
159                 uint wonBetAmount = cEvent.bets[x].amount;
160                 amountWon += wonBetAmount;
161                 pendingWithdrawals[cEvent.bets[x].person] += wonBetAmount;
162             } else {
163                 lostBetsLen++;
164             }
165         }
166         /* If we do have win bets */
167         if (amountWon > 0){
168             pendingWithdrawals[cEvent.arbitrator] += amountLost/100*cEvent.arbitratorFee;
169             amountLost = amountLost - (amountLost/100*cEvent.arbitratorFee);
170             for (x=0;x<cEvent.bets.length;x++){
171             if(cEvent.bets[x].bidName == cEvent.winner){
172                 //uint wonBetPercentage = cEvent.bets[x].amount*100/amountWon;
173                 uint wonBetPercentage = percent(cEvent.bets[x].amount, amountWon, 2);
174                 pendingWithdrawals[cEvent.bets[x].person] += (amountLost/100)*wonBetPercentage;
175             }
176         }
177         } else {
178             /* If we dont have any bets won, we pay all the funds back except arbitrator fee */
179             for(x=0;x<cEvent.bets.length;x++){
180                 pendingWithdrawals[cEvent.bets[x].person] += cEvent.bets[x].amount-((cEvent.bets[x].amount/100) * cEvent.arbitratorFee);
181                 pendingWithdrawals[cEvent.arbitrator] += (cEvent.bets[x].amount/100) * cEvent.arbitratorFee;
182             }
183         }
184         cEvent.status = eventStatus.closed;
185         emit eventStatusChanged(2);
186     }
187     
188     function withdraw(address person) private{
189         uint amount = pendingWithdrawals[person];
190         pendingWithdrawals[person] = 0;
191         person.transfer(amount);
192         emit withdrawalDone(amount);
193     }
194     
195     function requestWithdraw() external {
196         //require(pendingWithdrawals[msg.sender] != 0);
197         withdraw(msg.sender);
198     }
199     
200     function findBid(address creator, uint eventId, bytes32 bidName) private view returns(bool){
201         for (uint8 i=0;i<betEvents[creator][eventId].bids.length;i++){
202             if(betEvents[creator][eventId].bids[i].name == bidName){
203                 return true;
204             }
205         }
206     }
207     
208     function calc(uint one, uint two) private pure returns(uint){
209         return one/two;
210     }
211     function percent(uint numerator, uint denominator, uint precision) public 
212 
213     pure returns(uint quotient) {
214            // caution, check safe-to-multiply here
215           uint _numerator  = numerator * 10 ** (precision+1);
216           // with rounding of last digit
217           uint _quotient =  ((_numerator / denominator) + 5) / 10;
218           return ( _quotient);
219     }
220     /* Getters */
221     
222     function getBidsNum(address creator, uint eventId) external view returns (uint){
223         return betEvents[creator][eventId].bids.length;
224     }
225     
226     function getBid(address creator, uint eventId, uint bidId) external view returns (uint, bytes32, uint){
227         bid storage foundBid = betEvents[creator][eventId].bids[bidId];
228         return(foundBid.id, foundBid.name, foundBid.amountReceived);
229     }
230 
231     function getBetsNums(address creator, uint eventId) external view returns (uint){
232         return betEvents[creator][eventId].bets.length;
233     }
234 
235     function getWhoBet(address creator, uint eventId, uint bidId) external view returns (address[]){
236         return betEvents[creator][eventId].bids[bidId].whoBet;
237     }
238     
239     function getBet(address creator, uint eventId, uint betId) external view returns(address, bytes32, uint){
240         bet storage foundBet = betEvents[creator][eventId].bets[betId];
241         return (foundBet.person, foundBet.bidName, foundBet.amount);
242     }
243     
244     function getEventId(address creator, bytes32 eventName) external view returns (uint, bool){
245         for (uint i=0;i<betEvents[creator].length;i++){
246             if(betEvents[creator][i].name == eventName){
247                 return (betEvents[creator][i].id, true);
248             }
249         }
250     }
251 }