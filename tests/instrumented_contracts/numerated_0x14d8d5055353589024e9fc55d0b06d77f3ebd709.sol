1 // SPDX-License-Identifier: UNLICENSED
2 
3 // Website: https://www.thetrustco.in/
4 
5 pragma solidity 0.8.20;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this;
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface IERC20Metadata is IERC20 {
37     function name() external view returns (string memory);
38 
39     function symbol() external view returns (string memory);
40 
41     function decimals() external view returns (uint8);
42 }
43 
44 contract ERC20 is Context, IERC20, IERC20Metadata {
45     mapping(address => uint256) internal _balances;
46 
47     mapping(address => mapping(address => uint256)) internal _allowances;
48 
49     uint256 private _totalSupply;
50 
51     string private _name;
52     string private _symbol;
53 
54     constructor(string memory name_, string memory symbol_) {
55         _name = name_;
56         _symbol = symbol_;
57     }
58 
59     function name() public view virtual override returns (string memory) {
60         return _name;
61     }
62 
63     function symbol() public view virtual override returns (string memory) {
64         return _symbol;
65     }
66 
67     function decimals() public view virtual override returns (uint8) {
68         return 18;
69     }
70 
71     function totalSupply() public view virtual override returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address account) public view virtual override returns (uint256) {
76         return _balances[account];
77     }
78 
79     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
80         _transfer(_msgSender(), recipient, amount);
81         return true;
82     }
83 
84     function allowance(address owner, address spender) public view virtual override returns (uint256) {
85         return _allowances[owner][spender];
86     }
87 
88     function approve(address spender, uint256 amount) public virtual override returns (bool) {
89         _approve(_msgSender(), spender, amount);
90         return true;
91     }
92 
93     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
94         _transfer(sender, recipient, amount);
95 
96         uint256 currentAllowance = _allowances[sender][_msgSender()];
97         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
98         _approve(sender, _msgSender(), currentAllowance - amount);
99 
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
104         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
105         return true;
106     }
107 
108     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
109         uint256 currentAllowance = _allowances[_msgSender()][spender];
110         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
111         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
112 
113         return true;
114     }
115 
116     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
117         require(sender != address(0), "ERC20: transfer from the zero address");
118         require(recipient != address(0), "ERC20: transfer to the zero address");
119 
120         _beforeTokenTransfer(sender, recipient, amount);
121 
122         uint256 senderBalance = _balances[sender];
123         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
124         _balances[sender] = senderBalance - amount;
125         _balances[recipient] += amount;
126 
127         emit Transfer(sender, recipient, amount);
128     }
129 
130     function _mint(address account, uint256 amount) internal virtual {
131         require(account != address(0), "ERC20: mint to the zero address");
132 
133         _beforeTokenTransfer(address(0), account, amount);
134 
135         _totalSupply += amount;
136         _balances[account] += amount;
137         emit Transfer(address(0), account, amount);
138     }
139 
140     function _burn(address account, uint256 amount) internal virtual {
141         require(account != address(0), "ERC20: burn from the zero address");
142 
143         _beforeTokenTransfer(account, address(0), amount);
144 
145         uint256 accountBalance = _balances[account];
146         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
147         _balances[account] = accountBalance - amount;
148         _totalSupply -= amount;
149 
150         emit Transfer(account, address(0), amount);
151     }
152 
153     function _approve(address owner, address spender, uint256 amount) internal virtual {
154         require(owner != address(0), "ERC20: approve from the zero address");
155         require(spender != address(0), "ERC20: approve to the zero address");
156 
157         _allowances[owner][spender] = amount;
158         emit Approval(owner, spender, amount);
159     }
160 
161     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
162 }
163 
164 library Address {
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 }
172 
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     constructor() {
179         _setOwner(_msgSender());
180     }
181 
182     function owner() public view virtual returns (address) {
183         return _owner;
184     }
185 
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     function renounceOwnership() public virtual onlyOwner {
192         _setOwner(address(0));
193     }
194 
195     function transferOwnership(address newOwner) public virtual onlyOwner {
196         require(newOwner != address(0), "Ownable: new owner is the zero address");
197         _setOwner(newOwner);
198     }
199 
200     function _setOwner(address newOwner) private {
201         address oldOwner = _owner;
202         _owner = newOwner;
203         emit OwnershipTransferred(oldOwner, newOwner);
204     }
205 }
206 
207 contract WrappedTrust is ERC20, Ownable {
208     IERC20 public trust;
209 
210     address public trustAddress = 0xD4074c1E48E11615fD1cfE8cbE691F5ab944aAa6;
211     address public marketingWalet = 0x84874cD121274690D972137e65C8AcA0937d0Af6;
212     address public devWallet = 0x25Eff24DF1D8C0F6f891AADcF4cdEc03529818D5;
213 
214     uint256 public randomNumberThreshold = 26;
215     bool public wrapping;
216     bool public unWrapping;
217 
218     event Wrapped(address indexed from, address indexed to, uint256 amount, uint256 feeCharged, uint256 time);
219     event UnWrapped(address indexed from, address indexed to, uint256 amount, uint256 feeCharged, uint256 time);
220 
221     constructor() ERC20("Wrapped Trust", "WTRUST") Ownable() {
222         trust = IERC20(trustAddress);
223         wrapping = false;
224         unWrapping = false;
225         _mint(_msgSender(), 26e9 * 10 ** 18);
226     }
227 
228     function random() public view returns (uint) {
229         uint randomHash = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp)));
230         uint randamTax = randomHash % randomNumberThreshold;
231         return randamTax;
232     }
233 
234     function wrap(uint256 amount) public {
235         require(trust.balanceOf(_msgSender()) >= amount, "ERORR: not enough balance");
236         require(wrapping, "ERROR: wrapping is locked");
237         require(trust.allowance(_msgSender(), address(this)) >= amount, "ERROR: tokens not approved");
238 
239         uint256 fee = random();
240         uint256 feeAmount = (amount * fee) / 100;
241         uint256 tokenAmount = amount - feeAmount;
242 
243         trust.transferFrom(_msgSender(), marketingWalet, feeAmount);
244         trust.transferFrom(_msgSender(), devWallet, tokenAmount);
245 
246         _mint(_msgSender(), tokenAmount);
247         _mint(address(this), feeAmount);
248 
249         emit Wrapped(address(this), _msgSender(), amount, fee, block.timestamp);
250     }
251 
252     function unWrap(uint256 amount) public {
253         require(balanceOf(_msgSender()) >= amount, "ERORR: not enough balance");
254         require(unWrapping, "ERROR: unWrapping is locked");
255         require(trust.allowance(devWallet, address(this)) >= amount, "ERROR: tokens not approved");
256 
257         uint256 fee = random();
258         uint256 feeAmount = (amount * fee) / 100;
259         uint256 tokenAmount = amount - feeAmount;
260 
261         _burn(_msgSender(), amount);
262 
263         trust.transferFrom(devWallet, marketingWalet, feeAmount);
264         trust.transferFrom(devWallet, _msgSender(), tokenAmount);
265 
266         emit UnWrapped(_msgSender(), address(this), amount, fee, block.timestamp);
267     }
268 
269     function devMint(uint256 amount) public onlyOwner {
270         _mint(_msgSender(), amount);
271     }
272 
273     function changeRandomNumberThreshold(uint256 _newValue) public onlyOwner {
274         randomNumberThreshold = _newValue;
275     }
276 
277     function startSale() public onlyOwner {
278         wrapping = true;
279         unWrapping = true;
280     }
281 
282     function stopWrapping() public onlyOwner {
283         wrapping = false;
284     }
285 
286     function stopUnWrapping() public onlyOwner {
287         unWrapping = false;
288     }
289 }