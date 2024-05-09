1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(
12         address sender,
13         address recipient,
14         uint256 amount
15     ) external returns (bool);
16    
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface IERC20Metadata is IERC20 {
22     function name() external view returns (string memory);
23     function symbol() external view returns (string memory);
24     function decimals() external view returns (uint8);
25 }
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 contract ERC20 is Context, IERC20, IERC20Metadata {
39     mapping(address => uint256) private _balances;
40 
41     mapping(address => mapping(address => uint256)) private _allowances;
42 
43     uint256 private _totalSupply;
44 
45     string private _name;
46     string private _symbol;
47 
48     constructor(string memory name_, string memory symbol_) {
49         _name = name_;
50         _symbol = symbol_;
51     }
52 
53     function name() public view virtual override returns (string memory) {
54         return _name;
55     }
56 
57     function symbol() public view virtual override returns (string memory) {
58         return _symbol;
59     }
60 
61     function decimals() public view virtual override returns (uint8) {
62         return 18;
63     }
64 
65     function totalSupply() public view virtual override returns (uint256) {
66         return _totalSupply;
67     }
68 
69     function balanceOf(address account) public view virtual override returns (uint256) {
70         return _balances[account];
71     }
72 
73     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
74         _transfer(_msgSender(), recipient, amount);
75         return true;
76     }
77 
78     function allowance(address owner, address spender) public view virtual override returns (uint256) {
79         return _allowances[owner][spender];
80     }
81 
82     function approve(address spender, uint256 amount) public virtual override returns (bool) {
83         _approve(_msgSender(), spender, amount);
84         return true;
85     }
86 
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) public virtual override returns (bool) {
92         uint256 currentAllowance = _allowances[sender][_msgSender()];
93         if (currentAllowance != type(uint256).max) {
94             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
95             unchecked {
96                 _approve(sender, _msgSender(), currentAllowance - amount);
97             }
98         }
99 
100         _transfer(sender, recipient, amount);
101 
102         return true;
103     }
104 
105     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
106         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
107         return true;
108     }
109 
110     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
111         uint256 currentAllowance = _allowances[_msgSender()][spender];
112         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
113         unchecked {
114             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
115         }
116 
117         return true;
118     }
119 
120     function _transfer(
121         address sender,
122         address recipient,
123         uint256 amount
124     ) internal virtual {
125         require(sender != address(0), "ERC20: transfer from the zero address");
126         require(recipient != address(0), "ERC20: transfer to the zero address");
127 
128         _beforeTokenTransfer(sender, recipient, amount);
129 
130         uint256 senderBalance = _balances[sender];
131         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
132         unchecked {
133             _balances[sender] = senderBalance - amount;
134         }
135         _balances[recipient] += amount;
136 
137         emit Transfer(sender, recipient, amount);
138 
139         _afterTokenTransfer(sender, recipient, amount);
140     }
141 
142     function _mint(address account, uint256 amount) internal virtual {
143         require(account != address(0), "ERC20: mint to the zero address");
144 
145         _beforeTokenTransfer(address(0), account, amount);
146 
147         _totalSupply += amount;
148         _balances[account] += amount;
149         emit Transfer(address(0), account, amount);
150 
151         _afterTokenTransfer(address(0), account, amount);
152     }
153 
154     function _burn(address account, uint256 amount) internal virtual {
155         require(account != address(0), "ERC20: burn from the zero address");
156 
157         _beforeTokenTransfer(account, address(0), amount);
158 
159         uint256 accountBalance = _balances[account];
160         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
161         unchecked {
162             _balances[account] = accountBalance - amount;
163         }
164         _totalSupply -= amount;
165 
166         emit Transfer(account, address(0), amount);
167 
168         _afterTokenTransfer(account, address(0), amount);
169     }
170 
171     function _approve(
172         address owner,
173         address spender,
174         uint256 amount
175     ) internal virtual {
176         require(owner != address(0), "ERC20: approve from the zero address");
177         require(spender != address(0), "ERC20: approve to the zero address");
178 
179         _allowances[owner][spender] = amount;
180         emit Approval(owner, spender, amount);
181     }
182 
183     function _beforeTokenTransfer(
184         address from,
185         address to,
186         uint256 amount
187     ) internal virtual {}
188 
189     function _afterTokenTransfer(
190         address from,
191         address to,
192         uint256 amount
193     ) internal virtual {}
194 }
195 
196 contract AlveyChainToken is ERC20 {
197     constructor () ERC20("Alvey Chain", "wALV") 
198     {    
199         _mint(msg.sender, 160_000_000 * (10 ** 18));
200     }
201 }