1 // https://www.pog-token.com/
2 // https://t.me/pogtoken
3 
4 pragma solidity ^0.8.0;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 pragma solidity ^0.8.0;
17 
18 interface IERC20 {
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     function totalSupply() external view returns (uint256);
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(address to, uint256 amount) external returns (bool);
28 
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address from,
35         address to,
36         uint256 amount
37     ) external returns (bool);
38 }
39 
40 pragma solidity ^0.8.0;
41 
42 interface IERC20Metadata is IERC20 {
43 
44     function name() external view returns (string memory);
45 
46     function symbol() external view returns (string memory);
47 
48     function decimals() external view returns (uint8);
49 }
50 
51 pragma solidity ^0.8.0;
52 
53 contract ERC20 is Context, IERC20, IERC20Metadata {
54     mapping(address => uint256) private _balances;
55 
56     mapping(address => mapping(address => uint256)) private _allowances;
57 
58     uint256 private _totalSupply;
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
76     function decimals() public view virtual override returns (uint8) {
77         return 18;
78     }
79 
80     function totalSupply() public view virtual override returns (uint256) {
81         return _totalSupply;
82     }
83 
84     function balanceOf(address account) public view virtual override returns (uint256) {
85         return _balances[account];
86     }
87 
88     function transfer(address to, uint256 amount) public virtual override returns (bool) {
89         address owner = _msgSender();
90         _transfer(owner, to, amount);
91         return true;
92     }
93 
94     function allowance(address owner, address spender) public view virtual override returns (uint256) {
95         return _allowances[owner][spender];
96     }
97 
98     function approve(address spender, uint256 amount) public virtual override returns (bool) {
99         address owner = _msgSender();
100         _approve(owner, spender, amount);
101         return true;
102     }
103 
104     function transferFrom(
105         address from,
106         address to,
107         uint256 amount
108     ) public virtual override returns (bool) {
109         address spender = _msgSender();
110         _spendAllowance(from, spender, amount);
111         _transfer(from, to, amount);
112         return true;
113     }
114 
115     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
116         address owner = _msgSender();
117         _approve(owner, spender, allowance(owner, spender) + addedValue);
118         return true;
119     }
120 
121     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
122         address owner = _msgSender();
123         uint256 currentAllowance = allowance(owner, spender);
124         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
125         unchecked {
126             _approve(owner, spender, currentAllowance - subtractedValue);
127         }
128 
129         return true;
130     }
131 
132     function _transfer(
133         address from,
134         address to,
135         uint256 amount
136     ) internal virtual {
137         require(from != address(0), "ERC20: transfer from the zero address");
138         require(to != address(0), "ERC20: transfer to the zero address");
139 
140         _beforeTokenTransfer(from, to, amount);
141 
142         uint256 fromBalance = _balances[from];
143         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
144         unchecked {
145             _balances[from] = fromBalance - amount;
146             _balances[to] += amount;
147         }
148 
149         emit Transfer(from, to, amount);
150 
151         _afterTokenTransfer(from, to, amount);
152     }
153 
154     function _mint(address account, uint256 amount) internal virtual {
155         require(account != address(0), "ERC20: mint to the zero address");
156 
157         _beforeTokenTransfer(address(0), account, amount);
158 
159         _totalSupply += amount;
160         unchecked {
161             _balances[account] += amount;
162         }
163         emit Transfer(address(0), account, amount);
164 
165         _afterTokenTransfer(address(0), account, amount);
166     }
167 
168     function _burn(address account, uint256 amount) internal virtual {
169         require(account != address(0), "ERC20: burn from the zero address");
170 
171         _beforeTokenTransfer(account, address(0), amount);
172 
173         uint256 accountBalance = _balances[account];
174         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
175         unchecked {
176             _balances[account] = accountBalance - amount;
177             _totalSupply -= amount;
178         }
179 
180         emit Transfer(account, address(0), amount);
181 
182         _afterTokenTransfer(account, address(0), amount);
183     }
184 
185     function _approve(
186         address owner,
187         address spender,
188         uint256 amount
189     ) internal virtual {
190         require(owner != address(0), "ERC20: approve from the zero address");
191         require(spender != address(0), "ERC20: approve to the zero address");
192 
193         _allowances[owner][spender] = amount;
194         emit Approval(owner, spender, amount);
195     }
196 
197     function _spendAllowance(
198         address owner,
199         address spender,
200         uint256 amount
201     ) internal virtual {
202         uint256 currentAllowance = allowance(owner, spender);
203         if (currentAllowance != type(uint256).max) {
204             require(currentAllowance >= amount, "ERC20: insufficient allowance");
205             unchecked {
206                 _approve(owner, spender, currentAllowance - amount);
207             }
208         }
209     }
210 
211     function _beforeTokenTransfer(
212         address from,
213         address to,
214         uint256 amount
215     ) internal virtual {}
216 
217     function _afterTokenTransfer(
218         address from,
219         address to,
220         uint256 amount
221     ) internal virtual {}
222 }
223 
224 pragma solidity ^0.8.9;
225 
226 
227 contract POG is ERC20 {
228     constructor() ERC20("POG", "POG") {
229         _mint(msg.sender, 4206900000 * 10 ** decimals());
230     }
231 }