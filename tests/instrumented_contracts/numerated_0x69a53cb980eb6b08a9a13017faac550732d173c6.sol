1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     function Ownable() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0));
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95     function totalSupply() public view returns (uint256);
96     function balanceOf(address who) public view returns (uint256);
97     function transfer(address to, uint256 value) public returns (bool);
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106     using SafeMath for uint256;
107 
108     mapping(address => uint256) balances;
109 
110     uint256 totalSupply_;
111 
112     /**
113     * @dev total number of tokens in existence
114     */
115     function totalSupply() public view returns (uint256) {
116         return totalSupply_;
117     }
118 
119     /**
120     * @dev transfer token for a specified address
121     * @param _to The address to transfer to.
122     * @param _value The amount to be transferred.
123     */
124     function transfer(address _to, uint256 _value) public returns (bool) {
125         require(_to != address(0));
126         require(_value <= balances[msg.sender]);
127 
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         emit Transfer(msg.sender, _to, _value);
131         return true;
132     }
133 
134     /**
135     * @dev Gets the balance of the specified address.
136     * @param _owner The address to query the the balance of.
137     * @return An uint256 representing the amount owned by the passed address.
138     */
139     function balanceOf(address _owner) public view returns (uint256) {
140         return balances[_owner];
141     }
142 
143 }
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150     function allowance(address owner, address spender) public view returns (uint256);
151     function transferFrom(address from, address to, uint256 value) public returns (bool);
152     function approve(address spender, uint256 value) public returns (bool);
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 /**
157  * @title Roles
158  * @author Francisco Giordano (@frangio)
159  * @dev Library for managing addresses assigned to a Role.
160  *      See RBAC.sol for example usage.
161  */
162 library Roles {
163     struct Role {
164         mapping (address => bool) bearer;
165     }
166 
167     /**
168      * @dev give an address access to this role
169      */
170     function add(Role storage role, address addr)
171     internal
172     {
173         role.bearer[addr] = true;
174     }
175 
176     /**
177      * @dev remove an address' access to this role
178      */
179     function remove(Role storage role, address addr)
180     internal
181     {
182         role.bearer[addr] = false;
183     }
184 
185     /**
186      * @dev check if an address has this role
187      * // reverts
188      */
189     function check(Role storage role, address addr)
190     view
191     internal
192     {
193         require(has(role, addr));
194     }
195 
196     /**
197      * @dev check if an address has this role
198      * @return bool
199      */
200     function has(Role storage role, address addr)
201     view
202     internal
203     returns (bool)
204     {
205         return role.bearer[addr];
206     }
207 }
208 
209 /**
210  * @title RBAC (Role-Based Access Control)
211  * @author Matt Condon (@Shrugs)
212  * @dev Stores and provides setters and getters for roles and addresses.
213  * @dev Supports unlimited numbers of roles and addresses.
214  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
215  * This RBAC method uses strings to key roles. It may be beneficial
216  *  for you to write your own implementation of this interface using Enums or similar.
217  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
218  *  to avoid typos.
219  */
220 contract RBAC {
221     using Roles for Roles.Role;
222 
223     mapping (string => Roles.Role) private roles;
224 
225     event RoleAdded(address addr, string roleName);
226     event RoleRemoved(address addr, string roleName);
227 
228     /**
229      * @dev reverts if addr does not have role
230      * @param addr address
231      * @param roleName the name of the role
232      * // reverts
233      */
234     function checkRole(address addr, string roleName)
235     view
236     public
237     {
238         roles[roleName].check(addr);
239     }
240 
241     /**
242      * @dev determine if addr has role
243      * @param addr address
244      * @param roleName the name of the role
245      * @return bool
246      */
247     function hasRole(address addr, string roleName)
248     view
249     public
250     returns (bool)
251     {
252         return roles[roleName].has(addr);
253     }
254 
255     /**
256      * @dev add a role to an address
257      * @param addr address
258      * @param roleName the name of the role
259      */
260     function addRole(address addr, string roleName)
261     internal
262     {
263         roles[roleName].add(addr);
264         emit RoleAdded(addr, roleName);
265     }
266 
267     /**
268      * @dev remove a role from an address
269      * @param addr address
270      * @param roleName the name of the role
271      */
272     function removeRole(address addr, string roleName)
273     internal
274     {
275         roles[roleName].remove(addr);
276         emit RoleRemoved(addr, roleName);
277     }
278 
279     /**
280      * @dev modifier to scope access to a single role (uses msg.sender as addr)
281      * @param roleName the name of the role
282      * // reverts
283      */
284     modifier onlyRole(string roleName)
285     {
286         checkRole(msg.sender, roleName);
287         _;
288     }
289 
290     /**
291      * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
292      * @param roleNames the names of the roles to scope access to
293      * // reverts
294      *
295      * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
296      *  see: https://github.com/ethereum/solidity/issues/2467
297      */
298     // modifier onlyRoles(string[] roleNames) {
299     //     bool hasAnyRole = false;
300     //     for (uint8 i = 0; i < roleNames.length; i++) {
301     //         if (hasRole(msg.sender, roleNames[i])) {
302     //             hasAnyRole = true;
303     //             break;
304     //         }
305     //     }
306 
307     //     require(hasAnyRole);
308 
309     //     _;
310     // }
311 }
312 
313 /**
314  * @title Standard ERC20 token
315  *
316  * @dev Implementation of the basic standard token.
317  * @dev https://github.com/ethereum/EIPs/issues/20
318  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
319  */
320 contract StandardToken is ERC20, BasicToken {
321 
322     mapping (address => mapping (address => uint256)) internal allowed;
323 
324 
325     /**
326      * @dev Transfer tokens from one address to another
327      * @param _from address The address which you want to send tokens from
328      * @param _to address The address which you want to transfer to
329      * @param _value uint256 the amount of tokens to be transferred
330      */
331     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
332         require(_to != address(0));
333         require(_value <= balances[_from]);
334         require(_value <= allowed[_from][msg.sender]);
335 
336         balances[_from] = balances[_from].sub(_value);
337         balances[_to] = balances[_to].add(_value);
338         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
339         emit Transfer(_from, _to, _value);
340         return true;
341     }
342 
343     /**
344      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
345      *
346      * Beware that changing an allowance with this method brings the risk that someone may use both the old
347      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
348      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
349      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
350      * @param _spender The address which will spend the funds.
351      * @param _value The amount of tokens to be spent.
352      */
353     function approve(address _spender, uint256 _value) public returns (bool) {
354         allowed[msg.sender][_spender] = _value;
355         emit Approval(msg.sender, _spender, _value);
356         return true;
357     }
358 
359     /**
360      * @dev Function to check the amount of tokens that an owner allowed to a spender.
361      * @param _owner address The address which owns the funds.
362      * @param _spender address The address which will spend the funds.
363      * @return A uint256 specifying the amount of tokens still available for the spender.
364      */
365     function allowance(address _owner, address _spender) public view returns (uint256) {
366         return allowed[_owner][_spender];
367     }
368 
369     /**
370      * @dev Increase the amount of tokens that an owner allowed to a spender.
371      *
372      * approve should be called when allowed[_spender] == 0. To increment
373      * allowed value is better to use this function to avoid 2 calls (and wait until
374      * the first transaction is mined)
375      * From MonolithDAO Token.sol
376      * @param _spender The address which will spend the funds.
377      * @param _addedValue The amount of tokens to increase the allowance by.
378      */
379     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
380         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
381         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
382         return true;
383     }
384 
385     /**
386      * @dev Decrease the amount of tokens that an owner allowed to a spender.
387      *
388      * approve should be called when allowed[_spender] == 0. To decrement
389      * allowed value is better to use this function to avoid 2 calls (and wait until
390      * the first transaction is mined)
391      * From MonolithDAO Token.sol
392      * @param _spender The address which will spend the funds.
393      * @param _subtractedValue The amount of tokens to decrease the allowance by.
394      */
395     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
396         uint oldValue = allowed[msg.sender][_spender];
397         if (_subtractedValue > oldValue) {
398             allowed[msg.sender][_spender] = 0;
399         } else {
400             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
401         }
402         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
403         return true;
404     }
405 
406 }
407 
408 /**
409  * @title Titan Coin Contract
410  */
411 contract TitanToken is Ownable, StandardToken, RBAC {
412 
413     string public name = 'Titan Coin';
414     string public symbol = 'TC';
415     uint256 public decimals = 8;
416 
417     string public constant ROLE_EXCHANGER = "exchanger";
418 
419     uint256 public constant INITIAL_SUPPLY = 100000000 * 10 ** 8;
420     uint256 public MAXIMUM_ICO_TOKENS = 87000000 * 10 ** 8;
421 
422     uint256 public MAX_BOUNTY_ALLOCATED_TOKENS = 3000000;
423     uint256 public OWNERS_ALLOCATED_TOKENS = 100000000;
424 
425     modifier hasExchangePermission() {
426         checkRole(msg.sender, ROLE_EXCHANGER);
427         _;
428     }
429 
430     constructor() public {
431         totalSupply_ = INITIAL_SUPPLY;
432         balances[this] = INITIAL_SUPPLY;
433     }
434 
435     /**
436      * @dev add an exchanger role to an address
437      * @param exchanger address
438      */
439     function addExchanger(address exchanger) onlyOwner public {
440         addRole(exchanger, ROLE_EXCHANGER);
441     }
442 
443     /**
444      * @dev remove an exchanger role from an address
445      * @param exchanger address
446      */
447     function removeExchanger(address exchanger) onlyOwner public {
448         removeRole(exchanger, ROLE_EXCHANGER);
449     }
450 
451     function exchangeTokens(address _to, uint256 _amount) hasExchangePermission public returns (bool) {
452         this.transfer(_to, _amount);
453         return true;
454     }
455 }