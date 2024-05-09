1 // SPDX-License-Identifier: MIT
2 // The BluiCoin, a meme coin. See https://blui.io/ and https://remelife.io/
3 // Issues one trillion BLUI
4 // File: BluiCoin.sol
5 // File: @openzeppelin/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 pragma solidity ^0.8.0;
21 
22 interface IERC20 {
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     function totalSupply() external view returns (uint256);
28 
29     function balanceOf(address account) external view returns (uint256);
30 
31     function transfer(address to, uint256 amount) external returns (bool);
32  
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(address from, address to, uint256 amount) external returns (bool);
38 }
39 
40 
41 pragma solidity ^0.8.0;
42 
43 interface IERC20Metadata is IERC20 {
44 
45     function name() external view returns (string memory);
46 
47     function symbol() external view returns (string memory);
48 
49     function decimals() external view returns (uint8);
50 }
51 
52 pragma solidity ^0.8.0;
53 
54 
55 contract ERC20 is Context, IERC20, IERC20Metadata {
56     mapping(address => uint256) private _balances;
57 
58     mapping(address => mapping(address => uint256)) private _allowances;
59 
60     uint256 private _totalSupply;
61 
62     string private _name;
63     string private _symbol;
64 
65     constructor(string memory name_, string memory symbol_) {
66         _name = name_;
67         _symbol = symbol_;
68     }
69 
70     function name() public view virtual override returns (string memory) {
71         return _name;
72     }
73 
74     function symbol() public view virtual override returns (string memory) {
75         return _symbol;
76     }
77 
78     function decimals() public view virtual override returns (uint8) {
79         return 18;
80     }
81 
82     function totalSupply() public view virtual override returns (uint256) {
83         return _totalSupply;
84     }
85 
86     function balanceOf(address account) public view virtual override returns (uint256) {
87         return _balances[account];
88     }
89 
90     function transfer(address to, uint256 amount) public virtual override returns (bool) {
91         address owner = _msgSender();
92         _transfer(owner, to, amount);
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
106     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
107         address spender = _msgSender();
108         _spendAllowance(from, spender, amount);
109         _transfer(from, to, amount);
110         return true;
111     }
112 
113     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
114         address owner = _msgSender();
115         _approve(owner, spender, allowance(owner, spender) + addedValue);
116         return true;
117     }
118 
119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
120         address owner = _msgSender();
121         uint256 currentAllowance = allowance(owner, spender);
122         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
123         unchecked {
124             _approve(owner, spender, currentAllowance - subtractedValue);
125         }
126 
127         return true;
128     }
129 
130     function _transfer(address from, address to, uint256 amount) internal virtual {
131         require(from != address(0), "ERC20: transfer from the zero address");
132         require(to != address(0), "ERC20: transfer to the zero address");
133 
134         _beforeTokenTransfer(from, to, amount);
135 
136         uint256 fromBalance = _balances[from];
137         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
138         unchecked {
139             _balances[from] = fromBalance - amount;
140             _balances[to] += amount;
141         }
142 
143         emit Transfer(from, to, amount);
144 
145         _afterTokenTransfer(from, to, amount);
146     }
147 
148     function _mint(address account, uint256 amount) internal virtual {
149         require(account != address(0), "ERC20: mint to the zero address");
150 
151         _beforeTokenTransfer(address(0), account, amount);
152 
153         _totalSupply += amount;
154         unchecked {
155             _balances[account] += amount;
156         }
157         emit Transfer(address(0), account, amount);
158 
159         _afterTokenTransfer(address(0), account, amount);
160     }
161 
162     function _burn(address account, uint256 amount) internal virtual {
163         require(account != address(0), "ERC20: burn from the zero address");
164 
165         _beforeTokenTransfer(account, address(0), amount);
166 
167         uint256 accountBalance = _balances[account];
168         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
169         unchecked {
170             _balances[account] = accountBalance - amount;
171             _totalSupply -= amount;
172         }
173 
174         emit Transfer(account, address(0), amount);
175 
176         _afterTokenTransfer(account, address(0), amount);
177     }
178 
179     function _approve(address owner, address spender, uint256 amount) internal virtual {
180         require(owner != address(0), "ERC20: approve from the zero address");
181         require(spender != address(0), "ERC20: approve to the zero address");
182 
183         _allowances[owner][spender] = amount;
184         emit Approval(owner, spender, amount);
185     }
186 
187     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
188         uint256 currentAllowance = allowance(owner, spender);
189         if (currentAllowance != type(uint256).max) {
190             require(currentAllowance >= amount, "ERC20: insufficient allowance");
191             unchecked {
192                 _approve(owner, spender, currentAllowance - amount);
193             }
194         }
195     }
196 
197     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
198 
199     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
200 }
201 
202 
203 pragma solidity ^0.8.0;
204 
205 
206 abstract contract ERC20Burnable is Context, ERC20 {
207 
208     function burn(uint256 amount) public virtual {
209         _burn(_msgSender(), amount);
210     }
211 
212     function burnFrom(address account, uint256 amount) public virtual {
213         _spendAllowance(account, _msgSender(), amount);
214         _burn(account, amount);
215     }
216 }
217 
218 
219 pragma solidity ^0.8.9;
220 
221 
222 
223 contract BLUICOIN is ERC20, ERC20Burnable {
224     constructor() ERC20("BluiCoin", "BLUI") {
225         _mint(msg.sender, 1000000000000000 * 10 ** decimals());
226     }
227 }