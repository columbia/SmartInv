1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   uint256 public totalSupply;
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     if (a == 0) {
67       return 0;
68     }
69     uint256 c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     // assert(b > 0); // Solidity automatically throws when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78     return c;
79   }
80 
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender]);
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public view returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 
226 contract KITToken is StandardToken, Ownable {
227 
228   using SafeMath for uint256;
229 
230   event Mint(address indexed to, uint256 amount);
231 
232   event MintFinished();
233 
234   string public constant name = 'KIT';
235 
236   string public constant symbol = 'KIT';
237 
238   uint32 public constant decimals = 18;
239 
240   bool public mintingFinished = false;
241 
242   address public saleAgent;
243 
244   modifier notLocked() {
245     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
246     _;
247   }
248 
249   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
250     return super.transfer(_to, _value);
251   }
252 
253   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
254     return super.transferFrom(from, to, value);
255   }
256 
257   function setSaleAgent(address newSaleAgent) public {
258     require(saleAgent == msg.sender || owner == msg.sender);
259     saleAgent = newSaleAgent;
260   }
261 
262   function mint(address _to, uint256 _amount) public returns (bool) {
263     require(!mintingFinished);
264     require(msg.sender == saleAgent);
265     totalSupply = totalSupply.add(_amount);
266     balances[_to] = balances[_to].add(_amount);
267     Mint(_to, _amount);
268     Transfer(address(0), _to, _amount);
269     return true;
270   }
271 
272   function finishMinting() public returns (bool) {
273     require(!mintingFinished);
274     require(msg.sender == owner || msg.sender == saleAgent);
275     mintingFinished = true;
276     MintFinished();
277     return true;
278   }
279 
280 }
281 
282 
283 contract LockableChanges is Ownable {
284 
285   bool public changesLocked;
286 
287   modifier notLocked() {
288     require(!changesLocked);
289     _;
290   }
291 
292   function lockChanges() public onlyOwner {
293     changesLocked = true;
294   }
295 
296 }
297 
298 
299 contract CommonCrowdsale is Ownable, LockableChanges {
300 
301   using SafeMath for uint256;
302 
303   uint public constant PERCENT_RATE = 100;
304 
305   uint public price;
306 
307   uint public minInvestedLimit;
308 
309   uint public hardcap;
310 
311   uint public start;
312 
313   uint public end;
314 
315   uint public invested;
316 
317   uint public minted;
318 
319   address public wallet;
320 
321   address public bountyTokensWallet;
322 
323   address public devTokensWallet;
324 
325   address public advisorsTokensWallet;
326 
327   address public foundersTokensWallet;
328 
329   uint public bountyTokensPercent;
330 
331   uint public devTokensPercent;
332 
333   uint public advisorsTokensPercent;
334 
335   uint public foundersTokensPercent;
336 
337   address public directMintAgent;
338 
339   struct Bonus {
340     uint periodInDays;
341     uint bonus;
342   }
343 
344   Bonus[] public bonuses;
345 
346   KITToken public token;
347 
348   modifier saleIsOn() {
349     require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);
350     _;
351   }
352 
353   function setHardcap(uint newHardcap) public onlyOwner {
354     hardcap = newHardcap;
355   }
356 
357   function setStart(uint newStart) public onlyOwner {
358     start = newStart;
359   }
360 
361   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
362     bountyTokensPercent = newBountyTokensPercent;
363   }
364 
365   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner {
366     advisorsTokensPercent = newAdvisorsTokensPercent;
367   }
368 
369   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner {
370     devTokensPercent = newDevTokensPercent;
371   }
372 
373   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
374     foundersTokensPercent = newFoundersTokensPercent;
375   }
376 
377   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
378     bountyTokensWallet = newBountyTokensWallet;
379   }
380 
381   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner {
382     advisorsTokensWallet = newAdvisorsTokensWallet;
383   }
384 
385   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner {
386     devTokensWallet = newDevTokensWallet;
387   }
388 
389   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
390     foundersTokensWallet = newFoundersTokensWallet;
391   }
392 
393   function setEnd(uint newEnd) public onlyOwner {
394     require(start < newEnd);
395     end = newEnd;
396   }
397 
398   function setToken(address newToken) public onlyOwner {
399     token = KITToken(newToken);
400   }
401 
402   function setWallet(address newWallet) public onlyOwner {
403     wallet = newWallet;
404   }
405 
406   function setPrice(uint newPrice) public onlyOwner {
407     price = newPrice;
408   }
409 
410   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
411     minInvestedLimit = newMinInvestedLimit;
412   }
413 
414   function bonusesCount() public constant returns(uint) {
415     return bonuses.length;
416   }
417 
418   function addBonus(uint limit, uint bonus) public onlyOwner {
419     bonuses.push(Bonus(limit, bonus));
420   }
421 
422   modifier onlyDirectMintAgentOrOwner() {
423     require(directMintAgent == msg.sender || owner == msg.sender);
424     _;
425   }
426 
427   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
428     directMintAgent = newDirectMintAgent;
429   }
430 
431   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
432     calculateAndTransferTokens(to, investedWei);
433   }
434 
435   function mintExtendedTokens() internal {
436     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent).add(foundersTokensPercent);
437     uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));
438     uint summaryTokens = extendedTokens.add(minted);
439 
440     uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
441     mintAndSendTokens(bountyTokensWallet, bountyTokens);
442 
443     uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
444     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
445 
446     uint foundersTokens = summaryTokens.mul(foundersTokensPercent).div(PERCENT_RATE);
447     mintAndSendTokens(foundersTokensWallet, foundersTokens);
448 
449     uint devTokens = extendedTokens.sub(bountyTokens).sub(advisorsTokens).sub(foundersTokens);
450     mintAndSendTokens(devTokensWallet, devTokens);
451   }
452 
453   function mintAndSendTokens(address to, uint amount) internal {
454     token.mint(to, amount);
455     minted = minted.add(amount);
456   }
457 
458   function calculateAndTransferTokens(address to, uint investedInWei) internal {
459     // update invested value
460     invested = invested.add(investedInWei);
461 
462     // calculate tokens
463     uint tokens = msg.value.mul(price).div(1 ether);
464     uint bonus = getBonus();
465     if (bonus > 0) {
466       tokens = tokens.add(tokens.mul(bonus).div(100));
467     }
468 
469     // transfer tokens
470     mintAndSendTokens(to, tokens);
471   }
472 
473   function getBonus() public constant returns(uint) {
474     uint prevTimeLimit = start;
475     for (uint i = 0; i < bonuses.length; i++) {
476       Bonus storage bonus = bonuses[i];
477       prevTimeLimit += bonus.periodInDays * 1 days;
478       if (now < prevTimeLimit)
479         return bonus.bonus;
480     }
481     return 0;
482   }
483 
484   function createTokens() public payable;
485 
486   function() external payable {
487     createTokens();
488   }
489 
490   function retrieveTokens(address anotherToken) public onlyOwner {
491     ERC20 alienToken = ERC20(anotherToken);
492     alienToken.transfer(wallet, alienToken.balanceOf(this));
493   }
494 
495 }
496 
497 
498 contract ICO is CommonCrowdsale {
499 
500   function ICO() public {
501     minInvestedLimit = 10000000000000000;
502     price = 909000000000000000000;
503     bountyTokensPercent = 3;
504     advisorsTokensPercent = 1;
505     devTokensPercent = 4;
506     foundersTokensPercent = 10;
507     hardcap = 67500000000000000000000;
508     addBonus(7,10);
509     addBonus(7,5);
510     start = 1519131600;
511     end = 1521550800;
512     wallet = 0x72EcAEB966176c50CfFc0Db53E4A2D3DbC0d538B;
513     bountyTokensWallet = 0x7E513B54e3a45B60d6f92c6CECE10C68977EEA8c;
514     foundersTokensWallet = 0x4227859C5A9Bb4391Cc4735Aa655e980a3DD4380;
515     advisorsTokensWallet = 0x6e740ef8618A7d822238F867c622373Df8B54a22;
516     devTokensWallet = 0xCaDca9387E12F55997F46870DA28F0af1626A6d4;
517   }
518 
519   function finishMinting() public onlyOwner {
520     mintExtendedTokens();
521     token.finishMinting();
522   }
523 
524   function createTokens() public payable saleIsOn {
525     calculateAndTransferTokens(msg.sender, msg.value);
526     wallet.transfer(msg.value);
527   }
528 
529 }