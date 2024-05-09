1 pragma solidity ^0.5.0;
2 
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39      * account.
40      */
41     constructor () internal {
42         _owner = msg.sender;
43         emit OwnershipTransferred(address(0), _owner);
44     }
45 
46     /**
47      * @return the address of the owner.
48      */
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(isOwner());
58         _;
59     }
60 
61     /**
62      * @return true if `msg.sender` is the owner of the contract.
63      */
64     function isOwner() public view returns (bool) {
65         return msg.sender == _owner;
66     }
67 
68     /**
69      * @dev Allows the current owner to relinquish control of the contract.
70      * @notice Renouncing to ownership will leave the contract without an owner.
71      * It will not be possible to call the functions with the `onlyOwner`
72      * modifier anymore.
73      */
74     function renounceOwnership() public onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Allows the current owner to transfer control of the contract to a newOwner.
81      * @param newOwner The address to transfer ownership to.
82      */
83     function transferOwnership(address newOwner) public onlyOwner {
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0));
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 /**
99  * @title SafeMath
100  * @dev Unsigned math operations with safety checks that revert on error
101  */
102 library SafeMath {
103     /**
104     * @dev Multiplies two unsigned integers, reverts on overflow.
105     */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b);
116 
117         return c;
118     }
119 
120     /**
121     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
122     */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         // Solidity only automatically asserts when dividing by 0
125         require(b > 0);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
134     */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b <= a);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143     * @dev Adds two unsigned integers, reverts on overflow.
144     */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a);
148 
149         return c;
150     }
151 
152     /**
153     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
154     * reverts when dividing by zero.
155     */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b != 0);
158         return a % b;
159     }
160 }
161 
162 interface RegistryInterface {
163     struct RegisteredDerivative {
164         address derivativeAddress;
165         address derivativeCreator;
166     }
167 
168     // Registers a new derivative. Only authorized derivative creators can call this method.
169     function registerDerivative(address[] calldata counterparties, address derivativeAddress) external;
170 
171     // Adds a new derivative creator to this list of authorized creators. Only the owner of this contract can call
172     // this method.   
173     function addDerivativeCreator(address derivativeCreator) external;
174 
175     // Removes a derivative creator to this list of authorized creators. Only the owner of this contract can call this
176     // method.  
177     function removeDerivativeCreator(address derivativeCreator) external;
178 
179     // Returns whether the derivative has been registered with the registry (and is therefore an authorized participant
180     // in the UMA system).
181     function isDerivativeRegistered(address derivative) external view returns (bool isRegistered);
182 
183     // Returns a list of all derivatives that are associated with a particular party.
184     function getRegisteredDerivatives(address party) external view returns (RegisteredDerivative[] memory derivatives);
185 
186     // Returns all registered derivatives.
187     function getAllRegisteredDerivatives() external view returns (RegisteredDerivative[] memory derivatives);
188 
189     // Returns whether an address is authorized to register new derivatives.
190     function isDerivativeCreatorAuthorized(address derivativeCreator) external view returns (bool isAuthorized);
191 }
192 
193 contract Withdrawable is Ownable {
194     // Withdraws ETH from the contract.
195     function withdraw(uint amount) external onlyOwner {
196         msg.sender.transfer(amount);
197     }
198 
199     // Withdraws ERC20 tokens from the contract.
200     function withdrawErc20(address erc20Address, uint amount) external onlyOwner {
201         IERC20 erc20 = IERC20(erc20Address);
202         require(erc20.transfer(msg.sender, amount));
203     }
204 }
205 
206 contract Registry is RegistryInterface, Withdrawable {
207 
208     using SafeMath for uint;
209 
210     // Array of all registeredDerivatives that are approved to use the UMA Oracle.
211     RegisteredDerivative[] private registeredDerivatives;
212 
213     // This enum is required because a WasValid state is required to ensure that derivatives cannot be re-registered.
214     enum PointerValidity {
215         Invalid,
216         Valid,
217         WasValid
218     }
219 
220     struct Pointer {
221         PointerValidity valid;
222         uint128 index;
223     }
224 
225     // Maps from derivative address to a pointer that refers to that RegisteredDerivative in registeredDerivatives.
226     mapping(address => Pointer) private derivativePointers;
227 
228     // Note: this must be stored outside of the RegisteredDerivative because mappings cannot be deleted and copied
229     // like normal data. This could be stored in the Pointer struct, but storing it there would muddy the purpose
230     // of the Pointer struct and break separation of concern between referential data and data.
231     struct PartiesMap {
232         mapping(address => bool) parties;
233     }
234 
235     // Maps from derivative address to the set of parties that are involved in that derivative.
236     mapping(address => PartiesMap) private derivativesToParties;
237 
238     // Maps from derivative creator address to whether that derivative creator has been approved to register contracts.
239     mapping(address => bool) private derivativeCreators;
240 
241     modifier onlyApprovedDerivativeCreator {
242         require(derivativeCreators[msg.sender]);
243         _;
244     }
245 
246     function registerDerivative(address[] calldata parties, address derivativeAddress)
247         external
248         onlyApprovedDerivativeCreator
249     {
250         // Create derivative pointer.
251         Pointer storage pointer = derivativePointers[derivativeAddress];
252 
253         // Ensure that the pointer was not valid in the past (derivatives cannot be re-registered or double
254         // registered).
255         require(pointer.valid == PointerValidity.Invalid);
256         pointer.valid = PointerValidity.Valid;
257 
258         registeredDerivatives.push(RegisteredDerivative(derivativeAddress, msg.sender));
259 
260         // No length check necessary because we should never hit (2^127 - 1) derivatives.
261         pointer.index = uint128(registeredDerivatives.length.sub(1));
262 
263         // Set up PartiesMap for this derivative.
264         PartiesMap storage partiesMap = derivativesToParties[derivativeAddress];
265         for (uint i = 0; i < parties.length; i = i.add(1)) {
266             partiesMap.parties[parties[i]] = true;
267         }
268 
269         address[] memory partiesForEvent = parties;
270         emit RegisterDerivative(derivativeAddress, partiesForEvent);
271     }
272 
273     function addDerivativeCreator(address derivativeCreator) external onlyOwner {
274         if (!derivativeCreators[derivativeCreator]) {
275             derivativeCreators[derivativeCreator] = true;
276             emit AddDerivativeCreator(derivativeCreator);
277         }
278     }
279 
280     function removeDerivativeCreator(address derivativeCreator) external onlyOwner {
281         if (derivativeCreators[derivativeCreator]) {
282             derivativeCreators[derivativeCreator] = false;
283             emit RemoveDerivativeCreator(derivativeCreator);
284         }
285     }
286 
287     function isDerivativeRegistered(address derivative) external view returns (bool isRegistered) {
288         return derivativePointers[derivative].valid == PointerValidity.Valid;
289     }
290 
291     function getRegisteredDerivatives(address party) external view returns (RegisteredDerivative[] memory derivatives) {
292         // This is not ideal - we must statically allocate memory arrays. To be safe, we make a temporary array as long
293         // as registeredDerivatives. We populate it with any derivatives that involve the provided party. Then, we copy
294         // the array over to the return array, which is allocated using the correct size. Note: this is done by double
295         // copying each value rather than storing some referential info (like indices) in memory to reduce the number
296         // of storage reads. This is because storage reads are far more expensive than extra memory space (~100:1).
297         RegisteredDerivative[] memory tmpDerivativeArray = new RegisteredDerivative[](registeredDerivatives.length);
298         uint outputIndex = 0;
299         for (uint i = 0; i < registeredDerivatives.length; i = i.add(1)) {
300             RegisteredDerivative storage derivative = registeredDerivatives[i];
301             if (derivativesToParties[derivative.derivativeAddress].parties[party]) {
302                 // Copy selected derivative to the temporary array.
303                 tmpDerivativeArray[outputIndex] = derivative;
304                 outputIndex = outputIndex.add(1);
305             }
306         }
307 
308         // Copy the temp array to the return array that is set to the correct size.
309         derivatives = new RegisteredDerivative[](outputIndex);
310         for (uint j = 0; j < outputIndex; j = j.add(1)) {
311             derivatives[j] = tmpDerivativeArray[j];
312         }
313     }
314 
315     function getAllRegisteredDerivatives() external view returns (RegisteredDerivative[] memory derivatives) {
316         return registeredDerivatives;
317     }
318 
319     function isDerivativeCreatorAuthorized(address derivativeCreator) external view returns (bool isAuthorized) {
320         return derivativeCreators[derivativeCreator];
321     }
322 
323     event RegisterDerivative(address indexed derivativeAddress, address[] parties);
324     event AddDerivativeCreator(address indexed addedDerivativeCreator);
325     event RemoveDerivativeCreator(address indexed removedDerivativeCreator);
326 
327 }