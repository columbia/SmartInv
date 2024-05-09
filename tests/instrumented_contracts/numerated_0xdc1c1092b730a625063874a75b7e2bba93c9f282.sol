1 // File: contracts/Ownable.sol
2 
3 // solium-disable linebreak-style
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() internal {
24         _owner = msg.sender;
25         emit OwnershipTransferred(address(0), _owner);
26     }
27 
28     /**
29     * @return the address of the owner.
30     */
31     function owner() public view returns(address) {
32         return _owner;
33     }
34 
35     /**
36     * @dev Throws if called by any account other than the owner.
37     */
38     modifier onlyOwner() {
39         require(isOwner());
40         _;
41     }
42 
43     /**
44     * @return true if `msg.sender` is the owner of the contract.
45     */
46     function isOwner() public view returns(bool) {
47         return msg.sender == _owner;
48     }
49 
50     /**
51     * @dev Allows the current owner to relinquish control of the contract.
52     * @notice Renouncing to ownership will leave the contract without an owner.
53     * It will not be possible to call the functions with the `onlyOwner`
54     * modifier anymore.
55     */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62     * @dev Allows the current owner to transfer control of the contract to a newOwner.
63     * @param newOwner The address to transfer ownership to.
64     */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70     * @dev Transfers control of the contract to a newOwner.
71     * @param newOwner The address to transfer ownership to.
72     */
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 // File: contracts/Pausable.sol
81 
82 // solium-disable linebreak-style
83 pragma solidity ^0.5.0;
84 
85 
86 /**
87  * @title Pausable
88  * @dev Base contract which allows children to implement an emergency stop mechanism.
89  */
90 contract Pausable is Ownable {
91 
92     bool public paused = false;
93 
94     /**
95     * @dev Modifier to make a function callable only when the contract is not paused.
96     */
97     modifier whenNotPaused() {
98         require(!paused);
99         _;
100     }
101 
102     /**
103     * @dev Modifier to make a function callable only when the contract is paused.
104     */
105     modifier whenPaused() {
106         require(paused);
107         _;
108     }
109 
110     /**
111     * @dev called by the owner to pause, triggers stopped state
112     */
113     function pause() public onlyOwner whenNotPaused {
114         paused = true;
115         emit Paused(msg.sender);
116     }
117 
118     /**
119     * @dev called by the owner to unpause, returns to normal state
120     */
121     function unpause() public onlyOwner whenPaused {
122         paused = false;
123         emit Unpaused(msg.sender);
124     }
125 
126     event Paused(address account);
127     event Unpaused(address account);
128 }
129 
130 // File: contracts/IERC20.sol
131 
132 // solium-disable linebreak-style
133 pragma solidity ^0.5.0;
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 interface IERC20 {
140 
141   function totalSupply() external view returns (uint256);
142 
143   function balanceOf(address who) external view returns (uint256);
144 
145   function allowance(address owner, address spender)
146     external view returns (uint256);
147 
148   function transfer(address to, uint256 value) external returns (bool);
149 
150   function approve(address spender, uint256 value)
151     external returns (bool);
152 
153   function transferFrom(address from, address to, uint256 value)
154     external returns (bool);
155 
156   event Transfer(
157     address indexed from,
158     address indexed to,
159     uint256 value
160   );
161 
162   event Approval(
163     address indexed owner,
164     address indexed spender,
165     uint256 value
166   );
167 }
168 
169 // File: contracts/SafeMath.sol
170 
171 // solium-disable linebreak-style
172 pragma solidity ^0.5.0;
173 
174 /**
175  * @title SafeMath
176  * @dev Math operations with safety checks that revert on error
177  */
178 library SafeMath {
179 
180     /**
181     * @dev Multiplies two numbers, reverts on overflow.
182     */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b);
193 
194         return c;
195     }
196 
197     /**
198     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
199     */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b > 0); // Solidity only automatically asserts when dividing by 0
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
210     */
211     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212         require(b <= a);
213         uint256 c = a - b;
214 
215         return c;
216     }
217 
218     /**
219     * @dev Adds two numbers, reverts on overflow.
220     */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a);
224 
225         return c;
226     }
227 
228     /**
229     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
230     * reverts when dividing by zero.
231     */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         require(b != 0);
234         return a % b;
235     }
236 }
237 
238 // File: contracts/ERC20.sol
239 
240 // solium-disable linebreak-style
241 pragma solidity ^0.5.0;
242 
243 
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
250  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract ERC20 is IERC20 {
253     using SafeMath for uint256;
254 
255     mapping (address => uint256) internal _balances;
256 
257     mapping (address => mapping (address => uint256)) internal _allowed;
258 
259     uint256 internal _totalSupply;
260 
261     /**
262     * @dev Total number of tokens in existence
263     */
264     function totalSupply() public view returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269     * @dev Gets the balance of the specified address.
270     * @param owner The address to query the balance of.
271     * @return An uint256 representing the amount owned by the passed address.
272     */
273     function balanceOf(address owner) public view returns (uint256) {
274         return _balances[owner];
275     }
276 
277     /**
278     * @dev Function to check the amount of tokens that an owner allowed to a spender.
279     * @param owner address The address which owns the funds.
280     * @param spender address The address which will spend the funds.
281     * @return A uint256 specifying the amount of tokens still available for the spender.
282     */
283     function allowance(
284         address owner,
285         address spender
286     )
287       public
288       view
289       returns (uint256)
290     {
291         return _allowed[owner][spender];
292     }
293 
294     /**
295     * @dev Transfer token for a specified address
296     * @param to The address to transfer to.
297     * @param value The amount to be transferred.
298     */
299     function transfer(address to, uint256 value) public returns (bool) {
300         _transfer(msg.sender, to, value);
301         return true;
302     }
303 
304     /**
305     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306     * Beware that changing an allowance with this method brings the risk that someone may use both the old
307     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
308     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
309     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310     * @param spender The address which will spend the funds.
311     * @param value The amount of tokens to be spent.
312     */
313     function approve(address spender, uint256 value) public returns (bool) {
314         require(spender != address(0));
315 
316         _allowed[msg.sender][spender] = value;
317         emit Approval(msg.sender, spender, value);
318         return true;
319     }
320 
321     /**
322     * @dev Transfer tokens from one address to another
323     * @param from address The address which you want to send tokens from
324     * @param to address The address which you want to transfer to
325     * @param value uint256 the amount of tokens to be transferred
326     */
327     function transferFrom(
328         address from,
329         address to,
330         uint256 value
331     )
332       public
333       returns (bool)
334     {
335         require(value <= _allowed[from][msg.sender]);
336 
337         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
338         _transfer(from, to, value);
339         return true;
340     }
341 
342     /**
343     * @dev Increase the amount of tokens that an owner allowed to a spender.
344     * approve should be called when allowed_[_spender] == 0. To increment
345     * allowed value is better to use this function to avoid 2 calls (and wait until
346     * the first transaction is mined)
347     * From MonolithDAO Token.sol
348     * @param spender The address which will spend the funds.
349     * @param addedValue The amount of tokens to increase the allowance by.
350     */
351     function increaseAllowance(
352         address spender,
353         uint256 addedValue
354     )
355       public
356       returns (bool)
357     {
358         require(spender != address(0));
359 
360         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
361         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
362         return true;
363     }
364 
365     /**
366     * @dev Decrease the amount of tokens that an owner allowed to a spender.
367     * approve should be called when allowed_[_spender] == 0. To decrement
368     * allowed value is better to use this function to avoid 2 calls (and wait until
369     * the first transaction is mined)
370     * From MonolithDAO Token.sol
371     * @param spender The address which will spend the funds.
372     * @param subtractedValue The amount of tokens to decrease the allowance by.
373     */
374     function decreaseAllowance(
375         address spender,
376         uint256 subtractedValue
377     )
378       public
379       returns (bool)
380     {
381         require(spender != address(0));
382 
383         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
384         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
385         return true;
386     }
387 
388     /**
389     * @dev Transfer token for a specified addresses
390     * @param from The address to transfer from.
391     * @param to The address to transfer to.
392     * @param value The amount to be transferred.
393     */
394     function _transfer(address from, address to, uint256 value) internal {
395         require(value <= _balances[from]);
396         require(to != address(0));
397 
398         _balances[from] = _balances[from].sub(value);
399         _balances[to] = _balances[to].add(value);
400         emit Transfer(from, to, value);
401     }
402   
403 }
404 
405 // File: contracts/ERC20Mintable.sol
406 
407 // solium-disable linebreak-style
408 pragma solidity ^0.5.0;
409 
410 
411 /**
412  * @title ERC20Mintable
413  * @dev ERC20 minting logic
414  */
415 contract ERC20Mintable is ERC20 {
416     
417     /**
418     * @dev Internal function that mints an amount of the token and assigns it to
419     * an account. This encapsulates the modification of balances such that the
420     * proper events are emitted.
421     * @param account The account that will receive the created tokens.
422     * @param value The amount that will be created.
423     */
424     function _mint(address account, uint256 value) internal {
425         require(account != address(0));
426         _totalSupply = _totalSupply.add(value);
427         _balances[account] = _balances[account].add(value);
428         emit Transfer(address(0), account, value);
429         emit Mint(account, msg.sender, value);
430     }
431 
432     event Mint(address indexed to, address indexed minter, uint256 value);
433 }
434 
435 // File: contracts/ERC20Burnable.sol
436 
437 // solium-disable linebreak-style
438 pragma solidity ^0.5.0;
439 
440 
441 /**
442  * @title Burnable Token
443  * @dev Token that can be irreversibly burned (destroyed).
444  */
445 contract ERC20Burnable is ERC20 {
446     /**
447     * @dev Internal function that burns an amount of the token of a given
448     * account.
449     * @param account The account whose tokens will be burnt.
450     * @param value The amount that will be burnt.
451     */
452     function _burn(address account, uint256 value) internal {
453         require(account != address(0));
454         require(value <= _balances[account]);
455 
456         _totalSupply = _totalSupply.sub(value);
457         _balances[account] = _balances[account].sub(value);
458         emit Transfer(account, address(0), value);
459         emit Burn(account, msg.sender, value);
460     }
461 
462     event Burn(address indexed from, address indexed burner, uint256 value);
463 }
464 
465 // File: contracts/TokenDetails.sol
466 
467 // solium-disable linebreak-style
468 pragma solidity ^0.5.0;
469 
470 
471 contract TokenDetails {
472 
473     string internal _name;
474     string internal _symbol;
475     
476     /**
477     * @return the name of the token.
478     */
479     function name() public view returns(string memory) {
480         return _name;
481     }
482 
483     /**
484     * @return the symbol of the token.
485     */
486     function symbol() public view returns(string memory) {
487         return _symbol;
488     }
489 
490 }
491 
492 // File: contracts/ERC20Details.sol
493 
494 // solium-disable linebreak-style
495 pragma solidity ^0.5.0;
496 
497 
498 contract ERC20Details is TokenDetails {
499 
500     uint8 internal _decimals;
501 
502     /**
503     * @return the number of decimals of the token.
504     */
505     function decimals() public view returns(uint8) {
506         return _decimals;
507     }
508 
509 }
510 
511 // File: contracts/XmedBaseLoyaltyToken.sol
512 
513 // solium-disable linebreak-style
514 pragma solidity ^0.5.0;
515 
516 
517 
518 
519 
520 
521 contract XmedBaseLoyaltyToken is Pausable, ERC20Mintable, ERC20Burnable, ERC20Details {
522 
523     /**
524     * @param _tokenSymbol token symbol
525     * @param _tokenName token name
526     * @param _tokenDecimals token decimals
527     */
528     constructor(
529         string memory _tokenSymbol,
530         string memory _tokenName,
531         uint8 _tokenDecimals
532         ) public {
533         _symbol = _tokenSymbol;
534         _name = _tokenName;
535         _decimals = _tokenDecimals;
536     }
537 
538     // Function that handles change of total supply.
539     // Intended to be overriden in child contracts.
540     // Call super.onTotalSupplyChange in child contract overriden method to invoke the event.
541     function onTotalSupplyChange() internal {
542         emit TotalSupplyChanged();
543     }
544 
545     function award(address to, uint256 loyaltyAmount) public onlyOwner {
546         _mint(to, loyaltyAmount);
547         emit Award(to, _symbol, loyaltyAmount);
548         onTotalSupplyChange();
549     }
550 
551     function redeem(address from, uint256 loyaltyAmount) public onlyOwner {
552         _burn(from, loyaltyAmount);
553         emit Redeem(from, _symbol, loyaltyAmount);
554         onTotalSupplyChange();
555     }
556 
557     function burn(uint256 amount) public onlyOwner {
558         _burn(msg.sender, amount);
559         emit Burn(_symbol, amount);
560         onTotalSupplyChange();
561     }
562 
563     // emitted when the award method is called
564     event Award(address to, string tokenSymbol, uint256 tokenAmount);
565     // emitted when the redeem method is called
566     event Redeem(address from, string tokenSymbol, uint256 tokenAmount);
567     // emitted when the burn method is called
568     event Burn(string tokenSymbol, uint256 tokenAmount);
569     // emitted when the total supply is changed
570     event TotalSupplyChanged();
571 }
572 
573 // File: contracts\XmedLoyaltyToken.sol
574 
575 // solium-disable linebreak-style
576 pragma solidity ^0.5.0;
577 
578 
579 contract XmedLoyaltyToken is XmedBaseLoyaltyToken {
580 
581     /**
582     * @param _tokenSymbol token symbol
583     * @param _tokenName token name
584     * @param _tokenDecimals token decimals
585     */
586     constructor(
587         string memory _tokenSymbol,
588         string memory _tokenName,
589         uint8 _tokenDecimals
590         ) XmedBaseLoyaltyToken(_tokenSymbol, _tokenName, _tokenDecimals) public {
591 
592         }
593 
594     /**
595     *
596     * Classic transfer from except if the msg.sender is the contract owner,
597     * it skips the allowances.
598     *
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 value
604     )
605       public
606       returns (bool)
607     {
608         if (msg.sender == owner()){
609             _transfer(from, to, value);
610             return true;
611         }
612 
613         require(value <= _allowed[from][msg.sender]);
614 
615         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
616         _transfer(from, to, value);
617         return true;
618     }
619 }