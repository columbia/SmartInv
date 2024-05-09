1 pragma solidity ^0.6.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 }
8 
9 library SafeMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20 
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 contract Pausable is Context {
74     bool private _paused;
75 
76     event Paused(address account);
77     event Unpaused(address account);
78 
79     constructor () internal {
80         _paused = false;
81     }
82 
83     function paused() public view returns (bool) {
84         return _paused;
85     }
86 
87     modifier whenNotPaused() {
88         require(!_paused, "Pausable: paused");
89         _;
90     }
91 
92     modifier whenPaused() {
93         require(_paused, "Pausable: not paused");
94         _;
95     }
96 
97     function _pause() internal virtual whenNotPaused {
98         _paused = true;
99         emit Paused(_msgSender());
100     }
101 
102     function _unpause() internal virtual whenPaused {
103         _paused = false;
104         emit Unpaused(_msgSender());
105     }
106 }
107 
108 contract EaglePlatformToken is Context, IERC20, Ownable, Pausable {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112     mapping (address => mapping (address => uint256)) private _allowances;
113     mapping (address => bool) private _whitelist;
114 
115     uint256 private _totalSupply = 200000000 * (10 ** 18);
116 
117     string private _name = "Eagle Platform Token";
118     string private _symbol = "EPT";
119     uint8 private _decimals = 18;
120 
121     constructor () public {
122         _balances[_msgSender()] = _totalSupply;
123         emit Transfer(address(0), _msgSender(), _totalSupply);
124     }
125 
126     function name() public view returns (string memory) {
127         return _name;
128     }
129 
130     function symbol() public view returns (string memory) {
131         return _symbol;
132     }
133 
134     function decimals() public view returns (uint8) {
135         return _decimals;
136     }
137 
138     function totalSupply() public view override returns (uint256) {
139         return _totalSupply;
140     }
141 
142     function balanceOf(address account) public view override returns (uint256) {
143         return _balances[account];
144     }
145 
146     function isWhitelist(address account) public view returns (bool) {
147         return _whitelist[account];
148     }
149 
150     function pause() public onlyOwner returns (bool) {
151         _pause();
152         return true;
153     }
154 
155     function unpause() public onlyOwner returns (bool) {
156         _unpause();
157         return true;
158     }
159 
160     function addWhitelist(address account) public onlyOwner returns (bool) {
161         _whitelist[account] = true;
162         return true;
163     }
164 
165     function removeWhitelist(address account) public onlyOwner returns (bool) {
166         delete _whitelist[account];
167         return true;
168     }
169 
170     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     function burn(uint256 amount) public virtual {
176         _burn(_msgSender(), amount);
177     }
178 
179     function allowance(address owner, address spender) public view virtual override returns (uint256) {
180         return _allowances[owner][spender];
181     }
182 
183     function approve(address spender, uint256 amount) public virtual override returns (bool) {
184         _approve(_msgSender(), spender, amount);
185         return true;
186     }
187 
188     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
189         _transfer(sender, recipient, amount);
190         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
191         return true;
192     }
193 
194     function burnFrom(address account, uint256 amount) public virtual {
195         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
196 
197         _approve(account, _msgSender(), decreasedAllowance);
198         _burn(account, amount);
199     }
200 
201     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
202         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
203         return true;
204     }
205 
206     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
207         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
208         return true;
209     }
210 
211     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
212         require(sender != address(0), "ERC20: transfer from the zero address");
213         require(recipient != address(0), "ERC20: transfer to the zero address");
214 
215         if (paused() && !_whitelist[sender]) {
216             revert();
217         }
218 
219         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
220         _balances[recipient] = _balances[recipient].add(amount);
221         emit Transfer(sender, recipient, amount);
222     }
223 
224     function _burn(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: burn from the zero address");
226 
227         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
228         _totalSupply = _totalSupply.sub(amount);
229         emit Transfer(account, address(0), amount);
230     }
231 
232     function _approve(address owner, address spender, uint256 amount) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 }