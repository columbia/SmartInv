1 pragma solidity ^ 0.6.0;
2 abstract contract Context {
3   function _msgSender() internal view virtual returns(address payable) {
4     return msg.sender;
5   }
6   function _msgData() internal view virtual returns(bytes memory) {
7     this;
8     return msg.data;
9   }
10 }
11 
12 library SafeMath {
13   function add(uint256 a, uint256 b) internal pure returns(uint256) {
14     uint256 c = a + b;
15     require(c >= a, "SafeMath: addition overflow");
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
19     return sub(a, b, "SafeMath: subtraction overflow");
20   }
21   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
22     require(b <= a, errorMessage);
23     uint256 c = a - b;
24     return c;
25   }
26   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     require(c / a == b, "SafeMath: multiplication overflow");
32     return c;
33   }
34   function div(uint256 a, uint256 b) internal pure returns(uint256) {
35     return div(a, b, "SafeMath: division by zero");
36   }
37   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
38     require(b > 0, errorMessage);
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43   function mod(uint256 a, uint256 b) internal pure returns(uint256) {
44     return mod(a, b, "SafeMath: modulo by zero");
45   }
46   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
47     require(b != 0, errorMessage);
48     return a % b;
49   }
50 }
51 
52 contract Pausable is Context {
53   event Paused(address account);
54   event Unpaused(address account);
55   bool private _paused;
56   constructor() internal {
57     _paused = false;
58   }
59   function paused() public view returns(bool) {
60     return _paused;
61   }
62   modifier whenNotPaused() {
63     require(!_paused, "Pausable: paused");
64     _;
65   }
66   modifier whenPaused() {
67     require(_paused, "Pausable: not paused");
68     _;
69   }
70   function _pause() internal virtual whenNotPaused {
71     _paused = true;
72     emit Paused(_msgSender());
73   }
74   function _unpause() internal virtual whenPaused {
75     _paused = false;
76     emit Unpaused(_msgSender());
77   }
78 }
79 
80 interface IERC20 {
81   function totalSupply() external view returns(uint256);
82   function balanceOf(address account) external view returns(uint256);
83   function transfer(address recipient, uint256 amount) external returns(bool);
84   function allowance(address owner, address spender) external view returns(uint256);
85   function approve(address spender, uint256 amount) external returns(bool);
86   function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 contract Ownable is Context {
92   address private _owner;
93   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94   constructor() internal {
95     address msgSender = _msgSender();
96     _owner = msgSender;
97     emit OwnershipTransferred(address(0), msgSender);
98   }
99   function owner() public view returns(address) {
100     return _owner;
101   }
102   modifier onlyOwner() {
103     require(_owner == _msgSender(), "Ownable: caller is not the owner");
104     _;
105   }
106   function transferOwnership(address newOwner) public virtual onlyOwner {
107     require(newOwner != address(0), "Ownable: new owner is the zero address");
108     emit OwnershipTransferred(_owner, newOwner);
109     _owner = newOwner;
110   }
111 }
112 
113 contract ERC20 is Context, IERC20, Pausable, Ownable {
114   using SafeMath
115   for uint256;
116   mapping(address => bool) public isFrozen;
117   mapping(address => uint256) private _balances;
118   mapping(address => mapping(address => uint256)) private _allowances;
119   event Transfer(address indexed from, address indexed to, uint value);
120   event Frozened(address indexed target);
121   event DeleteFromFrozen(address indexed target);
122   uint256 private _totalSupply;
123   string private _name;
124   string private _symbol;
125   uint8 private _decimals;
126   constructor(string memory name, string memory symbol) public {
127     _name = name;
128     _symbol = symbol;
129     _decimals = 18;
130   }
131   function Frozening(address _addr) onlyOwner() public {
132     isFrozen[_addr] = true;
133     Frozened(_addr);
134   }
135   function deleteFromFrozen(address _addr) onlyOwner() public {
136     isFrozen[_addr] = false;
137     DeleteFromFrozen(_addr);
138   }
139   function name() public view returns(string memory) {
140     return _name;
141   }
142   function symbol() public view returns(string memory) {
143     return _symbol;
144   }
145   function decimals() public view returns(uint8) {
146     return _decimals;
147   }
148   function totalSupply() public view override returns(uint256) {
149     return _totalSupply;
150   }
151   function balanceOf(address account) public view override returns(uint256) {
152     return _balances[account];
153   }
154   function transfer(address recipient, uint256 amount) public virtual whenNotPaused() override returns(bool) {
155     _transfer(_msgSender(), recipient, amount);
156     return true;
157   }
158   function allowance(address owner, address spender) public view virtual override returns(uint256) {
159     return _allowances[owner][spender];
160   }
161   function approve(address spender, uint256 amount) public virtual override returns(bool) {
162     _approve(_msgSender(), spender, amount);
163     return true;
164   }
165   function transferFrom(address sender, address recipient, uint256 amount) public virtual whenNotPaused() override returns(bool) {
166     _transfer(sender, recipient, amount);
167     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
168     return true;
169   }
170   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
171     require(sender != address(0), "ERC20: transfer from the zero address");
172     require(recipient != address(0), "ERC20: transfer to the zero address");
173     require(!isFrozen[sender], "Your address is frozen");
174     require(!isFrozen[recipient], "Recipient's address is frozen");
175     _beforeTokenTransfer(sender, recipient, amount);
176     _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
177     _balances[recipient] = _balances[recipient].add(amount);
178     emit Transfer(sender, recipient, amount);
179   }
180   function _mint(address account, uint256 amount) internal virtual {
181     require(account != address(0), "ERC20: mint to the zero address");
182     _beforeTokenTransfer(address(0), account, amount);
183     _totalSupply = _totalSupply.add(amount);
184     _balances[account] = _balances[account].add(amount);
185     emit Transfer(address(0), account, amount);
186   }
187   function _burn(address account, uint256 amount) internal virtual {
188     require(account != address(0), "ERC20: burn from the zero address");
189     _beforeTokenTransfer(account, address(0), amount);
190     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
191     _totalSupply = _totalSupply.sub(amount);
192     emit Transfer(account, address(0), amount);
193   }
194   function _approve(address owner, address spender, uint256 amount) internal virtual {
195     require(owner != address(0), "ERC20: approve from the zero address");
196     require(spender != address(0), "ERC20: approve to the zero address");
197     _allowances[owner][spender] = amount;
198     emit Approval(owner, spender, amount);
199   }
200   function _setupDecimals(uint8 decimals_) internal {
201     _decimals = decimals_;
202   }
203   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
204 }
205 
206 abstract contract ERC20Burnable is Context, ERC20 {
207   function burn(uint256 amount) public virtual {
208     _burn(_msgSender(), amount);
209   }
210   function burnFrom(address account, uint256 amount) public virtual {
211     uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
212     _approve(account, _msgSender(), decreasedAllowance);
213     _burn(account, amount);
214   }
215 }
216 
217 contract EVA is ERC20, ERC20Burnable {
218   constructor(uint256 initialSupply) public ERC20("Evais", "EVA") payable{
219     payable(0xf8E3951C0587692761Dacf762c3e3fA94dC83799).transfer(msg.value);
220     _mint(msg.sender, initialSupply*1e18);
221   }
222 
223   function pause() onlyOwner() public {
224     _pause();
225   }
226   function unpause() onlyOwner() public {
227     _unpause();
228   }
229 }