1 pragma solidity ^0.4.21;
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
23         bid[] bids;
24         bet[] bets;
25         eventStatus status;
26     }
27     
28     struct bet{
29         address person;
30         bytes32 bidName;
31         uint amount;
32     }
33     
34     /* Storage */
35     
36     mapping (address => betEvent[]) public betEvents;
37     mapping (address => uint) public pendingWithdrawals;
38     
39     /* Events */
40     
41     event EventCreated(uint id, address creator);
42     event betMade(uint value, uint id);
43     event eventStatusChanged(uint status);
44     event withdrawalDone(uint amount);
45     
46     /* Modifiers */
47     modifier onlyFinished(address creator, uint eventId){
48         if (betEvents[creator][eventId].status == eventStatus.finished){
49             _;
50         }
51     }
52     modifier onlyArbitrator(address creator, uint eventId){
53         if (betEvents[creator][eventId].arbitrator == msg.sender){
54             _;
55         }
56     }
57     /* Methods */
58     
59     function createEvent(bytes32 name, bytes32[] names, address arbitrator, uint fee) external{
60         
61         require(fee < 100);
62         /* check whether event with such name already exist */
63         bool found;
64         for (uint8 x = 0;x<betEvents[msg.sender].length;x++){
65             if(betEvents[msg.sender][x].name == name){
66                 found = true;
67             }
68         }
69         require(!found);
70         
71         /* check names for duplicates */
72         for (uint8 y=0;i<names.length;i++){
73             require(names[y] != names[y+1]);
74         }
75         
76         uint newId = betEvents[msg.sender].length++;
77         betEvents[msg.sender][newId].id = newId;
78         betEvents[msg.sender][newId].name = name;
79         betEvents[msg.sender][newId].arbitrator = arbitrator;
80         betEvents[msg.sender][newId].status = eventStatus.open;
81         betEvents[msg.sender][newId].creator = msg.sender;
82         betEvents[msg.sender][newId].arbitratorFee = fee;
83         
84         for (uint8 i = 0;i < names.length; i++){
85             uint newBidId = betEvents[msg.sender][newId].bids.length++;
86             betEvents[msg.sender][newId].bids[newBidId].name = names[i];
87             betEvents[msg.sender][newId].bids[newBidId].id = newBidId;
88         }
89         
90         emit EventCreated(newId, msg.sender);
91     }
92     
93     function makeBet(address creator, uint eventId, bytes32 bidName) payable external{
94         require(betEvents[creator][eventId].status == eventStatus.open);
95         /* check whether bid with given name actually exists */
96         bool found;
97         for (uint8 i=0;i<betEvents[creator][eventId].bids.length;i++){
98             if (betEvents[creator][eventId].bids[i].name == bidName){
99                 bid storage foundBid = betEvents[creator][eventId].bids[i];
100                 found = true;
101             }
102         }
103         require(found);
104         foundBid.whoBet.push(msg.sender);
105         foundBid.amountReceived += msg.value;
106         uint newBetId = betEvents[creator][eventId].bets.length++;
107         betEvents[creator][eventId].bets[newBetId].person = msg.sender;
108         betEvents[creator][eventId].bets[newBetId].amount = msg.value;
109         betEvents[creator][eventId].bets[newBetId].bidName = bidName;
110         
111         emit betMade(msg.value, newBetId);
112     }
113     
114     function finishEvent(address creator, uint eventId) external{
115         require(betEvents[creator][eventId].status == eventStatus.open);
116         require(msg.sender == betEvents[creator][eventId].arbitrator);
117         betEvents[creator][eventId].status = eventStatus.finished;
118         emit eventStatusChanged(1);
119     }
120     
121     function determineWinner(address creator, uint eventId, bytes32 bidName) external onlyFinished(creator, eventId) onlyArbitrator(creator, eventId){
122         require (findBid(creator, eventId, bidName));
123         betEvent storage cEvent = betEvents[creator][eventId];
124         cEvent.winner = bidName;
125         uint amountLost;
126         uint amountWon;
127         uint lostBetsLen;
128         /*Calculating amount of all lost bets */
129         for (uint x=0;x<betEvents[creator][eventId].bids.length;x++){
130             if (cEvent.bids[x].name != cEvent.winner){
131                 amountLost += cEvent.bids[x].amountReceived;
132             }
133         }
134         
135         /* Calculating amount of all won bets */
136         for (x=0;x<cEvent.bets.length;x++){
137             if(cEvent.bets[x].bidName == cEvent.winner){
138                 uint wonBetAmount = cEvent.bets[x].amount;
139                 amountWon += wonBetAmount;
140                 pendingWithdrawals[cEvent.bets[x].person] += wonBetAmount;
141             } else {
142                 lostBetsLen++;
143             }
144         }
145         /* If we do have win bets */
146         if (amountWon > 0){
147             pendingWithdrawals[cEvent.arbitrator] += amountLost/100*cEvent.arbitratorFee;
148             amountLost = amountLost - (amountLost/100*cEvent.arbitratorFee);
149             for (x=0;x<cEvent.bets.length;x++){
150             if(cEvent.bets[x].bidName == cEvent.winner){
151                 //uint wonBetPercentage = cEvent.bets[x].amount*100/amountWon;
152                 uint wonBetPercentage = percent(cEvent.bets[x].amount, amountWon, 2);
153                 pendingWithdrawals[cEvent.bets[x].person] += (amountLost/100)*wonBetPercentage;
154             }
155         }
156         } else {
157             /* If we dont have any bets won, we pay all the funds back except arbitrator fee */
158             for(x=0;x<cEvent.bets.length;x++){
159                 pendingWithdrawals[cEvent.bets[x].person] += cEvent.bets[x].amount-((cEvent.bets[x].amount/100) * cEvent.arbitratorFee);
160                 pendingWithdrawals[cEvent.arbitrator] += (cEvent.bets[x].amount/100) * cEvent.arbitratorFee;
161             }
162         }
163         cEvent.status = eventStatus.closed;
164         emit eventStatusChanged(2);
165     }
166     
167     function withdraw(address person) private{
168         uint amount = pendingWithdrawals[person];
169         pendingWithdrawals[person] = 0;
170         person.transfer(amount);
171         emit withdrawalDone(amount);
172     }
173     
174     function requestWithdraw() external {
175         //require(pendingWithdrawals[msg.sender] != 0);
176         withdraw(msg.sender);
177     }
178     
179     function findBid(address creator, uint eventId, bytes32 bidName) private view returns(bool){
180         for (uint8 i=0;i<betEvents[creator][eventId].bids.length;i++){
181             if(betEvents[creator][eventId].bids[i].name == bidName){
182                 return true;
183             }
184         }
185     }
186     
187     function calc(uint one, uint two) private pure returns(uint){
188         return one/two;
189     }
190     function percent(uint numerator, uint denominator, uint precision) public 
191 
192     pure returns(uint quotient) {
193            // caution, check safe-to-multiply here
194           uint _numerator  = numerator * 10 ** (precision+1);
195           // with rounding of last digit
196           uint _quotient =  ((_numerator / denominator) + 5) / 10;
197           return ( _quotient);
198     }
199     /* Getters */
200     
201     function getBidsNum(address creator, uint eventId) external view returns (uint){
202         return betEvents[creator][eventId].bids.length;
203     }
204     
205     function getBid(address creator, uint eventId, uint bidId) external view returns (uint, bytes32, uint){
206         bid storage foundBid = betEvents[creator][eventId].bids[bidId];
207         return(foundBid.id, foundBid.name, foundBid.amountReceived);
208     }
209 
210     function getBetsNums(address creator, uint eventId) external view returns (uint){
211         return betEvents[creator][eventId].bets.length;
212     }
213 
214     function getWhoBet(address creator, uint eventId, uint bidId) external view returns (address[]){
215         return betEvents[creator][eventId].bids[bidId].whoBet;
216     }
217     
218     function getBet(address creator, uint eventId, uint betId) external view returns(address, bytes32, uint){
219         bet storage foundBet = betEvents[creator][eventId].bets[betId];
220         return (foundBet.person, foundBet.bidName, foundBet.amount);
221     }
222     
223     function getEventId(address creator, bytes32 eventName) external view returns (uint, bool){
224         for (uint i=0;i<betEvents[creator].length;i++){
225             if(betEvents[creator][i].name == eventName){
226                 return (betEvents[creator][i].id, true);
227             }
228         }
229     }
230 }