1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract SeedSwapToken is IERC20 {
17     
18     mapping (address => uint256) private _balances;
19     mapping (address => mapping (address => uint256)) private _allowances;
20 
21     uint256 private _totalSupply;
22     string private _name;
23     string private _symbol;
24 
25     constructor (string memory name_, string memory symbol_) {
26         _name = name_;
27         _symbol = symbol_;
28         _totalSupply = 100000000000000000000000000;
29         _balances[0xC3207fc9caF89a7c37b3651Dd77f91e933d956A4] = 60000000000000000000000000;
30         _balances[0xDdbD7290328284bc9C1020bb5AeBB07B06973C13] = 40000000000000000000000000;
31         emit Transfer(address(0), 0xC3207fc9caF89a7c37b3651Dd77f91e933d956A4, 60000000000000000000000000);
32         emit Transfer(address(0), 0xDdbD7290328284bc9C1020bb5AeBB07B06973C13, 40000000000000000000000000);
33     }
34 
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38     
39     function name() public view virtual returns (string memory) {
40         return _name;
41     }
42 
43     function symbol() public view virtual returns (string memory) {
44         return _symbol;
45     }
46 
47     function decimals() public view virtual returns (uint8) {
48         return 18;
49     }
50 
51     function totalSupply() public view virtual override returns (uint256) {
52         return _totalSupply  - _balances[address(0)];
53     }
54 
55     function balanceOf(address account) public view virtual override returns (uint256) {
56         return _balances[account];
57     }
58 
59     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
60         _transfer(_msgSender(), recipient, amount);
61         return true;
62     }
63 
64 
65     function allowance(address owner, address spender) public view virtual override returns (uint256) {
66         return _allowances[owner][spender];
67     }
68 
69     function approve(address spender, uint256 amount) public virtual override returns (bool) {
70         _approve(_msgSender(), spender, amount);
71         return true;
72     }
73 
74 
75     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
76         _transfer(sender, recipient, amount);
77         uint256 currentAllowance = _allowances[sender][_msgSender()];
78         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
79         _approve(sender, _msgSender(), currentAllowance - amount);
80         return true;
81     }
82 
83     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
84         require(sender != address(0), "ERC20: transfer from the zero address");
85         require(recipient != address(0), "ERC20: transfer to the zero address");
86         uint256 senderBalance = _balances[sender];
87         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
88         _balances[sender] = senderBalance - amount;
89         _balances[recipient] += amount;
90         emit Transfer(sender, recipient, amount);
91     }
92 
93     function _approve(address owner, address spender, uint256 amount) internal virtual {
94         require(owner != address(0), "ERC20: approve from the zero address");
95         require(spender != address(0), "ERC20: approve to the zero address");
96         _allowances[owner][spender] = amount;
97         emit Approval(owner, spender, amount);
98     }
99 }