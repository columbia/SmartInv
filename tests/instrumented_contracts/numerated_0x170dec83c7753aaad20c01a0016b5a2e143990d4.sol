1 // https://wiggercoin.com/
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 pragma solidity ^0.8.21;
16 interface IERC20 {
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address to, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(
25         address from,
26         address to,
27         uint256 amount
28     ) external returns (bool);
29 }
30 
31 
32 pragma solidity ^0.8.21;
33 interface IERC20Metadata is IERC20 {
34     function name() external view returns (string memory);
35     function symbol() external view returns (string memory);
36     function decimals() external view returns (uint8);
37 }
38 
39 pragma solidity ^0.8.21;
40 contract ERC20 is Context, IERC20, IERC20Metadata {
41     mapping(address => uint256) private _balances;
42 
43     mapping(address => mapping(address => uint256)) private _allowances;
44 
45     uint256 private _totalSupply;
46 
47     string private _name;
48     string private _symbol;
49 
50     constructor(string memory name_, string memory symbol_) {
51         _name = name_;
52         _symbol = symbol_;
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
63   
64     function decimals() public view virtual override returns (uint8) {
65         return 18;
66     }
67 
68     function totalSupply() public view virtual override returns (uint256) {
69         return _totalSupply;
70     }
71 
72     function balanceOf(address account) public view virtual override returns (uint256) {
73         return _balances[account];
74     }
75 
76     function transfer(address to, uint256 amount) public virtual override returns (bool) {
77         address owner = _msgSender();
78         _transfer(owner, to, amount);
79         
80         return true;
81     }
82 
83     function allowance(address owner, address spender) public view virtual override returns (uint256) {
84         return _allowances[owner][spender];
85     }
86 
87     function approve(address spender, uint256 amount) public virtual override returns (bool) {
88         address owner = _msgSender();
89         _approve(owner, spender, amount);
90         return true;
91     }
92 
93     function transferFrom(
94         address from,
95         address to,
96         uint256 amount
97         
98     ) public virtual override returns (bool) {
99         
100         address spender = _msgSender();
101         _spendAllowance(from, spender, amount);
102         _transfer(from, to, amount);
103         return true;
104     }
105 
106     
107     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
108         address owner = _msgSender();
109         _approve(owner, spender, allowance(owner, spender) + addedValue);
110         return true;
111     }
112 
113     
114     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
115         address owner = _msgSender();
116         uint256 currentAllowance = allowance(owner, spender);
117         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
118         unchecked {
119             _approve(owner, spender, currentAllowance - subtractedValue);
120         }
121 
122         return true;
123     }
124 
125     function _transfer(
126         address from,
127         address to,
128         uint256 amount
129     ) internal virtual {
130         require(from != address(0), "ERC20: transfer from the zero address");
131         require(to != address(0), "ERC20: transfer to the zero address");
132         
133         _beforeTokenTransfer(from, to, amount);
134 
135         uint256 fromBalance = _balances[from];
136         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
137         unchecked {
138             _balances[from] = fromBalance - amount;
139             _balances[to] += amount;
140         }
141 
142         emit Transfer(from, to, amount);
143 
144         _afterTokenTransfer(from, to, amount);
145     }
146 
147     function _mint(address account, uint256 amount) internal virtual {
148         require(account != address(0), "ERC20: mint to the zero address");
149 
150         _beforeTokenTransfer(address(0), account, amount);
151 
152         _totalSupply += amount;
153         unchecked {
154             _balances[account] += amount;
155         }
156         emit Transfer(address(0), account, amount);
157 
158         _afterTokenTransfer(address(0), account, amount);
159     }
160 
161     function _approve(
162         address owner,
163         address spender,
164         uint256 amount
165     ) internal virtual {
166         require(owner != address(0), "ERC20: approve from the zero address");
167         require(spender != address(0), "ERC20: approve to the zero address");
168 
169         _allowances[owner][spender] = amount;
170         emit Approval(owner, spender, amount);
171     }
172 
173     function _spendAllowance(
174         address owner,
175         address spender,
176         uint256 amount
177     ) internal virtual {
178         uint256 currentAllowance = allowance(owner, spender);
179         if (currentAllowance != type(uint256).max) {
180             require(currentAllowance >= amount, "ERC20: insufficient allowance");
181             unchecked {
182                 _approve(owner, spender, currentAllowance - amount);
183             }
184         }
185     }
186 
187     function _beforeTokenTransfer(
188         address from,
189         address to,
190         uint256 amount
191     ) internal virtual {}
192 
193    
194     function _afterTokenTransfer(
195         address from,
196         address to,
197         uint256 amount
198     ) internal virtual {}
199 }
200 
201 pragma solidity ^0.8.21;
202 contract WIGGER is ERC20 {
203     constructor() ERC20("WIGGER COIN", "WIGGER") {
204 
205         _mint(msg.sender, 1000000000 * 10 ** decimals());
206     }
207 }