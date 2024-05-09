1 /**
2  * Developed by The Flowchain Foundation
3  */
4 pragma solidity 0.5.16;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address public owner;
13     address public newOwner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     constructor() public {
18         owner = msg.sender;
19         newOwner = address(0);
20     }
21 
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     modifier onlyNewOwner() {
28         require(msg.sender != address(0));
29         require(msg.sender == newOwner);
30         _;
31     }
32     
33     function isOwner(address account) public view returns (bool) {
34         if( account == owner ){
35             return true;
36         }
37         else {
38             return false;
39         }
40     }
41 
42     function transferOwnership(address _newOwner) public onlyOwner {
43         require(_newOwner != address(0));
44         newOwner = _newOwner;
45     }
46 
47     function acceptOwnership() public onlyNewOwner {
48         emit OwnershipTransferred(owner, newOwner);        
49         owner = newOwner;
50         newOwner = address(0);
51     }
52 }
53 
54 /**
55  * @title Pausable
56  * @dev The Pausable can pause and unpause the token transfers.
57  */
58 contract Pausable is Ownable {
59     event Paused(address account);
60     event Unpaused(address account);
61 
62     bool private _paused;
63 
64     constructor () public {
65         _paused = false;
66     }    
67 
68     /**
69      * @return true if the contract is paused, false otherwise.
70      */
71     function paused() public view returns (bool) {
72         return _paused;
73     }
74 
75     /**
76      * @dev Modifier to make a function callable only when the contract is not paused.
77      */
78     modifier whenNotPaused() {
79         require(!_paused);
80         _;
81     }
82 
83     /**
84      * @dev Modifier to make a function callable only when the contract is paused.
85      */
86     modifier whenPaused() {
87         require(_paused);
88         _;
89     }
90 
91     /**
92      * @dev called by the owner to pause, triggers stopped state
93      */
94     function pause() public onlyOwner whenNotPaused {
95         _paused = true;
96         emit Paused(msg.sender);
97     }
98 
99     /**
100      * @dev called by the owner to unpause, returns to normal state
101      */
102     function unpause() public onlyOwner whenPaused {
103         _paused = false;
104         emit Unpaused(msg.sender);
105     }
106 }
107 
108 library SafeMath {
109     function add(uint a, uint b) internal pure returns (uint) {
110         uint c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115     function sub(uint a, uint b) internal pure returns (uint) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
119         require(b <= a, errorMessage);
120         uint c = a - b;
121 
122         return c;
123     }
124     function mul(uint a, uint b) internal pure returns (uint) {
125         if (a == 0) {
126             return 0;
127         }
128 
129         uint c = a * b;
130         require(c / a == b, "SafeMath: multiplication overflow");
131 
132         return c;
133     }
134     function div(uint a, uint b) internal pure returns (uint) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
138         // Solidity only automatically asserts when dividing by 0
139         require(b > 0, errorMessage);
140         uint c = a / b;
141 
142         return c;
143     }
144 }
145 
146 /**
147  * @title The ERC20 tokens
148  */
149 interface IERC20 {
150     function totalSupply() external view returns (uint);
151     function balanceOf(address account) external view returns (uint);
152     function transfer(address recipient, uint amount) external returns (bool);
153     function allowance(address owner, address spender) external view returns (uint);
154     function approve(address spender, uint amount) external returns (bool);
155     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
156     event Transfer(address indexed from, address indexed to, uint value);
157     event Approval(address indexed owner, address indexed spender, uint value);
158 }
159 
160 contract Context {
161     constructor () internal { }
162 
163     function _msgSender() internal view returns (address payable) {
164         return msg.sender;
165     }
166 }
167 
168 /**
169  * @dev The ERC20 standard implementation.
170  */
171 contract ERC20 is Context, IERC20 {
172     using SafeMath for uint;
173 
174     mapping (address => uint) private _balances;
175     mapping (address => mapping (address => uint)) private _allowances;
176 
177     uint private _totalSupply;
178 
179     function totalSupply() public view returns (uint) {
180         return _totalSupply;
181     }
182 
183     function balanceOf(address account) public view returns (uint) {
184         return _balances[account];
185     }
186 
187     function transfer(address recipient, uint amount) public returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view returns (uint) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint amount) public returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
204         return true;
205     }
206 
207     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
208         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
209         return true;
210     }
211 
212     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
213         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
214         return true;
215     }
216 
217     function _transfer(address sender, address recipient, uint amount) internal {
218         require(sender != address(0), "ERC20: transfer from the zero address");
219         require(recipient != address(0), "ERC20: transfer to the zero address");
220 
221         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
222         _balances[recipient] = _balances[recipient].add(amount);
223         emit Transfer(sender, recipient, amount);
224     }
225 
226     function _mint(address account, uint amount) internal {
227         require(account != address(0), "ERC20: mint to the zero address");
228 
229         _totalSupply = _totalSupply.add(amount);
230         _balances[account] = _balances[account].add(amount);
231         emit Transfer(address(0), account, amount);
232     }
233 
234     function _burn(address account, uint amount) internal {
235         require(account != address(0), "ERC20: burn from the zero address");
236 
237         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
238         _totalSupply = _totalSupply.sub(amount);
239         emit Transfer(account, address(0), amount);
240     }
241 
242     function _approve(address owner, address spender, uint amount) internal {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245 
246         _allowances[owner][spender] = amount;
247         emit Approval(owner, spender, amount);
248     }
249 }
250 
251 contract ERC20Detailed is IERC20 {
252     string private _name;
253     string private _symbol;
254     uint8 private _decimals;
255 
256     constructor (string memory name, string memory symbol, uint8 decimals) public {
257         _name = name;
258         _symbol = symbol;
259         _decimals = decimals;
260     }
261 
262     function name() public view returns (string memory) {
263         return _name;
264     }
265 
266     function symbol() public view returns (string memory) {
267         return _symbol;
268     }
269 
270     function decimals() public view returns (uint8) {
271         return _decimals;
272     }
273 }
274 
275 /**
276  * @title Address
277  * @dev Check if the address is a contract using eip-1052
278  */
279 library Address {
280     function isContract(address account) internal view returns (bool) {
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != 0x0 && codehash != accountHash);
286     }
287 }
288 
289 library SafeERC20 {
290     using SafeMath for uint;
291     using Address for address;
292 
293     function safeTransfer(IERC20 token, address to, uint value) internal {
294         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
295     }
296 
297     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
298         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
299     }
300 
301     function safeApprove(IERC20 token, address spender, uint value) internal {
302         require((value == 0) || (token.allowance(address(this), spender) == 0),
303             "SafeERC20: approve from non-zero to non-zero allowance"
304         );
305         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
306     }
307     function callOptionalReturn(IERC20 token, bytes memory data) private {
308         require(address(token).isContract(), "SafeERC20: call to non-contract");
309 
310         // solhint-disable-next-line avoid-low-level-calls
311         (bool success, bytes memory returndata) = address(token).call(data);
312         require(success, "SafeERC20: low-level call failed");
313 
314         if (returndata.length > 0) { // Return data is optional
315             // solhint-disable-next-line max-line-length
316             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
317         }
318     }
319 }
320 
321 contract DexToken is ERC20, ERC20Detailed, Ownable, Pausable {
322     using SafeERC20 for IERC20;
323     using Address for address;
324     using SafeMath for uint;
325 
326     event Freeze(address indexed account);
327     event Unfreeze(address indexed account);
328 
329     mapping (address => bool) public minters;
330     mapping (address => bool) public frozenAccount;
331 
332     address public governance;    
333 
334     modifier notFrozen(address _account) {
335         require(!frozenAccount[_account]);
336         _;
337     }
338 
339     constructor () public ERC20Detailed("Dextoken Governance", "DEXG", 18) {
340         governance = msg.sender;
341     }
342 
343     function transfer(address to, uint value) public notFrozen(msg.sender) whenNotPaused returns (bool) {
344         return super.transfer(to, value);
345     }   
346 
347     function transferFrom(address from, address to, uint value) public notFrozen(from) whenNotPaused returns (bool) {
348         return super.transferFrom(from, to, value);
349     }
350 
351     /**
352      * @dev Freeze an user
353      * @param account The address of the user who will be frozen
354      * @return The result of freezing an user
355      */
356     function freezeAccount(address account) external onlyOwner returns (bool) {
357         require(!frozenAccount[account], "ERC20: account frozen");
358         frozenAccount[account] = true;
359         emit Freeze(account);
360         return true;
361     }
362 
363     /**
364      * @dev Unfreeze an user
365      * @param account The address of the user who will be unfrozen
366      * @return The result of unfreezing an user
367      */
368     function unfreezeAccount(address account) external onlyOwner returns (bool) {
369         require(frozenAccount[account], "ERC20: account not frozen");
370         frozenAccount[account] = false;
371         emit Unfreeze(account);
372         return true;
373     }
374 
375     function setGovernance(address _governance) public {
376         require(msg.sender == governance, "!governance");
377         governance = _governance;
378     }
379 
380     /**
381      * @dev Setup the address that can mint tokens
382      * @param minter The address of the minter
383      * @return The result of the setup
384      */
385     function addMinter(address minter) external returns (bool success) {
386         require(msg.sender == governance, "!governance");    
387         minters[minter] = true;
388         return true;
389     }
390 
391     /**
392      * @dev Remove the address from minters
393      * @param minter The address of the minter
394      * @return The result of the setup
395      */
396     function removeMinter(address minter) external returns (bool success) {
397         require(msg.sender == governance, "!governance");
398         minters[minter] = false;
399         return true;
400     }
401 
402     /**
403      * @dev Mint an amount of tokens and transfer to the user
404      * @param account The address of the user who will receive the tokens
405      * @param amount The amount of tokens
406      * @return The result of token minting
407      */
408     function mint(address account, uint amount) external returns (bool success) {
409         require(minters[msg.sender], "!minter");    
410         _mint(account, amount);
411         return true;
412     }
413 
414     /**
415      * @dev Burn an amount of tokens
416      * @param account The address of the wallet
417      * @param amount The amount of tokens to burn
418      * @return The result of token burning
419      */
420     function burn(address account, uint amount) external returns (bool success) {
421         require(msg.sender == governance, "!governance");    
422         _burn(account, amount);
423         return true;
424     }    
425 }