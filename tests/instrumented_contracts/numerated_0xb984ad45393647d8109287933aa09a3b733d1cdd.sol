1 pragma solidity 0.4.25;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract ERC20Detailed is IERC20 {
33   string private _name;
34   string private _symbol;
35   uint8 private _decimals;
36 
37   constructor(string name, string symbol, uint8 decimals) public {
38     _name = name;
39     _symbol = symbol;
40     _decimals = decimals;
41   }
42 
43   function name() public view returns(string) {
44     return _name;
45   }
46 
47   function symbol() public view returns(string) {
48     return _symbol;
49   }
50 
51   function decimals() public view returns(uint8) {
52     return _decimals;
53   }
54 }
55 
56 library SafeMath {
57 
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60       return 0;
61     }
62 
63     uint256 c = a * b;
64     require(c / a == b);
65 
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b > 0);
71     uint256 c = a / b;
72 
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     require(b <= a);
78     uint256 c = a - b;
79 
80     return c;
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0);
92     return a % b;
93   }
94 }
95 
96 contract ERC20 is IERC20 {
97   using SafeMath for uint256;
98 
99   mapping (address => uint256) private _balances;
100 
101   mapping (address => mapping (address => uint256)) private _allowed;
102 
103   uint256 private _totalSupply;
104 
105   function totalSupply() public view returns (uint256) {
106     return _totalSupply;
107   }
108 
109   function balanceOf(address owner) public view returns (uint256) {
110     return _balances[owner];
111   }
112 
113   function allowance(
114     address owner,
115     address spender
116    )
117     public
118     view
119     returns (uint256)
120   {
121     return _allowed[owner][spender];
122   }
123 
124   function transfer(address to, uint256 value) public returns (bool) {
125     require(value <= _balances[msg.sender]);
126     require(to != address(0));
127 
128     _balances[msg.sender] = _balances[msg.sender].sub(value);
129     _balances[to] = _balances[to].add(value);
130     emit Transfer(msg.sender, to, value);
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
150     require(value <= _balances[from]);
151     require(value <= _allowed[from][msg.sender]);
152     require(to != address(0));
153 
154     _balances[from] = _balances[from].sub(value);
155     _balances[to] = _balances[to].add(value);
156     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
157     emit Transfer(from, to, value);
158     return true;
159   }
160 
161   function increaseAllowance(
162     address spender,
163     uint256 addedValue
164   )
165     public
166     returns (bool)
167   {
168     require(spender != address(0));
169 
170     _allowed[msg.sender][spender] = (
171       _allowed[msg.sender][spender].add(addedValue));
172     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173     return true;
174   }
175 
176   function decreaseAllowance(
177     address spender,
178     uint256 subtractedValue
179   )
180     public
181     returns (bool)
182   {
183     require(spender != address(0));
184 
185     _allowed[msg.sender][spender] = (
186       _allowed[msg.sender][spender].sub(subtractedValue));
187     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
188     return true;
189   }
190 
191   function _mint(address account, uint256 amount) internal {
192     require(account != 0);
193     _totalSupply = _totalSupply.add(amount);
194     _balances[account] = _balances[account].add(amount);
195     emit Transfer(address(0), account, amount);
196   }
197 
198   function _burn(address account, uint256 amount) internal {
199     require(account != 0);
200     require(amount <= _balances[account]);
201 
202     _totalSupply = _totalSupply.sub(amount);
203     _balances[account] = _balances[account].sub(amount);
204     emit Transfer(account, address(0), amount);
205   }
206 
207   function _burnFrom(address account, uint256 amount) internal {
208     require(amount <= _allowed[account][msg.sender]);
209 
210     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
211       amount);
212     _burn(account, amount);
213   }
214 }
215 
216 contract OrtPlus is ERC20, ERC20Detailed {
217     constructor()
218         ERC20Detailed("Orientum Plus", "ORT+", 18)
219         ERC20()
220 
221         public
222     {
223         uint256 _amount = 40000000000;
224         uint256 totalSupply = _amount.mul(10 ** uint256(18));
225         _mint(msg.sender, totalSupply);
226     }
227 }