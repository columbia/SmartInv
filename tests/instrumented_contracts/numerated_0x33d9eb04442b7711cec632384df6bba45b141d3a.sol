1 pragma solidity 0.4.25;
2 
3 /*
4 ▒ █ ▀ ▀ ▀ █ 　▒ █ ▀ ▀ █ 　░ █ ▀ ▀ █ 　▒ █ ▀ ▀ █ 　▒ █ ░ ▄ ▀ 　▒ █ ░ ░ ░ 　▒ █ ▀ ▀ ▀ 　
5 ░ ▀ ▀ ▀ ▄ ▄ 　▒ █ ▄ ▄ █ 　▒ █ ▄ ▄ █ 　▒ █ ▄ ▄ ▀ 　▒ █ ▀ ▄ ░ 　▒ █ ░ ░ ░ 　▒ █ ▀ ▀ ▀ 　
6 ▒ █ ▄ ▄ ▄ █ 　▒ █ ░ ░ ░ 　▒ █ ░ ▒ █ 　▒ █ ░ ▒ █ 　▒ █ ░ ▒ █ 　▒ █ ▄ ▄ █ 　▒ █ ▄ ▄ ▄ 　
7 
8 
9 ░ █ ▀ ▀ █ 　▀ █ ▀ 　▒ █ ▀ ▀ █ 　▒ █ ▀ ▀ ▄ 　▒ █ ▀ ▀ █ 　▒ █ ▀ ▀ ▀ █ 　▒ █ ▀ ▀ █ 　
10 ▒ █ ▄ ▄ █ 　▒ █ ░ 　▒ █ ▄ ▄ ▀ 　▒ █ ░ ▒ █ 　▒ █ ▄ ▄ ▀ 　▒ █ ░ ░ ▒ █ 　▒ █ ▄ ▄ █ 　
11 ▒ █ ░ ▒ █ 　▄ █ ▄ 　▒ █ ░ ▒ █ 　▒ █ ▄ ▄ ▀ 　▒ █ ░ ▒ █ 　▒ █ ▄ ▄ ▄ █ 　▒ █ ░ ░ ░ 　
12 
13 https://sparklemobile.io/  
14 
15 Contract can be paused and resumed, but that could also load/reload for later dates*
16 
17 
18 NOTES: 
19  ,_, _ In order to "claim tokens" you must first add our token contract address "0x4b7aD3a56810032782Afce12d7d27122bDb96efF"
20 [0,0] 
21 |)__)       
22 -”-”-
23 
24   ,_, _ Did you hear FREE Sparkle!
25 [0,0] 
26 |)__)       
27 -”-”- 1) Opposed to setting max number of airdrop winners I changed it to just give out the default airdrod reward to any
28 added address to the airdrop list(see note 3 below). When the tokens run out then the contract will not honor any
29 airdrop awards but can still be run and tokens added to continue using the contract for other giveaways.
30 
31 
32   ,_,  _ Follow us on Twitter!
33 [0,0] 
34 |)__)       
35 -”-”- 2) Added functions to allow adding address(es) with a different token reward than the standard 30 for those cases 
36 where some addresses we may want them to have more of an airdrop than the default
37 
38 
39   ,_,  _ Like us on Facebook 
40 [0,0] 
41 |)__)       
42 -”-”- 3) I tried to make sure that the general cases of people senting eth to the contract is reverted and not accepted
43 however I am not positive this can stop someone that is determined. With that said I did not add anything to withdraw
44 that potential eth so it would be stuck in this contract if someone happens to send the contract ETH...
45 
46 
47   ,_,  _ Join our Telegram and Discord!
48 [0,0] 
49 |)__)       
50 -”-”- 4)Contract was built with the intention of security in mind, all contracts are built with OpenZeppelin 2.0 latest release 
51 https://github.com/OpenZeppelin/openzeppelin-solidity/releases  
52 */
53 
54 contract Ownable {
55 
56     address public ownerField;
57 
58     constructor() public {
59         ownerField = msg.sender;
60     }
61 
62     modifier onlyOwner() {
63         require(msg.sender == ownerField, "Calling address not an owner");
64         _;
65     }
66 
67     function transferOwnership(address newOwner) public onlyOwner {
68         ownerField = newOwner;
69     }
70 
71     function owner() public view returns(address) {
72         return ownerField;
73     }
74 
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82   /**
83   * @dev Multiplies two numbers, reverts on overflow.
84   */
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87     // benefit is lost if 'b' is also tested.
88     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89     if (a == 0) {
90       return 0;
91     }
92 
93     uint256 c = a * b;
94     require(c / a == b);
95     return c;
96 
97   }
98 
99   /**
100   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b > 0); // Solidity only automatically asserts when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107 
108   }
109 
110   /**
111   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     require(b <= a);
115     uint256 c = a - b;
116     return c;
117   }
118 
119   /**
120   * @dev Adds two numbers, reverts on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     require(c >= a);
125     return c;
126   }
127 
128   /**
129   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
130   * reverts when dividing by zero.
131   */
132   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133     require(b != 0);
134     return a % b;
135   }
136 
137 }
138 
139 interface IERC20 {
140 
141   function totalSupply() external view returns (uint256);
142   function balanceOf(address who) external view returns (uint256);
143   function allowance(address owner, address spender) external view returns (uint256);
144   function transfer(address to, uint256 value) external returns (bool);
145   function approve(address spender, uint256 value) external returns (bool);
146   function transferFrom(address from, address to, uint256 value) external returns (bool);
147 
148   event Transfer(
149     address indexed from,
150     address indexed to,
151     uint256 value
152   );
153 
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 
160 }
161 
162 contract ERC20 is IERC20 {
163   using SafeMath for uint256;
164 
165   mapping (address => uint256) private _balances;
166   mapping (address => mapping (address => uint256)) private _allowed;
167 
168   uint256 private _totalSupply;
169 
170   /**
171   * @dev Total number of tokens in existence
172   */
173   function totalSupply() public view returns (uint256) {
174     return _totalSupply;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param owner The address to query the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address owner) public view returns (uint256) {
183     return _balances[owner];
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param owner address The address which owns the funds.
189    * @param spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192 
193   function allowance(
194     address owner,
195     address spender
196    )
197     public
198     view
199     returns (uint256)
200   {
201     return _allowed[owner][spender];
202   }
203 
204   /**
205   * @dev Transfer token for a specified address
206   * @param to The address to transfer to.
207   * @param value The amount to be transferred.
208   */
209   function transfer(address to, uint256 value) public returns (bool) {
210     _transfer(msg.sender, to, value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param spender The address which will spend the funds.
221    * @param value The amount of tokens to be spent.
222    */
223   function approve(address spender, uint256 value) public returns (bool) {
224     require(spender != address(0));
225 
226     _allowed[msg.sender][spender] = value;
227     emit Approval(msg.sender, spender, value);
228     return true;
229   }
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param from address The address which you want to send tokens from
234    * @param to address The address which you want to transfer to
235    * @param value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(
238     address from,
239     address to,
240     uint256 value
241   )
242     public
243     returns (bool)
244   {
245     require(value <= _allowed[from][msg.sender]);
246 
247     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
248     _transfer(from, to, value);
249 
250     return true;
251 
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed_[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param spender The address which will spend the funds.
261    * @param addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseAllowance(
264     address spender,
265     uint256 addedValue
266   )
267     public
268     returns (bool)
269 
270   {
271     require(spender != address(0));
272 
273     _allowed[msg.sender][spender] = (
274       _allowed[msg.sender][spender].add(addedValue));
275     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Decrease the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To decrement
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param subtractedValue The amount of tokens to decrease the allowance by.
287    */
288   function decreaseAllowance(
289     address spender,
290     uint256 subtractedValue
291   )
292     public
293     returns (bool)
294   {
295     require(spender != address(0));
296 
297     _allowed[msg.sender][spender] = (
298       _allowed[msg.sender][spender].sub(subtractedValue));
299     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
300 
301     return true;
302   }
303 
304   /**
305   * @dev Transfer token for a specified addresses
306   * @param from The address to transfer from.
307   * @param to The address to transfer to.
308   * @param value The amount to be transferred.
309   */
310 
311   function _transfer(address from, address to, uint256 value) internal {
312     require(value <= _balances[from], "Insignificant balance in from address");
313     require(to != address(0), "Invalid to address specified [0x0]");
314 
315     _balances[from] = _balances[from].sub(value);
316     _balances[to] = _balances[to].add(value);
317 
318     emit Transfer(from, to, value);
319   }
320 
321   /**
322    * @dev Internal function that mints an amount of the token and assigns it to
323    * an account. This encapsulates the modification of balances such that the
324    * proper events are emitted.
325    * @param account The account that will receive the created tokens.
326    * @param value The amount that will be created.
327    */
328   function _mint(address account, uint256 value) internal {
329     require(account != 0);
330 
331     _totalSupply = _totalSupply.add(value);
332     _balances[account] = _balances[account].add(value);
333 
334     emit Transfer(address(0), account, value);
335   }
336 
337 
338 
339   /**
340    * @dev Internal function that burns an amount of the token of a given
341    * account.
342    * @param account The account whose tokens will be burnt.
343    * @param value The amount that will be burnt.
344    */
345   function _burn(address account, uint256 value) internal {
346     require(account != 0);
347     require(value <= _balances[account]);
348 
349     _totalSupply = _totalSupply.sub(value);
350     _balances[account] = _balances[account].sub(value);
351 
352     emit Transfer(account, address(0), value);
353   }
354 
355   /**
356    * @dev Internal function that burns an amount of the token of a given
357    * account, deducting from the sender's allowance for said account. Uses the
358    * internal burn function.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362 
363   function _burnFrom(address account, uint256 value) internal {
364 
365     require(value <= _allowed[account][msg.sender]);
366 
367     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
368     // this function needs to emit an event with the updated approval.
369     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
370       value);
371     _burn(account, value);
372   }
373 
374 }
375 
376 contract Pausable is Ownable {
377     bool public paused;
378 
379     modifier ifNotPaused {
380         require(!paused, "Contract is paused");
381         _;
382     }
383 
384     modifier ifPaused {
385         require(paused, "Contract is not paused");
386         _;
387     }
388 
389     // Called by the owner on emergency, triggers paused state
390     function pause() external onlyOwner {
391         paused = true;
392     }
393 
394     // Called by the owner on end of emergency, returns to normal state
395     function resume() external onlyOwner ifPaused {
396         paused = false;
397     }
398 }
399 
400 contract AirDropWinners is Ownable, Pausable {
401 using SafeMath for uint256;
402 
403   struct Contribution {  
404     uint256 tokenAmount;
405     bool    wasClaimed;
406     bool    isValid;
407   }
408 
409 
410   address public tokenAddress;       //Smartcontract Address  
411   uint256 public totalTokensClaimed; // Totaltokens claimed by winners (you do not set this the contract does as tokens are claimed)
412   uint256 public startTime;          // airDrop Start time 
413    
414 
415   mapping (address => Contribution) contributions;
416 
417   constructor (address _token) 
418   Ownable() 
419   public {
420     tokenAddress = _token;
421     startTime = now;
422   }
423 
424   /**
425    * @dev getTotalTokensRemaining() provides the function of returning the number of
426    * tokens currently left in the airdrop balance
427    */
428   function getTotalTokensRemaining()
429   ifNotPaused
430   public
431   view
432   returns (uint256)
433   {
434     return ERC20(tokenAddress).balanceOf(this);
435   }
436 
437   /**
438    * @dev isAddressInAirdropList() provides the function of testing if the 
439    * specified address is in fact valid in the airdrop list
440    */
441   function isAddressInAirdropList(address _addressToLookUp)
442   ifNotPaused
443   public
444   view
445   returns (bool)
446   {
447     Contribution storage contrib = contributions[_addressToLookUp];
448     return contrib.isValid;
449   }
450 
451   /**
452    * @dev _bulkAddAddressesToAirdrop provides the function of adding addresses 
453    * to the airdrop list with the default of 30 sparkle
454    */
455   function bulkAddAddressesToAirDrop(address[] _addressesToAdd)
456   ifNotPaused
457   public
458   {
459     require(_addressesToAdd.length > 0);
460     for (uint i = 0; i < _addressesToAdd.length; i++) {
461       _addAddressToAirDrop(_addressesToAdd[i]);
462     }
463     
464   }
465 
466   /**
467    * @dev _bulkAddAddressesToAirdropWithAward provides the function of adding addresses 
468    * to the airdrop list with a specific number of tokens
469    */
470   function bulkAddAddressesToAirDropWithAward(address[] _addressesToAdd, uint256 _tokenAward)
471   ifNotPaused
472   public
473   {
474     require(_addressesToAdd.length > 0);
475     require(_tokenAward > 0);
476     for (uint i = 0; i < _addressesToAdd.length; i++) {
477       _addAddressToAirdropWithAward(_addressesToAdd[i], _tokenAward);
478     }
479     
480   }
481 
482   /**
483    * @dev _addAddressToAirdropWithAward provides the function of adding an address to the
484    * airdrop list with a specific number of tokens opposed to the default of  
485    * 30 Sparkle
486    * @dev NOTE: _tokenAward will be converted so value only needs to be whole number
487    * Ex: 30 opposed to 30 * (10e7)
488    */
489   function _addAddressToAirdropWithAward(address _addressToAdd, uint256 _tokenAward)
490   onlyOwner
491   internal
492   {
493       require(_addressToAdd != 0);
494       require(!isAddressInAirdropList(_addressToAdd));
495       require(_tokenAward > 0);
496       Contribution storage contrib = contributions[_addressToAdd];
497       contrib.tokenAmount = _tokenAward.mul(10e7);
498       contrib.wasClaimed = false;
499       contrib.isValid = true;
500   }
501 
502   /**
503    * @dev _addAddressToAirdrop provides the function of adding an address to the
504    * airdrop list with the default of 30 sparkle
505    */
506   function _addAddressToAirDrop(address _addressToAdd)
507   onlyOwner
508   internal
509   {
510       require(_addressToAdd != 0);
511       require(!isAddressInAirdropList(_addressToAdd));
512       Contribution storage contrib = contributions[_addressToAdd];
513       contrib.tokenAmount = 30 * 10e7;
514       contrib.wasClaimed = false;
515       contrib.isValid = true;
516   }
517 
518   /**
519    * @dev bulkRemoveAddressesFromAirDrop provides the function of removing airdrop 
520    * addresses from the airdrop list
521    */
522   function bulkRemoveAddressesFromAirDrop(address[] _addressesToRemove)
523   ifNotPaused
524   public
525   {
526     require(_addressesToRemove.length > 0);
527     for (uint i = 0; i < _addressesToRemove.length; i++) {
528       _removeAddressFromAirDrop(_addressesToRemove[i]);
529     }
530 
531   }
532 
533   /**
534    * @dev _removeAddressFromAirDrop provides the function of removing an address from 
535    * the airdrop
536    */
537   function _removeAddressFromAirDrop(address _addressToRemove)
538   onlyOwner
539   internal
540   {
541       require(_addressToRemove != 0);
542       require(isAddressInAirdropList(_addressToRemove));
543       Contribution storage contrib = contributions[_addressToRemove];
544       contrib.tokenAmount = 0;
545       contrib.wasClaimed = false;
546       contrib.isValid = false;
547   }
548 
549 function setAirdropAddressWasClaimed(address _addressToChange, bool _newWasClaimedValue)
550   ifNotPaused
551   onlyOwner
552   public
553   {
554     require(_addressToChange != 0);
555     require(isAddressInAirdropList(_addressToChange));
556     Contribution storage contrib = contributions[ _addressToChange];
557     require(contrib.isValid);
558     contrib.wasClaimed = _newWasClaimedValue;
559   }
560 
561   /**
562    * @dev claimTokens() provides airdrop winners the function of collecting their tokens
563    */
564   function claimTokens() 
565   ifNotPaused
566   public {
567     Contribution storage contrib = contributions[msg.sender];
568     require(contrib.isValid, "Address not found in airdrop list");
569     require(contrib.tokenAmount > 0, "There are currently no tokens to claim.");
570     uint256 tempPendingTokens = contrib.tokenAmount;
571     contrib.tokenAmount = 0;
572     totalTokensClaimed = totalTokensClaimed.add(tempPendingTokens);
573     contrib.wasClaimed = true;
574     ERC20(tokenAddress).transfer(msg.sender, tempPendingTokens);
575   }
576 
577   /**
578    * @dev () is the default payable function. Since this contract should not accept
579    * revert the transaction best as possible.
580    */
581   function() payable public {
582     revert("ETH not accepted");
583   }
584 
585 }
586 
587 contract SparkleAirDrop is AirDropWinners {
588   using SafeMath for uint256;
589 
590   address initTokenContractAddress = 0x4b7aD3a56810032782Afce12d7d27122bDb96efF;
591   
592   constructor()
593   AirDropWinners(initTokenContractAddress)
594   public  
595   {}
596 
597 }