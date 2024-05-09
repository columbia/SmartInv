1 pragma solidity 0.5.0;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9 
10     uint256 c = a * b;
11     require(c / a == b);
12 
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     require(b > 0);
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
43 
44 contract Ownable {
45   address private _owner;
46 
47   event OwnershipTransferred(
48     address indexed previousOwner,
49     address indexed newOwner
50   );
51 
52   constructor() internal {
53     _owner = msg.sender;
54     emit OwnershipTransferred(address(0), _owner);
55   }
56 
57   function owner() public view returns(address) {
58     return _owner;
59   }
60 
61   modifier onlyOwner() {
62     require(isOwner());
63     _;
64   }
65 
66   function isOwner() public view returns(bool) {
67     return msg.sender == _owner;
68   }
69 
70   function renounceOwnership() public onlyOwner {
71     emit OwnershipTransferred(_owner, address(0));
72     _owner = address(0);
73   }
74 
75   function transferOwnership(address newOwner) public onlyOwner {
76     _transferOwnership(newOwner);
77   }
78 
79   function _transferOwnership(address newOwner) internal {
80     require(newOwner != address(0));
81 
82     emit OwnershipTransferred(_owner, newOwner);
83     _owner = newOwner;
84   }
85 }
86 
87 
88 interface IERC20 {
89   function totalSupply() external view returns (uint256);
90 
91   function balanceOf(address who) external view returns (uint256);
92 
93   function allowance(address owner, address spender)
94     external view returns (uint256);
95 
96   function transfer(address to, uint256 value) external returns (bool);
97 
98   function approve(address spender, uint256 value)
99     external returns (bool);
100 
101   function transferFrom(address from, address to, uint256 value)
102     external returns (bool);
103 
104   event Transfer(
105     address indexed from,
106     address indexed to,
107     uint256 value
108   );
109 
110   event Approval(
111     address indexed owner,
112     address indexed spender,
113     uint256 value
114   );
115 }
116 
117 
118 contract ERC20 is IERC20 {
119   using SafeMath for uint256;
120 
121   mapping (address => uint256) private _balances;
122 
123   mapping (address => mapping (address => uint256)) private _allowed;
124 
125   uint256 private _totalSupply;
126 
127   function totalSupply() public view returns (uint256) {
128     return _totalSupply;
129   }
130 
131   function balanceOf(address owner) public view returns (uint256) {
132     return _balances[owner];
133   }
134 
135   function allowance(address owner, address spender) public view returns (uint256) {
136     return _allowed[owner][spender];
137   }
138 
139   function transfer(address to, uint256 value) public returns (bool) {
140     _transfer(msg.sender, to, value);
141     return true;
142   }
143 
144   function approve(address spender, uint256 value) public returns (bool) {
145     require(spender != address(0));
146 
147     _allowed[msg.sender][spender] = value;
148     emit Approval(msg.sender, spender, value);
149     return true;
150   }
151 
152   function transferFrom(address from, address to, uint256 value) public returns (bool) {
153     require(value <= _allowed[from][msg.sender]);
154 
155     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
156     _transfer(from, to, value);
157     return true;
158   }
159 
160   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
161     require(spender != address(0));
162 
163     _allowed[msg.sender][spender] = (
164       _allowed[msg.sender][spender].add(addedValue));
165     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
166     return true;
167   }
168 
169   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
170     require(spender != address(0));
171 
172     _allowed[msg.sender][spender] = (
173       _allowed[msg.sender][spender].sub(subtractedValue));
174     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
175     return true;
176   }
177 
178   function _transfer(address from, address to, uint256 value) internal {
179     require(value <= _balances[from]);
180     require(to != address(0));
181 
182     _balances[from] = _balances[from].sub(value);
183     _balances[to] = _balances[to].add(value);
184     emit Transfer(from, to, value);
185   }
186 
187   function _mint(address account, uint256 value) internal {
188     require(account != address(0));
189 
190     _totalSupply = _totalSupply.add(value);
191     _balances[account] = _balances[account].add(value);
192     emit Transfer(address(0), account, value);
193   }
194 
195   function _burn(address account, uint256 value) internal {
196     require(account != address(0));
197     require(value <= _balances[account]);
198 
199     _totalSupply = _totalSupply.sub(value);
200     _balances[account] = _balances[account].sub(value);
201     emit Transfer(account, address(0), value);
202   }
203 
204   function _burnFrom(address account, uint256 value) internal {
205     require(value <= _allowed[account][msg.sender]);
206 
207     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
208     _burn(account, value);
209   }
210 }
211 
212 
213 contract FOURINABAD is ERC20, Ownable {
214   using SafeMath for uint256;
215 
216   uint256 private constant INITIAL_SUPPLY = 10000000000;
217 
218   string public constant name = "FOURINABAD";
219   string public constant symbol = "FIAB";
220   uint8 public constant decimals = 18;
221 
222   constructor() public {
223     uint256 initialSupply = INITIAL_SUPPLY * (10 ** uint256(decimals));
224     require(initialSupply > 0);
225 
226     _mint(msg.sender, initialSupply);
227   }
228 
229   function mint(uint256 value) public onlyOwner returns (bool) {
230     _mint(msg.sender, value);
231 
232     return true;
233   }
234 
235   function burn(uint256 value) public onlyOwner returns (bool) {
236     _burn(msg.sender, value);
237 
238     return true;
239   }
240 
241   // don't accept eth
242   function () external payable {
243     if (msg.value > 0) {
244       revert();
245     }
246   }
247 }