1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2020-09-02
6  */
7 
8 /**
9  * Name: Ercau X
10  * Symbol: RAUX
11  * Max Supply: 1000000
12  * Deployed to: 
13  * Website: www.ercau.com | https://www.ercau.com
14  */
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26 
27     function sub(
28         uint256 a,
29         uint256 b,
30         string memory errorMessage
31     ) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function transfer(address recipient, uint256 amount)
44         external
45         returns (bool);
46 
47     function allowance(address owner, address spender)
48         external
49         view
50         returns (uint256);
51 
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     function transferFrom(
55         address sender,
56         address recipient,
57         uint256 amount
58     ) external returns (bool);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(
62         address indexed owner,
63         address indexed spender,
64         uint256 value
65     );
66 }
67 
68 abstract contract Context {
69     function _msgSender() internal virtual view returns (address payable) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal virtual view returns (bytes memory) {
74         this;
75         return msg.data;
76     }
77 }
78 
79 contract ErcauX is Context, IERC20 {
80     uint256 public constant ONE = 1e18;
81     using SafeMath for uint256;
82     mapping(address => uint256) private _balances;
83     mapping(address => mapping(address => uint256)) private _allowances;
84     uint256 private constant _totalSupply = 1e6 * ONE;
85 
86     constructor() public {
87         _balances[msg.sender] = _totalSupply;
88     }
89 
90     function name() public pure returns (string memory) {
91         return "ErcauX";
92     }
93 
94     function symbol() public pure returns (string memory) {
95         return "RAUX";
96     }
97 
98     function decimals() public pure returns (uint8) {
99         return 18;
100     }
101 
102     function totalSupply() public override view returns (uint256) {
103         return _totalSupply;
104     }
105 
106     function balanceOf(address account) public override view returns (uint256) {
107         return _balances[account];
108     }
109 
110     function transfer(address recipient, uint256 amount)
111         public
112         virtual
113         override
114         returns (bool)
115     {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119 
120     function allowance(address owner, address spender)
121         public
122         virtual
123         override
124         view
125         returns (uint256)
126     {
127         return _allowances[owner][spender];
128     }
129 
130     function approve(address spender, uint256 amount)
131         public
132         virtual
133         override
134         returns (bool)
135     {
136         _approve(_msgSender(), spender, amount);
137         return true;
138     }
139 
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) public virtual override returns (bool) {
145         _transfer(sender, recipient, amount);
146         _approve(
147             sender,
148             _msgSender(),
149             _allowances[sender][_msgSender()].sub(
150                 amount,
151                 "ERC20: transfer amount exceeds allowance"
152             )
153         );
154         return true;
155     }
156 
157     function increaseAllowance(address spender, uint256 addedValue)
158         public
159         virtual
160         returns (bool)
161     {
162         _approve(
163             _msgSender(),
164             spender,
165             _allowances[_msgSender()][spender].add(addedValue)
166         );
167         return true;
168     }
169 
170     function decreaseAllowance(address spender, uint256 subtractedValue)
171         public
172         virtual
173         returns (bool)
174     {
175         _approve(
176             _msgSender(),
177             spender,
178             _allowances[_msgSender()][spender].sub(
179                 subtractedValue,
180                 "ERC20: decreased allowance below zero"
181             )
182         );
183         return true;
184     }
185 
186     function _transfer(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) internal virtual {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193 
194         _balances[sender] = _balances[sender].sub(
195             amount,
196             "ERC20: transfer amount exceeds balance"
197         );
198         _balances[recipient] = _balances[recipient].add(amount);
199         emit Transfer(sender, recipient, amount);
200     }
201 
202     function _approve(
203         address owner,
204         address spender,
205         uint256 amount
206     ) internal virtual {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209 
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 }