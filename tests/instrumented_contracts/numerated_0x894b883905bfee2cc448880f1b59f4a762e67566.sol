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
65 // File: openzeppelin-eth/contracts/ownership/Ownable.sol
66 
67 pragma solidity ^0.5.2;
68 
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable is Initializable {
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82      * account.
83      */
84     function initialize(address sender) public initializer {
85         _owner = sender;
86         emit OwnershipTransferred(address(0), _owner);
87     }
88 
89     /**
90      * @return the address of the owner.
91      */
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(isOwner());
101         _;
102     }
103 
104     /**
105      * @return true if `msg.sender` is the owner of the contract.
106      */
107     function isOwner() public view returns (bool) {
108         return msg.sender == _owner;
109     }
110 
111     /**
112      * @dev Allows the current owner to relinquish control of the contract.
113      * It will not be possible to call the functions with the `onlyOwner`
114      * modifier anymore.
115      * @notice Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 
141     uint256[50] private ______gap;
142 }
143 
144 // File: contracts/AvatarNameStorage.sol
145 
146 pragma solidity ^0.5.0;
147 
148 contract ERC20Interface {
149     function balanceOf(address from) public view returns (uint256);
150     function transferFrom(address from, address to, uint tokens) public returns (bool);
151     function allowance(address owner, address spender) public view returns (uint256);
152     function burn(uint256 amount) public;
153 }
154 
155 contract AvatarNameStorage {
156     // Storage
157     ERC20Interface public manaToken;
158     uint256 public price;
159 
160     struct Data {
161         string username;
162         string metadata;
163     }
164 
165     // Stores usernames used
166     mapping (string => address) usernames;
167     // Stores account data
168     mapping (address => Data) public user;
169     // Stores account roles
170     mapping (address => bool) public allowed;
171 
172     // Events
173     event Register(
174         address indexed _owner,
175         string _username,
176         string _metadata,
177         address indexed _caller
178     );
179     event MetadataChanged(address indexed _owner, string _metadata);
180     event Allow(address indexed _caller, address indexed _account, bool _allowed);
181 }
182 
183 // File: contracts/AvatarNameRegistry.sol
184 
185 pragma solidity ^0.5.0;
186 
187 
188 
189 
190 contract AvatarNameRegistry is Ownable, AvatarNameStorage {
191 
192     /**
193     * @dev Initializer of the contract
194     * @param _mana - address of the mana token
195     * @param _owner - address of the owner allowed to register usernames and assign the role
196     */
197     function initialize(
198         ERC20Interface _mana,
199         address _owner
200     )
201     public initializer
202     {
203         manaToken = _mana;
204         price = 100000000000000000000; // 100 in wei
205 
206         // Allow owner to register usernames
207         allowed[_owner] = true;
208 
209         // Owner
210         Ownable.initialize(_owner);
211     }
212 
213     /**
214     * @dev Check if the sender is an allowed account
215     */
216     modifier onlyAllowed() {
217         require(
218             allowed[msg.sender] == true,
219             "The sender is not allowed to register a username"
220         );
221         _;
222     }
223 
224     /**
225     * @dev Manage role for an account
226     * @param _account - address of the account to be managed
227     * @param _allowed - bool whether the account should be allowed or not
228     */
229     function setAllowed(address _account, bool _allowed) external onlyOwner {
230         require(_account != msg.sender, "You can not manage your role");
231         allowed[_account] = _allowed;
232         emit Allow(msg.sender, _account, _allowed);
233     }
234 
235     /**
236     * @dev Register a usename
237     * @notice that the username should be less than or equal 32 bytes and blanks are not allowed
238     * @param _beneficiary - address of the account to be managed
239     * @param _username - string for the username
240     * @param _metadata - string for the metadata
241     */
242     function _registerUsername(
243         address _beneficiary,
244         string memory _username,
245         string memory _metadata
246     )
247     internal
248     {
249         _requireBalance(_beneficiary);
250         _requireUsernameValid(_username);
251         require(isUsernameAvailable(_username), "The username was already taken");
252 
253         manaToken.transferFrom(_beneficiary, address(this), price);
254         manaToken.burn(price);
255 
256         // Save username
257         usernames[_username] = _beneficiary;
258 
259         Data storage data = user[_beneficiary];
260 
261         // Free previous username
262         delete usernames[data.username];
263 
264         // Set data
265         data.username = _username;
266 
267         bytes memory metadata = bytes(_metadata);
268         if (metadata.length > 0) {
269             data.metadata = _metadata;
270         }
271 
272         emit Register(
273             _beneficiary,
274             _username,
275             data.metadata,
276             msg.sender
277         );
278     }
279 
280     /**
281     * @dev Register a usename
282     * @notice that the username can only be registered by an allowed account
283     * @param _beneficiary - address of the account to be managed
284     * @param _username - string for the username
285     * @param _metadata - string for the metadata
286     */
287     function registerUsername(
288         address _beneficiary,
289         string calldata _username,
290         string calldata _metadata
291     )
292     external
293     onlyAllowed
294     {
295         _registerUsername(_beneficiary, _username, _metadata);
296     }
297 
298     /**
299     * @dev Set metadata for an existing user
300     * @param _metadata - string for the metadata
301     */
302     function setMetadata(string calldata _metadata) external {
303         require(userExists(msg.sender), "The user does not exist");
304 
305         user[msg.sender].metadata = _metadata;
306         emit MetadataChanged(msg.sender, _metadata);
307     }
308 
309     /**
310     * @dev Check whether a user exist or not
311     * @param _user - address for the user
312     * @return bool - whether the user exist or not
313     */
314     function userExists(address _user) public view returns (bool) {
315         Data memory data = user[_user];
316         bytes memory username = bytes(data.username);
317         return username.length > 0;
318     }
319 
320     /**
321     * @dev Check whether a username is available or not
322     * @param _username - string for the username
323     * @return bool - whether the username is available or not
324     */
325     function isUsernameAvailable(string memory _username) public view returns (bool) {
326         return usernames[_username] == address(0);
327     }
328 
329     /**
330     * @dev Validate a username
331     * @param _username - string for the username
332     */
333     function _requireUsernameValid(string memory _username) internal pure {
334         bytes memory tempUsername = bytes(_username);
335         require(tempUsername.length <= 15, "Username should be less than or equal 15 characters");
336         for(uint256 i = 0; i < tempUsername.length; i++) {
337             require(tempUsername[i] > 0x20, "Invalid Character");
338         }
339     }
340 
341     /**
342     * @dev Validate if a user has balance and the contract has enough allowance
343     * to use user MANA on his belhalf
344     * @param _user - address of the user
345     */
346     function _requireBalance(address _user) internal view {
347         require(
348             manaToken.balanceOf(_user) >= price,
349             "Insufficient funds"
350         );
351         require(
352             manaToken.allowance(_user, address(this)) >= price,
353             "The contract is not authorized to use MANA on sender behalf"
354         );
355     }
356 }