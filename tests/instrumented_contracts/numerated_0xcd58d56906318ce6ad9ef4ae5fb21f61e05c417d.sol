1 // ░██████╗░█████╗░███████╗██╗░░░██╗  ██████╗░██╗░░░██╗
2 // ██╔════╝██╔══██╗██╔════╝██║░░░██║  ██╔══██╗╚██╗░██╔╝
3 // ╚█████╗░███████║█████╗░░██║░░░██║  ██████╦╝░╚████╔╝░
4 // ░╚═══██╗██╔══██║██╔══╝░░██║░░░██║  ██╔══██╗░░╚██╔╝░░
5 // ██████╔╝██║░░██║██║░░░░░╚██████╔╝  ██████╦╝░░░██║░░░
6 // ╚═════╝░╚═╝░░╚═╝╚═╝░░░░░░╚═════╝░  ╚═════╝░░░░╚═╝░░░
7 
8 // ░█████╗░░█████╗░██╗███╗░░██╗░██████╗██╗░░░██╗██╗░░░░░████████╗░░░███╗░░██╗███████╗████████╗
9 // ██╔══██╗██╔══██╗██║████╗░██║██╔════╝██║░░░██║██║░░░░░╚══██╔══╝░░░████╗░██║██╔════╝╚══██╔══╝
10 // ██║░░╚═╝██║░░██║██║██╔██╗██║╚█████╗░██║░░░██║██║░░░░░░░░██║░░░░░░██╔██╗██║█████╗░░░░░██║░░░
11 // ██║░░██╗██║░░██║██║██║╚████║░╚═══██╗██║░░░██║██║░░░░░░░░██║░░░░░░██║╚████║██╔══╝░░░░░██║░░░
12 // ╚█████╔╝╚█████╔╝██║██║░╚███║██████╔╝╚██████╔╝███████╗░░░██║░░░██╗██║░╚███║███████╗░░░██║░░░
13 // ░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚═╝░░╚══╝╚══════╝░░░╚═╝░░░
14 
15 // Get your SAFU contract now via Coinsult.net
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.17;
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32    
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 interface IERC20Metadata is IERC20 {
38     function name() external view returns (string memory);
39     function symbol() external view returns (string memory);
40     function decimals() external view returns (uint8);
41 }
42 
43 library Address {
44     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
45         require(address(this).balance >= amount, "Address: insufficient balance");
46 
47         (bool success, ) = recipient.call{value: amount}("");
48         return success;
49     }
50 }
51 
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view virtual returns (bytes calldata) {
58         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
59         return msg.data;
60     }
61 }
62 
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 contract ERC20 is Context, IERC20, IERC20Metadata {
96     mapping(address => uint256) private _balances;
97 
98     mapping(address => mapping(address => uint256)) private _allowances;
99 
100     uint256 private _totalSupply;
101 
102     string private _name;
103     string private _symbol;
104 
105     constructor(string memory name_, string memory symbol_) {
106         _name = name_;
107         _symbol = symbol_;
108     }
109 
110     function name() public view virtual override returns (string memory) {
111         return _name;
112     }
113 
114     function symbol() public view virtual override returns (string memory) {
115         return _symbol;
116     }
117 
118     function decimals() public view virtual override returns (uint8) {
119         return 18;
120     }
121 
122     function totalSupply() public view virtual override returns (uint256) {
123         return _totalSupply;
124     }
125 
126     function balanceOf(address account) public view virtual override returns (uint256) {
127         return _balances[account];
128     }
129 
130     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
131         _transfer(_msgSender(), recipient, amount);
132         return true;
133     }
134 
135     function allowance(address owner, address spender) public view virtual override returns (uint256) {
136         return _allowances[owner][spender];
137     }
138 
139     function approve(address spender, uint256 amount) public virtual override returns (bool) {
140         _approve(_msgSender(), spender, amount);
141         return true;
142     }
143 
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) public virtual override returns (bool) {
149         uint256 currentAllowance = _allowances[sender][_msgSender()];
150         if (currentAllowance != type(uint256).max) {
151             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
152             unchecked {
153                 _approve(sender, _msgSender(), currentAllowance - amount);
154             }
155         }
156 
157         _transfer(sender, recipient, amount);
158 
159         return true;
160     }
161 
162     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
163         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
164         return true;
165     }
166 
167     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
168         uint256 currentAllowance = _allowances[_msgSender()][spender];
169         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
170         unchecked {
171             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
172         }
173 
174         return true;
175     }
176 
177     function _transfer(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) internal virtual {
182         require(sender != address(0), "ERC20: transfer from the zero address");
183         require(recipient != address(0), "ERC20: transfer to the zero address");
184 
185         _beforeTokenTransfer(sender, recipient, amount);
186 
187         uint256 senderBalance = _balances[sender];
188         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
189         unchecked {
190             _balances[sender] = senderBalance - amount;
191         }
192         _balances[recipient] += amount;
193 
194         emit Transfer(sender, recipient, amount);
195 
196         _afterTokenTransfer(sender, recipient, amount);
197     }
198 
199     function _mint(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: mint to the zero address");
201 
202         _beforeTokenTransfer(address(0), account, amount);
203 
204         _totalSupply += amount;
205         _balances[account] += amount;
206         emit Transfer(address(0), account, amount);
207 
208         _afterTokenTransfer(address(0), account, amount);
209     }
210 
211     function _burn(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: burn from the zero address");
213 
214         _beforeTokenTransfer(account, address(0), amount);
215 
216         uint256 accountBalance = _balances[account];
217         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
218         unchecked {
219             _balances[account] = accountBalance - amount;
220         }
221         _totalSupply -= amount;
222 
223         emit Transfer(account, address(0), amount);
224 
225         _afterTokenTransfer(account, address(0), amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _beforeTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 
246     function _afterTokenTransfer(
247         address from,
248         address to,
249         uint256 amount
250     ) internal virtual {}
251 }
252 
253 
254 contract PEPMCITY is ERC20, Ownable {
255     using Address for address payable;
256     mapping (address => bool) private _isExcludedFromFees;
257 
258     string  public creator;
259 
260     constructor () ERC20("Pep ManCity", "PEPMCITY") 
261     {   
262         creator = "coinsult.net";
263 
264         _isExcludedFromFees[address(0x2c6DF5169811591a5273E11269aDAB9D2b8cb744)] = true;
265         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
266 
267         _mint(address(0x2c6DF5169811591a5273E11269aDAB9D2b8cb744), 1e9 * (10 ** decimals()));
268     }
269 
270     receive() external payable {}
271 
272     function claimStuckTokens(address token) external onlyOwner {
273         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
274         if (token == address(0x0)) {
275             payable(msg.sender).sendValue(address(this).balance);
276             return;
277         }
278         IERC20 ERC20token = IERC20(token);
279         uint256 balance = ERC20token.balanceOf(address(this));
280         ERC20token.transfer(msg.sender, balance);
281     }
282 
283     function excludeFromFees(address account, bool excluded) external onlyOwner{
284         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
285         _isExcludedFromFees[account] = excluded;
286     }
287 
288     function isExcludedFromFees(address account) public view returns(bool) {
289         return _isExcludedFromFees[account];
290     }
291 
292     bool public tradingEnabled;
293 
294     function enableTrading() external onlyOwner{
295         require(!tradingEnabled, "Trading already enabled.");
296         tradingEnabled = true;
297     }
298 
299     function _transfer(address from,address to,uint256 amount) internal  override {
300         require(from != address(0), "ERC20: transfer from the zero address");
301         require(to != address(0), "ERC20: transfer to the zero address");
302         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
303        
304         if (amount == 0) {
305             super._transfer(from, to, 0);
306             return;
307         }
308 
309         super._transfer(from, to, amount);
310     }
311 }