1 pragma solidity ^0.8.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 pragma solidity ^0.8.0;
14 
15 interface IERC20 {
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address to, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address from,
32         address to,
33         uint256 amount
34     ) external returns (bool);
35 }
36 pragma solidity ^0.8.0;
37 
38 interface IERC20Metadata is IERC20 {
39     function name() external view returns (string memory);
40 
41     function symbol() external view returns (string memory);
42 
43     function decimals() external view returns (uint8);
44 }
45 
46 pragma solidity ^0.8.0;
47 
48 
49 contract ERC20 is Context, IERC20, IERC20Metadata {
50     mapping(address => uint256) private _balances;
51 
52     mapping(address => mapping(address => uint256)) private _allowances;
53 
54     uint256 private _totalSupply;
55 
56     string private _name;
57     string private _symbol;
58 
59     constructor(string memory name_, string memory symbol_, uint256 initSupply) {
60         _name = name_;
61         _symbol = symbol_;
62         _mint(msg.sender, initSupply);
63     }
64 
65     function name() public view virtual override returns (string memory) {
66         return _name;
67     }
68 
69     function symbol() public view virtual override returns (string memory) {
70         return _symbol;
71     }
72 
73     function decimals() public view virtual override returns (uint8) {
74         return 18;
75     }
76 
77     function totalSupply() public view virtual override returns (uint256) {
78         return _totalSupply;
79     }
80 
81     function balanceOf(address account) public view virtual override returns (uint256) {
82         return _balances[account];
83     }
84 
85     function transfer(address to, uint256 amount) public virtual override returns (bool) {
86         address owner = _msgSender();
87         _transfer(owner, to, amount);
88         return true;
89     }
90 
91     function allowance(address owner, address spender) public view virtual override returns (uint256) {
92         return _allowances[owner][spender];
93     }
94 
95     function approve(address spender, uint256 amount) public virtual override returns (bool) {
96         address owner = _msgSender();
97         _approve(owner, spender, amount);
98         return true;
99     }
100 
101     function transferFrom(
102         address from,
103         address to,
104         uint256 amount
105     ) public virtual override returns (bool) {
106         address spender = _msgSender();
107         _spendAllowance(from, spender, amount);
108         _transfer(from, to, amount);
109         return true;
110     }
111 
112     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
113         address owner = _msgSender();
114         _approve(owner, spender, allowance(owner, spender) + addedValue);
115         return true;
116     }
117 
118     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
119         address owner = _msgSender();
120         uint256 currentAllowance = allowance(owner, spender);
121         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
122         unchecked {
123             _approve(owner, spender, currentAllowance - subtractedValue);
124         }
125 
126         return true;
127     }
128 
129     function _transfer(
130         address from,
131         address to,
132         uint256 amount
133     ) internal virtual {
134         require(from != address(0), "ERC20: transfer from the zero address");
135         require(to != address(0), "ERC20: transfer to the zero address");
136 
137         _beforeTokenTransfer(from, to, amount);
138 
139         uint256 fromBalance = _balances[from];
140         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
141         unchecked {
142             _balances[from] = fromBalance - amount;
143             _balances[to] += amount;
144         }
145 
146         emit Transfer(from, to, amount);
147 
148         _afterTokenTransfer(from, to, amount);
149     }
150 
151     function _mint(address account, uint256 amount) internal virtual {
152         require(account != address(0), "ERC20: mint to the zero address");
153 
154         _beforeTokenTransfer(address(0), account, amount);
155 
156         _totalSupply += amount;
157         unchecked {
158             _balances[account] += amount;
159         }
160         emit Transfer(address(0), account, amount);
161 
162         _afterTokenTransfer(address(0), account, amount);
163     }
164 
165     function _burn(address account, uint256 amount) internal virtual {
166         require(account != address(0), "ERC20: burn from the zero address");
167 
168         _beforeTokenTransfer(account, address(0), amount);
169 
170         uint256 accountBalance = _balances[account];
171         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
172         unchecked {
173             _balances[account] = accountBalance - amount;
174             // Overflow not possible: amount <= accountBalance <= totalSupply.
175             _totalSupply -= amount;
176         }
177 
178         emit Transfer(account, address(0), amount);
179 
180         _afterTokenTransfer(account, address(0), amount);
181     }
182 
183     function _approve(
184         address owner,
185         address spender,
186         uint256 amount
187     ) internal virtual {
188         require(owner != address(0), "ERC20: approve from the zero address");
189         require(spender != address(0), "ERC20: approve to the zero address");
190 
191         _allowances[owner][spender] = amount;
192         emit Approval(owner, spender, amount);
193     }
194 
195     function _spendAllowance(
196         address owner,
197         address spender,
198         uint256 amount
199     ) internal virtual {
200         uint256 currentAllowance = allowance(owner, spender);
201         if (currentAllowance != type(uint256).max) {
202             require(currentAllowance >= amount, "ERC20: insufficient allowance");
203             unchecked {
204                 _approve(owner, spender, currentAllowance - amount);
205             }
206         }
207     }
208 
209     function _beforeTokenTransfer(
210         address from,
211         address to,
212         uint256 amount
213     ) internal virtual {}
214 
215     function _afterTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 }