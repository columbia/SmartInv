1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     emit OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract Claimable is Ownable {
41   address public pendingOwner;
42 
43   /**
44    * @dev Modifier throws if called by any account other than the pendingOwner.
45    */
46   modifier onlyPendingOwner() {
47     require(msg.sender == pendingOwner);
48     _;
49   }
50 
51   /**
52    * @dev Allows the current owner to set the pendingOwner address.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner public {
56     pendingOwner = newOwner;
57   }
58 
59   /**
60    * @dev Allows the pendingOwner address to finalize the transfer.
61    */
62   function claimOwnership() onlyPendingOwner public {
63     emit OwnershipTransferred(owner, pendingOwner);
64     owner = pendingOwner;
65     pendingOwner = 0x0;
66   }
67 }
68 
69 contract CanReclaimToken is Ownable {
70   
71 
72   /**
73    * @dev Reclaim all ERC20Basic compatible tokens
74    * @param token ERC20Basic The address of the token contract
75    */
76   function reclaimToken(ERC20Basic token) external onlyOwner {
77     uint256 balance = token.balanceOf(this);
78     require(token.transfer(owner, balance));
79   }
80 
81 }
82 
83 contract HasNoEther is Ownable {
84 
85   /**
86   * @dev Constructor that rejects incoming Ether
87   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
88   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
89   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
90   * we could use assembly to access msg.value.
91   */
92   constructor() public payable {
93     require(msg.value == 0);
94   }
95 
96   /**
97    * @dev Disallows direct send by settings a default function without the `payable` flag.
98    */
99   function() external {
100   }
101 
102   /**
103    * @dev Transfer all Ether held by the contract to the owner.
104    */
105   function reclaimEther() external onlyOwner {
106     require(owner.send(address(this).balance));
107   }
108 }
109 
110 contract HasNoTokens is CanReclaimToken {
111 
112  /**
113   * @dev Reject all ERC23 compatible tokens
114   * @param from_ address The address that is transferring the tokens
115   * @param value_ uint256 the amount of the specified token
116   * @param data_ Bytes The data passed from the caller.
117   */
118   function tokenFallback(address from_, uint256 value_, bytes data_) external {
119     revert();
120   }
121 
122 }
123 
124 
125 
126 contract ERC20Basic {
127   uint256 public totalSupply;
128   function balanceOf(address who) public constant returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) public constant returns (uint256);
135   function transferFrom(address from, address to, uint256 value) public returns (bool);
136   function approve(address spender, uint256 value) public returns (bool);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 contract CertificateRedeemer is Claimable, HasNoTokens, HasNoEther {
141     /// @dev A set of addresses that are approved to sign on behalf of this contract
142     mapping(address => bool) public signers;
143 
144     /// @dev The nonce associated with each hash(accountId).  In this case, the account is an external
145     /// concept that does not correspond to an Ethereum address.  Therefore, the hash of the accountId
146     /// is used
147     mapping(bytes32 => uint256) public nonces;
148 
149     address public token;
150     address public tokenHolder;
151 
152     event TokenHolderChanged(address oldTokenHolder, address newTokenHolder);
153     event CertificateRedeemed(string accountId, uint256 amount, address recipient, uint256 nonce, address signer);
154     event SignerAdded(address signer);
155     event SignerRemoved(address signer);
156     event AccountNonceChanged(uint256 oldNonce, uint256 newNone);
157 
158     constructor(address _token, address _tokenHolder)
159     public
160     {
161         token = _token;
162         tokenHolder = _tokenHolder;
163     }
164 
165     function redeemWithdrawalCertificate(string accountId, uint256 amount, address recipient, bytes signature)
166       external
167       returns (bool)
168     {
169         // although the external accountId is a string, internally we use a hash of the string
170         bytes32 accountHash = hashAccountId(accountId);
171         uint256 nonce = nonces[accountHash]++;
172         
173         // compute the message that should have been signed for this action.
174         bytes32 unsignedMessage = generateWithdrawalHash(accountId, amount, recipient, nonce);
175 
176         // assuming the computed message is correct, recover the signer from the given signature.
177         // If the actual message that was signed was a different message, the recovered signer
178         // address will be a random address. We can be sure the correct message was signed if
179         // the signer is one of our approved signers.
180         address signer = recoverSigner(unsignedMessage, signature);
181 
182         // require that the signer is an approved signer
183         require(signers[signer]);
184 
185         // log the event, including the nonce that was used and the signer that approved the action
186         emit CertificateRedeemed(accountId, amount, recipient, nonce, signer);
187 
188         // make sure the transfer is successful
189         require(ERC20(token).transferFrom(tokenHolder, recipient, amount));
190 
191         return true;
192     }
193 
194     /// Helper Methods
195 
196     /**
197      * @dev Generates the hash of the message that needs to be signed by an approved signer.
198      * The nonce is read directly from the contract's state.
199      */
200     function generateWithdrawalHash(string accountId, uint256 amount, address recipient, uint256 nonce)
201      view
202      public
203     returns (bytes32)
204     {
205         bytes memory message = abi.encodePacked(address(this), 'withdraw', accountId, amount, recipient, nonce);
206         bytes32 messageHash = keccak256(message);
207         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
208     }
209 
210     /**
211      * @dev converts and accoutId to a bytes32
212      */
213     function hashAccountId(string accountId)
214     pure
215     internal
216     returns (bytes32)
217     {
218         return keccak256(abi.encodePacked(accountId));
219     }
220 
221 
222     function recoverSigner(bytes32 _hash, bytes _signature)
223     internal
224     pure
225     returns (address)
226     {
227         bytes32 r;
228         bytes32 s;
229         uint8 v;
230 
231         // Check the signature length
232         if (_signature.length != 65) {
233             return (address(0));
234         }
235 
236         // Divide the signature in r, s and v variables
237         // ecrecover takes the signature parameters, and the only way to get them
238         // currently is to use assembly.
239         // solium-disable-next-line security/no-inline-assembly
240         assembly {
241             r := mload(add(_signature, 32))
242             s := mload(add(_signature, 64))
243             v := byte(0, mload(add(_signature, 96)))
244         }
245 
246         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
247         if (v < 27) {
248             v += 27;
249         }
250 
251         // If the version is correct return the signer address
252         if (v != 27 && v != 28) {
253             return (address(0));
254         } else {
255             // solium-disable-next-line arg-overflow
256             return ecrecover(_hash, v, r, s);
257         }
258     }
259 
260 
261     /// Admin Methods
262 
263     function updateTokenHolder(address newTokenHolder)
264      onlyOwner
265      external
266     {
267         address oldTokenHolder = tokenHolder;
268         tokenHolder = newTokenHolder;
269         emit TokenHolderChanged(oldTokenHolder, newTokenHolder);
270     }
271 
272     function addSigner(address signer)
273      onlyOwner
274      external
275     {
276         signers[signer] = true;
277         emit SignerAdded(signer);
278     }
279 
280     function removeSigner(address signer)
281      onlyOwner
282      external
283     {
284         signers[signer] = false;
285         emit SignerRemoved(signer);
286     }
287     
288     function setNonce(string accountId, uint256 newNonce) 
289       public
290       onlyOwner
291     {
292         bytes32 accountHash = hashAccountId(accountId);
293         uint256 oldNonce = nonces[accountHash];
294         require(newNonce > oldNonce);
295         
296         nonces[accountHash] = newNonce;
297         
298         emit AccountNonceChanged(oldNonce, newNonce);
299     }
300 }