1 pragma solidity ^0.4.21;
2 
3 library StringUtils {
4     // Tests for uppercase characters in a given string
5     function allLower(string memory _string) internal pure returns (bool) {
6         bytes memory bytesString = bytes(_string);
7         for (uint i = 0; i < bytesString.length; i++) {
8             if ((bytesString[i] >= 65) && (bytesString[i] <= 90)) {  // Uppercase characters
9                 return false;
10             }
11         }
12         return true;
13     }
14 }
15 
16 contract Ownable {
17     address public owner;
18 
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23     /**
24     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25     * account.
26     */
27     function Ownable() public {
28         owner = msg.sender;
29     }
30 
31     /**
32     * @dev Throws if called by any account other than the owner.
33     */
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     /**
40     * @dev Allows the current owner to transfer control of the contract to a newOwner.
41     * @param newOwner The address to transfer ownership to.
42     */
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 
49 }
50 
51 contract ERC20Basic {
52     function totalSupply() public view returns (uint256);
53     function balanceOf(address who) public view returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract Withdrawable is Ownable {
59     // Allows owner to withdraw ether from the contract
60     function withdrawEther(address to) public onlyOwner {
61         to.transfer(address(this).balance);
62     }
63 
64     // Allows owner to withdraw ERC20 tokens from the contract
65     function withdrawERC20Token(address tokenAddress, address to) public onlyOwner {
66         ERC20Basic token = ERC20Basic(tokenAddress);
67         token.transfer(to, token.balanceOf(address(this)));
68     }
69 }
70 
71 
72 interface HydroToken {
73     function balanceOf(address _owner) external returns (uint256 balance);
74 }
75 
76 
77 contract RaindropClient is Withdrawable {
78     // Events for when a user signs up for Raindrop Client and when their account is deleted
79     event UserSignUp(string userName, address userAddress, bool official);
80     event UserDeleted(string userName, address userAddress, bool official);
81     // Events for when an application signs up for Raindrop Client and when their account is deleted
82     event ApplicationSignUp(string applicationName, bool official);
83     event ApplicationDeleted(string applicationName, bool official);
84 
85     using StringUtils for string;
86 
87     // Fees that unofficial users/applications must pay to sign up for Raindrop Client
88     uint public unofficialUserSignUpFee;
89     uint public unofficialApplicationSignUpFee;
90 
91     address public hydroTokenAddress;
92     uint public hydroStakingMinimum;
93 
94     // User accounts
95     struct User {
96         string userName;
97         address userAddress;
98         bool official;
99         bool _initialized;
100     }
101 
102     // Application accounts
103     struct Application {
104         string applicationName;
105         bool official;
106         bool _initialized;
107     }
108 
109     // Internally, users and applications are identified by the hash of their names
110     mapping (bytes32 => User) internal userDirectory;
111     mapping (bytes32 => Application) internal officialApplicationDirectory;
112     mapping (bytes32 => Application) internal unofficialApplicationDirectory;
113 
114     // Allows the Hydro API to sign up official users with their app-generated address
115     function officialUserSignUp(string userName, address userAddress) public onlyOwner {
116         _userSignUp(userName, userAddress, true);
117     }
118 
119     // Allows anyone to sign up as an unofficial user with their own address
120     function unofficialUserSignUp(string userName) public payable {
121         require(bytes(userName).length < 100);
122         require(msg.value >= unofficialUserSignUpFee);
123 
124         return _userSignUp(userName, msg.sender, false);
125     }
126 
127     // Allows the Hydro API to delete official users iff they've signed keccak256("Delete") with their private key
128     function deleteUserForUser(string userName, uint8 v, bytes32 r, bytes32 s) public onlyOwner {
129         bytes32 userNameHash = keccak256(userName);
130         require(userNameHashTaken(userNameHash));
131         address userAddress = userDirectory[userNameHash].userAddress;
132         require(isSigned(userAddress, keccak256("Delete"), v, r, s));
133 
134         delete userDirectory[userNameHash];
135 
136         emit UserDeleted(userName, userAddress, true);
137     }
138 
139     // Allows unofficial users to delete their account
140     function deleteUser(string userName) public {
141         bytes32 userNameHash = keccak256(userName);
142         require(userNameHashTaken(userNameHash));
143         address userAddress = userDirectory[userNameHash].userAddress;
144         require(userAddress == msg.sender);
145 
146         delete userDirectory[userNameHash];
147 
148         emit UserDeleted(userName, userAddress, true);
149     }
150 
151     // Allows the Hydro API to sign up official applications
152     function officialApplicationSignUp(string applicationName) public onlyOwner {
153         bytes32 applicationNameHash = keccak256(applicationName);
154         require(!applicationNameHashTaken(applicationNameHash, true));
155         officialApplicationDirectory[applicationNameHash] = Application(applicationName, true, true);
156 
157         emit ApplicationSignUp(applicationName, true);
158     }
159 
160     // Allows anyone to sign up as an unofficial application
161     function unofficialApplicationSignUp(string applicationName) public payable {
162         require(bytes(applicationName).length < 100);
163         require(msg.value >= unofficialApplicationSignUpFee);
164         require(applicationName.allLower());
165 
166         HydroToken hydro = HydroToken(hydroTokenAddress);
167         uint256 hydroBalance = hydro.balanceOf(msg.sender);
168         require(hydroBalance >= hydroStakingMinimum);
169 
170         bytes32 applicationNameHash = keccak256(applicationName);
171         require(!applicationNameHashTaken(applicationNameHash, false));
172         unofficialApplicationDirectory[applicationNameHash] = Application(applicationName, false, true);
173 
174         emit ApplicationSignUp(applicationName, false);
175     }
176 
177     // Allows the Hydro API to delete applications unilaterally
178     function deleteApplication(string applicationName, bool official) public onlyOwner {
179         bytes32 applicationNameHash = keccak256(applicationName);
180         require(applicationNameHashTaken(applicationNameHash, official));
181         if (official) {
182             delete officialApplicationDirectory[applicationNameHash];
183         } else {
184             delete unofficialApplicationDirectory[applicationNameHash];
185         }
186 
187         emit ApplicationDeleted(applicationName, official);
188     }
189 
190     // Allows the Hydro API to changes the unofficial user fee
191     function setUnofficialUserSignUpFee(uint newFee) public onlyOwner {
192         unofficialUserSignUpFee = newFee;
193     }
194 
195     // Allows the Hydro API to changes the unofficial application fee
196     function setUnofficialApplicationSignUpFee(uint newFee) public onlyOwner {
197         unofficialApplicationSignUpFee = newFee;
198     }
199 
200     // Allows the Hydro API to link to the Hydro token
201     function setHydroContractAddress(address _hydroTokenAddress) public onlyOwner {
202         hydroTokenAddress = _hydroTokenAddress;
203     }
204 
205     // Allows the Hydro API to set a minimum hydro balance required to register unofficially
206     function setHydroStakingMinimum(uint newMinimum) public onlyOwner {
207         hydroStakingMinimum = newMinimum;
208     }
209 
210     // Indicates whether a given user name has been claimed
211     function userNameTaken(string userName) public view returns (bool taken) {
212         bytes32 userNameHash = keccak256(userName);
213         return userDirectory[userNameHash]._initialized;
214     }
215 
216     // Indicates whether a given application name has been claimed for official and unofficial applications
217     function applicationNameTaken(string applicationName)
218         public
219         view
220         returns (bool officialTaken, bool unofficialTaken)
221     {
222         bytes32 applicationNameHash = keccak256(applicationName);
223         return (
224             officialApplicationDirectory[applicationNameHash]._initialized,
225             unofficialApplicationDirectory[applicationNameHash]._initialized
226         );
227     }
228 
229     // Returns user details by user name
230     function getUserByName(string userName) public view returns (address userAddress, bool official) {
231         bytes32 userNameHash = keccak256(userName);
232         require(userNameHashTaken(userNameHash));
233         User storage _user = userDirectory[userNameHash];
234 
235         return (_user.userAddress, _user.official);
236     }
237 
238     // Checks whether the provided (v, r, s) signature was created by the private key associated with _address
239     function isSigned(address _address, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
240         return ecrecover(messageHash, v, r, s) == _address;
241     }
242 
243     // Common internal logic for all user signups
244     function _userSignUp(string userName, address userAddress, bool official) internal {
245         bytes32 userNameHash = keccak256(userName);
246         require(!userNameHashTaken(userNameHash));
247         userDirectory[userNameHash] = User(userName, userAddress, official, true);
248 
249         emit UserSignUp(userName, userAddress, official);
250     }
251 
252     // Internal check for whether a user name has been taken
253     function userNameHashTaken(bytes32 userNameHash) internal view returns (bool) {
254         return userDirectory[userNameHash]._initialized;
255     }
256 
257     // Internal check for whether an application name has been taken
258     function applicationNameHashTaken(bytes32 applicationNameHash, bool official) internal view returns (bool) {
259         if (official) {
260             return officialApplicationDirectory[applicationNameHash]._initialized;
261         } else {
262             return unofficialApplicationDirectory[applicationNameHash]._initialized;
263         }
264     }
265 }