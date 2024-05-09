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
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
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
38      * @dev Subtracts two unsigned integers, reverts on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
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
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://eips.ethereum.org/EIPS/eip-20
61  */
62 interface IERC20 {
63     function transfer(address to, uint256 value) external returns (bool);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68 
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address who) external view returns (uint256);
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
92      */
93     constructor () internal {
94         _owner = msg.sender;
95         emit OwnershipTransferred(address(0), _owner);
96     }
97 
98     /**
99      * @return the address of the owner.
100      */
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(isOwner(), "The caller must be owner");
110         _;
111     }
112 
113     /**
114      * @return true if `msg.sender` is the owner of the contract.
115      */
116     function isOwner() public view returns (bool) {
117         return msg.sender == _owner;
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
133         require(newOwner != address(0), "Cannot transfer control of the contract to the zero address");
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  * @dev Implementation of the basic standard token.
142  */
143 contract StandardToken is IERC20 {
144     using SafeMath for uint256;
145 
146     mapping (address => uint256) internal _balances;
147 
148     mapping (address => mapping (address => uint256)) internal _allowed;
149 
150     uint256 internal _totalSupply;
151     
152     /**
153      * @dev Total number of tokens in existence.
154      */
155     function totalSupply() public view returns (uint256) {
156         return _totalSupply;
157     }
158 
159     /**
160      * @dev Gets the balance of the specified address.
161      * @param owner The address to query the balance of.
162      * @return A uint256 representing the amount owned by the passed address.
163      */
164     function balanceOf(address owner) public view returns (uint256) {
165         return _balances[owner];
166     }
167 
168     /**
169      * @dev Function to check the amount of tokens that an owner allowed to a spender.
170      * @param owner address The address which owns the funds.
171      * @param spender address The address which will spend the funds.
172      * @return A uint256 specifying the amount of tokens still available for the spender.
173      */
174     function allowance(address owner, address spender) public view returns (uint256) {
175         return _allowed[owner][spender];
176     }
177 
178     /**
179      * @dev Transfer token to a specified address.
180      * @param to The address to transfer to.
181      * @param value The amount to be transferred.
182      */
183     function transfer(address to, uint256 value) public returns (bool) {
184         _transfer(msg.sender, to, value);
185         return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      * Beware that changing an allowance with this method brings the risk that someone may use both the old
191      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      * @param spender The address which will spend the funds.
195      * @param value The amount of tokens to be spent.
196      */
197     function approve(address spender, uint256 value) public returns (bool) {
198         _approve(msg.sender, spender, value);
199         return true;
200     }
201 
202     /**
203      * @dev Transfer tokens from one address to another.
204      * Note that while this function emits an Approval event, this is not required as per the specification,
205      * and other compliant implementations may not emit the event.
206      * @param from address The address which you want to send tokens from
207      * @param to address The address which you want to transfer to
208      * @param value uint256 the amount of tokens to be transferred
209      */
210     function transferFrom(address from, address to, uint256 value) public returns (bool) {
211         _transfer(from, to, value);
212         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
213         return true;
214     }
215 
216     /**
217      * @dev Increase the amount of tokens that an owner allowed to a spender.
218      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * Emits an Approval event.
223      * @param spender The address which will spend the funds.
224      * @param addedValue The amount of tokens to increase the allowance by.
225      */
226     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
227         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the amount of tokens that an owner allowed to a spender.
233      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
234      * allowed value is better to use this function to avoid 2 calls (and wait until
235      * the first transaction is mined)
236      * From MonolithDAO Token.sol
237      * Emits an Approval event.
238      * @param spender The address which will spend the funds.
239      * @param subtractedValue The amount of tokens to decrease the allowance by.
240      */
241     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
242         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
243         return true;
244     }
245 
246     /**
247      * @dev Transfer token for a specified address.
248      * @param from The address to transfer from.
249      * @param to The address to transfer to.
250      * @param value The amount to be transferred.
251      */
252     function _transfer(address from, address to, uint256 value) internal {
253         require(to != address(0), "Cannot transfer to the zero address");
254 
255         _balances[from] = _balances[from].sub(value);
256         _balances[to] = _balances[to].add(value);
257         emit Transfer(from, to, value);
258     }
259 
260     /**
261      * @dev Approve an address to spend another addresses' tokens.
262      * @param owner The address that owns the tokens.
263      * @param spender The address that will spend the tokens.
264      * @param value The number of tokens that can be spent.
265      */
266     function _approve(address owner, address spender, uint256 value) internal {
267         require(spender != address(0), "Cannot approve to the zero address");
268         require(owner != address(0), "Setter cannot be the zero address");
269 
270         _allowed[owner][spender] = value;
271         emit Approval(owner, spender, value);
272     }
273 
274 }
275 
276 /**
277  *  @title FreezableToken
278  */
279 contract FreezableToken is StandardToken, Ownable {
280     mapping(address=>bool) internal _frozenAccount;
281 
282     event FrozenAccount(address indexed target, bool frozen);
283 
284     /**
285      * @dev Returns whether the specified address is frozen.
286      * @param account A specified address.
287      */
288     function frozenAccount(address account) public view returns(bool){
289         return _frozenAccount[account];
290     }
291 
292     /**
293      * @dev Check if the specified address is frozen. Requires the specified address not to be frozen.
294      * @param account A specified address.
295      */
296     function frozenCheck(address account) internal view {
297         require(!frozenAccount(account), "Address has been frozen");
298     }
299 
300     /**
301      * @dev Modify the frozen status of the specified address.
302      * @param account A specified address.
303      * @param frozen Frozen status, true: freeze, false: unfreeze.
304      */
305     function freeze(address account, bool frozen) public onlyOwner {
306   	    _frozenAccount[account] = frozen;
307   	    emit FrozenAccount(account, frozen);
308     }
309 
310     /**
311      * @dev Rewrite the transfer function to check if the address participating is frozen.
312      */
313     function transfer(address _to, uint256 _value) public returns (bool) {
314         frozenCheck(msg.sender);
315         frozenCheck(_to);
316         return super.transfer(_to, _value);
317     }
318 
319     /**
320      * @dev Rewrite the transferFrom function to check if the address participating is frozen.
321      */
322     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
323         frozenCheck(msg.sender);
324         frozenCheck(_from);
325         frozenCheck(_to);
326         return super.transferFrom(_from, _to, _value);
327     }    
328 
329     /**
330      * @dev Rewrite the _approve function to check if the address participating is frozen.
331      */
332     function _approve(address owner, address spender, uint256 value) internal {
333         frozenCheck(owner);
334         frozenCheck(spender);
335         super._approve(owner, spender, value);
336     }
337 
338 }
339 
340 /**
341  * @title MintableToken
342  * @dev Implement the function of ERC20 token minting.
343  */
344 contract MintableToken is FreezableToken {
345     /**
346      * @dev Internal function that mints an amount of the token and assigns it to
347      * an account. This encapsulates the modification of balances such that the
348      * proper events are emitted.
349      * @param account The account that will receive the created tokens.
350      * @param value The amount that will be created.
351      */
352     function _mint(address account, uint256 value) internal {
353         require(account != address(0), "Cannot mint to the zero address");
354 
355         _totalSupply = _totalSupply.add(value);
356         _balances[account] = _balances[account].add(value);
357         emit Transfer(address(0), account, value);
358     }
359 
360     /**
361      * @dev Function to mint tokens
362      * @param to The address that will receive the minted tokens.
363      * @param value The amount of tokens to mint.
364      * @return A boolean that indicates if the operation was successful.
365      */
366     function mint(address to, uint256 value) public onlyOwner returns (bool) {
367         frozenCheck(to);
368         _mint(to, value);
369         return true;
370     }
371 }
372 
373 /**
374  * @title BurnableToken
375  * @dev Implement the function of ERC20 token burning.
376  */
377 contract BurnableToken is FreezableToken {
378 
379     /**
380     * @dev Burns a specific amount of tokens.
381     * @param _value The amount of token to be burned.
382     */
383     function burn(uint256 _value) public onlyOwner {
384         _burn(msg.sender, _value);
385     }
386 
387     /**
388     * @dev Burns a specific amount of tokens from the target address and decrements allowance
389     * @param _from address The address which you want to send tokens from
390     * @param _value uint256 The amount of token to be burned
391     */
392     function burnFrom(address _from, uint256 _value) public onlyOwner {
393         require(_value <= _allowed[_from][msg.sender], "Not enough allowance");
394         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
395         _burn(_from, _value);
396     }
397 
398     function _burn(address _who, uint256 _value) internal {
399         require(_value <= _balances[_who], "Not enough token balance");
400         // no need to require value <= totalSupply, since that would imply the
401         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
402         _balances[_who] = _balances[_who].sub(_value);
403         _totalSupply = _totalSupply.sub(_value);
404         emit Transfer(_who, address(0), _value);
405     }
406 }
407 
408 contract GGCToken is MintableToken, BurnableToken {
409     string public constant name = "Global Gold Coins"; // name of Token 
410     string public constant symbol = "GGC"; // symbol of Token 
411     uint8 public constant decimals = 18;
412 
413     /**
414      * @dev Transfer tokens to multiple addresses.
415      */
416     function airdrop(address[] memory addressList, uint256[] memory amountList) public onlyOwner returns (bool) {
417         uint256 length = addressList.length;
418         require(addressList.length == amountList.length, "Inconsistent array length");
419         require(length > 0 && length <= 150, "Invalid number of transfer objects");
420         uint256 amount;
421         for (uint256 i = 0; i < length; i++) {
422             frozenCheck(addressList[i]);
423             require(amountList[i] > 0, "The transfer amount cannot be 0");
424             require(addressList[i] != address(0), "Cannot transfer to the zero address");
425             amount = amount.add(amountList[i]);
426             _balances[addressList[i]] = _balances[addressList[i]].add(amountList[i]);
427             emit Transfer(msg.sender, addressList[i], amountList[i]);
428         }
429         require(_balances[msg.sender] >= amount, "Not enough tokens to transfer");
430         _balances[msg.sender] = _balances[msg.sender].sub(amount);
431         return true;
432     }        
433 }