1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title MultiOwnable
5  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
6  * functions, this simplifies the implementation of "users permissions".
7  */
8 contract MultiOwnable {
9     address public manager; // address used to set owners
10     address[] public owners;
11     mapping(address => bool) public ownerByAddress;
12 
13     event AddOwner(address owner);
14     event RemoveOwner(address owner);
15 
16     modifier onlyOwner() {
17         require(ownerByAddress[msg.sender] == true);
18         _;
19     }
20 
21     /**
22      * @dev MultiOwnable constructor sets the manager
23      */
24     function MultiOwnable() public {
25         manager = msg.sender;
26         _addOwner(msg.sender);
27     }
28 
29     /**
30      * @dev Function to add owner address
31      */
32     function addOwner(address _owner) public {
33         require(msg.sender == manager);
34         _addOwner(_owner);
35 
36     }
37 
38     /**
39      * @dev Function to remove owner address
40      */
41     function removeOwner(address _owner) public {
42         require(msg.sender == manager);
43         _removeOwner(_owner);
44 
45     }
46 
47     function _addOwner(address _owner) internal {
48         ownerByAddress[_owner] = true;
49         
50         owners.push(_owner);
51         AddOwner(_owner);
52     }
53 
54     function _removeOwner(address _owner) internal {
55 
56         if (owners.length == 0)
57             return;
58 
59         ownerByAddress[_owner] = false;
60         
61         uint id = indexOf(_owner);
62         remove(id);
63         RemoveOwner(_owner);
64     }
65 
66     function getOwners() public constant returns (address[]) {
67         return owners;
68     }
69 
70     function indexOf(address value) internal returns(uint) {
71         uint i = 0;
72         while (i < owners.length) {
73             if (owners[i] == value) {
74                 break;
75             }
76             i++;
77         }
78     return i;
79   }
80 
81   function remove(uint index) internal {
82         if (index >= owners.length) return;
83 
84         for (uint i = index; i<owners.length-1; i++){
85             owners[i] = owners[i+1];
86         }
87         delete owners[owners.length-1];
88         owners.length--;
89     }
90 
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 /**
140  * @title IERC20Token - ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract IERC20Token {
144     string public name;
145     string public symbol;
146     uint8 public decimals;
147     uint256 public totalSupply;
148 
149     function balanceOf(address _owner) public constant returns (uint256 balance);
150     function transfer(address _to, uint256 _value)  public returns (bool success);
151     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
152     function approve(address _spender, uint256 _value)  public returns (bool success);
153     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
154 
155     event Transfer(address indexed _from, address indexed _to, uint256 _value);
156     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
157 }
158 
159 contract PricingStrategy {
160 
161     using SafeMath for uint256;
162 
163     uint256 public constant FIRST_ROUND = 1523664001; //2018.04.14 00:00:01 GMT
164     uint256 public constant FIRST_ROUND_RATE = 20; // FIRST ROUND BONUS RATE 20%
165 
166     uint256 public constant SECOND_ROUND = 1524268801; //2018.04.21 00:00:01 GMT
167     uint256 public constant SECOND_ROUND_RATE = 10; // SECOND ROUND BONUS RATE 10%
168 
169     uint256 public constant FINAL_ROUND_RATE = 0; //FINAL ROUND BONUS RATE 0%
170 
171 
172     function PricingStrategy() public {
173         
174     }
175 
176     function getRate() public constant returns(uint256 rate) {
177         if (now<FIRST_ROUND) {
178             return (FIRST_ROUND_RATE);
179         } else if (now<SECOND_ROUND) {
180             return (SECOND_ROUND_RATE);
181         } else {
182             return (FINAL_ROUND_RATE);
183         }
184     }
185 
186 }
187 
188 contract CrowdSale is MultiOwnable {
189 
190     using SafeMath for uint256;
191 
192     enum ICOState {
193         NotStarted,
194         Started,
195         Stopped,
196         Finished
197     } // ICO SALE STATES
198 
199     struct Stats { 
200         uint256 TotalContrAmount;
201         ICOState State;
202         uint256 TotalContrCount;
203     }
204 
205     event Contribution(address contraddress, uint256 ethamount, uint256 tokenamount);
206     event PresaleTransferred(address contraddress, uint256 tokenamount);
207     event TokenOPSPlatformTransferred(address contraddress, uint256 tokenamount);
208     event OVISBookedTokensTransferred(address contraddress, uint256 tokenamount);
209     event OVISSaleBooked(uint256 jointToken);
210     event OVISReservedTokenChanged(uint256 jointToken);
211     event RewardPoolTransferred(address rewardpooladdress, uint256 tokenamount);
212     event OPSPoolTransferred(address OPSpooladdress, uint256 tokenamount);
213     event SaleStarted();
214     event SaleStopped();
215     event SaleContinued();
216     event SoldOutandSaleStopped();
217     event SaleFinished();
218     event TokenAddressChanged(address jointaddress, address OPSAddress);
219     event StrategyAddressChanged(address strategyaddress);   
220     event Funded(address fundaddress, uint256 amount);
221 
222     uint256 public constant MIN_ETHER_CONTR = 0.1 ether; // MINIMUM ETHER CONTRIBUTION 
223     uint256 public constant MAX_ETHER_CONTR = 100 ether; // MAXIMUM ETHER CONTRIBUTION
224 
225     uint256 public constant DECIMALCOUNT = 10**18;
226     uint256 public constant JOINT_PER_ETH = 8000; // 1 ETH = 8000 JOINT
227 
228     uint256 public constant PRESALE_JOINTTOKENS = 5000000; // PRESALE 500 ETH * 10000 JOINT AMOUNT
229     uint256 public constant TOKENOPSPLATFORM_JOINTTOKENS = 25000000; // TOKENOPS PLAFTORM RESERVED AMOUNT
230     uint256 public constant MAX_AVAILABLE_JOINTTOKENS = 100000000; // PRESALE JOINT TOKEN SALE AMOUNT
231     uint256 public AVAILABLE_JOINTTOKENS = uint256(100000000).mul(DECIMALCOUNT);
232      
233     uint256 public OVISRESERVED_TOKENS = 25000000; // RESERVED TOKEN AMOUNT FOR OVIS PARTNER SALE
234     uint256 public OVISBOOKED_TOKENS = 0;
235     uint256 public OVISBOOKED_BONUSTOKENS = 0;
236 
237     uint256 public constant SALE_START_TIME = 1523059201; //UTC 2018-04-07 00:00:01
238 
239     
240     uint256 public ICOSALE_JOINTTOKENS = 0; // ICO CONTRACT TOTAL JOINT SALE AMOUNT
241     uint256 public ICOSALE_BONUSJOINTTOKENS = 0; // ICO CONTRACT TOTAL JOINT BONUS AMOUNT
242     uint256 public TOTAL_CONTRIBUTOR_COUNT = 0; // ICO SALE TOTAL CONTRIBUTOR COUNT
243 
244     ICOState public CurrentState; // ICO SALE STATE
245 
246     IERC20Token public JointToken;
247     IERC20Token public OPSToken;
248     PricingStrategy public PriceStrategy;
249 
250     address public FundAddress = 0x25Bc52CBFeB86f6f12EaddF77560b02c4617DC21;
251     address public RewardPoolAddress = 0xEb1FAef9068b6B8f46b50245eE877dA5b03D98C9;
252     address public OvisAddress = 0x096A5166F75B5B923234841F69374de2F47F9478;
253     address public PresaleAddress = 0x3e5EF0eC822B519eb0a41f94b34e90D16ce967E8;
254     address public TokenOPSSaleAddress = 0x8686e49E07Bde4F389B0a5728fCe8713DB83602b;
255     address public StrategyAddress = 0xe2355faB9239d5ddaA071BDE726ceb2Db876B8E2;
256     address public OPSPoolAddress = 0xEA5C0F39e5E3c742fF6e387394e0337e7366a121;
257 
258     modifier checkCap() {
259         require(msg.value>=MIN_ETHER_CONTR);
260         require(msg.value<=MAX_ETHER_CONTR);
261         _;
262     }
263 
264     modifier checkBalance() {
265         require(JointToken.balanceOf(address(this))>0);
266         require(OPSToken.balanceOf(address(this))>0);
267         _;       
268     }
269 
270     modifier checkTime() {
271         require(now>=SALE_START_TIME);
272         _;
273     }
274 
275     modifier checkState() {
276         require(CurrentState == ICOState.Started);
277         _;
278     }
279 
280     function CrowdSale() {
281         PriceStrategy = PricingStrategy(StrategyAddress);
282 
283         CurrentState = ICOState.NotStarted;
284         uint256 _soldtokens = PRESALE_JOINTTOKENS.add(TOKENOPSPLATFORM_JOINTTOKENS).add(OVISRESERVED_TOKENS);
285         _soldtokens = _soldtokens.mul(DECIMALCOUNT);
286         AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.sub(_soldtokens);
287     }
288 
289     function() payable public checkState checkTime checkBalance checkCap {
290         contribute();
291     }
292 
293     /**
294      * @dev calculates token amounts and sends to contributor
295      */
296     function contribute() private {
297         uint256 _jointAmount = 0;
298         uint256 _jointBonusAmount = 0;
299         uint256 _jointTransferAmount = 0;
300         uint256 _bonusRate = 0;
301         uint256 _ethAmount = msg.value;
302 
303         if (msg.value.mul(JOINT_PER_ETH)>AVAILABLE_JOINTTOKENS) {
304             _ethAmount = AVAILABLE_JOINTTOKENS.div(JOINT_PER_ETH);
305         } else {
306             _ethAmount = msg.value;
307         }       
308 
309         _bonusRate = PriceStrategy.getRate();
310         _jointAmount = (_ethAmount.mul(JOINT_PER_ETH));
311         _jointBonusAmount = _ethAmount.mul(JOINT_PER_ETH).mul(_bonusRate).div(100);  
312         _jointTransferAmount = _jointAmount.add(_jointBonusAmount);
313         
314         require(_jointAmount<=AVAILABLE_JOINTTOKENS);
315 
316         require(JointToken.transfer(msg.sender, _jointTransferAmount));
317         require(OPSToken.transfer(msg.sender, _jointTransferAmount));     
318 
319         if (msg.value>_ethAmount) {
320             msg.sender.transfer(msg.value.sub(_ethAmount));
321             CurrentState = ICOState.Stopped;
322             SoldOutandSaleStopped();
323         }
324 
325         AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.sub(_jointAmount);
326         ICOSALE_JOINTTOKENS = ICOSALE_JOINTTOKENS.add(_jointAmount);
327         ICOSALE_BONUSJOINTTOKENS = ICOSALE_BONUSJOINTTOKENS.add(_jointBonusAmount);         
328         TOTAL_CONTRIBUTOR_COUNT = TOTAL_CONTRIBUTOR_COUNT.add(1);
329 
330         Contribution(msg.sender, _ethAmount, _jointTransferAmount);
331     }
332 
333      /**
334      * @dev book OVIS partner sale tokens
335      */
336     function bookOVISSale(uint256 _rate, uint256 _jointToken) onlyOwner public {              
337         OVISBOOKED_TOKENS = OVISBOOKED_TOKENS.add(_jointToken);
338         require(OVISBOOKED_TOKENS<=OVISRESERVED_TOKENS.mul(DECIMALCOUNT));
339         uint256 _bonus = _jointToken.mul(_rate).div(100);
340         OVISBOOKED_BONUSTOKENS = OVISBOOKED_BONUSTOKENS.add(_bonus);
341         OVISSaleBooked(_jointToken);
342     }
343 
344      /**
345      * @dev changes OVIS partner sale reserved tokens
346      */
347     function changeOVISReservedToken(uint256 _jointToken) onlyOwner public {
348         if (_jointToken > OVISRESERVED_TOKENS) {
349             AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.sub((_jointToken.sub(OVISRESERVED_TOKENS)).mul(DECIMALCOUNT));
350             OVISRESERVED_TOKENS = _jointToken;
351         } else if (_jointToken < OVISRESERVED_TOKENS) {
352             AVAILABLE_JOINTTOKENS = AVAILABLE_JOINTTOKENS.add((OVISRESERVED_TOKENS.sub(_jointToken)).mul(DECIMALCOUNT));
353             OVISRESERVED_TOKENS = _jointToken;
354         }
355         
356         OVISReservedTokenChanged(_jointToken);
357     }
358 
359       /**
360      * @dev changes Joint Token and OPS Token contract address
361      */
362     function changeTokenAddress(address _jointAddress, address _OPSAddress) onlyOwner public {
363         JointToken = IERC20Token(_jointAddress);
364         OPSToken = IERC20Token(_OPSAddress);
365         TokenAddressChanged(_jointAddress, _OPSAddress);
366     }
367 
368     /**
369      * @dev changes Pricing Strategy contract address, which calculates token amounts to give
370      */
371     function changeStrategyAddress(address _strategyAddress) onlyOwner public {
372         PriceStrategy = PricingStrategy(_strategyAddress);
373         StrategyAddressChanged(_strategyAddress);
374     }
375 
376     /**
377      * @dev transfers presale token amounts to contributors
378      */
379     function transferPresaleTokens() private {
380         require(JointToken.transfer(PresaleAddress, PRESALE_JOINTTOKENS.mul(DECIMALCOUNT)));
381         PresaleTransferred(PresaleAddress, PRESALE_JOINTTOKENS.mul(DECIMALCOUNT));
382     }
383 
384     /**
385      * @dev transfers presale token amounts to contributors
386      */
387     function transferTokenOPSPlatformTokens() private {
388         require(JointToken.transfer(TokenOPSSaleAddress, TOKENOPSPLATFORM_JOINTTOKENS.mul(DECIMALCOUNT)));
389         TokenOPSPlatformTransferred(TokenOPSSaleAddress, TOKENOPSPLATFORM_JOINTTOKENS.mul(DECIMALCOUNT));
390     }
391 
392     /**
393      * @dev transfers token amounts to other ICO platforms
394      */
395     function transferOVISBookedTokens() private {
396         uint256 _totalTokens = OVISBOOKED_TOKENS.add(OVISBOOKED_BONUSTOKENS);
397         if(_totalTokens>0) {       
398             require(JointToken.transfer(OvisAddress, _totalTokens));
399             require(OPSToken.transfer(OvisAddress, _totalTokens));
400         }
401         OVISBookedTokensTransferred(OvisAddress, _totalTokens);
402     }
403 
404     /**
405      * @dev transfers remaining unsold token amount to reward pool
406      */
407     function transferRewardPool() private {
408         uint256 balance = JointToken.balanceOf(address(this));
409         if(balance>0) {
410             require(JointToken.transfer(RewardPoolAddress, balance));
411         }
412         RewardPoolTransferred(RewardPoolAddress, balance);
413     }
414 
415     /**
416      * @dev transfers remaining OPS token amount to pool
417      */
418     function transferOPSPool() private {
419         uint256 balance = OPSToken.balanceOf(address(this));
420         if(balance>0) {
421         require(OPSToken.transfer(OPSPoolAddress, balance));
422         }
423         OPSPoolTransferred(OPSPoolAddress, balance);
424     }
425 
426 
427     /**
428      * @dev start function to start crowdsale for contribution
429      */
430     function startSale() onlyOwner public {
431         require(CurrentState == ICOState.NotStarted);
432         require(JointToken.balanceOf(address(this))>0);
433         require(OPSToken.balanceOf(address(this))>0);       
434         CurrentState = ICOState.Started;
435         transferPresaleTokens();
436         transferTokenOPSPlatformTokens();
437         SaleStarted();
438     }
439 
440     /**
441      * @dev stop function to stop crowdsale for contribution
442      */
443     function stopSale() onlyOwner public {
444         require(CurrentState == ICOState.Started);
445         CurrentState = ICOState.Stopped;
446         SaleStopped();
447     }
448 
449     /**
450      * @dev continue function to continue crowdsale for contribution
451      */
452     function continueSale() onlyOwner public {
453         require(CurrentState == ICOState.Stopped);
454         CurrentState = ICOState.Started;
455         SaleContinued();
456     }
457 
458     /**
459      * @dev finish function to finish crowdsale for contribution
460      */
461     function finishSale() onlyOwner public {
462         if (this.balance>0) {
463             FundAddress.transfer(this.balance);
464         }
465         transferOVISBookedTokens();
466         transferRewardPool();    
467         transferOPSPool();  
468         CurrentState = ICOState.Finished; 
469         SaleFinished();
470     }
471 
472     /**
473      * @dev funds contract's balance to fund address
474      */
475     function getFund(uint256 _amount) onlyOwner public {
476         require(_amount<=this.balance);
477         FundAddress.transfer(_amount);
478         Funded(FundAddress, _amount);
479     }
480 
481     function getStats() public constant returns(uint256 TotalContrAmount, ICOState State, uint256 TotalContrCount) {
482         uint256 totaltoken = 0;
483         totaltoken = ICOSALE_JOINTTOKENS.add(PRESALE_JOINTTOKENS.mul(DECIMALCOUNT));
484         totaltoken = totaltoken.add(TOKENOPSPLATFORM_JOINTTOKENS.mul(DECIMALCOUNT));
485         totaltoken = totaltoken.add(OVISBOOKED_TOKENS);
486         return (totaltoken, CurrentState, TOTAL_CONTRIBUTOR_COUNT);
487     }
488 
489     function destruct() onlyOwner public {
490         require(CurrentState == ICOState.Finished);
491         selfdestruct(FundAddress);
492     }
493 }