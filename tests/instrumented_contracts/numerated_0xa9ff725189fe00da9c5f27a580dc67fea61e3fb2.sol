1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function add(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a + b;
12     assert(c >= a);
13     return c;
14   }
15 }
16 
17 contract ERC20Basic {
18   // events
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 
21   // public functions
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address addr) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25 }
26 
27 contract ERC20 is ERC20Basic {
28   // events
29   event Approval(address indexed owner, address indexed agent, uint256 value);
30 
31   // public functions
32   function allowance(address owner, address agent) public view returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool);
34   function approve(address agent, uint256 value) public returns (bool);
35 
36 }
37 
38 
39 contract Ownable {
40 
41   // public variables
42   address public owner;
43 
44   // events
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipTransferred(owner, address(0));
60     owner = address(0);
61   }
62 
63   function setOwner(address _owner) internal {
64     owner = _owner;
65     emit OwnershipTransferred(address(0), owner);
66   }
67 }
68 
69 
70 contract Freezer {
71 
72   address freezer;
73 
74 
75   modifier onlyFreezer() {
76     require(msg.sender == freezer);
77     _;
78   }
79 
80   function transferFreezership(address newFreezer) public onlyFreezer {
81     require(newFreezer != address(0));
82     freezer = newFreezer;
83   }
84 
85   function renounceFreezership() public onlyFreezer {
86     freezer = address(0);
87   }
88 
89   function setFreezer(address _freezer) internal {
90     freezer = _freezer;
91   }
92 }
93 
94 
95 contract Freezeable is Freezer {
96   // public variables
97 
98   // internal variables
99   mapping(address => bool) _freezeList;
100 
101   // events
102   event Freezed(address indexed freezedAddr);
103   event UnFreezed(address indexed unfreezedAddr);
104 
105   // public functions
106   function freeze(address addr) public onlyFreezer returns (bool) {
107     require(true != _freezeList[addr]);
108 
109     _freezeList[addr] = true;
110 
111     emit Freezed(addr);
112     return true;
113   }
114 
115   function unfreeze(address addr) public onlyFreezer returns (bool) {
116     require(true == _freezeList[addr]);
117 
118     _freezeList[addr] = false;
119 
120     emit UnFreezed(addr);
121     return true;
122   }
123 
124   modifier whenNotFreezed() {
125     require(true != _freezeList[msg.sender]);
126     _;
127   }
128 
129   function isFreezed(address addr) public view returns (bool) {
130     if (true == _freezeList[addr]) {
131       return true;
132     } else {
133       return false;
134     }
135   }
136   // internal functions
137 }
138 
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   // public variables
143   string public name;
144   string public symbol;
145   uint8 public decimals = 18;
146 
147   // internal variables
148   uint256 _totalSupply;
149   mapping(address => uint256) _balances;
150 
151   // events
152 
153   // public functions
154   function totalSupply() public view returns (uint256) {
155     return _totalSupply;
156   }
157 
158   function balanceOf(address addr) public view returns (uint256 balance) {
159     return _balances[addr];
160   }
161 
162   function transfer(address to, uint256 value) public returns (bool) {
163     require(to != address(0));
164     require(value <= _balances[msg.sender]);
165 
166     _balances[msg.sender] = _balances[msg.sender].sub(value);
167     _balances[to] = _balances[to].add(value);
168     emit Transfer(msg.sender, to, value);
169     return true;
170   }
171 
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175   // public variables
176 
177   // internal variables
178   mapping (address => mapping (address => uint256)) _allowances;
179 
180   // events
181 
182   // public functions
183   function transferFrom(address from, address to, uint256 value) public returns (bool) {
184     require(to != address(0));
185     require(value <= _balances[from]);
186     require(value <= _allowances[from][msg.sender]);
187 
188     _balances[from] = _balances[from].sub(value);
189     _balances[to] = _balances[to].add(value);
190     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
191     emit Transfer(from, to, value);
192     return true;
193   }
194 
195   function approve(address agent, uint256 value) public returns (bool) {
196     _allowances[msg.sender][agent] = value;
197     emit Approval(msg.sender, agent, value);
198     return true;
199   }
200 
201   function allowance(address owner, address agent) public view returns (uint256) {
202     return _allowances[owner][agent];
203   }
204 
205   function increaseApproval(address agent, uint value) public returns (bool) {
206     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
207     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
208     return true;
209   }
210 
211   function decreaseApproval(address agent, uint value) public returns (bool) {
212     uint allowanceValue = _allowances[msg.sender][agent];
213     if (value > allowanceValue) {
214       _allowances[msg.sender][agent] = 0;
215     } else {
216       _allowances[msg.sender][agent] = allowanceValue.sub(value);
217     }
218     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
219     return true;
220   }
221   // internal functions
222 }
223 
224 contract FreezeableToken is StandardToken, Freezeable, Ownable {
225   // public variables
226 
227   // internal variables
228 
229   // events
230 
231   // public functions
232   function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {
233     require(true != _freezeList[to]);
234     return super.transfer(to, value);
235   }
236 
237   function transferFrom(address from, address to, uint256 value) public returns (bool) {
238     require(true != _freezeList[from]);
239     require(true != _freezeList[to]);
240     return super.transferFrom(from, to, value);
241   }
242 
243   function approve(address agent, uint256 value) public whenNotFreezed returns (bool) {
244     require(true != _freezeList[agent]);
245     return super.approve(agent, value);
246   }
247 
248   function increaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
249     require(true != _freezeList[agent]);
250     return super.increaseApproval(agent, value);
251   }
252 
253   function decreaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
254     require(true != _freezeList[agent]);
255     return super.decreaseApproval(agent, value);
256   }
257 
258   // internal functions
259 }
260 
261 contract ArmorsToken is FreezeableToken {
262   // public variables
263   string public name = "Armors Token";
264   string public symbol = "ARM";
265   uint8 public decimals = 18;
266 
267   // public functions
268   constructor(address _owner) public {
269     _totalSupply = 21000000000 * (10 ** uint256(decimals));
270     
271     _balances[_owner] = _totalSupply;
272     emit Transfer(0x0, _owner, _totalSupply);
273 
274     setOwner(_owner);
275     setFreezer(_owner);
276   }
277 }