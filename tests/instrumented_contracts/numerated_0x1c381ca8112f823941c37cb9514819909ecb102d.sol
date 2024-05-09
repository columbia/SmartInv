1 pragma solidity ^0.4.17;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) constant returns (uint256);
13   function transfer(address to, uint256 value) returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 
56 }
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62 
63   using SafeMath for uint256;
64 
65   modifier onlyPayloadSize(uint size) {
66     assert(msg.data.length == size + 4);
67     _;
68   }
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amout of tokens to be transfered
110    */
111   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_to] = balances[_to].add(_value);
118     balances[_from] = balances[_from].sub(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifing the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152 }
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160 
161   address public owner;
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner {
184     require(newOwner != address(0));
185     owner = newOwner;
186   }
187 
188 }
189 
190 /**
191  * @title Mintable token
192  * @dev Simple ERC20 Token example, with mintable token creation
193  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
194  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
195  */
196 
197 contract MintableToken is StandardToken, Ownable {
198 
199   event Mint(address indexed to, uint256 amount);
200   event MintFinished();
201 
202   bool public mintingFinished = false;
203   mapping (address => bool) public crowdsaleContracts;
204 
205   modifier canMint() {
206     require(!mintingFinished);
207     _;
208   }
209 
210   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
211 
212     totalSupply = totalSupply.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     Mint(_to, _amount);
215     Transfer(this, _to, _amount);
216     return true;
217   }
218 
219   function finishMinting() onlyOwner returns (bool) {
220     mintingFinished = true;
221     MintFinished();
222     return true;
223   }
224 
225 }
226 
227 contract BSEToken is MintableToken {
228 
229   string public constant name = " BLACK SNAIL ENERGY ";
230 
231   string public constant symbol = "BSE";
232 
233   uint32 public constant decimals = 18;
234 
235   event Burn(address indexed burner, uint256 value);
236 
237   /**
238    * @dev Burns a specific amount of tokens.
239    * @param _value The amount of token to be burned.
240    */
241   function burn(uint256 _value) public {
242     require(_value > 0);
243     require(_value <= balances[msg.sender]);
244     // no need to require value <= totalSupply, since that would imply the
245     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
246 
247     address burner = msg.sender;
248     balances[burner] = balances[burner].sub(_value);
249     totalSupply = totalSupply.sub(_value);
250     Burn(burner, _value);
251   }
252 
253 }
254 
255 contract ReentrancyGuard {
256 
257   /**
258    * @dev We use a single lock for the whole contract.
259    */
260   bool private rentrancy_lock = false;
261 
262   /**
263    * @dev Prevents a contract from calling itself, directly or indirectly.
264    * @notice If you mark a function `nonReentrant`, you should also
265    * mark it `external`. Calling one nonReentrant function from
266    * another is not supported. Instead, you can implement a
267    * `private` function doing the actual work, and a `external`
268    * wrapper marked as `nonReentrant`.
269    */
270   modifier nonReentrant() {
271     require(!rentrancy_lock);
272     rentrancy_lock = true;
273     _;
274     rentrancy_lock = false;
275   }
276 }
277 
278 contract Stateful {
279   enum State {
280   Init,
281   PreIco,
282   PreIcoPaused,
283   preIcoFinished,
284   ICO,
285   salePaused,
286   CrowdsaleFinished,
287   companySold
288   }
289   State public state = State.Init;
290 
291   event StateChanged(State oldState, State newState);
292 
293   function setState(State newState) internal {
294     State oldState = state;
295     state = newState;
296     StateChanged(oldState, newState);
297   }
298 }
299 
300 
301 contract FiatContract {
302   function ETH(uint _id) constant returns (uint256);
303   function USD(uint _id) constant returns (uint256);
304   function EUR(uint _id) constant returns (uint256);
305   function GBP(uint _id) constant returns (uint256);
306   function updatedAt(uint _id) constant returns (uint);
307 }
308 
309 contract Crowdsale is Ownable, ReentrancyGuard, Stateful {
310 
311   using SafeMath for uint;
312 
313   mapping (address => uint) preICOinvestors;
314   mapping (address => uint) ICOinvestors;
315 
316   BSEToken public token ;
317   uint256 public startICO;
318   uint256 public startPreICO;
319   uint256 public period;
320   uint256 public constant rateCent = 2000000000000000;
321   
322   uint256 public constant preICOTokenHardCap = 440000 * 1 ether;
323   uint256 public constant ICOTokenHardCap = 1540000 * 1 ether;
324   uint256 public collectedCent;
325   uint256 day = 86400; // sec in day
326   uint256 public soldTokens;
327   uint256 public priceUSD; // format 1 cent = priceUSD * wei
328 
329 
330   address multisig;
331   address public oracle;
332 
333 
334   modifier onlyOwnerOrOracle() {
335     require(msg.sender == oracle || msg.sender == owner);
336     _;
337   }
338 
339   function changeOracle(address _oracle) onlyOwner external {
340     require(_oracle != 0);
341     oracle = _oracle;
342   }
343 
344   modifier saleIsOn() {
345     require((state == State.PreIco || state == State.ICO) &&(now < startICO + period || now < startPreICO + period));
346     _;
347   }
348 
349   modifier isUnderHardCap() {
350     require(soldTokens < getHardcap());
351     _;
352   }
353 
354   function getHardcap() internal returns(uint256) {
355     if (state == State.PreIco) {
356       return preICOTokenHardCap;
357     }
358     else {
359       if (state == State.ICO) {
360         return ICOTokenHardCap;
361       }
362     }
363   }
364 
365 
366   function Crowdsale(address _multisig, uint256 _priceUSD) {
367     priceUSD = _priceUSD;
368     multisig = _multisig;
369     token = new BSEToken();
370 
371   }
372   function startCompanySell() onlyOwner {
373     require(state== State.CrowdsaleFinished);
374     setState(State.companySold);
375   }
376 
377   // for mint tokens to USD investor
378   function usdSale(address _to, uint _valueUSD) onlyOwner  {
379     uint256 valueCent = _valueUSD * 100;
380     uint256 tokensAmount = rateCent.mul(valueCent);
381     collectedCent += valueCent;
382     token.mint(_to, tokensAmount);
383     if (state == State.ICO || state == State.preIcoFinished) {
384       ICOinvestors[_to] += tokensAmount;
385     } else {
386       preICOinvestors[_to] += tokensAmount;
387     }
388     soldTokens += tokensAmount;
389   }
390 
391   function pauseSale() onlyOwner {
392     require(state == State.ICO);
393     setState(State.salePaused);
394   }
395 
396   function pausePreSale() onlyOwner {
397     require(state == State.PreIco);
398     setState(State.PreIcoPaused);
399   }
400 
401   function startPreIco(uint256 _period, uint256 _priceUSD) onlyOwner {
402     require(_period > 0);
403     require(state == State.Init || state == State.PreIcoPaused);
404     priceUSD = _priceUSD;
405     startPreICO = now;
406     period = _period * day;
407     setState(State.PreIco);
408   }
409 
410   function finishPreIco() onlyOwner {
411     require(state == State.PreIco);
412     setState(State.preIcoFinished);
413     bool isSent = multisig.call.gas(3000000).value(this.balance)();
414     require(isSent);
415   }
416 
417   function startIco(uint256 _period, uint256 _priceUSD) onlyOwner {
418     require(_period > 0);
419     require(state == State.PreIco || state == State.salePaused || state == State.preIcoFinished);
420     priceUSD = _priceUSD;
421     startICO = now;
422     period = _period * day;
423     setState(State.ICO);
424   }
425 
426   function setPriceUSD(uint256 _priceUSD) onlyOwnerOrOracle {
427     priceUSD = _priceUSD;
428   }
429 
430   function finishICO() onlyOwner {
431     require(state == State.ICO);
432     setState(State.CrowdsaleFinished);
433     bool isSent = multisig.call.gas(3000000).value(this.balance)();
434     require(isSent);
435 
436   }
437   function finishMinting() onlyOwner {
438 
439     token.finishMinting();
440 
441   }
442 
443   function getDouble() nonReentrant {
444     require (state == State.ICO || state == State.companySold);
445     uint256 extraTokensAmount;
446     if (state == State.ICO) {
447       extraTokensAmount = preICOinvestors[msg.sender];
448       preICOinvestors[msg.sender] = 0;
449       token.mint(msg.sender, extraTokensAmount);
450       ICOinvestors[msg.sender] += extraTokensAmount;
451     }
452     else {
453       if (state == State.companySold) {
454         extraTokensAmount = preICOinvestors[msg.sender] + ICOinvestors[msg.sender];
455         preICOinvestors[msg.sender] = 0;
456         ICOinvestors[msg.sender] = 0;
457         token.mint(msg.sender, extraTokensAmount);
458       }
459     }
460   }
461 
462 
463   function mintTokens() payable saleIsOn isUnderHardCap nonReentrant {
464     uint256 valueWEI = msg.value;
465     uint256 valueCent = valueWEI.div(priceUSD);
466     uint256 tokens = rateCent.mul(valueCent);
467     uint256 hardcap = getHardcap();
468     if (soldTokens + tokens > hardcap) {
469       tokens = hardcap.sub(soldTokens);
470       valueCent = tokens.div(rateCent);
471       valueWEI = valueCent.mul(priceUSD);
472       uint256 change = msg.value - valueWEI;
473       bool isSent = msg.sender.call.gas(3000000).value(change)();
474       require(isSent);
475     }
476     token.mint(msg.sender, tokens);
477     collectedCent += valueCent;
478     soldTokens += tokens;
479     if (state == State.PreIco) {
480       preICOinvestors[msg.sender] += tokens;
481     }
482     else {
483       ICOinvestors[msg.sender] += tokens;
484     }
485   }
486 
487   function () payable {
488     mintTokens();
489   }
490 }