1 pragma solidity >=0.7.0 <0.9.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 interface IERC20 {
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address to, uint256 value) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 value) external returns (bool);
21     function transferFrom(address from, address to, uint256 value) external returns (bool);
22 }
23 
24 interface IERC20Metadata is IERC20 {
25     function name() external view returns (string memory);
26     function symbol() external view returns (string memory);
27     function decimals() external view returns (uint8);
28 }
29 
30 interface IERC20Errors {
31     error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
32     error ERC20InvalidSender(address sender);
33     error ERC20InvalidReceiver(address receiver);
34     error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
35     error ERC20InvalidApprover(address approver);
36     error ERC20InvalidSpender(address spender);
37 }
38 
39 abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
40     mapping(address => uint256) private _balances;
41 
42     mapping(address => mapping(address => uint256)) private _allowances;
43 
44     uint256 private _totalSupply;
45 
46     string private _name;
47     string private _symbol;
48     uint8 private _decimals;
49 
50     error ERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);
51 
52 
53     constructor() {
54         _name = "TrueEuro";
55         _symbol = "TEURO";
56 		_decimals = 18;
57     }
58 
59     function name() public view virtual returns (string memory) {
60         return _name;
61     }
62 
63     function symbol() public view virtual returns (string memory) {
64         return _symbol;
65     }
66 
67     function decimals() public view virtual returns (uint8) {
68         return _decimals;
69     }
70 
71     function totalSupply() public view virtual returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address account) public view virtual returns (uint256) {
76         return _balances[account];
77     }
78 
79     function transfer(address to, uint256 value) public virtual returns (bool) {
80         address owner = _msgSender();
81         _transfer(owner, to, value);
82         return true;
83     }
84 
85     function allowance(address owner, address spender) public view virtual returns (uint256) {
86         return _allowances[owner][spender];
87     }
88 
89     function approve(address spender, uint256 value) public virtual returns (bool) {
90         address owner = _msgSender();
91         _approve(owner, spender, value);
92         return true;
93     }
94 
95     function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
96         address spender = _msgSender();
97         _spendAllowance(from, spender, value);
98         _transfer(from, to, value);
99         return true;
100     }
101 
102     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
103         address owner = _msgSender();
104         _approve(owner, spender, allowance(owner, spender) + addedValue);
105         return true;
106     }
107 
108     function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
109         address owner = _msgSender();
110         uint256 currentAllowance = allowance(owner, spender);
111         if (currentAllowance < requestedDecrease) {
112             revert ERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
113         }
114         unchecked {
115             _approve(owner, spender, currentAllowance - requestedDecrease);
116         }
117 
118         return true;
119     }
120 
121     function _transfer(address from, address to, uint256 value) internal {
122         if (from == address(0)) {
123             revert ERC20InvalidSender(address(0));
124         }
125         if (to == address(0)) {
126             revert ERC20InvalidReceiver(address(0));
127         }
128         _update(from, to, value);
129     }
130 
131     function _update(address from, address to, uint256 value) internal virtual {
132         if (from == address(0)) {
133             // Overflow check required: The rest of the code assumes that totalSupply never overflows
134             _totalSupply += value;
135         } else {
136             uint256 fromBalance = _balances[from];
137             if (fromBalance < value) {
138                 revert ERC20InsufficientBalance(from, fromBalance, value);
139             }
140             unchecked {
141                 // Overflow not possible: value <= fromBalance <= totalSupply.
142                 _balances[from] = fromBalance - value;
143             }
144         }
145 
146         if (to == address(0)) {
147             unchecked {
148                 // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
149                 _totalSupply -= value;
150             }
151         } else {
152             unchecked {
153                 // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
154                 _balances[to] += value;
155             }
156         }
157 
158         emit Transfer(from, to, value);
159     }
160 
161     function _mint(address account, uint256 value) internal {
162         if (account == address(0)) {
163             revert ERC20InvalidReceiver(address(0));
164         }
165         _update(address(0), account, value);
166     }
167 
168     function _burn(address account, uint256 value) internal {
169         if (account == address(0)) {
170             revert ERC20InvalidSender(address(0));
171         }
172         _update(account, address(0), value);
173     }
174 
175     function _approve(address owner, address spender, uint256 value) internal virtual {
176         _approve(owner, spender, value, true);
177     }
178 
179     function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
180         if (owner == address(0)) {
181             revert ERC20InvalidApprover(address(0));
182         }
183         if (spender == address(0)) {
184             revert ERC20InvalidSpender(address(0));
185         }
186         _allowances[owner][spender] = value;
187         if (emitEvent) {
188             emit Approval(owner, spender, value);
189         }
190     }
191 
192     function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
193         uint256 currentAllowance = allowance(owner, spender);
194         if (currentAllowance != type(uint256).max) {
195             if (currentAllowance < value) {
196                 revert ERC20InsufficientAllowance(spender, currentAllowance, value);
197             }
198             unchecked {
199                 _approve(owner, spender, currentAllowance - value, false);
200             }
201         }
202     }
203 }
204 
205 contract TrueEuro is ERC20 {
206 
207     constructor(
208         uint256 totalSupply_,
209         address to
210     ) ERC20() {
211         _mint(to, totalSupply_);
212     }
213 	
214 }