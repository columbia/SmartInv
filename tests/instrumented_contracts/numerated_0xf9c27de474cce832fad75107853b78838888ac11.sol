1 pragma solidity ^0.5.0;
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
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
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
97         require(isOwner());
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
110      * @notice Renouncing to ownership will leave the contract without an owner.
111      * It will not be possible to call the functions with the `onlyOwner`
112      * modifier anymore.
113      */
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     /**
120      * @dev Allows the current owner to transfer control of the contract to a newOwner.
121      * @param newOwner The address to transfer ownership to.
122      */
123     function transferOwnership(address newOwner) public onlyOwner {
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers control of the contract to a newOwner.
129      * @param newOwner The address to transfer ownership to.
130      */
131     function _transferOwnership(address newOwner) internal {
132         require(newOwner != address(0));
133         emit OwnershipTransferred(_owner, newOwner);
134         _owner = newOwner;
135     }
136 }
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 interface IERC20 {
143     function transfer(address to, uint256 value) external returns (bool);
144 
145     function approve(address spender, uint256 value) external returns (bool);
146 
147     function transferFrom(address from, address to, uint256 value) external returns (bool);
148 
149     function totalSupply() external view returns (uint256);
150 
151     function balanceOf(address who) external view returns (uint256);
152 
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
165  * Originally based on code by FirstBlood:
166  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  *
168  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
169  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
170  * compliant implementations may not do it.
171  */
172 contract ERC20 is IERC20 {
173     using SafeMath for uint256;
174 
175     mapping (address => uint256) private _balances;
176 
177     mapping (address => mapping (address => uint256)) private _allowed;
178 
179     uint256 private _totalSupply;
180 
181     /**
182     * @dev Total number of tokens in existence
183     */
184     function totalSupply() public view returns (uint256) {
185         return _totalSupply;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address.
190     * @param owner The address to query the balance of.
191     * @return An uint256 representing the amount owned by the passed address.
192     */
193     function balanceOf(address owner) public view returns (uint256) {
194         return _balances[owner];
195     }
196 
197     /**
198      * @dev Function to check the amount of tokens that an owner allowed to a spender.
199      * @param owner address The address which owns the funds.
200      * @param spender address The address which will spend the funds.
201      * @return A uint256 specifying the amount of tokens still available for the spender.
202      */
203     function allowance(address owner, address spender) public view returns (uint256) {
204         return _allowed[owner][spender];
205     }
206 
207     /**
208     * @dev Transfer token for a specified address
209     * @param to The address to transfer to.
210     * @param value The amount to be transferred.
211     */
212     function transfer(address to, uint256 value) public returns (bool) {
213         _transfer(msg.sender, to, value);
214         return true;
215     }
216 
217     /**
218      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param spender The address which will spend the funds.
224      * @param value The amount of tokens to be spent.
225      */
226     function approve(address spender, uint256 value) public returns (bool) {
227         require(spender != address(0));
228 
229         _allowed[msg.sender][spender] = value;
230         emit Approval(msg.sender, spender, value);
231         return true;
232     }
233 
234     /**
235      * @dev Transfer tokens from one address to another.
236      * Note that while this function emits an Approval event, this is not required as per the specification,
237      * and other compliant implementations may not emit the event.
238      * @param from address The address which you want to send tokens from
239      * @param to address The address which you want to transfer to
240      * @param value uint256 the amount of tokens to be transferred
241      */
242     function transferFrom(address from, address to, uint256 value) public returns (bool) {
243         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
244         _transfer(from, to, value);
245         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
246         return true;
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed_[_spender] == 0. To increment
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * Emits an Approval event.
256      * @param spender The address which will spend the funds.
257      * @param addedValue The amount of tokens to increase the allowance by.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
260         require(spender != address(0));
261 
262         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
263         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
264         return true;
265     }
266 
267     /**
268      * @dev Decrease the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed_[_spender] == 0. To decrement
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * Emits an Approval event.
274      * @param spender The address which will spend the funds.
275      * @param subtractedValue The amount of tokens to decrease the allowance by.
276      */
277     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
281         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282         return true;
283     }
284 
285     /**
286     * @dev Transfer token for a specified addresses
287     * @param from The address to transfer from.
288     * @param to The address to transfer to.
289     * @param value The amount to be transferred.
290     */
291     function _transfer(address from, address to, uint256 value) internal {
292         require(to != address(0));
293 
294         _balances[from] = _balances[from].sub(value);
295         _balances[to] = _balances[to].add(value);
296         emit Transfer(from, to, value);
297     }
298 
299     /**
300      * @dev Internal function that mints an amount of the token and assigns it to
301      * an account. This encapsulates the modification of balances such that the
302      * proper events are emitted.
303      * @param account The account that will receive the created tokens.
304      * @param value The amount that will be created.
305      */
306     function _mint(address account, uint256 value) internal {
307         require(account != address(0));
308 
309         _totalSupply = _totalSupply.add(value);
310         _balances[account] = _balances[account].add(value);
311         emit Transfer(address(0), account, value);
312     }
313 
314     function _burn(address account, uint256 value) internal {
315       _totalSupply = _totalSupply.sub(value);
316       _balances[account] = _balances[account].sub(value);
317       emit Transfer(account, address(0), value);
318     }
319 
320 }
321 
322 contract Pausable is Ownable{
323     event Paused();
324     event Unpaused();
325 
326     bool private _paused;
327 
328     function paused() public view returns (bool) {
329         return _paused;
330     }
331 
332     modifier whenNotPaused() {
333        require(!_paused);
334        _;
335    }
336 
337    modifier whenPaused() {
338        require(_paused);
339        _;
340    }
341 
342    function pause() public onlyOwner whenNotPaused {
343         _paused = true;
344         emit Paused();
345     }
346 
347     function unpause() public onlyOwner whenPaused {
348         _paused = false;
349         emit Unpaused();
350     }
351 
352 }
353 
354 contract Apmcoin is ERC20, Ownable, Pausable{
355 
356     string public constant name = "APM Coin";
357     string public constant symbol = "APM";
358     uint8 public constant decimals = 18;
359 
360     event ClaimedTokens(address indexed owner, address indexed _token, uint256 claimedBalance);
361     event RegisterBlacklist(address indexed account);
362     event UnregisterBlacklist(address indexed account);
363 
364     mapping (address => bool) private blacklist;
365 
366     constructor (uint256 initialBalance) public {
367         uint256 _initialBalance = initialBalance;
368         _mint(msg.sender, _initialBalance);
369     }
370 
371     function _transfer(address from, address to, uint256 value) whenNotPaused internal {
372         require(!isBlacklist(from) && !isBlacklist(to));
373         return super._transfer(from, to, value);
374     }
375 
376     function mint(address account, uint256 amount) onlyOwner public {
377         _mint(account, amount);
378     }
379 
380     function burn(uint256 amount) onlyOwner public {
381         _burn(msg.sender, amount);
382     }
383 
384     function isBlacklist(address account) public view returns (bool) {
385         return blacklist[account];
386     }
387 
388     function registerBlacklist(address account) onlyOwner public {
389         blacklist[account] = true;
390         emit RegisterBlacklist(account);
391     }
392 
393     function unregisterBlacklist(address account) onlyOwner public {
394         blacklist[account] = false;
395         emit UnregisterBlacklist(account);
396     }
397 
398     function claimTokens(address _token, uint256 _claimedBalance) public onlyOwner {
399         IERC20 token = IERC20(_token);
400         address thisAddress = address(this);
401         uint256 tokenBalance = token.balanceOf(thisAddress);
402         require(tokenBalance >= _claimedBalance);
403 
404         address owner = msg.sender;
405         token.transfer(owner, _claimedBalance);
406         emit ClaimedTokens(owner, _token, _claimedBalance);
407     }
408 }