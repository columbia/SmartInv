1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // File: base64-sol/base64.sol
3 /**
4 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNX0kkkkkkkkkOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKko:,.. ......  ..':lkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKxo:,''',,,;;;;;;;;,,'....':d0WMMMMMMMMMMMMMWNKOkkxdooodxkOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXko:,,,;:ccccccccccccccccccc::;,';lxKXNMMMMWXOdl;,,''',,,,,,''';:lx0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOl,',;:cccccccccccccccccccc::::;;;;;,,'';oxxo:,'.',;::cccccccccccc:;,;coxKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk;..;:cccccccccc:::;,''''''.........           .;:cccccccccccccccc:::;,'.  .,lx0NWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk;..;:cccccccc:;,'......''',,,,,,,,'''''............',;:cccccccc:;,'....         .,cdOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc..;:ccccccc:;'...',;::cccccccccccccccccccccccc:::;,''...',::ccc:;,,,,,,,,,;;;,,,,,''',;:ldOXWMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMWk,.,:cccccc::,,,,;:ccccccccccccccccc:::;;;,,,,'',,,,,''...   ..,;:ccccccccccccccccc::;;,,..  ..;lx0NMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMXo..;cccccccc::;:ccccccccccccccc:;,''.....''''',,,,,;;;;;,,,,''.....';:ccccc::;,,'''''..............';lxKNMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMKc.':ccccccccccccccccccccccc::,'....'',;;;;;,,;;;::cllooollllc;;;;;,'....,,'....'',,,;;;;;;;;;;;;;;;;;;,,:ldkXWMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMK:.':cccccccccccccccccccc:;,''..',;::;;,,;:clodkO00KXXNNNNNNXXKkdl:....   ..',,;;,,,,,;:::cccccc::::;,''.',;;;lkNMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMWo.':ccccccccccccccccccccc:,,,;::;,,,:cox0KNWWMMMMMMMMMMMWWMMMMMMMMNKd;.  ..'';:lodxO0KXNNWWWWWWWWWWNNK0Oxoc;'...lNMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMM0,.;ccccccccccccccccccccc::;;,''';cdOXWMMMMMMMMMMMMMWKkoc::clxKWMMMMMMNO:.  .l0NWMMMMMMMMMMMMNOdlcccdONMMMMMN0d;..kWMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMx.':ccccccccccccccccc:;,,:::clox0NWMMMMMMMMMMMMMMNko:.        .cKMMMMMMMNd. ;KMMMMMMMMMMMMMWO;.      .:0WMMMMMMNx'lNMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMM0;.;cccccccccccccccccc;..oXNWWMMMMMMMMMMMMMMMMMMMKc.             ;KMMMMMMMWx..OMMMMMMMMMMMMNd.          .dNMMMMMMWd:0MMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMWk, .:cccccccccccccccccc:'.,cdOXWMMMMMMMMMMMMMMMMMX:        .,'.   .xWMMMMMMMNl.dWMMMMMMMMMMMk.            .xWMMMMMM0ckMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMXo...,:ccccccccccccccccccc::;,'.,l0WMMMMMMMMMMMMMMMx.       ;0NN0:. .dWMMMMMMMMx.cNMMMMMMMMMMWl      ,dkx:. .dWMMMMMMKcxWMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMNk;',;::ccccccccccccccccccccccccc:,.'c0WMMMMMMMMMMMMWd.       :XMNk;  .xWMMMMMMMMx.,KMMMMMMMMMMWd.    .lKKOc. ;KMMMMMMM0;oWMMMMMMMMM
24 MMMMMMMMMMMMMMMMW0l;;:cccccccccccccccccccccccccccc::::;''l0WMMMMMMMMMMMO'       .;c;.   :KMMMMMMMMNl .oXMMMMMMMMMMXl.    ....  ,0WMMMMMMWx;kMMMMMMMMMM
25 MMMMMMMMMMMMMMMXd,,:cccccccccccccccccccccccccccccc:'.,::;',lONMMMMMMMMMWk,           .'oKMMMMMMMMWx.  .,o0NMMMMMMMMNOl,.......cKWMMMMMMM0ldNMMMMMMMMMM
26 MMMMMMMMMMMMMW0c';ccccccccccccccccccccccccccccccccc:,..,::;'.;oONWMMMMMMMXxoc,''',:ldOXWMMMMMMMMXd. .','',:ldOKNWMMMMWNXKK000XWMMMMMMWXx:dNMMMMMMMMMMM
27 MMMMMMMMMMMMM0;':cccccccccccccccccccccccccccccccccccc:,...,::,.',cdOKNWMMMMMWNNXNWWMMMMMMMMMMWKd,..  .,:c:;,'',;:cldxxkOO00KKKKKK0Oxo:..cNMMMMMMMMMMMM
28 MMMMMMMMMMMM0;.;ccccccccccccccccccccccccccccccccccccccc:;'..',;:;'''';:codkO0KXNNWWWWNNXX0kdl;.  .;;'...,::;,,,,,,,,,'''''''''''''''''';0MMMMMMMMMMMMM
29 MMMMMMMMMMMNc.,ccccccccccccccccccccccccccccccccccccccccccc:;,'''',;;:;,,'''',,;;ccllcc::;;''''..':ccc:,...';;;,,'''''''''''''',,,''';cxKWMMMMMMMMMMMMM
30 MMMMMMMMMMMO'.:ccccccccccccccccccccccccccccccccc:;'',::ccccccc::,''...',,;;:::::::::::::;;,'''';:cccccc:;'...,:ccc::;,,'...      .;oONWMMMMMMMMMMMMMMM
31 MMMMMMMMMMWo.':cccccccccccccccccccccccccccccccccc:,.....',;;::ccccc:;,''...................',:cccccccccccc;.. ..,;;::;;,''.      :KMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMWl.,cccccccccccccccccccccccccccccccccccccc:;,'.......'',,;;;;::;;,,,'..    ...,;:cccccccccccccccc:;.    ................:0WMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMX:.;cccccccccccccccccccc::cccccccccccccccccccc:::;,,'...................',;::cccccccccccccccccccccc:,. ..',;:::::cccccc:,,dNMMMMMMMMMMMMMMMM
34 MMMMMMMMMMO'.:cccccccccccccccccc:,,:cccc:::cccccccccccccccccccccc:::::;;;;;;;:::ccccccccccccccccccccccccccccccc;..,:ccccccccccccccc;'c0WMMMMMMMMMMMMMM
35 MMMMMMMMMMk.':cccccccccccccccc:,..;cc:,'....',;::ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc:,,:cccccccccccccccc:.'dNMMMMMMMMMMMMM
36 MMMMMMMMMMx.'cccccccccccccccc:'.,:c:,..',,,,''...'',;::cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc, .cKWMMMMMMMMMMM
37 MMMMMMMMMWd.,cccccccccccccccc;,;cc:..,:::::::::;;,''....'',;::cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc:;'....:0MMMMMMMMMMM
38 MMMMMMMMMNl.,cccccccccccccccccccc:'.'::::::::::::::::;;,''.....'',;;::cccccccccccccccccccccccccccccccccccccccccccccccccccccccc:;,'...';:,.dWMMMMMMMMMM
39 MMMMMMMMMNl.;cccccccccccccccccccc:..,::::::;,,;;::::::::::::;;,''......'',,;;;::cccccccccccccccccccccccccccccccccccccc:::;,,'''..',;:::::dXMMMMMMMMMMM
40 MMMMMMMMMWo.;cccccccccccccccccccc:,.';:::::'. ....'',;::::::::::::::;;,,''''''''''',,,;;;::::::::::::::::::::;;;,,,'''''.''',,;:::::;;cdKWMMMMMMMMMMMM
41 MMMMMMMMMWo.;ccccccccccccccccccccc:,..;::::,...........'',,;;::::::::::::::::::;;,,''''''''''''''''''''''''..''''''',,;;::::::;,,',:lxKWMMMMMMMMMMMMMM
42 MMMMMMMMMWd.,ccccccccccccccccccccccc;'.';:::;'...',,'''........'',,;;:::::::::::::::::::::::;;;;;;;;;;;;;;;:::::::::::;;;,''....cx0XWMMMMMMMMMMMMMMMMM
43 MMMMMMMMMWo.,cccccccccccccccccccccccc:;..,;:::;,....'',,,,,'''.........''',,,;;;;::::::::::::::::::::::::;;;;,,''..............:KWMMMMMMMMMMMMMMMMMMMM
44 MMMMMMMMMMx..:ccccccccccccccccccccccccc:;'.,;::::;,....'',,,,,,,,,'''''....................................',,;;::ccc;'..,;:::;:lkXWMMMMMMMMMMMMMMMMMM
45 MMMMMMMMMMXl.':cccccccccccccccccccccccccc:;'.,;:::::;,.....'''''........''',,,''''''''.................. .ckOOOOO00O0Oko:'.';:::::lkNMMMMMMMMMMMMMMMMM
46 MMMMMMMMMMMNx,,:cc:cccccccccccccccccccccccc:;''';::::::;,'.....  ..............'',,,,,,',,,,,,,,,,,,,,''..'oO0OOOOOO0OO0Oxl'.';:::::l0WMMMMMMMMMMMMMMM
47 MMMMMMMMMMMMMKo,;:ccccccccccccccccccccccccccc:;,'',;:::::::;'.. .;okkkkxol:;;'.....''',,,,,,,,,,,,',,,,,'. .cO0OOOO0OOOOOO0kc..';:::,;OWMMMMMMMMMMMMMM
48 MMMMMMMMMMMMMMNk:,;:cccccccccccccccccccccccccccc:;''',;:::::::;,'',;coxOO00OOOxoc;......''',,',,,,,,,,,''. .:k0O0OO0OO00O000O:..,:::;.;KMMMMMMMMMMMMMM
49 MMMMMMMMMMMMMMMMNOoc;:cccccccccccccccccccccccccccc::,'.',;::::::::;,'.',;clodxOOOOko:'.  ....'''',,'''....'lkOOOOO00OO0OOkdo:..';:::;.;KMMMMMMMMMMMMMM
50 MMMMMMMMMMMMMMMMMMMXOo:;:cccccccccccccccccccccccccccc:;'...,;:::::::::;,,'..'',;:codddo:'.   ........  .,okO0OOOOOkxdlc:;,''',;::::;';OMMMMMMMMMMMMMMM
51 MMMMMMMMMMMMMMMMMMMMMWKxc;;:cccccccccccccccccccccccccccc:;,'..',;::::::::::::;;,''.'''''..            .cdddolcc::;,,'''',;:::::::;,,oKWMMMMMMMMMMMMMMM
52 MMMMMMMMMMMMMMMMMMMMMMMMNOo:;;:ccccccccccccccccccccccccccccc:,'...',;;:::::::::::::::;;,,,''''''''''''',;;;,,,,,;;:::::::::::;;,..c0WMMMMMMMMMMMMMMMMM
53 MMMMMMMMMMMMMMMMMMMMMMMMMMWNOdc,,::cccccccccccccccccccccccccccc:;,'....',;::::::::::::::::::::::::::::::;;;;;;;,,''',,;;;,'.....'dNMMMMMMMMMMMMMMMMMMM
54 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo:,,;:ccccccccccccccccccccccccccccc:;,'.......',;;:::::::::::::;;,''..'',,,,;;;;,,,,;:::::,.  .lKWMMMMMMMMMMMMMMMMMMMM
55 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0dc;,,;:cccccccccccccccccccccccccccccc::;,,''.....''''',,'''.....',,;::cccccccccccccccc:,..;OWMMMMMMMMMMMMMMMMMMMMMM
56 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXko:,,,;:cccccccccccccccccccccccccccccccccc::;;,,''....',;;::ccccccccccccccccc::;,,'..;kNMMMMMMMMMMMMMMMMMMMMMMMM
57 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKxoc;,,;::ccccccccccccccccccccccccccccccccccccccc:ccccccccccccccccccc::,'....';:lkNMMMMMMMMMMMMMMMMMMMMMMMMMM
58 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOdlc;,,,;:::ccccccccccccccccccccccccccccccccccccccccccc::;;;;;,''',:ldk0XWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
59 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0xdllc:;;;,,,,;;;;;;;;;;;;;;;;;;:::::;;:;::;;;;;,,'...';:ldkKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
60 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWX000kddddolcc:::::::::::::clcc:::::::coxk000000KXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
61 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM */
62 
63 
64 
65 pragma solidity >=0.6.0;
66 
67 /// @title Base64
68 /// @author Brecht Devos - <brecht@loopring.org>
69 /// @notice Provides functions for encoding/decoding base64
70 library Base64 {
71     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
72     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
73                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
74                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
75                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
76 
77     function encode(bytes memory data) internal pure returns (string memory) {
78         if (data.length == 0) return '';
79 
80         // load the table into memory
81         string memory table = TABLE_ENCODE;
82 
83         // multiply by 4/3 rounded up
84         uint256 encodedLen = 4 * ((data.length + 2) / 3);
85 
86         // add some extra buffer at the end required for the writing
87         string memory result = new string(encodedLen + 32);
88 
89         assembly {
90             // set the actual output length
91             mstore(result, encodedLen)
92 
93             // prepare the lookup table
94             let tablePtr := add(table, 1)
95 
96             // input ptr
97             let dataPtr := data
98             let endPtr := add(dataPtr, mload(data))
99 
100             // result ptr, jump over length
101             let resultPtr := add(result, 32)
102 
103             // run over the input, 3 bytes at a time
104             for {} lt(dataPtr, endPtr) {}
105             {
106                 // read 3 bytes
107                 dataPtr := add(dataPtr, 3)
108                 let input := mload(dataPtr)
109 
110                 // write 4 characters
111                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
112                 resultPtr := add(resultPtr, 1)
113                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
114                 resultPtr := add(resultPtr, 1)
115                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
116                 resultPtr := add(resultPtr, 1)
117                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
118                 resultPtr := add(resultPtr, 1)
119             }
120 
121             // padding with '='
122             switch mod(mload(data), 3)
123             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
124             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
125         }
126 
127         return result;
128     }
129 
130     function decode(string memory _data) internal pure returns (bytes memory) {
131         bytes memory data = bytes(_data);
132 
133         if (data.length == 0) return new bytes(0);
134         require(data.length % 4 == 0, "invalid base64 decoder input");
135 
136         // load the table into memory
137         bytes memory table = TABLE_DECODE;
138 
139         // every 4 characters represent 3 bytes
140         uint256 decodedLen = (data.length / 4) * 3;
141 
142         // add some extra buffer at the end required for the writing
143         bytes memory result = new bytes(decodedLen + 32);
144 
145         assembly {
146             // padding with '='
147             let lastBytes := mload(add(data, mload(data)))
148             if eq(and(lastBytes, 0xFF), 0x3d) {
149                 decodedLen := sub(decodedLen, 1)
150                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
151                     decodedLen := sub(decodedLen, 1)
152                 }
153             }
154 
155             // set the actual output length
156             mstore(result, decodedLen)
157 
158             // prepare the lookup table
159             let tablePtr := add(table, 1)
160 
161             // input ptr
162             let dataPtr := data
163             let endPtr := add(dataPtr, mload(data))
164 
165             // result ptr, jump over length
166             let resultPtr := add(result, 32)
167 
168             // run over the input, 4 characters at a time
169             for {} lt(dataPtr, endPtr) {}
170             {
171                // read 4 characters
172                dataPtr := add(dataPtr, 4)
173                let input := mload(dataPtr)
174 
175                // write 3 bytes
176                let output := add(
177                    add(
178                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
179                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
180                    add(
181                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
182                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
183                     )
184                 )
185                 mstore(resultPtr, shl(232, output))
186                 resultPtr := add(resultPtr, 3)
187             }
188         }
189 
190         return result;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Contract module that helps prevent reentrant calls to a function.
203  *
204  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
205  * available, which can be applied to functions to make sure there are no nested
206  * (reentrant) calls to them.
207  *
208  * Note that because there is a single `nonReentrant` guard, functions marked as
209  * `nonReentrant` may not call one another. This can be worked around by making
210  * those functions `private`, and then adding `external` `nonReentrant` entry
211  * points to them.
212  *
213  * TIP: If you would like to learn more about reentrancy and alternative ways
214  * to protect against it, check out our blog post
215  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
216  */
217 abstract contract ReentrancyGuard {
218     // Booleans are more expensive than uint256 or any type that takes up a full
219     // word because each write operation emits an extra SLOAD to first read the
220     // slot's contents, replace the bits taken up by the boolean, and then write
221     // back. This is the compiler's defense against contract upgrades and
222     // pointer aliasing, and it cannot be disabled.
223 
224     // The values being non-zero value makes deployment a bit more expensive,
225     // but in exchange the refund on every call to nonReentrant will be lower in
226     // amount. Since refunds are capped to a percentage of the total
227     // transaction's gas, it is best to keep them low in cases like this one, to
228     // increase the likelihood of the full refund coming into effect.
229     uint256 private constant _NOT_ENTERED = 1;
230     uint256 private constant _ENTERED = 2;
231 
232     uint256 private _status;
233 
234     constructor() {
235         _status = _NOT_ENTERED;
236     }
237 
238     /**
239      * @dev Prevents a contract from calling itself, directly or indirectly.
240      * Calling a `nonReentrant` function from another `nonReentrant`
241      * function is not supported. It is possible to prevent this from happening
242      * by making the `nonReentrant` function external, and making it call a
243      * `private` function that does the actual work.
244      */
245     modifier nonReentrant() {
246         // On the first call to nonReentrant, _notEntered will be true
247         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
248 
249         // Any calls to nonReentrant after this point will fail
250         _status = _ENTERED;
251 
252         _;
253 
254         // By storing the original value once again, a refund is triggered (see
255         // https://eips.ethereum.org/EIPS/eip-2200)
256         _status = _NOT_ENTERED;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Strings.sol
261 
262 
263 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev String operations.
269  */
270 library Strings {
271     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
272     uint8 private constant _ADDRESS_LENGTH = 20;
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
276      */
277     function toString(uint256 value) internal pure returns (string memory) {
278         // Inspired by OraclizeAPI's implementation - MIT licence
279         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
280 
281         if (value == 0) {
282             return "0";
283         }
284         uint256 temp = value;
285         uint256 digits;
286         while (temp != 0) {
287             digits++;
288             temp /= 10;
289         }
290         bytes memory buffer = new bytes(digits);
291         while (value != 0) {
292             digits -= 1;
293             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
294             value /= 10;
295         }
296         return string(buffer);
297     }
298 
299     /**
300      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
301      */
302     function toHexString(uint256 value) internal pure returns (string memory) {
303         if (value == 0) {
304             return "0x00";
305         }
306         uint256 temp = value;
307         uint256 length = 0;
308         while (temp != 0) {
309             length++;
310             temp >>= 8;
311         }
312         return toHexString(value, length);
313     }
314 
315     /**
316      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
317      */
318     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
319         bytes memory buffer = new bytes(2 * length + 2);
320         buffer[0] = "0";
321         buffer[1] = "x";
322         for (uint256 i = 2 * length + 1; i > 1; --i) {
323             buffer[i] = _HEX_SYMBOLS[value & 0xf];
324             value >>= 4;
325         }
326         require(value == 0, "Strings: hex length insufficient");
327         return string(buffer);
328     }
329 
330     /**
331      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
332      */
333     function toHexString(address addr) internal pure returns (string memory) {
334         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/Context.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Provides information about the current execution context, including the
347  * sender of the transaction and its data. While these are generally available
348  * via msg.sender and msg.data, they should not be accessed in such a direct
349  * manner, since when dealing with meta-transactions the account sending and
350  * paying for execution may not be the actual sender (as far as an application
351  * is concerned).
352  *
353  * This contract is only required for intermediate, library-like contracts.
354  */
355 abstract contract Context {
356     function _msgSender() internal view virtual returns (address) {
357         return msg.sender;
358     }
359 
360     function _msgData() internal view virtual returns (bytes calldata) {
361         return msg.data;
362     }
363 }
364 
365 // File: @openzeppelin/contracts/access/Ownable.sol
366 
367 
368 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Contract module which provides a basic access control mechanism, where
375  * there is an account (an owner) that can be granted exclusive access to
376  * specific functions.
377  *
378  * By default, the owner account will be the one that deploys the contract. This
379  * can later be changed with {transferOwnership}.
380  *
381  * This module is used through inheritance. It will make available the modifier
382  * `onlyOwner`, which can be applied to your functions to restrict their use to
383  * the owner.
384  */
385 abstract contract Ownable is Context {
386     address private _owner;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390     /**
391      * @dev Initializes the contract setting the deployer as the initial owner.
392      */
393     constructor() {
394         _transferOwnership(_msgSender());
395     }
396 
397     /**
398      * @dev Throws if called by any account other than the owner.
399      */
400     modifier onlyOwner() {
401         _checkOwner();
402         _;
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view virtual returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if the sender is not the owner.
414      */
415     function _checkOwner() internal view virtual {
416         require(owner() == _msgSender(), "Ownable: caller is not the owner");
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         _transferOwnership(address(0));
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _transferOwnership(newOwner);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Internal function without access restriction.
442      */
443     function _transferOwnership(address newOwner) internal virtual {
444         address oldOwner = _owner;
445         _owner = newOwner;
446         emit OwnershipTransferred(oldOwner, newOwner);
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Address.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
454 
455 pragma solidity ^0.8.1;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      *
478      * [IMPORTANT]
479      * ====
480      * You shouldn't rely on `isContract` to protect against flash loan attacks!
481      *
482      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
483      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
484      * constructor.
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // This method relies on extcodesize/address.code.length, which returns 0
489         // for contracts in construction, since the code is only stored at the end
490         // of the constructor execution.
491 
492         return account.code.length > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         (bool success, ) = recipient.call{value: amount}("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.call{value: value}(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
599         return functionStaticCall(target, data, "Address: low-level static call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
626         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(isContract(target), "Address: delegate call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.delegatecall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
648      * revert reason using the provided one.
649      *
650      * _Available since v4.3._
651      */
652     function verifyCallResult(
653         bool success,
654         bytes memory returndata,
655         string memory errorMessage
656     ) internal pure returns (bytes memory) {
657         if (success) {
658             return returndata;
659         } else {
660             // Look for revert reason and bubble it up if present
661             if (returndata.length > 0) {
662                 // The easiest way to bubble the revert reason is using memory via assembly
663                 /// @solidity memory-safe-assembly
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
676 
677 
678 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @title ERC721 token receiver interface
684  * @dev Interface for any contract that wants to support safeTransfers
685  * from ERC721 asset contracts.
686  */
687 interface IERC721Receiver {
688     /**
689      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
690      * by `operator` from `from`, this function is called.
691      *
692      * It must return its Solidity selector to confirm the token transfer.
693      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
694      *
695      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
696      */
697     function onERC721Received(
698         address operator,
699         address from,
700         uint256 tokenId,
701         bytes calldata data
702     ) external returns (bytes4);
703 }
704 
705 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @dev Interface of the ERC165 standard, as defined in the
714  * https://eips.ethereum.org/EIPS/eip-165[EIP].
715  *
716  * Implementers can declare support of contract interfaces, which can then be
717  * queried by others ({ERC165Checker}).
718  *
719  * For an implementation, see {ERC165}.
720  */
721 interface IERC165 {
722     /**
723      * @dev Returns true if this contract implements the interface defined by
724      * `interfaceId`. See the corresponding
725      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
726      * to learn more about how these ids are created.
727      *
728      * This function call must use less than 30 000 gas.
729      */
730     function supportsInterface(bytes4 interfaceId) external view returns (bool);
731 }
732 
733 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
734 
735 
736 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @dev Implementation of the {IERC165} interface.
743  *
744  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
745  * for the additional interface id that will be supported. For example:
746  *
747  * ```solidity
748  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
750  * }
751  * ```
752  *
753  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
754  */
755 abstract contract ERC165 is IERC165 {
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
760         return interfaceId == type(IERC165).interfaceId;
761     }
762 }
763 
764 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
765 
766 
767 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @dev Required interface of an ERC721 compliant contract.
774  */
775 interface IERC721 is IERC165 {
776     /**
777      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
778      */
779     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
780 
781     /**
782      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
783      */
784     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
785 
786     /**
787      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
788      */
789     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
790 
791     /**
792      * @dev Returns the number of tokens in ``owner``'s account.
793      */
794     function balanceOf(address owner) external view returns (uint256 balance);
795 
796     /**
797      * @dev Returns the owner of the `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function ownerOf(uint256 tokenId) external view returns (address owner);
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes calldata data
823     ) external;
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) external;
844 
845     /**
846      * @dev Transfers `tokenId` token from `from` to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
856      *
857      * Emits a {Transfer} event.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) external;
864 
865     /**
866      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
867      * The approval is cleared when the token is transferred.
868      *
869      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
870      *
871      * Requirements:
872      *
873      * - The caller must own the token or be an approved operator.
874      * - `tokenId` must exist.
875      *
876      * Emits an {Approval} event.
877      */
878     function approve(address to, uint256 tokenId) external;
879 
880     /**
881      * @dev Approve or remove `operator` as an operator for the caller.
882      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
883      *
884      * Requirements:
885      *
886      * - The `operator` cannot be the caller.
887      *
888      * Emits an {ApprovalForAll} event.
889      */
890     function setApprovalForAll(address operator, bool _approved) external;
891 
892     /**
893      * @dev Returns the account approved for `tokenId` token.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function getApproved(uint256 tokenId) external view returns (address operator);
900 
901     /**
902      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
903      *
904      * See {setApprovalForAll}
905      */
906     function isApprovedForAll(address owner, address operator) external view returns (bool);
907 }
908 
909 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
910 
911 
912 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
913 
914 pragma solidity ^0.8.0;
915 
916 
917 /**
918  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
919  * @dev See https://eips.ethereum.org/EIPS/eip-721
920  */
921 interface IERC721Metadata is IERC721 {
922     /**
923      * @dev Returns the token collection name.
924      */
925     function name() external view returns (string memory);
926 
927     /**
928      * @dev Returns the token collection symbol.
929      */
930     function symbol() external view returns (string memory);
931 
932     /**
933      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
934      */
935     function tokenURI(uint256 tokenId) external view returns (string memory);
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
939 
940 
941 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 
946 
947 
948 
949 
950 
951 
952 /**
953  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
954  * the Metadata extension, but not including the Enumerable extension, which is available separately as
955  * {ERC721Enumerable}.
956  */
957 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
958     using Address for address;
959     using Strings for uint256;
960 
961     // Token name
962     string private _name;
963 
964     // Token symbol
965     string private _symbol;
966 
967     // Mapping from token ID to owner address
968     mapping(uint256 => address) private _owners;
969 
970     // Mapping owner address to token count
971     mapping(address => uint256) private _balances;
972 
973     // Mapping from token ID to approved address
974     mapping(uint256 => address) private _tokenApprovals;
975 
976     // Mapping from owner to operator approvals
977     mapping(address => mapping(address => bool)) private _operatorApprovals;
978 
979     /**
980      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
981      */
982     constructor(string memory name_, string memory symbol_) {
983         _name = name_;
984         _symbol = symbol_;
985     }
986 
987     /**
988      * @dev See {IERC165-supportsInterface}.
989      */
990     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
991         return
992             interfaceId == type(IERC721).interfaceId ||
993             interfaceId == type(IERC721Metadata).interfaceId ||
994             super.supportsInterface(interfaceId);
995     }
996 
997     /**
998      * @dev See {IERC721-balanceOf}.
999      */
1000     function balanceOf(address owner) public view virtual override returns (uint256) {
1001         require(owner != address(0), "ERC721: address zero is not a valid owner");
1002         return _balances[owner];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-ownerOf}.
1007      */
1008     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1009         address owner = _owners[tokenId];
1010         require(owner != address(0), "ERC721: invalid token ID");
1011         return owner;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-name}.
1016      */
1017     function name() public view virtual override returns (string memory) {
1018         return _name;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Metadata-symbol}.
1023      */
1024     function symbol() public view virtual override returns (string memory) {
1025         return _symbol;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Metadata-tokenURI}.
1030      */
1031     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1032         _requireMinted(tokenId);
1033 
1034         string memory baseURI = _baseURI();
1035         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1036     }
1037 
1038     /**
1039      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1040      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1041      * by default, can be overridden in child contracts.
1042      */
1043     function _baseURI() internal view virtual returns (string memory) {
1044         return "";
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-approve}.
1049      */
1050     function approve(address to, uint256 tokenId) public virtual override {
1051         address owner = ERC721.ownerOf(tokenId);
1052         require(to != owner, "ERC721: approval to current owner");
1053 
1054         require(
1055             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1056             "ERC721: approve caller is not token owner nor approved for all"
1057         );
1058 
1059         _approve(to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-getApproved}.
1064      */
1065     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1066         _requireMinted(tokenId);
1067 
1068         return _tokenApprovals[tokenId];
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-setApprovalForAll}.
1073      */
1074     function setApprovalForAll(address operator, bool approved) public virtual override {
1075         _setApprovalForAll(_msgSender(), operator, approved);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-isApprovedForAll}.
1080      */
1081     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1082         return _operatorApprovals[owner][operator];
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-transferFrom}.
1087      */
1088     function transferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public virtual override {
1093         //solhint-disable-next-line max-line-length
1094         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1095 
1096         _transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         safeTransferFrom(from, to, tokenId, "");
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory data
1118     ) public virtual override {
1119         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1120         _safeTransfer(from, to, tokenId, data);
1121     }
1122 
1123     /**
1124      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1125      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1126      *
1127      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1128      *
1129      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1130      * implement alternative mechanisms to perform token transfer, such as signature-based.
1131      *
1132      * Requirements:
1133      *
1134      * - `from` cannot be the zero address.
1135      * - `to` cannot be the zero address.
1136      * - `tokenId` token must exist and be owned by `from`.
1137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _safeTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId,
1145         bytes memory data
1146     ) internal virtual {
1147         _transfer(from, to, tokenId);
1148         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1149     }
1150 
1151     /**
1152      * @dev Returns whether `tokenId` exists.
1153      *
1154      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1155      *
1156      * Tokens start existing when they are minted (`_mint`),
1157      * and stop existing when they are burned (`_burn`).
1158      */
1159     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1160         return _owners[tokenId] != address(0);
1161     }
1162 
1163     /**
1164      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must exist.
1169      */
1170     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1171         address owner = ERC721.ownerOf(tokenId);
1172         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1173     }
1174 
1175     /**
1176      * @dev Safely mints `tokenId` and transfers it to `to`.
1177      *
1178      * Requirements:
1179      *
1180      * - `tokenId` must not exist.
1181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1182      *
1183      * Emits a {Transfer} event.
1184      */
1185     function _safeMint(address to, uint256 tokenId) internal virtual {
1186         _safeMint(to, tokenId, "");
1187     }
1188 
1189     /**
1190      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1191      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1192      */
1193     function _safeMint(
1194         address to,
1195         uint256 tokenId,
1196         bytes memory data
1197     ) internal virtual {
1198         _mint(to, tokenId);
1199         require(
1200             _checkOnERC721Received(address(0), to, tokenId, data),
1201             "ERC721: transfer to non ERC721Receiver implementer"
1202         );
1203     }
1204 
1205     /**
1206      * @dev Mints `tokenId` and transfers it to `to`.
1207      *
1208      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must not exist.
1213      * - `to` cannot be the zero address.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _mint(address to, uint256 tokenId) internal virtual {
1218         require(to != address(0), "ERC721: mint to the zero address");
1219         require(!_exists(tokenId), "ERC721: token already minted");
1220 
1221         _beforeTokenTransfer(address(0), to, tokenId);
1222 
1223         _balances[to] += 1;
1224         _owners[tokenId] = to;
1225 
1226         emit Transfer(address(0), to, tokenId);
1227 
1228         _afterTokenTransfer(address(0), to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev Destroys `tokenId`.
1233      * The approval is cleared when the token is burned.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _burn(uint256 tokenId) internal virtual {
1242         address owner = ERC721.ownerOf(tokenId);
1243 
1244         _beforeTokenTransfer(owner, address(0), tokenId);
1245 
1246         // Clear approvals
1247         _approve(address(0), tokenId);
1248 
1249         _balances[owner] -= 1;
1250         delete _owners[tokenId];
1251 
1252         emit Transfer(owner, address(0), tokenId);
1253 
1254         _afterTokenTransfer(owner, address(0), tokenId);
1255     }
1256 
1257     /**
1258      * @dev Transfers `tokenId` from `from` to `to`.
1259      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1260      *
1261      * Requirements:
1262      *
1263      * - `to` cannot be the zero address.
1264      * - `tokenId` token must be owned by `from`.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _transfer(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) internal virtual {
1273         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1274         require(to != address(0), "ERC721: transfer to the zero address");
1275 
1276         _beforeTokenTransfer(from, to, tokenId);
1277 
1278         // Clear approvals from the previous owner
1279         _approve(address(0), tokenId);
1280 
1281         _balances[from] -= 1;
1282         _balances[to] += 1;
1283         _owners[tokenId] = to;
1284 
1285         emit Transfer(from, to, tokenId);
1286 
1287         _afterTokenTransfer(from, to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev Approve `to` to operate on `tokenId`
1292      *
1293      * Emits an {Approval} event.
1294      */
1295     function _approve(address to, uint256 tokenId) internal virtual {
1296         _tokenApprovals[tokenId] = to;
1297         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1298     }
1299 
1300     /**
1301      * @dev Approve `operator` to operate on all of `owner` tokens
1302      *
1303      * Emits an {ApprovalForAll} event.
1304      */
1305     function _setApprovalForAll(
1306         address owner,
1307         address operator,
1308         bool approved
1309     ) internal virtual {
1310         require(owner != operator, "ERC721: approve to caller");
1311         _operatorApprovals[owner][operator] = approved;
1312         emit ApprovalForAll(owner, operator, approved);
1313     }
1314 
1315     /**
1316      * @dev Reverts if the `tokenId` has not been minted yet.
1317      */
1318     function _requireMinted(uint256 tokenId) internal view virtual {
1319         require(_exists(tokenId), "ERC721: invalid token ID");
1320     }
1321 
1322     /**
1323      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1324      * The call is not executed if the target address is not a contract.
1325      *
1326      * @param from address representing the previous owner of the given token ID
1327      * @param to target address that will receive the tokens
1328      * @param tokenId uint256 ID of the token to be transferred
1329      * @param data bytes optional data to send along with the call
1330      * @return bool whether the call correctly returned the expected magic value
1331      */
1332     function _checkOnERC721Received(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory data
1337     ) private returns (bool) {
1338         if (to.isContract()) {
1339             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1340                 return retval == IERC721Receiver.onERC721Received.selector;
1341             } catch (bytes memory reason) {
1342                 if (reason.length == 0) {
1343                     revert("ERC721: transfer to non ERC721Receiver implementer");
1344                 } else {
1345                     /// @solidity memory-safe-assembly
1346                     assembly {
1347                         revert(add(32, reason), mload(reason))
1348                     }
1349                 }
1350             }
1351         } else {
1352             return true;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Hook that is called before any token transfer. This includes minting
1358      * and burning.
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` will be minted for `to`.
1365      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1366      * - `from` and `to` are never both zero.
1367      *
1368      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1369      */
1370     function _beforeTokenTransfer(
1371         address from,
1372         address to,
1373         uint256 tokenId
1374     ) internal virtual {}
1375 
1376     /**
1377      * @dev Hook that is called after any transfer of tokens. This includes
1378      * minting and burning.
1379      *
1380      * Calling conditions:
1381      *
1382      * - when `from` and `to` are both non-zero.
1383      * - `from` and `to` are never both zero.
1384      *
1385      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1386      */
1387     function _afterTokenTransfer(
1388         address from,
1389         address to,
1390         uint256 tokenId
1391     ) internal virtual {}
1392 }
1393 
1394 // File: contracts/strings.sol
1395 
1396 
1397 
1398 /*
1399  * @title String & slice utility library for Solidity contracts.
1400  * @author Nick Johnson <arachnid@notdot.net>
1401  */
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 library strings {
1406     struct slice {
1407         uint _len;
1408         uint _ptr;
1409     }
1410 
1411     function memcpy(uint dest, uint src, uint _len) private pure {
1412         // Copy word-length chunks while possible
1413         for(; _len >= 32; _len -= 32) {
1414             assembly {
1415                 mstore(dest, mload(src))
1416             }
1417             dest += 32;
1418             src += 32;
1419         }
1420 
1421         // Copy remaining bytes
1422         uint mask = type(uint).max;
1423         if (_len > 0) {
1424             mask = 256 ** (32 - _len) - 1;
1425         }
1426         assembly {
1427             let srcpart := and(mload(src), not(mask))
1428             let destpart := and(mload(dest), mask)
1429             mstore(dest, or(destpart, srcpart))
1430         }
1431     }
1432 
1433     /*
1434      * @dev Returns a slice containing the entire string.
1435      * @param self The string to make a slice from.
1436      * @return A newly allocated slice containing the entire string.
1437      */
1438     function toSlice(string memory self) internal pure returns (slice memory) {
1439         uint ptr;
1440         assembly {
1441             ptr := add(self, 0x20)
1442         }
1443         return slice(bytes(self).length, ptr);
1444     }
1445 
1446     /*
1447      * @dev Returns the length of a null-terminated bytes32 string.
1448      * @param self The value to find the length of.
1449      * @return The length of the string, from 0 to 32.
1450      */
1451     function len(bytes32 self) internal pure returns (uint) {
1452         uint ret;
1453         if (self == 0)
1454             return 0;
1455         if (uint(self) & type(uint128).max == 0) {
1456             ret += 16;
1457             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1458         }
1459         if (uint(self) & type(uint64).max == 0) {
1460             ret += 8;
1461             self = bytes32(uint(self) / 0x10000000000000000);
1462         }
1463         if (uint(self) & type(uint32).max == 0) {
1464             ret += 4;
1465             self = bytes32(uint(self) / 0x100000000);
1466         }
1467         if (uint(self) & type(uint16).max == 0) {
1468             ret += 2;
1469             self = bytes32(uint(self) / 0x10000);
1470         }
1471         if (uint(self) & type(uint8).max == 0) {
1472             ret += 1;
1473         }
1474         return 32 - ret;
1475     }
1476 
1477     /*
1478      * @dev Returns a slice containing the entire bytes32, interpreted as a
1479      *      null-terminated utf-8 string.
1480      * @param self The bytes32 value to convert to a slice.
1481      * @return A new slice containing the value of the input argument up to the
1482      *         first null.
1483      */
1484     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1485         // Allocate space for `self` in memory, copy it there, and point ret at it
1486         assembly {
1487             let ptr := mload(0x40)
1488             mstore(0x40, add(ptr, 0x20))
1489             mstore(ptr, self)
1490             mstore(add(ret, 0x20), ptr)
1491         }
1492         ret._len = len(self);
1493     }
1494 
1495     /*
1496      * @dev Returns a new slice containing the same data as the current slice.
1497      * @param self The slice to copy.
1498      * @return A new slice containing the same data as `self`.
1499      */
1500     function copy(slice memory self) internal pure returns (slice memory) {
1501         return slice(self._len, self._ptr);
1502     }
1503 
1504     /*
1505      * @dev Copies a slice to a new string.
1506      * @param self The slice to copy.
1507      * @return A newly allocated string containing the slice's text.
1508      */
1509     function toString(slice memory self) internal pure returns (string memory) {
1510         string memory ret = new string(self._len);
1511         uint retptr;
1512         assembly { retptr := add(ret, 32) }
1513 
1514         memcpy(retptr, self._ptr, self._len);
1515         return ret;
1516     }
1517 
1518     /*
1519      * @dev Returns the length in runes of the slice. Note that this operation
1520      *      takes time proportional to the length of the slice; avoid using it
1521      *      in loops, and call `slice.empty()` if you only need to know whether
1522      *      the slice is empty or not.
1523      * @param self The slice to operate on.
1524      * @return The length of the slice in runes.
1525      */
1526     function len(slice memory self) internal pure returns (uint l) {
1527         // Starting at ptr-31 means the LSB will be the byte we care about
1528         uint ptr = self._ptr - 31;
1529         uint end = ptr + self._len;
1530         for (l = 0; ptr < end; l++) {
1531             uint8 b;
1532             assembly { b := and(mload(ptr), 0xFF) }
1533             if (b < 0x80) {
1534                 ptr += 1;
1535             } else if(b < 0xE0) {
1536                 ptr += 2;
1537             } else if(b < 0xF0) {
1538                 ptr += 3;
1539             } else if(b < 0xF8) {
1540                 ptr += 4;
1541             } else if(b < 0xFC) {
1542                 ptr += 5;
1543             } else {
1544                 ptr += 6;
1545             }
1546         }
1547     }
1548 
1549     /*
1550      * @dev Returns true if the slice is empty (has a length of 0).
1551      * @param self The slice to operate on.
1552      * @return True if the slice is empty, False otherwise.
1553      */
1554     function empty(slice memory self) internal pure returns (bool) {
1555         return self._len == 0;
1556     }
1557 
1558     /*
1559      * @dev Returns a positive number if `other` comes lexicographically after
1560      *      `self`, a negative number if it comes before, or zero if the
1561      *      contents of the two slices are equal. Comparison is done per-rune,
1562      *      on unicode codepoints.
1563      * @param self The first slice to compare.
1564      * @param other The second slice to compare.
1565      * @return The result of the comparison.
1566      */
1567     function compare(slice memory self, slice memory other) internal pure returns (int) {
1568         uint shortest = self._len;
1569         if (other._len < self._len)
1570             shortest = other._len;
1571 
1572         uint selfptr = self._ptr;
1573         uint otherptr = other._ptr;
1574         for (uint idx = 0; idx < shortest; idx += 32) {
1575             uint a;
1576             uint b;
1577             assembly {
1578                 a := mload(selfptr)
1579                 b := mload(otherptr)
1580             }
1581             if (a != b) {
1582                 // Mask out irrelevant bytes and check again
1583                 uint mask = type(uint).max; // 0xffff...
1584                 if(shortest < 32) {
1585                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1586                 }
1587                 unchecked {
1588                     uint diff = (a & mask) - (b & mask);
1589                     if (diff != 0)
1590                         return int(diff);
1591                 }
1592             }
1593             selfptr += 32;
1594             otherptr += 32;
1595         }
1596         return int(self._len) - int(other._len);
1597     }
1598 
1599     /*
1600      * @dev Returns true if the two slices contain the same text.
1601      * @param self The first slice to compare.
1602      * @param self The second slice to compare.
1603      * @return True if the slices are equal, false otherwise.
1604      */
1605     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1606         return compare(self, other) == 0;
1607     }
1608 
1609     /*
1610      * @dev Extracts the first rune in the slice into `rune`, advancing the
1611      *      slice to point to the next rune and returning `self`.
1612      * @param self The slice to operate on.
1613      * @param rune The slice that will contain the first rune.
1614      * @return `rune`.
1615      */
1616     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1617         rune._ptr = self._ptr;
1618 
1619         if (self._len == 0) {
1620             rune._len = 0;
1621             return rune;
1622         }
1623 
1624         uint l;
1625         uint b;
1626         // Load the first byte of the rune into the LSBs of b
1627         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1628         if (b < 0x80) {
1629             l = 1;
1630         } else if(b < 0xE0) {
1631             l = 2;
1632         } else if(b < 0xF0) {
1633             l = 3;
1634         } else {
1635             l = 4;
1636         }
1637 
1638         // Check for truncated codepoints
1639         if (l > self._len) {
1640             rune._len = self._len;
1641             self._ptr += self._len;
1642             self._len = 0;
1643             return rune;
1644         }
1645 
1646         self._ptr += l;
1647         self._len -= l;
1648         rune._len = l;
1649         return rune;
1650     }
1651 
1652     /*
1653      * @dev Returns the first rune in the slice, advancing the slice to point
1654      *      to the next rune.
1655      * @param self The slice to operate on.
1656      * @return A slice containing only the first rune from `self`.
1657      */
1658     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1659         nextRune(self, ret);
1660     }
1661 
1662     /*
1663      * @dev Returns the number of the first codepoint in the slice.
1664      * @param self The slice to operate on.
1665      * @return The number of the first codepoint in the slice.
1666      */
1667     function ord(slice memory self) internal pure returns (uint ret) {
1668         if (self._len == 0) {
1669             return 0;
1670         }
1671 
1672         uint word;
1673         uint length;
1674         uint divisor = 2 ** 248;
1675 
1676         // Load the rune into the MSBs of b
1677         assembly { word:= mload(mload(add(self, 32))) }
1678         uint b = word / divisor;
1679         if (b < 0x80) {
1680             ret = b;
1681             length = 1;
1682         } else if(b < 0xE0) {
1683             ret = b & 0x1F;
1684             length = 2;
1685         } else if(b < 0xF0) {
1686             ret = b & 0x0F;
1687             length = 3;
1688         } else {
1689             ret = b & 0x07;
1690             length = 4;
1691         }
1692 
1693         // Check for truncated codepoints
1694         if (length > self._len) {
1695             return 0;
1696         }
1697 
1698         for (uint i = 1; i < length; i++) {
1699             divisor = divisor / 256;
1700             b = (word / divisor) & 0xFF;
1701             if (b & 0xC0 != 0x80) {
1702                 // Invalid UTF-8 sequence
1703                 return 0;
1704             }
1705             ret = (ret * 64) | (b & 0x3F);
1706         }
1707 
1708         return ret;
1709     }
1710 
1711     /*
1712      * @dev Returns the keccak-256 hash of the slice.
1713      * @param self The slice to hash.
1714      * @return The hash of the slice.
1715      */
1716     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1717         assembly {
1718             ret := keccak256(mload(add(self, 32)), mload(self))
1719         }
1720     }
1721 
1722     /*
1723      * @dev Returns true if `self` starts with `needle`.
1724      * @param self The slice to operate on.
1725      * @param needle The slice to search for.
1726      * @return True if the slice starts with the provided text, false otherwise.
1727      */
1728     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1729         if (self._len < needle._len) {
1730             return false;
1731         }
1732 
1733         if (self._ptr == needle._ptr) {
1734             return true;
1735         }
1736 
1737         bool equal;
1738         assembly {
1739             let length := mload(needle)
1740             let selfptr := mload(add(self, 0x20))
1741             let needleptr := mload(add(needle, 0x20))
1742             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1743         }
1744         return equal;
1745     }
1746 
1747     /*
1748      * @dev If `self` starts with `needle`, `needle` is removed from the
1749      *      beginning of `self`. Otherwise, `self` is unmodified.
1750      * @param self The slice to operate on.
1751      * @param needle The slice to search for.
1752      * @return `self`
1753      */
1754     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1755         if (self._len < needle._len) {
1756             return self;
1757         }
1758 
1759         bool equal = true;
1760         if (self._ptr != needle._ptr) {
1761             assembly {
1762                 let length := mload(needle)
1763                 let selfptr := mload(add(self, 0x20))
1764                 let needleptr := mload(add(needle, 0x20))
1765                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1766             }
1767         }
1768 
1769         if (equal) {
1770             self._len -= needle._len;
1771             self._ptr += needle._len;
1772         }
1773 
1774         return self;
1775     }
1776 
1777     /*
1778      * @dev Returns true if the slice ends with `needle`.
1779      * @param self The slice to operate on.
1780      * @param needle The slice to search for.
1781      * @return True if the slice starts with the provided text, false otherwise.
1782      */
1783     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1784         if (self._len < needle._len) {
1785             return false;
1786         }
1787 
1788         uint selfptr = self._ptr + self._len - needle._len;
1789 
1790         if (selfptr == needle._ptr) {
1791             return true;
1792         }
1793 
1794         bool equal;
1795         assembly {
1796             let length := mload(needle)
1797             let needleptr := mload(add(needle, 0x20))
1798             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1799         }
1800 
1801         return equal;
1802     }
1803 
1804     /*
1805      * @dev If `self` ends with `needle`, `needle` is removed from the
1806      *      end of `self`. Otherwise, `self` is unmodified.
1807      * @param self The slice to operate on.
1808      * @param needle The slice to search for.
1809      * @return `self`
1810      */
1811     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1812         if (self._len < needle._len) {
1813             return self;
1814         }
1815 
1816         uint selfptr = self._ptr + self._len - needle._len;
1817         bool equal = true;
1818         if (selfptr != needle._ptr) {
1819             assembly {
1820                 let length := mload(needle)
1821                 let needleptr := mload(add(needle, 0x20))
1822                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1823             }
1824         }
1825 
1826         if (equal) {
1827             self._len -= needle._len;
1828         }
1829 
1830         return self;
1831     }
1832 
1833     // Returns the memory address of the first byte of the first occurrence of
1834     // `needle` in `self`, or the first byte after `self` if not found.
1835     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1836         uint ptr = selfptr;
1837         uint idx;
1838 
1839         if (needlelen <= selflen) {
1840             if (needlelen <= 32) {
1841                 bytes32 mask;
1842                 if (needlelen > 0) {
1843                     mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1844                 }
1845 
1846                 bytes32 needledata;
1847                 assembly { needledata := and(mload(needleptr), mask) }
1848 
1849                 uint end = selfptr + selflen - needlelen;
1850                 bytes32 ptrdata;
1851                 assembly { ptrdata := and(mload(ptr), mask) }
1852 
1853                 while (ptrdata != needledata) {
1854                     if (ptr >= end)
1855                         return selfptr + selflen;
1856                     ptr++;
1857                     assembly { ptrdata := and(mload(ptr), mask) }
1858                 }
1859                 return ptr;
1860             } else {
1861                 // For long needles, use hashing
1862                 bytes32 hash;
1863                 assembly { hash := keccak256(needleptr, needlelen) }
1864 
1865                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1866                     bytes32 testHash;
1867                     assembly { testHash := keccak256(ptr, needlelen) }
1868                     if (hash == testHash)
1869                         return ptr;
1870                     ptr += 1;
1871                 }
1872             }
1873         }
1874         return selfptr + selflen;
1875     }
1876 
1877     // Returns the memory address of the first byte after the last occurrence of
1878     // `needle` in `self`, or the address of `self` if not found.
1879     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1880         uint ptr;
1881 
1882         if (needlelen <= selflen) {
1883             if (needlelen <= 32) {
1884                 bytes32 mask;
1885                 if (needlelen > 0) {
1886                     mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1887                 }
1888 
1889                 bytes32 needledata;
1890                 assembly { needledata := and(mload(needleptr), mask) }
1891 
1892                 ptr = selfptr + selflen - needlelen;
1893                 bytes32 ptrdata;
1894                 assembly { ptrdata := and(mload(ptr), mask) }
1895 
1896                 while (ptrdata != needledata) {
1897                     if (ptr <= selfptr)
1898                         return selfptr;
1899                     ptr--;
1900                     assembly { ptrdata := and(mload(ptr), mask) }
1901                 }
1902                 return ptr + needlelen;
1903             } else {
1904                 // For long needles, use hashing
1905                 bytes32 hash;
1906                 assembly { hash := keccak256(needleptr, needlelen) }
1907                 ptr = selfptr + (selflen - needlelen);
1908                 while (ptr >= selfptr) {
1909                     bytes32 testHash;
1910                     assembly { testHash := keccak256(ptr, needlelen) }
1911                     if (hash == testHash)
1912                         return ptr + needlelen;
1913                     ptr -= 1;
1914                 }
1915             }
1916         }
1917         return selfptr;
1918     }
1919 
1920     /*
1921      * @dev Modifies `self` to contain everything from the first occurrence of
1922      *      `needle` to the end of the slice. `self` is set to the empty slice
1923      *      if `needle` is not found.
1924      * @param self The slice to search and modify.
1925      * @param needle The text to search for.
1926      * @return `self`.
1927      */
1928     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1929         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1930         self._len -= ptr - self._ptr;
1931         self._ptr = ptr;
1932         return self;
1933     }
1934 
1935     /*
1936      * @dev Modifies `self` to contain the part of the string from the start of
1937      *      `self` to the end of the first occurrence of `needle`. If `needle`
1938      *      is not found, `self` is set to the empty slice.
1939      * @param self The slice to search and modify.
1940      * @param needle The text to search for.
1941      * @return `self`.
1942      */
1943     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1944         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1945         self._len = ptr - self._ptr;
1946         return self;
1947     }
1948 
1949     /*
1950      * @dev Splits the slice, setting `self` to everything after the first
1951      *      occurrence of `needle`, and `token` to everything before it. If
1952      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1953      *      and `token` is set to the entirety of `self`.
1954      * @param self The slice to split.
1955      * @param needle The text to search for in `self`.
1956      * @param token An output parameter to which the first token is written.
1957      * @return `token`.
1958      */
1959     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1960         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1961         token._ptr = self._ptr;
1962         token._len = ptr - self._ptr;
1963         if (ptr == self._ptr + self._len) {
1964             // Not found
1965             self._len = 0;
1966         } else {
1967             self._len -= token._len + needle._len;
1968             self._ptr = ptr + needle._len;
1969         }
1970         return token;
1971     }
1972 
1973     /*
1974      * @dev Splits the slice, setting `self` to everything after the first
1975      *      occurrence of `needle`, and returning everything before it. If
1976      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1977      *      and the entirety of `self` is returned.
1978      * @param self The slice to split.
1979      * @param needle The text to search for in `self`.
1980      * @return The part of `self` up to the first occurrence of `delim`.
1981      */
1982     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1983         split(self, needle, token);
1984     }
1985 
1986     /*
1987      * @dev Splits the slice, setting `self` to everything before the last
1988      *      occurrence of `needle`, and `token` to everything after it. If
1989      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1990      *      and `token` is set to the entirety of `self`.
1991      * @param self The slice to split.
1992      * @param needle The text to search for in `self`.
1993      * @param token An output parameter to which the first token is written.
1994      * @return `token`.
1995      */
1996     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1997         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1998         token._ptr = ptr;
1999         token._len = self._len - (ptr - self._ptr);
2000         if (ptr == self._ptr) {
2001             // Not found
2002             self._len = 0;
2003         } else {
2004             self._len -= token._len + needle._len;
2005         }
2006         return token;
2007     }
2008 
2009     /*
2010      * @dev Splits the slice, setting `self` to everything before the last
2011      *      occurrence of `needle`, and returning everything after it. If
2012      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2013      *      and the entirety of `self` is returned.
2014      * @param self The slice to split.
2015      * @param needle The text to search for in `self`.
2016      * @return The part of `self` after the last occurrence of `delim`.
2017      */
2018     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2019         rsplit(self, needle, token);
2020     }
2021 
2022     /*
2023      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2024      * @param self The slice to search.
2025      * @param needle The text to search for in `self`.
2026      * @return The number of occurrences of `needle` found in `self`.
2027      */
2028     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
2029         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2030         while (ptr <= self._ptr + self._len) {
2031             cnt++;
2032             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2033         }
2034     }
2035 
2036     /*
2037      * @dev Returns True if `self` contains `needle`.
2038      * @param self The slice to search.
2039      * @param needle The text to search for in `self`.
2040      * @return True if `needle` is found in `self`, false otherwise.
2041      */
2042     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
2043         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2044     }
2045 
2046     /*
2047      * @dev Returns a newly allocated string containing the concatenation of
2048      *      `self` and `other`.
2049      * @param self The first slice to concatenate.
2050      * @param other The second slice to concatenate.
2051      * @return The concatenation of the two strings.
2052      */
2053     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
2054         string memory ret = new string(self._len + other._len);
2055         uint retptr;
2056         assembly { retptr := add(ret, 32) }
2057         memcpy(retptr, self._ptr, self._len);
2058         memcpy(retptr + self._len, other._ptr, other._len);
2059         return ret;
2060     }
2061 
2062     /*
2063      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2064      *      newly allocated string.
2065      * @param self The delimiter to use.
2066      * @param parts A list of slices to join.
2067      * @return A newly allocated string containing all the slices in `parts`,
2068      *         joined with `self`.
2069      */
2070     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
2071         if (parts.length == 0)
2072             return "";
2073 
2074         uint length = self._len * (parts.length - 1);
2075         for(uint i = 0; i < parts.length; i++)
2076             length += parts[i]._len;
2077 
2078         string memory ret = new string(length);
2079         uint retptr;
2080         assembly { retptr := add(ret, 32) }
2081 
2082         for(uint i = 0; i < parts.length; i++) {
2083             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2084             retptr += parts[i]._len;
2085             if (i < parts.length - 1) {
2086                 memcpy(retptr, self._ptr, self._len);
2087                 retptr += self._len;
2088             }
2089         }
2090 
2091         return ret;
2092     }
2093 
2094     /**
2095      * Lower
2096      * 
2097      * Converts all the values of a string to their corresponding lower case
2098      * value.
2099      * 
2100      * @param _base When being used for a data type this is the extended object
2101      *              otherwise this is the string base to convert to lower case
2102      * @return string 
2103      */
2104     function lower(string memory _base)
2105         internal
2106         pure
2107         returns (string memory) {
2108         bytes memory _baseBytes = bytes(_base);
2109         for (uint i = 0; i < _baseBytes.length; i++) {
2110             _baseBytes[i] = _lower(_baseBytes[i]);
2111         }
2112         return string(_baseBytes);
2113     }
2114 
2115     /**
2116      * Lower
2117      * 
2118      * Convert an alphabetic character to lower case and return the original
2119      * value when not alphabetic
2120      * 
2121      * @param _b1 The byte to be converted to lower case
2122      * @return bytes1 The converted value if the passed value was alphabetic
2123      *                and in a upper case otherwise returns the original value
2124      */
2125     function _lower(bytes1 _b1)
2126         private
2127         pure
2128         returns (bytes1) {
2129 
2130         if (_b1 >= 0x41 && _b1 <= 0x5A) {
2131             return bytes1(uint8(_b1) + 32);
2132         }
2133 
2134         return _b1;
2135     }
2136 }
2137 
2138 pragma solidity ^0.8.4;
2139 
2140 
2141 contract PepeNameService is ERC721, Ownable, ReentrancyGuard {
2142   using strings for string;
2143 
2144   uint256 public price; // domain price
2145   bool public buyingEnabled; // buying domains enabled
2146   uint256 public referral = 1000; // share of each domain purchase (in bips) that goes to the referrer (referral fee)
2147   uint256 public totalSupply;
2148   uint256 public nameMaxLength = 100; // max length of a domain name
2149   string public description = "Pepe Name Service (PNS) is a cheap domain service, yours forever, 100% on-chain get yours at https://pepedomains.com/";
2150 
2151   struct Domain {
2152     string name; // domain name that goes before the TLD name; example: "Pepe" in "pepe.pepe"
2153     uint256 tokenId;
2154     address holder;
2155     string data; // stringified JSON object, example: {"description": "Some text", "twitter": "@Pepenameservice", "friends": ["0x123..."], "url": "https://pepedomains.com/"}
2156   }
2157   
2158   mapping (string => Domain) public domains; // mapping (domain name => Domain struct)
2159   mapping (uint256 => string) public domainIdsNames; // mapping (tokenId => domain name)
2160   mapping (address => string) public defaultNames; // user's default domain
2161 
2162   event DomainCreated(address indexed user, address indexed owner, string fullDomainName);
2163   event DefaultDomainChanged(address indexed user, string defaultDomain);
2164   event DataChanged(address indexed user);
2165   event TldPriceChanged(address indexed user, uint256 tldPrice);
2166   event ReferralFeeChanged(address indexed user, uint256 referralFee);
2167   event DomainBuyingToggle(address indexed user, bool domainBuyingToggle);
2168 
2169   constructor(
2170     string memory _name,
2171     string memory _symbol,
2172     address _tldOwner,
2173     uint256 _domainPrice,
2174     bool _buyingEnabled
2175   ) ERC721(_name, _symbol) {
2176     price = _domainPrice;
2177     buyingEnabled = _buyingEnabled;
2178     transferOwnership(_tldOwner);
2179   }
2180 
2181   // READ
2182 
2183   // Domain getters - you can also get all Domain data by calling the auto-generated domains(domainName) method
2184   function getDomainHolder(string calldata _domainName) public view returns(address) {
2185     return domains[strings.lower(_domainName)].holder;
2186   }
2187 
2188   function getDomainData(string calldata _domainName) public view returns(string memory) {
2189     return domains[strings.lower(_domainName)].data; // should be a JSON object
2190   }
2191 
2192   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
2193     string memory fullDomainName = string(abi.encodePacked(domains[domainIdsNames[_tokenId]].name, name()));
2194 
2195     return string(
2196       abi.encodePacked("data:application/json;base64,",Base64.encode(bytes(abi.encodePacked(
2197         '{"name": "', fullDomainName, '", ',
2198         '"description": "', description, '", ',
2199         '"image": "', _getImage(fullDomainName), '"}'))))
2200     );
2201   }
2202 
2203   function _getImage(string memory _fullDomainName) internal pure returns (string memory) {
2204     string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(
2205       '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500" width="500" height="500"><defs><linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" style="stop-color:rgb(25, 151, 39);stop-opacity:1" /><stop offset="100%" style="stop-color:rgb(45, 207, 9);stop-opacity:1" /></linearGradient></defs><rect x="0" y="0" width="500" height="500" fill="url(#grad)"/><text x="50%" y="50%" dominant-baseline="middle" fill="white" text-anchor="middle" font-size="2.5rem">',
2206         _fullDomainName,'</text>',
2207         '<g transform="translate(-0.000000,100.000000) scale(0.050000,-0.050000)" fill="rgb(17, 116, 29)" stroke="none"><path d="M760 1936 c-81 -31 -185 -90 -226 -128 -61 -56 -131 -164 -145 -224 -18 -77 -32 -104 -94 -179 -73 -89 -102 -152 -116 -251 -14 -110 -13 -368 2 -396 28 -52 69 -94 163 -165 190 -142 378 -238 535 -270 92 -19 500 -24 631 -7 85 11 302 75 329 97 29 24 164 192 173 217 13 32 -27 113 -78 160 -19 17 -32 36 -28 42 4 5 26 19 50 30 50 22 114 83 114 109 0 9 -29 58 -65 107 -35 50 -66 95 -67 101 -2 5 16 22 40 38 34 22 49 41 69 88 13 33 28 73 32 90 9 41 -6 163 -27 205 -20 40 -85 78 -277 160 -66 29 -149 67 -184 86 -115 63 -215 65 -357 7 l-63 -26 -53 33 c-129 81 -137 84 -233 87 -58 2 -103 -2 -125 -11z m609 -323 c73 -37 113 -92 119 -166 5 -63 -20 -123 -65 -155 -134 -93 -460 -30 -567 110 -14 19 -49 47 -77 62 -64 35 -63 58 3 67 25 4 82 23 125 43 177 80 351 94 462 39z m593 -18 c26 -9 59 -30 73 -47 21 -25 25 -39 25 -99 0 -43 -6 -81 -15 -99 -31 -60 -113 -79 -261 -61 -119 14 -187 36 -227 71 -29 25 -34 37 -44 106 -7 50 -8 85 -2 96 8 16 70 39 139 52 57 11 266 -2 312 -19z m-155 -846 c63 -47 84 -82 62 -104 -22 -22 -185 -65 -269 -71 l-75 -6 41 39 c68 64 69 66 38 112 -15 23 -25 44 -22 46 8 8 89 23 132 24 31 1 50 -7 93 -40z m-691 -50 c65 -20 214 -94 214 -106 0 -10 -103 7 -170 27 -80 26 -180 70 -180 81 0 7 21 13 56 18 7 0 43 -8 80 -20z"/><path d="M1155 1551 c-79 -48 -97 -170 -32 -216 27 -19 97 -19 141 -1 49 20 66 51 66 119 0 51 -4 62 -29 88 -24 23 -38 29 -73 29 -24 0 -56 -8 -73 -19z m106 -91 c10 -6 19 -16 19 -22 0 -18 -32 -48 -51 -48 -23 0 -36 44 -19 65 15 18 25 19 51 5z"/><path d="M1755 1537 c-59 -59 -56 -151 7 -183 17 -9 48 -14 76 -12 46 3 47 4 76 60 l28 57 -26 46 c-30 51 -51 65 -96 65 -23 0 -42 -10 -65 -33z m109 -83 c35 -13 12 -54 -30 -54 -20 0 -29 27 -14 45 14 17 21 18 44 9z"/></g>',
2208         '<g transform="translate(390.000000,510.000000) scale(0.050000,-0.050000)" fill="rgb(17, 116, 29)" stroke="none"><path d="M1268 1937 c-20 -8 -69 -35 -109 -61 -40 -25 -76 -46 -81 -46 -5 0 -34 11 -66 24 -135 57 -239 55 -353 -8 -35 -19 -118 -57 -184 -86 -192 -82 -257 -120 -277 -160 -21 -42 -36 -164 -27 -205 4 -17 19 -57 32 -90 20 -47 35 -66 69 -88 24 -16 42 -33 40 -38 -1 -6 -32 -51 -67 -101 -36 -49 -65 -98 -65 -107 0 -26 64 -87 114 -109 24 -11 46 -25 50 -30 4 -6 -9 -25 -28 -42 -51 -47 -91 -128 -78 -160 9 -25 144 -193 173 -217 27 -22 244 -86 329 -97 131 -17 539 -12 631 7 157 32 345 128 535 270 94 71 135 113 163 165 15 28 16 286 2 396 -14 99 -43 162 -116 251 -62 75 -76 102 -94 179 -14 60 -84 168 -146 225 -25 23 -90 63 -143 89 -89 43 -103 47 -182 50 -53 1 -99 -3 -122 -11z m-68 -313 c35 -8 100 -31 143 -50 43 -20 100 -39 125 -43 66 -9 67 -32 3 -67 -28 -15 -63 -43 -77 -62 -107 -140 -433 -203 -567 -110 -73 51 -88 170 -31 250 70 101 208 129 404 82z m-523 -28 c29 -9 57 -25 62 -34 6 -11 5 -46 -2 -96 -10 -69 -15 -81 -44 -106 -40 -35 -108 -57 -227 -71 -148 -18 -230 1 -261 61 -9 18 -15 56 -15 99 0 101 29 130 165 165 42 11 271 -2 322 -18z m-67 -816 c30 -6 56 -12 58 -15 3 -2 -7 -23 -22 -46 -31 -46 -30 -48 38 -112 l41 -39 -75 6 c-82 6 -247 49 -269 70 -21 22 -4 54 57 102 62 48 80 51 172 34z m629 -66 c17 -4 31 -10 31 -14 0 -10 -101 -55 -180 -80 -66 -20 -170 -37 -170 -27 0 12 139 82 205 103 82 27 74 26 114 18z"/><path d="M949 1541 c-25 -26 -29 -37 -29 -88 0 -68 17 -99 66 -119 44 -18 114 -18 141 1 47 33 52 119 11 178 -45 63 -139 77 -189 28z m91 -86 c16 -20 4 -65 -17 -65 -20 0 -53 28 -53 46 0 14 27 33 46 34 6 0 17 -7 24 -15z"/><path d="M378 1559 c-10 -5 -29 -30 -44 -55 l-26 -45 28 -57 c29 -56 30 -57 76 -60 87 -6 138 46 123 125 -9 52 -63 103 -106 103 -19 0 -42 -5 -51 -11z m56 -121 c15 -24 -5 -42 -38 -34 -17 4 -26 13 -26 25 0 33 45 39 64 9z"/></g>',
2209         '</svg>'
2210     ))));
2211 
2212     return string(abi.encodePacked("data:image/svg+xml;base64,",svgBase64Encoded));
2213   }
2214 
2215   // WRITE
2216   function editDefaultDomain(string calldata _domainName) external {
2217     require(domains[_domainName].holder == msg.sender, "You do not own the selected domain");
2218     defaultNames[msg.sender] = _domainName;
2219     emit DefaultDomainChanged(msg.sender, _domainName);
2220   }
2221 
2222   /// @notice Edit domain custom data. Make sure to not accidentally delete previous data. Fetch previous data first.
2223   /// @param _domainName Only domain name, no TLD/extension.
2224   /// @param _data Custom data needs to be in a JSON object format.
2225   function editData(string calldata _domainName, string calldata _data) external {
2226     require(domains[_domainName].holder == msg.sender, "Only domain holder can edit their data");
2227     domains[_domainName].data = _data;
2228     emit DataChanged(msg.sender);
2229   }
2230 
2231   /// @notice Mint a new domain name as NFT (no dots and spaces allowed).
2232   /// @param _domainName Enter domain name without TLD and make sure letters are in lowercase form.
2233   /// @return token ID
2234   function mint(
2235     string memory _domainName,
2236     address _domainHolder,
2237     address _referrer
2238   ) external payable nonReentrant returns(uint256) {
2239     require(buyingEnabled || msg.sender == owner(), "Buying TLDs disabled");
2240     require(msg.value >= price, "Value below price");
2241 
2242     _sendPayment(msg.value, _referrer);
2243 
2244     return _mintDomain(_domainName, _domainHolder, "");
2245   }
2246 
2247   function _mintDomain(
2248     string memory _domainNameRaw, 
2249     address _domainHolder,
2250     string memory _data
2251   ) internal returns(uint256) {
2252     // convert domain name to lowercase (only works for ascii, clients should enforce ascii domains only)
2253     string memory _domainName = strings.lower(_domainNameRaw);
2254 
2255     require(strings.len(strings.toSlice(_domainName)) > 1, "Domain must be longer than 1 char");
2256     require(bytes(_domainName).length < nameMaxLength, "Domain name is too long");
2257     require(strings.count(strings.toSlice(_domainName), strings.toSlice(".")) == 0, "There should be no dots in the name");
2258     require(strings.count(strings.toSlice(_domainName), strings.toSlice(" ")) == 0, "There should be no spaces in the name");
2259     require(domains[_domainName].holder == address(0), "Domain with this name already exists");
2260 
2261     _safeMint(_domainHolder, totalSupply);
2262 
2263     Domain memory newDomain;
2264     
2265     // store data in Domain struct
2266     newDomain.name = _domainName;
2267     newDomain.tokenId = totalSupply;
2268     newDomain.holder = _domainHolder;
2269     newDomain.data = _data;
2270 
2271     // add to both mappings
2272     domains[_domainName] = newDomain;
2273     domainIdsNames[totalSupply] = _domainName;
2274 
2275     if (bytes(defaultNames[_domainHolder]).length == 0) {
2276       defaultNames[_domainHolder] = _domainName; // if default domain name is not set for that holder, set it now
2277     }
2278     
2279     emit DomainCreated(msg.sender, _domainHolder, string(abi.encodePacked(_domainName, name())));
2280 
2281     ++totalSupply;
2282 
2283     return totalSupply-1;
2284   }
2285 
2286   function _sendPayment(uint256 _paymentAmount, address _referrer) internal {
2287 
2288     if (_referrer != address(0) && referral > 0 && referral < 5000) {
2289       // send referral fee - must be less than 50% (5000 bips)
2290       (bool sentReferralFee, ) = payable(_referrer).call{value: ((_paymentAmount * referral) / 10000)}("");
2291       require(sentReferralFee, "Failed to send referral fee");
2292     }
2293 
2294     // send the rest to TLD owner
2295     (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
2296     require(sent, "Failed to send domain payment to TLD owner");
2297   }
2298 
2299   ///@dev Hook that is called before any token transfer. This includes minting and burning.
2300   function _beforeTokenTransfer(address from,address to,uint256 tokenId) internal override virtual {
2301 
2302     if (from != address(0)) { // run on every transfer but not on mint
2303       domains[domainIdsNames[tokenId]].holder = to; // change holder address in Domain struct
2304       domains[domainIdsNames[tokenId]].data = ""; // reset custom data
2305       
2306       if (bytes(defaultNames[to]).length == 0) {
2307         defaultNames[to] = domains[domainIdsNames[tokenId]].name; // if default domain name is not set for that holder, set it now
2308       }
2309 
2310       if (strings.equals(strings.toSlice(domains[domainIdsNames[tokenId]].name), strings.toSlice(defaultNames[from]))) {
2311         defaultNames[from] = ""; // if previous owner had this domain name as default, unset it as default
2312       }
2313     }
2314   }
2315 
2316   // OWNER
2317 
2318   /// @notice Only TLD contract owner can call this function.
2319   function changeDescription(string calldata _description) external onlyOwner {
2320     description = _description;
2321   }
2322 
2323   /// @notice Only TLD contract owner can call this function.
2324   function changeNameMaxLength(uint256 _maxLength) external onlyOwner {
2325     nameMaxLength = _maxLength;
2326   }
2327 
2328   /// @notice Only TLD contract owner can call this function.
2329   function changePrice(uint256 _price) external onlyOwner {
2330     price = _price;
2331     emit TldPriceChanged(msg.sender, _price);
2332   }
2333 
2334   function withdraw() external onlyOwner{
2335     payable(msg.sender).transfer(address(this).balance);
2336   }
2337 
2338   /// @notice Only TLD contract owner can call this function.
2339   function changeReferralFee(uint256 _referral) external onlyOwner {
2340     require(_referral < 5000, "Referral fee cannot be 50% or higher");
2341     referral = _referral; // referral must be in bips
2342     emit ReferralFeeChanged(msg.sender, _referral);
2343   }
2344 
2345   /// @notice Only TLD contract owner can call this function.
2346   function toggleBuyingDomains() external onlyOwner {
2347     buyingEnabled = !buyingEnabled;
2348     emit DomainBuyingToggle(msg.sender, buyingEnabled);
2349   }
2350 }