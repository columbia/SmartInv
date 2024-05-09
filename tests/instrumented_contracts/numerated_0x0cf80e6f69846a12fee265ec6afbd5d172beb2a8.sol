1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 contract RBAC {
61   using Roles for Roles.Role;
62 
63   mapping (string => Roles.Role) private roles;
64 
65   event RoleAdded(address indexed operator, string role);
66   event RoleRemoved(address indexed operator, string role);
67 
68   /**
69    * @dev reverts if addr does not have role
70    * @param _operator address
71    * @param _role the name of the role
72    * // reverts
73    */
74   function checkRole(address _operator, string _role)
75     view
76     public
77   {
78     roles[_role].check(_operator);
79   }
80 
81   /**
82    * @dev determine if addr has role
83    * @param _operator address
84    * @param _role the name of the role
85    * @return bool
86    */
87   function hasRole(address _operator, string _role)
88     view
89     public
90     returns (bool)
91   {
92     return roles[_role].has(_operator);
93   }
94 
95   /**
96    * @dev add a role to an address
97    * @param _operator address
98    * @param _role the name of the role
99    */
100   function addRole(address _operator, string _role)
101     internal
102   {
103     roles[_role].add(_operator);
104     emit RoleAdded(_operator, _role);
105   }
106 
107   /**
108    * @dev remove a role from an address
109    * @param _operator address
110    * @param _role the name of the role
111    */
112   function removeRole(address _operator, string _role)
113     internal
114   {
115     roles[_role].remove(_operator);
116     emit RoleRemoved(_operator, _role);
117   }
118 
119   /**
120    * @dev modifier to scope access to a single role (uses msg.sender as addr)
121    * @param _role the name of the role
122    * // reverts
123    */
124   modifier onlyRole(string _role)
125   {
126     checkRole(msg.sender, _role);
127     _;
128   }
129 
130   /**
131    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
132    * @param _roles the names of the roles to scope access to
133    * // reverts
134    *
135    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
136    *  see: https://github.com/ethereum/solidity/issues/2467
137    */
138   // modifier onlyRoles(string[] _roles) {
139   //     bool hasAnyRole = false;
140   //     for (uint8 i = 0; i < _roles.length; i++) {
141   //         if (hasRole(msg.sender, _roles[i])) {
142   //             hasAnyRole = true;
143   //             break;
144   //         }
145   //     }
146 
147   //     require(hasAnyRole);
148 
149   //     _;
150   // }
151 }
152 
153 contract Whitelist is Ownable, RBAC {
154   string public constant ROLE_WHITELISTED = "whitelist";
155 
156   /**
157    * @dev Throws if operator is not whitelisted.
158    * @param _operator address
159    */
160   modifier onlyIfWhitelisted(address _operator) {
161     checkRole(_operator, ROLE_WHITELISTED);
162     _;
163   }
164 
165   /**
166    * @dev add an address to the whitelist
167    * @param _operator address
168    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
169    */
170   function addAddressToWhitelist(address _operator)
171     onlyOwner
172     public
173   {
174     addRole(_operator, ROLE_WHITELISTED);
175   }
176 
177   /**
178    * @dev getter to determine if address is in whitelist
179    */
180   function whitelist(address _operator)
181     public
182     view
183     returns (bool)
184   {
185     return hasRole(_operator, ROLE_WHITELISTED);
186   }
187 
188   /**
189    * @dev add addresses to the whitelist
190    * @param _operators addresses
191    * @return true if at least one address was added to the whitelist,
192    * false if all addresses were already in the whitelist
193    */
194   function addAddressesToWhitelist(address[] _operators)
195     onlyOwner
196     public
197   {
198     for (uint256 i = 0; i < _operators.length; i++) {
199       addAddressToWhitelist(_operators[i]);
200     }
201   }
202 
203   /**
204    * @dev remove an address from the whitelist
205    * @param _operator address
206    * @return true if the address was removed from the whitelist,
207    * false if the address wasn't in the whitelist in the first place
208    */
209   function removeAddressFromWhitelist(address _operator)
210     onlyOwner
211     public
212   {
213     removeRole(_operator, ROLE_WHITELISTED);
214   }
215 
216   /**
217    * @dev remove addresses from the whitelist
218    * @param _operators addresses
219    * @return true if at least one address was removed from the whitelist,
220    * false if all addresses weren't in the whitelist in the first place
221    */
222   function removeAddressesFromWhitelist(address[] _operators)
223     onlyOwner
224     public
225   {
226     for (uint256 i = 0; i < _operators.length; i++) {
227       removeAddressFromWhitelist(_operators[i]);
228     }
229   }
230 
231 }
232 
233 contract Distribute is Whitelist {
234     using SafeERC20 for ERC20;
235 
236     event TokenReleased(address indexed buyer, uint256 amount);
237 
238     ERC20 public Token;
239 
240     constructor(address token) public {
241         require(token != address(0));
242         Token = ERC20(token);
243     }
244 
245     function release(address beneficiary, uint256 amount)
246         public
247         onlyIfWhitelisted(msg.sender)
248     {
249         Token.safeTransfer(beneficiary, amount);
250         emit TokenReleased(beneficiary, amount);
251     }
252 
253     function releaseMany(address[] beneficiaries, uint256[] amounts)
254         external
255         onlyIfWhitelisted(msg.sender)
256     {
257         require(beneficiaries.length == amounts.length);
258         for (uint256 i = 0; i < beneficiaries.length; i++) {
259             release(beneficiaries[i], amounts[i]);
260         }
261     }
262 
263     function withdraw()
264         public
265         onlyOwner
266     {
267         Token.safeTransfer(owner, Token.balanceOf(address(this)));
268     }
269 
270     function close()
271         external
272         onlyOwner
273     {
274         withdraw();
275         selfdestruct(owner);
276     }
277 }
278 
279 library Roles {
280   struct Role {
281     mapping (address => bool) bearer;
282   }
283 
284   /**
285    * @dev give an address access to this role
286    */
287   function add(Role storage role, address addr)
288     internal
289   {
290     role.bearer[addr] = true;
291   }
292 
293   /**
294    * @dev remove an address' access to this role
295    */
296   function remove(Role storage role, address addr)
297     internal
298   {
299     role.bearer[addr] = false;
300   }
301 
302   /**
303    * @dev check if an address has this role
304    * // reverts
305    */
306   function check(Role storage role, address addr)
307     view
308     internal
309   {
310     require(has(role, addr));
311   }
312 
313   /**
314    * @dev check if an address has this role
315    * @return bool
316    */
317   function has(Role storage role, address addr)
318     view
319     internal
320     returns (bool)
321   {
322     return role.bearer[addr];
323   }
324 }
325 
326 contract ERC20Basic {
327   function totalSupply() public view returns (uint256);
328   function balanceOf(address who) public view returns (uint256);
329   function transfer(address to, uint256 value) public returns (bool);
330   event Transfer(address indexed from, address indexed to, uint256 value);
331 }
332 
333 contract ERC20 is ERC20Basic {
334   function allowance(address owner, address spender)
335     public view returns (uint256);
336 
337   function transferFrom(address from, address to, uint256 value)
338     public returns (bool);
339 
340   function approve(address spender, uint256 value) public returns (bool);
341   event Approval(
342     address indexed owner,
343     address indexed spender,
344     uint256 value
345   );
346 }
347 
348 library SafeERC20 {
349   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
350     require(token.transfer(to, value));
351   }
352 
353   function safeTransferFrom(
354     ERC20 token,
355     address from,
356     address to,
357     uint256 value
358   )
359     internal
360   {
361     require(token.transferFrom(from, to, value));
362   }
363 
364   function safeApprove(ERC20 token, address spender, uint256 value) internal {
365     require(token.approve(spender, value));
366   }
367 }