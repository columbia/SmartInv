1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 // ----------------------------------------------------------------------------
5 // 'CPRC' Token contract
6 // Name        : CryptoPawCoin
7 // Symbol      : CPRC
8 // Decimals    : 18
9 // ----------------------------------------------------------------------------
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(
17         address sender,
18         address recipient,
19         uint256 amount
20     ) external returns (bool);
21    
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 interface IERC20Metadata is IERC20 {
27     function name() external view returns (string memory);
28     function symbol() external view returns (string memory);
29     function decimals() external view returns (uint8);
30 }
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 contract ERC20 is Context, IERC20, IERC20Metadata {
44     mapping(address => uint256) private _balances;
45 
46     mapping(address => mapping(address => uint256)) private _allowances;
47 
48     uint256 private _totalSupply;
49 
50     string private _name;
51     string private _symbol;
52 
53     constructor(string memory name_, string memory symbol_) {
54         _name = name_;
55         _symbol = symbol_;
56     }
57 
58     function name() public view virtual override returns (string memory) {
59         return _name;
60     }
61 
62     function symbol() public view virtual override returns (string memory) {
63         return _symbol;
64     }
65 
66     function decimals() public view virtual override returns (uint8) {
67         return 18;
68     }
69 
70     function totalSupply() public view virtual override returns (uint256) {
71         return _totalSupply;
72     }
73 
74     function balanceOf(address account) public view virtual override returns (uint256) {
75         return _balances[account];
76     }
77 
78     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
79         _transfer(_msgSender(), recipient, amount);
80         return true;
81     }
82 
83     function allowance(address owner, address spender) public view virtual override returns (uint256) {
84         return _allowances[owner][spender];
85     }
86 
87     function approve(address spender, uint256 amount) public virtual override returns (bool) {
88         _approve(_msgSender(), spender, amount);
89         return true;
90     }
91 
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) public virtual override returns (bool) {
97         uint256 currentAllowance = _allowances[sender][_msgSender()];
98         if (currentAllowance != type(uint256).max) {
99             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
100             unchecked {
101                 _approve(sender, _msgSender(), currentAllowance - amount);
102             }
103         }
104 
105         _transfer(sender, recipient, amount);
106 
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
116         uint256 currentAllowance = _allowances[_msgSender()][spender];
117         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
118         unchecked {
119             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
120         }
121 
122         return true;
123     }
124 
125     function _transfer(
126         address sender,
127         address recipient,
128         uint256 amount
129     ) internal virtual {
130         require(sender != address(0), "ERC20: transfer from the zero address");
131         require(recipient != address(0), "ERC20: transfer to the zero address");
132 
133         _beforeTokenTransfer(sender, recipient, amount);
134 
135         uint256 senderBalance = _balances[sender];
136         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
137         unchecked {
138             _balances[sender] = senderBalance - amount;
139         }
140         _balances[recipient] += amount;
141 
142         emit Transfer(sender, recipient, amount);
143 
144         _afterTokenTransfer(sender, recipient, amount);
145     }
146 
147     function _mint(address account, uint256 amount) internal virtual {
148         require(account != address(0), "ERC20: mint to the zero address");
149 
150         _beforeTokenTransfer(address(0), account, amount);
151 
152         _totalSupply += amount;
153         _balances[account] += amount;
154         emit Transfer(address(0), account, amount);
155 
156         _afterTokenTransfer(address(0), account, amount);
157     }
158 
159     function _burn(address account, uint256 amount) internal virtual {
160         require(account != address(0), "ERC20: burn from the zero address");
161 
162         _beforeTokenTransfer(account, address(0), amount);
163 
164         uint256 accountBalance = _balances[account];
165         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
166         unchecked {
167             _balances[account] = accountBalance - amount;
168         }
169         _totalSupply -= amount;
170 
171         emit Transfer(account, address(0), amount);
172 
173         _afterTokenTransfer(account, address(0), amount);
174     }
175 
176     function _approve(
177         address owner,
178         address spender,
179         uint256 amount
180     ) internal virtual {
181         require(owner != address(0), "ERC20: approve from the zero address");
182         require(spender != address(0), "ERC20: approve to the zero address");
183 
184         _allowances[owner][spender] = amount;
185         emit Approval(owner, spender, amount);
186     }
187 
188     function _beforeTokenTransfer(
189         address from,
190         address to,
191         uint256 amount
192     ) internal virtual {}
193 
194     function _afterTokenTransfer(
195         address from,
196         address to,
197         uint256 amount
198     ) internal virtual {}
199 }
200 
201 contract CPRCToken is ERC20 {
202     constructor () ERC20("CryptoPawCoin", "CPRC") 
203     {    
204         _mint(msg.sender, 312_733_489_531 * (10 ** 18));
205     }
206 }