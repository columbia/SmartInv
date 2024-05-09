1 pragma solidity ^0.4.23;
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
135 contract ERC20Basic {
136     function totalSupply() public view returns (uint256);
137     function balanceOf(address who) public view returns (uint256);
138     function transfer(address to, uint256 value) public returns (bool);
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 contract Withdrawable is Ownable {
143     // Allows owner to withdraw ether from the contract
144     function withdrawEther(address to) public onlyOwner {
145         to.transfer(address(this).balance);
146     }
147 
148     // Allows owner to withdraw ERC20 tokens from the contract
149     function withdrawERC20Token(address tokenAddress, address to) public onlyOwner {
150         ERC20Basic token = ERC20Basic(tokenAddress);
151         token.transfer(to, token.balanceOf(address(this)));
152     }
153 }
154 
155 
156 contract RaindropClient is Withdrawable {
157     // attach the StringUtils library
158     using StringUtils for string;
159     using StringUtils for StringUtils.slice;
160     // Events for when a user signs up for Raindrop Client and when their account is deleted
161     event UserSignUp(string casedUserName, address userAddress, bool delegated);
162     event UserDeleted(string casedUserName);
163 
164     // Variables allowing this contract to interact with the Hydro token
165     address public hydroTokenAddress;
166     uint public minimumHydroStakeUser;
167     uint public minimumHydroStakeDelegatedUser;
168 
169     // User account template
170     struct User {
171         string casedUserName;
172         address userAddress;
173         bool delegated;
174         bool _initialized;
175     }
176 
177     // Mapping from hashed uncased names to users (primary User directory)
178     mapping (bytes32 => User) internal userDirectory;
179     // Mapping from addresses to hashed uncased names (secondary directory for account recovery based on address)
180     mapping (address => bytes32) internal nameDirectory;
181 
182     // Requires an address to have a minimum number of Hydro
183     modifier requireStake(address _address, uint stake) {
184         ERC20Basic hydro = ERC20Basic(hydroTokenAddress);
185         require(hydro.balanceOf(_address) >= stake);
186         _;
187     }
188 
189     // Allows applications to sign up users on their behalf iff users signed their permission
190     function signUpDelegatedUser(string casedUserName, address userAddress, uint8 v, bytes32 r, bytes32 s)
191         public
192         requireStake(msg.sender, minimumHydroStakeDelegatedUser)
193     {
194         require(isSigned(userAddress, keccak256("Create RaindropClient Hydro Account"), v, r, s));
195         _userSignUp(casedUserName, userAddress, true);
196     }
197 
198     // Allows users to sign up with their own address
199     function signUpUser(string casedUserName) public requireStake(msg.sender, minimumHydroStakeUser) {
200         return _userSignUp(casedUserName, msg.sender, false);
201     }
202 
203     // Allows users to delete their accounts
204     function deleteUser() public {
205         bytes32 uncasedUserNameHash = nameDirectory[msg.sender];
206         require(userDirectory[uncasedUserNameHash]._initialized);
207 
208         string memory casedUserName = userDirectory[uncasedUserNameHash].casedUserName;
209 
210         delete nameDirectory[msg.sender];
211         delete userDirectory[uncasedUserNameHash];
212 
213         emit UserDeleted(casedUserName);
214     }
215 
216     // Allows the Hydro API to link to the Hydro token
217     function setHydroTokenAddress(address _hydroTokenAddress) public onlyOwner {
218         hydroTokenAddress = _hydroTokenAddress;
219     }
220 
221     // Allows the Hydro API to set minimum hydro balances required for sign ups
222     function setMinimumHydroStakes(uint newMinimumHydroStakeUser, uint newMinimumHydroStakeDelegatedUser)
223         public onlyOwner
224     {
225         ERC20Basic hydro = ERC20Basic(hydroTokenAddress);
226         require(newMinimumHydroStakeUser <= (hydro.totalSupply() / 100 / 100)); // <= .01% of total supply
227         require(newMinimumHydroStakeDelegatedUser <= (hydro.totalSupply() / 100 / 2)); // <= .5% of total supply
228         minimumHydroStakeUser = newMinimumHydroStakeUser;
229         minimumHydroStakeDelegatedUser = newMinimumHydroStakeDelegatedUser;
230     }
231 
232     // Returns a bool indicated whether a given userName has been claimed (either exactly or as any case-variant)
233     function userNameTaken(string userName) public view returns (bool taken) {
234         bytes32 uncasedUserNameHash = keccak256(userName.lower());
235         return userDirectory[uncasedUserNameHash]._initialized;
236     }
237 
238     // Returns user details (including cased username) by any cased/uncased user name that maps to a particular user
239     function getUserByName(string userName) public view
240         returns (string casedUserName, address userAddress, bool delegated)
241     {
242         bytes32 uncasedUserNameHash = keccak256(userName.lower());
243         User storage _user = userDirectory[uncasedUserNameHash];
244         require(_user._initialized);
245 
246         return (_user.casedUserName, _user.userAddress, _user.delegated);
247     }
248 
249     // Returns user details by user address
250     function getUserByAddress(address _address) public view returns (string casedUserName, bool delegated) {
251         bytes32 uncasedUserNameHash = nameDirectory[_address];
252         User storage _user = userDirectory[uncasedUserNameHash];
253         require(_user._initialized);
254 
255         return (_user.casedUserName, _user.delegated);
256     }
257 
258     // Checks whether the provided (v, r, s) signature was created by the private key associated with _address
259     function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
260         return (_isSigned(_address, messageHash, v, r, s) || _isSignedPrefixed(_address, messageHash, v, r, s));
261     }
262 
263     // Checks unprefixed signatures
264     function _isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
265         internal
266         pure
267         returns (bool)
268     {
269         return ecrecover(messageHash, v, r, s) == _address;
270     }
271 
272     // Checks prefixed signatures (e.g. those created with web3.eth.sign)
273     function _isSignedPrefixed(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
274         internal
275         pure
276         returns (bool)
277     {
278         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
279         bytes32 prefixedMessageHash = keccak256(prefix, messageHash);
280 
281         return ecrecover(prefixedMessageHash, v, r, s) == _address;
282     }
283 
284     // Common internal logic for all user signups
285     function _userSignUp(string casedUserName, address userAddress, bool delegated) internal {
286         require(bytes(casedUserName).length < 50);
287 
288         bytes32 uncasedUserNameHash = keccak256(casedUserName.toSlice().copy().toString().lower());
289         require(!userDirectory[uncasedUserNameHash]._initialized);
290 
291         userDirectory[uncasedUserNameHash] = User(casedUserName, userAddress, delegated, true);
292         nameDirectory[userAddress] = uncasedUserNameHash;
293 
294         emit UserSignUp(casedUserName, userAddress, delegated);
295     }
296 }