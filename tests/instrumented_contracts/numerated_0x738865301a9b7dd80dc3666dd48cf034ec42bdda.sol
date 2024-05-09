1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <=0.8.0;
3 
4 interface IERC20 {
5         function totalSupply() external view returns (uint256);
6         function balanceOf(address account) external view returns (uint256);
7         function transfer(address recipient, uint256 amount) external returns (bool);
8         function allowance(address owner, address spender) external view returns (uint256);
9         function approve(address spender, uint256 amount) external returns (bool);
10         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11         event Approval(address indexed owner, address indexed spender, uint256 value);
12         event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract Pausable {
16         event Paused();
17         event Unpaused();
18         bool private _paused;
19         constructor ()                                  { _paused = false; }
20         function paused() public view returns (bool)    { return _paused; }
21         modifier whenNotPaused()                        { require(!_paused, "Pausable: paused"); _; }
22         modifier whenPaused()                           { require(_paused, "Pausable: not paused"); _; }
23         function _pause() internal virtual whenNotPaused{ _paused = true; emit Paused(); }
24         function _unpause() internal virtual whenPaused { _paused = false; emit Unpaused(); }
25 }
26 
27 contract AgorasToken is IERC20, Pausable {
28         mapping (address => uint256) private _balances;
29         mapping (address => mapping (address => uint256)) private _allowances;
30         mapping (address => bool) private _locked;
31         uint256 private _totalSupply;
32         string private _name;
33         string private _symbol;
34         uint8 private _decimals;
35         address private _owner;
36 
37         constructor() {
38                 _name = 'Agoras Token';
39                 _symbol = 'AGRS';
40                 _decimals = 8;
41                 _totalSupply = 42000000 * (10**_decimals);
42                 _balances[msg.sender] = _totalSupply;
43                 _owner = msg.sender;
44         }
45 
46         function name() public view returns (string memory)     { return _name; }
47         function symbol() public view returns (string memory) { return _symbol; }
48         function decimals() public view returns (uint8) { return _decimals; }
49         function totalSupply() public view override returns (uint256) { return _totalSupply; }
50         function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
51         function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
52                 require(!_locked[msg.sender], "AgorasToken locked sender");
53                 _transfer(msg.sender, recipient, amount);
54                 return true;
55         }
56         function allowance(address owner, address spender) public view virtual override returns (uint256) {
57                 return _allowances[owner][spender];
58         }
59         function approve(address spender, uint256 amount) public virtual override returns (bool) {
60                 _approve(msg.sender, spender, amount);
61                 return true;
62         }
63 
64         function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
65                 require(!_locked[sender], "AgorasToken locked from sender");
66                 require(_allowances[sender][msg.sender] >= amount, "AgorasToken transfer amount exceeds allowance");
67                 _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
68                 _transfer(sender, recipient, amount);
69                 return true;
70         }
71 
72         function _approve(address owner, address spender, uint256 amount) internal virtual {
73                 require(owner != address(0), "AgorasToken approve from the zero address");
74                 require(spender != address(0), "AgorasToken approve to the zero address");
75                 _allowances[owner][spender] = amount;
76                 emit Approval(owner, spender, amount);
77         }
78 
79         function _transfer(address sender, address recipient, uint256 amount) internal virtual {
80                 //_beforeTokenTransfer();
81                 require(paused() == false, "AgorasToken is Paused");
82                 require(sender != address(0), "AgorasToken transfer from the zero address");
83                 require(recipient != address(0), "AgorasToken transfer to the zero address");
84                 require(_balances[sender] >= amount, "AgorasToken transfer amount exceeds balance");
85                 require(_balances[recipient] + amount >= _balances[recipient], "AgorasToken addition overflow");
86 
87                 _balances[sender] -= amount;
88                 _balances[recipient] += amount;
89                 emit Transfer(sender, recipient, amount);
90         }
91 
92         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
93                 uint256 c = _allowances[msg.sender][spender] + addedValue;
94                 require(c >= _allowances[msg.sender][spender], "AgorasToken addition overflow");
95                 _approve(msg.sender, spender, c);
96                 return true;
97         }
98 
99         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
100                 require(_allowances[msg.sender][spender] >= subtractedValue, "AgorasToken decreased allowance below zero");
101                 _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
102                 return true;
103         }
104 
105         function _beforeTokenTransfer() internal virtual { }
106 
107         function pause()  public virtual returns (bool) {
108                 require(msg.sender == _owner, "AgorasToken: pause request from non owner");
109                 _pause();
110                 return true;
111         }
112 
113         function unpause() public virtual returns (bool) {
114                 require(msg.sender == _owner, "AgorasToken: unpause request from non owner");
115                 _unpause();
116                 return true;
117         }
118 
119         event Mint(uint256 amount);
120 
121         function mint(uint256 amount) public virtual returns (bool) {
122                 require(paused()==false, "AgorasToken is Paused");
123                 require(msg.sender == _owner, "AgorasToken: mint from non owner ");
124                 require(_totalSupply + amount >= _totalSupply, "AgorasToken addition overflow");
125                 require(_balances[_owner] + amount >= amount, "AgorasToken addition overflow");
126                 _totalSupply += amount;
127                 _balances[_owner] += amount;
128                 emit Mint(amount);
129                 return true;
130         }
131 
132         function updateNameSymbol(string calldata newname, string calldata newsymbol) public virtual returns (bool) {
133                 require(paused()==false, "AgorasToken is Paused");
134                 require(msg.sender == _owner, "AgorasToken: update from non owner");
135                 require(bytes(newname).length <= 32, "AgorasToken: name too long");
136                 require(bytes(newname).length > 0, "AgorasToken: empty name");
137                 require(bytes(newsymbol).length <= 8, "AgorasToken: symbol too long");
138                 require(bytes(newsymbol).length > 0, "AgorasToken: empty symbol");
139                 _name = newname;
140                 _symbol = newsymbol;
141                 return true;
142         }
143 
144         function isLocked(address addr) public virtual returns (bool) {
145                 return _locked[addr];
146         }
147 
148         function addLock(address addr) public virtual returns (bool) {
149                 require(paused()==false, "AgorasToken is Paused");
150                 require(msg.sender == _owner, "AgorasToken: update from non owner");
151                 _locked[addr] = true;
152                 emit Locked(addr);
153                 return true;
154         }
155 
156         function removeLock(address addr) public virtual returns (bool) {
157                 require(paused()==false, "AgorasToken is Paused");
158                 require(msg.sender == _owner, "AgorasToken: update from non owner");
159                 _locked[addr] = false;
160                 emit Unlocked(addr);
161                 return true;
162         }
163 
164         event Locked(address addr);
165         event Unlocked(address addr);
166 }