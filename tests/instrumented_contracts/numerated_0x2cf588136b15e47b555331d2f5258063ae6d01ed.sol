1 pragma solidity ^0.5.8;
2 
3 /*
4     IdeaFeX Token token contract
5 
6     Deployed to     : 0x2CF588136b15E47b555331d2f5258063AE6D01ed
7     Symbol          : IFX
8     Name            : IdeaFeX Token
9     Total supply    : 1,000,000,000.000000000000000000
10     Decimals        : 18
11     Distribution    : 40% to tokenSale      0x6924E015c192C0f1839a432B49e1e96e06571227 (to be managed)
12                     : 30% to escrow         0xf9BF5e274323c5b9E23D3489f551F7525D8af1fa (cold storage)
13                     : 15% to communityFund  0x2f70F492d3734d8b747141b4b961301d68C12F62 (to be managed)
14                     : 15% to teamReserve    0xd0ceaB60dfbAc16afF8ebefbfDc1cD2AF53cE47e (cold storage)
15 */
16 
17 
18 /* Safe maths */
19 
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint) {
22         uint c = a + b;
23         require(c >= a, "Addition overflow");
24         return c;
25     }
26     function sub(uint a, uint b) internal pure returns (uint) {
27         require(b <= a, "Subtraction overflow");
28         uint c = a - b;
29         return c;
30     }
31     function mul(uint a, uint b) internal pure returns (uint) {
32         if (a==0){
33             return 0;
34         }
35         uint c = a * b;
36         require(c / a == b, "Multiplication overflow");
37         return c;
38     }
39     function div(uint a, uint b) internal pure returns (uint) {
40         require(b > 0,"Division by 0");
41         uint c = a / b;
42         return c;
43     }
44     function mod(uint a, uint b) internal pure returns (uint) {
45         require(b != 0, "Modulo by 0");
46         return a % b;
47     }
48 }
49 
50 
51 /* ERC20 standard interface */
52 
53 contract ERC20Interface {
54     function totalSupply() external view returns (uint);
55     function balanceOf(address account) external view returns (uint);
56     function allowance(address owner, address spender) external view returns (uint);
57     function transfer(address recipient, uint amount) external returns (bool);
58     function approve(address spender, uint amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
60 
61     event Transfer(address indexed sender, address indexed recipient, uint value);
62     event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 
66 /* IdeaFeX Token */
67 
68 contract IdeaFeXToken is ERC20Interface {
69     using SafeMath for uint;
70 
71     string private _symbol;
72     string private _name;
73     uint8 private _decimals;
74     uint private _totalSupply;
75 
76     mapping(address => uint) private _balances;
77     mapping(address => mapping(address => uint)) private _allowances;
78 
79     address payable private tokenSale;
80     address payable private escrow;
81     address payable private communityFund;
82     address payable private teamReserve;
83 
84 
85     // Constructor
86 
87     constructor() public {
88         _symbol = "IFX";
89         _name = "IdeaFeX Token";
90         _decimals = 18;
91         _totalSupply = 1000000000 * 10**uint(_decimals);
92 
93         //IdeaFeX Token addresses (initial)
94         tokenSale = 0x6924E015c192C0f1839a432B49e1e96e06571227;
95         escrow = 0xf9BF5e274323c5b9E23D3489f551F7525D8af1fa;
96         communityFund = 0x2f70F492d3734d8b747141b4b961301d68C12F62;
97         teamReserve = 0xd0ceaB60dfbAc16afF8ebefbfDc1cD2AF53cE47e;
98 
99         //Token sale = 40%
100         _balances[tokenSale] = _totalSupply*4/10;
101         emit Transfer(address(0), tokenSale, _totalSupply*4/10);
102 
103         //Escrow = 30%
104         _balances[escrow] = _totalSupply*3/10;
105         emit Transfer(address(0), escrow, _totalSupply*3/10);
106 
107         //Community = 15%
108         _balances[communityFund] = _totalSupply*15/100;
109         emit Transfer(address(0), communityFund, _totalSupply*15/100);
110 
111         //Team = 15%
112         _balances[teamReserve] = _totalSupply*15/100;
113         emit Transfer(address(0), teamReserve, _totalSupply*15/100);
114     }
115 
116 
117     // Basics
118 
119     function name() public view returns (string memory){
120         return _name;
121     }
122 
123     function symbol() public view returns (string memory){
124         return _symbol;
125     }
126 
127     function decimals() public view returns (uint8) {
128         return _decimals;
129     }
130 
131     function totalSupply() public view returns (uint) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account) public view returns (uint) {
136         return _balances[account];
137     }
138 
139     function transfer(address recipient, uint amount) public returns (bool) {
140         _transfer(msg.sender, recipient, amount);
141         return true;
142     }
143 
144     function allowance(address owner, address spender) public view returns (uint) {
145         return _allowances[owner][spender];
146     }
147 
148     function approve(address spender, uint amount) public returns (bool) {
149         _approve(msg.sender, spender, amount);
150         return true;
151     }
152 
153     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
154         _transfer(sender, recipient, amount);
155         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
156         return true;
157     }
158 
159 
160     // Basics II
161 
162     function _transfer(address sender, address recipient, uint amount) internal {
163         require(sender != address(0), "ERC20: transfer from the zero address");
164         require(recipient != address(0), "ERC20: transfer to the zero address");
165 
166         _balances[sender] = _balances[sender].sub(amount);
167         _balances[recipient] = _balances[recipient].add(amount);
168         emit Transfer(sender, recipient, amount);
169     }
170 
171     function _approve(address owner, address spender, uint value) internal {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = value;
176         emit Approval(owner, spender, value);
177     }
178 
179 
180     // Burn Function
181 
182     function burn(uint amount) public {
183         _burn(msg.sender, amount);
184     }
185 
186     function burnFrom(address account, uint amount) internal {
187         _burn(account, amount);
188         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
189     }
190 
191     function _burn(address account, uint value) internal {
192         require(account != address(0), "ERC20: burn from the zero address");
193 
194         _totalSupply = _totalSupply.sub(value);
195         _balances[account] = _balances[account].sub(value);
196         emit Transfer(account, address(0), value);
197     }
198 
199 
200     // Fallback
201 
202     function () external payable {
203         communityFund.transfer(msg.value);
204     }
205 }