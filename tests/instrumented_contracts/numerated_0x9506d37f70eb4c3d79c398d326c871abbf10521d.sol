1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5   function _msgSender() internal view virtual returns (address) {
6     return msg.sender;
7   }
8 
9   function _msgData() internal view virtual returns (bytes calldata) {
10     this;
11     return msg.data;
12   }
13 }
14 
15 interface IERC20 {
16 
17   function totalSupply() external view returns (uint256);
18   function balanceOf(address account) external view returns (uint256);
19   function transfer(address recipient, uint256 amount) external returns (bool);
20   function allowance(address owner, address spender) external view returns (uint256);
21   function approve(address spender, uint256 amount) external returns (bool);
22   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 
24   event Transfer(address indexed from, address indexed to, uint256 value);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 interface IERC20Metadata is IERC20 {
29 
30   function name() external view returns (string memory);
31   function symbol() external view returns (string memory);
32   function decimals() external view returns (uint8);
33 }
34 
35 abstract contract Ownable is Context {
36 
37   // Holds the owner address
38   address private _owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   constructor () {
43     address msgSender = _msgSender();
44     _owner = msgSender;
45     emit OwnershipTransferred(address(0), msgSender);
46   }
47 
48   function owner() public view virtual returns (address) {
49     return _owner;
50   }
51 
52   modifier onlyOwner() {
53     require(owner() == _msgSender(), "Ownable: caller is not the owner");
54     _;
55   }
56 
57   function transferOwnership(address newOwner) public virtual onlyOwner {
58     require(newOwner != address(0), "Ownable: new owner is the zero address");
59     emit OwnershipTransferred(_owner, newOwner);
60     _owner = newOwner;
61   }
62 }
63 
64 // Our main contract which implements all ERC20 standard methods
65 contract MediaLicensingToken is Context, IERC20, IERC20Metadata, Ownable {
66 
67   // Holds all the balances
68   mapping (address => uint256) private _balances;
69 
70   // Holds all allowances
71   mapping (address => mapping (address => uint256)) private _allowances;
72 
73   // Holds all blacklisted addresses
74   mapping (address => bool) private _blocklist;
75 
76   // They can only be decreased
77   uint256 private _totalSupply;
78 
79   // Immutable they can only be set once during construction
80   string private _name;
81   string private _symbol;
82   uint256 private _maxTokens;
83 
84   // Events
85   event Blocklist(address indexed account, bool indexed status);
86 
87   // The initializer of our contract
88   constructor () {
89     _name = "Media Licensing Token";
90     _symbol = "MLT";
91 
92     // Holds max mintable limit, 200 million tokens
93     _maxTokens = 200000000000000000000000000;
94     _mint(_msgSender(), _maxTokens);
95   }
96 
97   /*
98    * PUBLIC RETURNS
99    */
100 
101   // Returns the name of the token.
102   function name() public view virtual override returns (string memory) {
103     return _name;
104   }
105 
106   // Returns the symbol of the token
107   function symbol() public view virtual override returns (string memory) {
108     return _symbol;
109   }
110 
111   // Returns the number of decimals used
112   function decimals() public view virtual override returns (uint8) {
113     return 18;
114   }
115 
116   // Returns the total supply
117   function totalSupply() public view virtual override returns (uint256) {
118     return _totalSupply;
119   }
120 
121   // Returns the balance of a given address
122   function balanceOf(address account) public view virtual override returns (uint256) {
123     return _balances[account];
124   }
125 
126   // Returns the allowances of the given addresses
127   function allowance(address owner, address spender) public view virtual override returns (uint256) {
128     return _allowances[owner][spender];
129   }
130 
131   // Returns a blocked address of a given address
132   function isBlocked(address account) public view virtual returns (bool) {
133     return _blocklist[account];
134   }
135 
136   /*
137    * PUBLIC FUNCTIONS
138    */
139 
140   // Calls the _transfer function for a given recipient and amount
141   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
142     _transfer(_msgSender(), recipient, amount);
143     return true;
144   }
145 
146   // Calls the _transfer function for a given array of recipients and amounts
147   function transferArray(address[] calldata recipients, uint256[] calldata amounts) public virtual returns (bool) {
148     for (uint8 count = 0; count < recipients.length; count++) {
149       _transfer(_msgSender(), recipients[count], amounts[count]);
150     }
151     return true;
152   }
153 
154   // Calls the _approve function for a given spender and amount
155   function approve(address spender, uint256 amount) public virtual override returns (bool) {
156     _approve(_msgSender(), spender, amount);
157     return true;
158   }
159 
160   // Calls the _transfer and _approve function for a given sender, recipient and amount
161   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
162     _transfer(sender, recipient, amount);
163 
164     uint256 currentAllowance = _allowances[sender][_msgSender()];
165     require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166     _approve(sender, _msgSender(), currentAllowance - amount);
167 
168     return true;
169   }
170 
171   // Calls the _approve function for a given spender and added value (amount)
172   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
173     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
174     return true;
175   }
176 
177   // Calls the _approve function for a given spender and substracted value (amount)
178   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179     uint256 currentAllowance = _allowances[_msgSender()][spender];
180     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
182 
183     return true;
184   }
185 
186   /*
187    * PUBLIC (Only Owner)
188    */
189 
190   // Calls the _burn internal function for a given amount
191   function burn(uint256 amount) public virtual onlyOwner {
192     _burn(_msgSender(), amount);
193   }
194 
195   function blockAddress (address account) public virtual onlyOwner {
196     _block(account, true);
197   }
198 
199   function unblockAddress (address account) public virtual onlyOwner {
200     _block(account, false);
201   }
202 
203   /*
204    * INTERNAL (PRIVATE)
205    */
206 
207   function _block (address account, bool status) internal virtual {
208     require(account != _msgSender(), "ERC20: message sender can not block or unblock himself");
209     _blocklist[account] = status;
210 
211     emit Blocklist(account, status);
212   }
213 
214   // Implements the transfer function for a given sender, recipient and amount
215   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
216     require(sender != address(0), "ERC20: transfer from the zero address");
217     require(recipient != address(0), "ERC20: transfer to the zero address");
218 
219     _beforeTokenTransfer(sender, recipient, amount);
220 
221     uint256 senderBalance = _balances[sender];
222     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
223     _balances[sender] = senderBalance - amount;
224     _balances[recipient] += amount;
225 
226     emit Transfer(sender, recipient, amount);
227   }
228 
229   // Implements the mint function for a given account and amount
230   function _mint(address account, uint256 amount) internal virtual {
231     require(account != address(0), "ERC20: mint to the zero address");
232 
233     _beforeTokenTransfer(address(0), account, amount);
234 
235     _totalSupply += amount;
236     // Paranoid security
237     require(_totalSupply <= _maxTokens, "ERC20: mint exceeds total supply limit");
238 
239     _balances[account] += amount;
240     emit Transfer(address(0), account, amount);
241   }
242 
243   // Implements the burn function for a given account and amount
244   function _burn(address account, uint256 amount) internal virtual {
245     require(account != address(0), "ERC20: burn from the zero address");
246 
247     _beforeTokenTransfer(account, address(0), amount);
248 
249     uint256 accountBalance = _balances[account];
250     require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
251     _balances[account] = accountBalance - amount;
252     _totalSupply -= amount;
253 
254     emit Transfer(account, address(0), amount);
255   }
256 
257   // Implements the approve function for a given owner, spender and amount
258   function _approve(address owner, address spender, uint256 amount) internal virtual {
259     require(owner != address(0), "ERC20: approve from the zero address");
260     require(spender != address(0), "ERC20: approve to the zero address");
261 
262     _allowances[owner][spender] = amount;
263     emit Approval(owner, spender, amount);
264   }
265 
266   /*
267    * INTERNAL (PRIVATE) HELPERS
268    */
269 
270   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
271     require(_blocklist[from] == false && _blocklist[to] == false, "MLTERC20: transfer not allowed");
272     require(amount > 0, "ERC20: amount must be above zero");
273   }
274 }