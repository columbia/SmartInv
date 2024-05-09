1 pragma solidity ^0.5.11;
2 
3 // Libraries
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address payable public owner;
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
52   function transferOwnership(address payable _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address payable _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is not paused.
80    */
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is paused.
88    */
89   modifier whenPaused() {
90     require(paused);
91     _;
92   }
93 
94   /**
95    * @dev called by the owner to pause, triggers stopped state
96    */
97   function pause() public onlyOwner whenNotPaused {
98     paused = true;
99     emit Pause();
100   }
101 
102   /**
103    * @dev called by the owner to unpause, returns to normal state
104    */
105   function unpause() public onlyOwner whenPaused {
106     paused = false;
107     emit Unpause();
108   }
109 }
110 
111 
112 /**
113  * @title Elliptic curve signature operations
114  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
115  * TODO Remove this library once solidity supports passing a signature to ecrecover.
116  * See https://github.com/ethereum/solidity/issues/864
117  */
118 
119 library ECRecovery {
120 
121   /**
122    * @dev Recover signer address from a message by using their signature
123    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
124    * @param _sig bytes signature, the signature is generated using web3.eth.sign()
125    */
126   function recover(bytes32 _hash, bytes memory _sig)
127     internal
128     pure
129     returns (address)
130   {
131     bytes32 r;
132     bytes32 s;
133     uint8 v;
134 
135     // Check the signature length
136     if (_sig.length != 65) {
137       return (address(0));
138     }
139 
140     // Divide the signature in r, s and v variables
141     // ecrecover takes the signature parameters, and the only way to get them
142     // currently is to use assembly.
143     // solium-disable-next-line security/no-inline-assembly
144     assembly {
145       r := mload(add(_sig, 32))
146       s := mload(add(_sig, 64))
147       v := byte(0, mload(add(_sig, 96)))
148     }
149 
150     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
151     if (v < 27) {
152       v += 27;
153     }
154 
155     // If the version is correct return the signer address
156     if (v != 27 && v != 28) {
157       return (address(0));
158     } else {
159       // solium-disable-next-line arg-overflow
160       return ecrecover(_hash, v, r, s);
161     }
162   }
163 
164   /**
165    * toEthSignedMessageHash
166    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
167    * and hash the result
168    */
169   function toEthSignedMessageHash(bytes32 _hash)
170     internal
171     pure
172     returns (bytes32)
173   {
174     // 32 is the length in bytes of hash,
175     // enforced by the type signature above
176     return keccak256(
177       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
178     );
179   }
180 }
181 
182 ////// End Libraries
183 
184 ////// ETHDenver Staking Contract
185 
186 contract ETHDenverStaking is Ownable, Pausable {
187 
188     using ECRecovery for bytes32;
189 
190     event UserStake(address userFortmaticAddress, address walletAddress, uint amountStaked);
191     event UserRecoupStake(address userFortmaticAddress, address walletAddress, uint amountStaked);
192 
193     // Debug events
194     event debugBytes32(bytes32 _msg);
195     event debugBytes(bytes _msg);
196     event debugString(string _msg);
197     event debugAddress(address _address);
198 
199     // ETHDenver will need to authorize staking and recouping.
200     address public grantSigner;
201 
202     // End of the event, when staking can be sweeped
203     uint public finishDate;
204 
205     // fortmaticAddress => walletAddress
206     mapping (address => address payable) public userStakedAddress;
207 
208     // ETH amount staked by a given fortmaticAddress
209     mapping (address => uint) public stakedAmount;
210 
211 
212     constructor(address _grantSigner, uint _finishDate) public {
213         require(_grantSigner != address(0x0));
214         require(_finishDate > block.timestamp);
215         grantSigner = _grantSigner;
216         finishDate = _finishDate;
217     }
218 
219     // Public functions
220 
221     // function allow the staking for a participant
222     function stake(address _userFortmaticAddress, uint _expiryDate, bytes memory _signature) public payable whenNotPaused {
223         bytes32 hashMessage = keccak256(abi.encodePacked(_userFortmaticAddress, msg.value, _expiryDate));
224         address signer = hashMessage.toEthSignedMessageHash().recover(_signature);
225 
226         require(signer == grantSigner, "Signature is not valid");
227         require(block.timestamp < _expiryDate, "Grant is expired");
228         require(userStakedAddress[_userFortmaticAddress] == address(0x0), "User has already staked!");
229 
230         userStakedAddress[_userFortmaticAddress] = msg.sender;
231         stakedAmount[_userFortmaticAddress] = msg.value;
232 
233         emit UserStake(_userFortmaticAddress, msg.sender, msg.value);
234     }
235 
236     // function allow the staking for a participant
237     function recoupStake(address _userFortmaticAddress, uint _expiryDate, bytes memory _signature) public whenNotPaused {
238         bytes32 hashMessage = keccak256(abi.encodePacked(_userFortmaticAddress, _expiryDate));
239         address signer = hashMessage.toEthSignedMessageHash().recover(_signature);
240 
241         require(signer == grantSigner, "Signature is not valid");
242         require(block.timestamp < _expiryDate, "Grant is expired");
243         require(userStakedAddress[_userFortmaticAddress] != address(0x0), "User has not staked!");
244 
245         address payable stakedBy = userStakedAddress[_userFortmaticAddress];
246         uint amount = stakedAmount[_userFortmaticAddress];
247         userStakedAddress[_userFortmaticAddress] = address(0x0);
248         stakedAmount[_userFortmaticAddress] = 0;
249 
250         stakedBy.transfer(amount);
251 
252         emit UserRecoupStake(_userFortmaticAddress, stakedBy, amount);
253     }
254 
255     // Owner functions
256 
257     function setGrantSigner(address _signer) public onlyOwner {
258         require(_signer != address(0x0), "address is null");
259         grantSigner = _signer;
260     }
261 
262     function sweepStakes() public onlyOwner {
263         require(block.timestamp > finishDate, "EthDenver is not over yet!");
264         owner.transfer(address(this).balance);
265     }
266 
267 }