1 pragma solidity ^0.4.19;
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
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
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
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 
222 contract MintableToken is StandardToken, Ownable {
223   event Mint(address indexed to, uint256 amount);
224   event MintFinished();
225 
226   bool public mintingFinished = false;
227 
228 
229   modifier canMint() {
230     require(!mintingFinished);
231     _;
232   }
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will receive the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     Transfer(address(0), _to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner public returns (bool) {
253     mintingFinished = true;
254     MintFinished();
255     return true;
256   }
257 }
258 
259 contract GOToken is MintableToken {	
260     
261   string public constant name = "GO Token";
262    
263   string public constant symbol = "GO";
264     
265   uint32 public constant decimals = 18;
266 
267   mapping(address => bool) public locked;
268 
269   modifier notLocked() {
270     require(msg.sender == owner || (mintingFinished && !locked[msg.sender]));
271     _;
272   }
273 
274   function lock(address to) public onlyOwner {
275     require(!mintingFinished);
276     locked[to] = true;
277   }
278   
279   function unlock(address to) public onlyOwner {
280     locked[to] = false;
281   }
282 
283   function retrieveTokens(address anotherToken) public onlyOwner {
284     ERC20 alienToken = ERC20(anotherToken);
285     alienToken.transfer(owner, alienToken.balanceOf(this));
286   }
287 
288   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
289     return super.transfer(_to, _value); 
290   }
291 
292   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
293     return super.transferFrom(from, to, value); 
294   }
295 
296 }
297 
298 contract CommonCrowdsale is Ownable {
299 
300   using SafeMath for uint256;
301 
302   uint public constant PERCENT_RATE = 100;
303 
304   uint public price = 5000000000000000000000;
305 
306   uint public minInvestedLimit = 100000000000000000;
307 
308   uint public maxInvestedLimit = 20000000000000000000;
309 
310   uint public hardcap = 114000000000000000000000;
311 
312   uint public start = 1513342800;
313 
314   uint public invested;
315   
316   uint public extraTokensPercent;
317 
318   address public wallet;
319 
320   address public directMintAgent;
321 
322   address public bountyTokensWallet;
323 
324   address public foundersTokensWallet;
325 
326   uint public bountyTokensPercent = 5;
327 
328   uint public foundersTokensPercent = 15;
329   
330   uint public index;
331  
332   bool public isITOFinished;
333 
334   bool public extraTokensTransferred;
335   
336   address[] public tokenHolders;
337   
338   mapping (address => uint) public balances;
339   
340   struct Milestone {
341     uint periodInDays;
342     uint discount;
343   }
344 
345   Milestone[] public milestones;
346 
347   GOToken public token = new GOToken();
348 
349   modifier onlyDirectMintAgentOrOwner() {
350     require(directMintAgent == msg.sender || owner == msg.sender);
351     _;
352   }
353 
354   modifier saleIsOn(uint value) {
355     require(value >= minInvestedLimit && now >= start && now < end() && invested < hardcap);
356     _;
357   }
358 
359   function tokenHoldersCount() public view returns(uint) {
360     return tokenHolders.length;
361   }
362 
363   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
364     directMintAgent = newDirectMintAgent;
365   }
366 
367   function setHardcap(uint newHardcap) public onlyOwner { 
368     hardcap = newHardcap;
369   }
370  
371   function setStart(uint newStart) public onlyOwner { 
372     start = newStart;
373   }
374 
375   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner { 
376     bountyTokensPercent = newBountyTokensPercent;
377   }
378 
379   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner { 
380     foundersTokensPercent = newFoundersTokensPercent;
381   }
382 
383   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner { 
384     bountyTokensWallet = newBountyTokensWallet;
385   }
386 
387   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner { 
388     foundersTokensWallet = newFoundersTokensWallet;
389   }
390 
391   function setWallet(address newWallet) public onlyOwner { 
392     wallet = newWallet;
393   }
394 
395   function setPrice(uint newPrice) public onlyOwner {
396     price = newPrice;
397   }
398 
399   function setMaxInvestedLimit(uint naxMinInvestedLimit) public onlyOwner {
400     maxInvestedLimit = naxMinInvestedLimit;
401   }
402 
403   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
404     minInvestedLimit = newMinInvestedLimit;
405   }
406  
407   function milestonesCount() public view returns(uint) {
408     return milestones.length;
409   }
410 
411   function end() public constant returns(uint) {
412     uint last = start;
413     for (uint i = 0; i < milestones.length; i++) {
414       Milestone storage milestone = milestones[i];
415       last += milestone.periodInDays * 1 days;
416     }
417     return last;
418   }
419 
420   function addMilestone(uint periodInDays, uint discount) public onlyOwner {
421     milestones.push(Milestone(periodInDays, discount));
422   }
423 
424   function setExtraTokensPercent(uint newExtraTokensPercent) public onlyOwner {
425     extraTokensPercent = newExtraTokensPercent;
426   }
427 
428   function payExtraTokens(uint count) public onlyOwner {
429     require(isITOFinished && !extraTokensTransferred);
430     if(extraTokensPercent == 0) {
431       extraTokensTransferred = true;
432     } else {
433       for(uint i = 0; index < tokenHolders.length && i < count; i++) {
434         address tokenHolder = tokenHolders[index];
435         uint value = token.balanceOf(tokenHolder);
436         if(value != 0) {
437           uint targetValue = value.mul(extraTokensPercent).div(PERCENT_RATE);
438           token.mint(this, targetValue);
439           token.transfer(tokenHolder, targetValue);
440         }
441         index++;
442       }
443       if(index == tokenHolders.length) extraTokensTransferred = true;
444     }
445   }
446 
447   function finishITO() public onlyOwner {
448     require(!isITOFinished);
449       
450     uint extendedTokensPercent = bountyTokensPercent.add(foundersTokensPercent);      
451     uint totalSupply = token.totalSupply();
452     uint allTokens = totalSupply.mul(PERCENT_RATE).div(PERCENT_RATE.sub(extendedTokensPercent));
453 
454     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
455     mint(bountyTokensWallet, bountyTokens);
456 
457     uint foundersTokens = allTokens.mul(foundersTokensPercent).div(PERCENT_RATE);
458     mint(foundersTokensWallet, foundersTokens);
459 
460     isITOFinished = true;
461   }
462 
463   function tokenOperationsFinished() public onlyOwner {
464     require(extraTokensTransferred);
465     token.finishMinting();
466     token.transferOwnership(owner);
467   }
468 
469   function getDiscount() public view returns(uint) {
470     uint prevTimeLimit = start;
471     for (uint i = 0; i < milestones.length; i++) {
472       Milestone storage milestone = milestones[i];
473       prevTimeLimit += milestone.periodInDays * 1 days;
474       if (now < prevTimeLimit)
475         return milestone.discount;
476     }
477     revert();
478   }
479 
480   function mint(address to, uint value) internal {
481     if(token.balanceOf(to) == 0) tokenHolders.push(to);
482     token.mint(to, value);
483   }
484 
485   function calculateAndTransferTokens(address to, uint investedInWei) internal {
486     invested = invested.add(msg.value);
487     uint tokens = investedInWei.mul(price.mul(PERCENT_RATE)).div(PERCENT_RATE.sub(getDiscount())).div(1 ether);
488     mint(to, tokens);
489     balances[to] = balances[to].add(investedInWei);
490     if(balances[to] >= maxInvestedLimit) token.lock(to);
491   }
492 
493   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn(investedWei) {
494     calculateAndTransferTokens(to, investedWei);
495   }
496 
497   function createTokens() public payable saleIsOn(msg.value) {
498     require(!isITOFinished);
499     wallet.transfer(msg.value);
500     calculateAndTransferTokens(msg.sender, msg.value);
501   }
502 
503   function() external payable {
504     createTokens();
505   }
506 
507   function retrieveTokens(address anotherToken) public onlyOwner {
508     ERC20 alienToken = ERC20(anotherToken);
509     alienToken.transfer(wallet, alienToken.balanceOf(this));
510   }
511   
512   function unlock(address to) public onlyOwner {
513     token.unlock(to);
514   }
515 
516 }
517 
518 contract GOTokenCrowdsale is CommonCrowdsale {
519 
520   function GOTokenCrowdsale() public {
521     hardcap = 114000000000000000000000;
522     price = 5000000000000000000000;
523     start = 1513342800;
524     wallet = 0x727436A7E7B836f3AB8d1caF475fAfEaeb25Ff27;
525     bountyTokensWallet = 0x38e4f2A7625A391bFE59D6ac74b26D8556d6361E;
526     foundersTokensWallet = 0x76A13d4F571107f363FF253E80706DAcE889aDED;
527     addMilestone(7, 30);
528     addMilestone(21, 15);
529     addMilestone(56, 0);
530   }
531 
532 }