1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.7.0 <0.9.0;
3 // Chud Twitter: https://twitter.com/Chudjakcoineth
4 // Chud Telegram: https://t.me/OfficialChudCoin
5 // Chud Website: https://www.mrchud.com/
6 abstract contract Context {
7     function _msgSender() internal view returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this;
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function decimals() external view returns (uint8);
20     function symbol() external view returns (string memory);
21     function name() external view returns (string memory);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address _owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 contract ERC20 is Context, IERC20 {
32     mapping(address => mapping(address => uint256)) private _allowances;
33     mapping(address => uint256) public _balances;
34     mapping(address => bool) liquidityPair;
35     mapping(address => bool) liquidityProvider;
36 
37     uint256 _totalSupply;
38     uint256 public maxWallet;
39     uint256 public maxTransaction;
40     bool limitInPlace;
41     address public ownerWallet;
42 
43     string private _name;
44     string private _symbol;
45 
46     modifier onlyOwner() {
47         require(_msgSender() == ownerWallet, "You are not the owner");
48         _;
49     }
50 
51     constructor(string memory name_, string memory symbol_, uint256 supply) {
52         _name = name_;
53         _symbol = symbol_;
54         _mint(_msgSender(), supply * (10**18));
55 
56         ownerWallet = _msgSender();
57     }
58 
59     receive() external payable {}
60 
61     function name() public view override returns (string memory) {
62         return _name;
63     }
64  
65     function symbol() public view override returns (string memory) {
66         return _symbol;
67     }
68 
69     function decimals() public pure override returns (uint8) {
70         return 18;
71     }
72 
73     function totalSupply() public view override returns (uint256) {
74         return _totalSupply;
75     }
76 
77     function balanceOf(address account) public view override returns (uint256) {
78         return _balances[account];
79     }
80 
81     function transfer(address to, uint256 amount) public override returns (bool) {
82         address owner = _msgSender();
83         _transfer(owner, to, amount);
84         return true;
85     }
86 
87     function allowance(address owner, address spender) public view override returns (uint256) {
88         return _allowances[owner][spender];
89     }
90 
91     function approve(address spender, uint256 amount) public override returns (bool) {
92         address owner = _msgSender();
93         _approve(owner, spender, amount);
94         return true;
95     }
96      
97     function renounceOwnership() external onlyOwner {
98         ownerWallet = address(0);
99     }
100 
101     function transferOwnership(address newOwner) external onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address, use renounceOwnership Function");
103 
104         if(balanceOf(ownerWallet) > 0) _transfer(ownerWallet, newOwner, balanceOf(ownerWallet));
105 
106         ownerWallet = newOwner;
107     }
108 
109     function _mint(address account, uint256 amount) internal {
110         require(account != address(0), "ERC20: mint to the zero address");
111 
112 
113         _totalSupply += amount;
114         unchecked {
115             _balances[account] += amount;
116         }
117         emit Transfer(address(0), account, amount);
118     }
119 
120     function _burn(address account, uint256 amount) internal {
121         require(account != address(0), "ERC20: burn from the zero address");
122 
123         uint256 accountBalance = _balances[account];
124         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
125         unchecked {
126             _balances[account] = accountBalance - amount;
127             _totalSupply -= amount;
128         }
129 
130         emit Transfer(account, address(0), amount);
131     }
132 
133     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
134         address spender = _msgSender();
135         _spendAllowance(from, spender, amount);
136         _transfer(from, to, amount);
137         return true;
138     }
139 
140     function _approve(address owner, address spender, uint256 amount) internal {
141         require(owner != address(0), "ERC20: approve from the zero address");
142         require(spender != address(0), "ERC20: approve to the zero address");
143 
144         _allowances[owner][spender] = amount;
145         emit Approval(owner, spender, amount);
146     }
147 
148     function _spendAllowance(address owner, address spender, uint256 amount) internal {
149         uint256 currentAllowance = allowance(owner, spender);
150         if (currentAllowance != type(uint256).max) {
151             require(currentAllowance >= amount, "ERC20: insufficient allowance");
152             unchecked {
153                 _approve(owner, spender, currentAllowance - amount);
154             }
155         }
156     }
157 
158     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
159         address owner = _msgSender();
160         _approve(owner, spender, allowance(owner, spender) + addedValue);
161         return true;
162     }
163 
164     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
165         address owner = _msgSender();
166         uint256 currentAllowance = allowance(owner, spender);
167         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
168         unchecked {
169             _approve(owner, spender, currentAllowance - subtractedValue);
170         }
171 
172         return true;
173     }
174 
175     function _beforeTokenTransfer(address from, address to, uint256 amount) internal view {
176         if(limitInPlace){
177             if(liquidityPair[from]){
178                 require(amount <= maxTransaction && balanceOf(to) + amount <= maxWallet, "Amount is over Max Transaction");
179             } else if(liquidityPair[to] && !liquidityProvider[from]) {
180                 require(amount <= maxTransaction, "Amount is over Max Transaction");
181             }
182         }
183     }
184 
185     function _transfer(address from, address to, uint256 amount) internal {
186         require(from != address(0), "ERC20: transfer from the zero address");
187         require(to != address(0), "ERC20: transfer to the zero address");
188         require(_balances[from] >= amount, "ERC20: transfer amount exceeds balance");
189         _beforeTokenTransfer(from, to, amount);
190         uint256 fromBalance = _balances[from];
191         unchecked {
192             _balances[from] = fromBalance - amount;
193             _balances[to] += amount;
194         }
195         emit Transfer(from, to, amount);
196     }
197 
198     function setLimits(bool inPlace, uint256 _maxTransaction, uint256 _maxWallet) external onlyOwner {
199         require(_maxTransaction >= 10 && _maxWallet > 10, "Max Transaction and Max Wallet must be over .1%");
200         maxTransaction = (_totalSupply * _maxTransaction) / 10000;
201         maxWallet = (_totalSupply * _maxWallet) / 10000;
202         limitInPlace = inPlace;
203     }
204 
205     function setLiquidityProvider(address provider, bool isProvider) external onlyOwner {
206         liquidityProvider[provider] = isProvider;
207     }
208 
209     function setPair(address pairs, bool isPair) external onlyOwner {
210         liquidityPair[pairs] = isPair;
211     }
212 
213     function burn(uint256 amount) external {
214         _burn(_msgSender(), amount);
215     }
216 }