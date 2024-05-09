1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 library SafeMath {
5     
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9         return c;
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14         return c;
15     }
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17        if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         require(c / a == b, "SafeMath: multiplication overflow");
22         return c;
23     }
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0, "SafeMath: division by zero");
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0, "SafeMath: modulo by zero");
34         return a % b;
35     }
36 }
37 
38 interface IBEP20 {
39     
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract ShibariumToken is IBEP20 {
51     using SafeMath for uint256;
52 
53        modifier onlyOwner() {
54         require(msg.sender==owner, "Only Call by Owner");
55         _;
56     }
57 
58     address public owner;
59 
60     constructor () {
61 
62         _name="Shibarium Token";
63         _symbol="SHIBARIUM";
64         _decimals=18;
65         owner=msg.sender;
66         _mint(msg.sender,(100000000*(10**18)));
67         _paused = false;
68     }
69 
70     // 
71     // 
72 
73     /**
74      * @dev Emitted when the pause is triggered by `account`.
75      */
76     event Paused(address account);
77 
78     /**
79      * @dev Emitted when the pause is lifted by `account`.
80      */
81     event Unpaused(address account);
82 
83     bool private _paused;
84 
85     /**
86      * @dev Initializes the contract in unpaused state.
87      */
88  
89 
90       
91 
92 
93     /**
94      * @dev Returns true if the contract is paused, and false otherwise.
95      */
96     function paused() public view virtual returns (bool) {
97         return _paused;
98     }
99 
100     /**
101      * @dev Modifier to make a function callable only when the contract is not paused.
102      *
103      * Requirements:
104      *
105      * - The contract must not be paused.
106      */
107     modifier whenNotPaused() {
108         require(!paused(), "Pausable: paused");
109         _;
110     }
111 
112     /**
113      * @dev Modifier to make a function callable only when the contract is paused.
114      *
115      * Requirements:
116      *
117      * - The contract must be paused.
118      */
119     modifier whenPaused() {
120         require(paused(), "Pausable: not paused");
121         _;
122     }
123 
124     /**
125      * @dev Triggers stopped state.
126      *
127      * Requirements:
128      *
129      * - The contract must not be paused.
130      */
131     function _pause() internal virtual whenNotPaused {
132         _paused = true;
133         emit Paused(msg.sender);
134     }
135 
136     /**
137      * @dev Returns to normal state.
138      *
139      * Requirements:
140      *
141      * - The contract must be paused.
142      */
143     function _unpause() internal virtual whenPaused {
144         _paused = false;
145         emit Unpaused(msg.sender);
146     }
147 
148     function pauseContract() public onlyOwner{
149         _pause();
150 
151     }
152     function unpauseContract() public onlyOwner{
153         _unpause();
154 
155     }
156 
157 //         
158     // 
159 
160     mapping (address => uint256) private _balances;
161     mapping (address => mapping (address => uint256)) private _allowances;
162     uint256 private _totalSupply;
163     function totalSupply() public view override returns (uint256) {
164         return _totalSupply;
165     }
166     function balanceOf(address account) public view override returns (uint256) {
167         return _balances[account];
168     }
169 
170     function transfer(address recipient, uint256 amount) public whenNotPaused override returns (bool) {
171         _transfer(msg.sender, recipient, amount);
172         return true;
173     }
174     function allowance(address owner, address spender) public view override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 value) public override returns (bool) {
179         _approve(msg.sender, spender, value);
180         return true;
181     }
182      
183     function transferownership(address _newonwer) public onlyOwner{
184         owner=_newonwer;
185     }
186 
187     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused override returns (bool) {
188         _transfer(sender, recipient, amount);
189         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
190         return true;
191     }
192     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
193         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
194         return true;
195     }
196 
197     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
198         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
199         return true;
200     }
201 
202     function _transfer(address sender, address recipient, uint256 amount) internal whenNotPaused {
203         require(sender != address(0), "ERC20: transfer from the zero address");
204         require(recipient != address(0), "ERC20: transfer to the zero address");
205 
206         _balances[sender] = _balances[sender].sub(amount);
207         _balances[recipient] = _balances[recipient].add(amount);
208         emit Transfer(sender, recipient, amount);
209     }
210     function _mint(address account, uint256 amount) internal {
211         require(account != address(0), "ERC20: mint to the zero address");
212 
213         _totalSupply = _totalSupply.add(amount);
214         _balances[account] = _balances[account].add(amount);
215         emit Transfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 value) internal whenNotPaused {
219         require(account != address(0), "ERC20: burn from the zero address");
220 
221         _totalSupply = _totalSupply.sub(value);
222         _balances[account] = _balances[account].sub(value);
223         emit Transfer(account, address(0), value);
224     }
225 
226     function _approve(address owner, address spender, uint256 value) internal whenNotPaused {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = value;
231         emit Approval(owner, spender, value);
232     }
233 
234     function _burnFrom(address account, uint256 amount) internal whenNotPaused {
235         _burn(account, amount);
236         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
237     }
238 
239 string private _name;
240     string private _symbol;
241     uint8 private _decimals;
242 
243       function name() public view returns (string memory) {
244         return _name;
245     }
246     function symbol() public view returns (string memory) {
247         return _symbol;
248     }
249 
250     function decimals() public view returns (uint8) {
251         return _decimals;
252     }
253 }