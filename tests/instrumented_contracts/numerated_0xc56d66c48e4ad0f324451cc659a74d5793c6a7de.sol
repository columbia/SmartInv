1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     mapping(address => uint256) public balances;
10 
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22     function allowance(address owner, address spender) public view returns (uint256);
23     function transferFrom(address from, address to, uint256 value) public returns (bool);
24     function approve(address spender, uint256 value) public returns (bool);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34     address public owner;
35 
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40     /**
41      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42      * account.
43      */
44     function Ownable() public {
45         owner = msg.sender;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 
66 }
67 
68 /**
69  * @title Freezing tokens
70  */
71 contract Freezing is Ownable, ERC20Basic {
72     using SafeMath for uint256;
73 
74     address tokenManager;
75 
76     bool freezingActive = true;
77 
78     event Freeze(address _holder, uint256 _amount);
79     event Unfreeze(address _holder, uint256 _amount);
80 
81     // all freezing sum for every holder
82     mapping(address => uint256) public freezeBalances;
83 
84     modifier onlyTokenManager() {
85         assert(msg.sender == tokenManager);
86         _;
87     }
88 
89     /**
90      * @dev Check freezing balance
91      */
92     modifier checkFreezing(address _holder, uint _value) {
93         if (freezingActive) {
94             require(balances[_holder].sub(_value) >= freezeBalances[_holder]);
95         }
96         _;
97     }
98 
99 
100     function setTokenManager(address _newManager) onlyOwner public {
101         tokenManager = _newManager;
102     }
103 
104     /**
105      * @dev Enable freezing for contract
106      */
107     function onFreezing() onlyTokenManager public {
108         freezingActive = true;
109     }
110 
111     /**
112      * @dev Disable freezing for contract
113      */
114     function offFreezing() onlyTokenManager public {
115         freezingActive = false;
116     }
117 
118     function Freezing() public {
119         tokenManager = owner;
120     }
121 
122     /**
123      * @dev Returns freezing balance of _holder
124      */
125     function freezingBalanceOf(address _holder) public view returns (uint256) {
126         return freezeBalances[_holder];
127     }
128 
129     /**
130      * @dev Freeze amount for user
131      */
132     function freeze(address _holder, uint _amount) public onlyTokenManager {
133         assert(balances[_holder].sub(_amount.add(freezeBalances[_holder])) >= 0);
134 
135         freezeBalances[_holder] = freezeBalances[_holder].add(_amount);
136         emit Freeze(_holder, _amount);
137     }
138 
139     /**
140      * @dev Unfreeze amount for user
141      */
142     function unfreeze(address _holder, uint _amount) public onlyTokenManager {
143         assert(freezeBalances[_holder].sub(_amount) >= 0);
144 
145         freezeBalances[_holder] = freezeBalances[_holder].sub(_amount);
146         emit Unfreeze(_holder, _amount);
147     }
148 
149 }
150 
151 
152 /**
153  * @title SafeMath
154  * @dev Math operations with safety checks that throw on error
155  */
156 library SafeMath {
157 
158     /**
159     * @dev Multiplies two numbers, throws on overflow.
160     */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         if (a == 0) {
163             return 0;
164         }
165         uint256 c = a * b;
166         assert(c / a == b);
167         return c;
168     }
169 
170     /**
171     * @dev Integer division of two numbers, truncating the quotient.
172     */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         // assert(b > 0); // Solidity automatically throws when dividing by 0
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177         return c;
178     }
179 
180     /**
181     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
182     */
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         assert(b <= a);
185         return a - b;
186     }
187 
188     /**
189     * @dev Adds two numbers, throws on overflow.
190     */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         assert(c >= a);
194         return c;
195     }
196 }
197 
198 /**
199  * @title Roles of users
200  */
201 contract VerificationStatus {
202     enum Statuses {None, Self, Video, Agent, Service}
203     Statuses constant defaultStatus = Statuses.None;
204 
205     event StatusChange(bytes32 _property, address _user, Statuses _status, address _caller);
206 }
207 
208 
209 /**
210  * @title Roles of users
211  *
212  * @dev User roles for KYC Contract
213  */
214 contract Roles is Ownable {
215 
216     // 0, 1, 2
217     enum RoleItems {Person, Agent, Administrator}
218     RoleItems constant defaultRole = RoleItems.Person;
219 
220     mapping (address => RoleItems) private roleList;
221 
222     /**
223      * @dev Event for every change of role
224      */
225     event RoleChange(address _user, RoleItems _role, address _caller);
226 
227     /**
228      * @dev for agent function
229      */
230     modifier onlyAgent() {
231         assert(roleList[msg.sender] == RoleItems.Agent);
232         _;
233     }
234 
235     /**
236      * @dev for administrator function
237      */
238     modifier onlyAdministrator() {
239         assert(roleList[msg.sender] == RoleItems.Administrator || msg.sender == owner);
240         _;
241     }
242 
243     /**
244      * @dev Save role for user
245      */
246     function _setRole(address _user, RoleItems _role) internal {
247         emit RoleChange(_user, _role, msg.sender);
248         roleList[_user] = _role;
249     }
250 
251     /**
252      * @dev reset role
253      */
254     function resetRole(address _user) onlyAdministrator public {
255         _setRole(_user, RoleItems.Person);
256     }
257 
258     /**
259      * @dev Appointing agent by administrator or owner
260      */
261     function appointAgent(address _user) onlyAdministrator public {
262         _setRole(_user, RoleItems.Agent);
263     }
264 
265     /**
266      * @dev Appointing administrator by owner
267      */
268     function appointAdministrator(address _user) onlyOwner public returns (bool) {
269         _setRole(_user, RoleItems.Administrator);
270         return true;
271     }
272 
273     function getRole(address _user) public view returns (RoleItems) {
274         return roleList[_user];
275     }
276 
277 }
278 
279 /**
280  * @title Storage for users data
281  */
282 contract PropertyStorage is Roles, VerificationStatus {
283 
284     struct Property {
285     Statuses status;
286     bool exist;
287     uint16 code;
288     }
289 
290     mapping(address => mapping(bytes32 => Property)) private propertyStorage;
291 
292     // agent => property => status
293     mapping(address => mapping(bytes32 => bool)) agentSign;
294 
295     event NewProperty(bytes32 _property, address _user, address _caller);
296 
297     modifier propertyExist(bytes32 _property, address _user) {
298         assert(propertyStorage[_user][_property].exist);
299         _;
300     }
301 
302     /**
303      *  @dev Compute hash for property before write into storage
304      *
305      *  @param _name Name of property (such as full_name, birthday, address etc.)
306      *  @param _data Value of property
307      */
308     function computePropertyHash(string _name, string _data) pure public returns (bytes32) {
309         return sha256(_name, _data);
310     }
311 
312     function _addPropertyValue(bytes32 _property, address _user) internal {
313         propertyStorage[_user][_property] = Property(
314         Statuses.None,
315         true,
316         0
317         );
318         emit NewProperty(_property, _user, msg.sender);
319     }
320 
321     /**
322      * @dev Add data for any user by administrator
323      */
324     function addPropertyForUser(bytes32 _property, address _user) public onlyAdministrator returns (bool) {
325         _addPropertyValue(_property, _user);
326         return true;
327     }
328 
329     /**
330      *  @dev Add property for sender
331      */
332     function addProperty(bytes32 _property) public returns (bool) {
333         _addPropertyValue(_property, msg.sender);
334         return true;
335     }
336 
337     /**
338      * @dev Returns status of user data (may be self 1, video 2, agent 3 or Service 4)
339      * @dev If verification is empty then it returns 0 (None)
340      */
341     function getPropertyStatus(bytes32 _property, address _user) public view propertyExist(_property, _user) returns (Statuses) {
342         return propertyStorage[_user][_property].status;
343     }
344 
345     /**
346      * @dev when user upload documents administrator will call this function
347      */
348     function setPropertyStatus(bytes32 _property, address _user, Statuses _status) public onlyAdministrator returns (bool){
349         _setPropertyStatus(_property, _user, _status);
350         return true;
351     }
352 
353     /**
354      * @dev Agent sign on user data by agent
355      */
356     function setAgentVerificationByAgent(bytes32 _property, address _user) public onlyAgent {
357         _setPropertyStatus(_property, _user, Statuses.Agent);
358         _signPropertyByAgent(msg.sender, _user, _property);
359     }
360 
361     /**
362      * @dev Agent sign on user data by Admin
363      */
364     function setAgentVerificationByAdmin(address _agent, address _user, bytes32 _property) public onlyOwner {
365         _setPropertyStatus(_property, _user, Statuses.Agent);
366         _signPropertyByAgent(_agent, _user, _property);
367     }
368 
369     /**
370      * @dev Set verification status for user data
371      */
372     function _setPropertyStatus(bytes32 _property, address _user, Statuses _status) internal propertyExist(_property, _user) {
373         propertyStorage[_user][_property].status = _status;
374         emit StatusChange(_property, _user, _status, msg.sender);
375     }
376 
377     /**
378      * @dev Agent sign on user data
379      */
380     function _signPropertyByAgent(address _agent, address _user, bytes32 _property) internal {
381         bytes32 _hash = _getHash(_user, _property);
382         agentSign[_agent][_hash] = true;
383     }
384 
385     /**
386      * @dev To make sure that the agent has signed the user property
387      */
388     function checkAgentSign(address _agent, address _user, bytes32 _property) public view returns (bool) {
389         bytes32 _hash = _getHash(_user, _property);
390         return agentSign[_agent][_hash];
391     }
392 
393     /**
394      * @dev Get hash sum for property
395      */
396     function _getHash(address _user, bytes32 _property) public pure returns (bytes32) {
397         return sha256(_user, _property);
398     }
399 
400 }
401 
402 /**
403  * @title Basic token
404  * @dev Basic version of StandardToken, with no allowances.
405  */
406 contract ERC20BasicToken is ERC20Basic, Freezing {
407     using SafeMath for uint256;
408 
409     uint256 totalSupply_;
410 
411     /**
412     * @dev total number of tokens in existence
413     */
414     function totalSupply() public view returns (uint256) {
415         return totalSupply_;
416     }
417 
418     /**
419     * @dev transfer token for a specified address
420     * @param _to The address to transfer to.
421     * @param _value The amount to be transferred.
422     */
423     function transfer(address _to, uint256 _value) checkFreezing(msg.sender, _value) public returns (bool) {
424         require(_to != address(0));
425         require(_value <= balances[msg.sender]);
426 
427         // SafeMath.sub will throw if there is not enough balance.
428         balances[msg.sender] = balances[msg.sender].sub(_value);
429         balances[_to] = balances[_to].add(_value);
430         emit Transfer(msg.sender, _to, _value);
431         return true;
432     }
433 
434     /**
435     * @dev Gets the balance of the specified address.
436     * @param _owner The address to query the the balance of.
437     * @return An uint256 representing the amount owned by the passed address.
438     */
439     function balanceOf(address _owner) public view returns (uint256 balance) {
440         return balances[_owner];
441     }
442 
443 }
444 
445 /**
446  * @title Standard ERC20 token
447  *
448  * @dev Implementation of the basic standard token.
449  * @dev https://github.com/ethereum/EIPs/issues/20
450  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
451  */
452 contract KYCToken is ERC20BasicToken, ERC20, PropertyStorage {
453 
454     mapping(address => mapping(address => uint256)) internal allowed;
455 
456     uint256 public totalSupply = 42000000000000000000000000;
457     string public name = "KYC.Legal token";
458     uint8 public decimals = 18;
459     string public symbol = "KYC";
460 
461     function balanceOf(address _owner) view public returns (uint256 balance) {
462         return balances[_owner];
463     }
464 
465     function KYCToken() public {
466         balances[msg.sender] = totalSupply;
467     }
468 
469     /**
470      * @dev Transfer tokens from one address to another
471      * @param _from address The address which you want to send tokens from
472      * @param _to address The address which you want to transfer to
473      * @param _value uint256 the amount of tokens to be transferred
474      */
475     function transferFrom(address _from, address _to, uint256 _value) checkFreezing(_from, _value) public returns (bool) {
476         require(_to != address(0));
477         require(_value <= balances[_from]);
478         require(_value <= allowed[_from][msg.sender]);
479 
480         balances[_from] = balances[_from].sub(_value);
481         balances[_to] = balances[_to].add(_value);
482         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
483         emit Transfer(_from, _to, _value);
484         return true;
485     }
486 
487     /**
488      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
489      *
490      * Beware that changing an allowance with this method brings the risk that someone may use both the old
491      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
492      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
493      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
494      * @param _spender The address which will spend the funds.
495      * @param _value The amount of tokens to be spent.
496      */
497     function approve(address _spender, uint256 _value) public returns (bool) {
498         allowed[msg.sender][_spender] = _value;
499         emit Approval(msg.sender, _spender, _value);
500         return true;
501     }
502 
503     /**
504      * @dev Function to check the amount of tokens that an owner allowed to a spender.
505      * @param _owner address The address which owns the funds.
506      * @param _spender address The address which will spend the funds.
507      * @return A uint256 specifying the amount of tokens still available for the spender.
508      */
509     function allowance(address _owner, address _spender) public constant returns (uint256) {
510         return allowed[_owner][_spender];
511     }
512 
513 }