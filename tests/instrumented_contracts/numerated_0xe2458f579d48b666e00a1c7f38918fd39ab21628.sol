1 pragma solidity 0.4.14;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev revert()s if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       revert();
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 
46 /**
47  * Math operations with safety checks
48  */
49 library SafeMath {
50   
51   
52   function mul256(uint256 a, uint256 b) internal returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div256(uint256 a, uint256 b) internal returns (uint256) {
59     require(b > 0); // Solidity automatically revert()s when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub256(uint256 a, uint256 b) internal returns (uint256) {
66     require(b <= a);
67     return a - b;
68   }
69 
70   function add256(uint256 a, uint256 b) internal returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }  
75   
76 
77   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
78     return a >= b ? a : b;
79   }
80 
81   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
82     return a < b ? a : b;
83   }
84 
85   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
86     return a >= b ? a : b;
87   }
88 
89   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
90     return a < b ? a : b;
91   }
92 }
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  */
99 contract ERC20Basic {
100   uint256 public totalSupply;
101   function balanceOf(address who) constant returns (uint256);
102   function transfer(address to, uint256 value);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev ERC20 interface with allowances. 
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) constant returns (uint256);
115   function transferFrom(address from, address to, uint256 value);
116   function approve(address spender, uint256 value);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances. 
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   /**
133    * @dev Fix for the ERC20 short address attack.
134    */
135   modifier onlyPayloadSize(uint size) {
136      if(msg.data.length < size + 4) {
137        revert();
138      }
139      _;
140   }
141 
142   /**
143   * @dev transfer token for a specified address
144   * @param _to The address to transfer to.
145   * @param _value The amount to be transferred.
146   */
147   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
148     balances[msg.sender] = balances[msg.sender].sub256(_value);
149     balances[_to] = balances[_to].add256(_value);
150     Transfer(msg.sender, _to, _value);
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of. 
156   * @return An uint representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) constant returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 
165 
166 
167 /**
168  * @title Standard ERC20 token
169  * @dev Implemantation of the basic standart token.
170  */
171 contract StandardToken is BasicToken, ERC20 {
172 
173   mapping (address => mapping (address => uint256)) allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint the amout of tokens to be transfered
181    */
182   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) {
183     var _allowance = allowed[_from][msg.sender];
184 
185     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
186     // if (_value > _allowance) revert();
187 
188     balances[_to] = balances[_to].add256(_value);
189     balances[_from] = balances[_from].sub256(_value);
190     allowed[_from][msg.sender] = _allowance.sub256(_value);
191     Transfer(_from, _to, _value);
192   }
193 
194   /**
195    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    * @param _spender The address which will spend the funds.
197    * @param _value The amount of tokens to be spent.
198    */
199   function approve(address _spender, uint256 _value) {
200 
201     //  To change the approve amount you first have to reduce the addresses
202     //  allowance to zero by calling `approve(_spender, 0)` if it is not
203     //  already 0 to mitigate the race condition described here:
204     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
206 
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens than an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint specifing the amount of tokens still avaible for the spender.
216    */
217   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
218     return allowed[_owner][_spender];
219   }
220 
221 
222 }
223 
224 
225 
226 /**
227  * @title LuckyToken
228  * @dev The main Lucky token contract
229  * 
230  */
231  
232 contract LuckyToken is StandardToken, Ownable{
233   string public name = "Lucky888Coin";
234   string public symbol = "LKY";
235   uint public decimals = 18;
236 
237   event TokenBurned(uint256 value);
238   
239   function LuckyToken() {
240     totalSupply = (10 ** 8) * (10 ** decimals);
241     balances[msg.sender] = totalSupply;
242   }
243 
244   /**
245    * @dev Allows the owner to burn the token
246    * @param _value number of tokens to be burned.
247    */
248   function burn(uint _value) onlyOwner {
249     require(balances[msg.sender] >= _value);
250     balances[msg.sender] = balances[msg.sender].sub256(_value);
251     totalSupply = totalSupply.sub256(_value);
252     TokenBurned(_value);
253   }
254 
255 }
256 
257 /**
258  * @title InitialTeuTokenSale
259  * @dev The Initial TEU token sale contract
260  * 
261  */
262 contract initialTeuTokenSale is Ownable {
263   using SafeMath for uint256;
264   event LogPeriodStart(uint period);
265   event LogCollectionStart(uint period);
266   event LogContribution(address indexed contributorAddress, uint256 weiAmount, uint period);
267   event LogCollect(address indexed contributorAddress, uint256 tokenAmount, uint period); 
268 
269   LuckyToken                                       private  token; 
270   mapping(uint => address)                       private  walletOfPeriod;
271   uint256                                        private  minContribution = 0.1 ether;
272   uint                                           private  saleStart;
273   bool                                           private  isTokenCollectable = false;
274   mapping(uint => uint)                          private  periodStart;
275   mapping(uint => uint)                          private  periodDeadline;
276   mapping(uint => uint256)                       private  periodTokenPool;
277 
278   mapping(uint => mapping (address => uint256))  private  contribution;  
279   mapping(uint => uint256)                       private  periodContribution;  
280   mapping(uint => mapping (address => bool))     private  collected;  
281   mapping(uint => mapping (address => uint256))  private  tokenCollected;  
282   
283   uint public totalPeriod = 0;
284   uint public currentPeriod = 0;
285 
286 
287   /**
288    * @dev Initialise the contract
289    * @param _tokenAddress address of TEU token
290    * @param _walletPeriod1 address of period 1 wallet
291    * @param _walletPeriod2 address of period 2 wallet
292    * @param _tokenPoolPeriod1 amount of pool of token in period 1
293    * @param _tokenPoolPeriod2 amount of pool of token in period 2
294    * @param _saleStartDate start date / time of the token sale
295    */
296   function initTokenSale (address _tokenAddress
297   , address _walletPeriod1, address _walletPeriod2
298   , uint256 _tokenPoolPeriod1, uint256 _tokenPoolPeriod2
299   , uint _saleStartDate) onlyOwner {
300     assert(totalPeriod == 0);
301     assert(_tokenAddress != address(0));
302     assert(_walletPeriod1 != address(0));
303     assert(_walletPeriod2 != address(0));
304     walletOfPeriod[1] = _walletPeriod1;
305     walletOfPeriod[2] = _walletPeriod2;
306     periodTokenPool[1] = _tokenPoolPeriod1;
307     periodTokenPool[2] = _tokenPoolPeriod2;
308     token = LuckyToken(_tokenAddress);
309     assert(token.owner() == owner);
310     setPeriodStart(_saleStartDate);
311  
312   }
313   
314   
315   /**
316    * @dev Allows the owner to set the starting time.
317    * @param _saleStartDate the new sales start date / time
318    */  
319   function setPeriodStart(uint _saleStartDate) onlyOwner beforeSaleStart private {
320     totalPeriod = 0;
321     saleStart = _saleStartDate;
322     
323     uint period1_contributionInterval = 14 days;
324     uint period1_collectionInterval = 14 days;
325     uint period2_contributionInterval = 7 days;
326     
327     addPeriod(saleStart, saleStart + period1_contributionInterval);
328     addPeriod(saleStart + period1_contributionInterval + period1_collectionInterval, saleStart + period1_contributionInterval + period1_collectionInterval + period2_contributionInterval);
329 
330     currentPeriod = 1;    
331   } 
332   
333   function addPeriod(uint _periodStart, uint _periodDeadline) onlyOwner beforeSaleEnd private {
334     require(_periodStart >= now && _periodDeadline > _periodStart && (totalPeriod == 0 || _periodStart > periodDeadline[totalPeriod]));
335     totalPeriod = totalPeriod + 1;
336     periodStart[totalPeriod] = _periodStart;
337     periodDeadline[totalPeriod] = _periodDeadline;
338     periodContribution[totalPeriod] = 0;
339   }
340 
341 
342   /**
343    * @dev Call this method to let the contract to go into next period of sales
344    */
345   function goNextPeriod() onlyOwner public {
346     for (uint i = 1; i <= totalPeriod; i++) {
347         if (currentPeriod < totalPeriod && now >= periodStart[currentPeriod + 1]) {
348             currentPeriod = currentPeriod + 1;
349             isTokenCollectable = false;
350             LogPeriodStart(currentPeriod);
351         }
352     }
353     
354   }
355 
356   /**
357    * @dev Call this method to let the contract to allow token collection after the contribution period
358    */  
359   function goTokenCollection() onlyOwner public {
360     require(currentPeriod > 0 && now > periodDeadline[currentPeriod] && !isTokenCollectable);
361     isTokenCollectable = true;
362     LogCollectionStart(currentPeriod);
363   }
364 
365   /**
366    * @dev modifier to allow contribution only when the sale is ON
367    */
368   modifier saleIsOn() {
369     require(currentPeriod > 0 && now >= periodStart[currentPeriod] && now < periodDeadline[currentPeriod]);
370     _;
371   }
372   
373   /**
374    * @dev modifier to allow collection only when the collection is ON
375    */
376   modifier collectIsOn() {
377     require(isTokenCollectable && currentPeriod > 0 && now > periodDeadline[currentPeriod] && (currentPeriod == totalPeriod || now < periodStart[currentPeriod + 1]));
378     _;
379   }
380   
381   /**
382    * @dev modifier to ensure it is before start of first period of sale
383    */  
384   modifier beforeSaleStart() {
385     require(totalPeriod == 0 || now < periodStart[1]);
386     _;  
387   }
388   /**
389    * @dev modifier to ensure it is before the deadline of last sale period
390    */  
391    
392   modifier beforeSaleEnd() {
393     require(currentPeriod == 0 || now < periodDeadline[totalPeriod]);
394     _;
395   }
396   /**
397    * @dev modifier to ensure it is after the deadline of last sale period
398    */ 
399   modifier afterSaleEnd() {
400     require(currentPeriod > 0 && now > periodDeadline[totalPeriod]);
401     _;
402   }
403   
404   modifier overMinContribution() {
405     require(msg.value >= minContribution);
406     _;
407   }
408   
409   
410   /**
411    * @dev record the contribution of a contribution 
412    */
413   function contribute() private saleIsOn overMinContribution {
414     contribution[currentPeriod][msg.sender] = contribution[currentPeriod][msg.sender].add256(msg.value);
415     periodContribution[currentPeriod] = periodContribution[currentPeriod].add256(msg.value);
416     assert(walletOfPeriod[currentPeriod].send(msg.value));
417     LogContribution(msg.sender, msg.value, currentPeriod);
418   }
419 
420   /**
421    * @dev Allows contributor to collect all token alloted for all period after preiod deadline
422    */
423   function collectToken() public collectIsOn {
424     uint256 _tokenCollected = 0;
425     for (uint i = 1; i <= totalPeriod; i++) {
426         if (!collected[i][msg.sender] && contribution[i][msg.sender] > 0)
427         {
428             _tokenCollected = contribution[i][msg.sender].mul256(periodTokenPool[i]).div256(periodContribution[i]);
429 
430             collected[i][msg.sender] = true;
431             token.transfer(msg.sender, _tokenCollected);
432 
433             tokenCollected[i][msg.sender] = _tokenCollected;
434             LogCollect(msg.sender, _tokenCollected, i);
435         }
436     }
437   }
438 
439 
440   /**
441    * @dev Allow owner to transfer out the token in the contract
442    * @param _to address to transfer to
443    * @param _amount amount to transfer
444    */  
445   function transferTokenOut(address _to, uint256 _amount) public onlyOwner {
446     token.transfer(_to, _amount);
447   }
448 
449   /**
450    * @dev Allow owner to transfer out the ether in the contract
451    * @param _to address to transfer to
452    * @param _amount amount to transfer
453    */  
454   function transferEtherOut(address _to, uint256 _amount) public onlyOwner {
455     assert(_to.send(_amount));
456   }  
457 
458   /**
459    * @dev to get the contribution amount of any contributor under different period
460    * @param _period period to get the contribution amount
461    * @param _contributor contributor to get the conribution amount
462    */  
463   function contributionOf(uint _period, address _contributor) public constant returns (uint256) {
464     return contribution[_period][_contributor] ;
465   }
466 
467   /**
468    * @dev to get the total contribution amount of a given period
469    * @param _period period to get the contribution amount
470    */  
471   function periodContributionOf(uint _period) public constant returns (uint256) {
472     return periodContribution[_period];
473   }
474 
475   /**
476    * @dev to check if token is collected by any contributor under different period
477    * @param _period period to get the collected status
478    * @param _contributor contributor to get collected status
479    */  
480   function isTokenCollected(uint _period, address _contributor) public constant returns (bool) {
481     return collected[_period][_contributor] ;
482   }
483   
484   /**
485    * @dev to get the amount of token collected by any contributor under different period
486    * @param _period period to get the amount
487    * @param _contributor contributor to get amont
488    */  
489   function tokenCollectedOf(uint _period, address _contributor) public constant returns (uint256) {
490     return tokenCollected[_period][_contributor] ;
491   }
492 
493   /**
494    * @dev Fallback function which receives ether and create the appropriate number of tokens for the 
495    * msg.sender.
496    */
497   function() external payable {
498     contribute();
499   }
500 
501 }