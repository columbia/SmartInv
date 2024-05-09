1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 
71 
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() public onlyOwner whenNotPaused {
104     paused = true;
105     emit Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() public onlyOwner whenPaused {
112     paused = false;
113     emit Unpause();
114   }
115 }
116 
117 
118 
119 
120 
121 /**
122  * @title Elliptic curve signature operations
123  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
124  * TODO Remove this library once solidity supports passing a signature to ecrecover.
125  * See https://github.com/ethereum/solidity/issues/864
126  */
127 
128 library ECRecovery {
129 
130   /**
131    * @dev Recover signer address from a message by using their signature
132    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
133    * @param _sig bytes signature, the signature is generated using web3.eth.sign()
134    */
135   function recover(bytes32 _hash, bytes _sig)
136     internal
137     pure
138     returns (address)
139   {
140     bytes32 r;
141     bytes32 s;
142     uint8 v;
143 
144     // Check the signature length
145     if (_sig.length != 65) {
146       return (address(0));
147     }
148 
149     // Divide the signature in r, s and v variables
150     // ecrecover takes the signature parameters, and the only way to get them
151     // currently is to use assembly.
152     // solium-disable-next-line security/no-inline-assembly
153     assembly {
154       r := mload(add(_sig, 32))
155       s := mload(add(_sig, 64))
156       v := byte(0, mload(add(_sig, 96)))
157     }
158 
159     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
160     if (v < 27) {
161       v += 27;
162     }
163 
164     // If the version is correct return the signer address
165     if (v != 27 && v != 28) {
166       return (address(0));
167     } else {
168       // solium-disable-next-line arg-overflow
169       return ecrecover(_hash, v, r, s);
170     }
171   }
172 
173   /**
174    * toEthSignedMessageHash
175    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
176    * and hash the result
177    */
178   function toEthSignedMessageHash(bytes32 _hash)
179     internal
180     pure
181     returns (bytes32)
182   {
183     // 32 is the length in bytes of hash,
184     // enforced by the type signature above
185     return keccak256(
186       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
187     );
188   }
189 }
190 
191 
192 
193 contract ETHDenverStaking is Ownable, Pausable {
194 
195     using ECRecovery for bytes32;
196 
197     event UserStake(address userUportAddress, address userMetamaskAddress, uint amountStaked);
198     event UserRecoupStake(address userUportAddress, address userMetamaskAddress, uint amountStaked);
199 
200     // Debug events
201     event debugBytes32(bytes32 _msg);
202     event debugBytes(bytes _msg);
203     event debugString(string _msg);
204     event debugAddress(address _address);
205 
206     // ETHDenver will need to authorize staking and recouping.
207     address public grantSigner;
208 
209     // End of the event, when staking can be sweeped
210     uint public finishDate;
211 
212     // uPortAddress => walletAddress
213     mapping (address => address) public userStakedAddress;
214 
215     // ETH amount staked by a given uPort address
216     mapping (address => uint256) public stakedAmount;
217 
218 
219     constructor(address _grantSigner, uint _finishDate) public {
220         grantSigner = _grantSigner;
221         finishDate = _finishDate;
222     }
223 
224     // Public functions
225 
226     // function allow the staking for a participant
227     function stake(address _userUportAddress, uint _expiryDate, bytes _signature) public payable whenNotPaused {
228         bytes32 hashMessage = keccak256(abi.encodePacked(_userUportAddress, msg.value, _expiryDate));
229         address signer = hashMessage.toEthSignedMessageHash().recover(_signature);
230 
231         require(signer == grantSigner, "Signature is not valid");
232         require(block.timestamp < _expiryDate, "Grant is expired");
233         require(userStakedAddress[_userUportAddress] == 0, "User has already staked!");
234 
235         userStakedAddress[_userUportAddress] = msg.sender;
236         stakedAmount[_userUportAddress] = msg.value;
237 
238         emit UserStake(_userUportAddress, msg.sender, msg.value);
239     }
240 
241     // function allow the staking for a participant
242     function recoupStake(address _userUportAddress, uint _expiryDate, bytes _signature) public whenNotPaused {
243         bytes32 hashMessage = keccak256(abi.encodePacked(_userUportAddress, _expiryDate));
244         address signer = hashMessage.toEthSignedMessageHash().recover(_signature);
245 
246         require(signer == grantSigner, "Signature is not valid");
247         require(block.timestamp < _expiryDate, "Grant is expired");
248         require(userStakedAddress[_userUportAddress] != 0, "User has not staked!");
249 
250         address stakedBy = userStakedAddress[_userUportAddress];
251         uint256 amount = stakedAmount[_userUportAddress];
252         userStakedAddress[_userUportAddress] = address(0x0);
253         stakedAmount[_userUportAddress] = 0;
254 
255         stakedBy.transfer(amount);
256 
257         emit UserRecoupStake(_userUportAddress, stakedBy, amount);
258     }
259 
260     // Owner functions
261 
262     function setGrantSigner(address _signer) public onlyOwner {
263         require(_signer != address(0x0), "address is null");
264         grantSigner = _signer;
265     }
266 
267     function sweepStakes() public onlyOwner {
268         require(block.timestamp > finishDate, "EthDenver is not over yet!");
269         owner.transfer(address(this).balance);
270     }
271 
272 }