1 pragma solidity ^0.5.2;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address private _owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     constructor () internal {
17         _owner = msg.sender;
18         emit OwnershipTransferred(address(0), _owner);
19     }
20 
21     /**
22      * @return the address of the owner.
23      */
24     function owner() public view returns (address) {
25         return _owner;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(isOwner());
33         _;
34     }
35 
36     /**
37      * @return true if `msg.sender` is the owner of the contract.
38      */
39     function isOwner() public view returns (bool) {
40         return msg.sender == _owner;
41     }
42 
43     /**
44      * @dev Allows the current owner to relinquish control of the contract.
45      * @notice Renouncing to ownership will leave the contract without an owner.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      */
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipTransferred(_owner, address(0));
51         _owner = address(0);
52     }
53 
54     /**
55      * @dev Allows the current owner to transfer control of the contract to a newOwner.
56      * @param newOwner The address to transfer ownership to.
57      */
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61 
62     /**
63      * @dev Transfers control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function _transferOwnership(address newOwner) internal {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 /**
73  * @title Roles
74  * @dev Library for managing addresses assigned to a Role.
75  */
76 library Roles {
77     struct Role {
78         mapping (address => bool) bearer;
79     }
80 
81     /**
82      * @dev give an account access to this role
83      */
84     function add(Role storage role, address account) internal {
85         require(account != address(0));
86         require(!has(role, account));
87 
88         role.bearer[account] = true;
89     }
90 
91     /**
92      * @dev remove an account's access to this role
93      */
94     function remove(Role storage role, address account) internal {
95         require(account != address(0));
96         require(has(role, account));
97 
98         role.bearer[account] = false;
99     }
100 
101     /**
102      * @dev check if an account has this role
103      * @return bool
104      */
105     function has(Role storage role, address account) internal view returns (bool) {
106         require(account != address(0));
107         return role.bearer[account];
108     }
109 }
110 
111 contract PauserRole {
112     using Roles for Roles.Role;
113 
114     event PauserAdded(address indexed account);
115     event PauserRemoved(address indexed account);
116 
117     Roles.Role private _pausers;
118 
119     constructor () internal {
120         _addPauser(msg.sender);
121     }
122 
123     modifier onlyPauser() {
124         require(isPauser(msg.sender));
125         _;
126     }
127 
128     function isPauser(address account) public view returns (bool) {
129         return _pausers.has(account);
130     }
131 
132     function addPauser(address account) public onlyPauser {
133         _addPauser(account);
134     }
135 
136     function renouncePauser() public {
137         _removePauser(msg.sender);
138     }
139 
140     function _addPauser(address account) internal {
141         _pausers.add(account);
142         emit PauserAdded(account);
143     }
144 
145     function _removePauser(address account) internal {
146         _pausers.remove(account);
147         emit PauserRemoved(account);
148     }
149 }
150 
151 /**
152  * @title Pausable
153  * @dev Base contract which allows children to implement an emergency stop mechanism.
154  */
155 contract Pausable is PauserRole {
156     event Paused(address account);
157     event Unpaused(address account);
158 
159     bool private _paused;
160 
161     constructor () internal {
162         _paused = false;
163     }
164 
165     /**
166      * @return true if the contract is paused, false otherwise.
167      */
168     function paused() public view returns (bool) {
169         return _paused;
170     }
171 
172     /**
173      * @dev Modifier to make a function callable only when the contract is not paused.
174      */
175     modifier whenNotPaused() {
176         require(!_paused);
177         _;
178     }
179 
180     /**
181      * @dev Modifier to make a function callable only when the contract is paused.
182      */
183     modifier whenPaused() {
184         require(_paused);
185         _;
186     }
187 
188     /**
189      * @dev called by the owner to pause, triggers stopped state
190      */
191     function pause() public onlyPauser whenNotPaused {
192         _paused = true;
193         emit Paused(msg.sender);
194     }
195 
196     /**
197      * @dev called by the owner to unpause, returns to normal state
198      */
199     function unpause() public onlyPauser whenPaused {
200         _paused = false;
201         emit Unpaused(msg.sender);
202     }
203 }
204 /**
205  * @title SafeMath
206  * @dev Unsigned math operations with safety checks that revert on error
207  */
208 library SafeMath {
209     /**
210      * @dev Multiplies two unsigned integers, reverts on overflow.
211      */
212     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
213         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
214         // benefit is lost if 'b' is also tested.
215         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
216         if (a == 0) {
217             return 0;
218         }
219 
220         uint256 c = a * b;
221         require(c / a == b);
222 
223         return c;
224     }
225 
226     /**
227      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         // Solidity only automatically asserts when dividing by 0
231         require(b > 0);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
240      */
241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242         require(b <= a);
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Adds two unsigned integers, reverts on overflow.
250      */
251     function add(uint256 a, uint256 b) internal pure returns (uint256) {
252         uint256 c = a + b;
253         require(c >= a);
254 
255         return c;
256     }
257 
258     /**
259      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
260      * reverts when dividing by zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b != 0);
264         return a % b;
265     }
266 }
267 contract ERC20 {
268   uint256 public totalSupply;
269   function balanceOf(address who) public view returns (uint256);
270   function transfer(address to, uint256 value) public returns (bool);
271   event Transfer(address indexed from, address indexed to, uint256 value);
272   function allowance(address owner, address spender) public view returns (uint256);
273   function transferFrom(address from, address to, uint256 value) public returns (bool);
274   function approve(address spender, uint256 value) public returns (bool);
275   event Approval(address indexed owner, address indexed spender, uint256 value);
276 }
277 
278 contract DetailedERC20 is ERC20 {
279   string public name;
280   string public symbol;
281   uint8 public decimals;
282 
283 constructor (string memory _name, string memory _symbol, uint8 _decimals) public {
284     name = _name;
285     symbol = _symbol;
286     decimals = _decimals;
287   }
288 }
289 
290 contract RELCoin is Pausable, DetailedERC20, Ownable {
291   using SafeMath for uint256;
292 
293   mapping(address => uint256) balances;
294   mapping (address => mapping (address => uint256)) internal allowed;
295 
296   address public crowdsaleContract;
297 
298   constructor(string memory _name, string memory _symbol, uint8 _decimals)
299     DetailedERC20(_name, _symbol, _decimals)
300     Ownable()
301     public {
302         totalSupply = 100 * (10**9) * 10**uint256(decimals);  // 100 billion
303     }
304 
305   function setCrowdsaleContract(address crowdsale) onlyOwner public {
306     crowdsaleContract = crowdsale;
307   }
308 
309   function addToBalances(address _person,uint256 value) public returns (bool) {
310     require(msg.sender == crowdsaleContract);
311     balances[_person] = balances[_person].add(value);
312     emit Transfer(address(this), _person, value);
313     return true;
314   }
315 
316   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
317     require(_to != address(0));
318     require(_value <= balances[msg.sender]);
319 
320     balances[msg.sender] = balances[msg.sender].sub(_value);
321     balances[_to] = balances[_to].add(_value);
322     emit Transfer(msg.sender, _to, _value);
323     return true;
324   }
325 
326 
327   function balanceOf(address _owner) public view returns (uint256 balance) {
328     return balances[_owner];
329   }
330 
331 
332   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
333     require(_to != address(0));
334     require(_value <= balances[_from]);
335     require(_value <= allowed[_from][msg.sender]);
336 
337     balances[_from] = balances[_from].sub(_value);
338     balances[_to] = balances[_to].add(_value);
339     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
340     emit Transfer(_from, _to, _value);
341     return true;
342   }
343 
344   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
345     allowed[msg.sender][_spender] = _value;
346     emit Approval(msg.sender, _spender, _value);
347     return true;
348   }
349 
350   function allowance(address _owner, address _spender) public view returns (uint256) {
351     return allowed[_owner][_spender];
352   }
353 
354   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
355     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
361     uint oldValue = allowed[msg.sender][_spender];
362     if (_subtractedValue > oldValue) {
363       allowed[msg.sender][_spender] = 0;
364     } else {
365       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
366     }
367     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
368     return true;
369   }
370 }