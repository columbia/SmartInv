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
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.17;
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30    
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 interface IERC20Metadata is IERC20 {
36     function name() external view returns (string memory);
37     function symbol() external view returns (string memory);
38     function decimals() external view returns (uint8);
39 }
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 contract ERC20 is Context, IERC20, IERC20Metadata {
53     mapping(address => uint256) private _balances;
54 
55     mapping(address => mapping(address => uint256)) private _allowances;
56 
57     uint256 private _totalSupply;
58 
59     string private _name;
60     string private _symbol;
61 
62     constructor(string memory name_, string memory symbol_) {
63         _name = name_;
64         _symbol = symbol_;
65     }
66 
67     function name() public view virtual override returns (string memory) {
68         return _name;
69     }
70 
71     function symbol() public view virtual override returns (string memory) {
72         return _symbol;
73     }
74 
75     function decimals() public view virtual override returns (uint8) {
76         return 18;
77     }
78 
79     function totalSupply() public view virtual override returns (uint256) {
80         return _totalSupply;
81     }
82 
83     function balanceOf(address account) public view virtual override returns (uint256) {
84         return _balances[account];
85     }
86 
87     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
88         _transfer(_msgSender(), recipient, amount);
89         return true;
90     }
91 
92     function allowance(address owner, address spender) public view virtual override returns (uint256) {
93         return _allowances[owner][spender];
94     }
95 
96     function approve(address spender, uint256 amount) public virtual override returns (bool) {
97         _approve(_msgSender(), spender, amount);
98         return true;
99     }
100 
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) public virtual override returns (bool) {
106         uint256 currentAllowance = _allowances[sender][_msgSender()];
107         if (currentAllowance != type(uint256).max) {
108             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
109             unchecked {
110                 _approve(sender, _msgSender(), currentAllowance - amount);
111             }
112         }
113 
114         _transfer(sender, recipient, amount);
115 
116         return true;
117     }
118 
119     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
120         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
121         return true;
122     }
123 
124     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
125         uint256 currentAllowance = _allowances[_msgSender()][spender];
126         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
127         unchecked {
128             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
129         }
130 
131         return true;
132     }
133 
134     function _transfer(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) internal virtual {
139         require(sender != address(0), "ERC20: transfer from the zero address");
140         require(recipient != address(0), "ERC20: transfer to the zero address");
141 
142         _beforeTokenTransfer(sender, recipient, amount);
143 
144         uint256 senderBalance = _balances[sender];
145         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
146         unchecked {
147             _balances[sender] = senderBalance - amount;
148         }
149         _balances[recipient] += amount;
150 
151         emit Transfer(sender, recipient, amount);
152 
153         _afterTokenTransfer(sender, recipient, amount);
154     }
155 
156     function _mint(address account, uint256 amount) internal virtual {
157         require(account != address(0), "ERC20: mint to the zero address");
158 
159         _beforeTokenTransfer(address(0), account, amount);
160 
161         _totalSupply += amount;
162         _balances[account] += amount;
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
177         }
178         _totalSupply -= amount;
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
197     function _beforeTokenTransfer(
198         address from,
199         address to,
200         uint256 amount
201     ) internal virtual {}
202 
203     function _afterTokenTransfer(
204         address from,
205         address to,
206         uint256 amount
207     ) internal virtual {}
208 }
209 
210 contract PepeOriginal is ERC20 {
211     constructor () ERC20("Pepe Original Version", "$POV") 
212     {    
213         _mint(msg.sender, 420_690_000_000_000 * (10 ** 18));
214     }
215 }