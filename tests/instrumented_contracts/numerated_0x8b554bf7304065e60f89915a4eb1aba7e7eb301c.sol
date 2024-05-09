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
154     require(!frozenAccount[from]);
155     require(from != address(0));
156     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
157     _transfer(from, to, value);
158     return true;
159   }
160   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
161     require(spender != address(0));
162     _allowed[msg.sender][spender] = (
163       _allowed[msg.sender][spender].add(addedValue));
164     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
165     return true;
166   }
167   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
168     require(spender != address(0));
169     _allowed[msg.sender][spender] = (
170       _allowed[msg.sender][spender].sub(subtractedValue));
171     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
172     return true;
173   }
174   function _transfer(address from, address to, uint256 value) internal {
175     require(value <= _balances[from]);
176     require(to != address(0));
177     require(!frozenAccount[msg.sender]);
178     _balances[from] = _balances[from].sub(value);
179     _balances[to] = _balances[to].add(value);
180     emit Transfer(from, to, value);
181   }
182   function _issue(address account, uint256 value) internal {
183     require(account != 0);
184     _totalSupply = _totalSupply.add(value);
185     _balances[account] = _balances[account].add(value);
186     emit Transfer(address(0), account, value);
187   }
188   function _burn(address account, uint256 value) internal {
189     require(account != 0);
190     require(!frozenAccount[account]);
191     require(value <= _balances[account]);
192     _totalSupply = _totalSupply.sub(value);
193     _balances[account] = _balances[account].sub(value);
194     emit Transfer(account, address(0), value);
195   }
196   function _burnFrom(address account, uint256 value) internal {
197     require(value <= _allowed[account][msg.sender]);
198     require(!frozenAccount[msg.sender]);
199     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
200     _burn(account, value);
201   }
202 }
203 
204 contract PauserRole {
205     
206   using Roles for Roles.Role;
207   event PauserAdded(address indexed account);
208   event PauserRemoved(address indexed account);
209   Roles.Role private pausers;
210   constructor() internal {
211     _addPauser(msg.sender);
212   }
213   modifier onlyPauser() {
214     require(isPauser(msg.sender));
215     _;
216   }
217   function isPauser(address account) public view returns (bool) {
218     return pausers.has(account);
219   }
220   function addPauser(address account) public onlyPauser {
221     _addPauser(account);
222   }
223   function renouncePauser() public {
224     _removePauser(msg.sender);
225   }
226   function _addPauser(address account) internal {
227     pausers.add(account);
228     emit PauserAdded(account);
229   }
230   function _removePauser(address account) internal {
231     pausers.remove(account);
232     emit PauserRemoved(account);
233   }
234 }
235 
236 contract Pausable is PauserRole {
237     
238   event Paused(address account);
239   event Unpaused(address account);
240   bool private _paused;
241   constructor() internal {
242     _paused = false;
243   }
244   function paused() public view returns(bool) {
245     return _paused;
246   }
247   modifier whenNotPaused() {
248     require(!_paused);
249     _;
250   }
251   modifier whenPaused() {
252     require(_paused);
253     _;
254   }
255   function pause() public onlyPauser whenNotPaused {
256     _paused = true;
257     emit Paused(msg.sender);
258   }
259   function unpause() public onlyPauser whenPaused {
260     _paused = false;
261     emit Unpaused(msg.sender);
262   }
263 }
264 
265 contract ERC20Burnable is ERC20 {
266 
267   function burn(uint256 value) public {
268     _burn(msg.sender, value);
269   }
270   function burnFrom(address from, uint256 value) public {
271     _burnFrom(from, value);
272   }
273 }
274 
275 contract ERC20Pausable is ERC20, Pausable {
276 
277   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
278     return super.transfer(to, value);
279   }
280   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
281     return super.transferFrom(from, to, value);
282   }
283   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
284     return super.approve(spender, value);
285   }
286   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
287     return super.increaseAllowance(spender, addedValue);
288   }
289   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
290     return super.decreaseAllowance(spender, subtractedValue);
291   }
292  
293 }
294 
295 contract ERC20Frozen is ERC20 {
296     
297   function freezeAccount (address target, bool freeze) onlyOwner public {
298     require(target != address(0));  
299     frozenAccount[target]=freeze;
300     emit frozenFunds(target, freeze);
301   }
302 }
303 
304 contract PazCoin is ERC20Burnable, ERC20Pausable, ERC20Frozen {
305 
306   string public constant name = "PazCoin";
307   string public constant symbol ="PAZ";
308   uint8 public constant decimals = 18;
309   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
310 
311   constructor() public {
312     _issue(msg.sender, INITIAL_SUPPLY);
313   }
314 }