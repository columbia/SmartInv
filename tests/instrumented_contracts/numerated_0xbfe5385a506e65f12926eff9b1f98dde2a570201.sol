1 pragma solidity ^0.4.24;
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
65 pragma solidity ^0.4.24;
66 
67 
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender)
88     public view returns (uint256);
89 
90   function transferFrom(address from, address to, uint256 value)
91     public returns (bool);
92 
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 pragma solidity ^0.4.24;
101 
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
114     // benefit is lost if 'b' is also tested.
115     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116     if (a == 0) {
117       return 0;
118     }
119 
120     c = a * b;
121     assert(c / a == b);
122     return c;
123   }
124 
125   /**
126   * @dev Integer division of two numbers, truncating the quotient.
127   */
128   function div(uint256 a, uint256 b) internal pure returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     // uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return a / b;
133   }
134 
135   /**
136   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137   */
138   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   /**
144   * @dev Adds two numbers, throws on overflow.
145   */
146   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
147     c = a + b;
148     assert(c >= a);
149     return c;
150   }
151 }
152 pragma solidity ^0.4.24;
153 
154 /**
155  * @title Rivetz SPID Registration Contract
156  *
157  * @dev This is a Registrar-like contract
158  *
159  */
160 contract RivetzRegistrar is Ownable {
161     using SafeMath for uint256;
162 
163     struct SPEntry {
164         // Ethereum Address of Registrant - may use a multi-sig wallet-contract and can assign an admin
165         address registrant;
166         // Ethereum address of Administrator - must be an address that can sign arbitrary messages for Registrar authentication
167         address admin;
168         // Hash of SPID public key that is stored in Registrar
169         uint256 pubKeyHash;
170         // Hash of Service Provider organization data, etc.
171         uint256 infoHash;
172         // Expiration date of subscription in UNIX epoch seconds
173         uint256  expiration;
174         // Flag indicating whether this SPID has been approved by Rivetz for operation (KYC/AML)
175         bool    valid;
176     }
177 
178     // Add an event, so we an find all SPIDs via the log
179     event SPCreated(uint256 indexed spid);
180 
181     mapping(uint256 => SPEntry) public spEntries;
182 
183     // ERC-20 token that will be accepted for payment
184     ERC20 public rvt;
185     // Address of wallet to which received funds will be sent
186     address public paymentWalletAddress;
187     // Typed contract instance of the ERC20 token
188 
189     // Seconds per year, used in subscription calculations
190     uint64 constant secPerYear = 365 days;  /* Sec/Year */
191 
192     // Fee in ERC-20 that is charged to register a SPID
193     uint256 public registrationFee = 1000 ether;               /* Initial fee (in wei) -- includes 1 year */
194     // Annual subscription fee
195     uint256 constant defaultAnnualFee = 1000 ether;     /* wei/year */
196     // Annual fee as a per-second charge in "wei"
197     uint256 public feePerSec = defaultAnnualFee / secPerYear;  /* wei/sec = (wei/year) / (sec/year) */
198 
199 
200     /**
201       * Constructor
202       * @param paymentTokenAddress Address of ERC-20 token that will be accepted for payment
203       * @param paymentDestAddress Address wallet to which payments will be sent
204       */
205     constructor(address paymentTokenAddress, address paymentDestAddress) public {
206         rvt = ERC20(paymentTokenAddress);
207         paymentWalletAddress = paymentDestAddress;
208     }
209 
210     /**
211      * Register a new SPID
212      * Sending address is initial registrant and administrator
213      */
214     function register(uint256 spid, uint256 pubKeyHash, uint256 infoHash) public {
215         require(rvt.transferFrom(msg.sender, paymentWalletAddress, registrationFee));
216         SPEntry storage spEntry = newEntry(spid);
217         spEntry.registrant = msg.sender;
218         spEntry.admin = msg.sender;
219         spEntry.pubKeyHash = pubKeyHash;
220         spEntry.infoHash = infoHash;
221         spEntry.valid = false;
222     }
223 
224     /**
225      * Register a new SPID, sender must be Rivetz
226      */
227     function rivetzRegister(uint256 spid, uint256 pubKeyHash, uint256 infoHash, address spidRegistrant, address spidAdmin) onlyOwner public {
228         SPEntry storage spEntry = newEntry(spid);
229         spEntry.registrant = spidRegistrant;
230         spEntry.admin = spidAdmin;
231         spEntry.pubKeyHash = pubKeyHash;
232         spEntry.infoHash = infoHash;
233         spEntry.valid = true;
234     }
235 
236     /**
237      * Create a new SP entry for further modification
238      */
239     function newEntry(uint256 spid) internal returns (SPEntry storage) {
240         SPEntry storage spEntry = spEntries[spid];
241         require(spEntry.registrant == 0);
242         spEntry.expiration = now + secPerYear;
243         emit SPCreated(spid);
244         return spEntry;
245     }
246 
247     /**
248      * Change registrant, must be existing registrant or Rivetz
249      */
250     function setRegistrant(uint256 spid, address registrant) public {
251         SPEntry storage spEntry = spEntries[spid];
252         require(spEntry.registrant != 0 && spEntry.registrant != address(0x1) );
253         requireRegistrantOrGreater(spEntry);
254         spEntry.registrant = registrant;
255     }
256 
257     /**
258      * Change admin, must be existing registrant or Rivetz
259      */
260     function setAdmin(uint256 spid, address admin) public {
261         SPEntry storage spEntry = spEntries[spid];
262         requireRegistrantOrGreater(spEntry);
263         spEntry.admin = admin;
264     }
265 
266     /**
267      * Change pubKey, must be existing registrant or Rivetz
268      */
269     function setPubKey(uint256 spid, uint256 pubKeyHash) public {
270         SPEntry storage spEntry = spEntries[spid];
271         requireRegistrantOrGreater(spEntry);
272         spEntry.pubKeyHash = pubKeyHash;
273     }
274 
275     /**
276      * Change info hash, must be admin, registrant or Rivetz
277      */
278     function setInfo(uint256 spid, uint256 infoHash) public {
279         SPEntry storage spEntry = spEntries[spid];
280         requireAdminOrGreater(spEntry);
281         spEntry.infoHash = infoHash;
282     }
283 
284     /**
285      * Mark as approved, must be done by Rivetz
286      */
287     function setValid(uint256 spid, bool valid) onlyOwner public {
288         spEntries[spid].valid = valid;
289     }
290 
291     /**
292      * Renew subscription -- can be done by anyone that pays
293      */
294     function renew(uint256 spid, uint256 payment) public returns (uint256 expiration) {
295         SPEntry storage spEntry = spEntries[spid];
296         require(rvt.transferFrom(msg.sender, paymentWalletAddress, payment));
297         uint256 periodStart = (spEntry.expiration > now) ? spEntry.expiration : now;
298         spEntry.expiration = periodStart.add(feeToSeconds(payment));
299         return spEntry.expiration;
300     }
301 
302     /**
303      * Set subscription end date -- can only be done by Rivetz
304      */
305     function setExpiration(uint256 spid, uint256 expiration) onlyOwner public {
306         spEntries[spid].expiration = expiration;
307     }
308 
309     /**
310      * Permanently deactivate SPID, must be registrant -- expires subscription, invalidates
311      */
312     function release(uint256 spid) public {
313         SPEntry storage spEntry = spEntries[spid];
314         requireRegistrantOrGreater(spEntry);
315         spEntry.expiration = 0;
316         spEntry.registrant = address(0x1);
317         spEntry.admin = address(0x1);
318         spEntry.valid = false;
319     }
320 
321     /**
322      * Disable SPID, zeroes out everything -- must be Rivetz
323      */
324     function rivetzRelease(uint256 spid) onlyOwner public {
325         SPEntry storage spEntry = spEntries[spid];
326         spEntry.registrant = address(0x1);
327         spEntry.admin = address(0x1);
328         spEntry.pubKeyHash = 0;
329         spEntry.infoHash = 0;
330         spEntry.expiration = 0;
331         spEntry.valid = false;
332     }
333 
334     /**
335      * Set new registration and annual fees -- must be Rivetz
336      */
337     function setFees(uint256 newRegistrationFee, uint256 newAnnualFee) onlyOwner public {
338         registrationFee = newRegistrationFee;
339         feePerSec = newAnnualFee / secPerYear;
340     }
341 
342 
343     /**
344      * RvT is upgradeable, make sure we can update Registrar to use upgraded RvT
345      */
346     function setToken(address erc20Address) onlyOwner public {
347         rvt = ERC20(erc20Address);
348     }
349 
350     /**
351      * Change payment address -- must be Rivetz
352      */
353     function setPaymentAddress(address paymentAddress) onlyOwner public {
354         paymentWalletAddress = paymentAddress;
355     }
356 
357     /**
358      * Permission check - admin or greater
359      * SP Registrant or Admin can't proceed if subscription expired
360      */
361     function requireAdminOrGreater(SPEntry spEntry) internal view {
362         require (msg.sender == spEntry.admin ||
363                  msg.sender == spEntry.registrant ||
364                  msg.sender == owner);
365         require (isSubscribed(spEntry) || msg.sender == owner);
366     }
367 
368     /**
369      * Permission check - registrant or greater
370      * SP Registrant or Admin can't proceed if subscription expired
371      */
372     function requireRegistrantOrGreater(SPEntry spEntry) internal view  {
373         require (msg.sender == spEntry.registrant ||
374                  msg.sender == owner);
375         require (isSubscribed(spEntry) || msg.sender == owner);
376     }
377 
378     /**
379      * Get annual fee in RvT
380      */
381     function getAnnualFee() public view returns (uint256) {
382         return feePerSec.mul(secPerYear);
383     }
384 
385     /**
386      * @dev Calculates the number of seconds feeAmount would add to expiration date
387      * @param feeAmount : Amount of RvT-wei to convert to seconds
388      * @return seconds :  Equivalent number of seconds purchased
389      */
390     function feeToSeconds(uint256 feeAmount) internal view returns (uint256 seconds_)
391     {
392         return feeAmount / feePerSec;                   /* secs = wei / ( wei/sec)  */
393     }
394 
395     function isSubscribed(SPEntry spEntry) internal view returns (bool subscribed)
396     {
397         return now < spEntry.expiration;
398     }
399 }