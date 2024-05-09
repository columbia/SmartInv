1 pragma solidity 0.5.4;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title Standard ERC20 token
27  *
28  * @dev Implementation of the basic standard token.
29  * https://eips.ethereum.org/EIPS/eip-20
30  * Originally based on code by FirstBlood:
31  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
32  *
33  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
34  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
35  * compliant implementations may not do it.
36  */
37 contract ERC20 is IERC20 {
38     using SafeMath for uint256;
39 
40     mapping (address => uint256) internal _balances;
41 
42     mapping (address => mapping (address => uint256)) internal _allowed;
43 
44     uint256 internal _totalSupply;
45 
46     /**
47      * @dev Total number of tokens in existence.
48      */
49     function totalSupply() public view returns (uint256) {
50         return _totalSupply;
51     }
52 
53     /**
54      * @dev Gets the balance of the specified address.
55      * @param owner The address to query the balance of.
56      * @return A uint256 representing the amount owned by the passed address.
57      */
58     function balanceOf(address owner) public view returns (uint256) {
59         return _balances[owner];
60     }
61 
62     /**
63      * @dev Function to check the amount of tokens that an owner allowed to a spender.
64      * @param owner address The address which owns the funds.
65      * @param spender address The address which will spend the funds.
66      * @return A uint256 specifying the amount of tokens still available for the spender.
67      */
68     function allowance(address owner, address spender) public view returns (uint256) {
69         return _allowed[owner][spender];
70     }
71 
72     /**
73      * @dev Transfer token to a specified address.
74      * @param to The address to transfer to.
75      * @param value The amount to be transferred.
76      */
77     function transfer(address to, uint256 value) public returns (bool) {
78         _transfer(msg.sender, to, value);
79         return true;
80     }
81 
82     /**
83      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
84      * Beware that changing an allowance with this method brings the risk that someone may use both the old
85      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
86      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      * @param spender The address which will spend the funds.
89      * @param value The amount of tokens to be spent.
90      */
91     function approve(address spender, uint256 value) public returns (bool) {
92         _approve(msg.sender, spender, value);
93         return true;
94     }
95 
96     /**
97      * @dev Transfer tokens from one address to another.
98      * Note that while this function emits an Approval event, this is not required as per the specification,
99      * and other compliant implementations may not emit the event.
100      * @param from address The address which you want to send tokens from
101      * @param to address The address which you want to transfer to
102      * @param value uint256 the amount of tokens to be transferred
103      */
104     function transferFrom(address from, address to, uint256 value) public returns (bool) {
105         _transfer(from, to, value);
106         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
107         return true;
108     }
109 
110     /**
111      * @dev Increase the amount of tokens that an owner allowed to a spender.
112      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
113      * allowed value is better to use this function to avoid 2 calls (and wait until
114      * the first transaction is mined)
115      * From MonolithDAO Token.sol
116      * Emits an Approval event.
117      * @param spender The address which will spend the funds.
118      * @param addedValue The amount of tokens to increase the allowance by.
119      */
120     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
121         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
122         return true;
123     }
124 
125     /**
126      * @dev Decrease the amount of tokens that an owner allowed to a spender.
127      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
128      * allowed value is better to use this function to avoid 2 calls (and wait until
129      * the first transaction is mined)
130      * From MonolithDAO Token.sol
131      * Emits an Approval event.
132      * @param spender The address which will spend the funds.
133      * @param subtractedValue The amount of tokens to decrease the allowance by.
134      */
135     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
136         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
137         return true;
138     }
139 
140     /**
141      * @dev Transfer token for a specified addresses.
142      * @param from The address to transfer from.
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function _transfer(address from, address to, uint256 value) internal {
147         require(to != address(0));
148 
149         _balances[from] = _balances[from].sub(value);
150         _balances[to] = _balances[to].add(value);
151         emit Transfer(from, to, value);
152     }
153 
154     /**
155      * @dev Internal function that mints an amount of the token and assigns it to
156      * an account. This encapsulates the modification of balances such that the
157      * proper events are emitted.
158      * @param account The account that will receive the created tokens.
159      * @param value The amount that will be created.
160      */
161     function _mint(address account, uint256 value) internal {
162         require(account != address(0));
163 
164         _totalSupply = _totalSupply.add(value);
165         _balances[account] = _balances[account].add(value);
166         emit Transfer(address(0), account, value);
167     }
168 
169     /**
170      * @dev Internal function that burns an amount of the token of a given
171      * account.
172      * @param account The account whose tokens will be burnt.
173      * @param value The amount that will be burnt.
174      */
175     function _burn(address account, uint256 value) internal {
176         require(account != address(0));
177 
178         _totalSupply = _totalSupply.sub(value);
179         _balances[account] = _balances[account].sub(value);
180         emit Transfer(account, address(0), value);
181     }
182 
183     /**
184      * @dev Approve an address to spend another addresses' tokens.
185      * @param owner The address that owns the tokens.
186      * @param spender The address that will spend the tokens.
187      * @param value The number of tokens that can be spent.
188      */
189     function _approve(address owner, address spender, uint256 value) internal {
190         require(spender != address(0));
191         require(owner != address(0));
192 
193         _allowed[owner][spender] = value;
194         emit Approval(owner, spender, value);
195     }
196 
197     /**
198      * @dev Internal function that burns an amount of the token of a given
199      * account, deducting from the sender's allowance for said account. Uses the
200      * internal burn function.
201      * Emits an Approval event (reflecting the reduced allowance).
202      * @param account The account whose tokens will be burnt.
203      * @param value The amount that will be burnt.
204      */
205     function _burnFrom(address account, uint256 value) internal {
206         _burn(account, value);
207         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
208     }
209 }
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217     address private _owner;
218 
219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
220 
221     /**
222      * @dev The Ownable constructor sets the original `owner` of the contract to the a
223      * specified account.
224      * @param initalOwner The address of the inital owner.
225      */
226     constructor (address initalOwner) internal {
227         _owner = initalOwner;
228         emit OwnershipTransferred(address(0), _owner);
229     }
230 
231     /**
232      * @return the address of the owner.
233      */
234     function owner() public view returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(isOwner());
243         _;
244     }
245 
246     /**
247      * @return true if `msg.sender` is the owner of the contract.
248      */
249     function isOwner() public view returns (bool) {
250         return msg.sender == _owner;
251     }
252 
253     /**
254      * @dev Allows the current owner to relinquish control of the contract.
255      * It will not be possible to call the functions with the `onlyOwner`
256      * modifier anymore.
257      * @notice Renouncing ownership will leave the contract without an owner,
258      * thereby removing any functionality that is only available to the owner.
259      */
260     function renounceOwnership() public onlyOwner {
261         emit OwnershipTransferred(_owner, address(0));
262         _owner = address(0);
263     }
264 
265     /**
266      * @dev Allows the current owner to transfer control of the contract to a newOwner.
267      * @param newOwner The address to transfer ownership to.
268      */
269     function transferOwnership(address newOwner) public onlyOwner {
270         _transferOwnership(newOwner);
271     }
272 
273     /**
274      * @dev Transfers control of the contract to a newOwner.
275      * @param newOwner The address to transfer ownership to.
276      */
277     function _transferOwnership(address newOwner) internal {
278         require(newOwner != address(0));
279         emit OwnershipTransferred(_owner, newOwner);
280         _owner = newOwner;
281     }
282 }
283 
284 /**
285  * @title ARPAToken
286  * @dev ARPA is an ownable, mintable, pausable and burnable ERC20 token
287  */
288 contract ARPAToken is ERC20, Ownable {
289     using SafeMath for uint;
290 
291     string public constant name = "ARPA Token";
292     uint8 public constant decimals = 18;
293     string public constant symbol = "ARPA";
294     uint public constant maxSupply = 2 * 10**9 * 10**uint(decimals); // 2 billion
295     uint public constant initalSupply = 14 * 10**8 * 10**uint(decimals); // 1.4 billion
296     
297     bool public paused; // True when circulation is paused.
298 
299     mapping (address => bool) public minter;
300 
301     /**
302      * @dev Throws if called by any account that is not a minter.
303      */
304     modifier onlyMinter() {
305         require(minter[msg.sender]);
306         _;
307     }
308 
309     /**
310      * @dev Throws if called when the circulation is paused.
311      */
312     modifier whenNotPaused() {
313         require(paused == false);
314         _;
315     }
316 
317     /**
318      * @dev The ARPAToken constructor sets the original manager of the contract to the a
319      * specified account, and send all the inital supply to it.
320      * @param manager The address of the first manager of this contract.
321      */
322     constructor(address manager) public Ownable(manager) {
323         _balances[manager] = initalSupply;
324         _totalSupply = initalSupply;
325     }
326 
327     /**
328      * @dev Add an address to the minter list.
329      * @param minterAddress The address to be added as a minter.
330      */
331     function addMinter(address minterAddress) public onlyOwner {
332         minter[minterAddress] = true;
333     }
334 
335     /**
336      * @dev Remove an address from the minter list.
337      * @param minterAddress The address to be removed from minters.
338      */
339     function removeMinter(address minterAddress) public onlyOwner {
340         minter[minterAddress] = false;
341     }
342 
343     /**
344      * @dev Function to mint tokens by a minter
345      * @param to The address that will receive the minted tokens.
346      * @param value The amount of tokens to mint.
347      * @return A boolean that indicates if the operation was successful.
348      * @notice 30% of the ARPA token are issued by the mining process.
349      */
350     function mint(address to, uint value) public onlyMinter returns (bool) {
351         require(_totalSupply.add(value) <= maxSupply);
352         _mint(to, value);
353         return true;
354     }
355 
356     /**
357      * @dev Function to pause all the circulation in the case of emergency.
358      */
359     function pause() public onlyOwner {
360         paused = true;
361     }
362 
363     /**
364      * @dev Function to recover all the circulation from emergency.
365      */
366     function unpause() public onlyOwner {
367         paused = false;
368     }
369 
370     /**
371      * @dev Burns a specific amount of tokens.
372      * @param value The amount of token to be burned.
373      */
374     function burn(uint256 value) public {
375         _burn(msg.sender, value);
376     }
377 
378     /**
379      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
380      * @param from address The account whose tokens will be burned.
381      * @param value uint256 The amount of token to be burned.
382      */
383     function burnFrom(address from, uint256 value) public {
384         _burnFrom(from, value);
385     }
386 
387     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
388         return super.transfer(to, value);
389     }
390 
391     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
392         return super.transferFrom(from, to, value);
393     }
394 
395     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
396         return super.approve(spender, value);
397     }
398 
399     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
400         return super.increaseAllowance(spender, addedValue);
401     }
402 
403     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
404         return super.decreaseAllowance(spender, subtractedValue);
405     }
406 
407 }
408 
409 /**
410  * @title SafeMath
411  * @dev Unsigned math operations with safety checks that revert on error.
412  */
413 library SafeMath {
414     /**
415      * @dev Multiplies two unsigned integers, reverts on overflow.
416      */
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
419         // benefit is lost if 'b' is also tested.
420         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
421         if (a == 0) {
422             return 0;
423         }
424 
425         uint256 c = a * b;
426         require(c / a == b);
427 
428         return c;
429     }
430 
431     /**
432      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
433      */
434     function div(uint256 a, uint256 b) internal pure returns (uint256) {
435         // Solidity only automatically asserts when dividing by 0
436         require(b > 0);
437         uint256 c = a / b;
438         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439 
440         return c;
441     }
442 
443     /**
444      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
445      */
446     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
447         require(b <= a);
448         uint256 c = a - b;
449 
450         return c;
451     }
452 
453     /**
454      * @dev Adds two unsigned integers, reverts on overflow.
455      */
456     function add(uint256 a, uint256 b) internal pure returns (uint256) {
457         uint256 c = a + b;
458         require(c >= a);
459 
460         return c;
461     }
462 
463     /**
464      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
465      * reverts when dividing by zero.
466      */
467     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
468         require(b != 0);
469         return a % b;
470     }
471 }