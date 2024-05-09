1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-21
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-08-09
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.7;
11 
12 library SafeMath {
13     
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a, "SafeMath: subtraction overflow");
21         uint256 c = a - b;
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25        if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0, "SafeMath: division by zero");
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 interface IBEP20 {
47     
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract Tipcoin is IBEP20 {
59     using SafeMath for uint256;
60 
61        modifier onlyOwner() {
62         require(msg.sender==owner, "Only Call by Owner");
63         _;
64     }
65 
66     address public owner;
67 
68     constructor () {
69 
70         _name="Tipcoin";
71         _symbol="TIP";
72         _decimals=18;
73         owner=msg.sender;
74         _mint(msg.sender,(1000000000*(10**18)));
75         _paused = false;
76     }
77 
78     // 
79     // 
80 
81     /**
82      * @dev Emitted when the pause is triggered by `account`.
83      */
84     event Paused(address account);
85 
86     /**
87      * @dev Emitted when the pause is lifted by `account`.
88      */
89     event Unpaused(address account);
90 
91     bool private _paused;
92 
93     /**
94      * @dev Initializes the contract in unpaused state.
95      */
96  
97 
98       
99 
100 
101     /**
102      * @dev Returns true if the contract is paused, and false otherwise.
103      */
104     function paused() public view virtual returns (bool) {
105         return _paused;
106     }
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is not paused.
110      *
111      * Requirements:
112      *
113      * - The contract must not be paused.
114      */
115     modifier whenNotPaused() {
116         require(!paused(), "Pausable: paused");
117         _;
118     }
119 
120     /**
121      * @dev Modifier to make a function callable only when the contract is paused.
122      *
123      * Requirements:
124      *
125      * - The contract must be paused.
126      */
127     modifier whenPaused() {
128         require(paused(), "Pausable: not paused");
129         _;
130     }
131 
132     /**
133      * @dev Triggers stopped state.
134      *
135      * Requirements:
136      *
137      * - The contract must not be paused.
138      */
139     function _pause() internal virtual whenNotPaused {
140         _paused = true;
141         emit Paused(msg.sender);
142     }
143 
144     /**
145      * @dev Returns to normal state.
146      *
147      * Requirements:
148      *
149      * - The contract must be paused.
150      */
151     function _unpause() internal virtual whenPaused {
152         _paused = false;
153         emit Unpaused(msg.sender);
154     }
155 
156     function pauseContract() public onlyOwner{
157         _pause();
158 
159     }
160     function unpauseContract() public onlyOwner{
161         _unpause();
162 
163     }
164 
165 //         
166     // 
167 
168     mapping (address => uint256) private _balances;
169     mapping (address => mapping (address => uint256)) private _allowances;
170     uint256 private _totalSupply;
171     function totalSupply() public view override returns (uint256) {
172         return _totalSupply;
173     }
174     function balanceOf(address account) public view override returns (uint256) {
175         return _balances[account];
176     }
177 
178     function transfer(address recipient, uint256 amount) public whenNotPaused override returns (bool) {
179         _transfer(msg.sender, recipient, amount);
180         return true;
181     }
182     function allowance(address owner, address spender) public view override returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 value) public override returns (bool) {
187         _approve(msg.sender, spender, value);
188         return true;
189     }
190      
191     function transferownership(address _newonwer) public onlyOwner{
192         owner=_newonwer;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
198         return true;
199     }
200     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
201         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
202         return true;
203     }
204 
205     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
206         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
207         return true;
208     }
209 
210     function _transfer(address sender, address recipient, uint256 amount) internal whenNotPaused {
211         require(sender != address(0), "ERC20: transfer from the zero address");
212         require(recipient != address(0), "ERC20: transfer to the zero address");
213 
214         _balances[sender] = _balances[sender].sub(amount);
215         _balances[recipient] = _balances[recipient].add(amount);
216         emit Transfer(sender, recipient, amount);
217     }
218     function _mint(address account, uint256 amount) internal {
219         require(account != address(0), "ERC20: mint to the zero address");
220 
221         _totalSupply = _totalSupply.add(amount);
222         _balances[account] = _balances[account].add(amount);
223         emit Transfer(address(0), account, amount);
224     }
225 
226     function _burn(address account, uint256 value) internal whenNotPaused {
227         require(account != address(0), "ERC20: burn from the zero address");
228 
229         _totalSupply = _totalSupply.sub(value);
230         _balances[account] = _balances[account].sub(value);
231         emit Transfer(account, address(0), value);
232     }
233 
234     function _approve(address owner, address spender, uint256 value) internal whenNotPaused {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = value;
239         emit Approval(owner, spender, value);
240     }
241 
242     function _burnFrom(address account, uint256 amount) internal whenNotPaused {
243         _burn(account, amount);
244         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
245     }
246 
247 string private _name;
248     string private _symbol;
249     uint8 private _decimals;
250 
251       function name() public view returns (string memory) {
252         return _name;
253     }
254     function symbol() public view returns (string memory) {
255         return _symbol;
256     }
257 
258     function decimals() public view returns (uint8) {
259         return _decimals;
260     }
261 }