1 // ░██████╗░█████╗░███████╗██╗░░░██╗  ██████╗░██╗░░░██╗
2 // ██╔════╝██╔══██╗██╔════╝██║░░░██║  ██╔══██╗╚██╗░██╔╝
3 // ╚█████╗░███████║█████╗░░██║░░░██║  ██████╦╝░╚████╔╝░
4 // ░╚═══██╗██╔══██║██╔══╝░░██║░░░██║  ██╔══██╗░░╚██╔╝░░
5 // ██████╔╝██║░░██║██║░░░░░╚██████╔╝  ██████╦╝░░░██║░░░
6 // ╚═════╝░╚═╝░░╚═╝╚═╝░░░░░░╚═════╝░  ╚═════╝░░░░╚═╝░░░
7 
8 // ░█████╗░░█████╗░██╗███╗░░██╗░██████╗██╗░░░██╗██╗░░░░░████████╗░░░███╗░░██╗███████╗████████╗
9 // ██╔══██╗██╔══██╗██║████╗░██║██╔════╝██║░░░██║██║░░░░░╚══██╔══╝░░░████╗░██║██╔════╝╚══██╔══╝
10 // ██║░░╚═╝██║░░██║██║██╔██╗██║╚█████╗░██║░░░██║██║░░░░░░░░██║░░░░░░██╔██╗██║█████╗░░░░░██║░░░
11 // ██║░░██╗██║░░██║██║██║╚████║░╚═══██╗██║░░░██║██║░░░░░░░░██║░░░░░░██║╚████║██╔══╝░░░░░██║░░░
12 // ╚█████╔╝╚█████╔╝██║██║░╚███║██████╔╝╚██████╔╝███████╗░░░██║░░░██╗██║░╚███║███████╗░░░██║░░░
13 // ░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚═╝░░╚══╝╚══════╝░░░╚═╝░░░
14 
15 // Project : TWEETY 
16 // 0%  TAX over every buy/sell 
17     
18 // Website : www.tweety.vip
19 // Telegram: @TweetyCoinOfficial
20 // Twitter : @TweetyCoinETH
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity 0.8.17;
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37    
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 interface IERC20Metadata is IERC20 {
43     function name() external view returns (string memory);
44     function symbol() external view returns (string memory);
45     function decimals() external view returns (uint8);
46 }
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
55         return msg.data;
56     }
57 }
58 
59 contract ERC20 is Context, IERC20, IERC20Metadata {
60     mapping(address => uint256) private _balances;
61 
62     mapping(address => mapping(address => uint256)) private _allowances;
63 
64     uint256 private _totalSupply;
65 
66     string private _name;
67     string private _symbol;
68 
69     constructor(string memory name_, string memory symbol_) {
70         _name = name_;
71         _symbol = symbol_;
72     }
73 
74     function name() public view virtual override returns (string memory) {
75         return _name;
76     }
77 
78     function symbol() public view virtual override returns (string memory) {
79         return _symbol;
80     }
81 
82     function decimals() public view virtual override returns (uint8) {
83         return 9;
84     }
85 
86     function totalSupply() public view virtual override returns (uint256) {
87         return _totalSupply;
88     }
89 
90     function balanceOf(address account) public view virtual override returns (uint256) {
91         return _balances[account];
92     }
93 
94     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
95         _transfer(_msgSender(), recipient, amount);
96         return true;
97     }
98 
99     function allowance(address owner, address spender) public view virtual override returns (uint256) {
100         return _allowances[owner][spender];
101     }
102 
103     function approve(address spender, uint256 amount) public virtual override returns (bool) {
104         _approve(_msgSender(), spender, amount);
105         return true;
106     }
107 
108     function transferFrom(
109         address sender,
110         address recipient,
111         uint256 amount
112     ) public virtual override returns (bool) {
113         uint256 currentAllowance = _allowances[sender][_msgSender()];
114         if (currentAllowance != type(uint256).max) {
115             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
116             unchecked {
117                 _approve(sender, _msgSender(), currentAllowance - amount);
118             }
119         }
120 
121         _transfer(sender, recipient, amount);
122 
123         return true;
124     }
125 
126     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
127         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
128         return true;
129     }
130 
131     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
132         uint256 currentAllowance = _allowances[_msgSender()][spender];
133         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
134         unchecked {
135             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
136         }
137 
138         return true;
139     }
140 
141     function _transfer(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) internal virtual {
146         require(sender != address(0), "ERC20: transfer from the zero address");
147         require(recipient != address(0), "ERC20: transfer to the zero address");
148 
149         _beforeTokenTransfer(sender, recipient, amount);
150 
151         uint256 senderBalance = _balances[sender];
152         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
153         unchecked {
154             _balances[sender] = senderBalance - amount;
155         }
156         _balances[recipient] += amount;
157 
158         emit Transfer(sender, recipient, amount);
159 
160         _afterTokenTransfer(sender, recipient, amount);
161     }
162 
163     function _mint(address account, uint256 amount) internal virtual {
164         require(account != address(0), "ERC20: mint to the zero address");
165 
166         _beforeTokenTransfer(address(0), account, amount);
167 
168         _totalSupply += amount;
169         _balances[account] += amount;
170         emit Transfer(address(0), account, amount);
171 
172         _afterTokenTransfer(address(0), account, amount);
173     }
174 
175     function _burn(address account, uint256 amount) internal virtual {
176         require(account != address(0), "ERC20: burn from the zero address");
177 
178         _beforeTokenTransfer(account, address(0), amount);
179 
180         uint256 accountBalance = _balances[account];
181         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
182         unchecked {
183             _balances[account] = accountBalance - amount;
184         }
185         _totalSupply -= amount;
186 
187         emit Transfer(account, address(0), amount);
188 
189         _afterTokenTransfer(account, address(0), amount);
190     }
191 
192     function _approve(
193         address owner,
194         address spender,
195         uint256 amount
196     ) internal virtual {
197         require(owner != address(0), "ERC20: approve from the zero address");
198         require(spender != address(0), "ERC20: approve to the zero address");
199 
200         _allowances[owner][spender] = amount;
201         emit Approval(owner, spender, amount);
202     }
203 
204     function _beforeTokenTransfer(
205         address from,
206         address to,
207         uint256 amount
208     ) internal virtual {}
209 
210     function _afterTokenTransfer(
211         address from,
212         address to,
213         uint256 amount
214     ) internal virtual {}
215 }
216 
217 contract TWEETY is ERC20 {
218     constructor () ERC20("TWEETY", "TWEETY") {    
219         _mint(msg.sender, 210_000_000_000 * (10 ** 9));
220     }
221 }