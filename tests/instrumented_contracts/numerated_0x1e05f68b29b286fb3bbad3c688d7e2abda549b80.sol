1 pragma solidity ^0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount)
9         external
10         returns (bool);
11 
12     function allowance(address owner, address spender)
13         external
14         view
15         returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 }
32 pragma solidity ^0.8.0;
33 
34 interface IERC20Metadata is IERC20 {
35     function name() external view returns (string memory);
36 
37     function symbol() external view returns (string memory);
38 
39     function decimals() external view returns (uint8);
40 }
41 pragma solidity ^0.8.0;
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 pragma solidity ^0.8.0;
53 
54 contract ERC20 is Context, IERC20, IERC20Metadata {
55     mapping(address => uint256) private _balances;
56     mapping(address => mapping(address => uint256)) private _allowances;
57     uint256 private _totalSupply;
58     string private _name;
59     string private _symbol;
60 
61     constructor(string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65 
66     function name() public view virtual override returns (string memory) {
67         return _name;
68     }
69 
70     function symbol() public view virtual override returns (string memory) {
71         return _symbol;
72     }
73 
74     function decimals() public view virtual override returns (uint8) {
75         return 18;
76     }
77 
78     function totalSupply() public view virtual override returns (uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account)
83         public
84         view
85         virtual
86         override
87         returns (uint256)
88     {
89         return _balances[account];
90     }
91 
92     function transfer(address recipient, uint256 amount)
93         public
94         virtual
95         override
96         returns (bool)
97     {
98         _transfer(_msgSender(), recipient, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender)
103         public
104         view
105         virtual
106         override
107         returns (uint256)
108     {
109         return _allowances[owner][spender];
110     }
111 
112     function approve(address spender, uint256 amount)
113         public
114         virtual
115         override
116         returns (bool)
117     {
118         _approve(_msgSender(), spender, amount);
119         return true;
120     }
121 
122     function transferFrom(
123         address sender,
124         address recipient,
125         uint256 amount
126     ) public virtual override returns (bool) {
127         _transfer(sender, recipient, amount);
128         uint256 currentAllowance = _allowances[sender][_msgSender()];
129         require(
130             currentAllowance >= amount,
131             "ERC20: transfer amount exceeds allowance"
132         );
133         unchecked {
134             _approve(sender, _msgSender(), currentAllowance - amount);
135         }
136         return true;
137     }
138 
139     function increaseAllowance(address spender, uint256 addedValue)
140         public
141         virtual
142         returns (bool)
143     {
144         _approve(
145             _msgSender(),
146             spender,
147             _allowances[_msgSender()][spender] + addedValue
148         );
149         return true;
150     }
151 
152     function decreaseAllowance(address spender, uint256 subtractedValue)
153         public
154         virtual
155         returns (bool)
156     {
157         uint256 currentAllowance = _allowances[_msgSender()][spender];
158         require(
159             currentAllowance >= subtractedValue,
160             "ERC20: decreased allowance below zero"
161         );
162         unchecked {
163             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
164         }
165         return true;
166     }
167 
168     function _transfer(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) internal virtual {
173         require(sender != address(0), "ERC20: transfer from the zero address");
174         require(recipient != address(0), "ERC20: transfer to the zero address");
175         _beforeTokenTransfer(sender, recipient, amount);
176         uint256 senderBalance = _balances[sender];
177         require(
178             senderBalance >= amount,
179             "ERC20: transfer amount exceeds balance"
180         );
181         unchecked {
182             _balances[sender] = senderBalance - amount;
183         }
184         _balances[recipient] += amount;
185         emit Transfer(sender, recipient, amount);
186         _afterTokenTransfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191         _beforeTokenTransfer(address(0), account, amount);
192         _totalSupply += amount;
193         _balances[account] += amount;
194         emit Transfer(address(0), account, amount);
195         _afterTokenTransfer(address(0), account, amount);
196     }
197 
198     function _burn(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: burn from the zero address");
200         _beforeTokenTransfer(account, address(0), amount);
201         uint256 accountBalance = _balances[account];
202         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
203         unchecked {
204             _balances[account] = accountBalance - amount;
205         }
206         _totalSupply -= amount;
207         emit Transfer(account, address(0), amount);
208         _afterTokenTransfer(account, address(0), amount);
209     }
210 
211     function _approve(
212         address owner,
213         address spender,
214         uint256 amount
215     ) internal virtual {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _beforeTokenTransfer(
223         address from,
224         address to,
225         uint256 amount
226     ) internal virtual {}
227 
228     function _afterTokenTransfer(
229         address from,
230         address to,
231         uint256 amount
232     ) internal virtual {}
233 }
234 pragma solidity 0.8.4;
235 
236 contract PicipoToken is ERC20 {
237     uint256 private immutable _cap;
238 
239     constructor(uint256 cap_) ERC20("PICIPO", "PICIPO") {
240         require(cap_ > 0, "ERC20Capped: cap is 0");
241         _cap = cap_;
242         _mint(msg.sender, cap_);
243     }
244 
245     function _mint(address account, uint256 amount) internal virtual override {
246         require(
247             ERC20.totalSupply() + amount <= 100000000000000000000000000,
248             "ERC20Capped: cap exceeded"
249         );
250         super._mint(account, amount);
251     }
252 }