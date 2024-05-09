1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12     * account.
13     */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19     * @dev Throws if called by any account other than the owner.
20     */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27     * @dev Allows the current owner to transfer control of the contract to a newOwner.
28     * @param newOwner The address to transfer ownership to.
29     */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 contract ERC20Basic {
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 contract Withdrawable is Ownable {
47     // Allows owner to withdraw ether from the contract
48     function withdrawEther(address to) public onlyOwner {
49         to.transfer(address(this).balance);
50     }
51 
52     // Allows owner to withdraw ERC20 tokens from the contract
53     function withdrawERC20Token(address tokenAddress, address to) public onlyOwner {
54         ERC20Basic token = ERC20Basic(tokenAddress);
55         token.transfer(to, token.balanceOf(address(this)));
56     }
57 }
58 
59 contract RaindropClient is Withdrawable {
60     // Events for when a user signs up for Raindrop Client and when their account is deleted
61     event UserSignUp(string userName, address userAddress, bool delegated);
62     event UserDeleted(string userName);
63 
64     // Variables allowing this contract to interact with the Hydro token
65     address public hydroTokenAddress;
66     uint public minimumHydroStakeUser;
67     uint public minimumHydroStakeDelegatedUser;
68 
69     // User account template
70     struct User {
71         string userName;
72         address userAddress;
73         bool delegated;
74         bool _initialized;
75     }
76 
77     // Mapping from hashed names to users (primary User directory)
78     mapping (bytes32 => User) internal userDirectory;
79     // Mapping from addresses to hashed names (secondary directory for account recovery based on address)
80     mapping (address => bytes32) internal nameDirectory;
81 
82     // Requires an address to have a minimum number of Hydro
83     modifier requireStake(address _address, uint stake) {
84         ERC20Basic hydro = ERC20Basic(hydroTokenAddress);
85         require(hydro.balanceOf(_address) >= stake);
86         _;
87     }
88 
89     // Allows applications to sign up users on their behalf iff users signed their permission
90     function signUpDelegatedUser(string userName, address userAddress, uint8 v, bytes32 r, bytes32 s)
91         public
92         requireStake(msg.sender, minimumHydroStakeDelegatedUser)
93     {
94         require(isSigned(userAddress, keccak256("Create RaindropClient Hydro Account"), v, r, s));
95         _userSignUp(userName, userAddress, true);
96     }
97 
98     // Allows users to sign up with their own address
99     function signUpUser(string userName) public requireStake(msg.sender, minimumHydroStakeUser) {
100         return _userSignUp(userName, msg.sender, false);
101     }
102 
103     // Allows users to delete their accounts
104     function deleteUser() public {
105         bytes32 userNameHash = nameDirectory[msg.sender];
106         require(userDirectory[userNameHash]._initialized);
107 
108         string memory userName = userDirectory[userNameHash].userName;
109 
110         delete nameDirectory[msg.sender];
111         delete userDirectory[userNameHash];
112 
113         emit UserDeleted(userName);
114     }
115 
116     // Allows the Hydro API to link to the Hydro token
117     function setHydroTokenAddress(address _hydroTokenAddress) public onlyOwner {
118         hydroTokenAddress = _hydroTokenAddress;
119     }
120 
121     // Allows the Hydro API to set minimum hydro balances required for sign ups
122     function setMinimumHydroStakes(uint newMinimumHydroStakeUser, uint newMinimumHydroStakeDelegatedUser) public {
123         ERC20Basic hydro = ERC20Basic(hydroTokenAddress);
124         require(newMinimumHydroStakeUser <= (hydro.totalSupply() / 100 / 10)); // <= .1% of total supply
125         require(newMinimumHydroStakeDelegatedUser <= (hydro.totalSupply() / 100)); // <= 1% of total supply
126         minimumHydroStakeUser = newMinimumHydroStakeUser;
127         minimumHydroStakeDelegatedUser = newMinimumHydroStakeDelegatedUser;
128     }
129 
130     // Returns a bool indicated whether a given userName has been claimed
131     function userNameTaken(string userName) public view returns (bool taken) {
132         bytes32 userNameHash = keccak256(userName);
133         return userDirectory[userNameHash]._initialized;
134     }
135 
136     // Returns user details by user name
137     function getUserByName(string userName) public view returns (address userAddress, bool delegated) {
138         bytes32 userNameHash = keccak256(userName);
139         User storage _user = userDirectory[userNameHash];
140         require(_user._initialized);
141 
142         return (_user.userAddress, _user.delegated);
143     }
144 
145     // Returns user details by user address
146     function getUserByAddress(address _address) public view returns (string userName, bool delegated) {
147         bytes32 userNameHash = nameDirectory[_address];
148         User storage _user = userDirectory[userNameHash];
149         require(_user._initialized);
150 
151         return (_user.userName, _user.delegated);
152     }
153 
154     // Checks whether the provided (v, r, s) signature was created by the private key associated with _address
155     function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
156         return (_isSigned(_address, messageHash, v, r, s) || _isSignedPrefixed(_address, messageHash, v, r, s));
157     }
158 
159     // Checks unprefixed signatures
160     function _isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
161         internal
162         pure
163         returns (bool)
164     {
165         return ecrecover(messageHash, v, r, s) == _address;
166     }
167 
168     // Checks prefixed signatures (e.g. those created with web3.eth.sign)
169     function _isSignedPrefixed(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s)
170         internal
171         pure
172         returns (bool)
173     {
174         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
175         bytes32 prefixedMessageHash = keccak256(prefix, messageHash);
176 
177         return ecrecover(prefixedMessageHash, v, r, s) == _address;
178     }
179 
180     // Common internal logic for all user signups
181     function _userSignUp(string userName, address userAddress, bool delegated) internal {
182         require(bytes(userName).length < 100);
183         bytes32 userNameHash = keccak256(userName);
184         require(!userDirectory[userNameHash]._initialized);
185 
186         userDirectory[userNameHash] = User(userName, userAddress, delegated, true);
187         nameDirectory[userAddress] = userNameHash;
188 
189         emit UserSignUp(userName, userAddress, delegated);
190     }
191 }