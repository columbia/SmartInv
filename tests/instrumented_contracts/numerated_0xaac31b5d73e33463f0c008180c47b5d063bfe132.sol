1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address private _owner;
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() internal {
83     _owner = msg.sender;
84     emit OwnershipTransferred(address(0), _owner);
85   }
86 
87   /**
88    * @return the address of the owner.
89    */
90   function owner() public view returns(address) {
91     return _owner;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(isOwner());
99     _;
100   }
101 
102   /**
103    * @return true if `msg.sender` is the owner of the contract.
104    */
105   function isOwner() public view returns(bool) {
106     return msg.sender == _owner;
107   }
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) public onlyOwner {
114     _transferOwnership(newOwner);
115   }
116 
117   /**
118    * @dev Transfers control of the contract to a newOwner.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function _transferOwnership(address newOwner) internal {
122     require(newOwner != address(0));
123     emit OwnershipTransferred(_owner, newOwner);
124     _owner = newOwner;
125   }
126 }
127 
128 
129 contract Pausable is Ownable {
130   event Pause();
131   event Unpause();
132   bool public paused = false;
133 
134   modifier whenNotPaused() {
135       require(!paused);
136       _;
137   }
138 
139   modifier whenPaused() {
140       require(paused);
141       _;
142   }
143 
144   function pause() onlyOwner whenNotPaused public {
145       paused = true;
146       emit Pause();
147   }
148 
149   function unpause() onlyOwner whenPaused public {
150       paused = false;
151       emit Unpause();
152   }
153 }
154 
155 
156 contract Freezable is Ownable{
157   mapping (address => bool) public frozenAccount;
158     
159   event FrozenFunds(address target, bool frozen);
160     
161   modifier whenUnfrozen(address target) {
162     require(!frozenAccount[target]);
163     _;
164   }
165   
166   function freezeAccount(address target, bool freeze) onlyOwner public{
167     frozenAccount[target] = freeze;
168     emit FrozenFunds(target, freeze);
169   }
170 }
171 
172 contract XERC20 is Pausable, Freezable {
173   using SafeMath for uint256;
174 
175   mapping (address => uint256) private _balances;
176 
177   mapping (address => mapping (address => uint256)) private _allowed;
178 
179   uint256 private _totalSupply;
180 
181   event Transfer(address indexed from, address indexed to, uint256 value);
182 
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184   
185   event Burn(address account, uint256 value);
186   
187   function burn(address account, uint256 value) external onlyOwner returns (bool) {
188     _burn(account, value);
189     emit Burn(account, value);
190     return true;
191   }
192 
193   function totalSupply() public view returns (uint256) {
194     return _totalSupply;
195   }
196 
197   function balanceOf(address owner) public view returns (uint256) {
198     return _balances[owner];
199   }
200 
201   function allowance(address owner, address spender) public view returns (uint256) {
202     return _allowed[owner][spender];
203   }
204 
205   function transfer(address to, uint256 value) public whenNotPaused whenUnfrozen(msg.sender) returns (bool) {
206     _transfer(msg.sender, to, value);
207     return true;
208   }
209 
210   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
211     require(spender != address(0));
212     _allowed[msg.sender][spender] = value;
213     emit Approval(msg.sender, spender, value);
214     return true;
215   }
216 
217   function transferFrom(address from, address to, uint256 value) public whenNotPaused whenUnfrozen(from) returns (bool) {
218     require(value <= _allowed[from][msg.sender]);
219     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
220     _transfer(from, to, value);
221     return true;
222   }
223 
224   function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns(bool)
225   {
226     require(spender != address(0));
227     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
228     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
229     return true;
230   }
231 
232   function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns(bool) {
233     require(spender != address(0));
234     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
235     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
236     return true;
237   }
238 
239   function _transfer(address from, address to, uint256 value) internal {
240     require(value <= _balances[from]);
241     require(to != address(0));
242     _balances[from] = _balances[from].sub(value);
243     _balances[to] = _balances[to].add(value);
244     emit Transfer(from, to, value);
245   }
246 
247   function _mint(address account, uint256 value) internal {
248     require(account != 0);
249     _totalSupply = _totalSupply.add(value);
250     _balances[account] = _balances[account].add(value);
251     emit Transfer(address(0), account, value);
252   }
253 
254   function _burn(address account, uint256 value) internal {
255     require(account != 0);
256     require(value <= _balances[account]);
257     _totalSupply = _totalSupply.sub(value);
258     _balances[account] = _balances[account].sub(value);
259     emit Transfer(account, address(0), value);
260   }
261 
262   function _burnFrom(address account, uint256 value) internal {
263     require(value <= _allowed[account][msg.sender]);
264     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
265     _burn(account, value);
266   }
267 
268 }
269 
270 
271 contract UCXToken is XERC20 {
272   string public constant name = "UCXToken";
273   string public constant symbol = "UCX";
274   uint8 public constant decimals = 18;
275   uint256 public constant INITIAL_SUPPLY = 2100000000 * (10 ** uint256(decimals));
276 
277   address address1 = 0x777721dEe44137F84D016D9B8f4D5F654CE5c777;
278   address address2 = 0x7770533000cB5CF3f55a20caF22c60438F867777;
279   address address3 = 0x7772082428388bd2007822FaDedF33697fF3e777;
280   address address4 = 0x777036867957eEE02181157093131CAE6D2fd777;
281   address address5 = 0x7776BdF1d3db7536e12143785cD107FdF2cF6777;
282   address address6 = 0x7778211a82cDC694c59Dd7451e3FE17E14987777;
283   address address7 = 0x777775152FA83fb685d114A6B1302432A4ff8777;
284   address address8 = 0x7770ae1b5e71b5FccF1eA236C5CD069850817777;
285   address address9 = 0x7776312f8d9aDd9542F4C4a343cC55fBB3bf1777;
286   address address10 = 0x7773951672A5A097bAF3AC40bc425066a00d7777;
287   address address11 = 0x7771232DDd8d5a4d93Ea958C7B99611B2fe17777;
288   address address12 = 0x7778B8b23b7D872e02afb9A7413d103775dC5777;
289 
290   constructor() public {
291     _mint(msg.sender, INITIAL_SUPPLY);
292 
293     transfer(address1, 255000000 * (10 ** uint256(decimals)));
294     transfer(address2, 34000000 * (10 ** uint256(decimals)));
295     transfer(address3, 34000000 * (10 ** uint256(decimals)));
296     transfer(address4, 34000000 * (10 ** uint256(decimals)));
297     transfer(address5, 34000000 * (10 ** uint256(decimals)));
298     transfer(address6, 34000000 * (10 ** uint256(decimals)));
299     transfer(address7, 340000000 * (10 ** uint256(decimals)));
300     transfer(address8, 510000000 * (10 ** uint256(decimals)));
301     transfer(address9, 170000000 * (10 ** uint256(decimals)));
302     transfer(address10, 170000000 * (10 ** uint256(decimals)));
303     transfer(address11, 85000000 * (10 ** uint256(decimals)));
304     transfer(address12, 400000000 * (10 ** uint256(decimals)));
305 
306     freezeAccount(address12,true);
307   }
308 
309 }