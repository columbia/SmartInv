1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86     * @dev Multiplies two unsigned integers, reverts on overflow.
87     */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116     */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125     * @dev Adds two unsigned integers, reverts on overflow.
126     */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136     * reverts when dividing by zero.
137     */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/access/Roles.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @title Roles
150  * @dev Library for managing addresses assigned to a Role.
151  */
152 library Roles {
153     struct Role {
154         mapping (address => bool) bearer;
155     }
156 
157     /**
158      * @dev give an account access to this role
159      */
160     function add(Role storage role, address account) internal {
161         require(account != address(0));
162         require(!has(role, account));
163 
164         role.bearer[account] = true;
165     }
166 
167     /**
168      * @dev remove an account's access to this role
169      */
170     function remove(Role storage role, address account) internal {
171         require(account != address(0));
172         require(has(role, account));
173 
174         role.bearer[account] = false;
175     }
176 
177     /**
178      * @dev check if an account has this role
179      * @return bool
180      */
181     function has(Role storage role, address account) internal view returns (bool) {
182         require(account != address(0));
183         return role.bearer[account];
184     }
185 }
186 
187 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
188 
189 pragma solidity ^0.5.0;
190 
191 
192 contract PauserRole {
193     using Roles for Roles.Role;
194 
195     event PauserAdded(address indexed account);
196     event PauserRemoved(address indexed account);
197 
198     Roles.Role private _pausers;
199 
200     constructor () internal {
201         _addPauser(msg.sender);
202     }
203 
204     modifier onlyPauser() {
205         require(isPauser(msg.sender));
206         _;
207     }
208 
209     function isPauser(address account) public view returns (bool) {
210         return _pausers.has(account);
211     }
212 
213     function addPauser(address account) public onlyPauser {
214         _addPauser(account);
215     }
216 
217     function renouncePauser() public {
218         _removePauser(msg.sender);
219     }
220 
221     function _addPauser(address account) internal {
222         _pausers.add(account);
223         emit PauserAdded(account);
224     }
225 
226     function _removePauser(address account) internal {
227         _pausers.remove(account);
228         emit PauserRemoved(account);
229     }
230 }
231 
232 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
233 
234 pragma solidity ^0.5.0;
235 
236 
237 /**
238  * @title Pausable
239  * @dev Base contract which allows children to implement an emergency stop mechanism.
240  */
241 contract Pausable is PauserRole {
242     event Paused(address account);
243     event Unpaused(address account);
244 
245     bool private _paused;
246 
247     constructor () internal {
248         _paused = false;
249     }
250 
251     /**
252      * @return true if the contract is paused, false otherwise.
253      */
254     function paused() public view returns (bool) {
255         return _paused;
256     }
257 
258     /**
259      * @dev Modifier to make a function callable only when the contract is not paused.
260      */
261     modifier whenNotPaused() {
262         require(!_paused);
263         _;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is paused.
268      */
269     modifier whenPaused() {
270         require(_paused);
271         _;
272     }
273 
274     /**
275      * @dev called by the owner to pause, triggers stopped state
276      */
277     function pause() public onlyPauser whenNotPaused {
278         _paused = true;
279         emit Paused(msg.sender);
280     }
281 
282     /**
283      * @dev called by the owner to unpause, returns to normal state
284      */
285     function unpause() public onlyPauser whenPaused {
286         _paused = false;
287         emit Unpaused(msg.sender);
288     }
289 }
290 
291 // File: contracts/INiftyTradingCardCreator.sol
292 
293 pragma solidity 0.5.0;
294 
295 interface INiftyTradingCardCreator {
296     function mintCard(
297         uint256 _cardType,
298         uint256 _nationality,
299         uint256 _position,
300         uint256 _ethnicity,
301         uint256 _kit,
302         uint256 _colour,
303         address _to
304     ) external returns (uint256 _tokenId);
305 
306     function setAttributes(
307         uint256 _tokenId,
308         uint256 _strength,
309         uint256 _speed,
310         uint256 _intelligence,
311         uint256 _skill
312     ) external returns (bool);
313 
314     function setName(
315         uint256 _tokenId,
316         uint256 _firstName,
317         uint256 _lastName
318     ) external returns (bool);
319 
320     function setAttributesAndName(
321         uint256 _tokenId,
322         uint256 _strength,
323         uint256 _speed,
324         uint256 _intelligence,
325         uint256 _skill,
326         uint256 _firstName,
327         uint256 _lastName
328     ) external returns (bool);
329 }
330 
331 // File: contracts/generators/INiftyFootballTradingCardGenerator.sol
332 
333 pragma solidity 0.5.0;
334 
335 contract INiftyFootballTradingCardGenerator {
336     function generateCard(address _sender) external returns (uint256 _nationality, uint256 _position, uint256 _ethnicity, uint256 _kit, uint256 _colour);
337 
338     function generateAttributes(address _sender, uint256 _base) external returns (uint256 strength, uint256 speed, uint256 intelligence, uint256 skill);
339 
340     function generateName(address _sender) external returns (uint256 firstName, uint256 lastName);
341 }
342 
343 // File: contracts/NiftyFootballAdmin.sol
344 
345 pragma solidity 0.5.0;
346 
347 
348 
349 
350 
351 
352 contract NiftyFootballAdmin is Ownable, Pausable {
353     using SafeMath for uint256;
354 
355     INiftyFootballTradingCardGenerator public generator;
356     INiftyTradingCardCreator public creator;
357 
358     uint256 public cardTypeDefault = 100;
359     uint256 public attributesBase = 50;
360 
361     constructor (
362         INiftyFootballTradingCardGenerator _generator,
363         INiftyTradingCardCreator _creator
364     ) public {
365         generator = _generator;
366         creator = _creator;
367     }
368 
369     function generateAndAssignCard(
370         uint256 _nationality,
371         uint256 _position,
372         uint256 _ethnicity,
373         uint256 _kit,
374         uint256 _colour,
375         uint256 _firstName,
376         uint256 _lastName,
377         address _to
378     ) public onlyOwner returns (uint256) {
379 
380         // 100 for special
381         uint256 tokenId = creator.mintCard(cardTypeDefault, _nationality, _position, _ethnicity, _kit, _colour, _to);
382         
383         // Generate attributes as normal
384         (uint256 _strength, uint256 _speed, uint256 _intelligence, uint256 _skill) = generator.generateAttributes(msg.sender, attributesBase);
385 
386         creator.setAttributesAndName(tokenId, _strength, _speed, _intelligence, _skill, _firstName, _lastName);
387 
388         return tokenId;
389     }
390 
391     function setCardTypeDefault(uint256 _newDefaultCardType) public onlyOwner returns (bool) {
392         cardTypeDefault = _newDefaultCardType;
393         return true;
394     }
395 
396     function setAttributesBase(uint256 _newAttributesBase) public onlyOwner returns (bool) {
397         attributesBase = _newAttributesBase;
398         return true;
399     }
400 
401     function setFutballCardsGenerator(INiftyFootballTradingCardGenerator _futballCardsGenerator) public onlyOwner returns (bool) {
402         generator = _futballCardsGenerator;
403         return true;
404     }
405 }