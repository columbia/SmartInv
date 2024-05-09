1 // Token Generated using SuperToken https://supertoken.xyz
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.4;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this;
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20     constructor () {
21         address msgSender = _msgSender();
22         _owner = msgSender;
23         emit OwnershipTransferred(address(0), msgSender);
24     }
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28     modifier onlyOwner() {
29         require(owner() == _msgSender(), "Ownable: caller is not the owner");
30         _;
31     }
32     function renounceOwnership() public virtual onlyOwner {
33         emit OwnershipTransferred(_owner, address(0));
34         _owner = address(0);
35     }
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         emit OwnershipTransferred(_owner, newOwner);
39         _owner = newOwner;
40     }
41 }
42 
43 interface IST20 {
44     function name() external view returns (string memory);
45     function symbol() external view returns (string memory);
46     function decimals() external view returns (uint8);
47     function totalSupply() external view returns (uint256);
48     function balanceOf(address account) external view returns (uint256);
49     function getOwner() external view returns (address);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function allowance(address _owner, address spender) external view returns (uint256);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract ST20 is Ownable, IST20 {
59     mapping (address => uint256) private _balances;
60     mapping (address => mapping (address => uint256)) private _allowances;
61     uint256 private _totalSupply;
62     string private _name;
63     string private _symbol;
64     uint8 private _decimals;
65 
66     constructor (string memory name_, string memory symbol_) {
67         _name = name_;
68         _symbol = symbol_;
69         _decimals = 18;
70     }
71     function _setupDecimals(uint8 decimals_) internal {
72         _decimals = decimals_;
73     }
74     function name() public view override returns (string memory) {
75         return _name;
76     }
77     function symbol() public view override returns (string memory) {
78         return _symbol;
79     }
80     function decimals() public view override returns (uint8) {
81         return _decimals;
82     }
83     function totalSupply() public view override returns (uint256) {
84         return _totalSupply;
85     }
86     function balanceOf(address account) public view override returns (uint256) {
87         return _balances[account];
88     }
89     function getOwner() public view override returns (address) {
90         return owner();
91     }
92     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
93         _transfer(_msgSender(), recipient, amount);
94         return true;
95     }
96     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
97         _transfer(sender, recipient, amount);
98         uint256 currentAllowance = _allowances[sender][_msgSender()];
99         require(currentAllowance >= amount, "Token: transfer amount exceeds allowance");
100         _approve(sender, _msgSender(), currentAllowance - amount);
101 
102         return true;
103     }
104     function approve(address spender, uint256 amount) public virtual override returns (bool) {
105         _approve(_msgSender(), spender, amount);
106         return true;
107     }
108     function allowance(address owner, address spender) public view virtual override returns (uint256) {
109         return _allowances[owner][spender];
110     }
111     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
112         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
113         return true;
114     }
115     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
116         uint256 currentAllowance = _allowances[_msgSender()][spender];
117         require(currentAllowance >= subtractedValue, "Token: decreased allowance below zero");
118         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
119         return true;
120     }
121     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
122         require(sender != address(0), "Token: transfer from the zero address");
123         require(recipient != address(0), "Token: transfer to the zero address");
124         _beforeTokenTransfer(sender, recipient, amount);
125         uint256 senderBalance = _balances[sender];
126         require(senderBalance >= amount, "Token: transfer amount exceeds balance");
127         _balances[sender] = senderBalance - amount;
128         _balances[recipient] += amount;
129         emit Transfer(sender, recipient, amount);
130     }
131     function _mint(address account, uint256 amount) internal virtual {
132         require(account != address(0), "Token: mint to the zero address");
133         _beforeTokenTransfer(address(0), account, amount);
134         _totalSupply += amount;
135         _balances[account] += amount;
136         emit Transfer(address(0), account, amount);
137     }
138     function _burn(address account, uint256 amount) internal virtual {
139         require(account != address(0), "Token: burn from the zero address");
140         _beforeTokenTransfer(account, address(0), amount);
141         uint256 accountBalance = _balances[account];
142         require(accountBalance >= amount, "Token: burn amount exceeds balance");
143         _balances[account] = accountBalance - amount;
144         _totalSupply -= amount;
145         emit Transfer(account, address(0), amount);
146     }
147     function _approve(address owner, address spender, uint256 amount) internal virtual {
148         require(owner != address(0), "Token: approve from the zero address");
149         require(spender != address(0), "Token: approve to the zero address");
150         _allowances[owner][spender] = amount;
151         emit Approval(owner, spender, amount);
152     }
153     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
154 }
155 
156 interface IPayable {
157     function pay(string memory serviceName) external payable;
158 }
159 
160 abstract contract ServicePayer {
161     constructor (address payable receiver, string memory serviceName) payable {
162         IPayable(receiver).pay{value: msg.value}(serviceName);
163     }
164 }
165 
166 contract ST_Basic_Token is ST20, ServicePayer {
167     constructor (
168         string memory name,
169         string memory symbol,
170         uint8 decimals,
171         uint256 initialBalance,
172         address payable feeReceiver
173     )
174         ST20(name, symbol)
175         ServicePayer(feeReceiver, "ST_Basic_Token")
176         payable
177     {
178         require(initialBalance > 0, "ST_Basic_Token: supply cannot be zero");
179         _setupDecimals(decimals);
180         _mint(_msgSender(), initialBalance);
181     }
182 }