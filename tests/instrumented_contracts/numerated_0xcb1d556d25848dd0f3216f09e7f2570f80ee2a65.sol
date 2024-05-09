1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33     
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 }
54 
55 interface IERC20 {
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address payable) {
68         return msg.sender;
69     }
70 }
71 
72 abstract contract Ownable is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () internal {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 abstract contract Pausable is Context, Ownable {
100     event Paused(address account);
101     event Unpaused(address account);
102 
103     bool private _paused;
104 
105     constructor () internal {
106         _paused = false;
107     }
108 
109     function paused() public view returns (bool) {
110         return _paused;
111     }
112 
113     modifier whenNotPaused() {
114         require(!_paused, "Pausable: paused");
115         _;
116     }
117 
118 
119     modifier whenPaused() {
120         require(_paused, "Pausable: not paused");
121         _;
122     }
123 
124 
125     function _pause() internal virtual onlyOwner whenNotPaused {
126         _paused = true;
127         emit Paused(_msgSender());
128     }
129 
130 
131     function _unpause() internal virtual onlyOwner whenPaused {
132         _paused = false;
133         emit Unpaused(_msgSender());
134     }
135 }
136 
137 contract ERC20 is Context, IERC20, Pausable {
138     using SafeMath for uint256;
139 
140     mapping (address => uint256) private _balances;
141 
142     mapping (address => mapping (address => uint256)) private _allowances;
143     
144     string public name;
145     string public symbol;
146     uint8 public decimals;
147     uint256 public totalSupply;
148     
149     constructor (string memory name_, string memory symbol_, uint256 totalSupply_) public { 
150         name = name_;
151         symbol = symbol_;
152         decimals = 18;
153 
154         _mint(owner(), totalSupply_ * (10 ** uint256(decimals)));
155         emit Transfer(address(0), owner(), totalSupply);
156     }
157 
158     function balanceOf(address account) public view override returns (uint256) {
159         return _balances[account];
160     }
161 
162     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166 
167     function allowance(address owner, address spender) public view virtual override returns (uint256) {
168         return _allowances[owner][spender];
169     }
170 
171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175 
176     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
177         _transfer(sender, recipient, amount);
178         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
189         return true;
190     }
191     
192     function mint(address account, uint256 amount) onlyOwner public virtual returns (bool) {
193         _mint(account, amount);
194         return true;
195     }
196 
197     function burn(uint256 amount) onlyOwner public virtual returns (bool) {
198         _burn(_msgSender(), amount);
199         return true;
200     }
201 
202     function pause() public virtual {
203         _pause();
204     }
205     
206     function unpause() public virtual {
207         _unpause();
208     }
209 
210     function _transfer(address sender, address recipient, uint256 amount) whenNotPaused internal virtual {
211         require(sender != address(0), "ERC20: transfer from the zero address");
212         require(recipient != address(0), "ERC20: transfer to the zero address");
213 
214         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
215         _balances[recipient] = _balances[recipient].add(amount);
216         emit Transfer(sender, recipient, amount);
217     }
218 
219     function _mint(address account, uint256 amount) whenNotPaused internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221 
222         totalSupply = totalSupply.add(amount);
223         _balances[account] = _balances[account].add(amount);
224         emit Transfer(address(0), account, amount);
225     }
226 
227     function _burn(address account, uint256 amount) whenNotPaused internal virtual {
228         require(account != address(0), "ERC20: burn from the zero address");
229 
230         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
231         totalSupply = totalSupply.sub(amount);
232         emit Transfer(account, address(0), amount);
233     }
234 
235     function _approve(address owner, address spender, uint256 amount) whenNotPaused internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238         
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 }