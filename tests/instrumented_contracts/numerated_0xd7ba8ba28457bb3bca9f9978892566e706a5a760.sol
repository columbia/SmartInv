1 // https://Flork.gg
2 // https://t.me/FlorkOnETH
3 // https://twitter.com/FlorkOnETH
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 pragma solidity ^0.8.21;
18 interface IERC20 {
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address to, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(
27         address from,
28         address to,
29         uint256 amount
30     ) external returns (bool);
31 }
32 
33 
34 pragma solidity ^0.8.21;
35 interface IERC20Metadata is IERC20 {
36     function name() external view returns (string memory);
37     function symbol() external view returns (string memory);
38     function decimals() external view returns (uint8);
39 }
40 
41 pragma solidity ^0.8.21;
42 contract ERC20 is Context, IERC20, IERC20Metadata {
43     mapping(address => uint256) private _balances;
44 
45     mapping(address => mapping(address => uint256)) private _allowances;
46 
47     uint256 private _totalSupply;
48 
49     string private _name;
50     string private _symbol;
51 
52     constructor(string memory name_, string memory symbol_) {
53         _name = name_;
54         _symbol = symbol_;
55     }
56 
57     function name() public view virtual override returns (string memory) {
58         return _name;
59     }
60 
61     function symbol() public view virtual override returns (string memory) {
62         return _symbol;
63     }
64 
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
78     function transfer(address to, uint256 amount) public virtual override returns (bool) {
79         address owner = _msgSender();
80         _transfer(owner, to, amount);
81         
82         return true;
83     }
84 
85     function allowance(address owner, address spender) public view virtual override returns (uint256) {
86         return _allowances[owner][spender];
87     }
88 
89     function approve(address spender, uint256 amount) public virtual override returns (bool) {
90         address owner = _msgSender();
91         _approve(owner, spender, amount);
92         return true;
93     }
94 
95     function transferFrom(
96         address from,
97         address to,
98         uint256 amount
99         
100     ) public virtual override returns (bool) {
101         
102         address spender = _msgSender();
103         _spendAllowance(from, spender, amount);
104         _transfer(from, to, amount);
105         return true;
106     }
107 
108     
109     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
110         address owner = _msgSender();
111         _approve(owner, spender, allowance(owner, spender) + addedValue);
112         return true;
113     }
114 
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
135         _beforeTokenTransfer(from, to, amount);
136 
137         uint256 fromBalance = _balances[from];
138         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
139         unchecked {
140             _balances[from] = fromBalance - amount;
141             _balances[to] += amount;
142         }
143 
144         emit Transfer(from, to, amount);
145 
146         _afterTokenTransfer(from, to, amount);
147     }
148 
149     function _mint(address account, uint256 amount) internal virtual {
150         require(account != address(0), "ERC20: mint to the zero address");
151 
152         _beforeTokenTransfer(address(0), account, amount);
153 
154         _totalSupply += amount;
155         unchecked {
156             _balances[account] += amount;
157         }
158         emit Transfer(address(0), account, amount);
159 
160         _afterTokenTransfer(address(0), account, amount);
161     }
162 
163     function _approve(
164         address owner,
165         address spender,
166         uint256 amount
167     ) internal virtual {
168         require(owner != address(0), "ERC20: approve from the zero address");
169         require(spender != address(0), "ERC20: approve to the zero address");
170 
171         _allowances[owner][spender] = amount;
172         emit Approval(owner, spender, amount);
173     }
174 
175     function _spendAllowance(
176         address owner,
177         address spender,
178         uint256 amount
179     ) internal virtual {
180         uint256 currentAllowance = allowance(owner, spender);
181         if (currentAllowance != type(uint256).max) {
182             require(currentAllowance >= amount, "ERC20: insufficient allowance");
183             unchecked {
184                 _approve(owner, spender, currentAllowance - amount);
185             }
186         }
187     }
188 
189     function _beforeTokenTransfer(
190         address from,
191         address to,
192         uint256 amount
193     ) internal virtual {}
194 
195    
196     function _afterTokenTransfer(
197         address from,
198         address to,
199         uint256 amount
200     ) internal virtual {}
201 }
202 
203 pragma solidity ^0.8.21;
204 contract Flork is ERC20 {
205     constructor() ERC20("Flork", "FLORK") {
206 
207         _mint(msg.sender, 1000000000000 * 10 ** decimals());
208     }
209 }