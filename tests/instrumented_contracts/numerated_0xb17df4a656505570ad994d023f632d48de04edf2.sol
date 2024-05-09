1 pragma solidity >=0.5.0 <0.6.0;
2 
3 interface INMR {
4 
5     /* ERC20 Interface */
6 
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     /* NMR Special Interface */
24 
25     // used for user balance management
26     function withdraw(address _from, address _to, uint256 _value) external returns(bool ok);
27 
28     // used for migrating active stakes
29     function destroyStake(address _staker, bytes32 _tag, uint256 _tournamentID, uint256 _roundID) external returns (bool ok);
30 
31     // used for disabling token upgradability
32     function createRound(uint256, uint256, uint256, uint256) external returns (bool ok);
33 
34     // used for upgrading the token delegate logic
35     function createTournament(uint256 _newDelegate) external returns (bool ok);
36 
37     // used like burn(uint256)
38     function mint(uint256 _value) external returns (bool ok);
39 
40     // used like burnFrom(address, uint256)
41     function numeraiTransfer(address _to, uint256 _value) external returns (bool ok);
42 
43     // used to check if upgrade completed
44     function contractUpgradable() external view returns (bool);
45 
46     function getTournament(uint256 _tournamentID) external view returns (uint256, uint256[] memory);
47 
48     function getRound(uint256 _tournamentID, uint256 _roundID) external view returns (uint256, uint256, uint256);
49 
50     function getStake(uint256 _tournamentID, uint256 _roundID, address _staker, bytes32 _tag) external view returns (uint256, uint256, bool, bool);
51 
52 }
53 
54 
55 
56 /**
57  * @title Initializable
58  *
59  * @dev Helper contract to support initializer functions. To use it, replace
60  * the constructor with a function that has the `initializer` modifier.
61  * WARNING: Unlike constructors, initializer functions must be manually
62  * invoked. This applies both to deploying an Initializable contract, as well
63  * as extending an Initializable contract via inheritance.
64  * WARNING: When used with inheritance, manual care must be taken to not invoke
65  * a parent initializer twice, or ensure that all initializers are idempotent,
66  * because this is not dealt with automatically as with constructors.
67  */
68 contract Initializable {
69 
70   /**
71    * @dev Indicates that the contract has been initialized.
72    */
73   bool private initialized;
74 
75   /**
76    * @dev Indicates that the contract is in the process of being initialized.
77    */
78   bool private initializing;
79 
80   /**
81    * @dev Modifier to use in the initializer function of a contract.
82    */
83   modifier initializer() {
84     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
85 
86     bool wasInitializing = initializing;
87     initializing = true;
88     initialized = true;
89 
90     _;
91 
92     initializing = wasInitializing;
93   }
94 
95   /// @dev Returns true if and only if the function is running in the constructor
96   function isConstructor() private view returns (bool) {
97     // extcodesize checks the size of the code stored in an address, and
98     // address returns the current address. Since the code is still not
99     // deployed when running a constructor, any checks on its code size will
100     // yield zero, making it an effective way to detect if a contract is
101     // under construction or not.
102     uint256 cs;
103     assembly { cs := extcodesize(address) }
104     return cs == 0;
105   }
106 
107   // Reserved storage space to allow for layout changes in the future.
108   uint256[50] private ______gap;
109 }
110 
111 
112 /**
113  * @title Ownable
114  * @dev The Ownable contract has an owner address, and provides basic authorization control
115  * functions, this simplifies the implementation of "user permissions".
116  */
117 contract Ownable is Initializable {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
124      * account.
125      */
126     function initialize(address sender) public initializer {
127         _owner = sender;
128         emit OwnershipTransferred(address(0), _owner);
129     }
130 
131     /**
132      * @return the address of the owner.
133      */
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(isOwner());
143         _;
144     }
145 
146     /**
147      * @return true if `msg.sender` is the owner of the contract.
148      */
149     function isOwner() public view returns (bool) {
150         return msg.sender == _owner;
151     }
152 
153     /**
154      * @dev Allows the current owner to relinquish control of the contract.
155      * @notice Renouncing to ownership will leave the contract without an owner.
156      * It will not be possible to call the functions with the `onlyOwner`
157      * modifier anymore.
158      */
159     function renounceOwnership() public onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     /**
165      * @dev Allows the current owner to transfer control of the contract to a newOwner.
166      * @param newOwner The address to transfer ownership to.
167      */
168     function transferOwnership(address newOwner) public onlyOwner {
169         _transferOwnership(newOwner);
170     }
171 
172     /**
173      * @dev Transfers control of the contract to a newOwner.
174      * @param newOwner The address to transfer ownership to.
175      */
176     function _transferOwnership(address newOwner) internal {
177         require(newOwner != address(0));
178         emit OwnershipTransferred(_owner, newOwner);
179         _owner = newOwner;
180     }
181 
182     uint256[50] private ______gap;
183 }
184 
185 
186 
187 contract Manageable is Initializable, Ownable {
188     address private _manager;
189 
190     event ManagementTransferred(address indexed previousManager, address indexed newManager);
191 
192     /**
193      * @dev The Managable constructor sets the original `manager` of the contract to the sender
194      * account.
195      */
196     function initialize(address sender) initializer public {
197         Ownable.initialize(sender);
198         _manager = sender;
199         emit ManagementTransferred(address(0), _manager);
200     }
201 
202     /**
203      * @return the address of the manager.
204      */
205     function manager() public view returns (address) {
206         return _manager;
207     }
208 
209     /**
210      * @dev Throws if called by any account other than the owner or manager.
211      */
212     modifier onlyManagerOrOwner() {
213         require(isManagerOrOwner());
214         _;
215     }
216 
217     /**
218      * @return true if `msg.sender` is the owner or manager of the contract.
219      */
220     function isManagerOrOwner() public view returns (bool) {
221         return (msg.sender == _manager || isOwner());
222     }
223 
224     /**
225      * @dev Allows the current owner to transfer control of the contract to a newManager.
226      * @param newManager The address to transfer management to.
227      */
228     function transferManagement(address newManager) public onlyOwner {
229         require(newManager != address(0));
230         emit ManagementTransferred(_manager, newManager);
231         _manager = newManager;
232     }
233 
234     uint256[50] private ______gap;
235 }
236 
237 
238 
239 contract Relay is Manageable {
240 
241     bool public active = true;
242     bool private _upgraded;
243 
244     // set NMR token, 1M address, null address, burn address as constants
245     address private constant _TOKEN = address(
246         0x1776e1F26f98b1A5dF9cD347953a26dd3Cb46671
247     );
248     address private constant _ONE_MILLION_ADDRESS = address(
249         0x00000000000000000000000000000000000F4240
250     );    
251     address private constant _NULL_ADDRESS = address(
252         0x0000000000000000000000000000000000000000
253     );
254     address private constant _BURN_ADDRESS = address(
255         0x000000000000000000000000000000000000dEaD
256     );
257 
258     /// @dev Throws if the address does not match the required conditions.
259     modifier isUser(address _user) {
260         require(
261             _user <= _ONE_MILLION_ADDRESS
262             && _user != _NULL_ADDRESS
263             && _user != _BURN_ADDRESS
264             , "_from must be a user account managed by Numerai"
265         );
266         _;
267     }
268 
269     /// @dev Throws if called after the relay is disabled.
270     modifier onlyActive() {
271         require(active, "User account relay has been disabled");
272         _;
273     }
274 
275     /// @notice Contructor function called at time of deployment
276     /// @param _owner The initial owner and manager of the relay
277     constructor(address _owner) public {
278         require(
279             address(this) == address(0xB17dF4a656505570aD994D023F632D48De04eDF2),
280             "incorrect deployment address - check submitting account & nonce."
281         );
282 
283         Manageable.initialize(_owner);
284     }
285 
286     /// @notice Transfer NMR on behalf of a Numerai user
287     ///         Can only be called by Manager or Owner
288     /// @dev Can only be used on the first 1 million ethereum addresses
289     /// @param _from The user address
290     /// @param _to The recipient address
291     /// @param _value The amount of NMR in wei
292     function withdraw(address _from, address _to, uint256 _value) public onlyManagerOrOwner onlyActive isUser(_from) returns (bool ok) {
293         require(INMR(_TOKEN).withdraw(_from, _to, _value));
294         return true;
295     }
296 
297     /// @notice Burn the NMR sent to address 0 and burn address
298     function burnZeroAddress() public {
299         uint256 amtZero = INMR(_TOKEN).balanceOf(_NULL_ADDRESS);
300         uint256 amtBurn = INMR(_TOKEN).balanceOf(_BURN_ADDRESS);
301         require(INMR(_TOKEN).withdraw(_NULL_ADDRESS, address(this), amtZero));
302         require(INMR(_TOKEN).withdraw(_BURN_ADDRESS, address(this), amtBurn));
303         uint256 amtThis = INMR(_TOKEN).balanceOf(address(this));
304         _burn(amtThis);
305     }
306 
307     /// @notice Permanantly disable the relay contract
308     ///         Can only be called by Owner
309     function disable() public onlyOwner onlyActive {
310         active = false;
311     }
312 
313     /// @notice Permanantly disable token upgradability
314     ///         Can only be called by Owner
315     function disableTokenUpgradability() public onlyOwner onlyActive {
316         require(INMR(_TOKEN).createRound(uint256(0),uint256(0),uint256(0),uint256(0)));
317     }
318 
319     /// @notice Upgrade the token delegate logic.
320     ///         Can only be called by Owner
321     /// @param _newDelegate Address of the new delegate contract
322     function changeTokenDelegate(address _newDelegate) public onlyOwner onlyActive {
323         require(INMR(_TOKEN).createTournament(uint256(_newDelegate)));
324     }
325 
326     /// @notice Get the address of the NMR token contract
327     /// @return The address of the NMR token contract
328     function token() external pure returns (address) {
329         return _TOKEN;
330     }
331 
332     /// @notice Internal helper function to burn NMR
333     /// @dev If before the token upgrade, sends the tokens to address 0
334     ///      If after the token upgrade, calls the repurposed mint function to burn
335     /// @param _value The amount of NMR in wei
336     function _burn(uint256 _value) internal {
337         if (INMR(_TOKEN).contractUpgradable()) {
338             require(INMR(_TOKEN).transfer(address(0), _value));
339         } else {
340             require(INMR(_TOKEN).mint(_value), "burn not successful");
341         }
342     }
343 }