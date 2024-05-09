1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract RBAC {
104   using Roles for Roles.Role;
105 
106   mapping (string => Roles.Role) private roles;
107 
108   event RoleAdded(address addr, string roleName);
109   event RoleRemoved(address addr, string roleName);
110 
111   /**
112    * @dev reverts if addr does not have role
113    * @param addr address
114    * @param roleName the name of the role
115    * // reverts
116    */
117   function checkRole(address addr, string roleName)
118     view
119     public
120   {
121     roles[roleName].check(addr);
122   }
123 
124   /**
125    * @dev determine if addr has role
126    * @param addr address
127    * @param roleName the name of the role
128    * @return bool
129    */
130   function hasRole(address addr, string roleName)
131     view
132     public
133     returns (bool)
134   {
135     return roles[roleName].has(addr);
136   }
137 
138   /**
139    * @dev add a role to an address
140    * @param addr address
141    * @param roleName the name of the role
142    */
143   function addRole(address addr, string roleName)
144     internal
145   {
146     roles[roleName].add(addr);
147     emit RoleAdded(addr, roleName);
148   }
149 
150   /**
151    * @dev remove a role from an address
152    * @param addr address
153    * @param roleName the name of the role
154    */
155   function removeRole(address addr, string roleName)
156     internal
157   {
158     roles[roleName].remove(addr);
159     emit RoleRemoved(addr, roleName);
160   }
161 
162   /**
163    * @dev modifier to scope access to a single role (uses msg.sender as addr)
164    * @param roleName the name of the role
165    * // reverts
166    */
167   modifier onlyRole(string roleName)
168   {
169     checkRole(msg.sender, roleName);
170     _;
171   }
172 
173   /**
174    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
175    * @param roleNames the names of the roles to scope access to
176    * // reverts
177    *
178    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
179    *  see: https://github.com/ethereum/solidity/issues/2467
180    */
181   // modifier onlyRoles(string[] roleNames) {
182   //     bool hasAnyRole = false;
183   //     for (uint8 i = 0; i < roleNames.length; i++) {
184   //         if (hasRole(msg.sender, roleNames[i])) {
185   //             hasAnyRole = true;
186   //             break;
187   //         }
188   //     }
189 
190   //     require(hasAnyRole);
191 
192   //     _;
193   // }
194 }
195 
196 library Roles {
197   struct Role {
198     mapping (address => bool) bearer;
199   }
200 
201   /**
202    * @dev give an address access to this role
203    */
204   function add(Role storage role, address addr)
205     internal
206   {
207     role.bearer[addr] = true;
208   }
209 
210   /**
211    * @dev remove an address' access to this role
212    */
213   function remove(Role storage role, address addr)
214     internal
215   {
216     role.bearer[addr] = false;
217   }
218 
219   /**
220    * @dev check if an address has this role
221    * // reverts
222    */
223   function check(Role storage role, address addr)
224     view
225     internal
226   {
227     require(has(role, addr));
228   }
229 
230   /**
231    * @dev check if an address has this role
232    * @return bool
233    */
234   function has(Role storage role, address addr)
235     view
236     internal
237     returns (bool)
238   {
239     return role.bearer[addr];
240   }
241 }
242 
243 contract Staff is Ownable, RBAC {
244 
245 	string public constant ROLE_STAFF = "staff";
246 
247 	function addStaff(address _staff) public onlyOwner {
248 		addRole(_staff, ROLE_STAFF);
249 	}
250 
251 	function removeStaff(address _staff) public onlyOwner {
252 		removeRole(_staff, ROLE_STAFF);
253 	}
254 
255 	function isStaff(address _staff) view public returns (bool) {
256 		return hasRole(_staff, ROLE_STAFF);
257 	}
258 }
259 
260 contract StaffUtil {
261 	Staff public staffContract;
262 
263 	constructor (Staff _staffContract) public {
264 		require(msg.sender == _staffContract.owner());
265 		staffContract = _staffContract;
266 	}
267 
268 	modifier onlyOwner() {
269 		require(msg.sender == staffContract.owner());
270 		_;
271 	}
272 
273 	modifier onlyOwnerOrStaff() {
274 		require(msg.sender == staffContract.owner() || staffContract.isStaff(msg.sender));
275 		_;
276 	}
277 }
278 
279 contract DiscountPhases is StaffUtil {
280 	using SafeMath for uint256;
281 
282 	event DiscountPhaseAdded(uint index, string name, uint8 percent, uint fromDate, uint toDate, uint timestamp, address byStaff);
283 	event DiscountPhaseRemoved(uint index, uint timestamp, address byStaff);
284 
285 	struct DiscountPhase {
286 		uint8 percent;
287 		uint fromDate;
288 		uint toDate;
289 	}
290 
291 	DiscountPhase[] public discountPhases;
292 
293 	constructor(Staff _staffContract) StaffUtil(_staffContract) public {
294 	}
295 
296 	function calculateBonusAmount(uint256 _purchasedAmount) public constant returns (uint256) {
297 		for (uint i = 0; i < discountPhases.length; i++) {
298 			if (now >= discountPhases[i].fromDate && now <= discountPhases[i].toDate) {
299 				return _purchasedAmount.mul(discountPhases[i].percent).div(100);
300 			}
301 		}
302 	}
303 
304 	function addDiscountPhase(string _name, uint8 _percent, uint _fromDate, uint _toDate) public onlyOwnerOrStaff {
305 		require(bytes(_name).length > 0);
306 		require(_percent > 0 && _percent <= 100);
307 
308 		if (now > _fromDate) {
309 			_fromDate = now;
310 		}
311 		require(_fromDate < _toDate);
312 
313 		for (uint i = 0; i < discountPhases.length; i++) {
314 			require(_fromDate > discountPhases[i].toDate || _toDate < discountPhases[i].fromDate);
315 		}
316 
317 		uint index = discountPhases.push(DiscountPhase({percent : _percent, fromDate : _fromDate, toDate : _toDate})) - 1;
318 
319 		emit DiscountPhaseAdded(index, _name, _percent, _fromDate, _toDate, now, msg.sender);
320 	}
321 
322 	function removeDiscountPhase(uint _index) public onlyOwnerOrStaff {
323 		require(now < discountPhases[_index].toDate);
324 		delete discountPhases[_index];
325 		emit DiscountPhaseRemoved(_index, now, msg.sender);
326 	}
327 }