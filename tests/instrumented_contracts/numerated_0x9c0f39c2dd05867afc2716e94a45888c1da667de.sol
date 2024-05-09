1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-19
3 */
4 
5 pragma solidity ^0.6.10;
6 
7 // SPDX-License-Identifier: UNLICENSED
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/20
35  */
36 interface IERC20 {
37     function transfer(address to, uint256 value) external returns (bool);
38 
39     function approve(address spender, uint256 value) external returns (bool);
40 
41     function transferFrom(address from, address to, uint256 value) external returns (bool);
42 
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address who) external view returns (uint256);
46 
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
55 
56 /**
57  * @title SafeMath
58  * @dev Unsigned math operations with safety checks that revert on error
59  */
60 library SafeMath {
61     /**
62     * @dev Multiplies two unsigned integers, reverts on overflow.
63     */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b);
74 
75         return c;
76     }
77 
78     /**
79     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
80     */
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Solidity only automatically asserts when dividing by 0
83         require(b > 0);
84         uint256 c = a / b;
85         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86 
87         return c;
88     }
89 
90     /**
91     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
92     */
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b <= a);
95         uint256 c = a - b;
96 
97         return c;
98     }
99 
100     /**
101     * @dev Adds two unsigned integers, reverts on overflow.
102     */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a);
106 
107         return c;
108     }
109 
110     /**
111     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
112     * reverts when dividing by zero.
113     */
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b != 0);
116         return a % b;
117     }
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
127  * Originally based on code by FirstBlood:
128  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  *
130  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
131  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
132  * compliant implementations may not do it.
133  */
134 contract ERC20 is IERC20 {
135     using SafeMath for uint256;
136 
137     mapping (address => uint256) private _balances;
138 
139     mapping (address => mapping (address => uint256)) private _allowed;
140 
141     uint256 private _totalSupply;
142     string private _name;
143     string private _symbol;
144     uint8 private _decimals;
145     mapping(address => bool) public Limtcheck;  
146 
147     uint256 public maxWalletBal =1000000000e18;
148 
149     constructor () public {
150         _name = 'KODA INU';
151         _symbol = 'KODA';
152         _decimals = 18;
153     }
154 
155     /**
156      * @return the name of the token.
157      */
158     function name() public view virtual returns (string memory) {
159         return _name;
160     }
161 
162     /**
163      * @return the symbol of the token.
164      */
165     function symbol() public view virtual returns (string memory) {
166         return _symbol;
167     }
168 
169     /**
170      * @return the number of decimals of the token.
171      */
172     function decimals() public view virtual returns (uint8) {
173         return _decimals;
174     }
175 
176     /**
177     * @dev Total number of tokens in existence
178     */
179     function totalSupply() public view override returns (uint256) {
180         return _totalSupply;
181     }
182 
183     /**
184     * @dev Gets the balance of the specified address.
185     * @param owner The address to query the balance of.
186     * @return An uint256 representing the amount owned by the passed address.
187     */
188     function balanceOf(address owner) public view override returns (uint256) {
189         return _balances[owner];
190     }
191 
192     /**
193      * @dev Function to check the amount of tokens that an owner allowed to a spender.
194      * @param owner address The address which owns the funds.
195      * @param spender address The address which will spend the funds.
196      * @return A uint256 specifying the amount of tokens still available for the spender.
197      */
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowed[owner][spender];
200     }
201 
202     /**
203     * @dev Transfer token for a specified address
204     * @param to The address to transfer to.
205     * @param value The amount to be transferred.
206     */
207     function transfer(address to, uint256 value) public virtual override returns (bool) {
208         _transfer(msg.sender, to, value);
209         return true;
210     }
211 
212     /**
213      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218      * @param spender The address which will spend the funds.
219      * @param value The amount of tokens to be spent.
220      */
221     function approve(address spender, uint256 value) public virtual override returns (bool) {
222         require(spender != address(0));
223 
224         _allowed[msg.sender][spender] = value;
225         emit Approval(msg.sender, spender, value);
226         return true;
227     }
228 
229     /**
230      * @dev Transfer tokens from one address to another.
231      * Note that while this function emits an Approval event, this is not required as per the specification,
232      * and other compliant implementations may not emit the event.
233      * @param from address The address which you want to send tokens from
234      * @param to address The address which you want to transfer to
235      * @param value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address from, address to, uint256 value) public virtual override returns (bool) {
238         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
239         _transfer(from, to, value);
240         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
241         return true;
242     }
243 
244     /**
245      * @dev Increase the amount of tokens that an owner allowed to a spender.
246      * approve should be called when allowed_[_spender] == 0. To increment
247      * allowed value is better to use this function to avoid 2 calls (and wait until
248      * the first transaction is mined)
249      * From MonolithDAO Token.sol
250      * Emits an Approval event.
251      * @param spender The address which will spend the funds.
252      * @param addedValue The amount of tokens to increase the allowance by.
253      */
254     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
255         require(spender != address(0));
256 
257         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
258         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
259         return true;
260     }
261 
262  
263     /**
264      * @dev Decrease the amount of tokens that an owner allowed to a spender.
265      * approve should be called when allowed_[_spender] == 0. To decrement
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * Emits an Approval event.
270      * @param spender The address which will spend the funds.
271      * @param subtractedValue The amount of tokens to decrease the allowance by.
272      */
273     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
277         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278         return true;
279     }
280 
281     /**
282     * @dev Transfer token for a specified addresses
283     * @param from The address to transfer from.
284     * @param to The address to transfer to.
285     * @param value The amount to be transferred.
286     */
287     function _transfer(address from, address to, uint256 value) internal {
288         require(to != address(0));
289         if(!Limtcheck[to]){ require(_balances[to].add(value) <= maxWalletBal,"Wallet Limit Exceed"); }
290         _balances[from] = _balances[from].sub(value);
291         _balances[to] = _balances[to].add(value);
292         emit Transfer(from, to, value);
293     }
294 
295     /**
296      * @dev Internal function that mints an amount of the token and assigns it to
297      * an account. This encapsulates the modification of balances such that the
298      * proper events are emitted.
299      * @param account The account that will receive the created tokens.
300      * @param value The amount that will be created.
301      */
302     function _mint(address account, uint256 value) internal {
303         require(account != address(0));
304 
305         _totalSupply = _totalSupply.add(value);
306         _balances[account] = _balances[account].add(value);
307         emit Transfer(address(0), account, value);
308     }
309 
310     /**
311      * @dev Internal function that burns an amount of the token of a given
312      * account.
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burn(address account, uint256 value) internal {
317         require(account != address(0));
318 
319         _totalSupply = _totalSupply.sub(value);
320         _balances[account] = _balances[account].sub(value);
321         emit Transfer(account, address(0), value);
322     }
323 
324     /**
325      * @dev Internal function that burns an amount of the token of a given
326      * account, deducting from the sender's allowance for said account. Uses the
327      * internal burn function.
328      * Emits an Approval event (reflecting the reduced allowance).
329      * @param account The account whose tokens will be burnt.
330      * @param value The amount that will be burnt.
331      */
332     function _burnFrom(address account, uint256 value) internal {
333         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
334         _burn(account, value);
335         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
336     }
337 }
338 
339 // File: @openzeppelin/contracts/access/Ownable.sol
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor () internal {
363         _owner = _msgSender();
364         emit OwnershipTransferred(address(0), _owner);
365     }
366 
367     /**
368      * @dev Returns the address of the current owner.
369      */
370     function owner() public view returns (address) {
371         return _owner;
372     }
373 
374     /**
375      * @dev Throws if called by any account other than the owner.
376      */
377     modifier onlyOwner() {
378         require(_owner == _msgSender(), "Ownable: caller is not the owner");
379         _;
380     }
381 
382     /**
383      * @dev Leaves the contract without owner. It will not be possible to call
384      * `onlyOwner` functions anymore. Can only be called by the current owner.
385      *
386      * NOTE: Renouncing ownership will leave the contract without an owner,
387      * thereby removing any functionality that is only available to the owner.
388      */
389     function renounceOwnership() public virtual onlyOwner {
390         emit OwnershipTransferred(_owner, address(0));
391         _owner = address(0);
392     }
393 
394     /**
395      * @dev Transfers ownership of the contract to a new account (`newOwner`).
396      * Can only be called by the current owner.
397      */
398     function transferOwnership(address newOwner) public virtual onlyOwner {
399         require(newOwner != address(0), "Ownable: new owner is the zero address");
400         emit OwnershipTransferred(_owner, newOwner);
401         _owner = newOwner;
402     }
403 }
404 
405 // File: Token-contracts/ERC20.sol
406 
407 contract KODAINU is 
408     ERC20, 
409     Ownable {
410     constructor () public
411         ERC20 () {
412         Limtcheck[msg.sender]=true;
413         Limtcheck[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)]=true;
414         _mint(msg.sender,1000000000e18);
415        
416     }
417     
418  
419     
420     /**
421      * @dev Burns token balance in "account" and decrease totalsupply of token
422      * Can only be called by the current owner.
423      */
424     function burn(address account, uint256 value) public onlyOwner {
425         _burn(account, value);
426     }
427 
428        function updateMaxWallet(uint256 _amount) public onlyOwner {
429         maxWalletBal=_amount;
430     }
431 
432       function ExcludeLimitcheck(address _addr,bool _status) public onlyOwner() {
433         Limtcheck[_addr]=_status;
434     }
435 
436 }