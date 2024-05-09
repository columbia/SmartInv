1 pragma solidity ^0.5.10;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Removed mul, div, mod
7  */
8 library SafeMath {
9         /**
10          * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
11          */
12         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13                 require(b <= a);
14                 uint256 c = a - b;
15 
16                 return c;
17         }
18 
19         /**
20          * @dev Adds two unsigned integers, reverts on overflow.
21          */
22         function add(uint256 a, uint256 b) internal pure returns (uint256) {
23                 uint256 c = a + b;
24                 require(c >= a);
25 
26                 return c;
27         }
28 }
29 
30 
31 contract ERC20 {
32       function totalSupply() public view returns (uint256);
33       function balanceOf(address _who) public view returns (uint256);
34       function transfer(address _to, uint256 _value) public returns (bool);
35       function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
36       function allowance(address _owner, address _spender) public view returns (uint256);
37       function approve(address _spender, uint256 _value) public returns (bool);
38 
39       event Transfer(address indexed from, address indexed to, uint256 value);
40       event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 
44 contract StandardToken is ERC20 {
45         using SafeMath for uint256;
46 
47         uint256 internal _totalSupply;
48         mapping(address => uint256) internal _balances;
49         mapping(address => mapping (address => uint256)) internal _allowed;
50 
51         modifier validDestination( address _to )
52         {
53                 require(_to != address(0x0), "Invalid address.");
54                 require(_to != address(this), "Invalid address.");
55                 _;
56         }
57 
58         function totalSupply() public view returns (uint256) {
59                 return _totalSupply;
60         }
61 
62         function balanceOf(address _who) public view returns (uint256) {
63                 return _balances[_who];
64         }
65 
66         function transfer(address _to, uint256 _value)
67                 public
68                 validDestination(_to)
69                 returns (bool)
70         {
71                 _balances[msg.sender] = _balances[msg.sender].sub(_value);
72                 _balances[_to] = _balances[_to].add(_value);
73                 emit Transfer(msg.sender, _to, _value);
74                 return true;
75         }
76 
77         function transferFrom(address _from, address _to, uint256 _value)
78                 public
79                 validDestination(_to)
80                 returns (bool)
81         {
82                 require(_value <= _allowed[_from][msg.sender],"Insufficient allowance.");
83 
84                 _balances[_from] = _balances[_from].sub(_value);
85                 _balances[_to] = _balances[_to].add(_value);
86 
87                 _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
88 
89                 emit Transfer(_from, _to, _value);
90                 return true;
91         }
92 
93         function burn(uint _value) public returns (bool)
94         {
95                 _balances[msg.sender] = _balances[msg.sender].sub(_value);
96                 _totalSupply = _totalSupply.sub(_value);
97                 emit Transfer(msg.sender, address(0x0), _value);
98                 return true;
99         }
100 
101         function burnFrom(address _from, uint256 _value) public validDestination(_from) returns (bool)
102         {
103                 _balances[_from] = _balances[_from].sub(_value);
104                 _totalSupply = _totalSupply.sub(_value);
105                 emit Transfer(_from, address(0x0), _value);
106 
107                 approve(msg.sender, _allowed[_from][msg.sender].sub(_value));
108 
109                 return true;
110         }
111 
112         function approve(address _spender, uint256 _value) public validDestination(_spender) returns (bool) {
113 
114                 _allowed[msg.sender][_spender] = _value;
115                 emit Approval(msg.sender, _spender, _value);
116                 return true;
117         }
118 
119         function allowance(address _owner, address _spender) public view returns (uint256)
120         {
121                 return _allowed[_owner][_spender];
122         }
123 }
124 
125 
126 contract Ownable {
127         address public owner;
128         mapping (address => bool) public delegatee;
129 
130         event OwnershipTransferred(
131                 address indexed previousOwner,
132                 address indexed newOwner
133         );
134 
135         event LockableDelegated(address indexed delegatee);
136         event LockableUndelegated(address indexed delegatee);
137 
138         constructor() public {
139                 owner = msg.sender;
140         }
141 
142         modifier validateAddress(address _to) {
143                 require(_to != address(0x0));
144 				require(_to != address(this));
145                 _;
146         }
147 
148         modifier onlyOwner() {
149                 require(msg.sender == owner, 'Permission denied.');
150                 _;
151         }
152 		
153 		modifier onlyLocker() {
154                 require(msg.sender == owner || delegatee[msg.sender], 'Permission denied');
155                 _;
156         }
157 
158         function transferOwnership(address _newOwner) public onlyOwner validateAddress(_newOwner) {
159                 owner = _newOwner;
160                 emit OwnershipTransferred(owner, _newOwner);
161         }
162 
163 	function delegateLockable(address _delegatee) public onlyOwner validateAddress(_delegatee) {
164 		require(!delegatee[_delegatee], 'Delegatee already.');
165 		delegatee[_delegatee] = true;
166 		emit LockableDelegated(_delegatee);
167 	}
168 	
169 	function undelegateLockable(address _delegatee) public onlyOwner validateAddress(_delegatee) {
170 		require(delegatee[_delegatee], 'Not a delegatee.');
171 		delegatee[_delegatee] = false;
172 		emit LockableUndelegated(_delegatee);
173 	}
174 }
175 
176 
177 contract Pausable is Ownable {
178         event Pause();
179         event Unpause();
180 
181         bool public paused = false;
182 
183         modifier whenNotPaused() {
184                 require(!paused, 'Paused by owner.');
185                 _;
186         }
187 
188         modifier whenPaused() {
189                 require(paused, 'Paused requied.');
190                 _;
191         }
192 
193         function pause() public onlyOwner whenNotPaused {
194                 paused = true;
195                 emit Pause();
196         }
197 
198         function unpause() public onlyOwner whenPaused {
199                 paused = false;
200                 emit Unpause();
201         }
202 }
203 
204 
205 contract Freezable is Ownable {
206         mapping (address => bool) public frozenAccount;
207 
208         event Freezed(address indexed target, bool frozen);
209         event Unfreezed(address indexed target, bool frozen);
210 
211         modifier isNotFrozen(address _target) {
212                 require(!frozenAccount[_target], 'Frozen account.');
213                 _;
214         }
215 
216         modifier isFrozen(address _target) {
217                 require(frozenAccount[_target], 'Not a frozen account.');
218                 _;
219         }
220 
221         function freeze(address _target) public onlyOwner isNotFrozen(_target) validateAddress(_target) {
222                 frozenAccount[_target] = true;
223                 emit Freezed(_target, true);
224         }
225 
226         function unfreeze(address _target) public onlyOwner isFrozen(_target) validateAddress(_target) {
227                 frozenAccount[_target] = false;
228                 emit Unfreezed(_target, false);
229         }
230 
231 }
232 
233 contract TimeLockable is Ownable {
234         using SafeMath for uint256;
235 
236         mapping (address => uint256) internal _lockType1;
237 	mapping (address => uint256) internal _lockType2;
238 	mapping (address => uint256) internal _lockType3;
239 
240         event LockAccount(address indexed target, uint256 value, uint256 lockedType);
241 
242         function _setTimeLockAccount(address _target, uint256 _value, uint256 _newLockType)
243                 internal
244                 onlyLocker
245                 returns (bool)
246         {
247 		if (_newLockType == 1) {
248 			_lockType1[_target] = _lockType1[_target].add(_value);
249 			return true;
250 		} else if (_newLockType == 2) {
251 			_lockType2[_target] = _lockType2[_target].add(_value);
252 			return true;
253 		} else if (_newLockType == 3) {
254 			_lockType3[_target] = _lockType3[_target].add(_value);
255 			return true;
256 		} else {
257 			return false;
258 		}
259         }
260 
261 	function balanceLocked(address _target) public view returns ( uint256 lockType1, uint256 lockType2, uint256 lockType3 ) {
262 		if (now > 1614556800) {				// Mar 1, 2021
263 			return (0, 0, 0);
264 		} else if (now > 1598918400) {			// Sep 1, 2020
265 			return (0, 0, _lockType3[_target]);
266 		} else if (now > 1593561600) {			// Jul 1, 2020
267 			return (0, _lockType2[_target], _lockType3[_target]);
268 		} else {
269 			return (_lockType1[_target], _lockType2[_target], _lockType3[_target]);
270 		}
271 	}
272 }
273 
274 
275 contract VKNF is StandardToken, Pausable, Freezable, TimeLockable {
276         using SafeMath for uint256;
277 
278         string  public  name = "VKenaf";
279         string  public  symbol = 'VKNF';
280         uint256 public  constant decimals = 12;
281 
282         constructor(
283                 uint256 _initialSupply
284         )
285                 public
286         {
287                 _totalSupply = _initialSupply * 10 ** uint256(decimals);
288                 _balances[msg.sender] = _totalSupply;                  
289         }
290 		
291         modifier balanceValidate(address _from, uint256 _value) {
292                 require(balanceAvailable(_from) >= _value, 'Insufficient available balance.');
293                 _;
294         }
295 
296         function balanceAvailable(address _target) public view returns ( uint256 ) {
297 		uint256 _locked1;
298 		uint256 _locked2;
299 		uint256 _locked3;
300 		
301 		(_locked1, _locked2, _locked3) = balanceLocked(_target);
302 		return _balances[_target].sub(_locked1).sub(_locked2).sub(_locked3);
303         }
304 
305 
306 	function lockAndTransfer(address _to, uint256 _value, uint256 _newLockType) 
307 		public
308 		onlyLocker 
309 	{
310 		require(_setTimeLockAccount(_to, _value, _newLockType));
311 		transfer(_to, _value);
312 	}
313 
314         function transfer(address _to, uint256 _value)
315                 public
316                 whenNotPaused
317                 isNotFrozen(msg.sender)
318                 isNotFrozen(_to)
319 		balanceValidate(msg.sender, _value)
320                 returns (bool)
321         {
322                 return super.transfer(_to, _value);
323         }
324 
325         function transferFrom(address _from, address _to, uint256 _value)
326                 public
327                 whenNotPaused
328                 isNotFrozen(_from)
329                 isNotFrozen(_to)
330 				balanceValidate(_from, _value)
331                 returns (bool)
332         {
333                 return super.transferFrom(_from, _to, _value);
334         }
335 
336         function burn(uint256 _value)
337                 public
338                 whenNotPaused
339                 isNotFrozen(msg.sender)
340 				balanceValidate(msg.sender, _value)
341                 returns (bool)
342         {
343                 return super.burn(_value);
344         }
345 
346         function burnFrom(address _from, uint256 _value)
347                 public
348                 whenNotPaused
349                 isNotFrozen(_from)
350 		balanceValidate(_from, _value)
351                 returns (bool)
352         {
353                 return super.burnFrom(_from, _value);
354         }
355 
356         function approve(address _spender, uint256 _value)
357                 public
358                 whenNotPaused
359                 isNotFrozen(msg.sender)
360                 isNotFrozen(_spender)
361 		balanceValidate(msg.sender, _value)
362                 returns (bool)
363         {
364                 return super.approve(_spender, _value);
365         }
366 
367 }