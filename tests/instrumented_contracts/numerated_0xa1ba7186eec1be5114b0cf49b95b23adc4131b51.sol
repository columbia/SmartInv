1 // File: contracts/Ownable.sol
2 
3 pragma solidity 0.5.9;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/SafeMath.sol
78 
79 pragma solidity 0.5.9;
80 
81 /**
82  * @title SafeMath
83  * @dev Unsigned math operations with safety checks that revert on error
84  */
85 library SafeMath {
86     /**
87      * @dev Multiplies two unsigned integers, reverts on overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b);
99 
100         return c;
101     }
102 
103     /**
104      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Solidity only automatically asserts when dividing by 0
108         require(b > 0);
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Adds two unsigned integers, reverts on overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a);
131 
132         return c;
133     }
134 
135     /**
136      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
137      * reverts when dividing by zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b != 0);
141         return a % b;
142     }
143 }
144 
145 // File: contracts/IERC20.sol
146 
147 pragma solidity 0.5.9;
148 
149 /**
150  * @title ERC20 interface
151  * @dev see https://eips.ethereum.org/EIPS/eip-20
152  */
153 interface IERC20 {
154     function transfer(address to, uint256 value) external returns (bool);
155 
156     function approve(address spender, uint256 value) external returns (bool);
157 
158     function transferFrom(address from, address to, uint256 value) external returns (bool);
159 
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address who) external view returns (uint256);
163 
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 // File: contracts/ERC20.sol
172 
173 pragma solidity 0.5.9;
174 
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * https://eips.ethereum.org/EIPS/eip-20
182  * Originally based on code by FirstBlood:
183  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  *
185  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
186  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
187  * compliant implementations may not do it.
188  */
189 contract ERC20 is IERC20 {
190     using SafeMath for uint256;
191 
192     mapping (address => uint256) internal _balances;
193 
194     mapping (address => mapping (address => uint256)) private _allowed;
195 
196     uint256 internal _totalSupply;
197 
198     /**
199      * @dev Total number of tokens in existence
200      */
201     function totalSupply() public view returns (uint256) {
202         return _totalSupply;
203     }
204 
205     /**
206      * @dev Gets the balance of the specified address.
207      * @param owner The address to query the balance of.
208      * @return A uint256 representing the amount owned by the passed address.
209      */
210     function balanceOf(address owner) public view returns (uint256) {
211         return _balances[owner];
212     }
213 
214     /**
215      * @dev Function to check the amount of tokens that an owner allowed to a spender.
216      * @param owner address The address which owns the funds.
217      * @param spender address The address which will spend the funds.
218      * @return A uint256 specifying the amount of tokens still available for the spender.
219      */
220     function allowance(address owner, address spender) public view returns (uint256) {
221         return _allowed[owner][spender];
222     }
223 
224     /**
225      * @dev Transfer token to a specified address
226      * @param to The address to transfer to.
227      * @param value The amount to be transferred.
228      */
229     function transfer(address to, uint256 value) public returns (bool) {
230         _transfer(msg.sender, to, value);
231         return true;
232     }
233 
234     /**
235      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236      * Beware that changing an allowance with this method brings the risk that someone may use both the old
237      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      * @param spender The address which will spend the funds.
241      * @param value The amount of tokens to be spent.
242      */
243     function approve(address spender, uint256 value) public returns (bool) {
244         _approve(msg.sender, spender, value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another.
250      * Note that while this function emits an Approval event, this is not required as per the specification,
251      * and other compliant implementations may not emit the event.
252      * @param from address The address which you want to send tokens from
253      * @param to address The address which you want to transfer to
254      * @param value uint256 the amount of tokens to be transferred
255      */
256     function transferFrom(address from, address to, uint256 value) public returns (bool) {
257         _transfer(from, to, value);
258         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
259         return true;
260     }
261 
262     /**
263      * @dev Increase the amount of tokens that an owner allowed to a spender.
264      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
265      * allowed value is better to use this function to avoid 2 calls (and wait until
266      * the first transaction is mined)
267      * From MonolithDAO Token.sol
268      * Emits an Approval event.
269      * @param spender The address which will spend the funds.
270      * @param addedValue The amount of tokens to increase the allowance by.
271      */
272     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
273         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
274         return true;
275     }
276 
277     /**
278      * @dev Decrease the amount of tokens that an owner allowed to a spender.
279      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
280      * allowed value is better to use this function to avoid 2 calls (and wait until
281      * the first transaction is mined)
282      * From MonolithDAO Token.sol
283      * Emits an Approval event.
284      * @param spender The address which will spend the funds.
285      * @param subtractedValue The amount of tokens to decrease the allowance by.
286      */
287     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
288         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
289         return true;
290     }
291 
292     /**
293      * @dev Transfer token for a specified addresses
294      * @param from The address to transfer from.
295      * @param to The address to transfer to.
296      * @param value The amount to be transferred.
297      */
298     function _transfer(address from, address to, uint256 value) internal {
299         require(to != address(0));
300 
301         _balances[from] = _balances[from].sub(value);
302         _balances[to] = _balances[to].add(value);
303         emit Transfer(from, to, value);
304     }
305 
306     /**
307      * @dev Internal function that mints an amount of the token and assigns it to
308      * an account. This encapsulates the modification of balances such that the
309      * proper events are emitted.
310      * @param account The account that will receive the created tokens.
311      * @param value The amount that will be created.
312      */
313     function _mint(address account, uint256 value) internal {
314         require(account != address(0));
315 
316         _totalSupply = _totalSupply.add(value);
317         _balances[account] = _balances[account].add(value);
318         emit Transfer(address(0), account, value);
319     }
320 
321     /**
322      * @dev Internal function that burns an amount of the token of a given
323      * account.
324      * @param account The account whose tokens will be burnt.
325      * @param value The amount that will be burnt.
326      */
327     function _burn(address account, uint256 value) internal {
328         require(account != address(0));
329 
330         _totalSupply = _totalSupply.sub(value);
331         _balances[account] = _balances[account].sub(value);
332         emit Transfer(account, address(0), value);
333     }
334 
335     /**
336      * @dev Approve an address to spend another addresses' tokens.
337      * @param owner The address that owns the tokens.
338      * @param spender The address that will spend the tokens.
339      * @param value The number of tokens that can be spent.
340      */
341     function _approve(address owner, address spender, uint256 value) internal {
342         require(spender != address(0));
343         require(owner != address(0));
344 
345         _allowed[owner][spender] = value;
346         emit Approval(owner, spender, value);
347     }
348 
349     /**
350      * @dev Internal function that burns an amount of the token of a given
351      * account, deducting from the sender's allowance for said account. Uses the
352      * internal burn function.
353      * Emits an Approval event (reflecting the reduced allowance).
354      * @param account The account whose tokens will be burnt.
355      * @param value The amount that will be burnt.
356      */
357     function _burnFrom(address account, uint256 value) internal {
358         _burn(account, value);
359         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
360     }
361 }
362 
363 // File: contracts/ERC20Burnable.sol
364 
365 pragma solidity 0.5.9;
366 
367 
368 /**
369  * @title Burnable Token
370  * @dev Token that can be irreversibly burned (destroyed).
371  */
372 contract ERC20Burnable is ERC20 {
373     /**
374      * @dev Burns a specific amount of tokens.
375      * @param value The amount of token to be burned.
376      */
377     function burn(uint256 value) public {
378         _burn(msg.sender, value);
379     }
380 
381     /**
382      * @dev Burns a specific amount of tokens from the target address and decrements allowance
383      * @param from address The account whose tokens will be burned.
384      * @param value uint256 The amount of token to be burned.
385      */
386     function burnFrom(address from, uint256 value) public {
387         _burnFrom(from, value);
388     }
389 }
390 
391 // File: contracts/ERC20Mintable.sol
392 
393 pragma solidity 0.5.9;
394 
395 
396 
397 /**
398  * @title ERC20Mintable
399  * @dev ERC20 minting logic
400  */
401 contract ERC20Mintable is ERC20, Ownable {
402     /**
403      * @dev Function to mint tokens
404      * @param to The address that will receive the minted tokens.
405      * @param value The amount of tokens to mint.
406      * @return A boolean that indicates if the operation was successful.
407      */
408     function mint(address to, uint256 value) public onlyOwner returns (bool) {
409         _mint(to, value);
410         return true;
411     }
412 }
413 
414 // File: contracts/FTIToken.sol
415 
416 pragma solidity 0.5.9;
417 
418 
419 
420 contract FTIToken is ERC20Burnable, ERC20Mintable {
421   string public constant name = "FTI NEWS Token";
422   string public constant symbol = "TECH";
423   uint8 public constant decimals = 10;
424 
425   uint256 public constant initialSupply = 299540000 * (10 ** uint256(decimals)); 
426 
427   constructor () public {
428     _totalSupply = initialSupply;
429     _balances[0x8D44D27D2AF7BE632baA340eA52E443756ea1aD3] = initialSupply;
430   }
431 }
432 
433 // File: contracts/FTICrowdsale.sol
434 
435 pragma solidity 0.5.9;
436 
437 
438 
439 
440 contract FTICrowdsale is Ownable {
441   using SafeMath for uint256;
442 
443   uint256 public rate;
444   uint256 public minPurchase;
445   uint256 public maxSupply;
446 
447   // Tokens, reserved for owners
448   uint256 public stage1ReleaseTime;
449   uint256 public stage2ReleaseTime;
450   uint256 public stage3ReleaseTime;
451 
452   // Amount of reserved tokens
453   uint256 public stage1Amount;
454   uint256 public stage2Amount;
455   uint256 public stage3Amount;
456 
457   bool public stage1Released;
458   bool public stage2Released;
459   bool public stage3Released;
460 
461   /**
462    * @dev Money is sent to this wallet upon tokens purchase
463    */
464   address payable public wallet;
465 
466   bool public isPaused;
467 
468   FTIToken public token;
469 
470   constructor () public {
471     token = new FTIToken();
472 
473     minPurchase = 0.00000000000005 ether; // price of the minimum part of the token
474     rate = 0.000194 ether;
475 
476     maxSupply = 2395600000 * (10 ** 10); // 2395600000 * (10^(decimals))
477     wallet = 0x8D44D27D2AF7BE632baA340eA52E443756ea1aD3;
478 
479     stage1ReleaseTime = now + 180 days; // 6 months
480     stage2ReleaseTime = now + 270 days; // 9 months
481     stage3ReleaseTime = now + 365 days; // 12 months
482 
483     stage1Amount = 299540000 * (10 ** uint256(token.decimals()));
484     stage2Amount = 299540000 * (10 ** uint256(token.decimals()));
485     stage3Amount = 299540000 * (10 ** uint256(token.decimals()));
486   }
487 
488   /**
489    * @dev This function suspends the tokens purchase
490    */
491   function pause() public onlyOwner {
492     require(!isPaused, 'Sales must be not paused');
493     isPaused = true;
494   }
495 
496   /**
497    * @dev This function resumes the purchase of tokens
498    */
499   function unpause() public onlyOwner {
500     require(isPaused, 'Sales must be paused');
501     isPaused = false;
502   }
503 
504   /**
505    * @dev Function set new wallet address.
506    * @param newWallet Address of new wallet.
507    */
508   function changeWallet(address payable newWallet) public onlyOwner {
509     require(newWallet != address(0));
510     wallet = newWallet;
511   }
512 
513   /**
514    * @dev This function set new token owner.
515    */
516   function transferTokenOwnership(address newOwner) public onlyOwner {
517     require(newOwner != address(0));
518     token.transferOwnership(newOwner);
519   }
520 
521   /**
522    * @dev This function burn all unsold tokens.
523    */
524   function burnUnsold() public onlyOwner {
525     token.burn(token.balanceOf(address(this)));
526   }
527 
528   /**
529    * @dev This function releases tokens reserved for owners.
530    */
531   function releaseStage1() public onlyOwner {
532     require(now > stage1ReleaseTime, 'Release time has not come yet');
533     require(stage1Released != true, 'Tokens already released');
534 
535     stage1Released = true;
536     token.mint(wallet, stage1Amount);
537   }
538 
539   /**
540    * @dev This function releases tokens reserved for owners.
541    */
542   function releaseStage2() public onlyOwner {
543     require(now > stage2ReleaseTime, 'Release time has not come yet');
544     require(stage2Released != true, 'Tokens already released');
545 
546     stage2Released = true;
547     token.mint(wallet, stage2Amount);
548   }
549 
550   /**
551    * @dev This function releases tokens reserved for owners.
552    */
553   function releaseStage3() public onlyOwner {
554     require(now > stage3ReleaseTime, 'Release time has not come yet');
555     require(stage3Released != true, 'Tokens already released');
556 
557     stage3Released = true;
558     token.mint(wallet, stage3Amount);
559   }
560 
561   /**
562    * @dev Fallback function
563    */
564   function() external payable {
565     buyTokens();
566   }
567 
568   function buyTokens() public payable {
569     require(!isPaused, 'Sales are temporarily paused');
570 
571     address payable inv = msg.sender;
572     require(inv != address(0));
573 
574     uint256 weiAmount = msg.value;
575     require(weiAmount >= minPurchase, 'Amount of ether is not enough to buy even the smallest token part');
576 
577     uint256 cleanWei; // amount of wei to use for purchase excluding change and max supply overflows
578     uint256 change;
579     uint256 tokens;
580     uint256 tokensNoBonuses;
581     uint256 totalSupply;
582     uint256 supply;
583 
584     tokensNoBonuses = weiAmount.mul(1E10).div(rate);
585 
586     if (weiAmount >= 10 ether) {
587       tokens = tokensNoBonuses.mul(112).div(100);
588     } else if (weiAmount >= 5 ether) {
589       tokens = tokensNoBonuses.mul(105).div(100);
590     } else {
591       tokens = tokensNoBonuses;
592     }
593 
594     totalSupply = token.totalSupply();
595     supply = totalSupply.sub(token.balanceOf(address(this)));
596 
597     if (supply.add(tokens) > maxSupply) {
598       tokens = maxSupply.sub(supply);
599       require(tokens > 0, 'There are currently no tokens for sale');
600       if (tokens >= tokensNoBonuses) {
601         cleanWei = weiAmount;
602       } else {
603         cleanWei = tokens.mul(rate).div(1E10);
604         change = weiAmount.sub(cleanWei);
605       }
606     } else {
607       cleanWei = weiAmount;
608     }
609 
610     if (token.balanceOf(address(this)) >= tokens) {
611       token.transfer(inv, tokens);
612     } else if (token.balanceOf(address(this)) == 0) {
613       token.mint(inv, tokens);
614     } else {
615       uint256 mintAmount = tokens.sub(token.balanceOf(address(this)));
616 
617       token.mint(address(this), mintAmount);
618       token.transfer(inv, tokens);
619     }
620 
621     wallet.transfer(cleanWei);
622 
623     if (change > 0) {
624       inv.transfer(change); 
625     }
626   }
627 }