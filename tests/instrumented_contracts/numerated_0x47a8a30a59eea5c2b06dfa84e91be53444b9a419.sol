1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library SafeERC20 {
81   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
82     assert(token.transfer(to, value));
83   }
84 
85   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
86     assert(token.transferFrom(from, to, value));
87   }
88 
89   function safeApprove(ERC20 token, address spender, uint256 value) internal {
90     assert(token.approve(spender, value));
91   }
92 }
93 
94 contract AccountRegistry is Ownable {
95   mapping(address => bool) public accounts;
96 
97   // Inviter + recipient pair
98   struct Invite {
99     address creator;
100     address recipient;
101   }
102 
103   // Mapping of public keys as Ethereum addresses to invite information
104   // NOTE: the address keys here are NOT Ethereum addresses, we just happen
105   // to work with the public keys in terms of Ethereum address strings because
106   // this is what `ecrecover` produces when working with signed text.
107   mapping(address => Invite) public invites;
108 
109   InviteCollateralizer public inviteCollateralizer;
110   ERC20 public blt;
111   address private inviteAdmin;
112 
113   event InviteCreated(address indexed inviter);
114   event InviteAccepted(address indexed inviter, address indexed recipient);
115   event AccountCreated(address indexed newUser);
116 
117   function AccountRegistry(ERC20 _blt, InviteCollateralizer _inviteCollateralizer) public {
118     blt = _blt;
119     accounts[owner] = true;
120     inviteAdmin = owner;
121     inviteCollateralizer = _inviteCollateralizer;
122   }
123 
124   function setInviteCollateralizer(InviteCollateralizer _newInviteCollateralizer) public nonZero(_newInviteCollateralizer) onlyOwner {
125     inviteCollateralizer = _newInviteCollateralizer;
126   }
127 
128   function setInviteAdmin(address _newInviteAdmin) public onlyOwner nonZero(_newInviteAdmin) {
129     inviteAdmin = _newInviteAdmin;
130   }
131 
132   /**
133    * @dev Create an account instantly. Reserved for the "invite admin" which is managed by the Bloom team
134    * @param _newUser Address of the user receiving an account
135    */
136   function createAccount(address _newUser) public onlyInviteAdmin {
137     require(!accounts[_newUser]);
138     createAccountFor(_newUser);
139   }
140 
141   /**
142    * @dev Create an invite using the signing model described in the contract description
143    * @param _sig Signature for `msg.sender`
144    */
145   function createInvite(bytes _sig) public onlyUser {
146     require(inviteCollateralizer.takeCollateral(msg.sender));
147 
148     address signer = recoverSigner(_sig);
149     require(inviteDoesNotExist(signer));
150 
151     invites[signer] = Invite(msg.sender, address(0));
152     InviteCreated(msg.sender);
153   }
154 
155   /**
156    * @dev Accept an invite using the signing model described in the contract description
157    * @param _sig Signature for `msg.sender` via the same key that issued the initial invite
158    */
159   function acceptInvite(bytes _sig) public onlyNonUser {
160     address signer = recoverSigner(_sig);
161     require(inviteExists(signer) && inviteHasNotBeenAccepted(signer));
162 
163     invites[signer].recipient = msg.sender;
164     createAccountFor(msg.sender);
165     InviteAccepted(invites[signer].creator, msg.sender);
166   }
167 
168   /**
169    * @dev Check if an invite has not been set on the struct meaning it hasn't been accepted
170    */
171   function inviteHasNotBeenAccepted(address _signer) internal view returns (bool) {
172     return invites[_signer].recipient == address(0);
173   }
174 
175   /**
176    * @dev Check that an invite hasn't already been created with this signer
177    */
178   function inviteDoesNotExist(address _signer) internal view returns (bool) {
179     return !inviteExists(_signer);
180   }
181 
182   /**
183    * @dev Check that an invite has already been created with this signer
184    */
185   function inviteExists(address _signer) internal view returns (bool) {
186     return invites[_signer].creator != address(0);
187   }
188 
189   /**
190    * @dev Recover the address associated with the public key that signed the provided signature
191    * @param _sig Signature of `msg.sender`
192    */
193   function recoverSigner(bytes _sig) private view returns (address) {
194     address signer = ECRecovery.recover(keccak256(msg.sender), _sig);
195     require(signer != address(0));
196 
197     return signer;
198   }
199 
200   /**
201    * @dev Create an account and emit an event
202    * @param _newUser Address of the new user
203    */
204   function createAccountFor(address _newUser) private {
205     accounts[_newUser] = true;
206     AccountCreated(_newUser);
207   }
208 
209   /**
210    * @dev Addresses with Bloom accounts already are not allowed
211    */
212   modifier onlyNonUser {
213     require(!accounts[msg.sender]);
214     _;
215   }
216 
217   /**
218    * @dev Addresses without Bloom accounts already are not allowed
219    */
220   modifier onlyUser {
221     require(accounts[msg.sender]);
222     _;
223   }
224 
225   modifier nonZero(address _address) {
226     require(_address != 0);
227     _;
228   }
229 
230   modifier onlyInviteAdmin {
231     require(msg.sender == inviteAdmin);
232     _;
233   }
234 }
235 
236 library ECRecovery {
237 
238   /**
239    * @dev Recover signer address from a message by using his signature
240    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
241    * @param sig bytes signature, the signature is generated using web3.eth.sign()
242    */
243   function recover(bytes32 hash, bytes sig) public pure returns (address) {
244     bytes32 r;
245     bytes32 s;
246     uint8 v;
247 
248     //Check the signature length
249     if (sig.length != 65) {
250       return (address(0));
251     }
252 
253     // Extracting these values isn't possible without assembly
254     // solhint-disable no-inline-assembly
255     // Divide the signature in r, s and v variables
256     assembly {
257       r := mload(add(sig, 32))
258       s := mload(add(sig, 64))
259       v := byte(0, mload(add(sig, 96)))
260     }
261 
262     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
263     if (v < 27) {
264       v += 27;
265     }
266 
267     // If the version is correct return the signer address
268     if (v != 27 && v != 28) {
269       return (address(0));
270     } else {
271       return ecrecover(hash, v, r, s);
272     }
273   }
274 
275 }
276 
277 contract InviteCollateralizer is Ownable {
278   // We need to rely on time for lockup periods. The amount that miners can manipulate
279   // a timestamp is not a concern for this behavior since token lockups are for several months
280   // solhint-disable not-rely-on-time
281 
282   using SafeMath for uint256;
283   using SafeERC20 for ERC20;
284 
285   ERC20 public blt;
286   address public seizedTokensWallet;
287   mapping (address => Collateralization[]) public collateralizations;
288   uint256 public collateralAmount = 1e17;
289   uint64 public lockupDuration = 1 years;
290 
291   address private collateralTaker;
292   address private collateralSeizer;
293 
294   struct Collateralization {
295     uint256 value; // Amount of BLT
296     uint64 releaseDate; // Date BLT can be withdrawn
297     bool claimed; // Has the original owner or the network claimed the collateral
298   }
299 
300   event CollateralPosted(address indexed owner, uint64 releaseDate, uint256 amount);
301   event CollateralSeized(address indexed owner, uint256 collateralId);
302 
303   function InviteCollateralizer(ERC20 _blt, address _seizedTokensWallet) public {
304     blt = _blt;
305     seizedTokensWallet = _seizedTokensWallet;
306     collateralTaker = owner;
307     collateralSeizer = owner;
308   }
309 
310   function takeCollateral(address _owner) public onlyCollateralTaker returns (bool) {
311     require(blt.transferFrom(_owner, address(this), collateralAmount));
312 
313     uint64 releaseDate = uint64(now) + lockupDuration;
314     CollateralPosted(_owner, releaseDate, collateralAmount);
315     collateralizations[_owner].push(Collateralization(collateralAmount, releaseDate, false));
316 
317     return true;
318   }
319 
320   function reclaim() public returns (bool) {
321     require(collateralizations[msg.sender].length > 0);
322 
323     uint256 reclaimableAmount = 0;
324 
325     for (uint256 i = 0; i < collateralizations[msg.sender].length; i++) {
326       if (collateralizations[msg.sender][i].claimed) {
327         continue;
328       } else if (collateralizations[msg.sender][i].releaseDate > now) {
329         break;
330       }
331 
332       reclaimableAmount = reclaimableAmount.add(collateralizations[msg.sender][i].value);
333       collateralizations[msg.sender][i].claimed = true;
334     }
335 
336     require(reclaimableAmount > 0);
337 
338     return blt.transfer(msg.sender, reclaimableAmount);
339   }
340 
341   function seize(address _subject, uint256 _collateralId) public onlyCollateralSeizer {
342     require(collateralizations[_subject].length >= _collateralId + 1);
343     require(!collateralizations[_subject][_collateralId].claimed);
344 
345     collateralizations[_subject][_collateralId].claimed = true;
346     blt.transfer(seizedTokensWallet, collateralizations[_subject][_collateralId].value);
347     CollateralSeized(_subject, _collateralId);
348   }
349 
350   function changeCollateralTaker(address _newCollateralTaker) public nonZero(_newCollateralTaker) onlyOwner {
351     collateralTaker = _newCollateralTaker;
352   }
353 
354   function changeCollateralSeizer(address _newCollateralSeizer) public nonZero(_newCollateralSeizer) onlyOwner {
355     collateralSeizer = _newCollateralSeizer;
356   }
357 
358   function changeCollateralAmount(uint256 _newAmount) public onlyOwner {
359     require(_newAmount > 0);
360     collateralAmount = _newAmount;
361   }
362 
363   function changeSeizedTokensWallet(address _newSeizedTokensWallet) public nonZero(_newSeizedTokensWallet) onlyOwner {
364     seizedTokensWallet = _newSeizedTokensWallet; 
365   }
366 
367   function changeLockupDuration(uint64 _newLockupDuration) public onlyOwner {
368     lockupDuration = _newLockupDuration;
369   }
370 
371   modifier nonZero(address _address) {
372     require(_address != 0);
373     _;
374   }
375 
376   modifier onlyCollateralTaker {
377     require(msg.sender == collateralTaker);
378     _;
379   }
380 
381   modifier onlyCollateralSeizer {
382     require(msg.sender == collateralSeizer);
383     _;
384   }
385 }