1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.6;
4 
5 
6 interface IERC20{
7      function totalSupply() external view returns (uint256);
8      function balanceOf(address account) external view returns (uint256);
9      function transfer(address recipient, uint256 amount) external returns (bool);
10      function allowance(address owner, address spender) external view returns (uint256);
11      function approve(address spender, uint256 amount) external returns (bool);
12      function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13      event Transfer(address indexed from, address indexed to, uint256 value);
14      event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library Address {
18    
19     function isContract(address account) internal view returns (bool) {
20         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
21         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
22         // for accounts without code, i.e. `keccak256('')`
23         bytes32 codehash;
24         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { codehash := extcodehash(account) }
27         return (codehash != accountHash && codehash != 0x0);
28     }
29    
30     function toPayable(address account) internal pure returns (address payable) {
31         return payable(address(uint160(account)));
32     }
33 
34     function sendValue(address payable recipient, uint256 amount) internal {
35         require(address(this).balance >= amount, "Address: insufficient balance");
36 
37         // solhint-disable-next-line avoid-call-value
38         (bool success, ) = recipient.call{value:amount}("");
39         require(success, "Address: unable to send value, recipient may have reverted");
40     }
41 }
42 
43 contract Context {
44    
45     constructor ()  { }
46    
47 
48     function _msgSender() internal view returns (address payable) {
49         return payable(msg.sender);
50     }
51 
52     function _msgData() internal view returns (bytes memory) {
53         this; 
54         return msg.data;
55     }
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63   
64     constructor ()  {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70    
71     function owner() external view returns (address) {
72         return _owner;
73     }
74 
75     
76     modifier onlyOwner() {
77         require(isOwner(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81    
82     function isOwner() public view returns (bool) {
83         return _msgSender() == _owner;
84     }
85 
86     function renounceOwnership() external onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91  
92     function transferOwnership(address newOwner) external onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96    
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 contract ERC20 is Context, IERC20,Ownable {
105    
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112     string private  _name;
113     string private _symbol;
114     uint8 private _decimals;
115     
116     constructor(string memory name_, string memory symbol_)  {
117         _name = name_;
118         _symbol = symbol_;
119         _decimals = 18;
120     }
121     
122   
123     function name() external view returns (string memory) {
124         return _name;
125     }
126 
127 
128     function symbol() external view returns (string memory) {
129         return _symbol;
130     }
131     
132     
133      function decimals() external view returns (uint8) {
134         return _decimals;
135     }
136 
137 
138   
139     function totalSupply() external view override returns (uint256) {
140         return _totalSupply;
141     }
142 
143   
144     function balanceOf(address account) external view override returns (uint256) {
145         return _balances[account];
146     }
147 
148    
149     function transfer(address recipient, uint256 amount) external override returns (bool) {
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender) external view override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158   
159     function approve(address spender, uint256 amount) external override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163 
164    function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) external virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170 
171         uint256 currentAllowance = _allowances[sender][_msgSender()];
172         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
173     
174         _approve(sender, _msgSender(), currentAllowance - amount);
175  
176 
177         return true;
178     }
179 
180    
181    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
183         return true;
184     }
185    
186    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
187         uint256 currentAllowance = _allowances[_msgSender()][spender];
188         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
189       
190             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191     
192 
193         return true;
194     }
195 
196     
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         _beforeTokenTransfer(sender, recipient, amount);
206 
207         uint256 senderBalance = _balances[sender];
208         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
209         unchecked {
210             _balances[sender] = senderBalance - amount;
211         }
212         _balances[recipient] += amount;
213 
214         emit Transfer(sender, recipient, amount);
215 
216         _afterTokenTransfer(sender, recipient, amount);
217     }
218 
219   
220     function _mint(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: mint to the zero address");
222 
223         _beforeTokenTransfer(address(0), account, amount);
224 
225         _totalSupply += amount;
226         _balances[account] += amount;
227         emit Transfer(address(0), account, amount);
228 
229         _afterTokenTransfer(address(0), account, amount);
230     }
231    
232     function _burn(address account, uint256 amount) internal virtual {
233         require(account != address(0), "ERC20: burn from the zero address");
234 
235         _beforeTokenTransfer(account, address(0), amount);
236 
237         uint256 accountBalance = _balances[account];
238         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
239         unchecked {
240             _balances[account] = accountBalance - amount;
241         }
242         _totalSupply -= amount;
243 
244         emit Transfer(account, address(0), amount);
245 
246         _afterTokenTransfer(account, address(0), amount);
247     }
248    
249    function _approve(
250         address owner,
251         address spender,
252         uint256 amount
253     ) internal virtual {
254         require(owner != address(0), "ERC20: approve from the zero address");
255         require(spender != address(0), "ERC20: approve to the zero address");
256 
257         _allowances[owner][spender] = amount;
258         emit Approval(owner, spender, amount);
259     }
260    
261 
262     function _beforeTokenTransfer(
263         address from,
264         address to,
265         uint256 amount
266     ) internal virtual {}
267     
268     function _afterTokenTransfer(
269         address from,
270         address to,
271         uint256 amount
272     ) internal virtual {}
273 
274 }
275 
276 contract PLEToken is ERC20{
277     
278    constructor() ERC20("Plethori","PLE") {
279        _mint(msg.sender,100e6 ether);
280    }
281 
282 }