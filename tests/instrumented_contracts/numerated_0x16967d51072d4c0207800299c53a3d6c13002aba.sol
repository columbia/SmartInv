1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
101 
102 pragma solidity ^0.5.0;
103 
104 /**
105  * @title SafeMath
106  * @dev Unsigned math operations with safety checks that revert on error
107  */
108 library SafeMath {
109     /**
110     * @dev Multiplies two unsigned integers, reverts on overflow.
111     */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b);
122 
123         return c;
124     }
125 
126     /**
127     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
128     */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
140     */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149     * @dev Adds two unsigned integers, reverts on overflow.
150     */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a);
154 
155         return c;
156     }
157 
158     /**
159     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
160     * reverts when dividing by zero.
161     */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         require(b != 0);
164         return a % b;
165     }
166 }
167 
168 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
169 
170 pragma solidity ^0.5.0;
171 
172 
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
179  * Originally based on code by FirstBlood:
180  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  *
182  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
183  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
184  * compliant implementations may not do it.
185  */
186 contract ERC20 is IERC20 {
187     using SafeMath for uint256;
188 
189     mapping (address => uint256) private _balances;
190 
191     mapping (address => mapping (address => uint256)) private _allowed;
192 
193     uint256 private _totalSupply;
194 
195     /**
196     * @dev Total number of tokens in existence
197     */
198     function totalSupply() public view returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203     * @dev Gets the balance of the specified address.
204     * @param owner The address to query the balance of.
205     * @return An uint256 representing the amount owned by the passed address.
206     */
207     function balanceOf(address owner) public view returns (uint256) {
208         return _balances[owner];
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param owner address The address which owns the funds.
214      * @param spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address owner, address spender) public view returns (uint256) {
218         return _allowed[owner][spender];
219     }
220 
221     /**
222     * @dev Transfer token for a specified address
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function transfer(address to, uint256 value) public returns (bool) {
227         _transfer(msg.sender, to, value);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233      * Beware that changing an allowance with this method brings the risk that someone may use both the old
234      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      * @param spender The address which will spend the funds.
238      * @param value The amount of tokens to be spent.
239      */
240     function approve(address spender, uint256 value) public returns (bool) {
241         require(spender != address(0));
242 
243         _allowed[msg.sender][spender] = value;
244         emit Approval(msg.sender, spender, value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another.
250      * Note that while this function emits an Approval event, this is not required as per the specification,
251      * and other compliant implementations may not emit the event.
252      * @param from address The address which you want to send tokens from
253      * @param to address The address which you want to transfer to
254      * @param value uint256 the amount of tokens to be transferred
255      */
256     function transferFrom(address from, address to, uint256 value) public returns (bool) {
257         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
258         _transfer(from, to, value);
259         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
260         return true;
261     }
262 
263     /**
264      * @dev Increase the amount of tokens that an owner allowed to a spender.
265      * approve should be called when allowed_[_spender] == 0. To increment
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * Emits an Approval event.
270      * @param spender The address which will spend the funds.
271      * @param addedValue The amount of tokens to increase the allowance by.
272      */
273     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
277         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278         return true;
279     }
280 
281     /**
282      * @dev Decrease the amount of tokens that an owner allowed to a spender.
283      * approve should be called when allowed_[_spender] == 0. To decrement
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * Emits an Approval event.
288      * @param spender The address which will spend the funds.
289      * @param subtractedValue The amount of tokens to decrease the allowance by.
290      */
291     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
292         require(spender != address(0));
293 
294         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
295         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
296         return true;
297     }
298 
299     /**
300     * @dev Transfer token for a specified addresses
301     * @param from The address to transfer from.
302     * @param to The address to transfer to.
303     * @param value The amount to be transferred.
304     */
305     function _transfer(address from, address to, uint256 value) internal {
306         // require(account != address(0));
307         if(to == address(0)) {
308             _burn(from, value);
309             return;
310         }
311         
312         _balances[from] = _balances[from].sub(value);
313         _balances[to] = _balances[to].add(value);
314         emit Transfer(from, to, value);
315     }
316 
317     /**
318      * @dev Internal function that mints an amount of the token and assigns it to
319      * an account. This encapsulates the modification of balances such that the
320      * proper events are emitted.
321      * @param account The account that will receive the created tokens.
322      * @param value The amount that will be created.
323      */
324     function _mint(address account, uint256 value) internal {
325         require(account != address(0));
326 
327         _totalSupply = _totalSupply.add(value);
328         _balances[account] = _balances[account].add(value);
329         emit Transfer(address(0), account, value);
330     }
331 
332     /**
333      * @dev Internal function that burns an amount of the token of a given
334      * account.
335      * @param account The account whose tokens will be burnt.
336      * @param value The amount that will be burnt.
337      */
338     function _burn(address account, uint256 value) internal {
339         require(account != address(0));
340 
341         _totalSupply = _totalSupply.sub(value);
342         _balances[account] = _balances[account].sub(value);
343         emit Transfer(account, address(0), value);
344     }
345 
346     /**
347      * @dev Internal function that burns an amount of the token of a given
348      * account, deducting from the sender's allowance for said account. Uses the
349      * internal burn function.
350      * Emits an Approval event (reflecting the reduced allowance).
351      * @param account The account whose tokens will be burnt.
352      * @param value The amount that will be burnt.
353      */
354     function _burnFrom(address account, uint256 value) internal {
355         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
356         _burn(account, value);
357         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
358     }
359     
360     
361     /**
362      * @dev Burns a specific amount of tokens.
363      * @param value The amount of token to be burned.
364      */
365     function burn(uint256 value) public {
366         _burn(msg.sender, value);
367     }
368 
369     /**
370      * @dev Burns a specific amount of tokens from the target address and decrements allowance
371      * @param from address The address which you want to send tokens from
372      * @param value uint256 The amount of token to be burned
373      */
374     function burnFrom(address from, uint256 value) public {
375         _burnFrom(from, value);
376     }
377 }
378 
379 
380 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
381 
382 pragma solidity ^0.5.0;
383 
384 
385 /**
386  * @title ERC20Detailed token
387  * @dev The decimals are only for visualization purposes.
388  * All the operations are done using the smallest and indivisible token unit,
389  * just as on Ethereum all the operations are done in wei.
390  */
391 contract ERC20Detailed is ERC20 {
392     string private _name;
393     string private _symbol;
394     uint8 private _decimals;
395 
396     constructor (string memory name, string memory symbol, uint8 decimals) public {
397         _name = name;
398         _symbol = symbol;
399         _decimals = decimals;
400     }
401 
402     /**
403      * @return the name of the token.
404      */
405     function name() public view returns (string memory) {
406         return _name;
407     }
408 
409     /**
410      * @return the symbol of the token.
411      */
412     function symbol() public view returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @return the number of decimals of the token.
418      */
419     function decimals() public view returns (uint8) {
420         return _decimals;
421     }
422 }
423 
424 // File: contracts\Token.sol
425 
426 pragma solidity ^0.5.0;
427 
428 
429 contract CXRToken is ERC20Detailed, Ownable {
430     constructor()
431     ERC20Detailed("Chain X Revolution Token", "CXR", 18)
432     public {
433         uint256 decimals = decimals();
434         uint256 supply = 38000000000;
435         uint256 initialSupply = supply * 10 ** decimals;
436         _mint(address(0x742236fbd952Cc462DD202F4143a9Fb5e8Fcd1A9), initialSupply);
437     }
438 }