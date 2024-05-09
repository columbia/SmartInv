1 /*   
2   _____  _    _  _____ 
3  |  __ \| |  | |/ ____|
4  | |__) | |  | | |  __ 
5  |  _  /| |  | | | |_ |
6  | | \ \| |__| | |__| |
7  |_|  \_\\____/ \_____|
8 
9 https://rug.money/ 
10 */
11 
12 pragma solidity ^0.6.0;
13 
14 interface IERC20 {
15 
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 // library to prevent overflow for uint256
27 
28 library SafeMath {
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         return mod(a, b, "SafeMath: modulo by zero");
71     }
72 
73     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b != 0, errorMessage);
75         return a % b;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) internal _balances;
85     mapping (address => mapping (address => uint256)) internal _allowances;
86     mapping (address => bool) internal _whitelist;
87     bool internal _globalWhitelist = true;
88 
89     uint256 internal _totalSupply;
90 
91     string internal _name;
92     string internal _symbol;
93     uint8 internal _decimals;
94     uint256 internal burnRate = 5; // Burn Rate is 5%
95 
96     constructor (string memory name, string memory symbol) public {
97         _name = name;
98         _symbol = symbol;
99         _decimals = 18;
100     }
101 
102     function name() public view returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view returns (uint8) {
111         return _decimals;
112     }
113 
114     function totalSupply() public view override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(msg.sender, recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(msg.sender, spender, amount);
133         return true;
134     }
135 
136     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
137         _transfer(sender, recipient, amount);
138         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
139         return true;
140     }
141 
142     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
143         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
144         return true;
145     }
146 
147     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
148         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
149         return true;
150     }
151 
152     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
153         require(sender != address(0), "ERC20: transfer from the zero address");
154         require(recipient != address(0), "ERC20: transfer to the zero address");
155  
156         if (_globalWhitelist == false) {
157           if (_whitelist[sender] == false && _whitelist[recipient] == false) { // recipient being staking pools; sender used for presale airdrop
158             amount = _burn(sender, amount, burnRate);
159           }
160         }
161 
162         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
163         _balances[recipient] = _balances[recipient].add(amount);
164         emit Transfer(sender, recipient, amount);
165     }
166 
167     function _mint(address account, uint256 amount) internal virtual { }
168 
169     /* Takes an amount, burns % of it, returns remaining amount */
170     function _burn(address account, uint256 amount, uint256 bRate) internal virtual returns(uint256) { 
171         require(account != address(0), "ERC20: burn from the zero address");
172         require(bRate <= 100, "Can't burn more than 100%!");
173 
174         uint256 burnCalc = (amount.mul(bRate).div(100));
175         uint256 remainingAfterBurn = amount.sub(burnCalc);
176 
177         _balances[account] = _balances[account].sub(burnCalc, "ERC20: burn amount exceeds balance");
178         _totalSupply = _totalSupply.sub(burnCalc);
179         emit Transfer(account, address(0), burnCalc);
180         return (remainingAfterBurn);
181     }
182 
183     function _approve(address owner, address spender, uint256 amount) internal virtual {
184         require(owner != address(0), "ERC20: approve from the zero address");
185         require(spender != address(0), "ERC20: approve to the zero address");
186 
187         _allowances[owner][spender] = amount;
188         emit Approval(owner, spender, amount);
189     }
190 
191     function _setupDecimals(uint8 decimals_) internal {
192         _decimals = decimals_;
193     }
194 
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
198 
199 abstract contract ERC20Capped is ERC20 {
200     uint256 private _cap;
201 
202     constructor (uint256 cap) public {
203         require(cap > 0, "ERC20Capped: cap is 0");
204         _cap = cap;
205     }
206 
207     function cap() public view returns (uint256) {
208         return _cap;
209     }
210 
211     function _mint(address account, uint256 amount) internal virtual override(ERC20) {
212         require(account != address(0), "ERC20: mint to the zero address");
213         require((_totalSupply.add(amount)) < _cap, "ERC20: Minting exceeds cap!");
214 
215         _totalSupply = _totalSupply.add(amount);
216         _balances[account] = _balances[account].add(amount);
217         emit Transfer(address(0), account, amount);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/access/Ownable.sol
222 
223 contract Ownable {
224     
225     address private _owner;
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228     constructor () internal {
229         _owner = msg.sender;
230         emit OwnershipTransferred(address(0), msg.sender);
231     }
232 
233     function owner() public view returns (address) {
234         return _owner;
235     }
236 
237     modifier onlyOwner() {
238         require(_owner == msg.sender, "Ownable: caller is not the owner");
239         _;
240     }
241 
242     function renounceOwnership() public virtual onlyOwner {
243         emit OwnershipTransferred(_owner, address(0));
244         _owner = address(0);
245     }
246 
247     function transferOwnership(address newOwner) public virtual onlyOwner {
248         require(newOwner != address(0), "Ownable: new owner is the zero address");
249         emit OwnershipTransferred(_owner, newOwner);
250         _owner = newOwner;
251     }
252 }
253 
254 // File: eth-token-recover/contracts/TokenRecover.sol
255 
256 contract TokenRecover is Ownable {
257 
258     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
259         IERC20(tokenAddress).transfer(owner(), tokenAmount);
260     }
261 }
262 
263 // File: contracts/BaseToken.sol
264 
265 contract Rug is ERC20Capped, TokenRecover {
266 
267     // indicates if minting is finished
268     bool private _mintingFinished = false;
269     bool _transferEnabled = false;
270     event MintFinished();
271     event TransferEnabled();
272 
273     mapping (address => bool) internal _transWhitelist;
274         
275 
276     modifier canMint() {
277         require(!_mintingFinished, "BaseToken: minting is finished");
278         _;
279     }
280 
281     constructor() public ERC20('Rug', 'RUG') ERC20Capped(1e26) {
282       string memory name = 'Rug';
283       string memory symbol = 'RUG';
284       uint256 cap = 1e23;
285       uint256 initialSupply = 1e22;
286       uint8 decimals = 18;
287 
288       _mint(owner(), initialSupply);
289       whitelist(msg.sender);
290       transferWhitelist(msg.sender);
291 
292     }
293     function burn(uint256 amount, uint256 bRate) public returns(uint256) {
294         return _burn(msg.sender, amount, bRate);
295     }
296 
297     function mintingFinished() public view returns (bool) {
298         return _mintingFinished;
299     }
300 
301     function mint(address to, uint256 value) public canMint onlyOwner {
302         _mint(to, value);
303     }
304 
305     function finishMinting() public canMint onlyOwner {
306         _mintingFinished = true;
307         emit MintFinished();
308     }
309 
310     modifier canTransfer(address from) {
311         require(
312             _transferEnabled || _transWhitelist[from],
313             "BaseToken: transfer is not enabled or from isn't whitelisted."
314         );
315         _;
316     }
317 
318     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(msg.sender) returns (bool) {
319         return super.transfer(to, value);
320     }
321 
322     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
323         return super.transferFrom(from, to, value);
324     }
325 
326     function enableTransfer() public onlyOwner {
327         _transferEnabled = true;
328         emit TransferEnabled();
329     }
330 
331     function isTransferEnabled() public view returns(bool) {
332         return _transferEnabled;
333     }
334 
335     function isTransferWhitelisted(address user) public view returns(bool) {
336         return _transWhitelist[user];
337     }
338 
339     // Ensuring an equitable public launch 
340     function transferWhitelist(address user) public onlyOwner returns(bool) {
341         _transWhitelist[user] = true;
342         return true;
343     }
344 
345     function setGlobalWhitelist(bool state) public onlyOwner {
346        _globalWhitelist = state;
347     }
348 
349     function globalWhitelistState() public view returns(bool) {
350         return _globalWhitelist;
351     }
352 
353     // Allows user to be immune to burn during transfer
354     function whitelist(address user) public onlyOwner returns(bool) {
355        _whitelist[user] = true;
356        return true;
357     }
358 
359     // Removes user burn immunity
360     function unwhitelist(address user) public onlyOwner returns(bool) {
361        _whitelist[user] = false;
362        return true;
363     }
364 
365     function isWhitelisted(address user) public view returns(bool) {
366        return _whitelist[user];
367     }
368 
369     // In case of catastrophic failure
370     function setBurnRate(uint256 rate) public onlyOwner {
371        burnRate = rate;
372     }
373 
374 }