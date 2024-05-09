1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-20
3 */
4 
5 pragma solidity ^0.5.7;
6 
7 /**
8  * @title SafeMath
9  * @dev Unsigned math operations with safety checks that revert on error.
10  */
11 library SafeMath {
12     /**
13      * @dev Adds two unsigned integers, reverts on overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         c = a + b;
17         assert(c >= a);
18         return c;
19     }
20 
21     /**
22      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
23      */
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33         if (a == 0) {
34             return 0;
35         }
36         c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40 
41     /**
42      * @dev Integer division of two unsigned integers truncating the quotient,
43      * reverts on division by zero.
44      */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         assert(b > 0);
47         uint256 c = a / b;
48         assert(a == b * c + a % b);
49         return a / b;
50     }
51 
52     /**
53      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
54      * reverts when dividing by zero.
55      */
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0);
58         return a % b;
59     }
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://eips.ethereum.org/EIPS/eip-20
66  */
67 interface IERC20{
68     function name() external view returns (string memory);
69     function symbol() external view returns (string memory);
70     function decimals() external view returns (uint256);
71     function totalSupply() external view returns (uint256);
72     function balanceOf(address owner) external view returns (uint256);
73     function transfer(address to, uint256 value) external returns (bool);
74     function transferFrom(address from, address to, uint256 value) external returns (bool);
75     function approve(address spender, uint256 value) external returns (bool);
76     function allowance(address owner, address spender) external view returns (uint256);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 /**
83  * @title Ownable
84  */
85 contract Ownable {
86     address internal _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev The Ownable constructor sets the original `owner` of the contract
92      * to the sender account.
93      */
94     constructor () internal {
95         _owner = msg.sender;
96         emit OwnershipTransferred(address(0), _owner);
97     }
98 
99     /**
100      * @return the address of the owner.
101      */
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     /**
107      * @dev Throws if called by any account other than the owner.
108      */
109     modifier onlyOwner() {
110         require(msg.sender == _owner);
111         _;
112     }
113 
114     /**
115      * @dev Allows the current owner to transfer control of the contract to a newOwner.
116      * @param newOwner The address to transfer ownership to.
117      */
118     function transferOwnership(address newOwner) external onlyOwner {
119         require(newOwner != address(0));
120         _owner = newOwner;
121         emit OwnershipTransferred(_owner, newOwner);
122     }
123 
124     /**
125      * @dev Rescue compatible ERC20 Token
126      *
127      * @param tokenAddr ERC20 The address of the ERC20 token contract
128      * @param receiver The address of the receiver
129      * @param amount uint256
130      */
131     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
132         IERC20 _token = IERC20(tokenAddr);
133         require(receiver != address(0));
134         uint256 balance = _token.balanceOf(address(this));
135 
136         require(balance >= amount);
137         assert(_token.transfer(receiver, amount));
138     }
139 
140     /**
141      * @dev Withdraw Ether
142      */
143     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
144         require(to != address(0));
145 
146         uint256 balance = address(this).balance;
147 
148         require(balance >= amount);
149         to.transfer(amount);
150     }
151 }
152 
153 /**
154  * @title Pausable
155  * @dev Base contract which allows children to implement an emergency stop mechanism.
156  */
157 contract Pausable is Ownable {
158     bool private _paused;
159 
160     event Paused(address account);
161     event Unpaused(address account);
162 
163     constructor () internal {
164         _paused = false;
165     }
166 
167     /**
168      * @return Returns true if the contract is paused, false otherwise.
169      */
170     function paused() public view returns (bool) {
171         return _paused;
172     }
173 
174     /**
175      * @dev Modifier to make a function callable only when the contract is not paused.
176      */
177     modifier whenNotPaused() {
178         require(!_paused);
179         _;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is paused.
184      */
185     modifier whenPaused() {
186         require(_paused);
187         _;
188     }
189 
190     /**
191      * @dev Called by a pauser to pause, triggers stopped state.
192      */
193     function pause() external onlyOwner whenNotPaused {
194         _paused = true;
195         emit Paused(msg.sender);
196     }
197 
198     /**
199      * @dev Called by a pauser to unpause, returns to normal state.
200      */
201     function unpause() external onlyOwner whenPaused {
202         _paused = false;
203         emit Unpaused(msg.sender);
204     }
205 }
206 
207 /**
208  * @title CoinWin Main Contract
209  */
210 contract CoinWin is Ownable, Pausable, IERC20 {
211     using SafeMath for uint256;
212 
213     string private _name = "CoinWin";
214     string private _symbol = "BS3";
215     uint256 private _decimals = 18;                // 18 decimals
216     uint256 private _cap = 734133197 * 10 **_decimals;   
217     uint256 private _totalSupply;
218 
219     mapping (address => bool) private _minter;
220     event Mint(address indexed to, uint256 value);
221     event MinterChanged(address account, bool state);
222 
223     mapping (address => uint256) private _balances;
224     mapping (address => mapping (address => uint256)) private _allowed;
225 
226     event Donate(address indexed account, uint256 amount);
227 
228     /**
229      * @dev Constructor
230      */
231     constructor() public {
232         _minter[msg.sender] = true;
233     }
234 
235     /**
236      * @dev donate
237      */
238     function () external payable {
239         emit Donate(msg.sender, msg.value);
240     }
241 
242 
243     /**
244      * @return the name of the token.
245      */
246     function name() public view returns (string memory) {
247         return _name;
248     }
249 
250     /**
251      * @return the symbol of the token.
252      */
253     function symbol() public view returns (string memory) {
254         return _symbol;
255     }
256 
257     /**
258      * @return the number of decimals of the token.
259      */
260     function decimals() public view returns (uint256) {
261         return _decimals;
262     }
263 
264     /**
265      * @return the cap for the token minting.
266      */
267     function cap() public view returns (uint256) {
268         return _cap;
269     }
270 
271     /**
272      * @dev Total number of tokens in existence.
273      */
274     function totalSupply() public view returns (uint256) {
275         return _totalSupply;
276     }
277 
278     /**
279      * @dev Gets the balance of the specified address.
280      * @param owner The address to query the balance of.
281      * @return A uint256 representing the amount owned by the passed address.
282      */
283     function balanceOf(address owner) public view returns (uint256) {
284         return _balances[owner];
285     }
286 
287     /**
288      * @dev Function to check the amount of tokens that an owner allowed to a spender.
289      * @param owner address The address which owns the funds.
290      * @param spender address The address which will spend the funds.
291      * @return A uint256 specifying the amount of tokens still available for the spender.
292      */
293     function allowance(address owner, address spender) public view returns (uint256) {
294         return _allowed[owner][spender];
295     }
296 
297     /**
298      * @dev Transfer token to a specified address.
299      * @param to The address to transfer to.
300      * @param value The amount to be transferred.
301      */
302     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
303         // Normal Transfer
304         _transfer(msg.sender, to, value);
305         return true;
306     }
307 
308     /**
309      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310      * @param spender The address which will spend the funds.
311      * @param value The amount of tokens to be spent.
312      */
313     function approve(address spender, uint256 value) public returns (bool) {
314         _approve(msg.sender, spender, value);
315         return true;
316     }
317 
318     /**
319      * @dev Increase the amount of tokens that an owner allowed to a spender.
320      * @param spender The address which will spend the funds.
321      * @param addedValue The amount of tokens to increase the allowance by.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Decrease the amount of tokens that an owner allowed to a spender.
330      * @param spender The address which will spend the funds.
331      * @param subtractedValue The amount of tokens to decrease the allowance by.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
334         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
335         return true;
336     }
337     /**
338      * @dev Transfer tokens from one address to another.
339      * @param from address The address which you want to send tokens from
340      * @param to address The address which you want to transfer to
341      * @param value uint256 the amount of tokens to be transferred
342      */
343     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
344         require(_allowed[from][msg.sender] >= value);
345         _transfer(from, to, value);
346         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
347         return true;
348     }
349 
350     /**
351      * @dev Transfer token for a specified addresses.
352      * @param from The address to transfer from.
353      * @param to The address to transfer to.
354      * @param value The amount to be transferred.
355      */
356     function _transfer(address from, address to, uint256 value) internal {
357         require(to != address(0));
358 
359         _balances[from] = _balances[from].sub(value);
360         _balances[to] = _balances[to].add(value);
361         emit Transfer(from, to, value);
362     }
363 
364     /**
365      * @dev Approve an address to spend another addresses' tokens.
366      * @param owner The address that owns the tokens.
367      * @param spender The address that will spend the tokens.
368      * @param value The number of tokens that can be spent.
369      */
370     function _approve(address owner, address spender, uint256 value) internal {
371         require(owner != address(0));
372         require(spender != address(0));
373 
374         _allowed[owner][spender] = value;
375         emit Approval(owner, spender, value);
376     }
377 
378 
379     /**
380      * @dev Throws if called by account not a minter.
381      */
382     modifier onlyMinter() {
383         require(_minter[msg.sender]);
384         _;
385     }
386 
387     /**
388      * @dev Returns true if the given account is minter.
389      */
390     function isMinter(address account) public view returns (bool) {
391         return _minter[account];
392     }
393 
394     /**
395      * @dev Set a minter state
396      */
397     function setMinterState(address account, bool state) external onlyOwner {
398         _minter[account] = state;
399         emit MinterChanged(account, state);
400     }
401 
402     /**
403      * @dev Function to mint tokens
404      * @param to The address that will receive the minted tokens.
405      * @param value The amount of tokens to mint.
406      * @return A boolean that indicates if the operation was successful.
407      */
408     function mint(address to, uint256 value) public onlyMinter returns (bool) {
409         _mint(to, value);
410         return true;
411     }
412 
413     /**
414      * @dev Internal function that mints an amount of the token and assigns it to an account.
415      * @param account The account that will receive the created tokens.
416      * @param value The amount that will be created.
417      */
418     function _mint(address account, uint256 value) internal {
419         require(_totalSupply.add(value) <= _cap);
420         require(account != address(0));
421 
422         _totalSupply = _totalSupply.add(value);
423         _balances[account] = _balances[account].add(value);
424         emit Mint(account, value);
425         emit Transfer(address(0), account, value);
426     }
427 }