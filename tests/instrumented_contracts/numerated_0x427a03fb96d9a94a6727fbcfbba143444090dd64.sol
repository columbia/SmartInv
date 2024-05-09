1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19     constructor() {
20         _setOwner(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function _setOwner(address newOwner) private {
33         address oldOwner = _owner;
34         _owner = newOwner;
35         emit OwnershipTransferred(oldOwner, newOwner);
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface IERC20Metadata is IERC20 {
52     function name() external view returns (string memory);
53     function symbol() external view returns (string memory);
54     function decimals() external view returns (uint8);
55 }
56 
57 contract PIXL is Context, IERC20, IERC20Metadata, Ownable {
58     mapping (address => uint256) private _balances;
59     mapping(address => bool) private whitelist;
60     mapping (address => mapping (address => uint256)) private _allowances;
61 
62     uint256 private _totalSupply;
63     string private _name;
64     string private _symbol;
65 
66     constructor () {
67         _name = "PIXL";
68         _symbol = "PIXL";
69     }
70 
71     function name() public view virtual override returns (string memory) {
72         return _name;
73     }
74 
75     function symbol() public view virtual override returns (string memory) {
76         return _symbol;
77     }
78 
79     function decimals() public view virtual override returns (uint8) {
80         return 18;
81     }
82 
83     function totalSupply() public view virtual override returns (uint256) {
84         return _totalSupply;
85     }
86 
87     function balanceOf(address account) public view virtual override returns (uint256) {
88         return _balances[account];
89     }
90 
91     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
92         _transfer(_msgSender(), recipient, amount);
93         return true;
94     }
95 
96     function allowance(address owner, address spender) public view virtual override returns (uint256) {
97         return _allowances[owner][spender];
98     }
99 
100     function approve(address spender, uint256 amount) public virtual override returns (bool) {
101         _approve(_msgSender(), spender, amount);
102         return true;
103     }
104 
105     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(sender, recipient, amount);
107 
108         uint256 currentAllowance = _allowances[sender][_msgSender()];
109         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
110         unchecked {
111             _approve(sender, _msgSender(), currentAllowance - amount);
112         }
113 
114         return true;
115     }
116 
117     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
118         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
119         return true;
120     }
121 
122     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
123         uint256 currentAllowance = _allowances[_msgSender()][spender];
124         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
125         unchecked {
126             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
127         }
128 
129         return true;
130     }
131 
132     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
133         require(sender != address(0), "ERC20: transfer from the zero address");
134         require(recipient != address(0), "ERC20: transfer to the zero address");
135 
136         uint256 senderBalance = _balances[sender];
137         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
138         unchecked {
139             _balances[sender] = senderBalance - amount;
140         }
141         _balances[recipient] += amount;
142 
143         emit Transfer(sender, recipient, amount);
144     }
145 
146     function _mint(address account, uint256 amount) internal virtual {
147         require(account != address(0), "ERC20: mint to the zero address");
148 
149         _totalSupply += amount;
150         _balances[account] += amount;
151         emit Transfer(address(0), account, amount);
152     }
153 
154     function _approve(address owner, address spender, uint256 amount) internal virtual {
155         require(owner != address(0), "ERC20: approve from the zero address");
156         require(spender != address(0), "ERC20: approve to the zero address");
157 
158         _allowances[owner][spender] = amount;
159         emit Approval(owner, spender, amount);
160     }
161 
162     function setWhitelist(address[] calldata minters) external onlyOwner {
163 
164         for (uint256 i; i < minters.length; i++) {
165             whitelist[minters[i]] = true;
166         }
167 
168         // whitelist[address(this)] = true;
169     }
170 
171     function whitelist_mint(address account, uint256 amount) external {
172         require(whitelist[msg.sender], 'ERC20: sender must be whitelisted');
173         _mint(account, amount);
174     }
175 
176     function check_whitelist(address account) public view returns (bool) {
177       return whitelist[account];
178     }
179 
180 }