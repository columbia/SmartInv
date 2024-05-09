1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(
12         address sender,
13         address recipient,
14         uint256 amount
15     ) external returns (bool);
16    
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface IERC20Metadata is IERC20 {
22     function name() external view returns (string memory);
23     function symbol() external view returns (string memory);
24     function decimals() external view returns (uint8);
25 }
26 
27 library Address {
28     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
29         require(address(this).balance >= amount, "Address: insufficient balance");
30 
31         (bool success, ) = recipient.call{value: amount}("");
32         return success;
33     }
34 }
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     constructor () {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 contract ERC20 is Context, IERC20, IERC20Metadata {
80     mapping(address => uint256) private _balances;
81 
82     mapping(address => mapping(address => uint256)) private _allowances;
83 
84     uint256 private _totalSupply;
85 
86     string private _name;
87     string private _symbol;
88 
89     constructor(string memory name_, string memory symbol_) {
90         _name = name_;
91         _symbol = symbol_;
92     }
93 
94     function name() public view virtual override returns (string memory) {
95         return _name;
96     }
97 
98     function symbol() public view virtual override returns (string memory) {
99         return _symbol;
100     }
101 
102     function decimals() public view virtual override returns (uint8) {
103         return 18;
104     }
105 
106     function totalSupply() public view virtual override returns (uint256) {
107         return _totalSupply;
108     }
109 
110     function balanceOf(address account) public view virtual override returns (uint256) {
111         return _balances[account];
112     }
113 
114     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
115         _transfer(_msgSender(), recipient, amount);
116         return true;
117     }
118 
119     function allowance(address owner, address spender) public view virtual override returns (uint256) {
120         return _allowances[owner][spender];
121     }
122 
123     function approve(address spender, uint256 amount) public virtual override returns (bool) {
124         _approve(_msgSender(), spender, amount);
125         return true;
126     }
127 
128     function transferFrom(
129         address sender,
130         address recipient,
131         uint256 amount
132     ) public virtual override returns (bool) {
133         uint256 currentAllowance = _allowances[sender][_msgSender()];
134         if (currentAllowance != type(uint256).max) {
135             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
136             unchecked {
137                 _approve(sender, _msgSender(), currentAllowance - amount);
138             }
139         }
140 
141         _transfer(sender, recipient, amount);
142 
143         return true;
144     }
145 
146     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
148         return true;
149     }
150 
151     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
152         uint256 currentAllowance = _allowances[_msgSender()][spender];
153         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
154         unchecked {
155             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
156         }
157 
158         return true;
159     }
160 
161     function _transfer(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) internal virtual {
166         require(sender != address(0), "ERC20: transfer from the zero address");
167         require(recipient != address(0), "ERC20: transfer to the zero address");
168 
169         _beforeTokenTransfer(sender, recipient, amount);
170 
171         uint256 senderBalance = _balances[sender];
172         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
173         unchecked {
174             _balances[sender] = senderBalance - amount;
175         }
176         _balances[recipient] += amount;
177 
178         emit Transfer(sender, recipient, amount);
179 
180         _afterTokenTransfer(sender, recipient, amount);
181     }
182 
183     function _mint(address account, uint256 amount) internal virtual {
184         require(account != address(0), "ERC20: mint to the zero address");
185 
186         _beforeTokenTransfer(address(0), account, amount);
187 
188         _totalSupply += amount;
189         _balances[account] += amount;
190         emit Transfer(address(0), account, amount);
191 
192         _afterTokenTransfer(address(0), account, amount);
193     }
194 
195     function _burn(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: burn from the zero address");
197 
198         _beforeTokenTransfer(account, address(0), amount);
199 
200         uint256 accountBalance = _balances[account];
201         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
202         unchecked {
203             _balances[account] = accountBalance - amount;
204         }
205         _totalSupply -= amount;
206 
207         emit Transfer(account, address(0), amount);
208 
209         _afterTokenTransfer(account, address(0), amount);
210     }
211 
212     function _approve(
213         address owner,
214         address spender,
215         uint256 amount
216     ) internal virtual {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219 
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _beforeTokenTransfer(
225         address from,
226         address to,
227         uint256 amount
228     ) internal virtual {}
229 
230     function _afterTokenTransfer(
231         address from,
232         address to,
233         uint256 amount
234     ) internal virtual {}
235 }
236 
237 
238 contract RAP is ERC20, Ownable {
239     using Address for address payable;
240     mapping (address => bool) private _isExcludedFromFees;
241 
242     constructor () ERC20("Philosoraptor", "RAP") 
243     {   
244         _isExcludedFromFees[owner()] = true;
245         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
246 
247         _mint(owner(), 1e9 * (10 ** decimals()));
248     }
249 
250     receive() external payable {}
251 
252     function claimStuckTokens(address token) external onlyOwner {
253         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
254         if (token == address(0x0)) {
255             payable(msg.sender).sendValue(address(this).balance);
256             return;
257         }
258         IERC20 ERC20token = IERC20(token);
259         uint256 balance = ERC20token.balanceOf(address(this));
260         ERC20token.transfer(msg.sender, balance);
261     }
262 
263     function excludeFromFees(address account, bool excluded) external onlyOwner{
264         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
265         _isExcludedFromFees[account] = excluded;
266     }
267 
268     function isExcludedFromFees(address account) public view returns(bool) {
269         return _isExcludedFromFees[account];
270     }
271 
272     bool public tradingEnabled;
273 
274     function enableTrading() external onlyOwner{
275         require(!tradingEnabled, "Trading already enabled.");
276         tradingEnabled = true;
277     }
278 
279     function _transfer(address from,address to,uint256 amount) internal  override {
280         require(from != address(0), "ERC20: transfer from the zero address");
281         require(to != address(0), "ERC20: transfer to the zero address");
282         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
283        
284         if (amount == 0) {
285             super._transfer(from, to, 0);
286             return;
287         }
288 
289         super._transfer(from, to, amount);
290     }
291 }