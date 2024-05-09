1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6       if (a == 0) {
7       return 0;
8     }
9 
10     uint256 c = a * b;
11     require(c / a == b);
12 
13     return c;
14   }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     require(b > 0); // Solidity only automatically asserts when dividing by 0
18     uint256 c = a / b;
19 
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b <= a);
25     uint256 c = a - b;
26 
27     return c;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     require(c >= a);
33 
34     return c;
35   }
36 
37   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b != 0);
39     return a % b;
40   }
41 }
42 
43 interface IERC20 {
44   function totalSupply() external view returns (uint256);
45 
46   function balanceOf(address who) external view returns (uint256);
47 
48   function allowance(address owner, address spender)
49     external view returns (uint256);
50 
51   function transfer(address to, uint256 value) external returns (bool);
52 
53   function approve(address spender, uint256 value)
54     external returns (bool);
55 
56   function transferFrom(address from, address to, uint256 value)
57     external returns (bool);
58 
59   event Transfer(
60     address indexed from,
61     address indexed to,
62     uint256 value
63   );
64 
65   event Approval(
66     address indexed owner,
67     address indexed spender,
68     uint256 value
69   );
70 }
71 
72 contract ERC20 is IERC20 {
73   using SafeMath for uint256;
74 
75   mapping (address => uint256) private _balances;
76 
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   uint256 private _totalSupply;
80 
81   function totalSupply() public view returns (uint256) {
82     return _totalSupply;
83   }
84 
85   function balanceOf(address owner) public view returns (uint256) {
86     return _balances[owner];
87   }
88 
89   function allowance(
90     address owner,
91     address spender
92    )
93     public
94     view
95     returns (uint256)
96   {
97     return _allowed[owner][spender];
98   }
99 
100   function transfer(address to, uint256 value) public returns (bool) {
101     require(value <= _balances[msg.sender]);
102     require(to != address(0));
103 
104     _balances[msg.sender] = _balances[msg.sender].sub(value);
105     _balances[to] = _balances[to].add(value);
106     emit Transfer(msg.sender, to, value);
107     return true;
108   }
109 
110   function approve(address spender, uint256 value) public returns (bool) {
111     require(spender != address(0));
112 
113     _allowed[msg.sender][spender] = value;
114     emit Approval(msg.sender, spender, value);
115     return true;
116   }
117 
118   function transferFrom(
119     address from,
120     address to,
121     uint256 value
122   )
123     public
124     returns (bool)
125   {
126     require(value <= _balances[from]);
127     require(value <= _allowed[from][msg.sender]);
128     require(to != address(0));
129 
130     _balances[from] = _balances[from].sub(value);
131     _balances[to] = _balances[to].add(value);
132     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
133     emit Transfer(from, to, value);
134     return true;
135   }
136 
137   function increaseAllowance(
138     address spender,
139     uint256 addedValue
140   )
141     public
142     returns (bool)
143   {
144     require(spender != address(0));
145 
146     _allowed[msg.sender][spender] = (
147       _allowed[msg.sender][spender].add(addedValue));
148     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
149     return true;
150   }
151 
152   function decreaseAllowance(
153     address spender,
154     uint256 subtractedValue
155   )
156     public
157     returns (bool)
158   {
159     require(spender != address(0));
160 
161     _allowed[msg.sender][spender] = (
162       _allowed[msg.sender][spender].sub(subtractedValue));
163     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
164     return true;
165   }
166 
167   function _mint(address account, uint256 amount) internal {
168     require(account != 0);
169     _totalSupply = _totalSupply.add(amount);
170     _balances[account] = _balances[account].add(amount);
171     emit Transfer(address(0), account, amount);
172   }
173 
174   function _burn(address account, uint256 amount) internal {
175     require(account != 0);
176     require(amount <= _balances[account]);
177 
178     _totalSupply = _totalSupply.sub(amount);
179     _balances[account] = _balances[account].sub(amount);
180     emit Transfer(account, address(0), amount);
181   }
182 
183   function _burnFrom(address account, uint256 amount) internal {
184     require(amount <= _allowed[account][msg.sender]);
185     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
186       amount);
187     _burn(account, amount);
188   }
189 }
190 
191 contract ScamToken is ERC20 {
192 
193   string public constant name = "Scam_Token";
194   string public constant symbol = "SCAM";
195   uint8 public constant decimals = 18;
196 
197   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
198 
199   constructor() public {
200     _mint(msg.sender, INITIAL_SUPPLY);
201   }
202 
203 }