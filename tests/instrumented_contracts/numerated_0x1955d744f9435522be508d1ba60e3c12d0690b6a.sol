1 /**
2  *Submitted for verification at Etherscan.io on 2020.02.25
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     require(c / a == b);
15     return c;
16   }
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b > 0); 
19     uint256 c = a / b;
20     return c;
21   }
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b <= a);
24     uint256 c = a - b;
25     return c;
26   }
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a);
30     return c;
31   }
32   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b != 0);
34     return a % b;
35   }
36 }
37 
38 library Roles {
39     
40   struct Role {
41     mapping (address => bool) bearer;
42   }
43   function add(Role storage role, address account) internal {
44     require(account != address(0));
45     require(!has(role, account));
46     role.bearer[account] = true;
47   }
48   function remove(Role storage role, address account) internal {
49     require(account != address(0));
50     require(has(role, account));
51     role.bearer[account] = false;
52   }
53   function has(Role storage role, address account) internal view returns (bool) {
54     require(account != address(0));
55     return role.bearer[account];
56   }
57 }
58 
59 contract Ownable {
60 
61   address private _owner;
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63   constructor() internal {
64     _owner = msg.sender;
65     emit OwnershipTransferred(address(0), _owner);
66   }
67   function owner() public view returns(address) {
68     return _owner;
69   }
70   modifier onlyOwner() {
71     require(isOwner());
72     _;
73   }
74   function isOwner() public view returns(bool) {
75     return msg.sender == _owner;
76   }
77   function renounceOwnership() public onlyOwner {
78     emit OwnershipTransferred(_owner, address(0));
79     _owner = address(0);
80   }
81   function transferOwnership(address newOwner) public onlyOwner {
82     _transferOwnership(newOwner);
83   }
84   function _transferOwnership(address newOwner) internal {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(_owner, newOwner);
87     _owner = newOwner;
88   }
89 }
90 
91 contract ERC223ReceivingContract {
92 
93     function tokenFallback(address _from, uint256 _value, bytes _data) public;
94 }
95 
96 interface IERC20 {
97     
98   function totalSupply() external view returns (uint256);
99   function balanceOf(address who) external view returns (uint256);
100   function allowance(address owner, address spender) external view returns (uint256);
101   function transfer(address to, uint256 value) external returns (bool);
102   function approve(address spender, uint256 value) external returns (bool);
103   function transferFrom(address from, address to, uint256 value) external returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106   //ERC223
107   function transfer(address to, uint256 value, bytes data) external returns (bool success);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 contract ERC20 is IERC20, Ownable {
112     
113   using SafeMath for uint256;
114   mapping (address => uint256) private _balances;
115   mapping (address => mapping (address => uint256)) private _allowed;
116   mapping (address => bool) public frozenAccount;
117   event frozenFunds(address account, bool freeze);
118   uint256 private _totalSupply;
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122   function balanceOf(address owner) public view returns (uint256) {
123     return _balances[owner];
124   }
125   function allowance(address owner, address spender) public view returns (uint256) {
126     return _allowed[owner][spender];
127   }
128   function transfer(address to, uint256 value) public returns (bool) {
129     _transfer(msg.sender, to, value);
130     return true;
131   }
132   //ERC223
133   function transfer(address to, uint256 value, bytes data) external returns (bool) {
134     require(transfer(to, value));
135 
136    uint codeLength;
137 
138    assembly {
139     // Retrieve the size of the code on target address, this needs assembly.
140     codeLength := extcodesize(to)
141   }
142 
143   if (codeLength > 0) {
144     ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
145     receiver.tokenFallback(msg.sender, value, data);
146     }
147   return true;
148   
149   }
150   function approve(address spender, uint256 value) public returns (bool) {
151     require(spender != address(0));
152     _allowed[msg.sender][spender] = value;
153     emit Approval(msg.sender, spender, value);
154     return true;
155   }
156   function transferFrom(address from, address to, uint256 value) public returns (bool) {
157     require(value <= _allowed[from][msg.sender]);
158     require(!frozenAccount[from]);
159     require(from != address(0));
160     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
161     _transfer(from, to, value);
162     return true;
163   }
164   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
165     require(spender != address(0));
166     _allowed[msg.sender][spender] = (
167       _allowed[msg.sender][spender].add(addedValue));
168     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
169     return true;
170   }
171   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
172     require(spender != address(0));
173     _allowed[msg.sender][spender] = (
174       _allowed[msg.sender][spender].sub(subtractedValue));
175     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
176     return true;
177   }
178   function _transfer(address from, address to, uint256 value) internal {
179     require(value <= _balances[from]);
180     require(to != address(0));
181     require(!frozenAccount[msg.sender]);
182     _balances[from] = _balances[from].sub(value);
183     _balances[to] = _balances[to].add(value);
184     emit Transfer(from, to, value);
185   }
186   function _issue(address account, uint256 value) internal {
187     require(account != 0);
188     _totalSupply = _totalSupply.add(value);
189     _balances[account] = _balances[account].add(value);
190     emit Transfer(address(0), account, value);
191   }
192   function _burn(address account, uint256 value) internal {
193     require(account != 0);
194     require(!frozenAccount[account]);
195     require(value <= _balances[account]);
196     _totalSupply = _totalSupply.sub(value);
197     _balances[account] = _balances[account].sub(value);
198     emit Transfer(account, address(0), value);
199   }
200   function _burnFrom(address account, uint256 value) internal {
201     require(value <= _allowed[account][msg.sender]);
202     require(!frozenAccount[msg.sender]);
203     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
204     _burn(account, value);
205   }
206 }
207 
208 contract PauserRole {
209     
210   using Roles for Roles.Role;
211   event PauserAdded(address indexed account);
212   event PauserRemoved(address indexed account);
213   Roles.Role private pausers;
214   constructor() internal {
215     _addPauser(msg.sender);
216   }
217   modifier onlyPauser() {
218     require(isPauser(msg.sender));
219     _;
220   }
221   function isPauser(address account) public view returns (bool) {
222     return pausers.has(account);
223   }
224   function addPauser(address account) public onlyPauser {
225     _addPauser(account);
226   }
227   function renouncePauser() public {
228     _removePauser(msg.sender);
229   }
230   function _addPauser(address account) internal {
231     pausers.add(account);
232     emit PauserAdded(account);
233   }
234   function _removePauser(address account) internal {
235     pausers.remove(account);
236     emit PauserRemoved(account);
237   }
238 }
239 
240 contract Pausable is PauserRole {
241     
242   event Paused(address account);
243   event Unpaused(address account);
244   bool private _paused;
245   constructor() internal {
246     _paused = false;
247   }
248   function paused() public view returns(bool) {
249     return _paused;
250   }
251   modifier whenNotPaused() {
252     require(!_paused);
253     _;
254   }
255   modifier whenPaused() {
256     require(_paused);
257     _;
258   }
259   function pause() public onlyPauser whenNotPaused {
260     _paused = true;
261     emit Paused(msg.sender);
262   }
263   function unpause() public onlyPauser whenPaused {
264     _paused = false;
265     emit Unpaused(msg.sender);
266   }
267 }
268 
269 contract ERC20Burnable is ERC20 {
270 
271   function burn(uint256 value) public {
272     _burn(msg.sender, value);
273   }
274   function burnFrom(address from, uint256 value) public {
275     _burnFrom(from, value);
276   }
277 }
278 
279 contract ERC20Pausable is ERC20, Pausable {
280 
281   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
282     return super.transfer(to, value);
283   }
284   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
285     return super.transferFrom(from, to, value);
286   }
287   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
288     return super.approve(spender, value);
289   }
290   function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
291     return super.increaseAllowance(spender, addedValue);
292   }
293   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
294     return super.decreaseAllowance(spender, subtractedValue);
295   }
296  
297 }
298 
299 contract ERC20Frozen is ERC20 {
300     
301   function freezeAccount (address target, bool freeze) onlyOwner public {
302     require(target != address(0));  
303     frozenAccount[target]=freeze;
304     emit frozenFunds(target, freeze);
305   }
306 }
307 
308 contract BitWPPToken is ERC20Burnable, ERC20Pausable, ERC20Frozen {
309 
310   string public constant name = "WPPToken";
311   string public constant symbol ="WPP";
312   uint8 public constant decimals = 18;
313   uint256 public constant INITIAL_SUPPLY = 5000000000 * (10 ** uint256(decimals));
314 
315   constructor() public {
316     _issue(msg.sender, INITIAL_SUPPLY);
317   }
318 }