1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 /**
4  ;:::::::::::::::::::::::::::::::::;;:::;;:;;:;;;:::::::::cccccc::::::;;;,''''''''.........    .;ldddddddoolc;,..',;:::::::::::::::::::::::::::::::::::
5 ;;::::::;::::::::::::::::::::::::;;;::;;;;;:::::::::::ccccccccc:::::;;,,',''''''''''......    'ldxdddddoollcc:,...';::::::::::::::::::::::::::::::::::
6 ;;;::::;:::::::::::::::;:::;;:;::;;;;;;:;;;;;::::::clllcccclcccc::;;,,,,,,,,'''',,'........  .:dxxxdddooolc::;;,....,;::::::::::::::::::::::::::::::::
7 ;;;::::::::::::::::::::;:::;;:;;;;;;;;:;;;:::::::cllccccllllccc::;,,,,,,,,'''',,,'.........  .,lddddddooollc;;,,'....';:::::::::::::::::::::::::::::::
8 ;;:::;;;:;;:::::::::::::::::::::;;;;;::;:::::;:lllc::cllllllc::;,,;;;,,,,,,,,,,''.''...........;coddddooolcc:;,,,'.. .';::::::::::::::::::::::::::::::
9 ;;;;;;;;;;;::;;;:::::::::::::;;;;;;::;::::::clolc::cloolllcc:;,,;;;;,,,,,,,,,,'''''........';::,;clooddolll::;,'''... .';:::::::::::::::::::::::::::::
10 ;;;;;;;;;;;;;;::::::::::::::;;;;;;;;::::;;:looc::cloooollc:;,,;;;;;,,,,,,,,,''''''........,:oxxdc::looooolcc:;;,'..... .';::::::::::::::::::::::::::::
11 ;;;::::;;;;;;:::::::::::::;;;;;;;;;;:::::lool::cloodoollc:;;;;::;,,,,,,,,'''''''''......';cdkOOOko::clooolcc:;;,'...... .';:::::::::::::::::::::::::::
12 :;:::;;;;;;;;::;:::::::;::;;;;;;;;:::::codoc::looddoolc:;;;:::;;,,,;;,,,''...'''.......';lk00000Okdc;clloll::;;,,'.....  .,:::::::::::::::::::::::::::
13 ::;;;;;;:;;;;;;::::::::;;:;;;;;;;::::clddl::cloddddol:;;::cc:;;;;;;;,,'''...'''.......,cdO0K0000OOko:;cllllc:;;,,'......  .,::::::::::::::::::::::::::
14 ;;;;;;;;:;;;;;;:;::::::;;;;;;;;;:::clodoc::clddddol:;;:cccc:;;;;;;;,''''..'''.......':ok0KK0000OOkkxl;;cclllc;,,,''......  .;:::::::::::::::::::::::::
15 ;;;;;;;::;;;;;;;;;:;:;;;;;;;;;;:::coddl:::loddddlc;;:cllcc::::::;,''''...'........';ok0KKKK000OOkkxxdc;:ccclc:,''''......   .;::::::::::::::::::::::::
16 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::codoc::clddddlc;:cllllllcccc:;;,'''............';ok0KKKK0000OOkkkxxdc;:ccccc:,''''.......  .,::::::::::::::::::::::::
17 ;;;;;;;;:;;;;;;;;;;;;;;;;;;;;:::lddlc:cloddol:;:clooooollllc:;,'''............':oO0KKKK0000OOOkkkxxddl;;ccc:cc;,..''......   .;:::::::::::::::::::::::
18 ;;;;;;;;;;;;;;;;;;;;;:;;;;;;::codoc::cooolc:;:cllooooooolc:;,''..............;ok0KKKKK0000OOOkkkxxddol:;:cc:cc:,..''......    ';::::::::::::::::::::::
19 ;;;;;;;;;;;;;;;;;::;;:;;;;;:ccool::clolc:;:ccllllllollc:;,''''.....         ..',:codkO000OOOkkxxxdddol:,:cc::c:;'..'.... .    .,::::::::::::::::::::::
20 ;;;;;;;;;;;;;;;;;;:;;;;;;;:clolc::cll:;,'',,;,,'..',,,''''....                      .':oxOOkkxxxdddool:,;cc::cc;'..'....       .;:::::::::::::::::::::
21 ;;;;;;;;;;;;;;;;;;;;;;;;::cloc:;:::,'..            ............                         .;lxxxddddooll:,;cc:::c;'..''....      .,:::::::::::::::::::::
22 ;;;;;;;;;;;;;;;;;;;;;;;;cllc:;,'...               .;;;;;;;;;;;'..................          'cdddooollc;';:::::c;'..''....       .;::::::::::::::::::::
23 ;;;;;;;;;;;;;;;;;;;;;;;;;;,'..                  .'oxddxxxxddddc,'.'''''''',,,,,,,''...       'coolllc:,.,:::::c;'..''.....       '::::::::::::::::::::
24 ;;;;;;;;;;;;;;;;;;;;;;,'...        .........''',:okOOOOOOOOOOOkdc::::::ccloooddddolc:;'.      .,cllcc:'.,::;;::;'..',.....       .;:::::::::::::::::::
25 ;;;;;;;;;;;;;;;;;;;;;;;,'..    .,cllooooooollccccldO0000OOOkkkxolllloooddxxxxkkOOOOkxdoc,..     .:cc:;..',,......  ...            ':::::::::::::::::::
26 ;;;;;;;;;;;;;;;;;;;;;;;;;;,'....;xkkkkkkkkxxddoolllx0000Okxddooc:ccloddxxxxxxxxxxxxkkkxdoc;'.    .,:;,...                         .;::::::::::::::::::
27 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,;lxkOOOOOOkkxddollld0K0OkxdololcclodxkO0000OOkkkxddddddddolc;,..  .',,'...                  .      ';:::::::::::::::::
28 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;:cccloolllodddolloOK0OkdolooolodxOOkxdoooollcccccllllloolllccccccc:;,,'...        ....... .      .;:::::::::::::::::
29 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,,:,.':c;...;dxdddodOK0OxdooddddxOOkdxo,.;ll:....;oolllcclloddxxxxdolc::;;,.       ...........     .,:::::::::::::::::
30 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;co;.;:'....oKK0kxdk0K0kxoooxkxkOOkk0NO:':ll;. ..lKKOdlllloxkOOkkxdolccccc:;. ..   ..',........     .;::::::::::::::::
31 ;;;;;;;;;;;;;;;;;;;;;;:::;;;;;;;;:l:...   .;kXXK0kk0KKOkdoodkkO00OKNNN0c....   .,xXX0xloodkO0OOkxdoolllllll:. .......;:,.......     .,::::::::::::::::
32 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cl;.. ..;x000OOO0KK0OxoloxOO0KK00KXNNk;.    .,d00kxddodk00Okxxdoollllllll:. .......;c:,.......     .;:::::::::::::::
33 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;col:;:oxOOOOOkk0KKOkdolokOO0KXXKKKKXKkoc::coxOkxxddodk00Okxddollllllllll:. .';,...,ll:'''.....    .,:::::::::::::::
34 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lxkkOOOOkxdlokKK0OxdlldO0OkO0KKKKKKK0000OOkxxdollldO0OOkxdoollcclllllll,...'::,..,cdl;''.....     ':::::::::::::::
35 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:dxoooollc:clkKK0Okdolok00OkkkOkkkkkkkxxxdollcccldkO0OOkxdoollcccllllllc....':lc'.':ddc,'......    .;::::::::::::::
36 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:x0kdllllodk0XXK0kxdolx000OkxkO0OxdoollccccclodkO000Okxxdoollccclllllll;..',';ll;..:odl;'......     ,::::::::::::::
37 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:dKXKKKKKKKKXXK0OkdoldOK00OkxxOKKXKK000OOO000KKKK00Okxxdolllccclllllllc'  ,:,;loc,.;ldo:'......     .::::::::::::::
38 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;d0XXXXXKKKXXX0Okxdoox0K00Okxxk0KXXXXXNNXXXXXXKK00Okxxdoollccccllllllc;.  ,c;,:ol;''cdoc,... ..     .;:::::::::::::
39 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lOKKKKK0KKXXK0kxdoldOKK0Okxxdk0KXXXNNNNNNXXXKK00Okxxdoollccccllllllc:,.  'c:,;loc,':odl;'.. ..      ,:::::::::::::
40 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:kKKKK00KXXK0OkxdooxO0Okkxdddx0KXXXXNXXXXXXKK00Okxxddolllcccllllllcc:'   .cc;;cll;',loo:'.. ...     ':::::::::::::
41 ;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;;;;;,'o00000KXXK0Okxdolldkkkxdollox0KXXXXXXXXXKKK00Okkxddoolllcccllllllc:;.    ;l:,;cl:,,cooc,.. ...     .;::::::::::::
42 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'.:kOkOKXXXK0OkxoodkO0000Oxl:cdk0KKKKKKKKKK00OOkkxddoollllccllllllcc:,.    ,lc;;:lc,':ooc,.. ...     .;::::::::::::
43 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;..,dkkKXXXK0OOkkk00KK000Okkd:;cokO00KKKK0000OOkkxxddoollllcclllllcc:;'.    .cl;,;cc;,;loc,.. ...     .;::::::::::::
44 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,. 'dOKXXXXK000000Okdolllllll;;coodxOOOOOOOOOkkkxxddooollllcllllllcc:;'.    .:l:,;:c:,;col;.. ...     .;::::::::::::
45 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,. 'x0KXNXKK00Okdl;'.. ...',,,;codooodxkkkkkkkxxxddoooollllllllllccc:,..    .;l:,,:::;;cll;.. ...     .;::::::::::::
46 :;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,. .dkxxxxdol:;,...      ..';:clldxxolloodddxxdddddoooollllllllllcc:;,..     ,c:;,;::;;:lc,.  ..      .;::::::::::::
47 ::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;. .oOkddolcc;'..     ...',;:cclllodxxolccloodddddoooollllllllllcc::;'.      ,c:;,;::;;:lc,.  ..      ':::::::::::::
48 :;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;. .cOOkxddO0Od:'.   ..',,;:ccccllloddxdollooddddddooolllllllllccc:;,..      ,cc;,;;;;,;c;..  .      .;:::::::::::::
49 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'  ,xkxdodO00Odl;....',;;:cccccccc:cloddddodxxxdddooollllllllccc::;'..      ,cc;,,;;,',;'.        .';::::::::::::::
50 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'. .okxdooxOOOOxlcllc:;;:::::::c:;,;:codddddxkkxddoollllllllccc::;,...      .;:;,,,''...        .';::::::::::::::::
51 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,. .:xxxddkkdlcccllc,'..'',;:cloddddooodddxxkkkkxdoolllcccccccc:;,'..        .'.....         ..,;::::::::::::::::::
52 ;:;::;;;;;;;;:;;;;;;::;;;;;;;;;;;;;,.  .okxxk00Okxdol::;;::cclooddxxkkkkxddxxxxkkkkxdolllcccccccc:;;,'..                     .';::::::::::::::::::::::
53 ::::;;;;;;;;;::;;:;;;::;;;;;;;;;;;;;.   ;xkkO000O0000Okxolc::cloddxxkkkkxxxxxdxxkkxxdolllccccccc::;,''...  .........       ..,::::::::::::::::::::::::
54 ;;;;;;;;;;:;;:;;;;:;::::::;;;;;;;;;;.   .lkkO00Okoc;;,,''..',:loddxxxxkkkxxxxddxxxxdoollccccccc::;,,'''.....',,;::;;;;,,,,;;::::::::::::::::::::::::::
55 ;;;;;;;;;;:;;;;;;;;;;::;;;;;;;;;;;;;,'''':xkOOOOxo:;;::::::cclodxxxxxxxxxxxxddddxxddollccccccc:;;,,,,,,''...   ...,;::::::::::::::::::::::::::::::::::
56 ::;;;;;;::;;;;;;;;;;;;;;;;:::;;;;;;;;;;;;:okOOOOOkO0KKXXKKK00OOkkxxxxxxxxxxxddddxxddolcccccc::;,,,,,,;;,''..      .'::::::::::::::::::::::::::::::::::
57 ::::;;::::;;;;;;;;;;;;::::::::;;;;;;;;;;;;cdkOO00KXXXXXXXXXXKK0OOkkxxxxxxxxxxxxxxxdollcccc::;;,,,,,,;;;,''..  ...',,::::::::::::::::::::::::::::::::::
58 :::::;::::::::;;;;;;;;;:::::::;;;;;;;;;;;;;cxOO00KXXXXXXXXXKK00OOkkkkxxxxxxxxxxxxdolccc:::;,,',,,;;;;;,,;;;;;:::;,',::::::::::::::c:::::::::::::::::::
59 :::::;;;;:::::;::::;;;;;;:::::;;;;;;;;;;;;;:lkO00KKXXXXXXKK00OOkkkkxxxxxxxxxxxxdoolcc::;;,'',,,;;;,,;cclllcc:;;,''';::::::::::::::::::::::::::::::::::
60 :::::;;;:::::::;:::::::::;::::;::;;;;;;;;;;;:ok000KKKKKKK00OOkkxxxxxxxxxxdddddollc::;,,'''',,;;;,',:llc::::::;;,'',:::::::::::::::::::::::::::::::::::
61 ::::::::::::::::;::::::::::::::::::;;;;;;;;;;:dOOO0000OOOkkxxdddddddddddooollcc:;;,'''''',,;;;;,..coccc:::::;;,,'';:::::::::::::::c:::::::::::::::::::
62 ::::::::::::::::;;::::::::::::::::;;;;;;;;;;;:ldxxkkxxxdddoolllllllllllcc::;;,,''...'',,,;;;;;,..'llcc::::;;;,,''';:::::::::::::::::::::::::::::::::::
63 :::::;:::::::::::::::::::;;::::::::::;;;;;;;;:odxdlcccc:::::::::::::;;,,''.......''',,,;;;;;;;,..;lc:::::;;;;,,'',::::::::::::::cc::::::::::::::::::::
64 :::::;:::::::::::::::::::::::::::::::::;;;;:;:oxOkc'...''''''''''''...........'''',,,,,,,;;:::ccccc::::::;;;;,,'',:::::::::::::::cc:::::::::::::::::::
65 :::::::::::::::::::::::::::::::::::::::;;;;:::oxOKx'   ':,'..........'''''''''',,,;;;::cccclllcc::::::::;;;;,,,'',::::::::::::::ccc:::c:::::::::::::::
66 :::::::::::::::::::::;:::;:::::::::;;::::::::coxkOo.   .oxolc:;;;;,,;;::cclllooddooooolllccc::::::::::::;;;;,,,'';::::::::::::::ccc::cc:::::::::::::::
67 :::::::::::::::::::::::::::::::::::::::::::::ldxkk:..   ;xOOkxxddddxxkkOOkkkkxxdollccc:::::::::::::::::;;;;;,,,'';::::::::::::ccccc::cc:::::::::::::::
68 :::::::::::::::::::::::::::::::::::::::;::::ldxdkkxxxl,..,lxkkkkkOkxdddollcccc:::::::::::::::::::::::;;;;;;;;,,,,;::::::::::::c:::ccc::ccc::::::::::cc
69 ::::::::::::::::::::::::::::::::::;;:::;;;;cdxxxxkdx0KOd:,;cdkOOOOkocccc:::::::::::::::::::::::::::::;;;;;;;;;;,'';:::::::::::::::cc:::::::::::::::::c
70 ::::::::::::::::::::::::::::::::::::;;,''':dkkxxxkd::xOOOOkkkxdoccol:::::::::::::::::::::::::::::::::;;;;;;;;;,'..;::::::::cc::::ccc::::::::::::::::::
71 ::::::::::::::::::::::::::::::::;;,,''...;dO0Okkxkkl.'lxdolc:;,,',ll;:::::::::ccc:::::::::::::::::::::::::;;,,,''.';::::::::c::cc:::::::::::::::::::::
72 :::::::::::::::::::;::::;;::::;;,'......,oOKK0Okkkkx;.'oxol:;;,,',ll;::::::ccccccc::c::::::::::::::::::;;;,,,,,,'...';:ccc:::::cc:::c:::::::::::::::::
73 :::::::::::::::::::::;::::::;,''.......'lk0KKKK0kkkkl..;xxdl:;,,,;ol;;::::cccccccccccccccccccccc::::;;;;;;;;;;;,..  ..,:cc:::c::ccccc:::::::::::::::::
74 ::::::::::::::::::;:;;::::;,'.........':x0KKKKKK0Okko' .lkxoc;;,,;ol;;:::ccccccccccccccccccc:::::::::::::::::;,.........,:::::c::ccc::::::::::::::::::
75 ::::::::::::::::::;::;::;,''..........;dOKKKKKKKKK0Od,..,dkdc;;,,:oc;;::cccclllloooool::::::;::::ccccc::::::;.............';:::::c:c::::::::::::::::::
76 ::::::::::::::::::;;:::;,'...........'lk0KKKKKKKKKKKOo:,cxko:;;;,coc;;:clooodddooooodl;::cclllllcccccccccc:'................';::::::::::::::::::::::::
77 ::::::::::::::::::::;;,'.............:x0KKKKKKKKKKKKKKkdOK0Oxdllldo;;:lodxxxxxxxxxxxkoccloooooollllllllc:,.....................,::::::::::::::::::::::
78 :::::::::::::::::::;;,'.............,lk0KKKKKKKKKKKKKKkx0KKKKK0OkkxodxkkOOOOOOOkkkkkkdclodddddoooolllol;........................,;::::::::::::::::c:::                                                                                                                                                                                                                                                                  
79 */
80 
81 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev Contract module that helps prevent reentrant calls to a function.
87  *
88  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
89  * available, which can be applied to functions to make sure there are no nested
90  * (reentrant) calls to them.
91  *
92  * Note that because there is a single `nonReentrant` guard, functions marked as
93  * `nonReentrant` may not call one another. This can be worked around by making
94  * those functions `private`, and then adding `external` `nonReentrant` entry
95  * points to them.
96  *
97  * TIP: If you would like to learn more about reentrancy and alternative ways
98  * to protect against it, check out our blog post
99  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
100  */
101 abstract contract ReentrancyGuard {
102     // Booleans are more expensive than uint256 or any type that takes up a full
103     // word because each write operation emits an extra SLOAD to first read the
104     // slot's contents, replace the bits taken up by the boolean, and then write
105     // back. This is the compiler's defense against contract upgrades and
106     // pointer aliasing, and it cannot be disabled.
107 
108     // The values being non-zero value makes deployment a bit more expensive,
109     // but in exchange the refund on every call to nonReentrant will be lower in
110     // amount. Since refunds are capped to a percentage of the total
111     // transaction's gas, it is best to keep them low in cases like this one, to
112     // increase the likelihood of the full refund coming into effect.
113     uint256 private constant _NOT_ENTERED = 1;
114     uint256 private constant _ENTERED = 2;
115 
116     uint256 private _status;
117 
118     constructor() {
119         _status = _NOT_ENTERED;
120     }
121 
122     /**
123      * @dev Prevents a contract from calling itself, directly or indirectly.
124      * Calling a `nonReentrant` function from another `nonReentrant`
125      * function is not supported. It is possible to prevent this from happening
126      * by making the `nonReentrant` function external, and making it call a
127      * `private` function that does the actual work.
128      */
129     modifier nonReentrant() {
130         // On the first call to nonReentrant, _notEntered will be true
131         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
132 
133         // Any calls to nonReentrant after this point will fail
134         _status = _ENTERED;
135 
136         _;
137 
138         // By storing the original value once again, a refund is triggered (see
139         // https://eips.ethereum.org/EIPS/eip-2200)
140         _status = _NOT_ENTERED;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/utils/Strings.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev String operations.
153  */
154 library Strings {
155     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
156     uint8 private constant _ADDRESS_LENGTH = 20;
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
160      */
161     function toString(uint256 value) internal pure returns (string memory) {
162         // Inspired by OraclizeAPI's implementation - MIT licence
163         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
164 
165         if (value == 0) {
166             return "0";
167         }
168         uint256 temp = value;
169         uint256 digits;
170         while (temp != 0) {
171             digits++;
172             temp /= 10;
173         }
174         bytes memory buffer = new bytes(digits);
175         while (value != 0) {
176             digits -= 1;
177             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
178             value /= 10;
179         }
180         return string(buffer);
181     }
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
185      */
186     function toHexString(uint256 value) internal pure returns (string memory) {
187         if (value == 0) {
188             return "0x00";
189         }
190         uint256 temp = value;
191         uint256 length = 0;
192         while (temp != 0) {
193             length++;
194             temp >>= 8;
195         }
196         return toHexString(value, length);
197     }
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
201      */
202     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
203         bytes memory buffer = new bytes(2 * length + 2);
204         buffer[0] = "0";
205         buffer[1] = "x";
206         for (uint256 i = 2 * length + 1; i > 1; --i) {
207             buffer[i] = _HEX_SYMBOLS[value & 0xf];
208             value >>= 4;
209         }
210         require(value == 0, "Strings: hex length insufficient");
211         return string(buffer);
212     }
213 
214     /**
215      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
216      */
217     function toHexString(address addr) internal pure returns (string memory) {
218         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
219     }
220 }
221 
222 
223 // File: @openzeppelin/contracts/utils/Context.sol
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
249 
250 // File: @openzeppelin/contracts/access/Ownable.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor() {
279         _transferOwnership(_msgSender());
280     }
281 
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         _checkOwner();
287         _;
288     }
289 
290     /**
291      * @dev Returns the address of the current owner.
292      */
293     function owner() public view virtual returns (address) {
294         return _owner;
295     }
296 
297     /**
298      * @dev Throws if the sender is not the owner.
299      */
300     function _checkOwner() internal view virtual {
301         require(owner() == _msgSender(), "Ownable: caller is not the owner");
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         _transferOwnership(address(0));
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Internal function without access restriction.
327      */
328     function _transferOwnership(address newOwner) internal virtual {
329         address oldOwner = _owner;
330         _owner = newOwner;
331         emit OwnershipTransferred(oldOwner, newOwner);
332     }
333 }
334 
335 // File: erc721a/contracts/IERC721A.sol
336 
337 
338 // ERC721A Contracts v4.1.0
339 // Creator: Chiru Labs
340 
341 pragma solidity ^0.8.4;
342 
343 /**
344  * @dev Interface of an ERC721A compliant contract.
345  */
346 interface IERC721A {
347     /**
348      * The caller must own the token or be an approved operator.
349      */
350     error ApprovalCallerNotOwnerNorApproved();
351 
352     /**
353      * The token does not exist.
354      */
355     error ApprovalQueryForNonexistentToken();
356 
357     /**
358      * The caller cannot approve to their own address.
359      */
360     error ApproveToCaller();
361 
362     /**
363      * Cannot query the balance for the zero address.
364      */
365     error BalanceQueryForZeroAddress();
366 
367     /**
368      * Cannot mint to the zero address.
369      */
370     error MintToZeroAddress();
371 
372     /**
373      * The quantity of tokens minted must be more than zero.
374      */
375     error MintZeroQuantity();
376 
377     /**
378      * The token does not exist.
379      */
380     error OwnerQueryForNonexistentToken();
381 
382     /**
383      * The caller must own the token or be an approved operator.
384      */
385     error TransferCallerNotOwnerNorApproved();
386 
387     /**
388      * The token must be owned by `from`.
389      */
390     error TransferFromIncorrectOwner();
391 
392     /**
393      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
394      */
395     error TransferToNonERC721ReceiverImplementer();
396 
397     /**
398      * Cannot transfer to the zero address.
399      */
400     error TransferToZeroAddress();
401 
402     /**
403      * The token does not exist.
404      */
405     error URIQueryForNonexistentToken();
406 
407     /**
408      * The `quantity` minted with ERC2309 exceeds the safety limit.
409      */
410     error MintERC2309QuantityExceedsLimit();
411 
412     /**
413      * The `extraData` cannot be set on an unintialized ownership slot.
414      */
415     error OwnershipNotInitializedForExtraData();
416 
417     struct TokenOwnership {
418         // The address of the owner.
419         address addr;
420         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
421         uint64 startTimestamp;
422         // Whether the token has been burned.
423         bool burned;
424         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
425         uint24 extraData;
426     }
427 
428     /**
429      * @dev Returns the total amount of tokens stored by the contract.
430      *
431      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
432      */
433     function totalSupply() external view returns (uint256);
434 
435     // ==============================
436     //            IERC165
437     // ==============================
438 
439     /**
440      * @dev Returns true if this contract implements the interface defined by
441      * `interfaceId`. See the corresponding
442      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
443      * to learn more about how these ids are created.
444      *
445      * This function call must use less than 30 000 gas.
446      */
447     function supportsInterface(bytes4 interfaceId) external view returns (bool);
448 
449     // ==============================
450     //            IERC721
451     // ==============================
452 
453     /**
454      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
455      */
456     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
460      */
461     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
462 
463     /**
464      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
465      */
466     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
467 
468     /**
469      * @dev Returns the number of tokens in ``owner``'s account.
470      */
471     function balanceOf(address owner) external view returns (uint256 balance);
472 
473     /**
474      * @dev Returns the owner of the `tokenId` token.
475      *
476      * Requirements:
477      *
478      * - `tokenId` must exist.
479      */
480     function ownerOf(uint256 tokenId) external view returns (address owner);
481 
482     /**
483      * @dev Safely transfers `tokenId` token from `from` to `to`.
484      *
485      * Requirements:
486      *
487      * - `from` cannot be the zero address.
488      * - `to` cannot be the zero address.
489      * - `tokenId` token must exist and be owned by `from`.
490      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
491      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
492      *
493      * Emits a {Transfer} event.
494      */
495     function safeTransferFrom(
496         address from,
497         address to,
498         uint256 tokenId,
499         bytes calldata data
500     ) external;
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
504      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
505      *
506      * Requirements:
507      *
508      * - `from` cannot be the zero address.
509      * - `to` cannot be the zero address.
510      * - `tokenId` token must exist and be owned by `from`.
511      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
513      *
514      * Emits a {Transfer} event.
515      */
516     function safeTransferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Transfers `tokenId` token from `from` to `to`.
524      *
525      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
533      *
534      * Emits a {Transfer} event.
535      */
536     function transferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
544      * The approval is cleared when the token is transferred.
545      *
546      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
547      *
548      * Requirements:
549      *
550      * - The caller must own the token or be an approved operator.
551      * - `tokenId` must exist.
552      *
553      * Emits an {Approval} event.
554      */
555     function approve(address to, uint256 tokenId) external;
556 
557     /**
558      * @dev Approve or remove `operator` as an operator for the caller.
559      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
560      *
561      * Requirements:
562      *
563      * - The `operator` cannot be the caller.
564      *
565      * Emits an {ApprovalForAll} event.
566      */
567     function setApprovalForAll(address operator, bool _approved) external;
568 
569     /**
570      * @dev Returns the account approved for `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function getApproved(uint256 tokenId) external view returns (address operator);
577 
578     /**
579      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
580      *
581      * See {setApprovalForAll}
582      */
583     function isApprovedForAll(address owner, address operator) external view returns (bool);
584 
585     // ==============================
586     //        IERC721Metadata
587     // ==============================
588 
589     /**
590      * @dev Returns the token collection name.
591      */
592     function name() external view returns (string memory);
593 
594     /**
595      * @dev Returns the token collection symbol.
596      */
597     function symbol() external view returns (string memory);
598 
599     /**
600      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
601      */
602     function tokenURI(uint256 tokenId) external view returns (string memory);
603 
604     // ==============================
605     //            IERC2309
606     // ==============================
607 
608     /**
609      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
610      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
611      */
612     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
613 }
614 
615 // File: erc721a/contracts/ERC721A.sol
616 
617 
618 // ERC721A Contracts v4.1.0
619 // Creator: Chiru Labs
620 
621 pragma solidity ^0.8.4;
622 
623 
624 /**
625  * @dev ERC721 token receiver interface.
626  */
627 interface ERC721A__IERC721Receiver {
628     function onERC721Received(
629         address operator,
630         address from,
631         uint256 tokenId,
632         bytes calldata data
633     ) external returns (bytes4);
634 }
635 
636 /**
637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
638  * including the Metadata extension. Built to optimize for lower gas during batch mints.
639  *
640  * Assumes serials are sequentially minted starting at `_startTokenId()`
641  * (defaults to 0, e.g. 0, 1, 2, 3..).
642  *
643  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
644  *
645  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
646  */
647 contract ERC721A is IERC721A {
648     // Mask of an entry in packed address data.
649     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
650 
651     // The bit position of `numberMinted` in packed address data.
652     uint256 private constant BITPOS_NUMBER_MINTED = 64;
653 
654     // The bit position of `numberBurned` in packed address data.
655     uint256 private constant BITPOS_NUMBER_BURNED = 128;
656 
657     // The bit position of `aux` in packed address data.
658     uint256 private constant BITPOS_AUX = 192;
659 
660     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
661     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
662 
663     // The bit position of `startTimestamp` in packed ownership.
664     uint256 private constant BITPOS_START_TIMESTAMP = 160;
665 
666     // The bit mask of the `burned` bit in packed ownership.
667     uint256 private constant BITMASK_BURNED = 1 << 224;
668 
669     // The bit position of the `nextInitialized` bit in packed ownership.
670     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
671 
672     // The bit mask of the `nextInitialized` bit in packed ownership.
673     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
674 
675     // The bit position of `extraData` in packed ownership.
676     uint256 private constant BITPOS_EXTRA_DATA = 232;
677 
678     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
679     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
680 
681     // The mask of the lower 160 bits for addresses.
682     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
683 
684     // The maximum `quantity` that can be minted with `_mintERC2309`.
685     // This limit is to prevent overflows on the address data entries.
686     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
687     // is required to cause an overflow, which is unrealistic.
688     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
689 
690     // The tokenId of the next token to be minted.
691     uint256 private _currentIndex;
692 
693     // The number of tokens burned.
694     uint256 private _burnCounter;
695 
696     // Token name
697     string private _name;
698 
699     // Token symbol
700     string private _symbol;
701 
702     // Mapping from token ID to ownership details
703     // An empty struct value does not necessarily mean the token is unowned.
704     // See `_packedOwnershipOf` implementation for details.
705     //
706     // Bits Layout:
707     // - [0..159]   `addr`
708     // - [160..223] `startTimestamp`
709     // - [224]      `burned`
710     // - [225]      `nextInitialized`
711     // - [232..255] `extraData`
712     mapping(uint256 => uint256) private _packedOwnerships;
713 
714     // Mapping owner address to address data.
715     //
716     // Bits Layout:
717     // - [0..63]    `balance`
718     // - [64..127]  `numberMinted`
719     // - [128..191] `numberBurned`
720     // - [192..255] `aux`
721     mapping(address => uint256) private _packedAddressData;
722 
723     // Mapping from token ID to approved address.
724     mapping(uint256 => address) private _tokenApprovals;
725 
726     // Mapping from owner to operator approvals
727     mapping(address => mapping(address => bool)) private _operatorApprovals;
728 
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732         _currentIndex = _startTokenId();
733     }
734 
735     /**
736      * @dev Returns the starting token ID.
737      * To change the starting token ID, please override this function.
738      */
739     function _startTokenId() internal view virtual returns (uint256) {
740         return 0;
741     }
742 
743     /**
744      * @dev Returns the next token ID to be minted.
745      */
746     function _nextTokenId() internal view returns (uint256) {
747         return _currentIndex;
748     }
749 
750     /**
751      * @dev Returns the total number of tokens in existence.
752      * Burned tokens will reduce the count.
753      * To get the total number of tokens minted, please see `_totalMinted`.
754      */
755     function totalSupply() public view override returns (uint256) {
756         // Counter underflow is impossible as _burnCounter cannot be incremented
757         // more than `_currentIndex - _startTokenId()` times.
758         unchecked {
759             return _currentIndex - _burnCounter - _startTokenId();
760         }
761     }
762 
763     /**
764      * @dev Returns the total amount of tokens minted in the contract.
765      */
766     function _totalMinted() internal view returns (uint256) {
767         // Counter underflow is impossible as _currentIndex does not decrement,
768         // and it is initialized to `_startTokenId()`
769         unchecked {
770             return _currentIndex - _startTokenId();
771         }
772     }
773 
774     /**
775      * @dev Returns the total number of tokens burned.
776      */
777     function _totalBurned() internal view returns (uint256) {
778         return _burnCounter;
779     }
780 
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
785         // The interface IDs are constants representing the first 4 bytes of the XOR of
786         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
787         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
788         return
789             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
790             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
791             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
792     }
793 
794     /**
795      * @dev See {IERC721-balanceOf}.
796      */
797     function balanceOf(address owner) public view override returns (uint256) {
798         if (owner == address(0)) revert BalanceQueryForZeroAddress();
799         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
800     }
801 
802     /**
803      * Returns the number of tokens minted by `owner`.
804      */
805     function _numberMinted(address owner) internal view returns (uint256) {
806         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
807     }
808 
809     /**
810      * Returns the number of tokens burned by or on behalf of `owner`.
811      */
812     function _numberBurned(address owner) internal view returns (uint256) {
813         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
814     }
815 
816     /**
817      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
818      */
819     function _getAux(address owner) internal view returns (uint64) {
820         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
821     }
822 
823     /**
824      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
825      * If there are multiple variables, please pack them into a uint64.
826      */
827     function _setAux(address owner, uint64 aux) internal {
828         uint256 packed = _packedAddressData[owner];
829         uint256 auxCasted;
830         // Cast `aux` with assembly to avoid redundant masking.
831         assembly {
832             auxCasted := aux
833         }
834         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
835         _packedAddressData[owner] = packed;
836     }
837 
838     /**
839      * Returns the packed ownership data of `tokenId`.
840      */
841     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
842         uint256 curr = tokenId;
843 
844         unchecked {
845             if (_startTokenId() <= curr)
846                 if (curr < _currentIndex) {
847                     uint256 packed = _packedOwnerships[curr];
848                     // If not burned.
849                     if (packed & BITMASK_BURNED == 0) {
850                         // Invariant:
851                         // There will always be an ownership that has an address and is not burned
852                         // before an ownership that does not have an address and is not burned.
853                         // Hence, curr will not underflow.
854                         //
855                         // We can directly compare the packed value.
856                         // If the address is zero, packed is zero.
857                         while (packed == 0) {
858                             packed = _packedOwnerships[--curr];
859                         }
860                         return packed;
861                     }
862                 }
863         }
864         revert OwnerQueryForNonexistentToken();
865     }
866 
867     /**
868      * Returns the unpacked `TokenOwnership` struct from `packed`.
869      */
870     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
871         ownership.addr = address(uint160(packed));
872         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
873         ownership.burned = packed & BITMASK_BURNED != 0;
874         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
875     }
876 
877     /**
878      * Returns the unpacked `TokenOwnership` struct at `index`.
879      */
880     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
881         return _unpackedOwnership(_packedOwnerships[index]);
882     }
883 
884     /**
885      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
886      */
887     function _initializeOwnershipAt(uint256 index) internal {
888         if (_packedOwnerships[index] == 0) {
889             _packedOwnerships[index] = _packedOwnershipOf(index);
890         }
891     }
892 
893     /**
894      * Gas spent here starts off proportional to the maximum mint batch size.
895      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
896      */
897     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
898         return _unpackedOwnership(_packedOwnershipOf(tokenId));
899     }
900 
901     /**
902      * @dev Packs ownership data into a single uint256.
903      */
904     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
905         assembly {
906             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
907             owner := and(owner, BITMASK_ADDRESS)
908             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
909             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
910         }
911     }
912 
913     /**
914      * @dev See {IERC721-ownerOf}.
915      */
916     function ownerOf(uint256 tokenId) public view override returns (address) {
917         return address(uint160(_packedOwnershipOf(tokenId)));
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-name}.
922      */
923     function name() public view virtual override returns (string memory) {
924         return _name;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-symbol}.
929      */
930     function symbol() public view virtual override returns (string memory) {
931         return _symbol;
932     }
933 
934     /**
935      * @dev See {IERC721Metadata-tokenURI}.
936      */
937     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
938         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
939 
940         string memory baseURI = _baseURI();
941         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
942     }
943 
944     /**
945      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
946      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
947      * by default, it can be overridden in child contracts.
948      */
949     function _baseURI() internal view virtual returns (string memory) {
950         return '';
951     }
952 
953     /**
954      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
955      */
956     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
957         // For branchless setting of the `nextInitialized` flag.
958         assembly {
959             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
960             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
961         }
962     }
963 
964     /**
965      * @dev See {IERC721-approve}.
966      */
967     function approve(address to, uint256 tokenId) public override {
968         address owner = ownerOf(tokenId);
969 
970         if (_msgSenderERC721A() != owner)
971             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
972                 revert ApprovalCallerNotOwnerNorApproved();
973             }
974 
975         _tokenApprovals[tokenId] = to;
976         emit Approval(owner, to, tokenId);
977     }
978 
979     /**
980      * @dev See {IERC721-getApproved}.
981      */
982     function getApproved(uint256 tokenId) public view override returns (address) {
983         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
984 
985         return _tokenApprovals[tokenId];
986     }
987 
988     /**
989      * @dev See {IERC721-setApprovalForAll}.
990      */
991     function setApprovalForAll(address operator, bool approved) public virtual override {
992         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
993 
994         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
995         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
996     }
997 
998     /**
999      * @dev See {IERC721-isApprovedForAll}.
1000      */
1001     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1002         return _operatorApprovals[owner][operator];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, '');
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         transferFrom(from, to, tokenId);
1026         if (to.code.length != 0)
1027             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1028                 revert TransferToNonERC721ReceiverImplementer();
1029             }
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted (`_mint`),
1038      */
1039     function _exists(uint256 tokenId) internal view returns (bool) {
1040         return
1041             _startTokenId() <= tokenId &&
1042             tokenId < _currentIndex && // If within bounds,
1043             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1044     }
1045 
1046     /**
1047      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1048      */
1049     function _safeMint(address to, uint256 quantity) internal {
1050         _safeMint(to, quantity, '');
1051     }
1052 
1053     /**
1054      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - If `to` refers to a smart contract, it must implement
1059      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * See {_mint}.
1063      *
1064      * Emits a {Transfer} event for each mint.
1065      */
1066     function _safeMint(
1067         address to,
1068         uint256 quantity,
1069         bytes memory _data
1070     ) internal {
1071         _mint(to, quantity);
1072 
1073         unchecked {
1074             if (to.code.length != 0) {
1075                 uint256 end = _currentIndex;
1076                 uint256 index = end - quantity;
1077                 do {
1078                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1079                         revert TransferToNonERC721ReceiverImplementer();
1080                     }
1081                 } while (index < end);
1082                 // Reentrancy protection.
1083                 if (_currentIndex != end) revert();
1084             }
1085         }
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event for each mint.
1097      */
1098     function _mint(address to, uint256 quantity) internal {
1099         uint256 startTokenId = _currentIndex;
1100         if (to == address(0)) revert MintToZeroAddress();
1101         if (quantity == 0) revert MintZeroQuantity();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // `balance` and `numberMinted` have a maximum limit of 2**64.
1107         // `tokenId` has a maximum limit of 2**256.
1108         unchecked {
1109             // Updates:
1110             // - `balance += quantity`.
1111             // - `numberMinted += quantity`.
1112             //
1113             // We can directly add to the `balance` and `numberMinted`.
1114             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1115 
1116             // Updates:
1117             // - `address` to the owner.
1118             // - `startTimestamp` to the timestamp of minting.
1119             // - `burned` to `false`.
1120             // - `nextInitialized` to `quantity == 1`.
1121             _packedOwnerships[startTokenId] = _packOwnershipData(
1122                 to,
1123                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1124             );
1125 
1126             uint256 tokenId = startTokenId;
1127             uint256 end = startTokenId + quantity;
1128             do {
1129                 emit Transfer(address(0), to, tokenId++);
1130             } while (tokenId < end);
1131 
1132             _currentIndex = end;
1133         }
1134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135     }
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * This function is intended for efficient minting only during contract creation.
1141      *
1142      * It emits only one {ConsecutiveTransfer} as defined in
1143      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1144      * instead of a sequence of {Transfer} event(s).
1145      *
1146      * Calling this function outside of contract creation WILL make your contract
1147      * non-compliant with the ERC721 standard.
1148      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1149      * {ConsecutiveTransfer} event is only permissible during contract creation.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `quantity` must be greater than 0.
1155      *
1156      * Emits a {ConsecutiveTransfer} event.
1157      */
1158     function _mintERC2309(address to, uint256 quantity) internal {
1159         uint256 startTokenId = _currentIndex;
1160         if (to == address(0)) revert MintToZeroAddress();
1161         if (quantity == 0) revert MintZeroQuantity();
1162         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1163 
1164         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1167         unchecked {
1168             // Updates:
1169             // - `balance += quantity`.
1170             // - `numberMinted += quantity`.
1171             //
1172             // We can directly add to the `balance` and `numberMinted`.
1173             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1174 
1175             // Updates:
1176             // - `address` to the owner.
1177             // - `startTimestamp` to the timestamp of minting.
1178             // - `burned` to `false`.
1179             // - `nextInitialized` to `quantity == 1`.
1180             _packedOwnerships[startTokenId] = _packOwnershipData(
1181                 to,
1182                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1183             );
1184 
1185             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1186 
1187             _currentIndex = startTokenId + quantity;
1188         }
1189         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1190     }
1191 
1192     /**
1193      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1194      */
1195     function _getApprovedAddress(uint256 tokenId)
1196         private
1197         view
1198         returns (uint256 approvedAddressSlot, address approvedAddress)
1199     {
1200         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1201         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1202         assembly {
1203             // Compute the slot.
1204             mstore(0x00, tokenId)
1205             mstore(0x20, tokenApprovalsPtr.slot)
1206             approvedAddressSlot := keccak256(0x00, 0x40)
1207             // Load the slot's value from storage.
1208             approvedAddress := sload(approvedAddressSlot)
1209         }
1210     }
1211 
1212     /**
1213      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1214      */
1215     function _isOwnerOrApproved(
1216         address approvedAddress,
1217         address from,
1218         address msgSender
1219     ) private pure returns (bool result) {
1220         assembly {
1221             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1222             from := and(from, BITMASK_ADDRESS)
1223             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1224             msgSender := and(msgSender, BITMASK_ADDRESS)
1225             // `msgSender == from || msgSender == approvedAddress`.
1226             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1227         }
1228     }
1229 
1230     /**
1231      * @dev Transfers `tokenId` from `from` to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `tokenId` token must be owned by `from`.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function transferFrom(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) public virtual override {
1245         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1246 
1247         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1248 
1249         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1250 
1251         // The nested ifs save around 20+ gas over a compound boolean condition.
1252         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1253             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1254 
1255         if (to == address(0)) revert TransferToZeroAddress();
1256 
1257         _beforeTokenTransfers(from, to, tokenId, 1);
1258 
1259         // Clear approvals from the previous owner.
1260         assembly {
1261             if approvedAddress {
1262                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1263                 sstore(approvedAddressSlot, 0)
1264             }
1265         }
1266 
1267         // Underflow of the sender's balance is impossible because we check for
1268         // ownership above and the recipient's balance can't realistically overflow.
1269         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1270         unchecked {
1271             // We can directly increment and decrement the balances.
1272             --_packedAddressData[from]; // Updates: `balance -= 1`.
1273             ++_packedAddressData[to]; // Updates: `balance += 1`.
1274 
1275             // Updates:
1276             // - `address` to the next owner.
1277             // - `startTimestamp` to the timestamp of transfering.
1278             // - `burned` to `false`.
1279             // - `nextInitialized` to `true`.
1280             _packedOwnerships[tokenId] = _packOwnershipData(
1281                 to,
1282                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1283             );
1284 
1285             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1286             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1287                 uint256 nextTokenId = tokenId + 1;
1288                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1289                 if (_packedOwnerships[nextTokenId] == 0) {
1290                     // If the next slot is within bounds.
1291                     if (nextTokenId != _currentIndex) {
1292                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1293                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1294                     }
1295                 }
1296             }
1297         }
1298 
1299         emit Transfer(from, to, tokenId);
1300         _afterTokenTransfers(from, to, tokenId, 1);
1301     }
1302 
1303     /**
1304      * @dev Equivalent to `_burn(tokenId, false)`.
1305      */
1306     function _burn(uint256 tokenId) internal virtual {
1307         _burn(tokenId, false);
1308     }
1309 
1310     /**
1311      * @dev Destroys `tokenId`.
1312      * The approval is cleared when the token is burned.
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must exist.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1321         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1322 
1323         address from = address(uint160(prevOwnershipPacked));
1324 
1325         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1326 
1327         if (approvalCheck) {
1328             // The nested ifs save around 20+ gas over a compound boolean condition.
1329             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1330                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1331         }
1332 
1333         _beforeTokenTransfers(from, address(0), tokenId, 1);
1334 
1335         // Clear approvals from the previous owner.
1336         assembly {
1337             if approvedAddress {
1338                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1339                 sstore(approvedAddressSlot, 0)
1340             }
1341         }
1342 
1343         // Underflow of the sender's balance is impossible because we check for
1344         // ownership above and the recipient's balance can't realistically overflow.
1345         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1346         unchecked {
1347             // Updates:
1348             // - `balance -= 1`.
1349             // - `numberBurned += 1`.
1350             //
1351             // We can directly decrement the balance, and increment the number burned.
1352             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1353             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1354 
1355             // Updates:
1356             // - `address` to the last owner.
1357             // - `startTimestamp` to the timestamp of burning.
1358             // - `burned` to `true`.
1359             // - `nextInitialized` to `true`.
1360             _packedOwnerships[tokenId] = _packOwnershipData(
1361                 from,
1362                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1363             );
1364 
1365             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1366             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1367                 uint256 nextTokenId = tokenId + 1;
1368                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1369                 if (_packedOwnerships[nextTokenId] == 0) {
1370                     // If the next slot is within bounds.
1371                     if (nextTokenId != _currentIndex) {
1372                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1373                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1374                     }
1375                 }
1376             }
1377         }
1378 
1379         emit Transfer(from, address(0), tokenId);
1380         _afterTokenTransfers(from, address(0), tokenId, 1);
1381 
1382         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1383         unchecked {
1384             _burnCounter++;
1385         }
1386     }
1387 
1388     /**
1389      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1390      *
1391      * @param from address representing the previous owner of the given token ID
1392      * @param to target address that will receive the tokens
1393      * @param tokenId uint256 ID of the token to be transferred
1394      * @param _data bytes optional data to send along with the call
1395      * @return bool whether the call correctly returned the expected magic value
1396      */
1397     function _checkContractOnERC721Received(
1398         address from,
1399         address to,
1400         uint256 tokenId,
1401         bytes memory _data
1402     ) private returns (bool) {
1403         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1404             bytes4 retval
1405         ) {
1406             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1407         } catch (bytes memory reason) {
1408             if (reason.length == 0) {
1409                 revert TransferToNonERC721ReceiverImplementer();
1410             } else {
1411                 assembly {
1412                     revert(add(32, reason), mload(reason))
1413                 }
1414             }
1415         }
1416     }
1417 
1418     /**
1419      * @dev Directly sets the extra data for the ownership data `index`.
1420      */
1421     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1422         uint256 packed = _packedOwnerships[index];
1423         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1424         uint256 extraDataCasted;
1425         // Cast `extraData` with assembly to avoid redundant masking.
1426         assembly {
1427             extraDataCasted := extraData
1428         }
1429         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1430         _packedOwnerships[index] = packed;
1431     }
1432 
1433     /**
1434      * @dev Returns the next extra data for the packed ownership data.
1435      * The returned result is shifted into position.
1436      */
1437     function _nextExtraData(
1438         address from,
1439         address to,
1440         uint256 prevOwnershipPacked
1441     ) private view returns (uint256) {
1442         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1443         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1444     }
1445 
1446     /**
1447      * @dev Called during each token transfer to set the 24bit `extraData` field.
1448      * Intended to be overridden by the cosumer contract.
1449      *
1450      * `previousExtraData` - the value of `extraData` before transfer.
1451      *
1452      * Calling conditions:
1453      *
1454      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1455      * transferred to `to`.
1456      * - When `from` is zero, `tokenId` will be minted for `to`.
1457      * - When `to` is zero, `tokenId` will be burned by `from`.
1458      * - `from` and `to` are never both zero.
1459      */
1460     function _extraData(
1461         address from,
1462         address to,
1463         uint24 previousExtraData
1464     ) internal view virtual returns (uint24) {}
1465 
1466     /**
1467      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1468      * This includes minting.
1469      * And also called before burning one token.
1470      *
1471      * startTokenId - the first token id to be transferred
1472      * quantity - the amount to be transferred
1473      *
1474      * Calling conditions:
1475      *
1476      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1477      * transferred to `to`.
1478      * - When `from` is zero, `tokenId` will be minted for `to`.
1479      * - When `to` is zero, `tokenId` will be burned by `from`.
1480      * - `from` and `to` are never both zero.
1481      */
1482     function _beforeTokenTransfers(
1483         address from,
1484         address to,
1485         uint256 startTokenId,
1486         uint256 quantity
1487     ) internal virtual {}
1488 
1489     /**
1490      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1491      * This includes minting.
1492      * And also called after one token has been burned.
1493      *
1494      * startTokenId - the first token id to be transferred
1495      * quantity - the amount to be transferred
1496      *
1497      * Calling conditions:
1498      *
1499      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1500      * transferred to `to`.
1501      * - When `from` is zero, `tokenId` has been minted for `to`.
1502      * - When `to` is zero, `tokenId` has been burned by `from`.
1503      * - `from` and `to` are never both zero.
1504      */
1505     function _afterTokenTransfers(
1506         address from,
1507         address to,
1508         uint256 startTokenId,
1509         uint256 quantity
1510     ) internal virtual {}
1511 
1512     /**
1513      * @dev Returns the message sender (defaults to `msg.sender`).
1514      *
1515      * If you are writing GSN compatible contracts, you need to override this function.
1516      */
1517     function _msgSenderERC721A() internal view virtual returns (address) {
1518         return msg.sender;
1519     }
1520 
1521     /**
1522      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1523      */
1524     function _toString(uint256 value) internal pure returns (string memory ptr) {
1525         assembly {
1526             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1527             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1528             // We will need 1 32-byte word to store the length,
1529             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1530             ptr := add(mload(0x40), 128)
1531             // Update the free memory pointer to allocate.
1532             mstore(0x40, ptr)
1533 
1534             // Cache the end of the memory to calculate the length later.
1535             let end := ptr
1536 
1537             // We write the string from the rightmost digit to the leftmost digit.
1538             // The following is essentially a do-while loop that also handles the zero case.
1539             // Costs a bit more than early returning for the zero case,
1540             // but cheaper in terms of deployment and overall runtime costs.
1541             for {
1542                 // Initialize and perform the first pass without check.
1543                 let temp := value
1544                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1545                 ptr := sub(ptr, 1)
1546                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1547                 mstore8(ptr, add(48, mod(temp, 10)))
1548                 temp := div(temp, 10)
1549             } temp {
1550                 // Keep dividing `temp` until zero.
1551                 temp := div(temp, 10)
1552             } {
1553                 // Body of the for loop.
1554                 ptr := sub(ptr, 1)
1555                 mstore8(ptr, add(48, mod(temp, 10)))
1556             }
1557 
1558             let length := sub(end, ptr)
1559             // Move the pointer 32 bytes leftwards to make room for the length.
1560             ptr := sub(ptr, 32)
1561             // Store the length.
1562             mstore(ptr, length)
1563         }
1564     }
1565 }
1566 
1567 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1568 
1569 
1570 // ERC721A Contracts v4.1.0
1571 // Creator: Chiru Labs
1572 
1573 pragma solidity ^0.8.4;
1574 
1575 
1576 /**
1577  * @dev Interface of an ERC721AQueryable compliant contract.
1578  */
1579 interface IERC721AQueryable is IERC721A {
1580     /**
1581      * Invalid query range (`start` >= `stop`).
1582      */
1583     error InvalidQueryRange();
1584 
1585     /**
1586      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1587      *
1588      * If the `tokenId` is out of bounds:
1589      *   - `addr` = `address(0)`
1590      *   - `startTimestamp` = `0`
1591      *   - `burned` = `false`
1592      *
1593      * If the `tokenId` is burned:
1594      *   - `addr` = `<Address of owner before token was burned>`
1595      *   - `startTimestamp` = `<Timestamp when token was burned>`
1596      *   - `burned = `true`
1597      *
1598      * Otherwise:
1599      *   - `addr` = `<Address of owner>`
1600      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1601      *   - `burned = `false`
1602      */
1603     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1604 
1605     /**
1606      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1607      * See {ERC721AQueryable-explicitOwnershipOf}
1608      */
1609     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1610 
1611     /**
1612      * @dev Returns an array of token IDs owned by `owner`,
1613      * in the range [`start`, `stop`)
1614      * (i.e. `start <= tokenId < stop`).
1615      *
1616      * This function allows for tokens to be queried if the collection
1617      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1618      *
1619      * Requirements:
1620      *
1621      * - `start` < `stop`
1622      */
1623     function tokensOfOwnerIn(
1624         address owner,
1625         uint256 start,
1626         uint256 stop
1627     ) external view returns (uint256[] memory);
1628 
1629     /**
1630      * @dev Returns an array of token IDs owned by `owner`.
1631      *
1632      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1633      * It is meant to be called off-chain.
1634      *
1635      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1636      * multiple smaller scans if the collection is large enough to cause
1637      * an out-of-gas error (10K pfp collections should be fine).
1638      */
1639     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1640 }
1641 
1642 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1643 
1644 
1645 // ERC721A Contracts v4.1.0
1646 // Creator: Chiru Labs
1647 
1648 pragma solidity ^0.8.4;
1649 
1650 
1651 
1652 /**
1653  * @title ERC721A Queryable
1654  * @dev ERC721A subclass with convenience query functions.
1655  */
1656 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1657     /**
1658      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1659      *
1660      * If the `tokenId` is out of bounds:
1661      *   - `addr` = `address(0)`
1662      *   - `startTimestamp` = `0`
1663      *   - `burned` = `false`
1664      *   - `extraData` = `0`
1665      *
1666      * If the `tokenId` is burned:
1667      *   - `addr` = `<Address of owner before token was burned>`
1668      *   - `startTimestamp` = `<Timestamp when token was burned>`
1669      *   - `burned = `true`
1670      *   - `extraData` = `<Extra data when token was burned>`
1671      *
1672      * Otherwise:
1673      *   - `addr` = `<Address of owner>`
1674      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1675      *   - `burned = `false`
1676      *   - `extraData` = `<Extra data at start of ownership>`
1677      */
1678     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1679         TokenOwnership memory ownership;
1680         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1681             return ownership;
1682         }
1683         ownership = _ownershipAt(tokenId);
1684         if (ownership.burned) {
1685             return ownership;
1686         }
1687         return _ownershipOf(tokenId);
1688     }
1689 
1690     /**
1691      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1692      * See {ERC721AQueryable-explicitOwnershipOf}
1693      */
1694     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1695         unchecked {
1696             uint256 tokenIdsLength = tokenIds.length;
1697             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1698             for (uint256 i; i != tokenIdsLength; ++i) {
1699                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1700             }
1701             return ownerships;
1702         }
1703     }
1704 
1705     /**
1706      * @dev Returns an array of token IDs owned by `owner`,
1707      * in the range [`start`, `stop`)
1708      * (i.e. `start <= tokenId < stop`).
1709      *
1710      * This function allows for tokens to be queried if the collection
1711      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1712      *
1713      * Requirements:
1714      *
1715      * - `start` < `stop`
1716      */
1717     function tokensOfOwnerIn(
1718         address owner,
1719         uint256 start,
1720         uint256 stop
1721     ) external view override returns (uint256[] memory) {
1722         unchecked {
1723             if (start >= stop) revert InvalidQueryRange();
1724             uint256 tokenIdsIdx;
1725             uint256 stopLimit = _nextTokenId();
1726             // Set `start = max(start, _startTokenId())`.
1727             if (start < _startTokenId()) {
1728                 start = _startTokenId();
1729             }
1730             // Set `stop = min(stop, stopLimit)`.
1731             if (stop > stopLimit) {
1732                 stop = stopLimit;
1733             }
1734             uint256 tokenIdsMaxLength = balanceOf(owner);
1735             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1736             // to cater for cases where `balanceOf(owner)` is too big.
1737             if (start < stop) {
1738                 uint256 rangeLength = stop - start;
1739                 if (rangeLength < tokenIdsMaxLength) {
1740                     tokenIdsMaxLength = rangeLength;
1741                 }
1742             } else {
1743                 tokenIdsMaxLength = 0;
1744             }
1745             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1746             if (tokenIdsMaxLength == 0) {
1747                 return tokenIds;
1748             }
1749             // We need to call `explicitOwnershipOf(start)`,
1750             // because the slot at `start` may not be initialized.
1751             TokenOwnership memory ownership = explicitOwnershipOf(start);
1752             address currOwnershipAddr;
1753             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1754             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1755             if (!ownership.burned) {
1756                 currOwnershipAddr = ownership.addr;
1757             }
1758             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1759                 ownership = _ownershipAt(i);
1760                 if (ownership.burned) {
1761                     continue;
1762                 }
1763                 if (ownership.addr != address(0)) {
1764                     currOwnershipAddr = ownership.addr;
1765                 }
1766                 if (currOwnershipAddr == owner) {
1767                     tokenIds[tokenIdsIdx++] = i;
1768                 }
1769             }
1770             // Downsize the array to fit.
1771             assembly {
1772                 mstore(tokenIds, tokenIdsIdx)
1773             }
1774             return tokenIds;
1775         }
1776     }
1777 
1778     /**
1779      * @dev Returns an array of token IDs owned by `owner`.
1780      *
1781      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1782      * It is meant to be called off-chain.
1783      *
1784      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1785      * multiple smaller scans if the collection is large enough to cause
1786      * an out-of-gas error (10K pfp collections should be fine).
1787      */
1788     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1789         unchecked {
1790             uint256 tokenIdsIdx;
1791             address currOwnershipAddr;
1792             uint256 tokenIdsLength = balanceOf(owner);
1793             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1794             TokenOwnership memory ownership;
1795             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1796                 ownership = _ownershipAt(i);
1797                 if (ownership.burned) {
1798                     continue;
1799                 }
1800                 if (ownership.addr != address(0)) {
1801                     currOwnershipAddr = ownership.addr;
1802                 }
1803                 if (currOwnershipAddr == owner) {
1804                     tokenIds[tokenIdsIdx++] = i;
1805                 }
1806             }
1807             return tokenIds;
1808         }
1809     }
1810 }
1811 
1812 
1813 pragma solidity >=0.8.9 <0.9.0;
1814 
1815 contract DeQuaads is ERC721AQueryable, Ownable, ReentrancyGuard {
1816     using Strings for uint256;
1817     uint256 public maxDeQuaads = 2001;
1818 	uint256 public lordsMint = 2;
1819     uint256 public maxDeQuaadsPerAddress = 10;
1820 	uint256 public maxDeQuaadsPerTX = 3;
1821     uint256 public deQuaadCost = 0.002 ether;
1822 	mapping(address => bool) public freeMinted; 
1823 
1824     bool public paused = true;
1825 
1826 	string public DeQuaadPrefix = '';
1827     string public deQuaadSuffix = '.json';
1828 	
1829   constructor(string memory baseURI) ERC721A("DeQuaads", "DQUDS") {
1830       setDeQuaadPrefix(baseURI); 
1831       _safeMint(_msgSender(), lordsMint);
1832   }
1833 
1834   modifier callerIsUser() {
1835         require(tx.origin == msg.sender, "Sneaky guy");
1836         _;
1837   }
1838 
1839   function numberDeQuaadsMinted(address owner) public view returns (uint256) {
1840         return _numberMinted(owner);
1841   }
1842 
1843   function mintDeQuaad(uint256 _mintAmount) public payable nonReentrant callerIsUser{
1844         require(!paused, 'The contract is paused!');
1845         require(numberDeQuaadsMinted(msg.sender) + _mintAmount <= maxDeQuaadsPerAddress, 'Your account can not stand anymore DeQuaads');
1846         require(_mintAmount > 0 && _mintAmount <= maxDeQuaadsPerTX, 'Invalid DeQuaad amount!');
1847         require(totalSupply() + _mintAmount <= (maxDeQuaads), 'Max DeQuaads exceeded!');
1848 	if (freeMinted[_msgSender()]){
1849         require(msg.value >= deQuaadCost * _mintAmount, 'Your to poor');
1850   }
1851     else{
1852 		require(msg.value >= deQuaadCost * _mintAmount - deQuaadCost, 'Your to poor');
1853         freeMinted[_msgSender()] = true;
1854   }
1855 
1856     _safeMint(_msgSender(), _mintAmount);
1857   }
1858 
1859   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1860     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1861     string memory currentBaseURI = _baseURI();
1862     return bytes(currentBaseURI).length > 0
1863         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), deQuaadSuffix))
1864         : '';
1865   }
1866 
1867   function setPaused() public onlyOwner {
1868     paused = !paused;
1869   }
1870 
1871   function setdeQuaadCost(uint256 _deQuaadCost) public onlyOwner {
1872     deQuaadCost = _deQuaadCost;
1873   }
1874   
1875   function setDeQuaadPrefix(string memory _DeQuaadPrefix) public onlyOwner {
1876     DeQuaadPrefix = _DeQuaadPrefix;
1877   }
1878 
1879   function withdraw() external onlyOwner {
1880         payable(msg.sender).transfer(address(this).balance);
1881   }
1882 
1883   function _startTokenId() internal view virtual override returns (uint256) {
1884     return 1;
1885   }
1886 
1887   function _baseURI() internal view virtual override returns (string memory) {
1888     return DeQuaadPrefix;
1889   }
1890 }