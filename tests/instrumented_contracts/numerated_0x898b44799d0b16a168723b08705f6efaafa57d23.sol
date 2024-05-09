1 // SPDX-License-Identifier: MIT
2 
3 /** 
4 ░W░E░B░S░I░T░E░ https://xaetokenerc20.com/
5 ░T░W░I░T░T░E░R░ https://twitter.com/XAETOKENERC20
6 **/
7 
8 pragma solidity ^0.8.20;
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a, "SafeMath: subtraction overflow");
31         uint256 c = a - b;
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b > 0, "SafeMath: division by zero");
46         uint256 c = a / b;
47         return c;
48     }
49 }
50 
51 contract XAE is IERC20 {
52     using SafeMath for uint256;
53 
54     string private _name = "XAE";
55     string private _symbol = "XAE";
56     uint8 private _decimals = 18;
57     uint256 private _totalSupply = 1000000000000 * (10**uint256(_decimals));
58 
59     mapping(address => uint256) private _balances;
60     mapping(address => mapping(address => uint256)) private _allowances;
61 
62     address private _owner;
63     mapping(address => bool) private _excludedFees;
64     mapping(address => bool) private _excludedRewards;
65 
66     uint256 private constant _taxRate = 2; // 2% tax rate
67     address private constant _marketingWallet = 0xCf9aaE5ac6898e1C83785150611DcAC92F17F0AB;
68 
69     modifier onlyOwner() {
70         require(msg.sender == _owner, "Only contract owner can call this function");
71         _;
72     }
73 
74     constructor() {
75         _owner = msg.sender;
76         _balances[msg.sender] = _totalSupply;
77         emit Transfer(address(0), msg.sender, _totalSupply);
78     }
79 
80     function name() public view returns (string memory) {
81         return _name;
82     }
83 
84     function symbol() public view returns (string memory) {
85         return _symbol;
86     }
87 
88     function decimals() public view returns (uint8) {
89         return _decimals;
90     }
91 
92     function totalSupply() public view override returns (uint256) {
93         return _totalSupply;
94     }
95 
96     function balanceOf(address account) public view override returns (uint256) {
97         return _balances[account];
98     }
99 
100     function transfer(address recipient, uint256 amount) public override returns (bool) {
101         require(amount > 0, "Amount must be greater than zero");
102 
103         _transfer(msg.sender, recipient, amount);
104 
105         return true;
106     }
107 
108     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
109         require(amount > 0, "Amount must be greater than zero");
110 
111         _transfer(sender, recipient, amount);
112         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
113 
114         return true;
115     }
116 
117     function approve(address spender, uint256 amount) public override returns (bool) {
118         _approve(msg.sender, spender, amount);
119         return true;
120     }
121 
122     function allowance(address owner, address spender) public view override returns (uint256) {
123         return _allowances[owner][spender];
124     }
125 
126     function increaseAllowance(address spender, uint256 addedAmount) public returns (bool) {
127         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedAmount));
128         return true;
129     }
130 
131     function decreaseAllowance(address spender, uint256 subtractedAmount) public returns (bool) {
132         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedAmount));
133         return true;
134     }
135 
136     function transferOwnership(address newOwner) public onlyOwner {
137         require(newOwner != address(0), "Invalid new owner");
138         _owner = newOwner;
139     }
140 
141     function renounceOwnership() public onlyOwner {
142         _owner = address(0);
143     }
144 
145     function Owner() public view returns (address) {
146         return _owner;
147     }
148 
149     function _transfer(address sender, address recipient, uint256 amount) internal {
150         uint256 taxAmount = amount.mul(_taxRate).div(100);
151         uint256 transferAmount = amount.sub(taxAmount);
152 
153         _balances[sender] = _balances[sender].sub(amount);
154         _balances[recipient] = _balances[recipient].add(transferAmount);
155         _balances[_marketingWallet] = _balances[_marketingWallet].add(taxAmount);
156 
157         emit Transfer(sender, recipient, transferAmount);
158         emit Transfer(sender, _marketingWallet, taxAmount);
159     }
160 
161     function _approve(address owner, address spender, uint256 amount) internal {
162         _allowances[owner][spender] = amount;
163         emit Approval(owner, spender, amount);
164     }
165 }