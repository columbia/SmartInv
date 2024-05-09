1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 contract BlankToken is Context, IERC20 {
35     mapping (address => uint256) private _balances;
36 
37     mapping (address => mapping (address => uint256)) private _allowances;
38 
39     uint256 private _totalSupply;
40 
41     string private _name = "Blank Token";
42     string private _symbol = "BLANK";
43 
44     constructor (uint256 totalSupply_) {
45         _totalSupply = totalSupply_;
46         _balances[_msgSender()] = _totalSupply;
47     }
48 
49     function name() public view virtual returns (string memory) {
50         return _name;
51     }
52 
53     function symbol() public view virtual returns (string memory) {
54         return _symbol;
55     }
56 
57     function decimals() public view virtual returns (uint8) {
58         return 18;
59     }
60 
61     function totalSupply() public view virtual override returns (uint256) {
62         return _totalSupply;
63     }
64 
65     function balanceOf(address account) public view virtual override returns (uint256) {
66         return _balances[account];
67     }
68 
69     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
70         _transfer(_msgSender(), recipient, amount);
71         return true;
72     }
73 
74     function allowance(address owner, address spender) public view virtual override returns (uint256) {
75         return _allowances[owner][spender];
76     }
77 
78     function approve(address spender, uint256 amount) public virtual override returns (bool) {
79         _approve(_msgSender(), spender, amount);
80         return true;
81     }
82 
83     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
84         _transfer(sender, recipient, amount);
85 
86         uint256 currentAllowance = _allowances[sender][_msgSender()];
87         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
88         _approve(sender, _msgSender(), currentAllowance - amount);
89 
90         return true;
91     }
92 
93     function burn(uint256 amount) public virtual {
94         _burn(_msgSender(), amount);
95     }
96 
97     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
98         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
99         return true;
100     }
101 
102     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
103         uint256 currentAllowance = _allowances[_msgSender()][spender];
104         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
105         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
106 
107         return true;
108     }
109 
110     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
111         require(sender != address(0), "ERC20: transfer from the zero address");
112         require(recipient != address(0), "ERC20: transfer to the zero address");
113 
114         uint256 senderBalance = _balances[sender];
115         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
116         _balances[sender] = senderBalance - amount;
117         _balances[recipient] += amount;
118 
119         emit Transfer(sender, recipient, amount);
120     }
121 
122     function _burn(address account, uint256 amount) internal virtual {
123         require(account != address(0), "ERC20: burn from the zero address");
124 
125         uint256 accountBalance = _balances[account];
126         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
127         _balances[account] = accountBalance - amount;
128         _totalSupply -= amount;
129 
130         emit Transfer(account, address(0), amount);
131     }
132 
133     function _approve(address owner, address spender, uint256 amount) internal virtual {
134         require(owner != address(0), "ERC20: approve from the zero address");
135         require(spender != address(0), "ERC20: approve to the zero address");
136 
137         _allowances[owner][spender] = amount;
138         emit Approval(owner, spender, amount);
139     }
140 }