1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-01-31
7 */
8 
9 pragma solidity ^0.4.23;
10 
11 library SafeMath {
12 
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract ERC20Basic {
26   // events
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 
29   // public functions
30   function totalSupply() public view returns (uint256);
31   function balanceOf(address addr) public view returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33 }
34 
35 contract ERC20 is ERC20Basic {
36   // events
37   event Approval(address indexed owner, address indexed agent, uint256 value);
38 
39   // public functions
40   function allowance(address owner, address agent) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address agent, uint256 value) public returns (bool);
43 
44 }
45 
46 
47 contract Ownable {
48 
49   // public variables
50   address public owner;
51 
52   // events
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   function transferOwnership(address newOwner) public onlyOwner {
61     require(newOwner != address(0));
62     emit OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 
66   function renounceOwnership() public onlyOwner {
67     emit OwnershipTransferred(owner, address(0));
68     owner = address(0);
69   }
70 
71   function setOwner(address _owner) internal {
72     owner = _owner;
73     emit OwnershipTransferred(address(0), owner);
74   }
75 }
76 
77 
78 contract Freezer {
79 
80   address freezer;
81 
82 
83   modifier onlyFreezer() {
84     require(msg.sender == freezer);
85     _;
86   }
87 
88   function transferFreezership(address newFreezer) public onlyFreezer {
89     require(newFreezer != address(0));
90     freezer = newFreezer;
91   }
92 
93   function renounceFreezership() public onlyFreezer {
94     freezer = address(0);
95   }
96 
97   function setFreezer(address _freezer) internal {
98     freezer = _freezer;
99   }
100 }
101 
102 
103 contract Freezeable is Freezer {
104   // public variables
105 
106   // internal variables
107   mapping(address => bool) _freezeList;
108 
109   // events
110   event Freezed(address indexed freezedAddr);
111   event UnFreezed(address indexed unfreezedAddr);
112 
113   // public functions
114   function freeze(address addr) public onlyFreezer returns (bool) {
115     require(true != _freezeList[addr]);
116 
117     _freezeList[addr] = true;
118 
119     emit Freezed(addr);
120     return true;
121   }
122 
123   function unfreeze(address addr) public onlyFreezer returns (bool) {
124     require(true == _freezeList[addr]);
125 
126     _freezeList[addr] = false;
127 
128     emit UnFreezed(addr);
129     return true;
130   }
131 
132   modifier whenNotFreezed() {
133     require(true != _freezeList[msg.sender]);
134     _;
135   }
136 
137   function isFreezed(address addr) public view returns (bool) {
138     if (true == _freezeList[addr]) {
139       return true;
140     } else {
141       return false;
142     }
143   }
144   // internal functions
145 }
146 
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   // public variables
151   string public name;
152   string public symbol;
153   uint8 public decimals = 18;
154 
155   // internal variables
156   uint256 _totalSupply;
157   mapping(address => uint256) _balances;
158 
159   // events
160 
161   // public functions
162   function totalSupply() public view returns (uint256) {
163     return _totalSupply;
164   }
165 
166   function balanceOf(address addr) public view returns (uint256 balance) {
167     return _balances[addr];
168   }
169 
170   function transfer(address to, uint256 value) public returns (bool) {
171     require(to != address(0));
172     require(value <= _balances[msg.sender]);
173 
174     _balances[msg.sender] = _balances[msg.sender].sub(value);
175     _balances[to] = _balances[to].add(value);
176     emit Transfer(msg.sender, to, value);
177     return true;
178   }
179 
180 }
181 
182 contract StandardToken is ERC20, BasicToken {
183   // public variables
184 
185   // internal variables
186   mapping (address => mapping (address => uint256)) _allowances;
187 
188   // events
189 
190   // public functions
191   function transferFrom(address from, address to, uint256 value) public returns (bool) {
192     require(to != address(0));
193     require(value <= _balances[from]);
194     require(value <= _allowances[from][msg.sender]);
195 
196     _balances[from] = _balances[from].sub(value);
197     _balances[to] = _balances[to].add(value);
198     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
199     emit Transfer(from, to, value);
200     return true;
201   }
202 
203   function approve(address agent, uint256 value) public returns (bool) {
204     _allowances[msg.sender][agent] = value;
205     emit Approval(msg.sender, agent, value);
206     return true;
207   }
208 
209   function allowance(address owner, address agent) public view returns (uint256) {
210     return _allowances[owner][agent];
211   }
212 
213   function increaseApproval(address agent, uint value) public returns (bool) {
214     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
215     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
216     return true;
217   }
218 
219   function decreaseApproval(address agent, uint value) public returns (bool) {
220     uint allowanceValue = _allowances[msg.sender][agent];
221     if (value > allowanceValue) {
222       _allowances[msg.sender][agent] = 0;
223     } else {
224       _allowances[msg.sender][agent] = allowanceValue.sub(value);
225     }
226     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
227     return true;
228   }
229   // internal functions
230 }
231 
232 contract FreezeableToken is StandardToken, Freezeable, Ownable {
233   // public variables
234 
235   // internal variables
236 
237   // events
238 
239   // public functions
240   function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {
241     require(true != _freezeList[to]);
242     return super.transfer(to, value);
243   }
244 
245   function transferFrom(address from, address to, uint256 value) public returns (bool) {
246     require(true != _freezeList[from]);
247     require(true != _freezeList[to]);
248     return super.transferFrom(from, to, value);
249   }
250 
251   function approve(address agent, uint256 value) public whenNotFreezed returns (bool) {
252     require(true != _freezeList[agent]);
253     return super.approve(agent, value);
254   }
255 
256   function increaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
257     require(true != _freezeList[agent]);
258     return super.increaseApproval(agent, value);
259   }
260 
261   function decreaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
262     require(true != _freezeList[agent]);
263     return super.decreaseApproval(agent, value);
264   }
265 
266   // internal functions
267 }
268 
269 contract CPTToken is FreezeableToken {
270   // public variables
271   string public name = "CPT Token";
272   string public symbol = "CPT";
273   uint8 public decimals = 18;
274 
275   // public functions
276   constructor(address _owner, address _freezer) public {
277     _totalSupply = 2100000 * (10 ** uint256(decimals));
278 
279     _balances[_owner] = _totalSupply;
280     emit Transfer(0x0, _owner, _totalSupply);
281 
282     setOwner(_owner);
283     setFreezer(_freezer);
284   }
285 }