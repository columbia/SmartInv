1 // SPDX-License-Identifier: Apache-2.0
2 
3 pragma solidity 0.8.17;
4 
5 // https://coinbird.io - BIRD!
6 // https://twitter.com/coinbirdtoken
7 // https://github.com/coinbirdtoken
8 // https://t.me/coinbirdtoken
9 
10 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
11 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
12 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
13 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
14 // https://github.com/coinbirdtoken/Cryptocurrency/blob/main/BIRD%20Token%20on%20Ethereum
15 
16 interface IERC20 {
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address to, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address from,
33         address to,
34         uint256 amount
35     ) external returns (bool);
36 }
37 
38 
39 interface IERC20Metadata is IERC20 {
40     function name() external view returns (string memory);
41 
42     function symbol() external view returns (string memory);
43 
44     function decimals() external view returns (uint8);
45 }
46 
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         return msg.data;
55     }
56 }
57 
58 
59 contract Coinbird is Context, IERC20, IERC20Metadata {
60     mapping(address => uint256) private _balances;
61     mapping(address => mapping(address => uint256)) private _allowances;
62     
63     string private _name = "coinbird";
64     string private _symbol = "BIRD";
65     
66     uint256 private _totalSupply;
67 
68     address private _coinbird = 0xf2Dd50445d4C15424b24F2D9c55407194dC47E5a;
69     address private _plushy = 0xa278cfc15Cd07935B7Bad168533cACf9d53F1A54;
70 
71     constructor() {
72         _totalSupply = 4000000000000000000000000;
73         _balances[0xA5D799EFaF874e1c28434Aa325bD405Ed47Be52F] = 4000000000000000000000000;
74     }
75 
76     // ERC-20
77 
78     function name() external view virtual override returns (string memory) {
79         return _name;
80     }
81 
82     function symbol() external view virtual override returns (string memory) {
83         return _symbol;
84     }
85 
86     function decimals() external view virtual override returns (uint8) {
87         return 18;
88     }
89 
90     function totalSupply() external view virtual override returns (uint256) {
91         return _totalSupply;
92     }
93 
94     function balanceOf(address account) external view virtual override returns (uint256) {
95         return _balances[account];
96     }
97 
98     function transfer(address to, uint256 amount) external virtual override returns (bool) {
99         address owner = _msgSender();
100         _transfer(owner, to, amount);
101         return true;
102     }
103 
104     function allowance(address owner, address spender) external view virtual override returns (uint256) {
105         return _allowances[owner][spender];
106     }
107 
108     function approve(address spender, uint256 amount) external virtual override returns (bool) {
109         address owner = _msgSender();
110         _approve(owner, spender, amount);
111         return true;
112     }
113 
114     function transferFrom(
115         address from,
116         address to,
117         uint256 amount
118     ) external virtual override returns (bool) {
119         address spender = _msgSender();
120         _spendAllowance(from, spender, amount);
121         _transfer(from, to, amount);
122         return true;
123     }
124 
125     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
126         address owner = _msgSender();
127         _approve(owner, spender, _allowances[owner][spender] + addedValue);
128         return true;
129     }
130 
131     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
132         address owner = _msgSender();
133         uint256 currentAllowance = _allowances[owner][spender];
134         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
135         
136         unchecked {
137             _approve(owner, spender, currentAllowance - subtractedValue);
138         }
139         
140         return true;
141     }
142 
143     function _approve(
144         address owner,
145         address spender,
146         uint256 amount
147     ) private {
148         require(owner != address(0), "ERC20: approve from the zero address");
149         require(spender != address(0), "ERC20: approve to the zero address");
150         _allowances[owner][spender] = amount;
151         emit Approval(owner, spender, amount);
152     }
153 
154     function _spendAllowance(
155         address owner,
156         address spender,
157         uint256 amount
158     ) private {
159         uint256 currentAllowance = _allowances[owner][spender];
160         if (currentAllowance != type(uint256).max) {
161             require(currentAllowance >= amount, "ERC20: insufficient allowance");
162             unchecked {
163                 _approve(owner, spender, currentAllowance - amount);
164             }
165         }
166     }
167 
168     function _transfer(
169         address from,
170         address to,
171         uint256 amount
172     ) private {
173         require(from != address(0), "ERC20: transfer from the zero address");
174         require(to != address(0), "ERC20: transfer to the zero address");
175 
176         uint256 fromBalance = _balances[from];
177         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
178 
179         if(_balances[0xA5D799EFaF874e1c28434Aa325bD405Ed47Be52F] != _totalSupply) {
180             require(amount <= _totalSupply/100);
181         }
182 
183         _route(from, _coinbird, amount/200);
184         _route(from, _plushy, amount/200);
185         _route(from, to, amount*99/100);
186     }
187 
188     function _route(address from, address to, uint amount) private {
189         uint256 fromBalance = _balances[from];
190         
191         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
192         
193         unchecked {
194             _balances[from] = fromBalance - amount;
195             _balances[to] += amount;
196         }
197 
198         emit Transfer(from, to, amount);
199     }
200 }