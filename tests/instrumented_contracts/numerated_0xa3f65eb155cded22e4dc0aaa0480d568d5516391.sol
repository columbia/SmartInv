1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.7;
7 
8 library SafeMath {
9     
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b <= a, "SafeMath: subtraction overflow");
17         uint256 c = a - b;
18         return c;
19     }
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21        if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26         return c;
27     }
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0, "SafeMath: modulo by zero");
38         return a % b;
39     }
40 }
41 
42 interface IBEP20 {
43     
44     function totalSupply() external view returns (uint256);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 contract ShibariumToken is IBEP20 {
55     using SafeMath for uint256;
56 
57        modifier onlyOwner() {
58         require(msg.sender==owner, "Only Call by Owner");
59         _;
60     }
61 
62     address public owner;
63 
64     constructor () {
65 
66         _name="Shibarium Token";
67         _symbol="SHIBARIUM";
68         _decimals=18;
69         owner=msg.sender;
70         _mint(msg.sender,(1000000000*(10**18)));
71         _paused = false;
72     }
73 
74     // 
75     // 
76 
77     /**
78      * @dev Emitted when the pause is triggered by `account`.
79      */
80     event Paused(address account);
81 
82     /**
83      * @dev Emitted when the pause is lifted by `account`.
84      */
85     event Unpaused(address account);
86 
87     bool private _paused;
88 
89     /**
90      * @dev Initializes the contract in unpaused state.
91      */
92  
93 
94       
95 
96 
97     /**
98      * @dev Returns true if the contract is paused, and false otherwise.
99      */
100     function paused() public view virtual returns (bool) {
101         return _paused;
102     }
103 
104     /**
105      * @dev Modifier to make a function callable only when the contract is not paused.
106      *
107      * Requirements:
108      *
109      * - The contract must not be paused.
110      */
111     modifier whenNotPaused() {
112         require(!paused(), "Pausable: paused");
113         _;
114     }
115 
116     /**
117      * @dev Modifier to make a function callable only when the contract is paused.
118      *
119      * Requirements:
120      *
121      * - The contract must be paused.
122      */
123     modifier whenPaused() {
124         require(paused(), "Pausable: not paused");
125         _;
126     }
127 
128     /**
129      * @dev Triggers stopped state.
130      *
131      * Requirements:
132      *
133      * - The contract must not be paused.
134      */
135     function _pause() internal virtual whenNotPaused {
136         _paused = true;
137         emit Paused(msg.sender);
138     }
139 
140     /**
141      * @dev Returns to normal state.
142      *
143      * Requirements:
144      *
145      * - The contract must be paused.
146      */
147     function _unpause() internal virtual whenPaused {
148         _paused = false;
149         emit Unpaused(msg.sender);
150     }
151 
152     function pauseContract() public onlyOwner{
153         _pause();
154 
155     }
156     function unpauseContract() public onlyOwner{
157         _unpause();
158 
159     }
160 
161 //         
162     // 
163 
164     mapping (address => uint256) private _balances;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     uint256 private _totalSupply;
167     function totalSupply() public view override returns (uint256) {
168         return _totalSupply;
169     }
170     function balanceOf(address account) public view override returns (uint256) {
171         return _balances[account];
172     }
173 
174     function transfer(address recipient, uint256 amount) public whenNotPaused override returns (bool) {
175         _transfer(msg.sender, recipient, amount);
176         return true;
177     }
178     function allowance(address owner, address spender) public view override returns (uint256) {
179         return _allowances[owner][spender];
180     }
181 
182     function approve(address spender, uint256 value) public override returns (bool) {
183         _approve(msg.sender, spender, value);
184         return true;
185     }
186      
187     function transferownership(address _newonwer) public onlyOwner{
188         owner=_newonwer;
189     }
190 
191     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused override returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
194         return true;
195     }
196     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
197         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
202         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
203         return true;
204     }
205 
206     function _transfer(address sender, address recipient, uint256 amount) internal whenNotPaused {
207         require(sender != address(0), "ERC20: transfer from the zero address");
208         require(recipient != address(0), "ERC20: transfer to the zero address");
209 
210         _balances[sender] = _balances[sender].sub(amount);
211         _balances[recipient] = _balances[recipient].add(amount);
212         emit Transfer(sender, recipient, amount);
213     }
214     function _mint(address account, uint256 amount) internal {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _totalSupply = _totalSupply.add(amount);
218         _balances[account] = _balances[account].add(amount);
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _burn(address account, uint256 value) internal whenNotPaused {
223         require(account != address(0), "ERC20: burn from the zero address");
224 
225         _totalSupply = _totalSupply.sub(value);
226         _balances[account] = _balances[account].sub(value);
227         emit Transfer(account, address(0), value);
228     }
229 
230     function _approve(address owner, address spender, uint256 value) internal whenNotPaused {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = value;
235         emit Approval(owner, spender, value);
236     }
237 
238     function _burnFrom(address account, uint256 amount) internal whenNotPaused {
239         _burn(account, amount);
240         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
241     }
242 
243 string private _name;
244     string private _symbol;
245     uint8 private _decimals;
246 
247       function name() public view returns (string memory) {
248         return _name;
249     }
250     function symbol() public view returns (string memory) {
251         return _symbol;
252     }
253 
254     function decimals() public view returns (uint8) {
255         return _decimals;
256     }
257 }