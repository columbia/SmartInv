1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC20 {
7 	event Transfer(address indexed from, address indexed to, uint256 value);
8     event Approval(address indexed owner, address indexed spender, uint256 value);
9 
10     function name() external view returns (string memory);
11     function symbol() external view returns (string memory);
12     function decimals() external view returns (uint8);
13 	function totalSupply() external view returns (uint256);
14 	function balanceOf(address account) external view returns (uint256);
15 	function allowance(address owner, address spender) external view returns (uint256);
16 	function approve(address spender, uint256 amount) external returns (bool);
17 	function transfer(address recipient, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19 }
20 
21 
22 contract ERC20 is IERC20 {
23     string private _name;
24     string private _symbol;
25     uint8 private _decimals;
26     uint256 private _totalSupply;
27     mapping(address => uint256) private _balances;
28     mapping(address => mapping(address => uint256)) private _allowances;
29     
30     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
31         _name = name_;
32         _symbol = symbol_;
33         _decimals = decimals_;
34     }
35 
36     function name() public view virtual override returns (string memory) {
37         return _name;
38     }
39 
40     function symbol() public view virtual override returns (string memory) {
41         return _symbol;
42     }
43     
44     function decimals() public view virtual override returns (uint8) {
45         return _decimals;
46     }
47 
48     function totalSupply() public view virtual override returns (uint256) {
49         return _totalSupply;
50     }
51     
52     function balanceOf(address account) public view virtual override returns (uint256) {
53         return _balances[account];
54     }
55     
56     function allowance(address owner, address spender) public view virtual override returns (uint256) {
57         return _allowances[owner][spender];
58     }
59     
60     function approve(address spender, uint256 amount) public virtual override returns (bool) {
61         _approve(msg.sender, spender, amount);
62         return true;
63     }
64     
65     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
66         _transfer(msg.sender, recipient, amount);
67         return true;
68     }
69 	
70     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
71         _transfer(sender, recipient, amount);
72         uint256 currentAllowance = _allowances[sender][msg.sender];
73         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
74         unchecked {
75             _approve(sender, msg.sender, currentAllowance - amount);
76         }
77         return true;
78     }
79     
80     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
81         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
82         return true;
83     }
84     
85     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
86         uint256 currentAllowance = _allowances[msg.sender][spender];
87         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
88         unchecked {
89             _approve(msg.sender, spender, currentAllowance - subtractedValue);
90         }
91         return true;
92     }
93     
94     function _mint(address account, uint256 amount) internal virtual {
95         require(account != address(0), "ERC20: mint to the zero address");
96         _beforeTokenTransfer(address(0), account, amount);
97         _totalSupply += amount;
98         _balances[account] += amount;
99         emit Transfer(address(0), account, amount);
100         _afterTokenTransfer(address(0), account, amount);
101     }
102     
103     function _burn(address account, uint256 amount) internal virtual {
104         require(account != address(0), "ERC20: burn from the zero address");
105         _beforeTokenTransfer(account, address(0), amount);
106         uint256 accountBalance = _balances[account];
107         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
108         unchecked {
109             _balances[account] = accountBalance - amount;
110         }
111         _totalSupply -= amount;
112         emit Transfer(account, address(0), amount);
113         _afterTokenTransfer(account, address(0), amount);
114     }
115     
116     function _approve(address owner, address spender, uint256 amount) internal virtual {
117         require(owner != address(0), "ERC20: approve from the zero address");
118         require(spender != address(0), "ERC20: approve to the zero address");
119         _allowances[owner][spender] = amount;
120         emit Approval(owner, spender, amount);
121     }
122     
123     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
124         require(sender != address(0), "ERC20: transfer from the zero address");
125         require(recipient != address(0), "ERC20: transfer to the zero address");
126         _beforeTokenTransfer(sender, recipient, amount);
127         uint256 senderBalance = _balances[sender];
128         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
129         unchecked {
130             _balances[sender] = senderBalance - amount;
131         }
132         _balances[recipient] += amount;
133         emit Transfer(sender, recipient, amount);
134         _afterTokenTransfer(sender, recipient, amount);
135     }
136     
137     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
138     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
139 }
140 
141 
142 contract NVA is ERC20 {
143     address private _owner;
144     bool private _locked = false;
145     
146     event DepositEther(address indexed fromAddress, uint256 valueEth);
147 	event WithdrawEther(address indexed fromAddress, uint256 valueEth);
148 
149     constructor() ERC20("NVA", "NVA", 18) {
150 		uint256 initTotalSupply = uint256(10000000000)*(uint256(10)**18);
151 		_mint(msg.sender, initTotalSupply);
152 		_owner = msg.sender;
153 	}
154 	
155     function owner() public view returns (address) {
156         return _owner;
157     }
158 	
159     function getBalanceEther() public view returns (uint256) {
160         return address(this).balance;
161     }
162 	
163     function depositEther() public payable {
164         emit DepositEther(msg.sender, msg.value);
165     }
166     
167     function withdrawEther(address payable recipient, uint256 amount) public {
168         require(!_locked, "Reentrant call detected!");
169         _locked = true;
170         require(msg.sender == _owner);
171         require(address(this).balance >= amount, "Address: insufficient balance");
172         (bool success, ) = recipient.call{value: amount}("");
173         require(success, "Address: unable to send value, recipient may have reverted");
174 		emit WithdrawEther(recipient, amount);
175         _locked = false;
176     }
177     
178     fallback() external payable {
179 		emit DepositEther(msg.sender, msg.value);
180 	}
181 	receive() external payable {
182 		emit DepositEther(msg.sender, msg.value);
183 	}
184 }