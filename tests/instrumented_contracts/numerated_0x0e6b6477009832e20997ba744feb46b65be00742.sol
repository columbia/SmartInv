1 pragma solidity 0.4.24;
2 
3 library ECRecovery {
4 
5   /**
6    * @dev Recover signer address from a message by using his signature
7    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
8    * @param sig bytes signature, the signature is generated using web3.eth.sign()
9    */
10   function recover(bytes32 hash, bytes sig) public pure returns (address) {
11     bytes32 r;
12     bytes32 s;
13     uint8 v;
14 
15     //Check the signature length
16     if (sig.length != 65) {
17       return (address(0));
18     }
19 
20     // Divide the signature in r, s and v variables
21     assembly {
22       r := mload(add(sig, 32))
23       s := mload(add(sig, 64))
24       v := byte(0, mload(add(sig, 96)))
25     }
26 
27     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
28     if (v < 27) {
29       v += 27;
30     }
31 
32     // If the version is correct return the signer address
33     if (v != 27 && v != 28) {
34       return (address(0));
35     } else {
36       return ecrecover(hash, v, r, s);
37     }
38   }
39 
40 }
41 
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   constructor() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 contract Claimable is Ownable {
80   address public pendingOwner;
81 
82   /**
83    * @dev Modifier throws if called by any account other than the pendingOwner.
84    */
85   modifier onlyPendingOwner() {
86     require(msg.sender == pendingOwner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to set the pendingOwner address.
92    * @param newOwner The address to transfer ownership to.
93    */
94   function transferOwnership(address newOwner) onlyOwner public {
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() onlyPendingOwner public {
102     emit OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = 0x0;
105   }
106 }
107 
108 contract ERC20Basic {
109   uint256 public totalSupply;
110   function balanceOf(address who) public constant returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public constant returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 contract RedemptionCertificate is Claimable {
123     using ECRecovery for bytes32;
124 
125     /// @dev A set of addresses that are approved to sign on behalf of this contract
126     mapping(address => bool) public signers;
127 
128     /// @dev The nonce associated with each hash(accountId).  In this case, the account is an external
129     /// concept that does not correspond to an Ethereum address.  Therefore, the hash of the accountId
130     /// is used
131     mapping(bytes32 => uint256) public nonces;
132 
133     address public token;
134     address public tokenHolder;
135 
136     event TokenHolderChanged(address oldTokenHolder, address newTokenHolder);
137     event CertificateRedeemed(string accountId, uint256 amount, address recipient);
138     event SignerAdded(address signer);
139     event SignerRemoved(address signer);
140 
141     constructor(address _token, address _tokenHolder)
142     public
143     {
144         token = _token;
145         tokenHolder = _tokenHolder;
146     }
147 
148 
149     /**
150      * @dev ensures that the hash was signed by a valid signer.  Also increments the associated
151      * account nonce to ensure that the same hash/signature cannot be used again
152      */
153     modifier onlyValidSignatureOnce(string accountId, bytes32 hash, bytes signature) {
154         address signedBy = hash.recover(signature);
155         require(signers[signedBy]);
156         _;
157         nonces[hashAccountId(accountId)]++;
158     }
159 
160 
161     /**
162      * @dev Attempts to withdraw tokens from this contract, using the signature as proof
163      * that the caller is entitled to the specified amount.
164      */
165     function withdraw(string accountId, uint256 amount, address recipient, bytes signature)
166     onlyValidSignatureOnce(
167         accountId,
168         generateWithdrawalHash(accountId, amount, recipient),
169         signature)
170     public
171     returns (bool)
172     {
173         require(ERC20(token).transferFrom(tokenHolder, recipient, amount));
174         emit CertificateRedeemed(accountId, amount, recipient);
175         return true;
176     }
177 
178 
179 
180 
181     /// Helper Methods
182 
183     /**
184      * @dev Generates the hash of the message that needs to be signed by an approved signer.
185      * The nonce is read directly from the contract's state.
186      */
187     function generateWithdrawalHash(string accountId, uint256 amount, address recipient)
188      view
189      public
190     returns (bytes32)
191     {
192         bytes32 accountHash = hashAccountId(accountId);
193         bytes memory message = abi.encodePacked(address(this), recipient, amount, nonces[accountHash]);
194         bytes32 messageHash = keccak256(message);
195         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
196     }
197 
198     /**
199      * @dev converts and accoutId to a bytes32
200      */
201     function hashAccountId(string accountId)
202     pure
203     internal
204     returns (bytes32)
205     {
206         return keccak256(abi.encodePacked(accountId));
207     }
208 
209 
210 
211 
212 
213 
214     /// Admin Methods
215 
216     function updateTokenHolder(address newTokenHolder)
217      onlyOwner
218       external
219     {
220         address oldTokenHolder = tokenHolder;
221         tokenHolder = newTokenHolder;
222         emit TokenHolderChanged(oldTokenHolder, newTokenHolder);
223     }
224 
225     function addSigner(address signer)
226      onlyOwner
227      external
228     {
229         signers[signer] = true;
230         emit SignerAdded(signer);
231     }
232 
233     function removeSigner(address signer)
234      onlyOwner
235      external
236     {
237         signers[signer] = false;
238         emit SignerRemoved(signer);
239     }
240 }