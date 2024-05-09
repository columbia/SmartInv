1 // Contract has been forked by <DEVAI> a Telegram AI bot. Visit https://t.me/ContractDevAI
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity 0.8.17;
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(
13         address sender,
14         address recipient,
15         uint256 amount
16     ) external returns (bool);
17    
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 interface IERC20Metadata is IERC20 {
23     function name() external view returns (string memory);
24     function symbol() external view returns (string memory);
25     function decimals() external view returns (uint8);
26 }
27 
28 library Address {
29     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
30         require(address(this).balance >= amount, "Address: insufficient balance");
31 
32         (bool success, ) = recipient.call{value: amount}("");
33         return success;
34     }
35 }
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 contract ERC20 is Context, IERC20, IERC20Metadata {
81     mapping(address => uint256) private _balances;
82 
83     mapping(address => mapping(address => uint256)) private _allowances;
84 
85     uint256 private _totalSupply;
86 
87     string private _name;
88     string private _symbol;
89 
90     constructor(string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95     function name() public view virtual override returns (string memory) {
96         return _name;
97     }
98 
99     function symbol() public view virtual override returns (string memory) {
100         return _symbol;
101     }
102 
103     function decimals() public view virtual override returns (uint8) {
104         return 9;
105     }
106 
107     function totalSupply() public view virtual override returns (uint256) {
108         return _totalSupply;
109     }
110 
111     function balanceOf(address account) public view virtual override returns (uint256) {
112         return _balances[account];
113     }
114 
115     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119 
120     function allowance(address owner, address spender) public view virtual override returns (uint256) {
121         return _allowances[owner][spender];
122     }
123 
124     function approve(address spender, uint256 amount) public virtual override returns (bool) {
125         _approve(_msgSender(), spender, amount);
126         return true;
127     }
128 
129     function transferFrom(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) public virtual override returns (bool) {
134         uint256 currentAllowance = _allowances[sender][_msgSender()];
135         if (currentAllowance != type(uint256).max) {
136             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
137             unchecked {
138                 _approve(sender, _msgSender(), currentAllowance - amount);
139             }
140         }
141 
142         _transfer(sender, recipient, amount);
143 
144         return true;
145     }
146 
147     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
148         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
149         return true;
150     }
151 
152     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
153         uint256 currentAllowance = _allowances[_msgSender()][spender];
154         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
155         unchecked {
156             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
157         }
158 
159         return true;
160     }
161 
162     function _transfer(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) internal virtual {
167         require(sender != address(0), "ERC20: transfer from the zero address");
168         require(recipient != address(0), "ERC20: transfer to the zero address");
169 
170         _beforeTokenTransfer(sender, recipient, amount);
171 
172         uint256 senderBalance = _balances[sender];
173         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
174         unchecked {
175             _balances[sender] = senderBalance - amount;
176         }
177         _balances[recipient] += amount;
178 
179         emit Transfer(sender, recipient, amount);
180 
181         _afterTokenTransfer(sender, recipient, amount);
182     }
183 
184     function _mint(address account, uint256 amount) internal virtual {
185         require(account != address(0), "ERC20: mint to the zero address");
186 
187         _beforeTokenTransfer(address(0), account, amount);
188 
189         _totalSupply += amount;
190         _balances[account] += amount;
191         emit Transfer(address(0), account, amount);
192 
193         _afterTokenTransfer(address(0), account, amount);
194     }
195 
196     function _burn(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: burn from the zero address");
198 
199         _beforeTokenTransfer(account, address(0), amount);
200 
201         uint256 accountBalance = _balances[account];
202         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
203         unchecked {
204             _balances[account] = accountBalance - amount;
205         }
206         _totalSupply -= amount;
207 
208         emit Transfer(account, address(0), amount);
209 
210         _afterTokenTransfer(account, address(0), amount);
211     }
212 
213     function _approve(
214         address owner,
215         address spender,
216         uint256 amount
217     ) internal virtual {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220 
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _beforeTokenTransfer(
226         address from,
227         address to,
228         uint256 amount
229     ) internal virtual {}
230 
231     function _afterTokenTransfer(
232         address from,
233         address to,
234         uint256 amount
235     ) internal virtual {}
236 }
237 
238 
239 contract GODFATHER is ERC20, Ownable {
240     using Address for address payable;
241     mapping (address => bool) private _isExcludedFromFees;
242 
243     string  public creator;
244 
245     constructor () ERC20("Godfather", "$GOD") 
246     {   
247         creator = "DEVAI";
248 
249         _isExcludedFromFees[address(0xf480d5381cf7d921E12e39ca13c41A80a77fd1fB)] = true;
250         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
251 
252         _mint(address(0xf480d5381cf7d921E12e39ca13c41A80a77fd1fB), 69_000_000 * (10 ** decimals()));
253     }
254 
255     receive() external payable {}
256 
257     function claimStuckTokens(address token) external onlyOwner {
258         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
259         if (token == address(0x0)) {
260             payable(msg.sender).sendValue(address(this).balance);
261             return;
262         }
263         IERC20 ERC20token = IERC20(token);
264         uint256 balance = ERC20token.balanceOf(address(this));
265         ERC20token.transfer(msg.sender, balance);
266     }
267 
268     function excludeFromFees(address account, bool excluded) external onlyOwner{
269         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
270         _isExcludedFromFees[account] = excluded;
271     }
272 
273     function isExcludedFromFees(address account) public view returns(bool) {
274         return _isExcludedFromFees[account];
275     }
276 
277     bool public tradingEnabled;
278 
279     function enableTrading() external onlyOwner{
280         require(!tradingEnabled, "Trading already enabled.");
281         tradingEnabled = true;
282     }
283 
284     function _transfer(address from,address to,uint256 amount) internal  override {
285         require(from != address(0), "ERC20: transfer from the zero address");
286         require(to != address(0), "ERC20: transfer to the zero address");
287         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
288        
289         if (amount == 0) {
290             super._transfer(from, to, 0);
291             return;
292         }
293 
294         super._transfer(from, to, amount);
295     }
296 }