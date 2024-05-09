1 pragma solidity 0.5.8;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
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
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a, "SafeMath: subtraction overflow");
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address internal _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         _owner = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84     }
85 
86     /**
87      * @return the address of the owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     /**
102      * @return true if `msg.sender` is the owner of the contract.
103      */
104     function isOwner() public view returns (bool) {
105         return msg.sender == _owner;
106     }
107 
108     /**
109      * @dev Allows the current owner to relinquish control of the contract.
110      * It will not be possible to call the functions with the `onlyOwner`
111      * modifier anymore.
112      * @notice Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function transferOwnership(address newOwner) public onlyOwner {
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers control of the contract to a newOwner.
130      * @param newOwner The address to transfer ownership to.
131      */
132     function _transferOwnership(address newOwner) internal {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 /**
140  * @title Claimable
141  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
142  * This allows the new owner to accept the transfer.
143  */
144 contract Claimable is Ownable {
145   address public pendingOwner;
146 
147   /**
148    * @dev Modifier throws if called by any account other than the pendingOwner.
149    */
150   modifier onlyPendingOwner() {
151     require(msg.sender == pendingOwner);
152     _;
153   }
154 
155   /**
156    * @dev Allows the current owner to set the pendingOwner address.
157    * @param newOwner The address to transfer ownership to.
158    */
159   function transferOwnership(address newOwner) onlyOwner public {
160     pendingOwner = newOwner;
161   }
162 
163   /**
164    * @dev Allows the pendingOwner address to finalize the transfer.
165    */
166   function claimOwnership() onlyPendingOwner public {
167     emit OwnershipTransferred(owner(), pendingOwner);
168     _owner = pendingOwner;
169     pendingOwner = address(0);
170   }
171 }
172 
173 
174 /**
175  * @title ERC20 interface
176  * @dev see https://eips.ethereum.org/EIPS/eip-20
177  */
178 interface IERC20 {
179     function transfer(address to, uint256 value) external returns (bool);
180 
181     function approve(address spender, uint256 value) external returns (bool);
182 
183     function transferFrom(address from, address to, uint256 value) external returns (bool);
184 
185     function totalSupply() external view returns (uint256);
186 
187     function balanceOf(address who) external view returns (uint256);
188 
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * https://eips.ethereum.org/EIPS/eip-20
201  * Originally based on code by FirstBlood:
202  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
203  *
204  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
205  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
206  * compliant implementations may not do it.
207  */
208 contract ERC20 is IERC20 {
209     using SafeMath for uint256;
210 
211     mapping (address => uint256) private _balances;
212 
213     mapping (address => mapping (address => uint256)) private _allowances;
214 
215     uint256 private _totalSupply;
216 
217     /**
218      * @dev Total number of tokens in existence.
219      */
220     function totalSupply() public view returns (uint256) {
221         return _totalSupply;
222     }
223 
224     /**
225      * @dev Gets the balance of the specified address.
226      * @param owner The address to query the balance of.
227      * @return A uint256 representing the amount owned by the passed address.
228      */
229     function balanceOf(address owner) public view returns (uint256) {
230         return _balances[owner];
231     }
232 
233     /**
234      * @dev Function to check the amount of tokens that an owner allowed to a spender.
235      * @param owner address The address which owns the funds.
236      * @param spender address The address which will spend the funds.
237      * @return A uint256 specifying the amount of tokens still available for the spender.
238      */
239     function allowance(address owner, address spender) public view returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     /**
244      * @dev Transfer token to a specified address.
245      * @param to The address to transfer to.
246      * @param value The amount to be transferred.
247      */
248     function transfer(address to, uint256 value) public returns (bool) {
249         _transfer(msg.sender, to, value);
250         return true;
251     }
252 
253     /**
254      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
255      * Beware that changing an allowance with this method brings the risk that someone may use both the old
256      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259      * @param spender The address which will spend the funds.
260      * @param value The amount of tokens to be spent.
261      */
262     function approve(address spender, uint256 value) public returns (bool) {
263         _approve(msg.sender, spender, value);
264         return true;
265     }
266 
267     /**
268      * @dev Transfer tokens from one address to another.
269      * Note that while this function emits an Approval event, this is not required as per the specification,
270      * and other compliant implementations may not emit the event.
271      * @param from address The address which you want to send tokens from
272      * @param to address The address which you want to transfer to
273      * @param value uint256 the amount of tokens to be transferred
274      */
275     function transferFrom(address from, address to, uint256 value) public returns (bool) {
276         _transfer(from, to, value);
277         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
278         return true;
279     }
280 
281     /**
282      * @dev Increase the amount of tokens that an owner allowed to a spender.
283      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * Emits an Approval event.
288      * @param spender The address which will spend the funds.
289      * @param addedValue The amount of tokens to increase the allowance by.
290      */
291     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
292         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
293         return true;
294     }
295 
296     /**
297      * @dev Decrease the amount of tokens that an owner allowed to a spender.
298      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
299      * allowed value is better to use this function to avoid 2 calls (and wait until
300      * the first transaction is mined)
301      * From MonolithDAO Token.sol
302      * Emits an Approval event.
303      * @param spender The address which will spend the funds.
304      * @param subtractedValue The amount of tokens to decrease the allowance by.
305      */
306     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
307         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
308         return true;
309     }
310 
311     /**
312      * @dev Transfer token for a specified addresses.
313      * @param from The address to transfer from.
314      * @param to The address to transfer to.
315      * @param value The amount to be transferred.
316      */
317     function _transfer(address from, address to, uint256 value) internal {
318         require(to != address(0), "ERC20: transfer to the zero address");
319 
320         _balances[from] = _balances[from].sub(value);
321         _balances[to] = _balances[to].add(value);
322         emit Transfer(from, to, value);
323     }
324 
325     /**
326      * @dev Internal function that mints an amount of the token and assigns it to
327      * an account. This encapsulates the modification of balances such that the
328      * proper events are emitted.
329      * @param account The account that will receive the created tokens.
330      * @param value The amount that will be created.
331      */
332     function _mint(address account, uint256 value) internal {
333         require(account != address(0), "ERC20: mint to the zero address");
334 
335         _totalSupply = _totalSupply.add(value);
336         _balances[account] = _balances[account].add(value);
337         emit Transfer(address(0), account, value);
338     }
339 
340     /**
341      * @dev Internal function that burns an amount of the token of a given
342      * account.
343      * @param account The account whose tokens will be burnt.
344      * @param value The amount that will be burnt.
345      */
346     function _burn(address account, uint256 value) internal {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349         _totalSupply = _totalSupply.sub(value);
350         _balances[account] = _balances[account].sub(value);
351         emit Transfer(account, address(0), value);
352     }
353 
354     /**
355      * @dev Approve an address to spend another addresses' tokens.
356      * @param owner The address that owns the tokens.
357      * @param spender The address that will spend the tokens.
358      * @param value The number of tokens that can be spent.
359      */
360     function _approve(address owner, address spender, uint256 value) internal {
361         require(owner != address(0), "ERC20: approve from the zero address");
362         require(spender != address(0), "ERC20: approve to the zero address");
363 
364         _allowances[owner][spender] = value;
365         emit Approval(owner, spender, value);
366     }
367 
368     /**
369      * @dev Internal function that burns an amount of the token of a given
370      * account, deducting from the sender's allowance for said account. Uses the
371      * internal burn function.
372      * Emits an Approval event (reflecting the reduced allowance).
373      * @param account The account whose tokens will be burnt.
374      * @param value The amount that will be burnt.
375      */
376     function _burnFrom(address account, uint256 value) internal {
377         _burn(account, value);
378         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
379     }
380 }
381 
382 /**
383  * @title Burnable Token
384  * @dev Token that can be irreversibly burned (destroyed).
385  */
386 contract ERC20Burnable is ERC20 {
387     /**
388      * @dev Burns a specific amount of tokens.
389      * @param value The amount of token to be burned.
390      */
391     function burn(uint256 value) public {
392         _burn(msg.sender, value);
393     }
394 
395     /**
396      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
397      * @param from address The account whose tokens will be burned.
398      * @param value uint256 The amount of token to be burned.
399      */
400     function burnFrom(address from, uint256 value) public {
401         _burnFrom(from, value);
402     }
403 }
404 
405 contract Mobu is ERC20Burnable, Claimable {
406     string public constant name    = "MOBU";  
407     string public constant symbol  = "MOBU";  
408     uint8 public constant decimals = 18;
409     
410     uint256 constant initialSupply = 150000000e18;
411 
412 	// Token holders
413 	address public mainHolderAddress;
414     address public teamAddress;
415     address public advisorsAddress;
416     address public bountyAddress;
417 
418 	// Start unlocking period for locked tokens
419     uint public beginUnlockDate = 0;
420 
421 	// Flags to check if locked tokens have been already transferred
422 	bool teamTokensClaimed = false;
423 	bool advisorsTokensClaimed = false;
424 	bool bountyTokensClaimed = false;
425 
426     modifier unlockingPeriodStarted() { 
427          require (beginUnlockDate != 0);
428         _; 
429     }
430 
431     constructor(address _mainHolderAddress, address _teamAddress, address _advisorsAddress, address _bountyAddress) public {
432     	mainHolderAddress = _mainHolderAddress;
433         teamAddress = _teamAddress;
434         advisorsAddress = _advisorsAddress;
435         bountyAddress = _bountyAddress;
436 
437 		// Main MOBU token holder address has 80% of MOBU Tokens
438         _mint(_mainHolderAddress, 120000000e18);
439         
440         // Total 12% Tokens Lock-up schedule
441         // Airdrop/bounty: 4% locked-up for 1 month
442         // Team: 12% locked-up for 1 year.
443         // Advisors: 4% locked-up for 3 months
444         // These tokens will be held by the smart contract until the locked-up period
445         _mint(address(this), 30000000e18);
446     }
447 
448 	// Owner can start unlocking period
449     function startUnlockingPeriod() public onlyOwner {
450         require (beginUnlockDate == 0);
451         beginUnlockDate = now;
452     }
453     
454     // 4% Airdrop/bounty tokens can be claimed after 1 month
455     function claimBountyTokens() public unlockingPeriodStarted {
456         require (now > beginUnlockDate + 30 days);
457         require (!bountyTokensClaimed);
458         bountyTokensClaimed = true;
459         _transfer(address(this), bountyAddress, 6000000e18);
460     }
461     
462     // 12% of Team tokens can be claimed after 12 months
463     function claimTeamTokens() public unlockingPeriodStarted {
464         require (now > beginUnlockDate + 365 days);
465         require (!teamTokensClaimed);
466         teamTokensClaimed = true;
467         _transfer(address(this), teamAddress, 18000000e18);
468     }
469     
470     // 4% of Advisors tokens can be claimed after 3 months
471     function claimAdvisorTokens() public unlockingPeriodStarted {
472         require (now > beginUnlockDate + 90 days);
473         require (!advisorsTokensClaimed);
474         advisorsTokensClaimed = true;
475         _transfer(address(this), advisorsAddress, 6000000e18);
476     }
477     
478     // Owner can recover any ERC-20 tokens sent to contract address.
479     function recover(ERC20 _token) public onlyOwner {
480         _token.transfer(msg.sender, _token.balanceOf(address(this)));
481     }
482 }