1 // File: ../3rdparty/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: ../3rdparty/openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error.
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0, "SafeMath: division by zero");
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a, "SafeMath: subtraction overflow");
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0, "SafeMath: modulo by zero");
91         return a % b;
92     }
93 }
94 
95 // File: ../3rdparty/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence.
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowances[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address.
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses.
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225 
226         _balances[from] = _balances[from].sub(value);
227         _balances[to] = _balances[to].add(value);
228         emit Transfer(from, to, value);
229     }
230 
231     /**
232      * @dev Internal function that mints an amount of the token and assigns it to
233      * an account. This encapsulates the modification of balances such that the
234      * proper events are emitted.
235      * @param account The account that will receive the created tokens.
236      * @param value The amount that will be created.
237      */
238     function _mint(address account, uint256 value) internal {
239         require(account != address(0), "ERC20: mint to the zero address");
240 
241         _totalSupply = _totalSupply.add(value);
242         _balances[account] = _balances[account].add(value);
243         emit Transfer(address(0), account, value);
244     }
245 
246     /**
247      * @dev Internal function that burns an amount of the token of a given
248      * account.
249      * @param account The account whose tokens will be burnt.
250      * @param value The amount that will be burnt.
251      */
252     function _burn(address account, uint256 value) internal {
253         require(account != address(0), "ERC20: burn from the zero address");
254 
255         _totalSupply = _totalSupply.sub(value);
256         _balances[account] = _balances[account].sub(value);
257         emit Transfer(account, address(0), value);
258     }
259 
260     /**
261      * @dev Approve an address to spend another addresses' tokens.
262      * @param owner The address that owns the tokens.
263      * @param spender The address that will spend the tokens.
264      * @param value The number of tokens that can be spent.
265      */
266     function _approve(address owner, address spender, uint256 value) internal {
267         require(owner != address(0), "ERC20: approve from the zero address");
268         require(spender != address(0), "ERC20: approve to the zero address");
269 
270         _allowances[owner][spender] = value;
271         emit Approval(owner, spender, value);
272     }
273 
274     /**
275      * @dev Internal function that burns an amount of the token of a given
276      * account, deducting from the sender's allowance for said account. Uses the
277      * internal burn function.
278      * Emits an Approval event (reflecting the reduced allowance).
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282     function _burnFrom(address account, uint256 value) internal {
283         _burn(account, value);
284         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
285     }
286 }
287 
288 // File: ../3rdparty/openzeppelin-solidity/contracts/ownership/Ownable.sol
289 
290 pragma solidity ^0.5.0;
291 
292 /**
293  * @title Ownable
294  * @dev The Ownable contract has an owner address, and provides basic authorization control
295  * functions, this simplifies the implementation of "user permissions".
296  */
297 contract Ownable {
298     address private _owner;
299 
300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302     /**
303      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304      * account.
305      */
306     constructor () internal {
307         _owner = msg.sender;
308         emit OwnershipTransferred(address(0), _owner);
309     }
310 
311     /**
312      * @return the address of the owner.
313      */
314     function owner() public view returns (address) {
315         return _owner;
316     }
317 
318     /**
319      * @dev Throws if called by any account other than the owner.
320      */
321     modifier onlyOwner() {
322         require(isOwner(), "Ownable: caller is not the owner");
323         _;
324     }
325 
326     /**
327      * @return true if `msg.sender` is the owner of the contract.
328      */
329     function isOwner() public view returns (bool) {
330         return msg.sender == _owner;
331     }
332 
333     /**
334      * @dev Allows the current owner to relinquish control of the contract.
335      * It will not be possible to call the functions with the `onlyOwner`
336      * modifier anymore.
337      * @notice Renouncing ownership will leave the contract without an owner,
338      * thereby removing any functionality that is only available to the owner.
339      */
340     function renounceOwnership() public onlyOwner {
341         emit OwnershipTransferred(_owner, address(0));
342         _owner = address(0);
343     }
344 
345     /**
346      * @dev Allows the current owner to transfer control of the contract to a newOwner.
347      * @param newOwner The address to transfer ownership to.
348      */
349     function transferOwnership(address newOwner) public onlyOwner {
350         _transferOwnership(newOwner);
351     }
352 
353     /**
354      * @dev Transfers control of the contract to a newOwner.
355      * @param newOwner The address to transfer ownership to.
356      */
357     function _transferOwnership(address newOwner) internal {
358         require(newOwner != address(0), "Ownable: new owner is the zero address");
359         emit OwnershipTransferred(_owner, newOwner);
360         _owner = newOwner;
361     }
362 }
363 
364 // File: ../3rdparty/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
365 
366 pragma solidity ^0.5.0;
367 
368 
369 /**
370  * @title ERC20Detailed token
371  * @dev The decimals are only for visualization purposes.
372  * All the operations are done using the smallest and indivisible token unit,
373  * just as on Ethereum all the operations are done in wei.
374  */
375 contract ERC20Detailed is IERC20 {
376     string private _name;
377     string private _symbol;
378     uint8 private _decimals;
379 
380     constructor (string memory name, string memory symbol, uint8 decimals) public {
381         _name = name;
382         _symbol = symbol;
383         _decimals = decimals;
384     }
385 
386     /**
387      * @return the name of the token.
388      */
389     function name() public view returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @return the symbol of the token.
395      */
396     function symbol() public view returns (string memory) {
397         return _symbol;
398     }
399 
400     /**
401      * @return the number of decimals of the token.
402      */
403     function decimals() public view returns (uint8) {
404         return _decimals;
405     }
406 }
407 
408 // File: contracts/ICert.sol
409 
410 pragma solidity ^0.5.0;
411 
412 /**
413  * @title CableCert interface
414  * @dev 
415  */
416 interface ICert {
417     //function transfer(address to, uint256 cert) external returns (bool);
418     function deposit(uint256 value) external returns (bool);
419  
420     function depositNiwixRate() external view returns(uint256);
421     function depositTo(address address_to, uint256 value) external returns (bool);
422     function getDepositNiwixValue(uint trueuro_amount) external view returns(uint256);
423 
424     //event Transfer(address indexed from, address indexed to, uint256 value);
425     //event Approval(address indexed owner, address indexed spender, uint256 value);
426 }
427 
428 // File: contracts/NIWIX.sol
429 
430 pragma solidity >=0.4.25 <0.6.0;
431 
432 
433 
434 
435 
436 
437 
438 //contract Cert is ICableCert{};
439 
440 contract NIWIX is ERC20, Ownable, ERC20Detailed{
441     using SafeMath for uint256;
442 
443     uint8 public constant DECIMALS = 8;
444     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(DECIMALS));
445     ICert private _cert;
446     ERC20 private _euron;
447 
448     event TokenFallbackNWX(address where, address sender, address from, uint256 value);
449 
450     function tokenFallback( address from, uint256 value ) public returns(bool){
451         emit TokenFallbackNWX( address(this), msg.sender, from, value);
452         if( msg.sender == address(_euron) || msg.sender == address(_cert)){
453             if( from != address(_cert) ) {
454                 uint256 niwixValue = _cert.getDepositNiwixValue(value);
455                 _euron.increaseAllowance(address(_cert), value);
456                 _approve(from, address(_cert), allowance(from,address(_cert)).add(niwixValue));
457                 _cert.depositTo(from, value);
458             }
459         }
460     }
461 
462 
463     constructor () public ERC20Detailed("NIWIX", "NWX", DECIMALS){
464         _mint(msg.sender, INITIAL_SUPPLY);
465     }
466 
467     function mint(uint256 amount) public onlyOwner returns(bool){
468         uint256 new_total_supply = totalSupply().add(amount);
469         require (new_total_supply <= 1000000000 * (10 ** uint256(DECIMALS)), "Total supply exceeded");
470         _mint(msg.sender, amount);
471     }
472 
473     function setCert(address cert) public onlyOwner returns(bool){
474         _cert = ICert(cert);
475         return true;
476     }
477 
478     function setEURON(address trueuro) public onlyOwner returns(bool){
479         _euron = ERC20(trueuro);
480         return true;
481     }
482 
483     function reclaimEther(address payable _to) external onlyOwner {
484         _to.transfer(address(this).balance);
485     }
486 
487     function reclaimToken(ERC20 token, address _to) external onlyOwner {
488         uint256 balance = token.balanceOf(address(this));
489         token.transfer(_to, balance);
490     }
491 
492 }