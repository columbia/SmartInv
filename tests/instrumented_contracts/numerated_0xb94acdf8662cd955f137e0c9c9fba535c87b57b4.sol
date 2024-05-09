1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 interface IERC20 {
6 
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount) external returns (bool);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function approve(address spender, uint256 amount) external returns (bool);
16 
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 interface IERC20Metadata is IERC20 {
25    
26     function name() external view returns (string memory);
27 
28     function symbol() external view returns (string memory);
29 
30     function decimals() external view returns (uint8);
31 }
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () {
53         address msgSender = _msgSender();
54         _owner = msg.sender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74 
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 }
81 /**
82 Token Name: MONA TOKEN
83 Max Total Supply: 100,000,000,000,000
84 Decimals: 18
85 Symbol: Lisa
86 Chain: Ethereum
87 */
88 
89 contract MONATOKEN is Context, IERC20, IERC20Metadata, Ownable{
90     mapping (address => uint256) private _balances;
91 
92     mapping (address => mapping (address => uint256)) private _allowances;
93 
94     uint256 private _totalSupply;
95 
96     string private _name;
97     string private _symbol;
98 
99     constructor () {
100         _name = "MONA TOKEN"; 
101         _symbol = "Lisa";
102         _totalSupply;
103         _mint(owner(), 100_000_000_000_000 ether );
104     }
105     
106     function name() public view virtual override returns (string memory) {
107         return _name;
108     }
109 
110     function symbol() public view virtual override returns (string memory) {
111         return _symbol;
112     }
113 
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117 
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     function balanceOf(address account) public view virtual override returns (uint256) {
123         return _balances[account];
124     }
125 
126     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
127         _transfer(_msgSender(), recipient, amount);
128         return true;
129     }
130 
131     function allowance(address owner, address spender) public view virtual override returns (uint256) {
132         return _allowances[owner][spender];
133     }
134 
135     function approve(address spender, uint256 amount) public virtual override returns (bool) {
136         _approve(_msgSender(), spender, amount);
137         return true;
138     }
139 
140     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
141         _transfer(sender, recipient, amount);
142 
143         uint256 currentAllowance = _allowances[sender][_msgSender()];
144         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
145         _approve(sender, _msgSender(), currentAllowance - amount);
146 
147         return true;
148     }
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
152         return true;
153     }
154 
155     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
156         uint256 currentAllowance = _allowances[_msgSender()][spender];
157         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
158         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
159 
160         return true;
161     }
162 
163     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
164         require(sender != address(0), "ERC2020: transfer from the zero address");
165         require(recipient != address(0), "ERC20: transfer to the zero address");
166 
167         _beforeTokenTransfer(sender, recipient, amount);
168 
169         uint256 senderBalance = _balances[sender];
170         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
171         _balances[sender] = senderBalance - amount;
172         _balances[recipient] += amount;
173 
174         emit Transfer(sender, recipient, amount);
175     }
176 
177     function _mint(address account, uint256 amount) internal virtual {
178         require(account != address(0), "ERC20: mint to the zero address");
179 
180         _beforeTokenTransfer(address(0), account, amount);
181 
182         _totalSupply += amount;
183         _balances[account] += amount;
184         emit Transfer(address(0), account, amount);
185     }
186 
187     function _burn(address account, uint256 amount) internal virtual {
188         require(account != address(0), "ERC20: burn from the zero address");
189 
190         _beforeTokenTransfer(account, address(0), amount);
191 
192         uint256 accountBalance = _balances[account];
193         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
194         _balances[account] = accountBalance - amount;
195         _totalSupply -= amount;
196 
197         emit Transfer(account, address(0), amount);
198     }
199 
200     function burn(uint256 amount) public onlyOwner {
201         _burn(msg.sender, amount);
202     }
203     
204     function _approve(address owner, address spender, uint256 amount) internal virtual {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207 
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
213 }