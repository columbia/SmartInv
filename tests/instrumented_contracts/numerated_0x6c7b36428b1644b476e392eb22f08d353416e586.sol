1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     
159   address public owner;
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() public {
166     owner = msg.sender;
167   }
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177   /**
178    * @dev Allows the current owner to transfer control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function transferOwnership(address newOwner) onlyOwner public {
182     require(newOwner != address(0));      
183     owner = newOwner;
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 contract MintableToken is StandardToken, Ownable {
195   event Mint(address indexed to, uint256 amount);
196   event MintFinished();
197 
198   bool public mintingFinished = false;
199 
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will receive the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     Mint(_to, _amount);
216     Transfer(address(0), _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner canMint public returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 }
230 
231 contract GUT is Ownable, MintableToken {
232   using SafeMath for uint256;    
233   string public constant name = "Geekz Utility Token";
234   string public constant symbol = "GUT";
235   uint32 public constant decimals = 18;
236 
237   address public addressTeam;
238   address public addressReserveFund;
239 
240   uint public summTeam = 4000000 * 1 ether;
241   uint public summReserveFund = 1000000 * 1 ether;
242 
243   function GUT() public {
244     addressTeam = 0x142c0dba7449ceae2Dc0A5ce048D65b690630274;  //set your value
245     addressReserveFund = 0xc709565D92a6B9a913f4d53de730712e78fe5B8C; //set your value
246 
247     //Founders and supporters initial Allocations
248     balances[addressTeam] = balances[addressTeam].add(summTeam);
249     balances[addressReserveFund] = balances[addressReserveFund].add(summReserveFund);
250 
251     totalSupply = summTeam.add(summReserveFund);
252   }
253   function getTotalSupply() public constant returns(uint256){
254       return totalSupply;
255   }
256 }
257 
258 /**
259  * @title Crowdsale
260  * @dev Crowdsale is a base contract for managing a token crowdsale.
261  * Crowdsales have a start and end timestamps, where Contributors can make
262  * token Contributions and the crowdsale will assign them tokens based
263  * on a token per ETH rate. Funds collected are forwarded to a wallet
264  * as they arrive. The contract requires a MintableToken that will be
265  * minted as contributions arrive, note that the crowdsale contract
266  * must be owner of the token in order to be able to mint it.
267  */
268 contract Crowdsale is Ownable {
269   using SafeMath for uint256;
270   // totalTokens
271   uint256 public totalTokens;
272   // soft cap
273   uint softcap;
274   // balances for softcap
275   mapping(address => uint) public balances;
276   // The token being offered
277   GUT public token;
278   // start and end timestamps where investments are allowed (both inclusive)
279   
280   //Early stage
281     //start
282   uint256 public startEarlyStage1;
283   uint256 public startEarlyStage2;
284   uint256 public startEarlyStage3;
285   uint256 public startEarlyStage4;
286     //end
287   uint256 public endEarlyStage1;
288   uint256 public endEarlyStage2;
289   uint256 public endEarlyStage3;
290   uint256 public endEarlyStage4;   
291   
292   //Final stage
293     //start
294   uint256 public startFinalStage1;
295   uint256 public startFinalStage2;
296     //end 
297   uint256 public endFinalStage1;    
298   uint256 public endFinalStage2;  
299   
300   //token distribution
301   uint256 public maxEarlyStage;
302   uint256 public maxFinalStage;
303 
304   uint256 public totalEarlyStage;
305   uint256 public totalFinalStage;
306   
307   // how many token units a Contributor gets per wei
308   uint256 public rateEarlyStage1;
309   uint256 public rateEarlyStage2;
310   uint256 public rateEarlyStage3;
311   uint256 public rateEarlyStage4;
312   uint256 public rateFinalStage1;
313   uint256 public rateFinalStage2;   
314   
315   // Remaining Token Allocation 
316   // (after completion of all stages of crowdfunding)
317   uint public mintStart; //31 Mar 2018 08:00:00 GMT
318 
319   // address where funds are collected
320   address public wallet;
321 
322   // minimum quantity values
323   uint256 public minQuanValues; 
324 
325 /**
326 * event for token Procurement logging
327 * @param contributor who Pledged for the tokens
328 * @param beneficiary who got the tokens
329 * @param value weis Contributed for Procurement
330 * @param amount amount of tokens Procured
331 */
332   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
333   function Crowdsale() public {
334     token = createTokenContract();
335     // total number of tokens
336     totalTokens = 25000000 * 1 ether;
337     //soft cap
338     softcap = 400 * 1 ether;   
339     // minimum quantity values
340     minQuanValues = 100000000000000000; //0.1 eth
341     // start and end timestamps where investments are allowed
342     //Early stage
343       //start
344     startEarlyStage1 = 1519804800;//28 Feb 2018 08:00:00 GMT
345     startEarlyStage2 = startEarlyStage1 + 2 * 1 days;
346     startEarlyStage3 = startEarlyStage2 + 2 * 1 days;
347     startEarlyStage4 = startEarlyStage3 + 2 * 1 days;
348       //end
349     endEarlyStage1 = startEarlyStage1 + 2 * 1 days;
350     endEarlyStage2 = startEarlyStage2 + 2 * 1 days;
351     endEarlyStage3 = startEarlyStage3 + 2 * 1 days;
352     endEarlyStage4 = startEarlyStage4 + 2 * 1 days;   
353     //Final stage
354       //start
355     startFinalStage1 = 1520582400;//09 Mar 2018 08:00:00 GMT
356     startFinalStage2 = startFinalStage1 + 6 * 1 days;
357       //end 
358     endFinalStage1 = startFinalStage1 + 6 * 1 days;    
359     endFinalStage2 = startFinalStage2 + 16 * 1 days;         
360     // restrictions on amounts during the crowdfunding event stages
361     maxEarlyStage = 4000000 * 1 ether;
362     maxFinalStage = 16000000 * 1 ether;
363     // rate;
364     rateEarlyStage1 = 10000;
365     rateEarlyStage2 = 7500;
366     rateEarlyStage3 = 5000;
367     rateEarlyStage4 = 4000;
368     rateFinalStage1 = 3000;
369     rateFinalStage2 = 2000; 
370     // Remaining Token Allocation 
371     // (after completion of all stages of crowdfunding event)
372     mintStart = endFinalStage2; //31 Mar 2018 08:00:00 GMT
373     // address where funds are collected
374     wallet = 0x80B48F46CD1857da32dB10fa54E85a2F18B96412;
375   }
376 
377   
378   function setRateEarlyStage1(uint _rateEarlyStage1) public {
379     rateEarlyStage1 = _rateEarlyStage1;
380   }
381   function setRateEarlyStage2(uint _rateEarlyStage2) public {
382     rateEarlyStage2 = _rateEarlyStage2;
383   }  
384   function setRateEarlyStage3(uint _rateEarlyStage3) public {
385     rateEarlyStage3 = _rateEarlyStage3;
386   }  
387   function setRateEarlyStage4(uint _rateEarlyStage4) public {
388     rateEarlyStage4 = _rateEarlyStage4;
389   }  
390   
391   function setRateFinalStage1(uint _rateFinalStage1) public {
392     rateFinalStage1 = _rateFinalStage1;
393   }  
394   function setRateFinalStage2(uint _rateFinalStage2) public {
395     rateFinalStage2 = _rateFinalStage2;
396   }   
397   
398   function createTokenContract() internal returns (GUT) {
399     return new GUT();
400   }
401 
402   // fallback function can be used to Procure tokens
403   function () external payable {
404     procureTokens(msg.sender);
405   }
406 
407   // low level token Pledge function
408   function procureTokens(address beneficiary) public payable {
409     uint256 tokens;
410     uint256 weiAmount = msg.value;
411     uint256 backAmount;
412     require(beneficiary != address(0));
413     //minimum amount in ETH
414     require(weiAmount >= minQuanValues);
415     //EarlyStage1
416     if (now >= startEarlyStage1 && now < endEarlyStage1 && totalEarlyStage < maxEarlyStage){
417       tokens = weiAmount.mul(rateEarlyStage1);
418       if (maxEarlyStage.sub(totalEarlyStage) < tokens){
419         tokens = maxEarlyStage.sub(totalEarlyStage); 
420         weiAmount = tokens.div(rateEarlyStage1);
421         backAmount = msg.value.sub(weiAmount);
422       }
423       totalEarlyStage = totalEarlyStage.add(tokens);
424     }
425     //EarlyStage2
426     if (now >= startEarlyStage2 && now < endEarlyStage2 && totalEarlyStage < maxEarlyStage){
427       tokens = weiAmount.mul(rateEarlyStage2);
428       if (maxEarlyStage.sub(totalEarlyStage) < tokens){
429         tokens = maxEarlyStage.sub(totalEarlyStage); 
430         weiAmount = tokens.div(rateEarlyStage2);
431         backAmount = msg.value.sub(weiAmount);
432       }
433       totalEarlyStage = totalEarlyStage.add(tokens);
434     }    
435     //EarlyStage3
436     if (now >= startEarlyStage3 && now < endEarlyStage3 && totalEarlyStage < maxEarlyStage){
437       tokens = weiAmount.mul(rateEarlyStage3);
438       if (maxEarlyStage.sub(totalEarlyStage) < tokens){
439         tokens = maxEarlyStage.sub(totalEarlyStage); 
440         weiAmount = tokens.div(rateEarlyStage3);
441         backAmount = msg.value.sub(weiAmount);
442       }
443       totalEarlyStage = totalEarlyStage.add(tokens);
444     }    
445     //EarlyStage4
446     if (now >= startEarlyStage4 && now < endEarlyStage4 && totalEarlyStage < maxEarlyStage){
447       tokens = weiAmount.mul(rateEarlyStage4);
448       if (maxEarlyStage.sub(totalEarlyStage) < tokens){
449         tokens = maxEarlyStage.sub(totalEarlyStage); 
450         weiAmount = tokens.div(rateEarlyStage4);
451         backAmount = msg.value.sub(weiAmount);
452       }
453       totalEarlyStage = totalEarlyStage.add(tokens);
454     }   
455     //FinalStage1
456     if (now >= startFinalStage1 && now < endFinalStage1 && totalFinalStage < maxFinalStage){
457       tokens = weiAmount.mul(rateFinalStage1);
458       if (maxFinalStage.sub(totalFinalStage) < tokens){
459         tokens = maxFinalStage.sub(totalFinalStage); 
460         weiAmount = tokens.div(rateFinalStage1);
461         backAmount = msg.value.sub(weiAmount);
462       }
463       totalFinalStage = totalFinalStage.add(tokens);
464     }       
465     //FinalStage2    
466     if (now >= startFinalStage2 && now < endFinalStage2 && totalFinalStage < maxFinalStage){
467       tokens = weiAmount.mul(rateFinalStage2);
468       if (maxFinalStage.sub(totalFinalStage) < tokens){
469         tokens = maxFinalStage.sub(totalFinalStage); 
470         weiAmount = tokens.div(rateFinalStage2);
471         backAmount = msg.value.sub(weiAmount);
472       }
473       totalFinalStage = totalFinalStage.add(tokens);
474     }        
475     
476     require(tokens > 0);
477     token.mint(beneficiary, tokens);
478     balances[msg.sender] = balances[msg.sender].add(msg.value);
479     //wallet.transfer(weiAmount);
480     
481     if (backAmount > 0){
482       msg.sender.transfer(backAmount);    
483     }
484     TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
485   }
486 
487   //Mint is allowed while TotalSupply <= totalTokens
488   function mintTokens(address _to, uint256 _amount) onlyOwner public returns (bool) {
489     require(_amount > 0);
490     require(_to != address(0));
491     require(now >= mintStart);
492     require(_amount <= totalTokens.sub(token.getTotalSupply()));
493     token.mint(_to, _amount);
494     return true;
495   }
496   
497   function refund() public{
498     require(this.balance < softcap && now > endFinalStage2);
499     require(balances[msg.sender] > 0);
500     uint value = balances[msg.sender];
501     balances[msg.sender] = 0;
502     msg.sender.transfer(value);
503   }
504   
505   function transferToMultisig() public onlyOwner {
506     require(this.balance >= softcap && now > endFinalStage2);  
507       wallet.transfer(this.balance);
508   }  
509 }