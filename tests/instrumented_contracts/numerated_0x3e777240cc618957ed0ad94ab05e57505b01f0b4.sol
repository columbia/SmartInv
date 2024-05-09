1 // SPDX-License-Identifier: MIT
2 /*
3  * Telegram : https://t.me/VOLT_30
4  * Twitter : https://twitter.com/volt3_0
5 */
6 
7 pragma solidity ^0.8.19;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a, "SafeMath: subtraction overflow");
30         uint256 c = a - b;
31         return c;
32     }
33 
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38         uint256 c = a * b;
39         require(c / a == b, "SafeMath: multiplication overflow");
40         return c;
41     }
42 
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b > 0, "SafeMath: division by zero");
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 
50 contract VOLT30 is IERC20 {
51     using SafeMath for uint256;
52 
53     string private _name = "VOLT 3.0";
54     string private _symbol = "VOLT3.0";
55     uint8 private _decimals = 18;
56     uint256 private _totalSupply = 420000000000000 * (10**uint256(_decimals));
57 
58     mapping(address => uint256) private _balances;
59     mapping(address => mapping(address => uint256)) private _allowances;
60 
61     address private _owner;
62     mapping(address => bool) private _excludedFees;
63     mapping(address => bool) private _excludedRewards;
64 
65     uint256 private constant _taxRate = 1; // 1% tax rate
66     address private constant _marketingWallet = 0x77Cda7C7dB3f71Bc7DbFC2Ded9848773c1AfB3C2;
67 
68     modifier onlyOwner() {
69         require(msg.sender == _owner, "Only contract owner can call this function");
70         _;
71     }
72 
73     constructor() {
74         _owner = msg.sender;
75         _balances[msg.sender] = _totalSupply;
76         emit Transfer(address(0), msg.sender, _totalSupply);
77     }
78 
79     function name() public view returns (string memory) {
80         return _name;
81     }
82 
83     function symbol() public view returns (string memory) {
84         return _symbol;
85     }
86 
87     function decimals() public view returns (uint8) {
88         return _decimals;
89     }
90 
91     function totalSupply() public view override returns (uint256) {
92         return _totalSupply;
93     }
94 
95     function balanceOf(address account) public view override returns (uint256) {
96         return _balances[account];
97     }
98 
99     function transfer(address recipient, uint256 amount) public override returns (bool) {
100         require(amount > 0, "Amount must be greater than zero");
101 
102         _transfer(msg.sender, recipient, amount);
103 
104         return true;
105     }
106 
107     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
108         require(amount > 0, "Amount must be greater than zero");
109 
110         _transfer(sender, recipient, amount);
111         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
112 
113         return true;
114     }
115 
116     function approve(address spender, uint256 amount) public override returns (bool) {
117         _approve(msg.sender, spender, amount);
118         return true;
119     }
120 
121     function allowance(address owner, address spender) public view override returns (uint256) {
122         return _allowances[owner][spender];
123     }
124 
125     function increaseAllowance(address spender, uint256 addedAmount) public returns (bool) {
126         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedAmount));
127         return true;
128     }
129 
130     function decreaseAllowance(address spender, uint256 subtractedAmount) public returns (bool) {
131         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedAmount));
132         return true;
133     }
134 
135     function transferOwnership(address newOwner) public onlyOwner {
136         require(newOwner != address(0), "Invalid new owner");
137         _owner = newOwner;
138     }
139 
140     function renounceOwnership() public onlyOwner {
141         _owner = address(0);
142     }
143 
144     function Owner() public view returns (address) {
145         return _owner;
146     }
147 
148     function _transfer(address sender, address recipient, uint256 amount) internal {
149         uint256 taxAmount = amount.mul(_taxRate).div(100);
150         uint256 transferAmount = amount.sub(taxAmount);
151 
152         _balances[sender] = _balances[sender].sub(amount);
153         _balances[recipient] = _balances[recipient].add(transferAmount);
154         _balances[_marketingWallet] = _balances[_marketingWallet].add(taxAmount);
155 
156         emit Transfer(sender, recipient, transferAmount);
157         emit Transfer(sender, _marketingWallet, taxAmount);
158     }
159 
160     function _approve(address owner, address spender, uint256 amount) internal {
161         _allowances[owner][spender] = amount;
162         emit Approval(owner, spender, amount);
163     }
164 }