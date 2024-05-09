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
36     bool wasInitializing = initializing;
37     initializing = true;
38     initialized = true;
39 
40     _;
41 
42     initializing = wasInitializing;
43   }
44 
45   /// @dev Returns true if and only if the function is running in the constructor
46   function isConstructor() private view returns (bool) {
47     // extcodesize checks the size of the code stored in an address, and
48     // address returns the current address. Since the code is still not
49     // deployed when running a constructor, any checks on its code size will
50     // yield zero, making it an effective way to detect if a contract is
51     // under construction or not.
52     uint256 cs;
53     assembly { cs := extcodesize(address) }
54     return cs == 0;
55   }
56 
57   // Reserved storage space to allow for layout changes in the future.
58   uint256[50] private ______gap;
59 }
60 
61 // File: contracts/AvatarNameStorage.sol
62 
63 pragma solidity ^0.5.0;
64 
65 contract ERC20Interface {
66     function balanceOf(address from) public view returns (uint256);
67     function transferFrom(address from, address to, uint tokens) public returns (bool);
68     function allowance(address owner, address spender) public view returns (uint256);
69     function burn(uint256 amount) public;
70 }
71 
72 contract AvatarNameStorage {
73     // Storage
74     ERC20Interface public manaToken;
75     uint256 public blocksUntilReveal;
76     uint256 public price;
77 
78     struct Data {
79         string username;
80         string metadata;
81     }
82     struct Commit {
83         bytes32 commit;
84         uint256 blockNumber;
85         bool revealed;
86     }
87 
88     // Stores commit messages by accounts
89     mapping (address => Commit) public commit;
90     // Stores usernames used
91     mapping (string => address) usernames;
92     // Stores account data
93     mapping (address => Data) public user;
94     // Stores account roles
95     mapping (address => bool) public allowed;
96 
97     // Events
98     event Register(
99         address indexed _owner,
100         string _username,
101         string _metadata,
102         address indexed _caller
103     );
104     event MetadataChanged(address indexed _owner, string _metadata);
105     event Allow(address indexed _caller, address indexed _account, bool _allowed);
106     event CommitUsername(address indexed _owner, bytes32 indexed _hash, uint256 _blockNumber);
107     event RevealUsername(address indexed _owner, bytes32 indexed _hash, uint256 _blockNumber);
108 }
109 
110 // File: contracts/AvatarNameRegistry.sol
111 
112 pragma solidity ^0.5.0;
113 
114 
115 
116 
117 contract AvatarNameRegistry is Initializable, AvatarNameStorage {
118 
119     /**
120     * @dev Initializer of the contract
121     * @param _mana - address of the mana token
122     * @param _register - address of the user allowed to register usernames and assign the role
123     * @param _blocksUntilReveal - uint256 for the blocks that should pass before reveal a commit
124     */
125     function initialize(
126         ERC20Interface _mana,
127         address _register,
128         uint256 _blocksUntilReveal
129     )
130     public initializer
131     {
132         require(_blocksUntilReveal != 0, "Blocks until reveal should be greather than 0");
133 
134 
135         manaToken = _mana;
136         blocksUntilReveal = _blocksUntilReveal;
137         price = 100000000000000000000; // 100 in wei
138 
139         // Allow deployer to register usernames
140         allowed[_register] = true;
141     }
142 
143     /**
144     * @dev Check if the sender is an allowed account
145     */
146     modifier onlyAllowed() {
147         require(
148             allowed[msg.sender] == true,
149             "The sender is not allowed to register a username"
150         );
151         _;
152     }
153 
154     /**
155     * @dev Manage role for an account
156     * @param _account - address of the account to be managed
157     * @param _allowed - bool whether the account should be allowed or not
158     */
159     function setAllowed(address _account, bool _allowed) external onlyAllowed {
160         require(_account != msg.sender, "You can not manage your role");
161         allowed[_account] = _allowed;
162         emit Allow(msg.sender, _account, _allowed);
163     }
164 
165     /**
166     * @dev Register a usename
167     * @notice that the username should be less than or equal 32 bytes and blanks are not allowed
168     * @param _beneficiary - address of the account to be managed
169     * @param _username - string for the username
170     * @param _metadata - string for the metadata
171     */
172     function _registerUsername(
173         address _beneficiary,
174         string memory _username,
175         string memory _metadata
176     )
177     internal
178     {
179         _requireUsernameValid(_username);
180         require(isUsernameAvailable(_username), "The username was already taken");
181 
182         // Save username
183         usernames[_username] = _beneficiary;
184 
185         Data storage data = user[_beneficiary];
186 
187         // Free previous username
188         delete usernames[data.username];
189 
190         // Set data
191         data.username = _username;
192 
193         bytes memory metadata = bytes(_metadata);
194         if (metadata.length > 0) {
195             data.metadata = _metadata;
196         }
197 
198         emit Register(
199             _beneficiary,
200             _username,
201             data.metadata,
202             msg.sender
203         );
204     }
205 
206     /**
207     * @dev Register a usename
208     * @notice that the username can only be registered by an allowed account
209     * @param _beneficiary - address of the account to be managed
210     * @param _username - string for the username
211     * @param _metadata - string for the metadata
212     */
213     function registerUsername(
214         address _beneficiary,
215         string calldata _username,
216         string calldata _metadata
217     )
218     external
219     onlyAllowed
220     {
221         _registerUsername(_beneficiary, _username, _metadata);
222     }
223 
224     /**
225     * @dev Commit a hash for a desire username
226     * @notice that the reveal should happen after the blocks defined on {blocksUntilReveal}
227     * @param _hash - bytes32 of the commit hash
228     */
229     function commitUsername(bytes32 _hash) public {
230         commit[msg.sender].commit = _hash;
231         commit[msg.sender].blockNumber = block.number;
232         commit[msg.sender].revealed = false;
233 
234         emit CommitUsername(msg.sender, _hash, block.number);
235     }
236 
237     /**
238     * @dev Reveal a commit
239     * @notice that the reveal should happen after the blocks defined on {blocksUntilReveal}
240     * @param _username - string for the username
241     * @param _metadata - string for the metadata
242     * @param _salt - bytes32 for the salt
243     */
244     function revealUsername(
245         string memory _username,
246         string memory _metadata,
247         bytes32 _salt
248     )
249     public
250     {
251         Commit storage userCommit = commit[msg.sender];
252 
253         require(userCommit.commit != 0, "User has not a commit to be revealed");
254         require(userCommit.revealed == false, "Commit was already revealed");
255         require(
256             getHash(_username, _metadata, _salt) == userCommit.commit,
257             "Revealed hash does not match commit"
258         );
259         require(
260             block.number > userCommit.blockNumber + blocksUntilReveal,
261             "Reveal can not be done before blocks passed"
262         );
263 
264         userCommit.revealed = true;
265 
266         emit RevealUsername(msg.sender, userCommit.commit, block.number);
267 
268         _registerUsername(msg.sender, _username, _metadata);
269     }
270 
271     /**
272     * @dev Return a bytes32 hash for the given arguments
273     * @param _username - string for the username
274     * @param _metadata - string for the metadata
275     * @param _salt - bytes32 for the salt
276     * @return bytes32 - for the hash of the given arguments
277     */
278     function getHash(
279         string memory _username,
280         string memory _metadata,
281         bytes32 _salt
282     )
283     public
284     view
285     returns (bytes32)
286     {
287         return keccak256(
288             abi.encodePacked(address(this), _username, _metadata, _salt)
289         );
290     }
291 
292     /**
293     * @dev Set metadata for an existing user
294     * @param _metadata - string for the metadata
295     */
296     function setMetadata(string calldata _metadata) external {
297         require(userExists(msg.sender), "The user does not exist");
298 
299         user[msg.sender].metadata = _metadata;
300         emit MetadataChanged(msg.sender, _metadata);
301     }
302 
303     /**
304     * @dev Check whether a user exist or not
305     * @param _user - address for the user
306     * @return bool - whether the user exist or not
307     */
308     function userExists(address _user) public view returns (bool) {
309         Data memory data = user[_user];
310         bytes memory username = bytes(data.username);
311         return username.length > 0;
312     }
313 
314     /**
315     * @dev Check whether a username is available or not
316     * @param _username - string for the username
317     * @return bool - whether the username is available or not
318     */
319     function isUsernameAvailable(string memory _username) public view returns (bool) {
320         return usernames[_username] == address(0);
321     }
322 
323     /**
324     * @dev Validate a username
325     * @param _username - string for the username
326     */
327     function _requireUsernameValid(string memory _username) internal pure {
328         bytes memory tempUsername = bytes(_username);
329         require(tempUsername.length <= 32, "Username should be less than or equal 32 characters");
330         for(uint256 i = 0; i < tempUsername.length; i++) {
331             require(tempUsername[i] != " ", "No blanks are allowed");
332         }
333     }
334 
335     /**
336     * @dev Validate if a user has balance and the contract has enough allowance
337     * to use user MANA on his belhalf
338     * @param _user - address of the user
339     */
340     function _requireBalance(address _user) internal view {
341         require(
342             manaToken.balanceOf(_user) >= price,
343             "Insufficient funds"
344         );
345         require(
346             manaToken.allowance(_user, address(this)) >= price,
347             "The contract is not authorized to use MANA on sender behalf"
348         );
349     }
350 }