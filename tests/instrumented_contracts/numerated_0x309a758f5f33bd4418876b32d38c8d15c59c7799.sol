1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
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
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
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
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 interface IERC20 {
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     function transferFrom(address from, address to, uint256 value) external returns (bool);
79 
80     function totalSupply() external view returns (uint256);
81 
82     function balanceOf(address who) external view returns (uint256);
83 
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Originally based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  *
101  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
102  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
103  * compliant implementations may not do it.
104  */
105 contract ERC20 is IERC20 {
106     using SafeMath for uint256;
107 
108     mapping (address => uint256) private _balances;
109 
110     mapping (address => mapping (address => uint256)) private _allowed;
111 
112     uint256 private _totalSupply;
113 
114     /**
115     * @dev Total number of tokens in existence
116     */
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param owner The address to query the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address owner) public view returns (uint256) {
127         return _balances[owner];
128     }
129 
130     /**
131      * @dev Function to check the amount of tokens that an owner allowed to a spender.
132      * @param owner address The address which owns the funds.
133      * @param spender address The address which will spend the funds.
134      * @return A uint256 specifying the amount of tokens still available for the spender.
135      */
136     function allowance(address owner, address spender) public view returns (uint256) {
137         return _allowed[owner][spender];
138     }
139 
140     /**
141     * @dev Transfer token for a specified address
142     * @param to The address to transfer to.
143     * @param value The amount to be transferred.
144     */
145     function transfer(address to, uint256 value) public returns (bool) {
146         _transfer(msg.sender, to, value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      * @param spender The address which will spend the funds.
157      * @param value The amount of tokens to be spent.
158      */
159     function approve(address spender, uint256 value) public returns (bool) {
160         _approve(msg.sender, spender, value);
161         return true;
162     }
163 
164     /**
165      * @dev Transfer tokens from one address to another.
166      * Note that while this function emits an Approval event, this is not required as per the specification,
167      * and other compliant implementations may not emit the event.
168      * @param from address The address which you want to send tokens from
169      * @param to address The address which you want to transfer to
170      * @param value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address from, address to, uint256 value) public returns (bool) {
173         _transfer(from, to, value);
174         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
175         return true;
176     }
177 
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      * approve should be called when allowed_[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param addedValue The amount of tokens to increase the allowance by.
187      */
188     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
189         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
190         return true;
191     }
192 
193     /**
194      * @dev Decrease the amount of tokens that an owner allowed to a spender.
195      * approve should be called when allowed_[_spender] == 0. To decrement
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * Emits an Approval event.
200      * @param spender The address which will spend the funds.
201      * @param subtractedValue The amount of tokens to decrease the allowance by.
202      */
203     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
205         return true;
206     }
207 
208     /**
209     * @dev Transfer token for a specified addresses
210     * @param from The address to transfer from.
211     * @param to The address to transfer to.
212     * @param value The amount to be transferred.
213     */
214     function _transfer(address from, address to, uint256 value) internal {
215         require(to != address(0));
216 
217         _balances[from] = _balances[from].sub(value);
218         _balances[to] = _balances[to].add(value);
219         emit Transfer(from, to, value);
220     }
221 
222     /**
223      * @dev Internal function that mints an amount of the token and assigns it to
224      * an account. This encapsulates the modification of balances such that the
225      * proper events are emitted.
226      * @param account The account that will receive the created tokens.
227      * @param value The amount that will be created.
228      */
229     function _mint(address account, uint256 value) internal {
230         require(account != address(0));
231 
232         _totalSupply = _totalSupply.add(value);
233         _balances[account] = _balances[account].add(value);
234         emit Transfer(address(0), account, value);
235     }
236 
237     /**
238      * @dev Internal function that burns an amount of the token of a given
239      * account.
240      * @param account The account whose tokens will be burnt.
241      * @param value The amount that will be burnt.
242      */
243     function _burn(address account, uint256 value) internal {
244         require(account != address(0));
245 
246         _totalSupply = _totalSupply.sub(value);
247         _balances[account] = _balances[account].sub(value);
248         emit Transfer(account, address(0), value);
249     }
250 
251     /**
252      * @dev Approve an address to spend another addresses' tokens.
253      * @param owner The address that owns the tokens.
254      * @param spender The address that will spend the tokens.
255      * @param value The number of tokens that can be spent.
256      */
257     function _approve(address owner, address spender, uint256 value) internal {
258         require(spender != address(0));
259         require(owner != address(0));
260 
261         _allowed[owner][spender] = value;
262         emit Approval(owner, spender, value);
263     }
264 
265     /**
266      * @dev Internal function that burns an amount of the token of a given
267      * account, deducting from the sender's allowance for said account. Uses the
268      * internal burn function.
269      * Emits an Approval event (reflecting the reduced allowance).
270      * @param account The account whose tokens will be burnt.
271      * @param value The amount that will be burnt.
272      */
273     function _burnFrom(address account, uint256 value) internal {
274         _burn(account, value);
275         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
276     }
277 }
278 
279 
280 
281 /**
282  * @title Controller
283  * @dev The Controller contract has an owner address, and provides basic authorization and transfer control
284  * functions, this simplifies the implementation of "user permissions".
285  */
286 contract Controller {
287     
288     address private _owner;
289     bool private _paused;
290     
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292     event Paused(address account);
293     event Unpaused(address account);
294     
295     mapping(address => bool) private owners;
296     
297     /**
298     * @dev The Controller constructor sets the initial `owner` of the contract to the sender
299     * account, and allows transfer by default.
300     */
301     constructor() internal {
302         setOwner(msg.sender);
303     }
304 
305     /**
306     * @dev Throws if called by any account other than the owner.
307     */
308     modifier onlyOwner() {
309         require(owners[msg.sender]);
310         _;
311     }
312 
313     function setOwner(address addr) internal returns(bool) {
314         if (!owners[addr]) {
315           owners[addr] = true;
316           _owner = addr;
317           return true; 
318         }
319     }
320 
321     /**
322     * @dev Allows the current owner to transfer control of the contract to a newOwner.
323     * @param newOwner The address to transfer ownership to.
324     */   
325     function changeOwner(address newOwner) onlyOwner public returns(bool) {
326         require (!owners[newOwner]);
327           owners[newOwner];
328           _owner = newOwner;
329           emit OwnershipTransferred(_owner, newOwner);
330           return true; 
331         }
332 
333     /**
334     * @return the address of the owner.
335     */
336     function Owner() public view returns (address) {
337         return _owner;
338     }
339     
340     /**
341     * @return true if the contract is paused, false otherwise.
342     */
343     function paused() public view returns(bool) {
344     return _paused;
345     }
346     
347     /**
348     * @dev Modifier to make a function callable only when the contract is not paused.
349     */
350     modifier whenNotPaused() {
351     require(!_paused);
352     _;
353     }
354     
355     /**
356     * @dev Modifier to make a function callable only when the contract is paused.
357     */
358     modifier whenPaused() {
359     require(_paused);
360     _;
361     }
362     
363     /**
364     * @dev called by the owner to pause, triggers stopped state
365     */
366     function pause() public onlyOwner whenNotPaused {
367     _paused = true;
368     emit Paused(msg.sender);
369     }
370     
371     /**
372     * @dev called by the owner to unpause, returns to normal state
373     */
374     function unpause() public onlyOwner whenPaused {
375     _paused = false;
376     emit Unpaused(msg.sender);
377     }
378     
379 }
380 
381 
382 
383 /**
384  * @title LobefyToken token
385  * @dev The decimals are only for visualization purposes.
386  * All the operations are done using the smallest and indivisible token unit,
387  * just as on Ethereum all the operations are done in wei.
388  */
389 contract LobefyToken is ERC20, Controller {
390     
391     using SafeMath for uint256;
392     
393     string private _name = "Lobefy Token";
394     string private _symbol = "CRWD";
395     uint256 private _decimals = 18;
396     
397     address private team = 0xDA19316953D19f5f8C6361d68C6D0078c06285d3;
398     uint256 private team1Balance = 50 * (10 ** 6) * (10 ** 18);
399     
400     
401     constructor() public {
402         mint(team, team1Balance);
403     }
404 
405     /**
406      * @return the name of the token.
407      */
408     function name() public view returns (string memory) {
409         return _name;
410     }
411 
412     /**
413      * @return the symbol of the token.
414      */
415     function symbol() public view returns (string memory) {
416         return _symbol;
417     }
418 
419     /**
420      * @return the number of decimals of the token.
421      */
422     function decimals() public view returns (uint256) {
423         return _decimals;
424     }
425     
426     /**
427      * @dev Burns a specific amount of tokens.
428      * @param value The amount of token to be burned.
429      */
430     function burn(uint256 value) public {
431         _burn(msg.sender, value);
432     }
433 
434     /**
435      * @dev Burns a specific amount of tokens from the target address and decrements allowance
436      * @param from address The address which you want to send tokens from
437      * @param value uint256 The amount of token to be burned
438      */
439     function burnFrom(address from, uint256 value) public {
440         _burnFrom(from, value);
441     }
442     
443     /**
444      * @dev Function to mint tokens
445      * @param to The address that will receive the minted tokens.
446      * @param value The amount of tokens to mint.
447      * @return A boolean that indicates if the operation was successful.
448      */
449     function mint(address to, uint256 value) public onlyOwner returns (bool) {
450         _mint(to, value);
451         return true;
452     }
453     
454     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
455         return super.transfer(to, value);
456     }
457 
458     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
459         return super.transferFrom(from, to, value);
460     }
461 
462     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
463         return super.approve(spender, value);
464     }
465 
466     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
467         return super.increaseAllowance(spender, addedValue);
468     }
469 
470     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
471         return super.decreaseAllowance(spender, subtractedValue);
472     }
473 }