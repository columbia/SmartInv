1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4     
5   function name() external view returns (string);
6   
7   function symbol() external view returns (string);
8   
9   function decimals() external view returns (uint8);
10 
11   function totalSupply() external view returns (uint256);
12 
13   function balanceOf(address who) external view returns (uint256);
14 
15   function allowance(address owner, address spender)
16     external view returns (uint256);
17 
18   function transfer(address to, uint256 value) external returns (bool);
19 
20   function approve(address spender, uint256 value)
21     external returns (bool);
22 
23   function transferFrom(address from, address to, uint256 value)
24     external returns (bool);
25 
26   event Transfer(
27     address indexed from,
28     address indexed to,
29     uint256 value
30   );
31 
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 library SafeMath {
40 
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45 
46     uint256 c = a * b;
47     require(c / a == b);
48 
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     require(b > 0);
54     uint256 c = a / b;
55 
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     require(c >= a);
69 
70     return c;
71   }
72 
73   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b != 0);
75     return a % b;
76   }
77 }
78 
79 contract NPX is IERC20 {
80   using SafeMath for uint256;
81 
82   mapping (address => uint256) private _balances;
83 
84   mapping (address => mapping (address => uint256)) private _allowed;
85 
86   string private _name = 'NapoleonX';
87   
88   string private _symbol = 'NPX';
89   
90   uint8 private _decimals = 18;
91 
92   uint256 private _totalSupply;
93   
94   constructor () public {
95       _mint(msg.sender, 29800000 ether);
96   }
97   
98   function name() public view returns (string) {
99       return _name;
100   }
101   
102   function symbol() public view returns (string) {
103       return _symbol;
104   }
105   
106   function decimals() public view returns (uint8) {
107       return _decimals;
108   }
109 
110   function totalSupply() public view returns (uint256) {
111     return _totalSupply;
112   }
113 
114   function balanceOf(address owner) public view returns (uint256) {
115     return _balances[owner];
116   }
117 
118   function allowance(
119     address owner,
120     address spender
121    )
122     public
123     view
124     returns (uint256)
125   {
126     return _allowed[owner][spender];
127   }
128 
129   function transfer(address to, uint256 value) public returns (bool) {
130     _transfer(msg.sender, to, value);
131     return true;
132   }
133 
134   function approve(address spender, uint256 value) public returns (bool) {
135     require(spender != address(0));
136 
137     _allowed[msg.sender][spender] = value;
138     emit Approval(msg.sender, spender, value);
139     return true;
140   }
141 
142   function transferFrom(
143     address from,
144     address to,
145     uint256 value
146   )
147     public
148     returns (bool)
149   {
150     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
151     _transfer(from, to, value);
152     return true;
153   }
154 
155   function increaseAllowance(
156     address spender,
157     uint256 addedValue
158   )
159     public
160     returns (bool)
161   {
162     require(spender != address(0));
163 
164     _allowed[msg.sender][spender] = (
165       _allowed[msg.sender][spender].add(addedValue));
166     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
167     return true;
168   }
169 
170   function decreaseAllowance(
171     address spender,
172     uint256 subtractedValue
173   )
174     public
175     returns (bool)
176   {
177     require(spender != address(0));
178 
179     _allowed[msg.sender][spender] = (
180       _allowed[msg.sender][spender].sub(subtractedValue));
181     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
182     return true;
183   }
184 
185   function _transfer(address from, address to, uint256 value) internal {
186     require(to != address(0));
187 
188     _balances[from] = _balances[from].sub(value);
189     _balances[to] = _balances[to].add(value);
190     emit Transfer(from, to, value);
191   }
192 
193   function _mint(address account, uint256 value) internal {
194     require(account != address(0));
195 
196     _totalSupply = _totalSupply.add(value);
197     _balances[account] = _balances[account].add(value);
198     emit Transfer(address(0), account, value);
199   }
200 
201   function _burn(address account, uint256 value) internal {
202     require(account != address(0));
203 
204     _totalSupply = _totalSupply.sub(value);
205     _balances[account] = _balances[account].sub(value);
206     emit Transfer(account, address(0), value);
207   }
208 
209   function _burnFrom(address account, uint256 value) internal {
210     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
211     _burn(account, value);
212   }
213 }