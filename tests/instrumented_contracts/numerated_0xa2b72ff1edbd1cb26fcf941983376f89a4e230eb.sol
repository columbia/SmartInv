1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-31
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 library SafeMath {
8 
9   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10     assert(b <= a);
11     return a - b;
12   }
13 
14   function add(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 }
20 
21 contract ERC20Basic {
22   // events
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 
25   // public functions
26   function totalSupply() public view returns (uint256);
27   function balanceOf(address addr) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29 }
30 
31 contract ERC20 is ERC20Basic {
32   // events
33   event Approval(address indexed owner, address indexed agent, uint256 value);
34 
35   // public functions
36   function allowance(address owner, address agent) public view returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address agent, uint256 value) public returns (bool);
39 
40 }
41 
42 
43 contract Ownable {
44 
45   // public variables
46   address public owner;
47 
48   // events
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 
62   function renounceOwnership() public onlyOwner {
63     emit OwnershipTransferred(owner, address(0));
64     owner = address(0);
65   }
66 
67   function setOwner(address _owner) internal {
68     owner = _owner;
69     emit OwnershipTransferred(address(0), owner);
70   }
71 }
72 
73 
74 contract Freezer {
75 
76   address freezer;
77 
78 
79   modifier onlyFreezer() {
80     require(msg.sender == freezer);
81     _;
82   }
83 
84   function transferFreezership(address newFreezer) public onlyFreezer {
85     require(newFreezer != address(0));
86     freezer = newFreezer;
87   }
88 
89   function renounceFreezership() public onlyFreezer {
90     freezer = address(0);
91   }
92 
93   function setFreezer(address _freezer) internal {
94     freezer = _freezer;
95   }
96 }
97 
98 
99 contract Freezeable is Freezer {
100   // public variables
101 
102   // internal variables
103   mapping(address => bool) _freezeList;
104 
105   // events
106   event Freezed(address indexed freezedAddr);
107   event UnFreezed(address indexed unfreezedAddr);
108 
109   // public functions
110   function freeze(address addr) public onlyFreezer returns (bool) {
111     require(true != _freezeList[addr]);
112 
113     _freezeList[addr] = true;
114 
115     emit Freezed(addr);
116     return true;
117   }
118 
119   function unfreeze(address addr) public onlyFreezer returns (bool) {
120     require(true == _freezeList[addr]);
121 
122     _freezeList[addr] = false;
123 
124     emit UnFreezed(addr);
125     return true;
126   }
127 
128   modifier whenNotFreezed() {
129     require(true != _freezeList[msg.sender]);
130     _;
131   }
132 
133   function isFreezed(address addr) public view returns (bool) {
134     if (true == _freezeList[addr]) {
135       return true;
136     } else {
137       return false;
138     }
139   }
140   // internal functions
141 }
142 
143 contract BasicToken is ERC20Basic {
144   using SafeMath for uint256;
145 
146   // public variables
147   string public name;
148   string public symbol;
149   uint8 public decimals = 18;
150 
151   // internal variables
152   uint256 _totalSupply;
153   mapping(address => uint256) _balances;
154 
155   // events
156 
157   // public functions
158   function totalSupply() public view returns (uint256) {
159     return _totalSupply;
160   }
161 
162   function balanceOf(address addr) public view returns (uint256 balance) {
163     return _balances[addr];
164   }
165 
166   function transfer(address to, uint256 value) public returns (bool) {
167     require(to != address(0));
168     require(value <= _balances[msg.sender]);
169 
170     _balances[msg.sender] = _balances[msg.sender].sub(value);
171     _balances[to] = _balances[to].add(value);
172     emit Transfer(msg.sender, to, value);
173     return true;
174   }
175 
176 }
177 
178 contract StandardToken is ERC20, BasicToken {
179   // public variables
180 
181   // internal variables
182   mapping (address => mapping (address => uint256)) _allowances;
183 
184   // events
185 
186   // public functions
187   function transferFrom(address from, address to, uint256 value) public returns (bool) {
188     require(to != address(0));
189     require(value <= _balances[from]);
190     require(value <= _allowances[from][msg.sender]);
191 
192     _balances[from] = _balances[from].sub(value);
193     _balances[to] = _balances[to].add(value);
194     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
195     emit Transfer(from, to, value);
196     return true;
197   }
198 
199   function approve(address agent, uint256 value) public returns (bool) {
200     _allowances[msg.sender][agent] = value;
201     emit Approval(msg.sender, agent, value);
202     return true;
203   }
204 
205   function allowance(address owner, address agent) public view returns (uint256) {
206     return _allowances[owner][agent];
207   }
208 
209   function increaseApproval(address agent, uint value) public returns (bool) {
210     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
211     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
212     return true;
213   }
214 
215   function decreaseApproval(address agent, uint value) public returns (bool) {
216     uint allowanceValue = _allowances[msg.sender][agent];
217     if (value > allowanceValue) {
218       _allowances[msg.sender][agent] = 0;
219     } else {
220       _allowances[msg.sender][agent] = allowanceValue.sub(value);
221     }
222     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
223     return true;
224   }
225   // internal functions
226 }
227 
228 contract FreezeableToken is StandardToken, Freezeable, Ownable {
229   // public variables
230 
231   // internal variables
232 
233   // events
234 
235   // public functions
236   function transfer(address to, uint256 value) public whenNotFreezed returns (bool) {
237     require(true != _freezeList[to]);
238     return super.transfer(to, value);
239   }
240 
241   function transferFrom(address from, address to, uint256 value) public returns (bool) {
242     require(true != _freezeList[from]);
243     require(true != _freezeList[to]);
244     return super.transferFrom(from, to, value);
245   }
246 
247   function approve(address agent, uint256 value) public whenNotFreezed returns (bool) {
248     require(true != _freezeList[agent]);
249     return super.approve(agent, value);
250   }
251 
252   function increaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
253     require(true != _freezeList[agent]);
254     return super.increaseApproval(agent, value);
255   }
256 
257   function decreaseApproval(address agent, uint value) public whenNotFreezed returns (bool success) {
258     require(true != _freezeList[agent]);
259     return super.decreaseApproval(agent, value);
260   }
261 
262   // internal functions
263 }
264 
265 contract SAFTToken is FreezeableToken {
266   // public variables
267   string public name = "Safety Token";
268   string public symbol = "SAFT";
269   uint8 public decimals = 18;
270 
271   // public functions
272   constructor(address _owner) public {
273     _totalSupply = 21000000000 * (10 ** uint256(decimals));
274 
275     _balances[_owner] = _totalSupply;
276     emit Transfer(0x0, _owner, _totalSupply);
277 
278     setOwner(_owner);
279     setFreezer(_owner);
280   }
281 }