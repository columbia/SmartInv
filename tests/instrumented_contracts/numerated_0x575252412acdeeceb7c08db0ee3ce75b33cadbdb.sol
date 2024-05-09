1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 pragma solidity ^0.8.0;
15 
16 interface IERC20 {
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address to, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address from,
33         address to,
34         uint256 amount
35     ) external returns (bool);
36 }
37 
38 pragma solidity ^0.8.12;
39 
40 interface IERC20Metadata is IERC20 {
41 
42     function name() external view returns (string memory);
43 
44     function symbol() external view returns (string memory);
45 
46     function decimals() external view returns (uint8);
47 }
48 
49 pragma solidity ^0.8.12;
50 
51 
52 contract ERC20 is Context, IERC20, IERC20Metadata {
53     mapping(address => uint256) private _balances;
54 
55     mapping(address => mapping(address => uint256)) private _allowances;
56 
57     uint256 private _totalSupply;
58 
59 
60     string private _name;
61     string private _symbol;
62 
63     constructor(string memory name_, string memory symbol_) {
64         _name = name_;
65         _symbol = symbol_;
66     }
67 
68     function name() public view virtual override returns (string memory) {
69         return _name;
70     }
71 
72     function symbol() public view virtual override returns (string memory) {
73         return _symbol;
74     }
75 
76   
77     function decimals() public view virtual override returns (uint8) {
78         return 18;
79     }
80 
81     function totalSupply() public view virtual override returns (uint256) {
82         return _totalSupply;
83     }
84 
85     function balanceOf(address account) public view virtual override returns (uint256) {
86         return _balances[account];
87     }
88 
89     function transfer(address to, uint256 amount) public virtual override returns (bool) {
90         address owner = _msgSender();
91         _transfer(owner, to, amount);
92         
93         return true;
94     }
95 
96     function allowance(address owner, address spender) public view virtual override returns (uint256) {
97         return _allowances[owner][spender];
98     }
99 
100     function approve(address spender, uint256 amount) public virtual override returns (bool) {
101         address owner = _msgSender();
102         _approve(owner, spender, amount);
103         return true;
104     }
105 
106     function transferFrom(
107         address from,
108         address to,
109         uint256 amount
110         
111     ) public virtual override returns (bool) {
112         
113         address spender = _msgSender();
114         _spendAllowance(from, spender, amount);
115         _transfer(from, to, amount);
116         return true;
117     }
118 
119     
120     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
121         address owner = _msgSender();
122         _approve(owner, spender, allowance(owner, spender) + addedValue);
123         return true;
124     }
125 
126     
127     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
128         address owner = _msgSender();
129         uint256 currentAllowance = allowance(owner, spender);
130         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
131         unchecked {
132             _approve(owner, spender, currentAllowance - subtractedValue);
133         }
134 
135         return true;
136     }
137 
138     function _transfer(
139         address from,
140         address to,
141         uint256 amount
142     ) internal virtual {
143         require(from != address(0), "ERC20: transfer from the zero address");
144         require(to != address(0), "ERC20: transfer to the zero address");
145         
146         _beforeTokenTransfer(from, to, amount);
147 
148         uint256 fromBalance = _balances[from];
149         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
150         unchecked {
151             _balances[from] = fromBalance - amount;
152             _balances[to] += amount;
153         }
154 
155         emit Transfer(from, to, amount);
156 
157         _afterTokenTransfer(from, to, amount);
158     }
159 
160     function _mint(address account, uint256 amount) internal virtual {
161         require(account != address(0), "ERC20: mint to the zero address");
162 
163         _beforeTokenTransfer(address(0), account, amount);
164 
165         _totalSupply += amount;
166         unchecked {
167             _balances[account] += amount;
168         }
169         emit Transfer(address(0), account, amount);
170 
171         _afterTokenTransfer(address(0), account, amount);
172     }
173 
174     function _burn(address account, uint256 amount) internal virtual {
175         require(account != address(0), "ERC20: burn from the zero address");
176 
177         _beforeTokenTransfer(account, address(0), amount);
178 
179         uint256 accountBalance = _balances[account];
180         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
181         unchecked {
182             _balances[account] = accountBalance - amount;
183             _totalSupply -= amount;
184         }
185 
186         emit Transfer(account, address(0), amount);
187 
188         _afterTokenTransfer(account, address(0), amount);
189     }
190 
191     function _approve(
192         address owner,
193         address spender,
194         uint256 amount
195     ) internal virtual {
196         require(owner != address(0), "ERC20: approve from the zero address");
197         require(spender != address(0), "ERC20: approve to the zero address");
198 
199         _allowances[owner][spender] = amount;
200         emit Approval(owner, spender, amount);
201     }
202 
203     function _spendAllowance(
204         address owner,
205         address spender,
206         uint256 amount
207     ) internal virtual {
208         uint256 currentAllowance = allowance(owner, spender);
209         if (currentAllowance != type(uint256).max) {
210             require(currentAllowance >= amount, "ERC20: insufficient allowance");
211             unchecked {
212                 _approve(owner, spender, currentAllowance - amount);
213             }
214         }
215     }
216 
217     function _beforeTokenTransfer(
218         address from,
219         address to,
220         uint256 amount
221     ) internal virtual {}
222 
223    
224     function _afterTokenTransfer(
225         address from,
226         address to,
227         uint256 amount
228     ) internal virtual {}
229 }
230 
231 pragma solidity ^0.8.12;
232 
233 
234 contract LIL is ERC20 {
235     constructor() ERC20("Lil", "LIL") {
236 
237         _mint(msg.sender, 100000000000 * 10 ** decimals());
238     }
239 }