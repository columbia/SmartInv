1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     event Transfer(address indexed from, address indexed to, uint256 value);
6 
7     event Approval(address indexed owner, address indexed spender, uint256 value);
8 
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address to, uint256 amount) external returns (bool);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address from,
21         address to,
22         uint256 amount
23     ) external returns (bool);
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
38         return msg.data;
39     }
40 }
41 
42 contract Token is Context, IERC20, IERC20Metadata {
43     mapping(address => uint256) private _balances;
44     mapping(address => mapping(address => uint256)) private _allowances;
45     uint256 private _totalSupply;
46     string private _name;
47     string private _symbol;
48 
49     constructor(string memory name_, string memory symbol_, uint256 supply_) {
50         _name = name_;
51         _symbol = symbol_;
52         _mint(msg.sender, supply_);
53     }
54 
55     function name() public view virtual override returns (string memory) {
56         return _name;
57     }
58 
59     function symbol() public view virtual override returns (string memory) {
60         return _symbol;
61     }
62 
63     function decimals() public view virtual override returns (uint8) {
64         return 18;
65     }
66 
67     function totalSupply() public view virtual override returns (uint256) {
68         return _totalSupply;
69     }
70 
71     function balanceOf(address account) public view virtual override returns (uint256) {
72         return _balances[account];
73     }
74 
75     function transfer(address to, uint256 amount) public virtual override returns (bool) {
76         address owner = _msgSender();
77         _transfer(owner, to, amount);
78         return true;
79     }
80 
81     function allowance(address owner, address spender) public view virtual override returns (uint256) {
82         return _allowances[owner][spender];
83     }
84 
85     function approve(address spender, uint256 amount) public virtual override returns (bool) {
86         address owner = _msgSender();
87         _approve(owner, spender, amount);
88         return true;
89     }
90 
91     function transferFrom(
92         address from,
93         address to,
94         uint256 amount
95     ) public virtual override returns (bool) {
96         address spender = _msgSender();
97         _spendAllowance(from, spender, amount);
98         _transfer(from, to, amount);
99         return true;
100     }
101 
102     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
103         address owner = _msgSender();
104         _approve(owner, spender, allowance(owner, spender) + addedValue);
105         return true;
106     }
107 
108     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
109         address owner = _msgSender();
110         uint256 currentAllowance = allowance(owner, spender);
111         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
112         unchecked {
113             _approve(owner, spender, currentAllowance - subtractedValue);
114         }
115 
116         return true;
117     }
118 
119     function _transfer(
120         address from,
121         address to,
122         uint256 amount
123     ) internal virtual {
124         require(from != address(0), "ERC20: transfer from the zero address");
125         require(to != address(0), "ERC20: transfer to the zero address");
126 
127         _beforeTokenTransfer(from, to, amount);
128 
129         uint256 fromBalance = _balances[from];
130         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
131         unchecked {
132             _balances[from] = fromBalance - amount;
133             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
134             // decrementing then incrementing.
135             _balances[to] += amount;
136         }
137 
138         emit Transfer(from, to, amount);
139 
140         _afterTokenTransfer(from, to, amount);
141     }
142 
143     function _mint(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: mint to the zero address");
145 
146         _beforeTokenTransfer(address(0), account, amount);
147 
148         _totalSupply += amount;
149         unchecked {
150             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
151             _balances[account] += amount;
152         }
153         emit Transfer(address(0), account, amount);
154 
155         _afterTokenTransfer(address(0), account, amount);
156     }
157 
158     function _burn(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: burn from the zero address");
160 
161         _beforeTokenTransfer(account, address(0), amount);
162 
163         uint256 accountBalance = _balances[account];
164         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
165         unchecked {
166             _balances[account] = accountBalance - amount;
167             // Overflow not possible: amount <= accountBalance <= totalSupply.
168             _totalSupply -= amount;
169         }
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
188     function _spendAllowance(
189         address owner,
190         address spender,
191         uint256 amount
192     ) internal virtual {
193         uint256 currentAllowance = allowance(owner, spender);
194         if (currentAllowance != type(uint256).max) {
195             require(currentAllowance >= amount, "ERC20: insufficient allowance");
196             unchecked {
197                 _approve(owner, spender, currentAllowance - amount);
198             }
199         }
200     }
201 
202     function _beforeTokenTransfer(
203         address from,
204         address to,
205         uint256 amount
206     ) internal virtual {}
207 
208     function _afterTokenTransfer(
209         address from,
210         address to,
211         uint256 amount
212     ) internal virtual {}
213 }