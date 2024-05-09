1 pragma solidity ^0.5.8;
2 contract Context {
3     constructor () internal { }
4     function _msgSender() internal view returns (address payable) {
5         return msg.sender;
6     }
7     function _msgData() internal view returns (bytes memory) {
8         this;
9         return msg.data;
10     }
11 }
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42         return c;
43     }
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "SafeMath: division by zero");
46     }
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         return c;
51     }
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;
58     }
59 }
60 contract ERC20 is Context, IERC20 {
61     using SafeMath for uint256;
62     mapping (address => uint256) private _balances;
63     mapping (address => mapping (address => uint256)) private _allowances;
64     uint256 private _totalSupply;
65     function totalSupply() public view returns (uint256) {
66         return _totalSupply;
67     }
68     function balanceOf(address account) public view returns (uint256) {
69         return _balances[account];
70     }
71     function transfer(address recipient, uint256 amount) public returns (bool) {
72         _transfer(_msgSender(), recipient, amount);
73         return true;
74     }
75     function allowance(address owner, address spender) public view returns (uint256) {
76         return _allowances[owner][spender];
77     }
78     function approve(address spender, uint256 amount) public returns (bool) {
79         _approve(_msgSender(), spender, amount);
80         return true;
81     }
82     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
83         _transfer(sender, recipient, amount);
84         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
85         return true;
86     }
87     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
88         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
89         return true;
90     }
91     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
92         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
93         return true;
94     }
95     function _transfer(address sender, address recipient, uint256 amount) internal {
96         require(sender != address(0), "ERC20: transfer from the zero address");
97         require(recipient != address(0), "ERC20: transfer to the zero address");
98         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
99         _balances[recipient] = _balances[recipient].add(amount);
100         emit Transfer(sender, recipient, amount);
101     }
102     function _mint(address account, uint256 amount) internal {
103         require(account != address(0), "ERC20: mint to the zero address");
104         _totalSupply = _totalSupply.add(amount);
105         _balances[account] = _balances[account].add(amount);
106         emit Transfer(address(0), account, amount);
107     }
108     function _burn(address account, uint256 amount) internal {
109         require(account != address(0), "ERC20: burn from the zero address");
110         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
111         _totalSupply = _totalSupply.sub(amount);
112         emit Transfer(account, address(0), amount);
113     }
114     function _approve(address owner, address spender, uint256 amount) internal {
115         require(owner != address(0), "ERC20: approve from the zero address");
116         require(spender != address(0), "ERC20: approve to the zero address");
117         _allowances[owner][spender] = amount;
118         emit Approval(owner, spender, amount);
119     }
120     function _burnFrom(address account, uint256 amount) internal {
121         _burn(account, amount);
122         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
123     }
124 }
125 library Roles {
126     struct Role {
127         mapping (address => bool) bearer;
128     }
129     function add(Role storage role, address account) internal {
130         require(!has(role, account), "Roles: account already has role");
131         role.bearer[account] = true;
132     }
133     function remove(Role storage role, address account) internal {
134         require(has(role, account), "Roles: account does not have role");
135         role.bearer[account] = false;
136     }
137     function has(Role storage role, address account) internal view returns (bool) {
138         require(account != address(0), "Roles: account is the zero address");
139         return role.bearer[account];
140     }
141 }
142 contract MinterRole is Context {
143     using Roles for Roles.Role;
144     event MinterAdded(address indexed account);
145     event MinterRemoved(address indexed account);
146     Roles.Role private _minters;
147     constructor () internal {
148         _addMinter(_msgSender());
149     }
150     modifier onlyMinter() {
151         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
152         _;
153     }
154     function isMinter(address account) public view returns (bool) {
155         return _minters.has(account);
156     }
157     function addMinter(address account) public onlyMinter {
158         _addMinter(account);
159     }
160     function renounceMinter() public {
161         _removeMinter(_msgSender());
162     }
163     function _addMinter(address account) internal {
164         _minters.add(account);
165         emit MinterAdded(account);
166     }
167     function _removeMinter(address account) internal {
168         _minters.remove(account);
169         emit MinterRemoved(account);
170     }
171 }
172 contract ERC20Mintable is ERC20, MinterRole {
173     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
174         _mint(account, amount);
175         return true;
176     }
177 }
178 contract ERC20Capped is ERC20Mintable {
179     uint256 private _cap;
180     constructor (uint256 cap) public {
181         require(cap > 0, "ERC20Capped: cap is 0");
182         _cap = cap;
183     }
184     function cap() public view returns (uint256) {
185         return _cap;
186     }
187     function _mint(address account, uint256 value) internal {
188         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
189         super._mint(account, value);
190     }
191 }
192 contract ERC20Detailed is IERC20 {
193     string private _name;
194     string private _symbol;
195     uint8 private _decimals;
196     constructor (string memory name, string memory symbol, uint8 decimals) public {
197         _name = name;
198         _symbol = symbol;
199         _decimals = decimals;
200     }
201     function name() public view returns (string memory) {
202         return _name;
203     }
204     function symbol() public view returns (string memory) {
205         return _symbol;
206     }
207     function decimals() public view returns (uint8) {
208         return _decimals;
209     }
210 }
211 contract AIFBCT is ERC20Detailed, ERC20Capped {
212     constructor() ERC20Detailed("AI-FBCT", "AI-FBCT", 18) ERC20Capped(360000000 ether) public
213     {
214         mint(0xeC4de3cF3809f406085E62d8Dbbb2a14891BB906, 360000000 ether);
215         renounceMinter();
216     }
217 }