1 pragma solidity ^0.4.11;
2 // We have to specify what version of compiler this code will compile with
3 
4 contract PonziUnlimited {
5 
6   modifier onlyBy(address _account)
7     {
8         require(msg.sender == _account);
9         // Do not forget the "_;"! It will
10         // be replaced by the actual function
11         // body when the modifier is used.
12         _;
13     }
14 
15   event GainsCalculated(
16     address receiver,
17     uint payedAmount,
18     uint gains,
19     uint contractBalance,
20     uint currentPayoutIndex
21   );
22 
23   event FeesCalculated(
24     uint gains,
25     uint fees
26   );
27 
28   event Payout(
29     address receiver,
30     uint value
31   );
32 
33   event FeesPayout(
34     uint value
35   );
36 
37   event FundsDeposited(
38     address depositor,
39     uint amount
40   );
41 
42   event ComputedGainsRate(
43     address depositor,
44     uint gainsRate
45   );
46 
47   struct Deposit {
48     address depositor;
49     uint amount;
50   }
51 
52   struct PayoutItem {
53     address receiver;
54     uint amount;
55   }
56 
57   address public master;
58   uint public feesRate;
59   uint public numDeposits;
60   uint public totalDeposited;
61   uint public totalGains;
62   uint public lastDeposit;
63   uint public profitsRatePercent;
64   uint public referedRateBonus;
65   uint public refereesRateBonus;
66   bool public active;
67   uint private currentPayoutIndex;
68 
69   mapping (uint => Deposit) public depositsStack;
70 
71   mapping (address => uint) public refereesCount;
72   mapping (address => uint) public pendingReferals;
73   mapping (address => uint) public addressGains;
74   mapping (address => uint[]) public addressPositions;
75   mapping (address => address) public refereeInvitations;
76   mapping (address => bool) public refereds;
77 
78   PayoutItem[] public lastPayouts;
79 
80   function PonziUnlimited() {
81     master = msg.sender;
82     feesRate = 10;
83     numDeposits = 0;
84     currentPayoutIndex = 0;
85     profitsRatePercent = 15;
86     referedRateBonus = 5;
87     refereesRateBonus = 5;
88     totalDeposited = 0;
89     totalGains = 0;
90     active = false;
91   }
92 
93   function getPayout(uint index) constant returns (address receiver, uint amount) {
94     PayoutItem memory payout;
95     payout = lastPayouts[index];
96     return (payout.receiver, payout.amount);
97   }
98 
99   function getLastPayouts() constant returns (address[10] lastReceivers, uint[10] lastAmounts) {
100     uint j = 0;
101     PayoutItem memory currentPayout;
102     uint length = lastPayouts.length;
103     uint startIndex = 0;
104 
105     if (length > 10) {
106       startIndex = length - 10;
107     }
108 
109     for(uint i = startIndex; i < length; i++) {
110       currentPayout = lastPayouts[i];
111       lastReceivers[j] = currentPayout.receiver;
112       lastAmounts[j] = currentPayout.amount;
113       j++;
114     }
115 
116     return (lastReceivers, lastAmounts);
117   }
118 
119   function getMaster() constant returns (address masterAddress) {
120     return master;
121   }
122 
123   function getnumDeposits() constant returns (uint) {
124     return numDeposits;
125   }
126 
127   function getContractMetrics() constant returns (uint, uint, uint, uint, bool) {
128     return (
129       this.balance,
130       totalDeposited,
131       totalGains,
132       numDeposits,
133       active
134     );
135   }
136 
137   function setActive(bool activate) onlyBy(master) returns (bool) {
138     active = activate;
139 
140     if (active) {
141       dispatchGains();
142     }
143     return active;
144   }
145 
146   function inviteReferee(address referer, address referee) returns (bool success) {
147     success = true;
148 
149     refereeInvitations[referee] = referer;
150     pendingReferals[referer] += 1;
151     return success;
152   }
153 
154   function createReferee(address referer, address referee) private {
155     refereds[referee] = true;
156     refereesCount[referer] += 1;
157     pendingReferals[referer] -= 1;
158   }
159 
160   function checkIfReferee(address referee) private {
161     address referer = refereeInvitations[referee];
162     if(referer != address(0)) {
163       createReferee(referer, referee);
164       delete refereeInvitations[referee];
165     }
166   }
167 
168   function getAddressGains(address addr) constant returns(uint) {
169     return addressGains[addr];
170   }
171 
172   function getCurrentPayoutIndex() constant returns(uint) {
173     return currentPayoutIndex;
174   }
175 
176   function getEarliestPosition(address addr) constant returns(uint[]) {
177     return  addressPositions[addr];
178   }
179 
180   function deposit() payable {
181     if(msg.value <= 0) throw;
182     lastDeposit = block.timestamp;
183     depositsStack[numDeposits] = Deposit(msg.sender, msg.value);
184     totalDeposited += msg.value;
185 
186     checkIfReferee(msg.sender);
187     FundsDeposited(msg.sender, msg.value);
188     ++numDeposits;
189 
190     addressPositions[msg.sender].push(numDeposits);
191 
192     if(active) {
193       dispatchGains();
194     }
195   }
196 
197   function resetBonuses(address depositor) private {
198     resetReferee(depositor);
199     resetReferedCount(depositor);
200   }
201 
202   function setGainsRate(uint gainsRate) onlyBy(master) {
203     profitsRatePercent = gainsRate;
204   }
205 
206   function resetReferee(address depositor) private {
207     refereds[depositor] = false;
208   }
209 
210   function resetReferedCount(address depositor) private {
211     refereesCount[depositor] = 0;
212   }
213 
214   function getAccountReferalsStats(address addr) constant returns(uint, uint) {
215 
216     return (
217       getPendingReferals(addr),
218       getReferedCount(addr)
219     );
220   }
221 
222   function computeGainsRate(address depositor) constant returns(uint gainsPercentage) {
223     gainsPercentage = profitsRatePercent;
224     if(isReferee(depositor)) {
225       gainsPercentage += referedRateBonus;
226     }
227 
228     gainsPercentage += getReferedCount(depositor) * refereesRateBonus;
229 
230     ComputedGainsRate(depositor, gainsPercentage);
231     return gainsPercentage;
232   }
233 
234  function computeGains(Deposit deposit) private constant returns (uint gains, uint fees) {
235     gains = 0;
236 
237     if(deposit.amount > 0) {
238       gains = (deposit.amount * computeGainsRate(deposit.depositor)) / 100;
239       fees = (gains * feesRate) / 100;
240 
241       GainsCalculated(deposit.depositor, deposit.amount, gains, this.balance, currentPayoutIndex);
242       FeesCalculated(gains, fees);
243     }
244 
245     return (
246       gains - fees,
247       fees
248     );
249   }
250 
251   function isReferee(address referee) private constant returns (bool) {
252     return refereds[referee];
253   }
254 
255   function getReferedCount(address referer) private constant returns (uint referedsCount) {
256     referedsCount = refereesCount[referer];
257     return referedsCount;
258   }
259 
260   function getPendingReferals(address addr) private constant returns (uint) {
261     return  pendingReferals[addr];
262   }
263 
264   function addNewPayout(PayoutItem payout) private {
265     lastPayouts.length++;
266     lastPayouts[lastPayouts.length-1] = payout;
267   }
268 
269   function payout(Deposit deposit) private{
270 
271     var (gains, fees) = computeGains(deposit);
272     bool success = false;
273     bool feesSuccess = false;
274     uint payableAmount = deposit.amount + gains;
275     address currentDepositor = deposit.depositor;
276 
277     if(gains > 0 && this.balance > payableAmount) {
278       success = currentDepositor.send( payableAmount );
279       if (success) {
280         Payout(currentDepositor, payableAmount);
281         addNewPayout(PayoutItem(currentDepositor, payableAmount));
282         feesSuccess = master.send(fees);
283         if(feesSuccess) {
284           FeesPayout(fees);
285         }
286         resetBonuses(currentDepositor);
287         addressGains[currentDepositor] += gains;
288         totalGains += gains;
289         currentPayoutIndex ++;
290       }
291     }
292   }
293 
294   function dispatchGains() {
295 
296     for (uint i = currentPayoutIndex; i<numDeposits; i++){
297       payout(depositsStack[i]);
298     }
299   }
300 
301   function() payable {
302     deposit();
303   }
304 }