1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 /**
74  * @title Roles
75  * @dev Library for managing addresses assigned to a Role.
76  */
77 library Roles {
78     struct Role {
79         mapping (address => bool) bearer;
80     }
81 
82     /**
83      * @dev give an account access to this role
84      */
85     function add(Role storage role, address account) internal {
86         require(account != address(0));
87         require(!has(role, account));
88 
89         role.bearer[account] = true;
90     }
91 
92     /**
93      * @dev remove an account's access to this role
94      */
95     function remove(Role storage role, address account) internal {
96         require(account != address(0));
97         require(has(role, account));
98 
99         role.bearer[account] = false;
100     }
101 
102     /**
103      * @dev check if an account has this role
104      * @return bool
105      */
106     function has(Role storage role, address account) internal view returns (bool) {
107         require(account != address(0));
108         return role.bearer[account];
109     }
110 }
111 
112 contract PauserRole {
113     using Roles for Roles.Role;
114 
115     event PauserAdded(address indexed account);
116     event PauserRemoved(address indexed account);
117 
118     Roles.Role private _pausers;
119 
120     constructor () internal {
121         _addPauser(msg.sender);
122     }
123 
124     modifier onlyPauser() {
125         require(isPauser(msg.sender));
126         _;
127     }
128 
129     function isPauser(address account) public view returns (bool) {
130         return _pausers.has(account);
131     }
132 
133     function addPauser(address account) public onlyPauser {
134         _addPauser(account);
135     }
136 
137     function renouncePauser() public {
138         _removePauser(msg.sender);
139     }
140 
141     function _addPauser(address account) internal {
142         _pausers.add(account);
143         emit PauserAdded(account);
144     }
145 
146     function _removePauser(address account) internal {
147         _pausers.remove(account);
148         emit PauserRemoved(account);
149     }
150 }
151 
152 /**
153  * @title Pausable
154  * @dev Base contract which allows children to implement an emergency stop mechanism.
155  */
156 contract Pausable is PauserRole {
157     event Paused(address account);
158     event Unpaused(address account);
159 
160     bool private _paused;
161 
162     constructor () internal {
163         _paused = false;
164     }
165 
166     /**
167      * @return true if the contract is paused, false otherwise.
168      */
169     function paused() public view returns (bool) {
170         return _paused;
171     }
172 
173     /**
174      * @dev Modifier to make a function callable only when the contract is not paused.
175      */
176     modifier whenNotPaused() {
177         require(!_paused);
178         _;
179     }
180 
181     /**
182      * @dev Modifier to make a function callable only when the contract is paused.
183      */
184     modifier whenPaused() {
185         require(_paused);
186         _;
187     }
188 
189     /**
190      * @dev called by the owner to pause, triggers stopped state
191      */
192     function pause() public onlyPauser whenNotPaused {
193         _paused = true;
194         emit Paused(msg.sender);
195     }
196 
197     /**
198      * @dev called by the owner to unpause, returns to normal state
199      */
200     function unpause() public onlyPauser whenPaused {
201         _paused = false;
202         emit Unpaused(msg.sender);
203     }
204 }
205 /**
206  * @title SafeMath
207  * @dev Unsigned math operations with safety checks that revert on error
208  */
209 library SafeMath {
210     /**
211      * @dev Multiplies two unsigned integers, reverts on overflow.
212      */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215         // benefit is lost if 'b' is also tested.
216         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
217         if (a == 0) {
218             return 0;
219         }
220 
221         uint256 c = a * b;
222         require(c / a == b);
223 
224         return c;
225     }
226 
227     /**
228      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
229      */
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         // Solidity only automatically asserts when dividing by 0
232         require(b > 0);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         require(b <= a);
244         uint256 c = a - b;
245 
246         return c;
247     }
248 
249     /**
250      * @dev Adds two unsigned integers, reverts on overflow.
251      */
252     function add(uint256 a, uint256 b) internal pure returns (uint256) {
253         uint256 c = a + b;
254         require(c >= a);
255 
256         return c;
257     }
258 
259     /**
260      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
261      * reverts when dividing by zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         require(b != 0);
265         return a % b;
266     }
267 }
268 contract ERC20 {
269   uint256 public totalSupply;
270   function balanceOf(address who) public view returns (uint256);
271   function transfer(address to, uint256 value) public returns (bool);
272   event Transfer(address indexed from, address indexed to, uint256 value);
273   function allowance(address owner, address spender) public view returns (uint256);
274   function transferFrom(address from, address to, uint256 value) public returns (bool);
275   function approve(address spender, uint256 value) public returns (bool);
276   event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 contract DetailedERC20 is ERC20 {
280   string public name;
281   string public symbol;
282   uint8 public decimals;
283 
284 constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
285     name = _name;
286     symbol = _symbol;
287     decimals = _decimals;
288   }
289 }
290 
291 contract RELCoin is Pausable, DetailedERC20, Ownable {
292   using SafeMath for uint256;
293 
294   mapping(address => uint256) balances;
295   mapping (address => mapping (address => uint256)) internal allowed;
296 
297   address public crowdsaleContract;
298   uint256 public tokenSaled = 0;
299 
300   constructor(string memory _name, string memory _symbol, uint8 _decimals)
301     DetailedERC20(_name, _symbol, _decimals)
302     Ownable()
303     public {
304         totalSupply = 100 * (10**9) * 10**uint256(decimals);  // 100 billion
305     }
306 
307   function setCrowdsaleContract(address crowdsale) onlyOwner public {
308     crowdsaleContract = crowdsale;
309   }
310 
311   function addToBalances(address _person,uint256 value) public returns (bool) {
312     require(msg.sender == crowdsaleContract);
313     require(value <= totalSupply - tokenSaled);
314     balances[_person] = balances[_person].add(value);
315     tokenSaled = tokenSaled.add(value);
316     emit Transfer(address(this), _person, value);
317     return true;
318   }
319 
320   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
321     require(_to != address(0));
322     require(_value <= balances[msg.sender]);
323 
324     balances[msg.sender] = balances[msg.sender].sub(_value);
325     balances[_to] = balances[_to].add(_value);
326     emit Transfer(msg.sender, _to, _value);
327     return true;
328   }
329 
330 
331   function balanceOf(address _owner) public view returns (uint256 balance) {
332     return balances[_owner];
333   }
334 
335 
336   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
337     require(_to != address(0));
338     require(_value <= balances[_from]);
339     require(_value <= allowed[_from][msg.sender]);
340 
341     balances[_from] = balances[_from].sub(_value);
342     balances[_to] = balances[_to].add(_value);
343     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
344     emit Transfer(_from, _to, _value);
345     return true;
346   }
347 
348   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
349     allowed[msg.sender][_spender] = _value;
350     emit Approval(msg.sender, _spender, _value);
351     return true;
352   }
353 
354   function allowance(address _owner, address _spender) public view returns (uint256) {
355     return allowed[_owner][_spender];
356   }
357 
358   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
359     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
360     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361     return true;
362   }
363 
364   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
365     uint oldValue = allowed[msg.sender][_spender];
366     if (_subtractedValue > oldValue) {
367       allowed[msg.sender][_spender] = 0;
368     } else {
369       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
370     }
371     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372     return true;
373   }
374 }