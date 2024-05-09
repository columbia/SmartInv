1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
68 
69 /**
70  * @title Contracts that should not own Ether
71  * @author Remco Bloemen <remco@2π.com>
72  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
73  * in the contract, it will allow the owner to reclaim this Ether.
74  * @notice Ether can still be sent to this contract by:
75  * calling functions labeled `payable`
76  * `selfdestruct(contract_address)`
77  * mining directly to the contract address
78  */
79 contract HasNoEther is Ownable {
80 
81   /**
82   * @dev Constructor that rejects incoming Ether
83   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
84   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
85   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
86   * we could use assembly to access msg.value.
87   */
88   constructor() public payable {
89     require(msg.value == 0);
90   }
91 
92   /**
93    * @dev Disallows direct send by setting a default function without the `payable` flag.
94    */
95   function() external {
96   }
97 
98   /**
99    * @dev Transfer all Ether held by the contract to the owner.
100    */
101   function reclaimEther() external onlyOwner {
102     owner.transfer(address(this).balance);
103   }
104 }
105 
106 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * See https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address _who) public view returns (uint256);
116   function transfer(address _to, uint256 _value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address _owner, address _spender)
128     public view returns (uint256);
129 
130   function transferFrom(address _from, address _to, uint256 _value)
131     public returns (bool);
132 
133   function approve(address _spender, uint256 _value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
142 
143 /**
144  * @title SafeERC20
145  * @dev Wrappers around ERC20 operations that throw on failure.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150   function safeTransfer(
151     ERC20Basic _token,
152     address _to,
153     uint256 _value
154   )
155     internal
156   {
157     require(_token.transfer(_to, _value));
158   }
159 
160   function safeTransferFrom(
161     ERC20 _token,
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     internal
167   {
168     require(_token.transferFrom(_from, _to, _value));
169   }
170 
171   function safeApprove(
172     ERC20 _token,
173     address _spender,
174     uint256 _value
175   )
176     internal
177   {
178     require(_token.approve(_spender, _value));
179   }
180 }
181 
182 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
183 
184 /**
185  * @title Contracts that should be able to recover tokens
186  * @author SylTi
187  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
188  * This will prevent any accidental loss of tokens.
189  */
190 contract CanReclaimToken is Ownable {
191   using SafeERC20 for ERC20Basic;
192 
193   /**
194    * @dev Reclaim all ERC20Basic compatible tokens
195    * @param _token ERC20Basic The address of the token contract
196    */
197   function reclaimToken(ERC20Basic _token) external onlyOwner {
198     uint256 balance = _token.balanceOf(this);
199     _token.safeTransfer(owner, balance);
200   }
201 
202 }
203 
204 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
205 
206 /**
207  * @title Contracts that should not own Tokens
208  * @author Remco Bloemen <remco@2π.com>
209  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
210  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
211  * owner to reclaim the tokens.
212  */
213 contract HasNoTokens is CanReclaimToken {
214 
215  /**
216   * @dev Reject all ERC223 compatible tokens
217   * @param _from address The address that is transferring the tokens
218   * @param _value uint256 the amount of the specified token
219   * @param _data Bytes The data passed from the caller.
220   */
221   function tokenFallback(
222     address _from,
223     uint256 _value,
224     bytes _data
225   )
226     external
227     pure
228   {
229     _from;
230     _value;
231     _data;
232     revert();
233   }
234 
235 }
236 
237 // File: contracts/IPassportLogicRegistry.sol
238 
239 interface IPassportLogicRegistry {
240     /**
241      * @dev This event will be emitted every time a new passport logic implementation is registered
242      * @param version representing the version name of the registered passport logic implementation
243      * @param implementation representing the address of the registered passport logic implementation
244      */
245     event PassportLogicAdded(string version, address implementation);
246 
247     /**
248      * @dev This event will be emitted every time a new passport logic implementation is set as current one
249      * @param version representing the version name of the current passport logic implementation
250      * @param implementation representing the address of the current passport logic implementation
251      */
252     event CurrentPassportLogicSet(string version, address implementation);
253 
254     /**
255      * @dev Tells the address of the passport logic implementation for a given version
256      * @param _version to query the implementation of
257      * @return address of the passport logic implementation registered for the given version
258      */
259     function getPassportLogic(string _version) external view returns (address);
260 
261     /**
262      * @dev Tells the version of the current passport logic implementation
263      * @return version of the current passport logic implementation
264      */
265     function getCurrentPassportLogicVersion() external view returns (string);
266 
267     /**
268      * @dev Tells the address of the current passport logic implementation
269      * @return address of the current passport logic implementation
270      */
271     function getCurrentPassportLogic() external view returns (address);
272 }
273 
274 // File: contracts/PassportLogicRegistry.sol
275 
276 /**
277  * @title PassportImplRegistry
278  * @dev This contract works as a registry of passport implementations, it holds the implementations for the registered versions.
279  */
280 contract PassportLogicRegistry is IPassportLogicRegistry, Ownable, HasNoEther, HasNoTokens {
281     // current passport version/implementation
282     string internal currentPassportLogicVersion;
283     address internal currentPassportLogic;
284 
285     // Mapping of versions to passport implementations
286     mapping(string => address) internal passportLogicImplementations;
287 
288     /**
289      * @dev The PassportImplRegistry constructor sets the current passport version and implementation.
290      */
291     constructor (string _version, address _implementation) public {
292         _addPassportLogic(_version, _implementation);
293         _setCurrentPassportLogic(_version);
294     }
295 
296     /**
297      * @dev Registers a new passport version with its logic implementation address
298      * @param _version representing the version name of the new passport logic implementation to be registered
299      * @param _implementation representing the address of the new passport logic implementation to be registered
300      */
301     function addPassportLogic(string _version, address _implementation) public onlyOwner {
302         _addPassportLogic(_version, _implementation);
303     }
304 
305     /**
306      * @dev Tells the address of the passport logic implementation for a given version
307      * @param _version to query the implementation of
308      * @return address of the passport logic implementation registered for the given version
309      */
310     function getPassportLogic(string _version) external view returns (address) {
311         return passportLogicImplementations[_version];
312     }
313 
314     /**
315      * @dev Sets a new passport logic implementation as current one
316      * @param _version representing the version name of the passport logic implementation to be set as current one
317      */
318     function setCurrentPassportLogic(string _version) public onlyOwner {
319         _setCurrentPassportLogic(_version);
320     }
321 
322     /**
323      * @dev Tells the version of the current passport logic implementation
324      * @return version of the current passport logic implementation
325      */
326     function getCurrentPassportLogicVersion() external view returns (string) {
327         return currentPassportLogicVersion;
328     }
329 
330     /**
331      * @dev Tells the address of the current passport logic implementation
332      * @return address of the current passport logic implementation
333      */
334     function getCurrentPassportLogic() external view returns (address) {
335         return currentPassportLogic;
336     }
337 
338     function _addPassportLogic(string _version, address _implementation) internal {
339         require(_implementation != 0x0, "Cannot set implementation to a zero address");
340         require(passportLogicImplementations[_version] == 0x0, "Cannot replace existing version implementation");
341 
342         passportLogicImplementations[_version] = _implementation;
343         emit PassportLogicAdded(_version, _implementation);
344     }
345 
346     function _setCurrentPassportLogic(string _version) internal {
347         require(passportLogicImplementations[_version] != 0x0, "Cannot set non-existing passport logic as current implementation");
348 
349         currentPassportLogicVersion = _version;
350         currentPassportLogic = passportLogicImplementations[_version];
351         emit CurrentPassportLogicSet(currentPassportLogicVersion, currentPassportLogic);
352     }
353 }