1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Adds two unsigned integers, reverts on overflow.
10      */
11     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         c = a + b;
13         assert(c >= a);
14         return c;
15     }
16 
17     /**
18      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
19      */
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     /**
26      * @dev Multiplies two unsigned integers, reverts on overflow.
27      */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         if (a == 0) {
30             return 0;
31         }
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 
37     /**
38      * @dev Integer division of two unsigned integers truncating the quotient,
39      * reverts on division by zero.
40      */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b > 0);
43         uint256 c = a / b;
44         assert(a == b * c + a % b);
45         return a / b;
46     }
47 
48     /**
49      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
50      * reverts when dividing by zero.
51      */
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0);
54         return a % b;
55     }
56 }
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://eips.ethereum.org/EIPS/eip-20
62  */
63 interface IERC20{
64     function name() external view returns (string memory);
65     function symbol() external view returns (string memory);
66     function decimals() external view returns (uint256);
67     function totalSupply() external view returns (uint256);
68     function balanceOf(address owner) external view returns (uint256);
69     function transfer(address to, uint256 value) external returns (bool);
70     function transferFrom(address from, address to, uint256 value) external returns (bool);
71     function approve(address spender, uint256 value) external returns (bool);
72     function allowance(address owner, address spender) external view returns (uint256);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 /**
79  * @title Ownable
80  */
81 contract Ownable {
82     address internal _owner;
83 
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     /**
87      * @dev The Ownable constructor sets the original `owner` of the contract
88      * to the sender account.
89      */
90     constructor () internal {
91         _owner = msg.sender;
92         emit OwnershipTransferred(address(0), _owner);
93     }
94 
95     /**
96      * @return the address of the owner.
97      */
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(msg.sender == _owner);
107         _;
108     }
109 
110     /**
111      * @dev Allows the current owner to transfer control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address newOwner) external onlyOwner {
115         require(newOwner != address(0));
116         _owner = newOwner;
117         emit OwnershipTransferred(_owner, newOwner);
118     }
119 
120     /**
121      * @dev Rescue compatible ERC20 Token
122      *
123      * @param tokenAddr ERC20 The address of the ERC20 token contract
124      * @param receiver The address of the receiver
125      * @param amount uint256
126      */
127     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
128         IERC20 _token = IERC20(tokenAddr);
129         require(receiver != address(0));
130         uint256 balance = _token.balanceOf(address(this));
131 
132         require(balance >= amount);
133         assert(_token.transfer(receiver, amount));
134     }
135 
136     /**
137      * @dev Withdraw Ether
138      */
139     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
140         require(to != address(0));
141 
142         uint256 balance = address(this).balance;
143 
144         require(balance >= amount);
145         to.transfer(amount);
146     }
147 }
148 
149 /**
150  * @title Pausable
151  * @dev Base contract which allows children to implement an emergency stop mechanism.
152  */
153 contract Pausable is Ownable {
154     bool private _paused;
155 
156     event Paused(address account);
157     event Unpaused(address account);
158 
159     constructor () internal {
160         _paused = false;
161     }
162 
163     /**
164      * @return Returns true if the contract is paused, false otherwise.
165      */
166     function paused() public view returns (bool) {
167         return _paused;
168     }
169 
170     /**
171      * @dev Modifier to make a function callable only when the contract is not paused.
172      */
173     modifier whenNotPaused() {
174         require(!_paused);
175         _;
176     }
177 
178     /**
179      * @dev Modifier to make a function callable only when the contract is paused.
180      */
181     modifier whenPaused() {
182         require(_paused);
183         _;
184     }
185 
186     /**
187      * @dev Called by a pauser to pause, triggers stopped state.
188      */
189     function pause() external onlyOwner whenNotPaused {
190         _paused = true;
191         emit Paused(msg.sender);
192     }
193 
194     /**
195      * @dev Called by a pauser to unpause, returns to normal state.
196      */
197     function unpause() external onlyOwner whenPaused {
198         _paused = false;
199         emit Unpaused(msg.sender);
200     }
201 }
202 
203 /**
204  * @title OWpay Main Contract
205  */
206 contract OWpay is Ownable, Pausable, IERC20 {
207     using SafeMath for uint256;
208 
209     string private _name = "OWpay";
210     string private _symbol = "OW";
211     uint256 private _decimals = 18;                // 18 decimals
212     uint256 private _cap = 1000000000 * 10 **_decimals;   // 1 billion cap
213     uint256 private _totalSupply;
214 
215     mapping (address => bool) private _minter;
216     event Mint(address indexed to, uint256 value);
217     event MinterChanged(address account, bool state);
218 
219     mapping (address => uint256) private _balances;
220     mapping (address => mapping (address => uint256)) private _allowed;
221 
222     event Donate(address indexed account, uint256 amount);
223 
224     /**
225      * @dev Constructor
226      */
227     constructor() public {
228         _minter[msg.sender] = true;
229     }
230 
231     /**
232      * @dev donate
233      */
234     function () external payable {
235         emit Donate(msg.sender, msg.value);
236     }
237 
238 
239     /**
240      * @return the name of the token.
241      */
242     function name() public view returns (string memory) {
243         return _name;
244     }
245 
246     /**
247      * @return the symbol of the token.
248      */
249     function symbol() public view returns (string memory) {
250         return _symbol;
251     }
252 
253     /**
254      * @return the number of decimals of the token.
255      */
256     function decimals() public view returns (uint256) {
257         return _decimals;
258     }
259 
260     /**
261      * @return the cap for the token minting.
262      */
263     function cap() public view returns (uint256) {
264         return _cap;
265     }
266 
267     /**
268      * @dev Total number of tokens in existence.
269      */
270     function totalSupply() public view returns (uint256) {
271         return _totalSupply;
272     }
273 
274     /**
275      * @dev Gets the balance of the specified address.
276      * @param owner The address to query the balance of.
277      * @return A uint256 representing the amount owned by the passed address.
278      */
279     function balanceOf(address owner) public view returns (uint256) {
280         return _balances[owner];
281     }
282 
283     /**
284      * @dev Function to check the amount of tokens that an owner allowed to a spender.
285      * @param owner address The address which owns the funds.
286      * @param spender address The address which will spend the funds.
287      * @return A uint256 specifying the amount of tokens still available for the spender.
288      */
289     function allowance(address owner, address spender) public view returns (uint256) {
290         return _allowed[owner][spender];
291     }
292 
293     /**
294      * @dev Transfer token to a specified address.
295      * @param to The address to transfer to.
296      * @param value The amount to be transferred.
297      */
298     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
299         // Normal Transfer
300         _transfer(msg.sender, to, value);
301         return true;
302     }
303 
304     /**
305      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306      * @param spender The address which will spend the funds.
307      * @param value The amount of tokens to be spent.
308      */
309     function approve(address spender, uint256 value) public returns (bool) {
310         _approve(msg.sender, spender, value);
311         return true;
312     }
313 
314     /**
315      * @dev Increase the amount of tokens that an owner allowed to a spender.
316      * @param spender The address which will spend the funds.
317      * @param addedValue The amount of tokens to increase the allowance by.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
320         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Decrease the amount of tokens that an owner allowed to a spender.
326      * @param spender The address which will spend the funds.
327      * @param subtractedValue The amount of tokens to decrease the allowance by.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
330         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
331         return true;
332     }
333     /**
334      * @dev Transfer tokens from one address to another.
335      * @param from address The address which you want to send tokens from
336      * @param to address The address which you want to transfer to
337      * @param value uint256 the amount of tokens to be transferred
338      */
339     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
340         require(_allowed[from][msg.sender] >= value);
341         _transfer(from, to, value);
342         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
343         return true;
344     }
345 
346     /**
347      * @dev Transfer token for a specified addresses.
348      * @param from The address to transfer from.
349      * @param to The address to transfer to.
350      * @param value The amount to be transferred.
351      */
352     function _transfer(address from, address to, uint256 value) internal {
353         require(to != address(0));
354 
355         _balances[from] = _balances[from].sub(value);
356         _balances[to] = _balances[to].add(value);
357         emit Transfer(from, to, value);
358     }
359 
360     /**
361      * @dev Approve an address to spend another addresses' tokens.
362      * @param owner The address that owns the tokens.
363      * @param spender The address that will spend the tokens.
364      * @param value The number of tokens that can be spent.
365      */
366     function _approve(address owner, address spender, uint256 value) internal {
367         require(owner != address(0));
368         require(spender != address(0));
369 
370         _allowed[owner][spender] = value;
371         emit Approval(owner, spender, value);
372     }
373 
374 
375     /**
376      * @dev Throws if called by account not a minter.
377      */
378     modifier onlyMinter() {
379         require(_minter[msg.sender]);
380         _;
381     }
382 
383     /**
384      * @dev Returns true if the given account is minter.
385      */
386     function isMinter(address account) public view returns (bool) {
387         return _minter[account];
388     }
389 
390     /**
391      * @dev Set a minter state
392      */
393     function setMinterState(address account, bool state) external onlyOwner {
394         _minter[account] = state;
395         emit MinterChanged(account, state);
396     }
397 
398     /**
399      * @dev Function to mint tokens
400      * @param to The address that will receive the minted tokens.
401      * @param value The amount of tokens to mint.
402      * @return A boolean that indicates if the operation was successful.
403      */
404     function mint(address to, uint256 value) public onlyMinter returns (bool) {
405         _mint(to, value);
406         return true;
407     }
408 
409     /**
410      * @dev Internal function that mints an amount of the token and assigns it to an account.
411      * @param account The account that will receive the created tokens.
412      * @param value The amount that will be created.
413      */
414     function _mint(address account, uint256 value) internal {
415         require(_totalSupply.add(value) <= _cap);
416         require(account != address(0));
417 
418         _totalSupply = _totalSupply.add(value);
419         _balances[account] = _balances[account].add(value);
420         emit Mint(account, value);
421         emit Transfer(address(0), account, value);
422     }
423 }