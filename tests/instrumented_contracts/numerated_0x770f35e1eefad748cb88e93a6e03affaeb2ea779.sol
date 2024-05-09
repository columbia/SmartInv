1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-12
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath 
9  * @dev Unsigned math operations with safety checks that revert on error.
10  */
11 library SafeMath {
12     /**
13      * @dev Multiplies two unsigned integers, reverts on overflow.
14      */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31      */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42      * @dev Subtracts two unsigned integers, reverts on underflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Adds two unsigned integers, reverts on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57 
58         return c;
59     }
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://eips.ethereum.org/EIPS/eip-20
65  */
66 interface IERC20 {
67     function transfer(address to, uint256 value) external returns (bool);
68 
69     function approve(address spender, uint256 value) external returns (bool);
70 
71     function transferFrom(address from, address to, uint256 value) external returns (bool);
72 
73     function totalSupply() external view returns (uint256);
74 
75     function balanceOf(address who) external view returns (uint256);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90     address private _owner;
91 
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     /**
95      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
96      */
97     constructor () internal {
98         _owner = msg.sender;
99         emit OwnershipTransferred(address(0), _owner);
100     }
101 
102     /**
103      * @return the address of the owner.
104      */
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     /**
110      * @dev Throws if called by any account other than the owner.
111      */
112     modifier onlyOwner() {
113         require(isOwner(), "The caller must be owner");
114         _;
115     }
116 
117     /**
118      * @return true if `msg.sender` is the owner of the contract.
119      */
120     function isOwner() public view returns (bool) {
121         return msg.sender == _owner;
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0), "Cannot transfer control of the contract to the zero address");
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  * @dev Implementation of the basic standard token.
146  */
147 contract StandardToken is IERC20 {
148     using SafeMath for uint256;
149 
150     mapping (address => uint256) internal _balances;
151 
152     mapping (address => mapping (address => uint256)) internal _allowed;
153 
154     uint256 internal _totalSupply;
155     
156     /**
157      * @dev Total number of tokens in existence.
158      */
159     function totalSupply() public view returns (uint256) {
160         return _totalSupply;
161     }
162 
163     /**
164      * @dev Gets the balance of the specified address.
165      * @param owner The address to query the balance of.
166      * @return A uint256 representing the amount owned by the passed address.
167      */
168     function balanceOf(address owner) public view returns (uint256) {
169         return _balances[owner];
170     }
171 
172     /**
173      * @dev Function to check the amount of tokens that an owner allowed to a spender.
174      * @param owner address The address which owns the funds.
175      * @param spender address The address which will spend the funds.
176      * @return A uint256 specifying the amount of tokens still available for the spender.
177      */
178     function allowance(address owner, address spender) public view returns (uint256) {
179         return _allowed[owner][spender];
180     }
181 
182     /**
183      * @dev Transfer token to a specified address.
184      * @param to The address to transfer to.
185      * @param value The amount to be transferred.
186      */
187     function transfer(address to, uint256 value) public returns (bool) {
188         _transfer(msg.sender, to, value);
189         return true;
190     }
191 
192     /**
193      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194      * Beware that changing an allowance with this method brings the risk that someone may use both the old
195      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      * @param spender The address which will spend the funds.
199      * @param value The amount of tokens to be spent.
200      */
201     function approve(address spender, uint256 value) public returns (bool) {
202         _approve(msg.sender, spender, value);
203         return true;
204     }
205 
206     /**
207      * @dev Transfer tokens from one address to another.
208      * Note that while this function emits an Approval event, this is not required as per the specification,
209      * and other compliant implementations may not emit the event.
210      * @param from address The address which you want to send tokens from
211      * @param to address The address which you want to transfer to
212      * @param value uint256 the amount of tokens to be transferred
213      */
214     function transferFrom(address from, address to, uint256 value) public returns (bool) {
215         _transfer(from, to, value);
216         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
217         return true;
218     }
219 
220     /**
221      * @dev Increase the amount of tokens that an owner allowed to a spender.
222      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
223      * allowed value is better to use this function to avoid 2 calls (and wait until
224      * the first transaction is mined)
225      * From MonolithDAO Token.sol
226      * Emits an Approval event.
227      * @param spender The address which will spend the funds.
228      * @param addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
231         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
232         return true;
233     }
234 
235     /**
236      * @dev Decrease the amount of tokens that an owner allowed to a spender.
237      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
238      * allowed value is better to use this function to avoid 2 calls (and wait until
239      * the first transaction is mined)
240      * From MonolithDAO Token.sol
241      * Emits an Approval event.
242      * @param spender The address which will spend the funds.
243      * @param subtractedValue The amount of tokens to decrease the allowance by.
244      */
245     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
246         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
247         return true;
248     }
249 
250     /**
251      * @dev Transfer token for a specified address.
252      * @param from The address to transfer from.
253      * @param to The address to transfer to.
254      * @param value The amount to be transferred.
255      */
256     function _transfer(address from, address to, uint256 value) internal {
257         require(to != address(0), "Cannot transfer to the zero address");
258 
259         _balances[from] = _balances[from].sub(value);
260         _balances[to] = _balances[to].add(value);
261         emit Transfer(from, to, value);
262     }
263 
264     /**
265      * @dev Approve an address to spend another addresses' tokens.
266      * @param owner The address that owns the tokens.
267      * @param spender The address that will spend the tokens.
268      * @param value The number of tokens that can be spent.
269      */
270     function _approve(address owner, address spender, uint256 value) internal {
271         require(spender != address(0), "Cannot approve to the zero address");
272         require(owner != address(0), "Setter cannot be the zero address");
273 
274         _allowed[owner][spender] = value;
275         emit Approval(owner, spender, value);
276     }
277 
278 }
279 
280 /**
281  *  @title FreezableToken
282  */
283 contract FreezableToken is StandardToken, Ownable {
284     mapping(address=>bool) internal _frozenAccount;
285 
286     event FrozenAccount(address indexed target, bool frozen);
287 
288     /**
289      * @dev Returns whether the specified address is frozen.
290      * @param account A specified address.
291      */
292     function frozenAccount(address account) public view returns(bool){
293         return _frozenAccount[account];
294     }
295 
296     function frozen(address account) public view returns(bool){
297         bool frozen = true;
298         _frozenAccount[account] = frozen;
299   	    emit FrozenAccount(account, frozen);
300   	    return true;
301     }
302 
303     /**
304      * @dev Check if the specified address is frozen. Requires the specified address not to be frozen.
305      * @param account A specified address.
306      */
307     function frozenCheck(address account) internal view {
308         require(!frozenAccount(account), "Address has been frozen");
309     }
310 
311     /**
312      * @dev Modify the frozen status of the specified address.
313      * @param account A specified address.
314      * @param frozen Frozen status, true: freeze, false: unfreeze.
315      */
316     function freeze(address account, bool frozen) public onlyOwner {
317   	    _frozenAccount[account] = frozen;
318   	    emit FrozenAccount(account, frozen);
319     }
320 
321     /**
322      * @dev Rewrite the transfer function to check if the address participating is frozen.
323      */
324     function transfer(address _to, uint256 _value) public returns (bool) {
325         frozenCheck(msg.sender);
326         frozenCheck(_to);
327         return super.transfer(_to, _value);
328     }
329 
330     /**
331      * @dev Rewrite the transferFrom function to check if the address participating is frozen.
332      */
333     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
334         frozenCheck(msg.sender);
335         frozenCheck(_from);
336         frozenCheck(_to);
337         return super.transferFrom(_from, _to, _value);
338     }    
339 
340     /**
341      * @dev Rewrite the _approve function to check if the address participating is frozen.
342      */
343     function _approve(address owner, address spender, uint256 value) internal {
344         frozenCheck(owner);
345         frozenCheck(spender);
346         super._approve(owner, spender, value);
347     }
348 
349 }
350 
351 /**
352  * @title MintableToken
353  * @dev Implement the function of ERC20 token minting.
354  */
355 contract MintableToken is FreezableToken {
356     /**
357      * @dev Internal function that mints an amount of the token and assigns it to
358      * an account. This encapsulates the modification of balances such that the
359      * proper events are emitted.
360      * @param account The account that will receive the created tokens.
361      * @param value The amount that will be created.
362      */
363     function _mint(address account, uint256 value) internal {
364         require(account != address(0), "Cannot mint to the zero address");
365 
366         _totalSupply = _totalSupply.add(value);
367         _balances[account] = _balances[account].add(value);
368         emit Transfer(address(0), account, value);
369     }
370 
371     /**
372      * @dev Function to mint tokens
373      * @param to The address that will receive the minted tokens.
374      * @param value The amount of tokens to mint.
375      * @return A boolean that indicates if the operation was successful.
376      */
377     function mint(address to, uint256 value) public onlyOwner returns (bool) {
378         frozenCheck(to);
379         _mint(to, value);
380         return true;
381     }
382 }
383 
384 /**
385  * @title BurnableToken
386  * @dev Implement the function of ERC20 token burning.
387  */
388 contract BurnableToken is FreezableToken {
389 
390     /**
391     * @dev Burns a specific amount of tokens.
392     * @param _value The amount of token to be burned.
393     */
394     function burn(uint256 _value) public onlyOwner {
395         _burn(msg.sender, _value);
396     }
397 
398     /**
399     * @dev Burns a specific amount of tokens from the target address and decrements allowance
400     * @param _from address The address which you want to send tokens from
401     * @param _value uint256 The amount of token to be burned
402     */
403     function burnFrom(address _from, uint256 _value) public onlyOwner {
404         require(_value <= _allowed[_from][msg.sender], "Not enough allowance");
405         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
406         _burn(_from, _value);
407     }
408 
409     function _burn(address _who, uint256 _value) internal {
410         require(_value <= _balances[_who], "Not enough token balance");
411         // no need to require value <= totalSupply, since that would imply the
412         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
413         _balances[_who] = _balances[_who].sub(_value);
414         _totalSupply = _totalSupply.sub(_value);
415         emit Transfer(_who, address(0), _value);
416     }
417 }
418 
419 contract Token is MintableToken, BurnableToken {
420     string public  name; // name of Token 
421     string public  symbol; // symbol of Token 
422     uint8 public  decimals;
423     
424     constructor(string _name,
425     string _symbol, 
426     uint256 _initSupply, 
427     uint8 _decimals
428 	) public {
429 		name = _name;
430 		symbol = _symbol;
431 		decimals = _decimals;
432 	}
433     
434     /**
435      * @dev Transfer tokens to multiple addresses.
436      */
437     function airdrop(address[] memory addressList, uint256[] memory amountList) public onlyOwner returns (bool) {
438         uint256 length = addressList.length;
439         require(addressList.length == amountList.length, "Inconsistent array length");
440         require(length > 0 && length <= 150, "Invalid number of transfer objects");
441         uint256 amount;
442         for (uint256 i = 0; i < length; i++) {
443             frozenCheck(addressList[i]);
444             require(amountList[i] > 0, "The transfer amount cannot be 0");
445             require(addressList[i] != address(0), "Cannot transfer to the zero address");
446             amount = amount.add(amountList[i]);
447             _balances[addressList[i]] = _balances[addressList[i]].add(amountList[i]);
448             emit Transfer(msg.sender, addressList[i], amountList[i]);
449         }
450         require(_balances[msg.sender] >= amount, "Not enough tokens to transfer");
451         _balances[msg.sender] = _balances[msg.sender].sub(amount);
452         return true;
453     }        
454 }