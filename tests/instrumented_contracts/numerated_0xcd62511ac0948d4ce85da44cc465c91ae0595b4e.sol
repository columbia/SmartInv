1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address to, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(
11         address from,
12         address to,
13         uint256 amount
14     ) external returns (bool);
15     function name() external view returns (string memory);
16     function symbol() external view returns (string memory);
17     function decimals() external view returns (uint8);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract ERC20 is IERC20 {
23     string private _name;
24     string private _symbol;
25     uint8 public _decimals;
26     mapping(address => uint256) private _balances;
27     mapping(address => mapping(address => uint256)) private _allowances;
28     uint256 private _totalSupply;
29 
30     function _msgSender() internal view virtual returns (address)
31     {
32         return msg.sender;
33     }
34 
35     constructor(string memory NAME, string memory SYMBOL, uint8 DECIMALS, uint TOTAL_SUPPLY)
36     {
37         _name = NAME;
38         _symbol = SYMBOL;
39         _decimals = DECIMALS;
40         _mint(msg.sender, TOTAL_SUPPLY);
41     }
42 
43     function name() public view returns(string memory)
44     {
45         return _name;
46     }
47 
48     function symbol() public view returns(string memory)
49     {
50         return _symbol;
51     }
52 
53     function decimals() public view returns (uint8)
54     {
55         return _decimals;
56     }
57 
58     function totalSupply() public view returns (uint256)
59     {
60         return _totalSupply;
61     }
62 
63     function balanceOf(address account) public view returns (uint256)
64     {
65         return _balances[account];
66     }
67 
68     function transfer(address to, uint256 amount) public returns (bool)
69     {
70         address owner = _msgSender();
71         _transfer(owner, to, amount);
72         return true;
73     }
74 
75     function allowance(address owner, address spender) public view returns (uint256)
76     {
77         return _allowances[owner][spender];
78     }
79 
80     function approve(address spender, uint256 amount) public virtual override returns (bool)
81     {
82         address owner = _msgSender();
83         _approve(owner, spender, amount);
84         return true;
85     }
86 
87     function transferFrom(address from, address to, uint256 amount) public returns (bool)
88     {
89         address spender = _msgSender();
90         _spendAllowance(from, spender, amount);
91         _transfer(from, to, amount);
92         return true;
93     }
94 
95     function increaseAllowance(address spender, uint256 addedValue) public returns (bool)
96     {
97         address owner = _msgSender();
98         _approve(owner, spender, _allowances[owner][spender] + addedValue);
99         return true;
100     }
101 
102     function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool)
103     {
104         address owner = _msgSender();
105         uint256 currentAllowance = _allowances[owner][spender];
106         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
107         unchecked {
108             _approve(owner, spender, currentAllowance - subtractedValue);
109         }
110 
111         return true;
112     }
113 
114     function _transfer(address from, address to, uint256 amount) internal
115     {
116         require(from != address(0), "ERC20: transfer from the zero address");
117         require(to != address(0), "ERC20: transfer to the zero address");
118 
119         uint256 fromBalance = _balances[from];
120         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
121         unchecked {
122             _balances[from] = fromBalance - amount;
123         }
124         _balances[to] += amount;
125 
126         emit Transfer(from, to, amount);
127     }
128 
129     function _mint(address account, uint256 amount) internal
130     {
131         require(account != address(0), "ERC20: mint to the zero address");
132 
133         _totalSupply += amount;
134         _balances[account] += amount;
135         emit Transfer(address(0), account, amount);
136     }
137 
138     function _approve(address owner, address spender, uint256 amount) internal
139     {
140         require(owner != address(0), "ERC20: approve from the zero address");
141         require(spender != address(0), "ERC20: approve to the zero address");
142 
143         _allowances[owner][spender] = amount;
144         emit Approval(owner, spender, amount);
145     }
146 
147     function _spendAllowance(address owner, address spender, uint256 amount) internal
148     {
149         uint256 currentAllowance = allowance(owner, spender);
150         if (currentAllowance != type(uint256).max) {
151             require(currentAllowance >= amount, "ERC20: insufficient allowance");
152             unchecked {
153                 _approve(owner, spender, currentAllowance - amount);
154             }
155         }
156     }
157 }