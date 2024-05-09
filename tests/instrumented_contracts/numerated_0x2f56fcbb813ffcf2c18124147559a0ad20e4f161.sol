1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18     constructor () {
19         address msgSender = _msgSender();
20         _owner = msgSender;
21         emit OwnershipTransferred(address(0), msgSender);
22     }
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26     modifier onlyOwner() {
27         require(owner() == _msgSender(), "Ownable: caller is not the owner");
28         _;
29     }
30     function renounceOwnership() public virtual onlyOwner {
31         emit OwnershipTransferred(_owner, address(0));
32         _owner = address(0);
33     }
34     function transferOwnership(address newOwner) public virtual onlyOwner {
35         require(newOwner != address(0), "Ownable: new owner is the zero address");
36         emit OwnershipTransferred(_owner, newOwner);
37         _owner = newOwner;
38     }
39 }
40 
41 interface IST20 {
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address account) external view returns (uint256);
47     function getOwner() external view returns (address);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function allowance(address _owner, address spender) external view returns (uint256);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract ST20 is Ownable, IST20 {
57     mapping (address => uint256) private _balances;
58     mapping (address => mapping (address => uint256)) private _allowances;
59     uint256 private _totalSupply;
60     string private _name;
61     string private _symbol;
62     uint8 private _decimals;
63 
64     constructor (string memory name_, string memory symbol_) {
65         _name = name_;
66         _symbol = symbol_;
67         _decimals = 18;
68     }
69     function _setupDecimals(uint8 decimals_) internal {
70         _decimals = decimals_;
71     }
72     function name() public view override returns (string memory) {
73         return _name;
74     }
75     function symbol() public view override returns (string memory) {
76         return _symbol;
77     }
78     function decimals() public view override returns (uint8) {
79         return _decimals;
80     }
81     function totalSupply() public view override returns (uint256) {
82         return _totalSupply;
83     }
84     function balanceOf(address account) public view override returns (uint256) {
85         return _balances[account];
86     }
87     function getOwner() public view override returns (address) {
88         return owner();
89     }
90     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
91         _transfer(_msgSender(), recipient, amount);
92         return true;
93     }
94     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
95         _transfer(sender, recipient, amount);
96         uint256 currentAllowance = _allowances[sender][_msgSender()];
97         require(currentAllowance >= amount, "Token: transfer amount exceeds allowance");
98         _approve(sender, _msgSender(), currentAllowance - amount);
99 
100         return true;
101     }
102     function approve(address spender, uint256 amount) public virtual override returns (bool) {
103         _approve(_msgSender(), spender, amount);
104         return true;
105     }
106     function allowance(address owner, address spender) public view virtual override returns (uint256) {
107         return _allowances[owner][spender];
108     }
109     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
110         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
111         return true;
112     }
113     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
114         uint256 currentAllowance = _allowances[_msgSender()][spender];
115         require(currentAllowance >= subtractedValue, "Token: decreased allowance below zero");
116         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
117         return true;
118     }
119     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
120         require(sender != address(0), "Token: transfer from the zero address");
121         require(recipient != address(0), "Token: transfer to the zero address");
122         _beforeTokenTransfer(sender, recipient, amount);
123         uint256 senderBalance = _balances[sender];
124         require(senderBalance >= amount, "Token: transfer amount exceeds balance");
125         _balances[sender] = senderBalance - amount;
126         _balances[recipient] += amount;
127         emit Transfer(sender, recipient, amount);
128     }
129     function _mint(address account, uint256 amount) internal virtual {
130         require(account != address(0), "Token: mint to the zero address");
131         _beforeTokenTransfer(address(0), account, amount);
132         _totalSupply += amount;
133         _balances[account] += amount;
134         emit Transfer(address(0), account, amount);
135     }
136     function _burn(address account, uint256 amount) internal virtual {
137         require(account != address(0), "Token: burn from the zero address");
138         _beforeTokenTransfer(account, address(0), amount);
139         uint256 accountBalance = _balances[account];
140         require(accountBalance >= amount, "Token: burn amount exceeds balance");
141         _balances[account] = accountBalance - amount;
142         _totalSupply -= amount;
143         emit Transfer(account, address(0), amount);
144     }
145     function _approve(address owner, address spender, uint256 amount) internal virtual {
146         require(owner != address(0), "Token: approve from the zero address");
147         require(spender != address(0), "Token: approve to the zero address");
148         _allowances[owner][spender] = amount;
149         emit Approval(owner, spender, amount);
150     }
151     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
152 }
153 
154 interface IPayable {
155     function pay(string memory serviceName) external payable;
156 }
157 
158 abstract contract ServicePayer {
159     constructor (address payable receiver, string memory serviceName) payable {
160         IPayable(receiver).pay{value: msg.value}(serviceName);
161     }
162 }
163 
164 contract ST_Standard_Token is ST20, ServicePayer {
165     constructor (
166         string memory name,
167         string memory symbol,
168         uint8 decimals,
169         uint256 initialBalance,
170         address payable feeReceiver
171     )
172         ST20(name, symbol)
173         ServicePayer(feeReceiver, "ST_Standard_Token")
174         payable
175     {
176         require(initialBalance > 0, "ST_Standard_Token: supply cannot be zero");
177         _setupDecimals(decimals);
178         _mint(_msgSender(), initialBalance);
179     }
180 }