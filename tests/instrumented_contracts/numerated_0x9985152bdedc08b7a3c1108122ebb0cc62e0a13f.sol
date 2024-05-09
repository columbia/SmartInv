1 // SPDX-License-Identifier: MIT                                                                               
2 
3 // Welcome to EmotiCoin, where innovation meets the future of memecoins. 
4 // Our groundbreaking Reverse Split Protocol (RSP) is here to redefine the crypto experience. 
5 // With a total of 84 captivating supply cuts, EmotiCoin is changing the game.
6 
7 // Website: www.emoticoin.io
8 // Twitter: https://twitter.com/Emoticoin_io
9 // Telegram: https://t.me/emoticoin_io
10 // Instagram: https://www.instagram.com/emoticoin_io/                 
11 
12 pragma solidity 0.8.20;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract ERC20 is Context, IERC20 {
41     mapping(address => uint256) private _balances;
42     mapping(address => mapping(address => uint256)) private _allowances;
43     uint256 private _totalSupply;
44     string private _name;
45     string private _symbol;
46 
47     constructor(string memory name_, string memory symbol_) {
48         _name = name_;
49         _symbol = symbol_;
50     }
51 
52     function name() public view virtual override returns (string memory) {
53         return _name;
54     }
55 
56     function symbol() public view virtual override returns (string memory) {
57         return _symbol;
58     }
59 
60     function decimals() public view virtual override returns (uint8) {
61         return 18;
62     }
63 
64     function totalSupply() public view virtual override returns (uint256) {
65         return _totalSupply;
66     }
67 
68     function balanceOf(address account) public view virtual override returns (uint256) {
69         return _balances[account];
70     }
71 
72     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
73         _transfer(_msgSender(), recipient, amount);
74         return true;
75     }
76 
77     function allowance(address owner, address spender) public view virtual override returns (uint256) {
78         return _allowances[owner][spender];
79     }
80 
81     function approve(address spender, uint256 amount) public virtual override returns (bool) {
82         _approve(_msgSender(), spender, amount);
83         return true;
84     }
85 
86     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
87         _transfer(sender, recipient, amount);
88 
89         uint256 currentAllowance = _allowances[sender][_msgSender()];
90         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
91         unchecked {
92             _approve(sender, _msgSender(), currentAllowance - amount);
93         }
94 
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
104         uint256 currentAllowance = _allowances[_msgSender()][spender];
105         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
106         unchecked {
107             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
108         }
109 
110         return true;
111     }
112 
113     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
114         require(sender != address(0), "ERC20: transfer from the zero address");
115         require(recipient != address(0), "ERC20: transfer to the zero address");
116 
117         uint256 senderBalance = _balances[sender];
118         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
119         unchecked {
120             _balances[sender] = senderBalance - amount;
121         }
122         _balances[recipient] += amount;
123 
124         emit Transfer(sender, recipient, amount);
125     }
126 
127     function _createInitialSupply(address account, uint256 amount) internal virtual {
128         require(account != address(0), "ERC20: mint to the zero address");
129 
130         _totalSupply += amount;
131         _balances[account] += amount;
132         emit Transfer(address(0), account, amount);
133     }
134 
135     function _approve(address owner, address spender, uint256 amount) internal virtual {
136         require(owner != address(0), "ERC20: approve from the zero address");
137         require(spender != address(0), "ERC20: approve to the zero address");
138 
139         _allowances[owner][spender] = amount;
140         emit Approval(owner, spender, amount);
141     }
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146 
147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
148     
149     constructor () {
150         address msgSender = _msgSender();
151         _owner = msgSender;
152         emit OwnershipTransferred(address(0), msgSender);
153     }
154 
155     function owner() public view returns (address) {
156         return _owner;
157     }
158 
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     function renounceOwnership() public virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 contract EmotiCoin is Ownable, ERC20 {
177 
178     mapping (address => bool) public whitelisted;
179 
180     string public _1_x;
181     string public _2_telegram;
182     string public _3_website;
183 
184     bool public tradingActive = false;
185 
186     constructor() ERC20("EmotiCoin", "EMOTI"){
187         whitelisted[msg.sender] = true;
188 
189         uint256 totalSupply = 777_777_777 * 1e18;
190         _1_x = "x.com/Emoticoin_io";
191         _2_telegram = "t.me/emoticoin_io";
192         _3_website = "Emoticoin.io";
193 
194         _createInitialSupply(msg.sender, totalSupply);
195     }
196 
197     function _transfer(
198         address from,
199         address to,
200         uint256 amount
201     ) internal override {
202         if(!tradingActive){
203             require(whitelisted[to] || whitelisted[from], "Trading not active");
204         }
205         super._transfer(from, to, amount);
206     }
207 
208     function enableTrading() external onlyOwner {
209         require(!tradingActive, "Trading already active");
210         tradingActive = true;
211         renounceOwnership();
212     }
213 
214     function setWhitelisted(address account, bool exempt) external onlyOwner {
215         whitelisted[account] = exempt;
216     }
217 }