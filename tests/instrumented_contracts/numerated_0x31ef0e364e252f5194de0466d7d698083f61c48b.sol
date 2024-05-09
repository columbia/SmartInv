1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: contracts/WCADAOSignUp.sol
114 
115 //SPDX-License-Identifier: MIT
116 pragma solidity ^0.8.17;
117 
118 
119 contract WCADAOSignUp is Ownable {
120 	struct User {
121 		string username;
122 		address[] addresses;
123 	}
124 
125 	mapping(string => address[]) public userToAddresses;
126 	mapping(address => string) public addressToUser;
127 	string[] public usernames;
128 
129 	string public constant version = "0.1";
130 
131 	constructor() {}
132 
133 	function signUp(string memory username) external {
134 		username = lower(username);
135 		require(isValidUsername(username), "Username isn't valid, use only a-z, 0-9, . or -");
136 		require(userToAddresses[username].length == 0, "Username is unavaiable");
137 		require(bytes(addressToUser[msg.sender]).length == 0, "Wallet is already linked to another user");
138 
139 		usernames.push(username);
140 		userToAddresses[username].push(msg.sender);
141 		addressToUser[msg.sender] = username;
142 	}
143 
144 	function linkWalletTo(string memory username) external {
145 		username = lower(username);
146 		require(bytes(username).length > 0 && userToAddresses[username].length > 0, "Username doesn't exists");
147 		require(bytes(addressToUser[msg.sender]).length == 0, "Wallet already linked");
148 
149 		userToAddresses[username].push(msg.sender);
150 		addressToUser[msg.sender] = username;
151 	}
152 
153 	function unlinkWallet(address wallet) external {
154 		string memory username = addressToUser[msg.sender];
155 		require(bytes(username).length > 0, "You are not signed in DAO");
156 		require(wallet != address(0) && compare(addressToUser[wallet], username), "This wallet isn't linked to your username");
157 		require(userToAddresses[username].length > 1, "You should keep at least one wallet linked");
158 		removeWallet(userToAddresses[username], wallet);
159 		delete addressToUser[wallet];
160 	}
161 
162 	function unsubscribe() external {
163 		string memory username = addressToUser[msg.sender];
164 		deleteUser(username);
165 	}
166 
167 	function kick(string memory username) external onlyOwner {
168 		username = lower(username);
169 		require(userToAddresses[username].length > 0, "Username doesn't exists");
170 		deleteUser(username);
171 	}
172 
173 	function deleteUser(string memory username) internal {
174 		for (uint256 i = 0; i < userToAddresses[username].length; i++) {
175 			delete addressToUser[userToAddresses[username][i]];
176 		}
177 
178 		for (uint256 i = 0; i < usernames.length; i++) {
179 			if (compare(usernames[i], username)) {
180 				usernames[i] = usernames[usernames.length - 1];
181 				usernames.pop();
182 				break;
183 			}
184 		}
185 
186 		delete userToAddresses[username];
187 	}
188 
189 	function getUser(string memory username) external view returns (User memory user) {
190 		username = lower(username);
191 		require(userToAddresses[username].length > 0, "Username doesn't exists");
192 
193 		return User(username, userToAddresses[username]);
194 	}
195 
196 	function getUserFromAddress(address wallet) external view returns (User memory user) {
197 		require(bytes(addressToUser[wallet]).length > 0, "Wallet isn't linked to any user");
198 
199 		return User(addressToUser[wallet], userToAddresses[addressToUser[wallet]]);
200 	}
201 
202 	function getUsers() external view returns (User[] memory) {
203 		User[] memory users = new User[](usernames.length);
204 		for (uint256 i = 0; i < usernames.length; i++) {
205 			users[i] = User(usernames[i], userToAddresses[usernames[i]]);
206 		}
207 		return users;
208 	}
209 
210 	function getUsersCount() external view returns (uint256) {
211 		return usernames.length;
212 	}
213 
214 	function getUserAddressesCount(string calldata username) external view returns (uint256) {
215 		return userToAddresses[username].length;
216 	}
217 
218 	function lower(string memory _base) internal pure returns (string memory) {
219 		bytes memory _baseBytes = bytes(_base);
220 		for (uint256 i = 0; i < _baseBytes.length; i++) {
221 			_baseBytes[i] = _lower(_baseBytes[i]);
222 		}
223 		return string(_baseBytes);
224 	}
225 
226 	function _lower(bytes1 _b1) private pure returns (bytes1) {
227 		if (_b1 >= 0x41 && _b1 <= 0x5A) {
228 			return bytes1(uint8(_b1) + 32);
229 		}
230 
231 		return _b1;
232 	}
233 
234 	function compare(string memory s1, string memory s2) internal pure returns (bool) {
235 		return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
236 	}
237 
238 	function removeWallet(address[] storage array, address wallet) internal returns (bool) {
239 		for (uint256 i = 0; i < array.length; i++) {
240 			if (array[i] == wallet) {
241 				array[i] = array[array.length - 1];
242 				array.pop();
243 				return true;
244 			}
245 		}
246 		return false;
247 	}
248 
249 	function isValidUsername(string memory _base) internal pure returns (bool) {
250 		bytes memory _bytes = bytes(_base);
251 		if (_bytes.length < 1) {
252 			return false;
253 		}
254 		for (uint256 i = 0; i < _bytes.length; i++) {
255 			if (!((_bytes[i] >= 0x30 && _bytes[i] <= 0x39) || (_bytes[i] >= 0x61 && _bytes[i] <= 0x7a) || (_bytes[i] >= 0x2d && _bytes[i] <= 0x2e))) {
256 				return false;
257 			}
258 		}
259 		return true;
260 	}
261 }