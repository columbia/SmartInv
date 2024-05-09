1 pragma solidity 0.5.10;	
2 library SafeMath {	
3     function add(uint256 a, uint256 b) internal pure returns (uint256) {	
4         uint256 c = a + b;	
5         require(c >= a, "SafeMath: addition overflow");	
6         return c;	
7     }	
8     function sub(uint256 a, uint256 b) internal pure returns (uint256) {	
9         return sub(a, b, "SafeMath: subtraction overflow");	
10     }	
11     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	
12         require(b <= a, errorMessage);	
13         uint256 c = a - b;	
14         return c;	
15     }	
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {	
17         if (a == 0) {	
18             return 0;	
19         }	
20         uint256 c = a * b;	
21         require(c / a == b, "SafeMath: multiplication overflow");	
22         return c;	
23     }	
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {	
25         return div(a, b, "SafeMath: division by zero");	
26     }	
27     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	
28         require(b > 0, errorMessage);	
29         uint256 c = a / b;	
30         return c;	
31     }	
32 }	
33 contract Ownable {	
34     address private _owner;	
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);	
36     constructor () internal {	
37         _owner = msg.sender;	
38         emit OwnershipTransferred(address(0), msg.sender);	
39     }	
40     function owner() public view returns (address) {	
41         return _owner;	
42     }	
43     modifier onlyOwner() {	
44         require(_owner == msg.sender, "Ownable: caller is not the owner");	
45         _;	
46     }	
47     function transferOwnership(address newOwner) public onlyOwner {	
48         require(newOwner != address(0), "Ownable: new owner is the zero address");	
49         emit OwnershipTransferred(_owner, newOwner);	
50         _owner = newOwner;	
51     }	
52 }	
53 interface IERC20 {	
54     function totalSupply() external view returns (uint256);	
55     function balanceOf(address account) external view returns (uint256);	
56     function transfer(address recipient, uint256 amount) external returns (bool);	
57     function allowance(address owner, address spender) external view returns (uint256);	
58     function approve(address spender, uint256 amount) external returns (bool);	
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);	
60     event Transfer(address indexed from, address indexed to, uint256 value);	
61     event Approval(address indexed owner, address indexed spender, uint256 value);	
62 }	
63 contract ERC20 is IERC20 {	
64     using SafeMath for uint256;	
65     mapping (address => uint256) private _balances;	
66     mapping (address => mapping (address => uint256)) private _allowances;	
67     uint256 private _totalSupply;	
68     string internal _name;	
69     string internal _symbol;	
70     uint8 internal _decimals;	
71     function name() public view returns (string memory) {	
72         return _name;	
73     }	
74     function symbol() public view returns (string memory) {	
75         return _symbol;	
76     }	
77     function decimals() public view returns (uint8) {	
78         return _decimals;	
79     }	
80     function totalSupply() public view returns (uint256) {	
81         return _totalSupply;	
82     }	
83     function balanceOf(address account) public view returns (uint256) {	
84         return _balances[account];	
85     }	
86     function transfer(address recipient, uint256 amount) public returns (bool) {	
87         _transfer(msg.sender, recipient, amount);	
88         return true;	
89     }	
90     function allowance(address owner, address spender) public view returns (uint256) {	
91         return _allowances[owner][spender];	
92     }	
93     function approve(address spender, uint256 amount) public returns (bool) {	
94         _approve(msg.sender, spender, amount);	
95         return true;	
96     }	
97     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {	
98         _transfer(sender, recipient, amount);	
99         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));	
100         return true;	
101     }	
102     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {	
103         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));	
104         return true;	
105     }	
106     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {	
107         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));	
108         return true;	
109     }	
110     function _transfer(address sender, address recipient, uint256 amount) internal {	
111         require(sender != address(0), "ERC20: transfer from the zero address");	
112         require(recipient != address(0), "ERC20: transfer to the zero address");	
113         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");	
114         _balances[recipient] = _balances[recipient].add(amount);	
115         emit Transfer(sender, recipient, amount);	
116     }	
117     function _mint(address account, uint256 amount) internal {	
118         require(account != address(0), "ERC20: mint to the zero address");	
119         _totalSupply = _totalSupply.add(amount);	
120         _balances[account] = _balances[account].add(amount);	
121         emit Transfer(address(0), account, amount);	
122     }	
123     function _burn(address account, uint256 amount) internal {	
124         require(account != address(0), "ERC20: burn from the zero address");	
125         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");	
126         _totalSupply = _totalSupply.sub(amount);	
127         emit Transfer(account, address(0), amount);	
128     }	
129     function _approve(address owner, address spender, uint256 amount) internal {	
130         require(owner != address(0), "ERC20: approve from the zero address");	
131         require(spender != address(0), "ERC20: approve to the zero address");	
132         _allowances[owner][spender] = amount;	
133         emit Approval(owner, spender, amount);	
134     }	
135 }	
136 library Roles {	
137     struct Role {	
138         mapping (address => bool) bearer;	
139     }	
140     function add(Role storage role, address account) internal {	
141         require(!has(role, account), "Roles: account already has role");	
142         role.bearer[account] = true;	
143     }	
144     function remove(Role storage role, address account) internal {	
145         require(has(role, account), "Roles: account does not have role");	
146         role.bearer[account] = false;	
147     }	
148     function has(Role storage role, address account) internal view returns (bool) {	
149         require(account != address(0), "Roles: account is the zero address");	
150         return role.bearer[account];	
151     }	
152 }	
153 interface ApproveAndCallFallBack {	
154     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external;	
155 }	
156 contract TRES is ERC20, Ownable {	
157     address private boss = 0xC20e9fa3C437181A8f2F283B5c97Af59C0b046Aa;	
158     address private admin = 0xa4DE430d65667af7Ed57Ef966C3823deD8D5127a;	
159     mapping (address => uint256) freezed;	
160     modifier notFreezed(address account) {	
161         require(block.timestamp >= freezed[account]);	
162         _;	
163     }	
164     modifier onlyOwnerAndBoss() {	
165         require(msg.sender == owner() || msg.sender == boss);	
166         _;	
167     }	
168     uint256 internal INITIAL_SUPPLY = 200000000  * (10 ** 18);	
169     constructor(address recipient) public {	
170         _name = "Transparent Reliable Exchange and Storage";	
171         _symbol = "TRES";	
172         _decimals = 18;	
173         _mint(recipient, INITIAL_SUPPLY);	
174     }	
175     function _transfer(address sender, address recipient, uint256 amount) internal notFreezed(sender) {	
176         super._transfer(sender, recipient, amount);	
177     }	
178     function _freeze(address account, uint256 period) internal {	
179         require(account != address(0));	
180         freezed[account] = block.timestamp.add(period);	
181         emit OnFreezed(msg.sender, account, period, block.timestamp);	
182     }	
183     function freeze(address[] memory accounts, uint256[] memory periods) public onlyOwnerAndBoss {	
184         for (uint256 i = 0; i < accounts.length; i++) {	
185             _freeze(accounts[i], periods[i]);	
186         }	
187     }	
188     function freezeAndTransfer(address recipient, uint256 amount, uint256 period) public {	
189         require(msg.sender == boss || msg.sender == admin);	
190         _freeze(recipient, period);	
191         transfer(recipient, amount);	
192     }	
193     function deputeBoss(address newBoss) public onlyOwnerAndBoss {	
194         require(newBoss != address(0));	
195         emit OnBossDeputed(boss, newBoss, block.timestamp);	
196         boss = newBoss;	
197     }	
198     function deputeAdmin(address newAdmin) public onlyOwnerAndBoss {	
199         require(newAdmin != address(0));	
200         emit OnAdminDeputed(admin, newAdmin, block.timestamp);	
201         admin = newAdmin;	
202     }	
203     function approveAndCall(address spender, uint256 amount, bytes calldata extraData) external returns (bool) {	
204         require(approve(spender, amount));	
205         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), extraData);	
206         return true;	
207     }	
208     function withdrawERC20(address ERC20Token, address recipient) external {	
209         require(msg.sender == boss || msg.sender == admin);	
210         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));	
211         require(amount > 0);	
212         IERC20(ERC20Token).transfer(recipient, amount);	
213     }	
214     function setName(string memory newName, string memory newSymbol) public onlyOwner {	
215         emit OnNameSet(_name, _symbol, newName, newSymbol, now);	
216         _name = newName;	
217         _symbol = newSymbol;	
218     }	
219     function releaseDate(address account) public view returns(uint256) {	
220         return freezed[account];	
221     }	
222     event OnFreezed (	
223         address indexed sender,	
224         address indexed account,	
225         uint256 period,	
226         uint256 timestamp	
227     );	
228     event OnBossDeputed (	
229         address indexed former,	
230         address indexed current,	
231         uint256 timestamp	
232     );	
233     event OnAdminDeputed (	
234         address indexed former,	
235         address indexed current,	
236         uint256 timestamp	
237     );	
238     event OnNameSet (	
239         string oldName,	
240         string oldSymbol,	
241         string newName,	
242         string newSymbol,	
243         uint256 timestamp	
244     );	
245 }