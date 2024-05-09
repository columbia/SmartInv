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
41   
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46 
47     uint256 c = a * b;
48     require(c / a == b);
49 
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     require(b > 0);
55     uint256 c = a / b;
56 
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b <= a);
62     uint256 c = a - b;
63 
64     return c;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     require(c >= a);
70 
71     return c;
72   }
73 
74   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b != 0);
76     return a % b;
77   }
78 }
79 
80 contract ERC20 is IERC20 {
81   using SafeMath for uint256;
82 
83   mapping (address => uint256) private _balances;
84 
85   mapping (address => mapping (address => uint256)) private _allowed;
86 
87   string private _name = 'Pay Base Chain';
88   
89   string private _symbol = 'PBC';
90   
91   uint8 private _decimals = 18;
92 
93   uint256 private _totalSupply;
94   
95   constructor () public {
96       _mint(msg.sender, 80000000000 ether);
97   }
98   
99   function name() public view returns (string) {
100       return _name;
101   }
102   
103   function symbol() public view returns (string) {
104       return _symbol;
105   }
106   
107   function decimals() public view returns (uint8) {
108       return _decimals;
109   }
110 
111   function totalSupply() public view returns (uint256) {
112     return _totalSupply;
113   }
114 
115   function balanceOf(address owner) public view returns (uint256) {
116     return _balances[owner];
117   }
118 
119   function allowance(
120     address owner,
121     address spender
122    )
123     public
124     view
125     returns (uint256)
126   {
127     return _allowed[owner][spender];
128   }
129 
130   function transfer(address to, uint256 value) public returns (bool) {
131     _transfer(msg.sender, to, value);
132     return true;
133   }
134 
135   function approve(address spender, uint256 value) public returns (bool) {
136     require(spender != address(0));
137 
138     _allowed[msg.sender][spender] = value;
139     emit Approval(msg.sender, spender, value);
140     return true;
141   }
142 
143   function transferFrom(
144     address from,
145     address to,
146     uint256 value
147   )
148     public
149     returns (bool)
150   {
151     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
152     _transfer(from, to, value);
153     return true;
154   }
155 
156   function increaseAllowance(
157     address spender,
158     uint256 addedValue
159   )
160     public
161     returns (bool)
162   {
163     require(spender != address(0));
164 
165     _allowed[msg.sender][spender] = (
166       _allowed[msg.sender][spender].add(addedValue));
167     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
168     return true;
169   }
170 
171   function decreaseAllowance(
172     address spender,
173     uint256 subtractedValue
174   )
175     public
176     returns (bool)
177   {
178     require(spender != address(0));
179 
180     _allowed[msg.sender][spender] = (
181       _allowed[msg.sender][spender].sub(subtractedValue));
182     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
183     return true;
184   }
185 
186   function _transfer(address from, address to, uint256 value) internal {
187     require(to != address(0));
188 
189     _balances[from] = _balances[from].sub(value);
190     _balances[to] = _balances[to].add(value);
191     emit Transfer(from, to, value);
192   }
193 
194   function _mint(address account, uint256 value) internal {
195     require(account != address(0));
196 
197     _totalSupply = _totalSupply.add(value);
198     _balances[account] = _balances[account].add(value);
199     emit Transfer(address(0), account, value);
200   }
201 
202   function _burn(address account, uint256 value) internal {
203     require(account != address(0));
204 
205     _totalSupply = _totalSupply.sub(value);
206     _balances[account] = _balances[account].sub(value);
207     emit Transfer(account, address(0), value);
208   }
209 
210   function _burnFrom(address account, uint256 value) internal {
211     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
212     _burn(account, value);
213   }
214 }