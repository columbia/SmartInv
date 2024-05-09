1 pragma solidity ^0.4.19;
2 
3 /*
4 developed by cryptonomica.net, 2018
5 last version: 2018-02-18
6 github: https://github.com/Cryptonomica/
7 */
8 
9 contract CryptonomicaVerification {
10 
11     /* ---------------------- Verification Data */
12 
13     // Ethereum address is connected to OpenPGP public key data from Cryptonomica.net
14     // Ethereum address can be connected to one OpenPGP key only, and one time only
15     // If OpenPGP key expires, user have to use another Ethereum address for new OpenPGP public key
16     // But user can verify multiple Ethereum accounts with the same OpenPGP key
17 
18     // ---- mappings to store verification data, to make it accessible for other smart contracts
19     // we store sting data as bytes32 (http://solidity.readthedocs.io/en/develop/types.html#fixed-size-byte-arrays)
20     // !!! -> up to 32 ASCII letters,
21     // see: https://ethereum.stackexchange.com/questions/6729/how-many-letters-can-bytes32-keep
22 
23     // OpenPGP Message Format https://tools.ietf.org/html/rfc4880#section-12.2 : "A V4 fingerprint is the 160-bit SHA-1 hash ..."
24     // thus fingerprint is 20 bytes, in hexadecimal 40 symbols string representation
25     // fingerprints are stored as upper case strings like:
26     // 57A5FEE5A34D563B4B85ADF3CE369FD9E77173E5
27     // or as bytes20: "0x57A5FEE5A34D563B4B85ADF3CE369FD9E77173E5" from web3.js or Bytes20 from web3j
28     // see: https://crypto.stackexchange.com/questions/32087/how-to-generate-fingerprint-for-pgp-public-key
29     mapping(address => bytes20) public fingerprint; // ..............................................................0
30 
31     // we use unverifiedFingerprintAsString to store fingerprint provided by user
32     mapping(address => string) public unverifiedFingerprint; // (!) Gas requirement: infinite
33 
34     mapping(address => uint) public keyCertificateValidUntil; // unix time ..........................................1
35     mapping(address => bytes32) public firstName; // ................................................................2
36     mapping(address => bytes32) public lastName; // .................................................................3
37     mapping(address => uint) public birthDate; // unix time .........................................................4
38     // Nationality - from user passport or id document:
39     // 2-letter country codes defined in ISO 3166
40     // like returned by Locale.getISOCountries() in Java (upper case)
41     // see: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
42     mapping(address => bytes32) public nationality; //      .........................................................5
43     mapping(address => uint256) public verificationAddedOn; // unix time ............................................6
44     mapping(address => uint256) public revokedOn; // unix time, returns uint256: 0 if verification is not revoked ...7
45     // this will be longer than 32 char, and have to be properly formatted (with "\n")
46     mapping(address => string) public signedString; //.(!) Gas requirement: infinite.................................8
47 
48     // unix time online converter: https://www.epochconverter.com
49     // for coders: http://www.convert-unix-time.com
50     mapping(address => uint256) public signedStringUploadedOnUnixTime;
51 
52     // this allows to search for account connected to fingerprint
53     // as a key we use fingerprint as bytes32, like 0x57A5FEE5A34D563B4B85ADF3CE369FD9E77173E5
54     mapping(bytes20 => address) public addressAttached; //
55 
56     // (!) Gas requirement: infinite
57     string public stringToSignExample = "I hereby confirm that the address <address lowercase> is my Ethereum address";
58 
59     /* the same data as above stored as a struct:
60     struct will be returned as 'List' in web3j (only one function call needed) */
61     mapping(address => Verification) public verification; // (!) Gas requirement: infinite
62     struct Verification {
63         // all string have to be <= 32 chars
64         string fingerprint; // ................................................0
65         uint keyCertificateValidUntil; // .....................................1
66         string firstName; // ..................................................2
67         string lastName;// ....................................................3
68         uint birthDate; //  ...................................................4
69         string nationality; //  ...............................................5
70         uint verificationAddedOn;// ...........................................6
71         uint revokedOn; // ....................................................7
72         string signedString; //................................................8
73         // uint256 signedStringUploadedOnUnixTime; //... Stack too deep
74     }
75 
76     /*  -------------------- Administrative Data */
77     address public owner; // smart contract owner (super admin)
78     mapping(address => bool) public isManager; // list of managers
79 
80     uint public priceForVerificationInWei; // see converter on https://etherconverter.online/
81 
82     address public withdrawalAddress; // address to send Ether from this contract
83     bool public withdrawalAddressFixed = false; // this can be smart contract with manages ETH from this SC
84 
85     /* --------------------- Constructor */
86     function CryptonomicaVerification() public {// Constructor must be public or internal
87         owner = msg.sender;
88         isManager[msg.sender] = true;
89         withdrawalAddress = msg.sender;
90     }
91 
92     /* -------------------- Utility functions : ---------------------- */
93 
94     // (?) CryptonomicaVerification.stringToBytes32(string memory) : Is constant but potentially should not be.
95     // probably because of 'using low-level calls' or 'using inline assembly that contains certain opcodes'
96     // but 'The compiler does not enforce yet that a pure method is not reading from the state.'
97     // > in fact works as constant
98     function stringToBytes32(string memory source) public pure returns (bytes32 result) {// (!) Gas requirement: infinite
99         // require(bytes(source).length <= 32); // causes error, but string have to be max 32 chars
100 
101         // https://ethereum.stackexchange.com/questions/9603/understanding-mload-assembly-function
102         // http://solidity.readthedocs.io/en/latest/assembly.html
103         // this converts every char to its byte representation
104         // see hex codes on http://www.asciitable.com/ (7 > 37, a > 61, z > 7a)
105         // "az7" > 0x617a370000000000000000000000000000000000000000000000000000000000
106         assembly {
107             result := mload(add(source, 32))
108         }
109     }
110 
111     // see also:
112     // https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string
113     // https://ethereum.stackexchange.com/questions/1081/how-to-concatenate-a-bytes32-array-to-a-string
114     // 0x617a370000000000000000000000000000000000000000000000000000000000 > "az7"
115     function bytes32ToString(bytes32 _bytes32) public pure returns (string){// (!) Gas requirement: infinite
116         // string memory str = string(_bytes32);
117         // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
118         // thus we should convert bytes32 to bytes (to dynamically-sized byte array)
119         bytes memory bytesArray = new bytes(32);
120         for (uint256 i; i < 32; i++) {
121             bytesArray[i] = _bytes32[i];
122         }
123         return string(bytesArray);
124     }
125 
126     /* -------------------- Verification functions : ---------------------- */
127 
128     // from user acc
129     // (!) Gas requirement: infinite
130     function uploadSignedString(string _fingerprint, bytes20 _fingerprintBytes20, string _signedString) public payable {
131 
132         // check length of the uploaded string,
133         // it expected to be a 64 chars string signed with OpenPGP standard signature
134         // bytes: Dynamically-sized byte array,
135         // see: http://solidity.readthedocs.io/en/develop/types.html#dynamically-sized-byte-array
136         // if (bytes(_signedString).length > 1000) {//
137         //    revert();
138         //    // (payable)
139         // }
140         // --- not needed: if string is to big -> out of gas
141 
142         // check payment :
143         if (msg.value < priceForVerificationInWei) {
144             revert();
145             // (payable)
146         }
147 
148         // if signed string already uploaded, should revert
149         if (signedStringUploadedOnUnixTime[msg.sender] != 0) {
150             revert();
151             // (payable)
152         }
153 
154         // fingerprint should be uppercase 40 symbols
155         if (bytes(_fingerprint).length != 40) {
156             revert();
157             // (payable)
158         }
159 
160         // fingerprint can be connected to one eth address only
161         if (addressAttached[_fingerprintBytes20] != 0) {
162             revert();
163             // (payable)
164         }
165 
166         // at this stage we can not be sure that key with this fingerprint really owned by user
167         // thus we store it as 'unverified'
168         unverifiedFingerprint[msg.sender] = _fingerprint;
169 
170         signedString[msg.sender] = verification[msg.sender].signedString = _signedString;
171 
172         // uint256 - Unix Time
173         signedStringUploadedOnUnixTime[msg.sender] = block.timestamp;
174 
175         SignedStringUploaded(msg.sender, _fingerprint, _signedString);
176 
177     }
178 
179     event SignedStringUploaded(address indexed fromAccount, string fingerprint, string uploadedString);
180 
181     // from 'manager' account only
182     // (!) Gas requirement: infinite
183     function addVerificationData(
184         address _acc, //
185         string _fingerprint, // "57A5FEE5A34D563B4B85ADF3CE369FD9E77173E5"
186         bytes20 _fingerprintBytes20, // "0x57A5FEE5A34D563B4B85ADF3CE369FD9E77173E5"
187         uint _keyCertificateValidUntil, //
188         string _firstName, //
189         string _lastName, //
190         uint _birthDate, //
191         string _nationality) public {
192 
193         // (!!!) only manager can add verification data
194         require(isManager[msg.sender]);
195 
196         // check input
197         // fingerprint should be uppercase 40 symbols
198         // require(bytes(_fingerprint).length == 40);
199         // require(bytes(_firstName).length <= 32);
200         // require(bytes(_lastName).length <= 32);
201         // _nationality should be like "IL" or "US"
202         // require(bytes(_nationality).length == 2);
203         // >>> if we control manager account we can make checks before sending data to smart contract (cheaper)
204 
205         // check if signed string uploaded
206         require(signedStringUploadedOnUnixTime[_acc] != 0);
207         // to make possible adding verification only one time:
208         require(verificationAddedOn[_acc] == 0);
209 
210         verification[_acc].fingerprint = _fingerprint;
211         fingerprint[_acc] = _fingerprintBytes20;
212 
213         addressAttached[_fingerprintBytes20] = _acc;
214 
215         verification[_acc].keyCertificateValidUntil = keyCertificateValidUntil[_acc] = _keyCertificateValidUntil;
216         verification[_acc].firstName = _firstName;
217         firstName[_acc] = stringToBytes32(_firstName);
218         verification[_acc].lastName = _lastName;
219         lastName[_acc] = stringToBytes32(_lastName);
220         verification[_acc].birthDate = birthDate[_acc] = _birthDate;
221         verification[_acc].nationality = _nationality;
222         nationality[_acc] = stringToBytes32(_nationality);
223         verification[_acc].verificationAddedOn = verificationAddedOn[_acc] = block.timestamp;
224 
225         VerificationAdded(
226             verification[_acc].fingerprint,
227             _acc,
228         // keyCertificateValidUntil[_acc],
229         // verification[_acc].firstName,
230         // verification[_acc].lastName,
231         // birthDate[_acc],
232         // verification[_acc].nationality,
233             msg.sender
234         );
235         // return true;
236     }
237 
238     event VerificationAdded (
239         string forFingerprint,
240         address indexed verifiedAccount, // (1) indexed
241     // uint keyCertificateValidUntilUnixTime,
242     // string userFirstName,
243     // string userLastName,
244     // uint userBirthDate,
245     // string userNationality,
246         address verificationAddedByAccount
247     );
248 
249     // from user or 'manager' account
250     function revokeVerification(address _acc) public {// (!) Gas requirement: infinite
251         require(msg.sender == _acc || isManager[msg.sender]);
252 
253         verification[_acc].revokedOn = revokedOn[_acc] = block.timestamp;
254 
255         // event
256         VerificationRevoked(
257             _acc,
258             verification[_acc].fingerprint,
259             block.timestamp,
260             msg.sender
261         );
262     }
263 
264     event VerificationRevoked (
265         address indexed revocedforAccount, // (1) indexed
266         string withFingerprint,
267         uint revokedOnUnixTime,
268         address indexed revokedBy // (2) indexed
269     );
270 
271     /* -------------------- Administrative functions : ---------------------- */
272 
273     // to avoid mistakes: owner (super admin) should be changed in two steps
274     // change is valid when accepted from new owner address
275     address private newOwner;
276     // only owner
277     function changeOwnerStart(address _newOwner) public {
278         require(msg.sender == owner);
279         newOwner = _newOwner;
280         ChangeOwnerStarted(msg.sender, _newOwner);
281     } //
282     event ChangeOwnerStarted (address indexed startedBy, address indexed newOwner);
283     // only by new owner
284     function changeOwnerAccept() public {
285         require(msg.sender == newOwner);
286         // event here:
287         OwnerChanged(owner, newOwner);
288         owner = newOwner;
289     } //
290     event OwnerChanged(address indexed from, address indexed to);
291 
292     // only owner
293     function addManager(address _acc) public {
294         require(msg.sender == owner);
295         isManager[_acc] = true;
296         ManagerAdded(_acc, msg.sender);
297     } //
298     event ManagerAdded (address indexed added, address indexed addedBy);
299     // only owner
300     function removeManager(address manager) public {
301         require(msg.sender == owner);
302         isManager[manager] = false;
303         ManagerRemoved(manager, msg.sender);
304     } //
305     event ManagerRemoved(address indexed removed, address indexed removedBy);
306 
307     // only by manager
308     function setPriceForVerification(uint priceInWei) public {
309         // see converter on https://etherconverter.online
310         require(isManager[msg.sender]);
311         uint oldPrice = priceForVerificationInWei;
312         priceForVerificationInWei = priceInWei;
313         PriceChanged(oldPrice, priceForVerificationInWei, msg.sender);
314     } //
315     event PriceChanged(uint from, uint to, address indexed changedBy);
316 
317     // !!! can be called by any user or contract
318     // check for re-entrancy vulnerability http://solidity.readthedocs.io/en/develop/security-considerations.html#re-entrancy
319     // >>> since we are making a withdrawal to our own contract only there is no possible attack using re-entrancy vulnerability,
320     function withdrawAllToWithdrawalAddress() public returns (bool) {// (!) Gas requirement: infinite
321         // http://solidity.readthedocs.io/en/develop/security-considerations.html#sending-and-receiving-ether
322         // about <address>.send(uint256 amount) and <address>.transfer(uint256 amount)
323         // see: http://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=transfer#address-related
324         // https://ethereum.stackexchange.com/questions/19341/address-send-vs-address-transfer-best-practice-usage
325         uint sum = this.balance;
326         if (!withdrawalAddress.send(this.balance)) {// makes withdrawal and returns true or false
327             Withdrawal(withdrawalAddress, sum, msg.sender, false);
328             return false;
329         }
330         Withdrawal(withdrawalAddress, sum, msg.sender, true);
331         return true;
332     } //
333     event Withdrawal(address indexed to, uint sumInWei, address indexed by, bool success);
334 
335     // only owner
336     function setWithdrawalAddress(address _withdrawalAddress) public {
337         require(msg.sender == owner);
338         require(!withdrawalAddressFixed);
339         WithdrawalAddressChanged(withdrawalAddress, _withdrawalAddress, msg.sender);
340         withdrawalAddress = _withdrawalAddress;
341     } //
342     event WithdrawalAddressChanged(address indexed from, address indexed to, address indexed changedBy);
343 
344     // only owner
345     function fixWithdrawalAddress(address _withdrawalAddress) public returns (bool) {
346         require(msg.sender == owner);
347         require(withdrawalAddress == _withdrawalAddress);
348 
349         // prevents event if already fixed
350         require(!withdrawalAddressFixed);
351 
352         withdrawalAddressFixed = true;
353         WithdrawalAddressFixed(withdrawalAddress, msg.sender);
354         return true;
355     } //
356     // this event can be fired one time only
357     event WithdrawalAddressFixed(address withdrawalAddressFixedAs, address fixedBy);
358 
359 }