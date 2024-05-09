1 pragma solidity ^0.4.2;
2 
3 /*
4 *  @notice the token contract used as reward 
5 */
6 contract token {
7 
8     /*
9     *  @notice exposes the transfer method of the token contract
10     *  @param _receiver address receiving tokens
11     *  @param _amount number of tokens being transferred       
12     */    
13     function transfer(address _receiver, uint _amount) returns (bool success) { }
14 
15     /*
16     *  @notice exposes the priviledgedAddressBurnUnsoldCoins method of the token contract
17     *  burns all unsold coins  
18     */     
19     function priviledgedAddressBurnUnsoldCoins(){ }
20 
21 }
22 
23 /*
24 `* is owned
25 */
26 contract owned {
27 
28     address public owner;
29 
30     function owned() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         if (msg.sender != owner) throw;
36         _;
37     }
38 
39     function ownerTransferOwnership(address newOwner)
40         onlyOwner
41     {
42         owner = newOwner;
43     }
44 
45 }
46 
47 /*
48 * safe math
49 */
50 contract DSSafeAddSub {
51 
52     function safeToAdd(uint a, uint b) internal returns (bool) {
53         return (a + b >= a);
54     }
55 
56     function safeAdd(uint a, uint b) internal returns (uint) {
57         if (!safeToAdd(a, b)) throw;
58         return a + b;
59     }
60 
61     function safeToSubtract(uint a, uint b) internal returns (bool) {
62         return (b <= a);
63     }
64 
65     function safeSub(uint a, uint b) internal returns (uint) {
66         if (!safeToSubtract(a, b)) throw;
67         return a - b;
68     } 
69 
70 }
71 
72 /* 
73 *  EtherollCrowdfund contract
74 *  Funds sent to this address transfer a customized ERC20 token to msg.sender for the duration of the crowdfund
75 *  Deployment order:
76 *  EtherollToken, EtherollCrowdfund
77 *  1) Send tokens to this
78 *  2) Assign this as priviledgedAddress in EtherollToken
79 *  3) Call updateTokenStatus in EtherollToken 
80 *  -- crowdfund is open --
81 *  4) safeWithdraw onlyAfterDeadline in this
82 *  5) ownerBurnUnsoldTokens onlyAfterDeadline in this
83 *  6) updateTokenStatus in EtherollToken freezes/thaws tokens
84 */
85 contract EtherollCrowdfund is owned, DSSafeAddSub {
86 
87     /*
88     *  checks only after crowdfund deadline
89     */    
90     modifier onlyAfterDeadline() { 
91         if (now < deadline) throw;
92         _; 
93     }
94 
95     /*
96     *  checks only in emergency
97     */    
98     modifier isEmergency() { 
99         if (!emergency) throw;
100         _; 
101     } 
102 
103     /* the crowdfund goal */
104     uint public fundingGoal;
105     /* 1 week countdown to price increase */
106     uint public weekTwoPriceRiseBegin = now + 10080 * 1 minutes;    
107     /* 80% to standard multi-sig wallet contract is house bankroll  */
108     address public bankRollBeneficiary;      
109     /* 20% to etheroll wallet*/
110     address public etherollBeneficiary;         
111     /* total amount of ether raised */
112     uint public amountRaised;
113     /* two weeks */
114     uint public deadline;
115     /* 0.01 ETH per token base price */
116     uint public price = 10000000000000000;
117     /* address of token used as reward */
118     token public tokenReward;
119     /* crowdsale is open */
120     bool public crowdsaleClosed = false;  
121     /* 80% of funds raised */
122     uint public bankrollBeneficiaryAmount;
123     /* 20% of funds raised */    
124     uint public etherollBeneficiaryAmount;
125     /* map balance of address */
126     mapping (address => uint) public balanceOf; 
127     /* funding goal has not been reached */ 
128     bool public fundingGoalReached = false;   
129     /* escape hatch for all in emergency */
130     bool public emergency = false; 
131 
132     /* log events */
133     event LogFundTransfer(address indexed Backer, uint indexed Amount, bool indexed IsContribution);  
134     event LogGoalReached(address indexed Beneficiary, uint indexed AmountRaised);       
135 
136     /*
137     *  @param _ifSuccessfulSendToBeneficiary receives 80% of ether raised end of crowdfund
138     *  @param _ifSuccessfulSendToEtheroll receives 20% of ether raised end of crowdfund
139     *  @param _fundingGoalInEthers the funding goal of the crowdfund
140     *  @param _durationInMinutes the length of the crowdfund in minutes
141     *  @param _addressOfTokenUsedAsReward the token address   
142     */  
143     function EtherollCrowdfund(
144         /* multi-sig address to send 80% */        
145         address _ifSuccessfulSendToBeneficiary,
146         /* address to send 20% */
147         address _ifSuccessfulSendToEtheroll,
148         /* funding goal */
149         uint _fundingGoalInEthers,
150         /* two weeks: 20160 minutes*/
151         uint _durationInMinutes,
152         /* token */
153         token _addressOfTokenUsedAsReward
154     ) {
155         bankRollBeneficiary = _ifSuccessfulSendToBeneficiary;
156         etherollBeneficiary = _ifSuccessfulSendToEtheroll;
157         fundingGoal = _fundingGoalInEthers * 1 ether;
158         deadline = now + _durationInMinutes * 1 minutes;
159         tokenReward = token(_addressOfTokenUsedAsReward);
160     }
161   
162     /*
163     *  @notice public function
164     *  default function is payable
165     *  responsible for transfer of tokens based on price, msg.sender and msg.value
166     *  tracks investment total of msg.sender 
167     *  refunds any spare change
168     */      
169     function ()
170         payable
171     {
172 
173         /* crowdfund period is over */
174         if(now > deadline) crowdsaleClosed = true;  
175 
176         /* crowdsale is closed */
177         if (crowdsaleClosed) throw;
178 
179         /* do not allow creating 0 */        
180         if (msg.value == 0) throw;      
181 
182         /* 
183         *  transfer tokens
184         *  check/set week two price rise
185         */
186         if(now < weekTwoPriceRiseBegin) {
187                       
188             /* week 1 power token conversion * 2: 1 ETH = 200 tokens */
189             if(tokenReward.transfer(msg.sender, ((msg.value*price)/price)*2)) {
190                 LogFundTransfer(msg.sender, msg.value, true); 
191             } else {
192                 throw;
193             }
194 
195         }else{
196             /* week 2 conversion: 1 ETH = 100 tokens */
197             if(tokenReward.transfer(msg.sender, (msg.value*price)/price)) {
198                 LogFundTransfer(msg.sender, msg.value, true); 
199             } else {
200                 throw;
201             }            
202 
203         } 
204 
205         /* add to amountRaised */
206         amountRaised = safeAdd(amountRaised, msg.value);          
207 
208         /* track ETH balanceOf address in case emergency refund is required */  
209         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], msg.value);
210 
211     }    
212 
213     /*
214     *  @notice public function
215     *  onlyAfterDeadline
216     *  moves ether to beneficiary contracts if goal reached
217     *  if goal not reached msg.sender can withdraw their deposit
218     */     
219     function safeWithdraw() public
220         onlyAfterDeadline
221     {
222 
223         if (amountRaised >= fundingGoal){
224             /* allows funds to be moved to beneficiary */
225             fundingGoalReached = true;
226             /* log event */            
227             LogGoalReached(bankRollBeneficiary, amountRaised);           
228         }    
229             
230         /* close crowdsale */
231         crowdsaleClosed = true;  
232                         
233         /* 
234         *  public 
235         *  funding goal not reached 
236         *  manual refunds
237         */
238         if (!fundingGoalReached) {
239             calcRefund(msg.sender);
240         }
241         
242         /* 
243         *  onlyOwner can call
244         *  funding goal reached 
245         *  move funds to beneficiary addresses
246         */        
247         if (msg.sender == owner && fundingGoalReached) {
248 
249             /* multi-sig bankrollBeneficiary receives 80% */
250             bankrollBeneficiaryAmount = (this.balance*80)/100;   
251 
252             /* send to trusted address bankRollBeneficiary 80% */      
253             if (bankRollBeneficiary.send(bankrollBeneficiaryAmount)) {  
254 
255                 /* log event */              
256                 LogFundTransfer(bankRollBeneficiary, bankrollBeneficiaryAmount, false);
257             
258                 /* etherollBeneficiary receives remainder */
259                 etherollBeneficiaryAmount = this.balance;                  
260 
261                 /* send to trusted address etherollBeneficiary the remainder */
262                 if(!etherollBeneficiary.send(etherollBeneficiaryAmount)) throw;
263 
264                 /* log event */        
265                 LogFundTransfer(etherollBeneficiary, etherollBeneficiaryAmount, false);                 
266 
267             } else {
268 
269                 /* allow manual refunds via safeWithdrawal */
270                 fundingGoalReached = false;
271 
272             }
273         }
274     }  
275 
276     /*
277     *  @notice internal function
278     *  @param _addressToRefund the address being refunded
279     *  accessed via public functions emergencyWithdraw and safeWithdraw
280     *  calculates refund amount available for an address  
281     */     
282     function calcRefund(address _addressToRefund) internal
283     {
284         /* assigns var amount to balance of _addressToRefund */
285         uint amount = balanceOf[_addressToRefund];
286         /* sets balance to 0 */
287         balanceOf[_addressToRefund] = 0;
288         /* is there any balance? */
289         if (amount > 0) {
290             /* call to untrusted address */
291             if (_addressToRefund.call.value(amount)()) {
292                 /* log event */
293                 LogFundTransfer(_addressToRefund, amount, false);
294             } else {
295                 /* unsuccessful send so reset the balance */
296                 balanceOf[_addressToRefund] = amount;
297             }
298         } 
299     }     
300    
301 
302     /*
303     *  @notice public function
304     *  emergency manual refunds
305     */     
306     function emergencyWithdraw() public
307         isEmergency    
308     {
309         /* manual refunds */
310         calcRefund(msg.sender);
311     }        
312 
313     /*
314     *  @notice owner restricted function   
315     *  @param _newEmergencyStatus boolean
316     *  sets contract mode to emergency status to allow individual withdraw via emergencyWithdraw()
317     */    
318     function ownerSetEmergencyStatus(bool _newEmergencyStatus) public
319         onlyOwner 
320     {        
321         /* close crowdsale */
322         crowdsaleClosed = _newEmergencyStatus;
323         /* allow manual refunds via emergencyWithdraw */
324         emergency = _newEmergencyStatus;        
325     } 
326 
327     /*
328     *  @notice  owner restricted function 
329     *  burns any unsold tokens at end of crowdfund
330     */      
331     function ownerBurnUnsoldTokens()
332         onlyOwner
333         onlyAfterDeadline
334     {
335         tokenReward.priviledgedAddressBurnUnsoldCoins();
336     }         
337 
338 
339 }