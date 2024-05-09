1 // SPDX-License-Identifier: PAIN
2 // ⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠂⠉⠁⠀⠀⠀⠉⠁⠒⠢⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 // ⠀⠀⠀⠀⠀⢀⠀⠊⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠢⡀⠀⠀⠀⠀⠀⠀
4 // ⠀⠀⠀⠀⡠⠊⢀⡄⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡀⠀⠀⠀⢸⡀⠀⠀⠀⠀⠀
5 // ⠀⠀⠀⠠⠁⠀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⡀⠀⠀⠀⡇⠀⠀⠀⠀⠀
6 // ⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⡄⠀⠀⢳⡀⠀⠀⠀⠀
7 // ⠀⠀⠀⢨⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⡀⠀⠀⣽⠀⠀⠀⠀
8 // ⠀⠀⠀⠘⡇⠀⠀⠀⠀⣀⡀⠀⠀⢀⣀⣀⡀⠀⠀⣀⣀⣰⠁⢀⣇⡙⡇⠀⠀⠀
9 // ⠀⠀⠀⠀⢧⠀⢀⣴⣾⣿⡗⠀⠀⠛⠛⢛⣛⡫⠉⠀⡄⢸⠀⣸⡟⢀⠃⠀⠀⠀
10 // ⠀⠀⠀⠀⠈⢦⠀⠀⠀⠃⠀⠀⠀⠀⢀⡀⠀⠀⠀⠘⢁⠀⠀⢸⣀⡜⠀⠀⠀⠀
11 // ⠀⠀⠀⠀⠀⢸⠀⠀⠀⡼⡁⣀⣀⣠⠴⠃⠀⠢⡀⠀⠘⣦⠀⠘⣏⢄⠀⠀⠀⠀
12 // ⠀⠀⠀⠀⠀⠸⡆⠀⠸⠁⣠⣬⣍⣭⠴⢶⡶⠂⠐⠤⠤⠟⠀⢀⡏⠀⢃⠀⠀⠀
13 // ⠀⠀⠀⠀⠀⠀⢇⠀⠀⠀⠙⠒⢶⣐⠲⠉⠀⠀⠀⠀⠀⢀⣴⣾⠃⠀⠀⠑⠒⠤
14 // ⠀⠀⠀⠀⠀⠀⠈⢢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⡿⠃⠀⠀⠀⠀⠀⠀
15 // ⠀⠀⠀⠀⠀⡠⠀⠀⡠⠂⣄⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀
16 // ⡠⠔⠒⠉⠁⠀⠀⠀⠀⢀⡀⢿⣶⠦⢤⣤⣾⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 
18 pragma solidity ^0.8.15;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address to, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(
36         address from,
37         address to,
38         uint256 amount
39     ) external returns (bool);
40 }
41 
42 interface IERC20Metadata is IERC20 {
43     function name() external view returns (string memory);
44     function symbol() external view returns (string memory);
45     function decimals() external view returns (uint8);
46 }
47 
48 contract ERC20 is Context, IERC20, IERC20Metadata {
49     mapping(address => uint256) private _balances;
50 
51     mapping(address => mapping(address => uint256)) private _allowances;
52 
53     uint256 private _totalSupply;
54 
55     string private _name;
56     string private _symbol;
57 
58     constructor(string memory name_, string memory symbol_) {
59         _name = name_;
60         _symbol = symbol_;
61     }
62 
63     function name() public view virtual override returns (string memory) {
64         return _name;
65     }
66 
67     function symbol() public view virtual override returns (string memory) {
68         return _symbol;
69     }
70 
71     function decimals() public view virtual override returns (uint8) {
72         return 18;
73     }
74 
75     function totalSupply() public view virtual override returns (uint256) {
76         return _totalSupply;
77     }
78 
79     function balanceOf(address account) public view virtual override returns (uint256) {
80         return _balances[account];
81     }
82 
83     function transfer(address to, uint256 amount) public virtual override returns (bool) {
84         address owner = _msgSender();
85         _transfer(owner, to, amount);
86         return true;
87     }
88 
89     function allowance(address owner, address spender) public view virtual override returns (uint256) {
90         return _allowances[owner][spender];
91     }
92 
93     function approve(address spender, uint256 amount) public virtual override returns (bool) {
94         address owner = _msgSender();
95         _approve(owner, spender, amount);
96         return true;
97     }
98 
99     function transferFrom(
100         address from,
101         address to,
102         uint256 amount
103     ) public virtual override returns (bool) {
104         address spender = _msgSender();
105         _spendAllowance(from, spender, amount);
106         _transfer(from, to, amount);
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
111         address owner = _msgSender();
112         _approve(owner, spender, allowance(owner, spender) + addedValue);
113         return true;
114     }
115 
116     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
117         address owner = _msgSender();
118         uint256 currentAllowance = allowance(owner, spender);
119         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
120         unchecked {
121             _approve(owner, spender, currentAllowance - subtractedValue);
122         }
123 
124         return true;
125     }
126 
127     function _transfer(
128         address from,
129         address to,
130         uint256 amount
131     ) internal virtual {
132         require(from != address(0), "ERC20: transfer from the zero address");
133         require(to != address(0), "ERC20: transfer to the zero address");
134 
135         uint256 fromBalance = _balances[from];
136         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
137         unchecked {
138             _balances[from] = fromBalance - amount;
139             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
140             // decrementing then incrementing.
141             _balances[to] += amount;
142         }
143 
144         emit Transfer(from, to, amount);
145     }
146 
147     function _mint(address account, uint256 amount) internal virtual {
148         require(account != address(0), "ERC20: mint to the zero address");
149 
150         _totalSupply += amount;
151         unchecked {
152             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
153             _balances[account] += amount;
154         }
155         emit Transfer(address(0), account, amount);
156     }
157 
158     function _approve(
159         address owner,
160         address spender,
161         uint256 amount
162     ) internal virtual {
163         require(owner != address(0), "ERC20: approve from the zero address");
164         require(spender != address(0), "ERC20: approve to the zero address");
165 
166         _allowances[owner][spender] = amount;
167         emit Approval(owner, spender, amount);
168     }
169 
170     function _spendAllowance(
171         address owner,
172         address spender,
173         uint256 amount
174     ) internal virtual {
175         uint256 currentAllowance = allowance(owner, spender);
176         if (currentAllowance != type(uint256).max) {
177             require(currentAllowance >= amount, "ERC20: insufficient allowance");
178             unchecked {
179                 _approve(owner, spender, currentAllowance - amount);
180             }
181         }
182     }
183 }
184 
185 contract HarodlThePainCoin is ERC20 {
186     constructor() ERC20("PAIN", "PAIN") {
187         _mint(msg.sender, 420690000000000 * 10 ** decimals());
188     }
189 }