1 pragma solidity ^0.4.13;
2 
3 library StringUtils {
4     struct slice {
5         uint _len;
6         uint _ptr;
7     }
8 
9     /*
10      * @dev Returns a slice containing the entire string.
11      * @param self The string to make a slice from.
12      * @return A newly allocated slice containing the entire string.
13      */
14     function toSlice(string self) internal pure returns (slice) {
15         uint ptr;
16         assembly {
17             ptr := add(self, 0x20)
18         }
19         return slice(bytes(self).length, ptr);
20     }
21 
22     /*
23      * @dev Returns a new slice containing the same data as the current slice.
24      * @param self The slice to copy.
25      * @return A new slice containing the same data as `self`.
26      */
27     function copy(slice self) internal pure returns (slice) {
28         return slice(self._len, self._ptr);
29     }
30 
31     /*
32      * @dev Copies a slice to a new string.
33      * @param self The slice to copy.
34      * @return A newly allocated string containing the slice's text.
35      */
36     function toString(slice self) internal pure returns (string) {
37         string memory ret = new string(self._len);
38         uint retptr;
39         assembly { retptr := add(ret, 32) }
40 
41         memcpy(retptr, self._ptr, self._len);
42         return ret;
43     }
44 
45     /**
46     * Lower
47     *
48     * Converts all the values of a string to their corresponding lower case
49     * value.
50     *
51     * @param _base When being used for a data type this is the extended object
52     *              otherwise this is the string base to convert to lower case
53     * @return string
54     */
55     function lower(string _base) internal pure returns (string) {
56         bytes memory _baseBytes = bytes(_base);
57         for (uint i = 0; i < _baseBytes.length; i++) {
58             _baseBytes[i] = _lower(_baseBytes[i]);
59         }
60         return string(_baseBytes);
61     }
62 
63     /**
64     * Lower
65     *
66     * Convert an alphabetic character to lower case and return the original
67     * value when not alphabetic
68     *
69     * @param _b1 The byte to be converted to lower case
70     * @return bytes1 The converted value if the passed value was alphabetic
71     *                and in a upper case otherwise returns the original value
72     */
73     function _lower(bytes1 _b1) internal pure returns (bytes1) {
74         if (_b1 >= 0x41 && _b1 <= 0x5A) {
75             return bytes1(uint8(_b1) + 32);
76         }
77         return _b1;
78     }
79 
80     function memcpy(uint dest, uint src, uint len) private pure {
81         // Copy word-length chunks while possible
82         for (; len >= 32; len -= 32) {
83             assembly {
84                 mstore(dest, mload(src))
85             }
86             dest += 32;
87             src += 32;
88         }
89 
90         // Copy remaining bytes
91         uint mask = 256 ** (32 - len) - 1;
92         assembly {
93             let srcpart := and(mload(src), not(mask))
94             let destpart := and(mload(dest), mask)
95             mstore(dest, or(destpart, srcpart))
96         }
97     }
98 }
99 
100 contract Ownable {
101     address public owner;
102 
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106 
107     /**
108     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109     * account.
110     */
111     constructor() public {
112         owner = msg.sender;
113     }
114 
115     /**
116     * @dev Throws if called by any account other than the owner.
117     */
118     modifier onlyOwner() {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     /**
124     * @dev Allows the current owner to transfer control of the contract to a newOwner.
125     * @param newOwner The address to transfer ownership to.
126     */
127     function transferOwnership(address newOwner) public onlyOwner {
128         require(newOwner != address(0));
129         emit OwnershipTransferred(owner, newOwner);
130         owner = newOwner;
131     }
132 
133 }
134 
135 contract Withdrawable is Ownable {
136     // Allows owner to withdraw ether from the contract
137     function withdrawEther(address to) public onlyOwner {
138         to.transfer(address(this).balance);
139     }
140 
141     // Allows owner to withdraw ERC20 tokens from the contract
142     function withdrawERC20Token(address tokenAddress, address to) public onlyOwner {
143         ERC20Basic token = ERC20Basic(tokenAddress);
144         token.transfer(to, token.balanceOf(address(this)));
145     }
146 }
147 
148 contract ClientRaindrop is Withdrawable {
149     // attach the StringUtils library
150     using StringUtils for string;
151     using StringUtils for StringUtils.slice;
152     // Events for when a user signs up for Raindrop Client and when their account is deleted
153     event UserSignUp(string casedUserName, address userAddress);
154     event UserDeleted(string casedUserName);
155 
156     // Variables allowing this contract to interact with the Hydro token
157     address public hydroTokenAddress;
158     uint public minimumHydroStakeUser;
159     uint public minimumHydroStakeDelegatedUser;
160 
161     // User account template
162     struct User {
163         string casedUserName;
164         address userAddress;
165     }
166 
167     // Mapping from hashed uncased names to users (primary User directory)
168     mapping (bytes32 => User) internal userDirectory;
169     // Mapping from addresses to hashed uncased names (secondary directory for account recovery based on address)
170     mapping (address => bytes32) internal addressDirectory;
171 
172     // Requires an address to have a minimum number of Hydro
173     modifier requireStake(address _address, uint stake) {
174         ERC20Basic hydro = ERC20Basic(hydroTokenAddress);
175         require(hydro.balanceOf(_address) >= stake, "Insufficient HYDRO balance.");
176         _;
177     }
178 
179     // Allows applications to sign up users on their behalf iff users signed their permission
180     function signUpDelegatedUser(string casedUserName, address userAddress, uint8 v, bytes32 r, bytes32 s)
181         public
182         requireStake(msg.sender, minimumHydroStakeDelegatedUser)
183     {
184         require(
185             isSigned(userAddress, keccak256(abi.encodePacked("Create RaindropClient Hydro Account")), v, r, s),
186             "Permission denied."
187         );
188         _userSignUp(casedUserName, userAddress);
189     }
190 
191     // Allows users to sign up with their own address
192     function signUpUser(string casedUserName) public requireStake(msg.sender, minimumHydroStakeUser) {
193         return _userSignUp(casedUserName, msg.sender);
194     }
195 
196     // Allows users to delete their accounts
197     function deleteUser() public {
198         bytes32 uncasedUserNameHash = addressDirectory[msg.sender];
199         require(initialized(uncasedUserNameHash), "No user associated with the sender address.");
200 
201         string memory casedUserName = userDirectory[uncasedUserNameHash].casedUserName;
202 
203         delete addressDirectory[msg.sender];
204         delete userDirectory[uncasedUserNameHash];
205 
206         emit UserDeleted(casedUserName);
207     }
208 
209     // Allows the Hydro API to link to the Hydro token
210     function setHydroTokenAddress(address _hydroTokenAddress) public onlyOwner {
211         hydroTokenAddress = _hydroTokenAddress;
212     }
213 
214     // Allows the Hydro API to set minimum hydro balances required for sign ups
215     function setMinimumHydroStakes(uint newMinimumHydroStakeUser, uint newMinimumHydroStakeDelegatedUser)
216         public onlyOwner
217     {
218         ERC20Basic hydro = ERC20Basic(hydroTokenAddress);
219         // <= the airdrop amount
220         require(newMinimumHydroStakeUser <= (222222 * 10**18), "Stake is too high.");
221         // <= 1% of total supply
222         require(newMinimumHydroStakeDelegatedUser <= (hydro.totalSupply() / 100), "Stake is too high.");
223         minimumHydroStakeUser = newMinimumHydroStakeUser;
224         minimumHydroStakeDelegatedUser = newMinimumHydroStakeDelegatedUser;
225     }
226 
227     // Returns a bool indicating whether a given userName has been claimed (either exactly or as any case-variant)
228     function userNameTaken(string userName) public view returns (bool taken) {
229         bytes32 uncasedUserNameHash = keccak256(abi.encodePacked(userName.lower()));
230         return initialized(uncasedUserNameHash);
231     }
232 
233     // Returns user details (including cased username) by any cased/uncased user name that maps to a particular user
234     function getUserByName(string userName) public view returns (string casedUserName, address userAddress) {
235         bytes32 uncasedUserNameHash = keccak256(abi.encodePacked(userName.lower()));
236         require(initialized(uncasedUserNameHash), "User does not exist.");
237 
238         return (userDirectory[uncasedUserNameHash].casedUserName, userDirectory[uncasedUserNameHash].userAddress);
239     }
240 
241     // Returns user details by user address
242     function getUserByAddress(address _address) public view returns (string casedUserName) {
243         bytes32 uncasedUserNameHash = addressDirectory[_address];
244         require(initialized(uncasedUserNameHash), "User does not exist.");
245 
246         return userDirectory[uncasedUserNameHash].casedUserName;
247     }
248 
249     // Checks whether the provided (v, r, s) signature was created by the private key associated with _address
250     function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
251         return (_isSigned(_address, messageHash, v, r, s) || _isSignedPrefixed(_address, messageHash, v, r, s));
252     }
253 
254     // Checks unprefixed signatures
255     function _isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
256         internal
257         pure
258         returns (bool)
259     {
260         return ecrecover(messageHash, v, r, s) == _address;
261     }
262 
263     // Checks prefixed signatures (e.g. those created with web3.eth.sign)
264     function _isSignedPrefixed(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
265         internal
266         pure
267         returns (bool)
268     {
269         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
270         bytes32 prefixedMessageHash = keccak256(abi.encodePacked(prefix, messageHash));
271 
272         return ecrecover(prefixedMessageHash, v, r, s) == _address;
273     }
274 
275     // Common internal logic for all user signups
276     function _userSignUp(string casedUserName, address userAddress) internal {
277         require(!initialized(addressDirectory[userAddress]), "Address already registered.");
278 
279         require(bytes(casedUserName).length < 31, "Username too long.");
280         require(bytes(casedUserName).length > 3, "Username too short.");
281 
282         bytes32 uncasedUserNameHash = keccak256(abi.encodePacked(casedUserName.toSlice().copy().toString().lower()));
283         require(!initialized(uncasedUserNameHash), "Username taken.");
284 
285         userDirectory[uncasedUserNameHash] = User(casedUserName, userAddress);
286         addressDirectory[userAddress] = uncasedUserNameHash;
287 
288         emit UserSignUp(casedUserName, userAddress);
289     }
290 
291     function initialized(bytes32 uncasedUserNameHash) internal view returns (bool) {
292         return userDirectory[uncasedUserNameHash].userAddress != 0x0; // a sufficient initialization check
293     }
294 }
295 
296 contract ERC20Basic {
297     function totalSupply() public view returns (uint256);
298     function balanceOf(address who) public view returns (uint256);
299     function transfer(address to, uint256 value) public returns (bool);
300     event Transfer(address indexed from, address indexed to, uint256 value);
301 }