1 pragma solidity 0.5.14;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplie two unsigned integers, revert on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Add two unsigned integers, revert on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /*
59  * @dev Provides information about the current execution context, including the
60  * sender of the transaction and its data. While these are generally available
61  * via msg.sender and msg.data, they should not be accessed in such a direct
62  * manner, since when dealing with GSN meta-transactions the account sending and
63  * paying for execution may not be the actual sender (as far as an application
64  * is concerned).
65  *
66  * This contract is only required for intermediate, library-like contracts.
67  */
68 contract Context {
69     // Empty internal constructor, to prevent people from mistakenly deploying
70     // an instance of this contract, which should be used via inheritance.
71     constructor () internal { }
72 
73     function _msgSender() internal view returns (address payable) {
74         return msg.sender;
75     }
76 
77     function _msgData() internal view returns (bytes memory) {
78         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
79         return msg.data;
80     }
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev See https://eips.ethereum.org/EIPS/eip-20
86  */
87 interface IERC20 {
88     function transfer(address to, uint256 value) external returns (bool); 
89 
90     function approve(address spender, uint256 value) external returns (bool); 
91 
92     function transferFrom(address from, address to, uint256 value) external returns (bool); 
93 
94     function totalSupply() external view returns (uint256); 
95 
96     function balanceOf(address who) external view returns (uint256);
97 
98     function allowance(address owner, address spender) external view returns (uint256); 
99 
100     event Transfer(address indexed from, address indexed to, uint256 value); 
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value); 
103 }
104 
105 
106 /**
107  * @title Standard ERC20 token
108  * @dev Implementation of the basic standard token.
109  */
110 contract StandardToken is IERC20, Context {
111     using SafeMath for uint256; 
112     
113     mapping (address => uint256) internal _balances; 
114     mapping (address => mapping (address => uint256)) internal _allowed; 
115     
116     uint256 internal _totalSupply; 
117     
118     /**
119      * @dev Total number of tokens in existence.
120      */
121     function totalSupply() public view returns (uint256) {
122         return _totalSupply; 
123     }
124 
125     /**
126      * @dev Get the balance of the specified address.
127      * @param owner The address to query the balance of.
128      * @return A uint256 representing the amount owned by the passed address.
129      */
130     function balanceOf(address owner) public view returns (uint256) {
131         return _balances[owner];
132     }
133 
134     /**
135      * @dev Function to check the amount of tokens that an owner allowed to a spender.
136      * @param owner The address which owns the funds.
137      * @param spender The address which will spend the funds.
138      * @return A uint256 specifying the amount of tokens still available for the spender.
139      */
140     function allowance(address owner, address spender) public view returns (uint256) {
141         return _allowed[owner][spender];
142     }
143 
144     /**
145      * @dev Transfer tokens to a specified address.
146      * @param to The address to transfer to.
147      * @param value The amount to be transferred.
148      */
149     function transfer(address to, uint256 value) public returns (bool) {
150         _transfer(_msgSender(), to, value);
151         return true;
152     }
153 
154     /**
155      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156      * Beware that changing an allowance with this method brings the risk that someone may use both the old
157      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      * @param spender The address which will spend the funds.
161      * @param value The amount of tokens to be spent.
162      */
163     function approve(address spender, uint256 value) public returns (bool) {
164         _approve(_msgSender(), spender, value); 
165         return true;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another.
170      * Note that while this function emits an Approval event, this is not required as per the specification,
171      * and other compliant implementations may not emit the event.
172      * @param from The address which you want to send tokens from.
173      * @param to The address which you want to transfer to.
174      * @param value The amount of tokens to be transferred.
175      */
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _transfer(from, to, value); 
178         _approve(from, _msgSender(), _allowed[from][_msgSender()].sub(value)); 
179         return true;
180     }
181 
182     /**
183      * @dev Increase the amount of tokens that an owner allowed to a spender.
184      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param addedValue The amount of tokens to increase the allowance by.
191      */
192     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193         _approve(_msgSender(), spender, _allowed[_msgSender()][spender].add(addedValue)); 
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         _approve(_msgSender(), spender, _allowed[_msgSender()][spender].sub(subtractedValue));
209         return true;
210     }
211 
212     /**
213      * @dev Transfer tokens for a specified address.
214      * @param from The address to transfer from.
215      * @param to The address to transfer to.
216      * @param value The amount to be transferred.
217      */
218     function _transfer(address from, address to, uint256 value) internal {
219         require(to != address(0), "Cannot transfer to the zero address"); 
220         _balances[from] = _balances[from].sub(value); 
221         _balances[to] = _balances[to].add(value); 
222         emit Transfer(from, to, value); 
223     }
224 
225     /**
226      * @dev Approve an address to spend another addresses' tokens.
227      * @param owner The address that owns the tokens.
228      * @param spender The address that will spend the tokens.
229      * @param value The number of tokens that can be spent.
230      */
231     function _approve(address owner, address spender, uint256 value) internal {
232         require(spender != address(0), "Cannot approve to the zero address"); 
233         require(owner != address(0), "Setter cannot be the zero address"); 
234 	    _allowed[owner][spender] = value;
235         emit Approval(owner, spender, value); 
236     }
237 
238     /**
239      * @dev Destroys `amount` tokens from `account`, reducing the
240      * total supply.
241      *
242      * Emits a {Transfer} event with `to` set to the zero address.
243      *
244      * Requirements
245      *
246      * - `account` cannot be the zero address.
247      * - `account` must have at least `amount` tokens.
248      */
249     function _burn(address account, uint256 amount) internal {
250         require(account != address(0), "burn from the zero address");
251         _balances[account] = _balances[account].sub(amount);
252         _totalSupply = _totalSupply.sub(amount);
253         emit Transfer(account, address(0), amount);
254     }
255 
256     /**
257      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
258      * from the caller's allowance.
259      *
260      * See {_burn} and {_approve}.
261      */
262     function _burnFrom(address account, uint256 amount) internal {
263         _burn(account, amount);
264         _approve(account, _msgSender(), _allowed[account][_msgSender()].sub(amount));
265     }
266 
267 }
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * This module is used through inheritance. It will make available the modifier
275  * `onlyOwner`, which can be applied to your functions to restrict their use to
276  * the owner.
277  */
278 contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor () internal {
287         address msgSender = _msgSender();
288         _owner = msgSender;
289         emit OwnershipTransferred(address(0), msgSender);
290     }
291 
292     /**
293      * @dev Returns the address of the current owner.
294      */
295     function owner() public view returns (address) {
296         return _owner;
297     }
298 
299     /**
300      * @dev Throws if called by any account other than the owner.
301      */
302     modifier onlyOwner() {
303         require(isOwner(), "Ownable: caller is not the owner");
304         _;
305     }
306 
307     /**
308      * @dev Returns true if the caller is the current owner.
309      */
310     function isOwner() public view returns (bool) {
311         return _msgSender() == _owner;
312     }
313 
314     /**
315      * @dev Leaves the contract without owner. It will not be possible to call
316      * `onlyOwner` functions anymore. Can only be called by the current owner.
317      *
318      * NOTE: Renouncing ownership will leave the contract without an owner,
319      * thereby removing any functionality that is only available to the owner.
320      */
321     function renounceOwnership() public onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public onlyOwner {
331         _transferOwnership(newOwner);
332     }
333 
334     /**
335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
336      */
337     function _transferOwnership(address newOwner) internal {
338         require(newOwner != address(0), "Ownable: new owner is the zero address");
339         emit OwnershipTransferred(_owner, newOwner);
340         _owner = newOwner;
341     }
342 }
343 
344 /**
345  * @dev Contract module which allows children to implement an emergency stop
346  * mechanism that can be triggered by an authorized account.
347  *
348  * This module is used through inheritance. It will make available the
349  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
350  * the functions of your contract. Note that they will not be pausable by
351  * simply including this module, only once the modifiers are put in place.
352  */
353 contract Pausable is Ownable {
354     /**
355      * @dev Emitted when the pause is triggered by a pauser (`account`).
356      */
357     event Paused(address account);
358 
359     /**
360      * @dev Emitted when the pause is lifted by a pauser (`account`).
361      */
362     event Unpaused(address account);
363 
364     bool private _paused;
365 
366     /**
367      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
368      * to the deployer.
369      */
370     constructor () internal {
371         _paused = false;
372     }
373 
374     /**
375      * @dev Returns true if the contract is paused, and false otherwise.
376      */
377     function paused() public view returns (bool) {
378         return _paused;
379     }
380 
381     /**
382      * @dev Modifier to make a function callable only when the contract is not paused.
383      */
384     modifier whenNotPaused() {
385         require(!_paused, "Pausable: paused");
386         _;
387     }
388 
389     /**
390      * @dev Modifier to make a function callable only when the contract is paused.
391      */
392     modifier whenPaused() {
393         require(_paused, "Pausable: not paused");
394         _;
395     }
396 
397     /**
398      * @dev Called by a pauser to pause, triggers stopped state.
399      */
400     function Pause() public whenNotPaused onlyOwner {
401         _paused = true;
402         emit Paused(_msgSender());
403     }
404 
405     /**
406      * @dev Called by a pauser to unpause, returns to normal state.
407      */
408     function Unpause() public whenPaused onlyOwner {
409         _paused = false;
410         emit Unpaused(_msgSender());
411     }
412 }
413 
414 contract Burnable is StandardToken {
415     function burn(uint256 amount) public {
416         _burn(_msgSender(), amount);
417     }
418 
419     function burnFrom(address account, uint256 amount) public {
420         _burnFrom(account, amount);
421     }
422 }
423 
424 contract Freezable is Ownable {
425     mapping(address=>bool) public frozenAccount;
426     event Frozen(address indexed target, bool frozen);
427   
428     function frozenCheck(address target) internal view {
429         require(!frozenAccount[target], "Freezable: Account is frozen!");
430     }
431   
432     function freezeAccount(address target, bool frozen) public onlyOwner {
433   	    frozenAccount[target] = frozen;
434   	    emit Frozen(target, frozen);
435     }
436 }
437 
438 contract TWEEToken is StandardToken, Pausable, Burnable, Freezable {
439     string public constant name = "Tweebaa";  
440     string public constant symbol = "TWEE";  
441     uint8 public constant decimals = 18;
442     uint256 internal constant INIT_TOTALSUPPLY = 2000000000; 
443     address public constant tokenWallet = 0xa1bF6B4996a10cfBA2a8d4c9F6ac803575Bc780A;
444     
445     /**
446      * @dev Constructor, initialize the basic information of contract.
447      */
448     constructor() public {
449         _totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
450         _balances[tokenWallet] = _totalSupply;
451         emit Transfer(address(0), tokenWallet, _totalSupply);
452     }
453 
454     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
455         frozenCheck(_msgSender());
456         frozenCheck(_to);
457         return super.transfer(_to, _value);
458     }
459 
460     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused  returns (bool) {
461         frozenCheck(_msgSender());
462         frozenCheck(_from);
463         frozenCheck(_to);
464         return super.transferFrom(_from, _to, _value);
465     }
466 
467     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
468         return super.approve(_spender, _value);
469     }
470 
471     function increaseAllowance(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
472         return super.increaseAllowance(_spender, _addedValue);
473     }
474 
475     function decreaseAllowance(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
476         return super.decreaseAllowance(_spender, _subtractedValue);
477     }
478 
479     function batchTransfer(address[] memory _receivers, uint256[] memory _value) public whenNotPaused returns (bool) {
480         require(!frozenAccount[_msgSender()]);
481         require(_receivers.length == _value.length);
482         uint cnt = _receivers.length;
483         require(cnt > 0 && cnt <= 121);
484 
485         for (uint i = 0; i < cnt; i++) {
486             frozenCheck(_receivers[i]);
487             require(_receivers[i] != address(0));
488             require(_value[i] > 0);
489             _balances[_msgSender()] = _balances[_msgSender()].sub(_value[i]);
490             _balances[_receivers[i]] = _balances[_receivers[i]].add(_value[i]);
491             emit Transfer(_msgSender(), _receivers[i], _value[i]);
492         }
493         return true;
494     }
495 }