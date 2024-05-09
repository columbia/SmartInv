1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     int256 constant private INT256_MIN = -2**255;
10 
11     /**
12     * @dev Multiplies two unsigned integers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Multiplies two signed integers, reverts on overflow.
30     */
31     function mul(int256 a, int256 b) internal pure returns (int256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35         if (a == 0) {
36             return 0;
37         }
38 
39         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
40 
41         int256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
61     */
62     function div(int256 a, int256 b) internal pure returns (int256) {
63         require(b != 0); // Solidity only automatically asserts when dividing by 0
64         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
65 
66         int256 c = a / b;
67 
68         return c;
69     }
70 
71     /**
72     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73     */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82     * @dev Subtracts two signed integers, reverts on overflow.
83     */
84     function sub(int256 a, int256 b) internal pure returns (int256) {
85         int256 c = a - b;
86         require((b >= 0 && c <= a) || (b < 0 && c > a));
87 
88         return c;
89     }
90 
91     /**
92     * @dev Adds two unsigned integers, reverts on overflow.
93     */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         uint256 c = a + b;
96         require(c >= a);
97 
98         return c;
99     }
100 
101     /**
102     * @dev Adds two signed integers, reverts on overflow.
103     */
104     function add(int256 a, int256 b) internal pure returns (int256) {
105         int256 c = a + b;
106         require((b >= 0 && c >= a) || (b < 0 && c < a));
107 
108         return c;
109     }
110 
111     /**
112     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
113     * reverts when dividing by zero.
114     */
115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b != 0);
117         return a % b;
118     }
119 }
120 /**
121  * @title Ownable
122  * @dev The Ownable contract has an owner address, and provides basic authorization control
123  * functions, this simplifies the implementation of "user permissions".
124  */
125 contract Ownable {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132      * account.
133      */
134     constructor () internal {
135         _owner = msg.sender;
136         emit OwnershipTransferred(address(0), _owner);
137     }
138 
139     /**
140      * @return the address of the owner.
141      */
142     function owner() public view returns (address) {
143         return _owner;
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         require(isOwner());
151         _;
152     }
153 
154     /**
155      * @return true if `msg.sender` is the owner of the contract.
156      */
157     function isOwner() public view returns (bool) {
158         return msg.sender == _owner;
159     }
160 
161     /**
162      * @dev Allows the current owner to relinquish control of the contract.
163      * @notice Renouncing to ownership will leave the contract without an owner.
164      * It will not be possible to call the functions with the `onlyOwner`
165      * modifier anymore.
166      */
167     function renounceOwnership() public onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     /**
173      * @dev Allows the current owner to transfer control of the contract to a newOwner.
174      * @param newOwner The address to transfer ownership to.
175      */
176     function transferOwnership(address newOwner) public onlyOwner {
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers control of the contract to a newOwner.
182      * @param newOwner The address to transfer ownership to.
183      */
184     function _transferOwnership(address newOwner) internal {
185         require(newOwner != address(0));
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 /**
192  * @title ERC20 interface
193  * @dev see https://github.com/ethereum/EIPs/issues/20
194  */
195 interface IERC20 {
196     function totalSupply() external view returns (uint256);
197 
198     function balanceOf(address who) external view returns (uint256);
199 
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     function transfer(address to, uint256 value) external returns (bool);
203 
204     function approve(address spender, uint256 value) external returns (bool);
205 
206     function transferFrom(address from, address to, uint256 value) external returns (bool);
207 
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
218  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  *
220  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
221  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
222  * compliant implementations may not do it.
223  */
224 contract ERC20 is IERC20 {
225     using SafeMath for uint256;
226 
227     mapping (address => uint256) private _balances;
228 
229     mapping (address => mapping (address => uint256)) private _allowed;
230 
231     uint256 private _totalSupply;
232 
233     /**
234     * @dev Total number of tokens in existence
235     */
236     function totalSupply() public view returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241     * @dev Gets the balance of the specified address.
242     * @param owner The address to query the balance of.
243     * @return An uint256 representing the amount owned by the passed address.
244     */
245     function balanceOf(address owner) public view returns (uint256) {
246         return _balances[owner];
247     }
248 
249     /**
250      * @dev Function to check the amount of tokens that an owner allowed to a spender.
251      * @param owner address The address which owns the funds.
252      * @param spender address The address which will spend the funds.
253      * @return A uint256 specifying the amount of tokens still available for the spender.
254      */
255     function allowance(address owner, address spender) public view returns (uint256) {
256         return _allowed[owner][spender];
257     }
258 
259     /**
260     * @dev Transfer token for a specified address
261     * @param to The address to transfer to.
262     * @param value The amount to be transferred.
263     */
264     function transfer(address to, uint256 value) public returns (bool) {
265         _transfer(msg.sender, to, value);
266         return true;
267     }
268 
269     /**
270      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
271      * Beware that changing an allowance with this method brings the risk that someone may use both the old
272      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275      * @param spender The address which will spend the funds.
276      * @param value The amount of tokens to be spent.
277      */
278     function approve(address spender, uint256 value) public returns (bool) {
279         require(spender != address(0));
280 
281         _allowed[msg.sender][spender] = value;
282         emit Approval(msg.sender, spender, value);
283         return true;
284     }
285 
286     /**
287      * @dev Transfer tokens from one address to another.
288      * Note that while this function emits an Approval event, this is not required as per the specification,
289      * and other compliant implementations may not emit the event.
290      * @param from address The address which you want to send tokens from
291      * @param to address The address which you want to transfer to
292      * @param value uint256 the amount of tokens to be transferred
293      */
294     function transferFrom(address from, address to, uint256 value) public returns (bool) {
295         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
296         _transfer(from, to, value);
297         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
298         return true;
299     }
300 
301     /**
302      * @dev Increase the amount of tokens that an owner allowed to a spender.
303      * approve should be called when allowed_[_spender] == 0. To increment
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * Emits an Approval event.
308      * @param spender The address which will spend the funds.
309      * @param addedValue The amount of tokens to increase the allowance by.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
312         require(spender != address(0));
313 
314         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
315         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
316         return true;
317     }
318 
319     /**
320      * @dev Decrease the amount of tokens that an owner allowed to a spender.
321      * approve should be called when allowed_[_spender] == 0. To decrement
322      * allowed value is better to use this function to avoid 2 calls (and wait until
323      * the first transaction is mined)
324      * From MonolithDAO Token.sol
325      * Emits an Approval event.
326      * @param spender The address which will spend the funds.
327      * @param subtractedValue The amount of tokens to decrease the allowance by.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
330         require(spender != address(0));
331         
332         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
333         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
334         return true;
335     }
336 
337     /**
338     * @dev Transfer token for a specified addresses
339     * @param from The address to transfer from.
340     * @param to The address to transfer to.
341     * @param value The amount to be transferred.
342     */
343     function _transfer(address from, address to, uint256 value) internal {
344         require(to != address(0));
345 
346         _balances[from] = _balances[from].sub(value);
347         _balances[to] = _balances[to].add(value);
348         emit Transfer(from, to, value);
349     }
350 
351     /**
352      * @dev Internal function that mints an amount of the token and assigns it to
353      * an account. This encapsulates the modification of balances such that the
354      * proper events are emitted.
355      * @param account The account that will receive the created tokens.
356      * @param value The amount that will be created.
357      */
358     function _mint(address account, uint256 value) internal {
359         require(account != address(0));
360 
361         _totalSupply = _totalSupply.add(value);
362         _balances[account] = _balances[account].add(value);
363         emit Transfer(address(0), account, value);
364     }
365 
366     /**
367      * @dev Internal function that burns an amount of the token of a given
368      * account.
369      * @param account The account whose tokens will be burnt.
370      * @param value The amount that will be burnt.
371      */
372     function _burn(address account, uint256 value) internal {
373         require(account != address(0));
374 
375         _totalSupply = _totalSupply.sub(value);
376         _balances[account] = _balances[account].sub(value);
377         emit Transfer(account, address(0), value);
378     }
379 
380     /**
381      * @dev Internal function that burns an amount of the token of a given
382      * account, deducting from the sender's allowance for said account. Uses the
383      * internal burn function.
384      * Emits an Approval event (reflecting the reduced allowance).
385      * @param account The account whose tokens will be burnt.
386      * @param value The amount that will be burnt.
387      */
388     function _burnFrom(address account, uint256 value) internal {
389         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
390         _burn(account, value);
391         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
392     }
393 }
394 
395 /**
396  * @title ERC20Detailed token
397  * @dev The decimals are only for visualization purposes.
398  * All the operations are done using the smallest and indivisible token unit,
399  * just as on Ethereum all the operations are done in wei.
400  */
401 contract ERC20Detailed is ERC20 {
402     string private _name;
403     string private _symbol;
404     uint8 private _decimals;
405     uint256 private _initSupply;
406     
407     constructor (string name, string symbol, uint8 decimals, uint256 initSupply) public {
408         _name = name;
409         _symbol = symbol;
410         _decimals = decimals;
411         _initSupply = initSupply.mul(10 **uint256(decimals));
412     }
413 
414     /**
415      * @return the name of the token.
416      */
417     function name() public view returns (string) {
418         return _name;
419     }
420 
421     /**
422      * @return the symbol of the token.
423      */
424     function symbol() public view returns (string) {
425         return _symbol;
426     }
427 
428     /**
429      * @return the number of decimals of the token.
430      */
431     function decimals() public view returns (uint8) {
432         return _decimals;
433     }
434     /**
435      * @return the initial Supply of the token.
436      */
437     function initSupply() public view returns (uint256) {
438         return _initSupply;
439     }
440 }
441 
442 /**
443  * @title Helps contracts guard against reentrancy attacks.
444  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
445  * @dev If you mark a function `nonReentrant`, you should also
446  * mark it `external`.
447  */
448 contract ReentrancyGuard {
449     /// @dev counter to allow mutex lock with only one SSTORE operation
450     uint256 private _guardCounter;
451 
452     constructor () internal {
453         // The counter starts at one to prevent changing it from zero to a non-zero
454         // value, which is a more expensive operation.
455         _guardCounter = 1;
456     }
457 
458     /**
459      * @dev Prevents a contract from calling itself, directly or indirectly.
460      * Calling a `nonReentrant` function from another `nonReentrant`
461      * function is not supported. It is possible to prevent this from happening
462      * by making the `nonReentrant` function external, and make it call a
463      * `private` function that does the actual work.
464      */
465     modifier nonReentrant() {
466         _guardCounter += 1;
467         uint256 localCounter = _guardCounter;
468         _;
469         require(localCounter == _guardCounter);
470     }
471 }
472 
473 /**
474  * @title HRS
475  * @dev ERC20 Token 
476  */
477 contract HRS is ERC20, ERC20Detailed, Ownable, ReentrancyGuard  {
478    using SafeMath for uint256;
479    
480    mapping (address => bool) status; 
481    
482    // Address where funds can be collected
483     address private _walletP;
484     // Address where funds can be collected too
485     address private _walletN;
486     // How many token units a buyer gets per wei.
487     // The rate is the conversion between wei and the smallest and indivisible token unit.
488     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
489     // 1 wei will give you 1 unit, or 0.001 TOK.
490     uint256 private _rate;
491     // _rate multiply index
492     uint256 private _x;
493     // _rate share index
494     uint256 private _y;
495     // Amount of wei raised
496     uint256 private _weiRaised;
497     
498     /**
499      * @dev Constructor that gives msg.sender initialSupply of existing tokens.
500      */
501     constructor () public ERC20Detailed("HYDROSTANDART", "HRS", 18, 20000000
502     ) {
503         _mint(msg.sender, initSupply());
504     }
505 
506    /**
507      * @dev Function to mint tokens
508      * @param to The address that will receive the minted tokens.
509      * @param value The amount of tokens to mint.
510      * @return A boolean that indicates if the operation was successful.
511      */
512     function mint(address to, uint256 value) public onlyOwner returns (bool) {
513         _mint(to, value);
514         return true;
515     }
516     
517    /**
518      * @dev Function to burn tokens
519      * @param to The address to burn tokens.
520      * @param value The amount of tokens to burn.
521      * @return A boolean that indicates if the operation was successful.
522      */
523     function burn(address to, uint256 value) public onlyOwner returns (bool) {
524         _burn(to, value);
525         return true;
526     }
527    /**
528      * @dev check an account's status
529      * @return bool
530      */
531     function CheckStatus(address account) public view returns (bool) {
532         require(account != address(0));
533         bool currentStatus = status[account];
534         return currentStatus;
535     }
536     
537     /**
538      * @dev change an account's status. OnlyOwner
539      * @return bool
540      */
541     function ChangeStatus(address account) public  onlyOwner {
542         require(account != address(0));
543         bool currentStatus1 = status[account];
544        status[account] = (currentStatus1 == true) ? false : true;
545     }
546 
547    /**
548      * @dev fallback function ***DO NOT OVERRIDE***
549      * Note that other contracts will transfer fund with a base gas stipend
550      * of 2300, which is not enough to call buyTokens. Consider calling
551      * buyTokens directly when purchasing tokens from a contract.
552      */
553     function () external payable {
554         buyTokens(msg.sender, msg.value);
555         }
556     function buyTokens(address beneficiary, uint256 weiAmount) public nonReentrant payable {
557         require(beneficiary != address(0) && beneficiary !=_walletP && beneficiary !=_walletN);
558         require(weiAmount != 0);
559         require(_walletP != 0);
560         require(_walletN != 0);
561         require(CheckStatus(beneficiary) != true);
562         
563         // calculate token amount to be created
564         uint256 tokens = weiAmount.div(_y).mul(_x).mul(_rate);
565         // compass 
566         address CurrentFundWallet = (balanceOf(_walletP) > balanceOf(_walletN) == true) ? _walletP : _walletN;
567         // check token amount to be transfered from _wallet
568         require(balanceOf(CurrentFundWallet) > tokens);
569         // update state
570         _weiRaised = _weiRaised.add(weiAmount);
571         // transfer tokens to beneficiary from CurrentFundWallet
572        _transfer(CurrentFundWallet, beneficiary, tokens);
573        // transfer weiAmount to CurrentFundWallet
574        CurrentFundWallet.transfer(weiAmount);
575     }
576   
577     /**
578      * Set Rate. onlyOwner
579      */
580     function setRate(uint256 rate) public onlyOwner  {
581         require(rate > 1);
582         _rate = rate;
583     }
584     /**
585      * Set X. onlyOwner
586      */
587     function setX(uint256 x) public onlyOwner  {
588         require(x >= 1);
589         _x = x;
590     }
591     /**
592      * Set Y. onlyOwner
593      */
594     function setY(uint256 y) public onlyOwner  {
595         require(y >= 1);
596         _y = y;
597     }
598     /**
599      * Set the Positiv _wallet. onlyOwner
600      */
601     function setPositivWallet(address PositivWallet) public onlyOwner  {
602         _walletP = PositivWallet;
603     } 
604     
605     /**
606      * @return the Positiv _wallet.
607      */
608     function PositivWallet() public view returns (address) {
609         return _walletP;
610     }
611     /**
612      * Set the Negativ _wallet. onlyOwner
613      */
614     function setNegativWallet(address NegativWallet) public onlyOwner  {
615         _walletN = NegativWallet;
616     } 
617     
618     /**
619      * @return the Negativ _wallet.
620      */
621     function NegativWallet() public view returns (address) {
622         return _walletN;
623     }
624     /**
625      * @return Rate.
626      */
627     function Rate() public view returns (uint256) {
628         return _rate;
629     }
630     /**
631      * @return _X.
632      */
633     function X() public view returns (uint256) {
634         return _x;
635     }
636     /**
637      * @return _Y.
638      */
639     function Y() public view returns (uint256) {
640         return _y;
641     }
642     /**
643      * @return the number of wei income Total.
644      */
645     function WeiRaised() public view returns (uint256) {
646         return _weiRaised;
647     }
648     
649 }