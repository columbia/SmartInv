1 /** @title Hey Token
2  *  @author Thomas Vanderstraeten - <thomas@hey.network>
3  *  Keep in mind that smart contracts still rely on experimental technology.
4  */
5 
6 pragma solidity ^0.5.0;
7 
8 
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 interface IERC20 {
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address who) external view returns (uint256);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error
35  */
36 library SafeMath {
37     /**
38     * @dev Multiplies two unsigned integers, reverts on overflow.
39     */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     /**
67     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Adds two unsigned integers, reverts on overflow.
78     */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88     * reverts when dividing by zero.
89     */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0);
92         return a % b;
93     }
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
101  * Originally based on code by FirstBlood:
102  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  *
104  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
105  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
106  * compliant implementations may not do it.
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowed;
114 
115     uint256 private _totalSupply;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param owner The address to query the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param owner address The address which owns the funds.
136      * @param spender address The address which will spend the funds.
137      * @return A uint256 specifying the amount of tokens still available for the spender.
138      */
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowed[owner][spender];
141     }
142 
143     /**
144     * @dev Transfer token for a specified address
145     * @param to The address to transfer to.
146     * @param value The amount to be transferred.
147     */
148     function transfer(address to, uint256 value) public returns (bool) {
149         _transfer(msg.sender, to, value);
150         return true;
151     }
152 
153     /**
154      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param spender The address which will spend the funds.
160      * @param value The amount of tokens to be spent.
161      */
162     function approve(address spender, uint256 value) public returns (bool) {
163         require(spender != address(0));
164 
165         _allowed[msg.sender][spender] = value;
166         emit Approval(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
180         _transfer(from, to, value);
181         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
182         return true;
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      * approve should be called when allowed_[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196         require(spender != address(0));
197 
198         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
199         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
200         return true;
201     }
202 
203     /**
204      * @dev Decrease the amount of tokens that an owner allowed to a spender.
205      * approve should be called when allowed_[_spender] == 0. To decrement
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * Emits an Approval event.
210      * @param spender The address which will spend the funds.
211      * @param subtractedValue The amount of tokens to decrease the allowance by.
212      */
213     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
217         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Transfer token for a specified addresses
223     * @param from The address to transfer from.
224     * @param to The address to transfer to.
225     * @param value The amount to be transferred.
226     */
227     function _transfer(address from, address to, uint256 value) internal {
228         require(to != address(0));
229 
230         _balances[from] = _balances[from].sub(value);
231         _balances[to] = _balances[to].add(value);
232         emit Transfer(from, to, value);
233     }
234 
235     /**
236      * @dev Internal function that mints an amount of the token and assigns it to
237      * an account. This encapsulates the modification of balances such that the
238      * proper events are emitted.
239      * @param account The account that will receive the created tokens.
240      * @param value The amount that will be created.
241      */
242     function _mint(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.add(value);
246         _balances[account] = _balances[account].add(value);
247         emit Transfer(address(0), account, value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account.
253      * @param account The account whose tokens will be burnt.
254      * @param value The amount that will be burnt.
255      */
256     function _burn(address account, uint256 value) internal {
257         require(account != address(0));
258 
259         _totalSupply = _totalSupply.sub(value);
260         _balances[account] = _balances[account].sub(value);
261         emit Transfer(account, address(0), value);
262     }
263 
264     /**
265      * @dev Internal function that burns an amount of the token of a given
266      * account, deducting from the sender's allowance for said account. Uses the
267      * internal burn function.
268      * Emits an Approval event (reflecting the reduced allowance).
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burnFrom(address account, uint256 value) internal {
273         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
274         _burn(account, value);
275         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
276     }
277 }
278 
279 
280 /**
281  * @title ERC20Detailed token
282  * @dev The decimals are only for visualization purposes.
283  * All the operations are done using the smallest and indivisible token unit,
284  * just as on Ethereum all the operations are done in wei.
285  */
286 contract ERC20Detailed is IERC20 {
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290 
291     constructor (string memory name, string memory symbol, uint8 decimals) public {
292         _name = name;
293         _symbol = symbol;
294         _decimals = decimals;
295     }
296 
297     /**
298      * @return the name of the token.
299      */
300     function name() public view returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @return the symbol of the token.
306      */
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @return the number of decimals of the token.
313      */
314     function decimals() public view returns (uint8) {
315         return _decimals;
316     }
317 }
318 
319 
320 /**
321  * @title Ownable
322  * @dev The Ownable contract has an owner address, and provides basic authorization control
323  * functions, this simplifies the implementation of "user permissions".
324  */
325 contract Ownable {
326     address private _owner;
327 
328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329 
330     /**
331      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
332      * account.
333      */
334     constructor () internal {
335         _owner = msg.sender;
336         emit OwnershipTransferred(address(0), _owner);
337     }
338 
339     /**
340      * @return the address of the owner.
341      */
342     function owner() public view returns (address) {
343         return _owner;
344     }
345 
346     /**
347      * @dev Throws if called by any account other than the owner.
348      */
349     modifier onlyOwner() {
350         require(isOwner());
351         _;
352     }
353 
354     /**
355      * @return true if `msg.sender` is the owner of the contract.
356      */
357     function isOwner() public view returns (bool) {
358         return msg.sender == _owner;
359     }
360 
361     /**
362      * @dev Allows the current owner to relinquish control of the contract.
363      * @notice Renouncing to ownership will leave the contract without an owner.
364      * It will not be possible to call the functions with the `onlyOwner`
365      * modifier anymore.
366      */
367     function renounceOwnership() public onlyOwner {
368         emit OwnershipTransferred(_owner, address(0));
369         _owner = address(0);
370     }
371 
372     /**
373      * @dev Allows the current owner to transfer control of the contract to a newOwner.
374      * @param newOwner The address to transfer ownership to.
375      */
376     function transferOwnership(address newOwner) public onlyOwner {
377         _transferOwnership(newOwner);
378     }
379 
380     /**
381      * @dev Transfers control of the contract to a newOwner.
382      * @param newOwner The address to transfer ownership to.
383      */
384     function _transferOwnership(address newOwner) internal {
385         require(newOwner != address(0));
386         emit OwnershipTransferred(_owner, newOwner);
387         _owner = newOwner;
388     }
389 }
390 
391 contract EmergencyERC20Drain is Ownable {
392     /**
393     * @dev Allows owner to withdraw any ERC20 tokens sent by mistake to the contract.
394     * Taken from Zilliqa's token contract: https://github.com/Zilliqa/Zilliqa-ERC20-Token
395     */
396     function drain(
397         IERC20 token,
398         uint amount
399     )
400         public
401         onlyOwner
402     {
403         token.transfer(owner(), amount);
404     }
405 }
406 
407 /** @title Hey Token
408  *  @dev A basic extension of the ERC20 standard to include additional security
409  *  recommendations, mostly from Consensys' Tokens Best Practices:
410  *  https://consensys.github.io/smart-contract-best-practices/tokens/
411  */
412 contract Token is ERC20, ERC20Detailed, EmergencyERC20Drain {
413 
414     /* *** Token Parameters *** */
415 
416     /** @dev Equivalent to 1 billion tokens. Note that here we'd like to use
417      *  decimals() to be DRY (and follow OZ's SimpleToken example, however
418      *  this crashes the compiler).
419      */
420     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(18));
421 
422 
423     /* *** Modifiers *** */
424 
425     /** @dev Prevent sending of the token to invalid addresses. Note that the
426      *  address(0) check is already performed as part of the ERC20 standard.
427      */
428     modifier validDestination(
429         address to
430     )
431     {
432         require(to != address(this), "cannot send to contract itself");
433         _;
434     }
435 
436 
437     /* *** Public Functions *** */
438 
439     /** @dev Constructor. Mints all tokens at once and give them to the contract
440      *  deployer. No further minting is subsequently possible.
441      */
442     constructor()
443         public
444         ERC20Detailed("HeyToken", "HEY", 18)
445     {
446         _mint(msg.sender, INITIAL_SUPPLY);
447     }
448 
449     /** @dev Overrides the standard ERC20 transfer to apply the validDestination
450      *  modifier. All else remains the same.
451      *  @param to The address which you want to transfer to
452      *  @param value The amount of tokens to be transferred
453      */
454     function transfer(
455         address to,
456         uint value
457     )
458         public
459         validDestination(to)
460         returns (bool)
461     {
462         return super.transfer(to, value);
463     }
464 
465     /** @dev Overrides the standard ERC20 transferFrom to apply the validDestination
466      *  modifier. All else remains the same.
467      *  @param from The address which you want to send tokens from
468      *  @param to The address which you want to transfer to
469      *  @param value The amount of tokens to be transferred
470      */
471     function transferFrom(
472         address from,
473         address to,
474         uint value
475     )
476         public
477         validDestination(to)
478         returns (bool)
479     {
480         return super.transferFrom(from, to, value);
481     }
482 }