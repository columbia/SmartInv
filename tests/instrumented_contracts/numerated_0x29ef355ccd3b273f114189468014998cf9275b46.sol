1 // File: zos-lib/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.6.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     uint256 cs;
57     assembly { cs := extcodesize(address) }
58     return cs == 0;
59   }
60 
61   // Reserved storage space to allow for layout changes in the future.
62   uint256[50] private ______gap;
63 }
64 
65 // File: zos-lib/contracts/ownership/Ownable.sol
66 
67 pragma solidity ^0.5.0;
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  *
74  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
75  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
76  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
77  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
78  */
79 contract ZOSLibOwnable {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86      * account.
87      */
88     constructor () internal {
89         _owner = msg.sender;
90         emit OwnershipTransferred(address(0), _owner);
91     }
92 
93     /**
94      * @return the address of the owner.
95      */
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(isOwner());
105         _;
106     }
107 
108     /**
109      * @return true if `msg.sender` is the owner of the contract.
110      */
111     function isOwner() public view returns (bool) {
112         return msg.sender == _owner;
113     }
114 
115     /**
116      * @dev Allows the current owner to relinquish control of the contract.
117      * @notice Renouncing to ownership will leave the contract without an owner.
118      * It will not be possible to call the functions with the `onlyOwner`
119      * modifier anymore.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 // File: contracts/AvatarNameStorage.sol
146 
147 pragma solidity ^0.5.0;
148 
149 contract ERC20Interface {
150     function balanceOf(address from) public view returns (uint256);
151     function transferFrom(address from, address to, uint tokens) public returns (bool);
152     function allowance(address owner, address spender) public view returns (uint256);
153     function burn(uint256 amount) public;
154 }
155 
156 contract AvatarNameStorage {
157     // Storage
158     ERC20Interface public manaToken;
159     uint256 public price;
160 
161     struct Data {
162         string username;
163         string metadata;
164     }
165 
166     // Stores usernames used
167     mapping (string => address) usernames;
168     // Stores account data
169     mapping (address => Data) public user;
170     // Stores account roles
171     mapping (address => bool) public allowed;
172 
173     // Events
174     event Register(
175         address indexed _owner,
176         string _username,
177         string _metadata,
178         address indexed _caller
179     );
180     event MetadataChanged(address indexed _owner, string _metadata);
181     event Allow(address indexed _caller, address indexed _account, bool _allowed);
182 }
183 
184 // File: contracts/AvatarNameRegistry.sol
185 
186 pragma solidity ^0.5.0;
187 
188 
189 
190 
191 
192 contract AvatarNameRegistry is ZOSLibOwnable, Initializable, AvatarNameStorage {
193 
194     /**
195     * @dev Initializer of the contract
196     * @param _mana - address of the mana token
197     * @param _owner - address of the owner allowed to register usernames and assign the role
198     */
199     function initialize(
200         ERC20Interface _mana,
201         address _owner
202     )
203     public initializer
204     {
205         manaToken = _mana;
206         price = 100000000000000000000; // 100 in wei
207 
208         // Allow owner to register usernames
209         allowed[_owner] = true;
210 
211         // Owner
212         transferOwnership(_owner);
213     }
214 
215     /**
216     * @dev Check if the sender is an allowed account
217     */
218     modifier onlyAllowed() {
219         require(
220             allowed[msg.sender] == true,
221             "The sender is not allowed to register a username"
222         );
223         _;
224     }
225 
226     /**
227     * @dev Manage role for an account
228     * @param _account - address of the account to be managed
229     * @param _allowed - bool whether the account should be allowed or not
230     */
231     function setAllowed(address _account, bool _allowed) external onlyOwner {
232         require(_account != msg.sender, "You can not manage your role");
233         allowed[_account] = _allowed;
234         emit Allow(msg.sender, _account, _allowed);
235     }
236 
237     /**
238     * @dev Register a usename
239     * @notice that the username should be less than or equal 32 bytes and blanks are not allowed
240     * @param _beneficiary - address of the account to be managed
241     * @param _username - string for the username
242     * @param _metadata - string for the metadata
243     */
244     function _registerUsername(
245         address _beneficiary,
246         string memory _username,
247         string memory _metadata
248     )
249     internal
250     {
251         _requireBalance(_beneficiary);
252         _requireUsernameValid(_username);
253         require(isUsernameAvailable(_username), "The username was already taken");
254 
255         // manaToken.transferFrom(_beneficiary, address(this), price);
256         // manaToken.burn(price);
257 
258         // Save username
259         usernames[_username] = _beneficiary;
260 
261         Data storage data = user[_beneficiary];
262 
263         // Free previous username
264         delete usernames[data.username];
265 
266         // Set data
267         data.username = _username;
268 
269         bytes memory metadata = bytes(_metadata);
270         if (metadata.length > 0) {
271             data.metadata = _metadata;
272         }
273 
274         emit Register(
275             _beneficiary,
276             _username,
277             data.metadata,
278             msg.sender
279         );
280     }
281 
282     /**
283     * @dev Register a usename
284     * @notice that the username can only be registered by an allowed account
285     * @param _beneficiary - address of the account to be managed
286     * @param _username - string for the username
287     * @param _metadata - string for the metadata
288     */
289     function registerUsername(
290         address _beneficiary,
291         string calldata _username,
292         string calldata _metadata
293     )
294     external
295     onlyAllowed
296     {
297         _registerUsername(_beneficiary, _username, _metadata);
298     }
299 
300     /**
301     * @dev Set metadata for an existing user
302     * @param _metadata - string for the metadata
303     */
304     function setMetadata(string calldata _metadata) external {
305         require(userExists(msg.sender), "The user does not exist");
306 
307         user[msg.sender].metadata = _metadata;
308         emit MetadataChanged(msg.sender, _metadata);
309     }
310 
311     /**
312     * @dev Check whether a user exist or not
313     * @param _user - address for the user
314     * @return bool - whether the user exist or not
315     */
316     function userExists(address _user) public view returns (bool) {
317         Data memory data = user[_user];
318         bytes memory username = bytes(data.username);
319         return username.length > 0;
320     }
321 
322     /**
323     * @dev Check whether a username is available or not
324     * @param _username - string for the username
325     * @return bool - whether the username is available or not
326     */
327     function isUsernameAvailable(string memory _username) public view returns (bool) {
328         return usernames[_username] == address(0);
329     }
330 
331     /**
332     * @dev Validate a username
333     * @param _username - string for the username
334     */
335     function _requireUsernameValid(string memory _username) internal pure {
336         bytes memory tempUsername = bytes(_username);
337         require(tempUsername.length <= 15, "Username should be less than or equal 15 characters");
338         for(uint256 i = 0; i < tempUsername.length; i++) {
339             require(tempUsername[i] > 0x20, "Invalid Character");
340         }
341     }
342 
343     /**
344     * @dev Validate if a user has balance and the contract has enough allowance
345     * to use user MANA on his belhalf
346     * @param _user - address of the user
347     */
348     function _requireBalance(address _user) internal view {
349         require(
350             manaToken.balanceOf(_user) >= price,
351             "Insufficient funds"
352         );
353         require(
354             manaToken.allowance(_user, address(this)) >= price,
355             "The contract is not authorized to use MANA on sender behalf"
356         );
357     }
358 }