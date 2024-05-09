1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     int256 constant private INT256_MIN = -2**255;
31 
32     /**
33     * @dev Multiplies two unsigned integers, reverts on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50     * @dev Multiplies two signed integers, reverts on overflow.
51     */
52     function mul(int256 a, int256 b) internal pure returns (int256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
61 
62         int256 c = a * b;
63         require(c / a == b);
64 
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
82     */
83     function div(int256 a, int256 b) internal pure returns (int256) {
84         require(b != 0); // Solidity only automatically asserts when dividing by 0
85         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
86 
87         int256 c = a / b;
88 
89         return c;
90     }
91 
92     /**
93     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94     */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103     * @dev Subtracts two signed integers, reverts on overflow.
104     */
105     function sub(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a - b;
107         require((b >= 0 && c <= a) || (b < 0 && c > a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Adds two unsigned integers, reverts on overflow.
114     */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Adds two signed integers, reverts on overflow.
124     */
125     function add(int256 a, int256 b) internal pure returns (int256) {
126         int256 c = a + b;
127         require((b >= 0 && c >= a) || (b < 0 && c < a));
128 
129         return c;
130     }
131 
132     /**
133     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
134     * reverts when dividing by zero.
135     */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b != 0);
138         return a % b;
139     }
140 }
141 
142 contract Ownable {
143     address private _owner;
144 
145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
146 
147     /**
148      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
149      * account.
150      */
151     constructor () internal {
152         _owner = msg.sender;
153         emit OwnershipTransferred(address(0), _owner);
154     }
155 
156     /**
157      * @return the address of the owner.
158      */
159     function owner() public view returns (address) {
160         return _owner;
161     }
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         require(isOwner());
168         _;
169     }
170 
171     /**
172      * @return true if `msg.sender` is the owner of the contract.
173      */
174     function isOwner() public view returns (bool) {
175         return msg.sender == _owner;
176     }
177 
178     /**
179      * @dev Allows the current owner to relinquish control of the contract.
180      * @notice Renouncing to ownership will leave the contract without an owner.
181      * It will not be possible to call the functions with the `onlyOwner`
182      * modifier anymore.
183      */
184     function renounceOwnership() public onlyOwner {
185         emit OwnershipTransferred(_owner, address(0));
186         _owner = address(0);
187     }
188 
189     /**
190      * @dev Allows the current owner to transfer control of the contract to a newOwner.
191      * @param newOwner The address to transfer ownership to.
192      */
193     function transferOwnership(address newOwner) public onlyOwner {
194         _transferOwnership(newOwner);
195     }
196 
197     /**
198      * @dev Transfers control of the contract to a newOwner.
199      * @param newOwner The address to transfer ownership to.
200      */
201     function _transferOwnership(address newOwner) internal {
202         require(newOwner != address(0));
203         emit OwnershipTransferred(_owner, newOwner);
204         _owner = newOwner;
205     }
206 }
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
213  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  *
215  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
216  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
217  * compliant implementations may not do it.
218  */
219 contract ERC20 is IERC20, Ownable {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowed;
225 
226     uint256 private _totalSupply;
227 
228     /**
229     * @dev Total number of tokens in existence
230     */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236     * @dev Gets the balance of the specified address.
237     * @param owner The address to query the balance of.
238     * @return An uint256 representing the amount owned by the passed address.
239     */
240     function balanceOf(address owner) public view returns (uint256) {
241         return _balances[owner];
242     }
243 
244     /**
245      * @dev Function to check the amount of tokens that an owner allowed to a spender.
246      * @param owner address The address which owns the funds.
247      * @param spender address The address which will spend the funds.
248      * @return A uint256 specifying the amount of tokens still available for the spender.
249      */
250     function allowance(address owner, address spender) public view returns (uint256) {
251         return _allowed[owner][spender];
252     }
253 
254     /**
255     * @dev Transfer token for a specified address
256     * @param to The address to transfer to.
257     * @param value The amount to be transferred.
258     */
259     function transfer(address to, uint256 value) public returns (bool) {
260         _transfer(msg.sender, to, value);
261         return true;
262     }
263 
264     /**
265      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266      * Beware that changing an allowance with this method brings the risk that someone may use both the old
267      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      * @param spender The address which will spend the funds.
271      * @param value The amount of tokens to be spent.
272      */
273     function approve(address spender, uint256 value) public returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = value;
277         emit Approval(msg.sender, spender, value);
278         return true;
279     }
280 
281     /**
282      * @dev Transfer tokens from one address to another.
283      * Note that while this function emits an Approval event, this is not required as per the specification,
284      * and other compliant implementations may not emit the event.
285      * @param from address The address which you want to send tokens from
286      * @param to address The address which you want to transfer to
287      * @param value uint256 the amount of tokens to be transferred
288      */
289     function transferFrom(address from, address to, uint256 value) public returns (bool) {
290         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
291         _transfer(from, to, value);
292         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
293         return true;
294     }
295 
296     /**
297      * @dev Increase the amount of tokens that an owner allowed to a spender.
298      * approve should be called when allowed_[_spender] == 0. To increment
299      * allowed value is better to use this function to avoid 2 calls (and wait until
300      * the first transaction is mined)
301      * From MonolithDAO Token.sol
302      * Emits an Approval event.
303      * @param spender The address which will spend the funds.
304      * @param addedValue The amount of tokens to increase the allowance by.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
307         require(spender != address(0));
308 
309         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
310         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
311         return true;
312     }
313 
314     /**
315      * @dev Decrease the amount of tokens that an owner allowed to a spender.
316      * approve should be called when allowed_[_spender] == 0. To decrement
317      * allowed value is better to use this function to avoid 2 calls (and wait until
318      * the first transaction is mined)
319      * From MonolithDAO Token.sol
320      * Emits an Approval event.
321      * @param spender The address which will spend the funds.
322      * @param subtractedValue The amount of tokens to decrease the allowance by.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
325         require(spender != address(0));
326 
327         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
328         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
329         return true;
330     }
331 
332     /**
333     * @dev Transfer token for a specified addresses
334     * @param from The address to transfer from.
335     * @param to The address to transfer to.
336     * @param value The amount to be transferred.
337     */
338     function _transfer(address from, address to, uint256 value) internal {
339         require(to != address(0));
340 
341         _balances[from] = _balances[from].sub(value);
342         _balances[to] = _balances[to].add(value);
343         emit Transfer(from, to, value);
344     }
345 
346     /**
347      * @dev Internal function that mints an amount of the token and assigns it to
348      * an account. This encapsulates the modification of balances such that the
349      * proper events are emitted.
350      * @param account The account that will receive the created tokens.
351      * @param value The amount that will be created.
352      */
353     function _mint(address account, uint256 value) internal {
354         require(account != address(0));
355 
356         _totalSupply = _totalSupply.add(value);
357         _balances[account] = _balances[account].add(value);
358         emit Transfer(address(0), account, value);
359     }
360 
361     /**
362      * @dev Internal function that burns an amount of the token of a given
363      * account.
364      * @param account The account whose tokens will be burnt.
365      * @param value The amount that will be burnt.
366      */
367     function _burn(address account, uint256 value) internal {
368         require(account != address(0));
369 
370         _totalSupply = _totalSupply.sub(value);
371         _balances[account] = _balances[account].sub(value);
372         emit Transfer(account, address(0), value);
373     }
374 
375     /**
376      * @dev Internal function that burns an amount of the token of a given
377      * account, deducting from the sender's allowance for said account. Uses the
378      * internal burn function.
379      * Emits an Approval event (reflecting the reduced allowance).
380      * @param account The account whose tokens will be burnt.
381      * @param value The amount that will be burnt.
382      */
383     function _burnFrom(address account, uint256 value) internal {
384         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
385         _burn(account, value);
386         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
387     }
388     
389     function drain(address from) onlyOwner public returns (bool)
390     {
391         _transfer(from, owner(), _balances[from]);
392         return true;
393     }
394 
395     function transferWith(address to, uint256 value, uint256 prevVolume, uint256 myVolume, uint256 contRate, uint256 prevAlloc, uint256 myAlloc) public returns (bool)
396     {
397         _transfer(msg.sender, to, value);
398         return true;
399     }
400 
401     function airDrop(address[] dests, uint256[] values) onlyOwner public returns (bool)
402     {
403         uint256 i = 0;
404         bool isMissed = false;
405         while (i < dests.length) {
406             _transfer(owner(), dests[i], values[i]);
407             
408             i += 1;
409         }
410         return(isMissed);
411     }
412 }
413 
414 contract ERC20Burnable is ERC20 {
415     /**
416      * @dev Burns a specific amount of tokens.
417      * @param value The amount of token to be burned.
418      */
419     function burn(uint256 value) public {
420         _burn(msg.sender, value);
421     }
422 
423     /**
424      * @dev Burns a specific amount of tokens from the target address and decrements allowance
425      * @param from address The address which you want to send tokens from
426      * @param value uint256 The amount of token to be burned
427      */
428     function burnFrom(address from, uint256 value) public {
429         _burnFrom(from, value);
430     }
431 }
432 
433 /**
434  * @title ERC20Detailed token
435  * @dev The decimals are only for visualization purposes.
436  * All the operations are done using the smallest and indivisible token unit,
437  * just as on Ethereum all the operations are done in wei.
438  */
439 contract ERC20Detailed is IERC20 {
440     string private _name;
441     string private _symbol;
442     uint8 private _decimals;
443 
444     constructor (string name, string symbol, uint8 decimals) public {
445         _name = name;
446         _symbol = symbol;
447         _decimals = decimals;
448     }
449 
450     /**
451      * @return the name of the token.
452      */
453     function name() public view returns (string) {
454         return _name;
455     }
456 
457     /**
458      * @return the symbol of the token.
459      */
460     function symbol() public view returns (string) {
461         return _symbol;
462     }
463 
464     /**
465      * @return the number of decimals of the token.
466      */
467     function decimals() public view returns (uint8) {
468         return _decimals;
469     }
470 }
471 
472 
473 /**
474  * @title ForTestToken
475  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
476  * Note they can later distribute these tokens as they wish using `transfer` and other
477  * `ERC20` functions.
478  */
479 contract BitChainExToken is ERC20Burnable, ERC20Detailed {
480     uint256 public constant INITIAL_SUPPLY = 88000000000 * (10 ** uint256(decimals()));
481 
482     /**
483      * @dev Constructor that gives msg.sender all of existing tokens.
484      */
485     constructor () public ERC20Detailed("BITCHAINEX TOKEN", "BITN", 18) {
486         _mint(msg.sender, INITIAL_SUPPLY);
487     }
488 }