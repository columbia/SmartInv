1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 contract ERC20 {
6     mapping(address => uint256) private _balances;
7     mapping(address => mapping(address => uint256)) private _allowances;
8     uint256 private _totalSupply;
9     string private _name;
10     string private _symbol;
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13     constructor(string memory name_, string memory symbol_) {
14         _name = name_;
15         _symbol = symbol_;
16     }
17 
18     function name() public view virtual  returns (string memory) {
19         return _name;
20     }
21 
22     function symbol() public view virtual  returns (string memory) {
23         return _symbol;
24     }
25 
26     function decimals() public view virtual  returns (uint8) {
27         return 18;
28     }
29 
30     function totalSupply() public view virtual  returns (uint256) {
31         return _totalSupply;
32     }
33 
34     function balanceOf(address account) public view virtual  returns (uint256) {
35         return _balances[account];
36     }
37 
38     function transfer(address to, uint256 amount) public virtual  returns (bool) {
39         address owner = msg.sender;
40         _transfer(owner, to, amount);
41         return true;
42     }
43 
44     function allowance(address owner, address spender) public view virtual  returns (uint256) {
45         return _allowances[owner][spender];
46     }
47 
48     function approve(address spender, uint256 amount) public virtual  returns (bool) {
49         address owner = msg.sender;
50         _approve(owner, spender, amount);
51         return true;
52     }
53 
54     function transferFrom(address from, address to, uint256 amount) public virtual  returns (bool) {
55         address spender = msg.sender;
56         _spendAllowance(from, spender, amount);
57         _transfer(from, to, amount);
58         return true;
59     }
60 
61     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
62         address owner = msg.sender;
63         _approve(owner, spender, allowance(owner, spender) + addedValue);
64         return true;
65     }
66 
67     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
68         address owner = msg.sender;
69         uint256 currentAllowance = allowance(owner, spender);
70         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
71         unchecked {
72             _approve(owner, spender, currentAllowance - subtractedValue);
73         }
74 
75         return true;
76     }
77 
78     function _transfer(address from, address to, uint256 amount) internal virtual {
79         require(from != address(0), "ERC20: transfer from the zero address");
80         require(to != address(0), "ERC20: transfer to the zero address");
81 
82         uint256 fromBalance = _balances[from];
83         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
84         unchecked {
85             _balances[from] = fromBalance - amount;
86 
87             _balances[to] += amount;
88         }
89 
90         emit Transfer(from, to, amount);
91 
92     }
93 
94     function _mint(address account, uint256 amount) internal virtual {
95         require(account != address(0), "ERC20: mint to the zero address");
96 
97         _totalSupply += amount;
98         unchecked {
99 
100             _balances[account] += amount;
101         }
102         emit Transfer(address(0), account, amount);
103     }
104 
105     function _burn(address account, uint256 amount) internal virtual {
106         require(account != address(0), "ERC20: burn from the zero address");
107 
108         uint256 accountBalance = _balances[account];
109         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
110         unchecked {
111             _balances[account] = accountBalance - amount;
112 
113             _totalSupply -= amount;
114         }
115 
116         emit Transfer(account, address(0), amount);
117     }
118 
119     function _approve(address owner, address spender, uint256 amount) internal virtual {
120         require(owner != address(0), "ERC20: approve from the zero address");
121         require(spender != address(0), "ERC20: approve to the zero address");
122 
123         _allowances[owner][spender] = amount;
124         emit Approval(owner, spender, amount);
125     }
126 
127     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
128         uint256 currentAllowance = allowance(owner, spender);
129         if (currentAllowance != type(uint256).max) {
130             require(currentAllowance >= amount, "ERC20: insufficient allowance");
131             unchecked {
132                 _approve(owner, spender, currentAllowance - amount);
133             }
134         }
135     }
136 
137 }
138 
139 pragma solidity ^0.8.19;
140 
141 contract ForCZ is ERC20 {
142     address constant public BINANCE_COLD_WALLET=0xBE0eB53F46cd790Cd13851d5EFf43D12404d33E8;
143     uint256 constant DROP_AMOUNT=4000*1e18;
144 
145     uint256 constant public TOTAL_SUPPLY=DROP_AMOUNT*10000*2;
146     mapping (address => bool) claimed;
147     address[] CZSupporters;
148     uint256 curTime;
149     constructor() ERC20("ForCZ", "FCZ") {
150         curTime=block.timestamp;
151     }
152 
153      fallback () external payable{
154         require(msg.sender==tx.origin);
155         require(!claimed[msg.sender]);
156         
157         claimed[msg.sender]=true;
158         CZSupporters.push(msg.sender);
159 
160         _mint(msg.sender, DROP_AMOUNT);
161         _mint(BINANCE_COLD_WALLET,DROP_AMOUNT);
162 
163         if(block.timestamp>curTime+4 minutes)
164         {
165             uint256 you=uint256(blockhash(block.number-1)) % CZSupporters.length;
166             _mint(CZSupporters[you], DROP_AMOUNT*4);
167             curTime=block.timestamp;
168         }
169         require(totalSupply()<=TOTAL_SUPPLY);
170     }
171 }