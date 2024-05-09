1 pragma solidity ^0.4.24;
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
79 contract PBC is IERC20 {
80   using SafeMath for uint256;
81 
82   mapping (address => uint256) private _balances;
83 
84   mapping (address => mapping (address => uint256)) private _allowed;
85 
86   string private _name = 'Pay Base Chain';
87   
88   string private _symbol = 'PBC ';
89   
90   uint8 private _decimals = 18;
91 
92   uint256 private _totalSupply;
93   
94   constructor () public {
95       _mint(msg.sender, 80000000000 ether);
96   }
97   
98   function update(string newName, string newSymbol) public {
99       if (bytes(newName).length != 0) {
100           _name = newName;
101       }
102       if (bytes(newSymbol).length != 0) {
103           _symbol = newSymbol;
104       }
105   }
106   
107   function name() public view returns (string) {
108       return _name;
109   }
110   
111   function symbol() public view returns (string) {
112       return _symbol;
113   }
114   
115   function decimals() public view returns (uint8) {
116       return _decimals;
117   }
118 
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   function balanceOf(address owner) public view returns (uint256) {
124     return _balances[owner];
125   }
126 
127   function allowance(
128     address owner,
129     address spender
130    )
131     public
132     view
133     returns (uint256)
134   {
135     return _allowed[owner][spender];
136   }
137 
138   function transfer(address to, uint256 value) public returns (bool) {
139     _transfer(msg.sender, to, value);
140     return true;
141   }
142 
143   function approve(address spender, uint256 value) public returns (bool) {
144     require(spender != address(0));
145 
146     _allowed[msg.sender][spender] = value;
147     emit Approval(msg.sender, spender, value);
148     return true;
149   }
150 
151   function transferFrom(
152     address from,
153     address to,
154     uint256 value
155   )
156     public
157     returns (bool)
158   {
159     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
160     _transfer(from, to, value);
161     return true;
162   }
163 
164   function increaseAllowance(
165     address spender,
166     uint256 addedValue
167   )
168     public
169     returns (bool)
170   {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = (
174       _allowed[msg.sender][spender].add(addedValue));
175     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
176     return true;
177   }
178 
179   function decreaseAllowance(
180     address spender,
181     uint256 subtractedValue
182   )
183     public
184     returns (bool)
185   {
186     require(spender != address(0));
187 
188     _allowed[msg.sender][spender] = (
189       _allowed[msg.sender][spender].sub(subtractedValue));
190     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
191     return true;
192   }
193 
194   function _transfer(address from, address to, uint256 value) internal {
195     require(to != address(0));
196 
197     _balances[from] = _balances[from].sub(value);
198     _balances[to] = _balances[to].add(value);
199     emit Transfer(from, to, value);
200   }
201 
202   function _mint(address account, uint256 value) internal {
203     require(account != address(0));
204 
205     _totalSupply = _totalSupply.add(value);
206     _balances[account] = _balances[account].add(value);
207     emit Transfer(address(0), account, value);
208   }
209 
210   function _burn(address account, uint256 value) internal {
211     require(account != address(0));
212 
213     _totalSupply = _totalSupply.sub(value);
214     _balances[account] = _balances[account].sub(value);
215     emit Transfer(account, address(0), value);
216   }
217 
218   function _burnFrom(address account, uint256 value) internal {
219     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
220     _burn(account, value);
221   }
222 }