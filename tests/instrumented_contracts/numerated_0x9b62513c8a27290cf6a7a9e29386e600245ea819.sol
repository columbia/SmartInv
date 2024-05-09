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
44 interface IERC20 {
45   function totalSupply() external view returns (uint256);
46 
47   function balanceOf(address who) external view returns (uint256);
48 
49   function allowance(address owner, address spender)
50     external view returns (uint256);
51 
52   function transfer(address to, uint256 value) external returns (bool);
53 
54   function approve(address spender, uint256 value)
55     external returns (bool);
56 
57   function transferFrom(address from, address to, uint256 value)
58     external returns (bool);
59 
60   event Transfer(
61     address indexed from,
62     address indexed to,
63     uint256 value
64   );
65 
66   event Approval(
67     address indexed owner,
68     address indexed spender,
69     uint256 value
70   );
71 }
72 
73 
74 contract ERC20 is IERC20 {
75   using SafeMath for uint256;
76 
77   mapping (address => uint256) private _balances;
78 
79   mapping (address => mapping (address => uint256)) private _allowed;
80 
81   uint256 private _totalSupply;
82 
83   function totalSupply() public view returns (uint256) {
84     return _totalSupply;
85   }
86 
87   function balanceOf(address owner) public view returns (uint256) {
88     return _balances[owner];
89   }
90 
91   function allowance(address owner, address spender) public view returns (uint256) {
92     return _allowed[owner][spender];
93   }
94 
95   function transfer(address to, uint256 value) public returns (bool) {
96     _transfer(msg.sender, to, value);
97     return true;
98   }
99 
100   function approve(address spender, uint256 value) public returns (bool) {
101     require(spender != address(0));
102 
103     _allowed[msg.sender][spender] = value;
104     emit Approval(msg.sender, spender, value);
105     return true;
106   }
107 
108   function transferFrom(address from, address to, uint256 value) public returns (bool) {
109     require(value <= _allowed[from][msg.sender]);
110 
111     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
112     _transfer(from, to, value);
113     return true;
114   }
115 
116   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
117     require(spender != address(0));
118 
119     _allowed[msg.sender][spender] = (
120       _allowed[msg.sender][spender].add(addedValue));
121     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
122     return true;
123   }
124 
125   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
126     require(spender != address(0));
127 
128     _allowed[msg.sender][spender] = (
129       _allowed[msg.sender][spender].sub(subtractedValue));
130     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
131     return true;
132   }
133 
134   function _transfer(address from, address to, uint256 value) internal {
135     require(to != address(0));
136     require(value <= _balances[from]);
137 
138     _balances[from] = _balances[from].sub(value);
139     _balances[to] = _balances[to].add(value);
140     emit Transfer(from, to, value);
141   }
142 
143   function _mint(address account, uint256 value) internal {
144     require(account != address(0));
145 
146     _totalSupply = _totalSupply.add(value);
147     _balances[account] = _balances[account].add(value);
148     emit Transfer(address(0), account, value);
149   }
150 
151   function _burn(address account, uint256 value) internal {
152     require(account != address(0));
153     require(value <= _balances[account]);
154 
155     _totalSupply = _totalSupply.sub(value);
156     _balances[account] = _balances[account].sub(value);
157     emit Transfer(account, address(0), value);
158   }
159 
160   function _burnFrom(address account, uint256 value) internal {
161     require(value <= _allowed[account][msg.sender]);
162 
163     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
164     _burn(account, value);
165   }
166 }
167 
168 
169 contract Ownable {
170   address private _owner;
171 
172   event OwnershipTransferred(
173     address indexed previousOwner,
174     address indexed newOwner
175   );
176 
177   constructor() internal {
178     _owner = msg.sender;
179     emit OwnershipTransferred(address(0), _owner);
180   }
181 
182   function owner() public view returns(address) {
183     return _owner;
184   }
185 
186   modifier onlyOwner() {
187     require(isOwner());
188     _;
189   }
190 
191   function isOwner() public view returns(bool) {
192     return msg.sender == _owner;
193   }
194 
195   function transferOwnership(address newOwner) public onlyOwner {
196     _transferOwnership(newOwner);
197   }
198 
199   function _transferOwnership(address newOwner) internal {
200     require(newOwner != address(0));
201 
202     emit OwnershipTransferred(_owner, newOwner);
203     _owner = newOwner;
204   }
205 }
206 
207 
208 contract ContentsProtocolToken is ERC20, Ownable {
209   using SafeMath for uint256;
210 
211   uint256 private constant INITIAL_SUPPLY = 10000000000;
212 
213   string public constant name = "Contents Protocol Token";
214   string public constant symbol = "CPT";
215   uint8 public constant decimals = 18;
216 
217   constructor() public {
218     uint256 initialSupply = INITIAL_SUPPLY * (10 ** uint256(decimals));
219     require(initialSupply > 0);
220 
221     _mint(msg.sender, initialSupply);
222   }
223 
224   function mint(uint256 value) public onlyOwner returns (bool) {
225     _mint(msg.sender, value);
226 
227     return true;
228   }
229 
230   function burn(uint256 value) public onlyOwner returns (bool) {
231     _burn(msg.sender, value);
232 
233     return true;
234   }
235 
236   // don't accept eth
237   function () external payable {
238     if (msg.value > 0) {
239       revert();
240     }
241   }
242 }