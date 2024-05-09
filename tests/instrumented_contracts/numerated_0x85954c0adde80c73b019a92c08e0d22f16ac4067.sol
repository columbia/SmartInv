1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b > 0); 
15     uint256 c = a / b;
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     uint256 c = a - b;
21     return c;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26     return c;
27   }
28   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b != 0);
30     return a % b;
31   }
32 }
33 
34 library Roles {
35     
36   struct Role {
37     mapping (address => bool) bearer;
38   }
39   function add(Role storage role, address account) internal {
40     require(account != address(0));
41     require(!has(role, account));
42     role.bearer[account] = true;
43   }
44   function remove(Role storage role, address account) internal {
45     require(account != address(0));
46     require(has(role, account));
47     role.bearer[account] = false;
48   }
49   function has(Role storage role, address account) internal view returns (bool) {
50     require(account != address(0));
51     return role.bearer[account];
52   }
53 }
54 
55 contract Ownable {
56 
57   address private _owner;
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59   constructor() internal {
60     _owner = msg.sender;
61     emit OwnershipTransferred(address(0), _owner);
62   }
63   function owner() public view returns(address) {
64     return _owner;
65   }
66   modifier onlyOwner() {
67     require(isOwner());
68     _;
69   }
70   function isOwner() public view returns(bool) {
71     return msg.sender == _owner;
72   }
73   function renounceOwnership() public onlyOwner {
74     emit OwnershipTransferred(_owner, address(0));
75     _owner = address(0);
76   }
77   function transferOwnership(address newOwner) public onlyOwner {
78     _transferOwnership(newOwner);
79   }
80   function _transferOwnership(address newOwner) internal {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(_owner, newOwner);
83     _owner = newOwner;
84   }
85 }
86 
87 contract ERC223ReceivingContract {
88 
89     function tokenFallback(address _from, uint256 _value, bytes _data) public;
90 }
91 
92 interface IERC20 {
93     
94   function totalSupply() external view returns (uint256);
95   function balanceOf(address who) external view returns (uint256);
96   function allowance(address owner, address spender) external view returns (uint256);
97   function transfer(address to, uint256 value) external returns (bool);
98   function approve(address spender, uint256 value) external returns (bool);
99   function transferFrom(address from, address to, uint256 value) external returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 
102   //ERC223
103   function transfer(address to, uint256 value, bytes data) external returns (bool success);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 contract ERC20 is IERC20, Ownable {
108     
109   using SafeMath for uint256;
110   mapping (address => uint256) private _balances;
111   mapping (address => mapping (address => uint256)) private _allowed;
112   mapping (address => bool) public frozenAccount;
113   event frozenFunds(address account, bool freeze);
114   uint256 private _totalSupply;
115   function totalSupply() public view returns (uint256) {
116     return _totalSupply;
117   }
118   function balanceOf(address owner) public view returns (uint256) {
119     return _balances[owner];
120   }
121   function allowance(address owner, address spender) public view returns (uint256) {
122     return _allowed[owner][spender];
123   }
124   function transfer(address to, uint256 value) public returns (bool) {
125     _transfer(msg.sender, to, value);
126     return true;
127   }
128   //ERC223
129   function transfer(address to, uint256 value, bytes data) external returns (bool) {
130     require(transfer(to, value));
131 
132    uint codeLength;
133 
134    assembly {
135     // Retrieve the size of the code on target address, this needs assembly.
136     codeLength := extcodesize(to)
137   }
138 
139   if (codeLength > 0) {
140     ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
141     receiver.tokenFallback(msg.sender, value, data);
142     }
143   return true;
144   
145   }
146   function approve(address spender, uint256 value) public returns (bool) {
147     require(spender != address(0));
148     _allowed[msg.sender][spender] = value;
149     emit Approval(msg.sender, spender, value);
150     return true;
151   }
152   function transferFrom(address from, address to, uint256 value) public returns (bool) {
153     require(value <= _allowed[from][msg.sender]);
154     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
155     _transfer(from, to, value);
156     return true;
157   }
158   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
159     require(spender != address(0));
160     _allowed[msg.sender][spender] = (
161       _allowed[msg.sender][spender].add(addedValue));
162     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
163     return true;
164   }
165   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
166     require(spender != address(0));
167     _allowed[msg.sender][spender] = (
168       _allowed[msg.sender][spender].sub(subtractedValue));
169     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170     return true;
171   }
172   function _transfer(address from, address to, uint256 value) internal {
173     require(value <= _balances[from]);
174     require(to != address(0));
175     _balances[from] = _balances[from].sub(value);
176     _balances[to] = _balances[to].add(value);
177     emit Transfer(from, to, value);
178    require(!frozenAccount[msg.sender]);
179   }
180   function _issue(address account, uint256 value) internal {
181     require(account != 0);
182     _totalSupply = _totalSupply.add(value);
183     _balances[account] = _balances[account].add(value);
184     emit Transfer(address(0), account, value);
185   }
186   function _burn(address account, uint256 value) internal {
187     require(account != 0);
188     require(value <= _balances[account]);
189     _totalSupply = _totalSupply.sub(value);
190     _balances[account] = _balances[account].sub(value);
191     emit Transfer(account, address(0), value);
192   }
193   function _burnFrom(address account, uint256 value) internal {
194     require(value <= _allowed[account][msg.sender]);
195     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
196     _burn(account, value);
197   }
198 }
199 
200 contract PauserRole {
201     
202   using Roles for Roles.Role;
203   event PauserAdded(address indexed account);
204   event PauserRemoved(address indexed account);
205   Roles.Role private pausers;
206   constructor() internal {
207     _addPauser(msg.sender);
208   }
209   modifier onlyPauser() {
210     require(isPauser(msg.sender));
211     _;
212   }
213   function isPauser(address account) public view returns (bool) {
214     return pausers.has(account);
215   }
216   function addPauser(address account) public onlyPauser {
217     _addPauser(account);
218   }
219   function renouncePauser() public {
220     _removePauser(msg.sender);
221   }
222   function _addPauser(address account) internal {
223     pausers.add(account);
224     emit PauserAdded(account);
225   }
226   function _removePauser(address account) internal {
227     pausers.remove(account);
228     emit PauserRemoved(account);
229   }
230 }
231 
232 contract Pausable is PauserRole {
233     
234   event Paused(address account);
235   event Unpaused(address account);
236   bool private _paused;
237   constructor() internal {
238     _paused = false;
239   }
240   function paused() public view returns(bool) {
241     return _paused;
242   }
243   modifier whenNotPaused() {
244     require(!_paused);
245     _;
246   }
247   modifier whenPaused() {
248     require(_paused);
249     _;
250   }
251   function pause() public onlyPauser whenNotPaused {
252     _paused = true;
253     emit Paused(msg.sender);
254   }
255   function unpause() public onlyPauser whenPaused {
256     _paused = false;
257     emit Unpaused(msg.sender);
258   }
259 }
260 
261 contract ERC20Burnable is ERC20 {
262 
263   function burn(uint256 value) public {
264     _burn(msg.sender, value);
265   }
266   function burnFrom(address from, uint256 value) public {
267     _burnFrom(from, value);
268   }
269 }
270 
271 contract ERC20Pausable is ERC20, Pausable {
272 
273   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
274     return super.transfer(to, value);
275   }
276   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
277     return super.transferFrom(from, to, value);
278   }
279   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
280     return super.approve(spender, value);
281   }
282   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
283     return super.increaseAllowance(spender, addedValue);
284   }
285   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
286     return super.decreaseAllowance(spender, subtractedValue);
287   }
288 }
289 
290 contract ERC20Frozen is ERC20 {
291     
292   function freezeAccount (address target, bool freeze) onlyOwner public {
293     frozenAccount[target]=freeze;
294     emit frozenFunds(target, freeze);
295   }
296 }
297 
298 contract CertifiedEmissionReductionsToken is ERC20Burnable, ERC20Pausable, ERC20Frozen {
299 
300   string public constant name = "CertifiedEmissionReductionsToken";
301   string public constant symbol = "CERT";
302   uint8 public constant decimals = 18;
303   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
304 
305   constructor() public {
306     _issue(msg.sender, INITIAL_SUPPLY);
307   }
308 }