1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
5 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
6 import {SafeMetadata} from './SafeMetadata.sol';
7 import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
8 import {DateTime} from './DateTime.sol';
9 import './Base64.sol';
10 import {NFTSVG} from './NFTSVG.sol';
11 
12 library NFTTokenURIScaffold {
13     using SafeMetadata for IERC20;
14     using Strings for uint256;
15 
16     function tokenURI(
17         uint256 id,
18         IPair pair,
19         IPair.Due memory due,
20         uint256 maturity
21     ) public view returns (string memory) {
22         string memory uri = constructTokenSVG(
23             address(pair.asset()),
24             address(pair.collateral()),
25             id.toString(),
26             weiToPrecisionString(due.debt, pair.asset().safeDecimals()),
27             weiToPrecisionString(due.collateral, pair.collateral().safeDecimals()),
28             getReadableDateString(maturity),
29             maturity
30         );
31 
32         string memory description = string(
33             abi.encodePacked(
34                 'This collateralized debt position represents a debt of ',
35                 weiToPrecisionString(due.debt, pair.asset().safeDecimals()),
36                 ' ',
37                 pair.asset().safeSymbol(),
38                 ' borrowed against a collateral of ',
39                 weiToPrecisionString(due.collateral, pair.collateral().safeDecimals()),
40                 ' ',
41                 pair.collateral().safeSymbol(),
42                 '. This position will expire on ',
43                 maturity.toString(),
44                 ' unix epoch time.\\nThe owner of this NFT has the option to pay the debt before maturity time to claim the locked collateral. In case the owner choose to default on the debt payment, the collateral will be forfeited'
45             )
46         );
47         description = string(
48             abi.encodePacked(
49                 description,
50                 '\\n\\nAsset Address: ',
51                 addressToString(address(pair.asset())),
52                 '\\nCollateral Address: ',
53                 addressToString(address(pair.collateral())),
54                 '\\nDebt Required: ',
55                 weiToPrecisionLongString(due.debt, pair.asset().safeDecimals()),
56                 ' ',
57                 IERC20(pair.asset()).safeSymbol(),
58                 '\\nCollateral Locked: ',
59                 weiToPrecisionLongString(due.collateral, pair.collateral().safeDecimals()),
60                 ' ',
61                 IERC20(pair.collateral()).safeSymbol()
62             )
63         );
64 
65         string memory name = 'Timeswap Collateralized Debt';
66 
67         return (constructTokenURI(name, description, uri));
68     }
69 
70     function constructTokenURI(
71         string memory name,
72         string memory description,
73         string memory imageSVG
74     ) internal pure returns (string memory) {
75         return
76             string(
77                 abi.encodePacked(
78                     'data:application/json;base64,',
79                     Base64.encode(
80                         bytes(
81                             abi.encodePacked(
82                                 '{"name":"',
83                                 name,
84                                 '", "description":"',
85                                 description,
86                                 '", "image": "',
87                                 'data:image/svg+xml;base64,',
88                                 Base64.encode(bytes(imageSVG)),
89                                 '"}'
90                             )
91                         )
92                     )
93                 )
94             );
95     }
96 
97     function constructTokenSVG(
98         address asset,
99         address collateral,
100         string memory tokenId,
101         string memory assetAmount,
102         string memory collateralAmount,
103         string memory maturityDate,
104         uint256 maturityTimestamp
105     ) internal view returns (string memory) {
106         NFTSVG.SVGParams memory params = NFTSVG.SVGParams({
107             tokenId: tokenId,
108             svgTitle: string(
109                 abi.encodePacked(
110                     parseSymbol(IERC20(asset).safeSymbol()),
111                     '/',
112                     parseSymbol(IERC20(collateral).safeSymbol())
113                 )
114             ),
115             assetInfo: string(abi.encodePacked(parseSymbol(IERC20(asset).safeSymbol()), ': ', addressToString(asset))),
116             collateralInfo: string(
117                 abi.encodePacked(parseSymbol(IERC20(collateral).safeSymbol()), ': ', addressToString(collateral))
118             ),
119             debtRequired: string(abi.encodePacked(assetAmount, ' ', parseSymbol(IERC20(asset).safeSymbol()))),
120             collateralLocked: string(
121                 abi.encodePacked(collateralAmount, ' ', parseSymbol(IERC20(collateral).safeSymbol()))
122             ),
123             maturityDate: maturityDate,
124             isMatured: block.timestamp > maturityTimestamp,
125             maturityTimestampString: maturityTimestamp.toString(),
126             tokenColors: getSVGCData(asset, collateral)
127         });
128 
129         return NFTSVG.constructSVG(params);
130     }
131 
132     function weiToPrecisionLongString(uint256 weiAmt, uint256 decimal) public pure returns (string memory) {
133         if (decimal == 0) {
134             return string(abi.encodePacked(weiAmt.toString(), '.00'));
135         }
136 
137         uint256 significantDigits = weiAmt / (10**decimal);
138         uint256 precisionDigits = weiAmt % (10**(decimal));
139 
140         if (precisionDigits == 0) {
141             return string(abi.encodePacked(significantDigits.toString(), '.00'));
142         }
143 
144         string memory precisionDigitsString = toStringTrimmed(precisionDigits);
145         uint256 lengthDiff = decimal - bytes(precisionDigits.toString()).length;
146         for (uint256 i; i < lengthDiff; i++) {
147             precisionDigitsString = string(abi.encodePacked('0', precisionDigitsString));
148         }
149 
150         return string(abi.encodePacked(significantDigits.toString(), '.', precisionDigitsString));
151     }
152 
153     function weiToPrecisionString(uint256 weiAmt, uint256 decimal) public pure returns (string memory) {
154         if (decimal == 0) {
155             return string(abi.encodePacked(weiAmt.toString(), '.00'));
156         }
157 
158         uint256 significantDigits = weiAmt / (10**decimal);
159         if (significantDigits > 1e9) {
160             string memory weiAmtString = weiAmt.toString();
161             uint256 len = bytes(weiAmtString).length - 9;
162             weiAmt = weiAmt / (10**len);
163             return string(abi.encodePacked(weiAmt.toString(), '...'));
164         }
165         uint256 precisionDigits = weiAmt % (10**(decimal));
166         precisionDigits = precisionDigits / (10**(decimal - 4));
167 
168         if (precisionDigits == 0) {
169             return string(abi.encodePacked(significantDigits.toString(), '.00'));
170         }
171 
172         string memory precisionDigitsString = toStringTrimmed(precisionDigits);
173         uint256 lengthDiff = 4 - bytes(precisionDigits.toString()).length;
174         for (uint256 i; i < lengthDiff; i++) {
175             precisionDigitsString = string(abi.encodePacked('0', precisionDigitsString));
176         }
177 
178         return string(abi.encodePacked(significantDigits.toString(), '.', precisionDigitsString));
179     }
180 
181     function toStringTrimmed(uint256 value) internal pure returns (string memory) {
182         if (value == 0) {
183             return '0';
184         }
185         uint256 temp = value;
186         uint256 digits;
187         uint256 flag;
188         while (temp != 0) {
189             if (flag == 0 && temp % 10 == 0) {
190                 temp /= 10;
191                 continue;
192             } else if (flag == 0 && temp % 10 != 0) {
193                 flag++;
194                 digits++;
195             } else {
196                 digits++;
197             }
198 
199             temp /= 10;
200         }
201         bytes memory buffer = new bytes(digits);
202         flag = 0;
203         while (value != 0) {
204             if (flag == 0 && value % 10 == 0) {
205                 value /= 10;
206                 continue;
207             } else if (flag == 0 && value % 10 != 0) {
208                 flag++;
209                 digits -= 1;
210                 buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             } else {
212                 digits -= 1;
213                 buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
214             }
215 
216             value /= 10;
217         }
218         return string(buffer);
219     }
220 
221     function addressToString(address _addr) public pure returns (string memory) {
222         bytes memory data = abi.encodePacked(_addr);
223         bytes memory alphabet = '0123456789abcdef';
224 
225         bytes memory str = new bytes(2 + data.length * 2);
226         str[0] = '0';
227         str[1] = 'x';
228         for (uint256 i; i < data.length; i++) {
229             str[2 + i * 2] = alphabet[uint256(uint8(data[i] >> 4))];
230             str[3 + i * 2] = alphabet[uint256(uint8(data[i] & 0x0f))];
231         }
232         return string(str);
233     }
234 
235     function getSlice(
236         uint256 begin,
237         uint256 end,
238         string memory text
239     ) public pure returns (string memory) {
240         bytes memory a = new bytes(end - begin + 1);
241         for (uint256 i; i <= end - begin; i++) {
242             a[i] = bytes(text)[i + begin - 1];
243         }
244         return string(a);
245     }
246 
247     function parseSymbol(string memory symbol) public pure returns (string memory) {
248         if (bytes(symbol).length > 5) {
249             return getSlice(1, 5, symbol);
250         }
251         return symbol;
252     }
253 
254     function getMonthString(uint256 _month) public pure returns (string memory) {
255         string[12] memory months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
256         return months[_month];
257     }
258 
259     function getReadableDateString(uint256 timestamp) public pure returns (string memory) {
260         (uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) = DateTime
261             .timestampToDateTime(timestamp);
262 
263         string memory result = string(
264             abi.encodePacked(
265                 day.toString(),
266                 ' ',
267                 getMonthString(month - 1),
268                 ' ',
269                 year.toString(),
270                 ', ',
271                 padWithZero(hour),
272                 ':',
273                 padWithZero(minute),
274                 ':',
275                 padWithZero(second),
276                 ' UTC'
277             )
278         );
279         return result;
280     }
281 
282     function padWithZero(uint256 value) public pure returns (string memory) {
283         if (value < 10) {
284             return string(abi.encodePacked('0', value.toString()));
285         }
286         return value.toString();
287     }
288 
289     function getLightColor(address token) public pure returns (string memory) {
290         string[15] memory lightColors = [
291             'F7BAF7',
292             'F7C8BA',
293             'FAE2BE',
294             'BAE1F7',
295             'EBF7BA',
296             'CEF7BA',
297             'CED2EF',
298             'CABAF7',
299             'BAF7E5',
300             'BACFF7',
301             'F7BAE3',
302             'F7E9BA',
303             'E0BAF7',
304             'F7BACF',
305             'FFFFFF'
306         ];
307         uint160 tokenValue = uint160(token) % 15;
308         return (lightColors[tokenValue]);
309     }
310 
311     function getDarkColor(address token) public pure returns (string memory) {
312         string[15] memory darkColors = [
313             'DF51EC',
314             'EC7651',
315             'ECAE51',
316             '51B4EC',
317             'A4C327',
318             '59C327',
319             '5160EC',
320             '7951EC',
321             '27C394',
322             '5185EC',
323             'EC51B8',
324             'F4CB3A',
325             'B151EC',
326             'EC5184',
327             'C5C0C2'
328         ];
329         uint160 tokenValue = uint160(token) % 15;
330         return (darkColors[tokenValue]);
331     }
332 
333     function getSVGCData(address asset, address collateral) public pure returns (string memory) {
334         string memory token0LightColor = string(abi.encodePacked('.C{fill:#', getLightColor(asset), '}'));
335         string memory token0DarkColor = string(abi.encodePacked('.D{fill:#', getDarkColor(asset), '}'));
336         string memory token1LightColor = string(abi.encodePacked('.E{fill:#', getLightColor(collateral), '}'));
337         string memory token1DarkColor = string(abi.encodePacked('.F{fill:#', getDarkColor(collateral), '}'));
338 
339         return string(abi.encodePacked(token0LightColor, token0DarkColor, token1LightColor, token1DarkColor));
340     }
341 }
