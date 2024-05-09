1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.7.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 abstract contract ERC20 is IERC20 {
22     uint256 private _totalSupply;
23     mapping(address => uint256) private _balances;
24     mapping(address => mapping(address => uint256)) private _allowances;
25 
26     string private _name;
27     string private _symbol;
28     uint8 private _decimals;
29 
30     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) {
31         _name = name;
32         _symbol = symbol;
33         _decimals = decimals;
34         _totalSupply = totalSupply;
35         _balances[msg.sender] = totalSupply;
36         emit Transfer(address(0), msg.sender, totalSupply);
37     }
38 
39     function name() public view returns (string memory) {
40         return _name;
41     }
42 
43     function symbol() public view returns (string memory) {
44         return _symbol;
45     }
46 
47     function decimals() public view returns (uint8) {
48         return _decimals;
49     }
50 
51     function totalSupply() public view override returns (uint256) {
52         return _totalSupply;
53     }
54 
55     function balanceOf(address account) public view override returns (uint256) {
56         return _balances[account];
57     }
58 
59     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
60         _transfer(msg.sender, recipient, amount);
61         return true;
62     }
63 
64     function allowance(address owner, address spender) public view virtual override returns (uint256) {
65         return _allowances[owner][spender];
66     }
67 
68     function approve(address spender, uint256 amount) public virtual override returns (bool) {
69         _approve(msg.sender, spender, amount);
70         return true;
71     }
72 
73     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
74         _transfer(sender, recipient, amount);
75 
76         uint256 allowanceSender = _allowances[sender][msg.sender];
77         require(amount <= allowanceSender, "ERC20: transfer amount exceeds allowance");
78 
79         _approve(sender, msg.sender, allowanceSender - amount);
80         return true;
81     }
82 
83     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
84         uint256 sum = _allowances[msg.sender][spender] + addedValue;
85         require(sum >= addedValue, "SafeMath: addition overflow");
86 
87         _approve(msg.sender, spender, sum);
88         return true;
89     }
90 
91     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
92         uint256 temp = _allowances[msg.sender][spender];
93         require(subtractedValue <= temp, "ERC20: decreased allowance below zero");
94 
95         _approve(msg.sender, spender, temp - subtractedValue);
96         return true;
97     }
98 
99     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
100         require(sender != address(0), "ERC20: transfer from the zero address");
101         require(recipient != address(0), "ERC20: transfer to the zero address");
102 
103         uint256 temp = _balances[sender];
104         require(amount <= temp, "ERC20: transfer amount exceeds balance");
105         _balances[sender] = temp - amount;
106 
107         temp = _balances[recipient];
108         require(temp + amount >= temp, "SafeMath: addition overflow");
109         _balances[recipient] = temp + amount;
110         emit Transfer(sender, recipient, amount);
111     }
112 
113     function _approve(address owner, address spender, uint256 amount) internal virtual {
114         require(owner != address(0), "ERC20: approve from the zero address");
115         require(spender != address(0), "ERC20: approve to the zero address");
116 
117         _allowances[owner][spender] = amount;
118         emit Approval(owner, spender, amount);
119     }
120 }
121 
122 contract NSBT is ERC20 {
123     constructor() ERC20("Neutrino System Base Token", "NSBT", 6, 1000000000000000000) {
124     }
125 }