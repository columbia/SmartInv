1 // SPDX-License-Identifier: MIT
2 
3 // TOAD Token (ERC-20) - $TOAD
4 
5 
6 pragma solidity ^0.8.0;
7 
8 // Importing required OpenZeppelin contracts
9 // Context.sol
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 // IERC20.sol
21 interface IERC20 {
22     // Returns the total supply of tokens
23     function totalSupply() external view returns (uint256);
24 
25     // Returns the token balance of specific account
26     function balanceOf(address account) external view returns (uint256);
27 
28     // Transfers tokens from the function caller to another address
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     // Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     // Sets the amount of tokens that an address can spend on behalf of the msg.sender
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     // Transfers tokens from one address to another
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 // IERC20Metadata.sol
51 interface IERC20Metadata is IERC20 {
52     function name() external view returns (string memory);
53 
54     function symbol() external view returns (string memory);
55 
56     function decimals() external view returns (uint8);
57 }
58 
59 // Ownable.sol
60 contract Ownable is Context {
61 
62      // The owner of the contract
63     address private _owner;
64 
65     
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor() {
69         _setOwner(_msgSender());
70     }
71 
72     // Returns the current owner
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     // Makes a function callable only by the owner
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     // Allows the current owner to relinquish control of the contract
84     function renounceOwnership() public virtual onlyOwner {
85         _setOwner(address(0));
86     }
87 
88 
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 // ERC20.sol
102 contract ERC20 is Context, IERC20, IERC20Metadata {
103     mapping(address => uint256) private _balances;
104 
105     mapping(address => mapping(address => uint256)) private _allowances;
106 
107     uint256 private _totalSupply;
108 
109     string private _name;
110     string private _symbol;
111 
112     constructor(string memory name_, string memory symbol_) {
113         _name = name_;
114         _symbol = symbol_;
115     }
116 
117     function name() public view virtual override returns (string memory) {
118         return _name;
119     }
120 
121     function symbol() public view virtual override returns (string memory) {
122         return _symbol;
123     }
124 
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account) public view virtual override returns (uint256) {
134         return _balances[account];
135     }
136 
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public virtual override returns (bool) {
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) public virtual override returns (bool) {
156         _transfer(sender, recipient, amount);
157 
158         uint256 currentAllowance = _allowances[sender][_msgSender()];
159         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
160         _approve(sender, _msgSender(), currentAllowance - amount);
161 
162         return true;
163     }
164 
165     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
166         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
167         return true;
168     }
169 
170     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
171         uint256 currentAllowance = _allowances[_msgSender()][spender];
172         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
173         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
174 
175         return true;
176     }
177 
178     function _transfer(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) internal virtual {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185 
186         _beforeTokenTransfer(sender, recipient, amount);
187 
188         uint256 senderBalance = _balances[sender];
189         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
190         _balances[sender] = senderBalance - amount;
191         _balances[recipient] += amount;
192 
193         emit Transfer(sender, recipient, amount);
194     }
195 
196     function _mint(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: mint to the zero address");
198 
199         _beforeTokenTransfer(address(0), account, amount);
200 
201         _totalSupply += amount;
202         _balances[account] += amount;
203         emit Transfer(address(0), account, amount);
204     }
205 
206     function _burn(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _beforeTokenTransfer(account, address(0), amount);
210 
211         uint256 accountBalance = _balances[account];
212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
213         _balances[account] = accountBalance - amount;
214         _totalSupply -= amount;
215 
216         emit Transfer(account, address(0), amount);
217     }
218 
219     function _approve(
220         address owner,
221         address spender,
222         uint256 amount
223     ) internal virtual {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _beforeTokenTransfer(
232         address from,
233         address to,
234         uint256 amount
235     ) internal virtual {}
236 }
237 
238 // Toad Token
239 contract Toad is Ownable, ERC20 {
240     bool public limited;
241     uint256 public maxHoldingAmount;
242     uint256 public minHoldingAmount;
243     mapping(address => bool) public blacklists;
244     bool public blacklistEnabled;
245 
246     constructor(uint256 _totalSupply) ERC20("Toad", "TOAD") {
247         _mint(msg.sender, _totalSupply);
248     }
249 
250     // blacklists a sniper bot before contract ownership is revoked
251     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
252         blacklists[_address] = _isBlacklisting;
253     }
254 
255     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
256         limited = _limited;
257         maxHoldingAmount = _maxHoldingAmount;
258         minHoldingAmount = _minHoldingAmount;
259     }
260 
261     function setBlacklistEnabled(bool _enabled) external onlyOwner {
262         blacklistEnabled = _enabled;
263     }
264 
265     // checks for blacklist
266     function _beforeTokenTransfer(
267         address from,
268         address to,
269         uint256 amount
270     ) override internal virtual {
271         if (blacklistEnabled) {
272             require(!blacklists[to] && !blacklists[from], "Blacklisted");
273         }
274 
275         if (limited && from != owner()) {
276             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
277         }
278     }
279 
280     //burns any tokens inputted from wallet
281     function burn(uint256 value) external {
282         _burn(msg.sender, value);
283     }
284 }