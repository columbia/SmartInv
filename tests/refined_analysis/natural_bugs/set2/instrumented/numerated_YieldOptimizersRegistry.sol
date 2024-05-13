1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  __ __ _     _   _ _____     _   _       _                 _____         _     _           
18 // |  |  |_|___| |_| |     |___| |_|_|_____|_|___ ___ ___ ___| __  |___ ___|_|___| |_ ___ _ _ 
19 // |_   _| | -_| | . |  |  | . |  _| |     | |- _| -_|  _|_ -|    -| -_| . | |_ -|  _|  _| | |
20 //   |_| |_|___|_|___|_____|  _|_| |_|_|_|_|_|___|___|_| |___|__|__|___|_  |_|___|_| |_| |_  |
21 //                         |_|                                         |___|             |___|
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {IFortressCompounder} from "src/shared/fortress-interfaces/IFortressCompounder.sol";
26 import {IFortressConcentrator} from "src/shared/fortress-interfaces/IFortressConcentrator.sol";
27 
28 contract YieldOptimizersRegistry {
29 
30     // -------------- Compounders --------------
31 
32     // Curve Compounders
33 
34     /// @notice The list of Curve Compounder Vaults primary assets
35     address[] public curveCompoundersPrimaryAssets;
36 
37     /// @notice The mapping from Primary Asset to Curve Compounder Vault address
38     mapping(address => address) public curveCompounders;
39 
40     // Balancer Compounders
41 
42     /// @notice The list of Balancer Compounder Vaults primary assets
43     address[] public balancerCompoundersPrimaryAssets;
44 
45     /// @notice The mapping from Primary Asset to Balancer Compounder Vault address
46     mapping(address => address) public balancerCompounders;
47 
48     // Token Compounders
49 
50     /// @notice The list of TokenCompounder primary assets
51     address[] public tokenCompoundersPrimaryAssets;
52 
53     /// @notice The mapping from Primary Asset to Token Compounder Vault address
54     mapping(address => address) public tokenCompounders;
55 
56     // -------------- Concentrators --------------
57 
58     struct TargetAsset {
59         address fortETH;
60         address fortUSD;
61         address fortCrypto1; 
62         address fortCrypto2;
63     }
64     
65     // Concentrators Target Assets
66 
67     /// @notice The instance of Concentrator Target Assets
68     TargetAsset public concentratorTargetAssets;
69 
70     // Curve Concentrators
71 
72     /// @notice The list of Curve ETH Concentrator Vaults primary assets
73     address[] public curveEthConcentratorsPrimaryAssets;
74     
75     /// @notice The list of Curve USD Concentrator Vaults primary assets
76     address[] public curveUsdConcentratorsPrimaryAssets;
77 
78     /// @notice The list of Curve Crypto1 Concentrator Vaults primary assets
79     address[] public curveCrypto1ConcentratorsPrimaryAssets;
80 
81     /// @notice The list of Curve Crypto2 Concentrator Vaults primary assets
82     address[] public curveCrypto2ConcentratorsPrimaryAssets;
83 
84     /// @notice The mapping from Primary Asset to Curve ETH Concentrator Vault address
85     mapping(address => address) public curveEthConcentrators;
86 
87     /// @notice The mapping from Primary Asset to Curve USD Concentrator Vault address
88     mapping(address => address) public curveUsdConcentrators;
89 
90     /// @notice The mapping from Primary Asset to Curve Crypto1 Concentrator Vault address
91     mapping(address => address) public curveCrypto1Concentrators;
92 
93     /// @notice The mapping from Primary Asset to Curve Crypto2 Concentrator Vault address
94     mapping(address => address) public curveCrypto2Concentrators;
95 
96     // Balancer Concentrators
97 
98     /// @notice The list of Balancer ETH Concentrator Vaults primary assets
99     address[] public balancerEthConcentratorsPrimaryAssets;
100     
101     /// @notice The list of Balancer USD Concentrator Vaults primary assets
102     address[] public balancerUsdConcentratorsPrimaryAssets;
103 
104     /// @notice The list of Balancer Crypto1 Concentrator Vaults primary assets
105     address[] public balancerCrypto1ConcentratorsPrimaryAssets;
106 
107     /// @notice The list of Balancer Crypto2 Concentrator Vaults primary assets
108     address[] public balancerCrypto2ConcentratorsPrimaryAssets;
109 
110     /// @notice The mapping from Primary Asset to Balancer ETH Concentrator Vault address
111     mapping(address => address) public balancerEthConcentrators;
112 
113     /// @notice The mapping from Primary Asset to Balancer USD Concentrator Vault address
114     mapping(address => address) public balancerUsdConcentrators;
115 
116     /// @notice The mapping from Primary Asset to Balancer Crypto1 Concentrator Vault address
117     mapping(address => address) public balancerCrypto1Concentrators;
118 
119     /// @notice The mapping from Primary Asset to Balancer Crypto2 Concentrator Vault address
120     mapping(address => address) public balancerCrypto2Concentrators;
121 
122     // -------------- Settings --------------
123 
124     /// @notice The addresses of the contract owners
125     address[2] public owners;
126 
127     // ********************* Constructor *********************
128 
129     constructor(address _owner) {
130         owners[0] = _owner;
131     }
132 
133     // ********************* View Functions *********************
134     
135     // -----------------------------------------------------------
136     // --------------------- AMM Compounders ---------------------
137     // -----------------------------------------------------------
138 
139     /// @dev Get the list of addresses of the Primary Assets of all Compounder vaults for a specific AMM
140     /// @return _primaryAssets - The list of addresses of the Primary Assets
141     function getAmmCompoundersPrimaryAssets(bool _isCurve) external view returns (address[] memory _primaryAssets) {
142         if (_isCurve) {
143             return curveCompoundersPrimaryAssets;
144         } else {
145             return balancerCompoundersPrimaryAssets;
146         }
147     }
148 
149     /// @dev Get the address of a Compounder Vault for a specific AMM and Primary Asset
150     /// @return _compounderVault - The address of the Compounder Vault
151     function getAmmCompounderVault(bool _isCurve, address _asset) public view returns (address _compounderVault) {
152         if (_isCurve) {
153             return curveCompounders[_asset];
154         } else {
155             return balancerCompounders[_asset];
156         }
157     }
158 
159     /// @dev Get the address of all underlying assets for a specific AMM and Primary Asset
160     /// @return - The list of addresses of underlying assets
161     function getAmmCompounderUnderlyingAssets(bool _isCurve, address _asset) external view returns (address[] memory) {
162         return IFortressCompounder(getAmmCompounderVault(_isCurve, _asset)).getUnderlyingAssets();
163     }
164 
165     /// @dev Get the name of a Compounder Vault for a specific AMM and Primary Asset
166     /// @return - The name of the Compounder Vault
167     function getAmmCompounderName(bool _isCurve, address _asset) external view returns (string memory) {
168         return IFortressCompounder(getAmmCompounderVault(_isCurve, _asset)).getName();
169     }
170 
171     /// @dev Get the symbol of a Compounder Vault for a specific AMM and Primary Asset
172     /// @return - The symbol of the Compounder Vault
173     function getAmmCompounderSymbol(bool _isCurve, address _asset) external view returns (string memory) {
174         return IFortressCompounder(getAmmCompounderVault(_isCurve, _asset)).getSymbol();
175     }
176 
177     /// @dev Get the description of a Compounder Vault for a specific AMM and Primary Asset
178     /// @return - The description of the Compounder Vault
179     function getAmmCompounderDescription(bool _isCurve, address _asset) external view returns (string memory) {
180         return IFortressCompounder(getAmmCompounderVault(_isCurve, _asset)).getDescription();
181     }
182 
183     // -------------------------------------------------------------
184     // --------------------- Token Compounders ---------------------
185     // -------------------------------------------------------------
186 
187     /// @dev Get the addresses of the Primary Assets of all Token Compounder vaults
188     /// @return - The list of addresses of Primary Assets
189     function getTokenCompoundersPrimaryAssets() external view returns (address[] memory) {
190         return tokenCompoundersPrimaryAssets;
191     }
192 
193     /// @dev Get the address of a Token Compounder Vault for a specific Primary Asset
194     /// @return - The address of the Token Compounder Vault
195     function getTokenCompounderVault(address _asset) public view returns (address) {
196         return tokenCompounders[_asset];
197     }
198 
199     /// @dev Get the address of all underlying assets for a specific Token Compounder Vault given AMMType and Primary Asset
200     /// @return - The list of addresses of underlying assets
201     function getTokenCompounderUnderlyingAssets(address _asset) external view returns (address[] memory) {
202         return IFortressCompounder(getTokenCompounderVault(_asset)).getUnderlyingAssets();
203     }
204 
205     /// @dev Get the name of a Token Compounder Vault for a specific Primary Asset
206     /// @return - The name of the Token Compounder Vault
207     function getTokenCompounderName(address _asset) external view returns (string memory) {
208         return IFortressCompounder(getTokenCompounderVault(_asset)).getName();
209     }
210 
211     /// @dev Get the symbol of a Token Compounder Vault for a specific Primary Asset
212     /// @return - The symbol of the Token Compounder Vault
213     function getTokenCompounderSymbol(address _asset) external view returns (string memory) {
214         return IFortressCompounder(getTokenCompounderVault(_asset)).getSymbol();
215     }
216 
217     /// @dev Get the description of a Compounder Vault for a specific AMMType and Primary Asset
218     /// @return - The description of the Compounder Vault
219     function getTokenCompounderDescription(address _asset) external view returns (string memory) {
220         return IFortressCompounder(getTokenCompounderVault(_asset)).getDescription();
221     }
222 
223     // -------------------------------------------------------------
224     // --------------------- AMM Concentrators ---------------------
225     // -------------------------------------------------------------
226 
227     /// @dev Get the addresses of Primary Assets of all AMM Concentrator vaults for a specific AMM and Target Asset
228     /// @return _primaryAssets - The list of addresses of Primary Assets
229     function getConcentratorPrimaryAssets(bool _isCurve, address _targetAsset) external view returns (address[] memory _primaryAssets) {
230         TargetAsset memory _concentratorTargetAssets = concentratorTargetAssets;
231         if (_isCurve) {
232             if (_targetAsset == _concentratorTargetAssets.fortETH) {
233                 return curveEthConcentratorsPrimaryAssets;
234             } else if (_targetAsset == _concentratorTargetAssets.fortUSD) {
235                 return curveUsdConcentratorsPrimaryAssets;
236             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto1) {
237                 return curveCrypto1ConcentratorsPrimaryAssets;
238             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto2) {
239                 return curveCrypto2ConcentratorsPrimaryAssets;
240             } else {
241                 revert InvalidTargetAsset();
242             }
243         } else {
244             if (_targetAsset == _concentratorTargetAssets.fortETH) {
245                 return balancerEthConcentratorsPrimaryAssets;
246             } else if (_targetAsset == _concentratorTargetAssets.fortUSD) {
247                 return balancerUsdConcentratorsPrimaryAssets;
248             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto1) {
249                 return balancerCrypto1ConcentratorsPrimaryAssets;
250             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto2) {
251                 return balancerCrypto2ConcentratorsPrimaryAssets;
252             } else {
253                 revert InvalidTargetAsset();
254             }
255         }
256     }
257 
258     /// @dev Get the address of a Concentrator Vault for a specific AMM, Target Asset, and Primary Asset
259     /// @return _concentrator - The address of the Concentrator Vault
260     function getConcentrator(bool _isCurve, address _targetAsset, address _primaryAsset) public view returns (address _concentrator) {
261         TargetAsset memory _concentratorTargetAssets = concentratorTargetAssets;
262         if (_isCurve) {
263             if (_targetAsset == _concentratorTargetAssets.fortETH) {
264                 return curveEthConcentrators[_primaryAsset];
265             } else if (_targetAsset == _concentratorTargetAssets.fortUSD) {
266                 return curveUsdConcentrators[_primaryAsset];
267             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto1) {
268                 return curveCrypto1Concentrators[_primaryAsset];
269             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto2) {
270                 return curveCrypto2Concentrators[_primaryAsset];
271             } else {
272                 revert InvalidTargetAsset();
273             }
274         } else {
275             if (_targetAsset == _concentratorTargetAssets.fortETH) {
276                 return balancerEthConcentrators[_primaryAsset];
277             } else if (_targetAsset == _concentratorTargetAssets.fortUSD) {
278                 return balancerUsdConcentrators[_primaryAsset];
279             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto1) {
280                 return balancerCrypto1Concentrators[_primaryAsset];
281             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto2) {
282                 return balancerCrypto2Concentrators[_primaryAsset];
283             } else {
284                 revert InvalidTargetAsset();
285             }
286         }
287     }
288 
289     /// @dev Get the symbol of a Concentrator Vault for a specific AMM, Target Asset, and Primary Asset
290     /// @return - The symbol of the Concentrator Vault
291     function getConcentratorSymbol(bool _isCurve, address _targetAsset, address _asset) external view returns (string memory) {
292         return IFortressConcentrator(getConcentrator(_isCurve, _targetAsset, _asset)).getSymbol();
293     }
294 
295     /// @dev Get the name of a Concentrator Vault for a specific AMM, Target Asset, and Primary Asset
296     /// @return - The name of the Concentrator Vault
297     function getConcentratorName(bool _isCurve, address _targetAsset, address _asset) external view returns (string memory) {
298         return IFortressConcentrator(getConcentrator(_isCurve, _targetAsset, _asset)).getName();
299     }
300 
301     /// @dev Get the description of a Concentrator Vault for a specific AMM, Target Asset, and Primary Asset
302     /// @return - The description of the Concentrator Vault
303     function getConcentratorDescription(bool _isCurve, address _targetAsset, address _asset) external view returns (string memory) {
304         return IFortressConcentrator(getConcentrator(_isCurve, _targetAsset, _asset)).getDescription();
305     }
306 
307     /// @dev Get the underlying assets of a Concentrator Vault for a specific AMM, Target Asset, and Primary Asset
308     /// @return - The list of addresses of underlying assets
309     function getConcentratorUnderlyingAssets(bool _isCurve, address _targetAsset, address _asset) external view returns (address[] memory) {
310         return IFortressConcentrator(getConcentrator(_isCurve, _targetAsset, _asset)).getUnderlyingAssets();
311     }
312 
313     /// @dev Get the target asset of a Concentrator Vault for a specific AMM, Target Asset, and Primary Asset
314     /// @return - The address of the target asset, which is a Fortress Compounder Vault
315     function getConcentratorTargetVault(bool _isCurve, address _targetAsset, address _asset) external view returns (address) {
316         return IFortressConcentrator(getConcentrator(_isCurve, _targetAsset, _asset)).getCompounder();
317     }
318 
319     // ********************* Modifiers *********************
320 
321     modifier onlyOwner {
322         if (msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
323         _;
324     }
325 
326     // ********************* Restricted Functions *********************
327 
328     /// @dev Register a new AMM Compounder Vault
329     /// @param _isCurve - The AMM Type of the Compounder, True for Curve, False for Balancer
330     /// @param _compounder - The address of the Compounder
331     /// @param _primaryAsset - The address of the Primary Asset
332     function registerAmmCompounder(bool _isCurve, address _compounder, address _primaryAsset) onlyOwner external {
333         if (_isCurve) {
334             if (curveCompounders[_primaryAsset] != address(0)) revert AlreadyRegistered();
335 
336             curveCompounders[_primaryAsset] = _compounder;
337             curveCompoundersPrimaryAssets.push(_primaryAsset);
338         } else {
339             if (balancerCompounders[_primaryAsset] != address(0)) revert AlreadyRegistered();
340 
341             balancerCompounders[_primaryAsset] = _compounder;
342             balancerCompoundersPrimaryAssets.push(_primaryAsset);
343         }
344         
345         emit RegisterAMMCompounder(_isCurve, _compounder, _primaryAsset);
346     }
347 
348     /// @dev Register a new Token Compounder Vault
349     /// @param _compounder - The address of the Compounder
350     /// @param _primaryAsset - The address of the Primary Asset
351     function registerTokenCompounder(address _compounder, address _primaryAsset) onlyOwner external {
352         if (tokenCompounders[_primaryAsset] != address(0)) revert AlreadyRegistered();
353 
354         tokenCompounders[_primaryAsset] = _compounder;
355         tokenCompoundersPrimaryAssets.push(_primaryAsset);
356 
357         emit RegisterTokenCompounder(_compounder, _primaryAsset);
358     }
359 
360     /// @dev Register a new Concentrator Vault
361     /// @param _isCurve - The AMM Type of the Compounder, True for Curve, False for Balancer
362     /// @param _concentrator - The address of the Concentrator
363     /// @param _targetAsset - The address of the Target Asset
364     /// @param _primaryAsset - The address of the Primary Asset
365     function registerAmmConcentrator(bool _isCurve, address _concentrator, address _targetAsset, address _primaryAsset) onlyOwner external {
366         TargetAsset memory _concentratorTargetAssets = concentratorTargetAssets;
367         
368         if (_isCurve) {
369             if (_targetAsset == _concentratorTargetAssets.fortETH) {
370                 if (curveEthConcentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
371                 curveEthConcentrators[_primaryAsset] = _concentrator;
372                 curveEthConcentratorsPrimaryAssets.push(_primaryAsset);
373             } else if (_targetAsset == _concentratorTargetAssets.fortUSD) {
374                 if (curveUsdConcentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
375                 curveUsdConcentrators[_primaryAsset] = _concentrator;
376                 curveUsdConcentratorsPrimaryAssets.push(_primaryAsset);
377             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto1) {
378                 if (curveCrypto1Concentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
379                 curveCrypto1Concentrators[_primaryAsset] = _concentrator;
380                 curveCrypto1ConcentratorsPrimaryAssets.push(_primaryAsset);
381             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto2) {
382                 if (curveCrypto2Concentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
383                 curveCrypto2Concentrators[_primaryAsset] = _concentrator;
384                 curveCrypto2ConcentratorsPrimaryAssets.push(_primaryAsset);
385             } else {
386                 revert InvalidTargetAsset();
387             }
388         } else {
389             if (_targetAsset == _concentratorTargetAssets.fortETH) {
390                 if (balancerEthConcentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
391                 balancerEthConcentrators[_primaryAsset] = _concentrator;
392                 balancerEthConcentratorsPrimaryAssets.push(_primaryAsset);
393             } else if (_targetAsset == _concentratorTargetAssets.fortUSD) {
394                 if (balancerUsdConcentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
395                 balancerUsdConcentrators[_primaryAsset] = _concentrator;
396                 balancerUsdConcentratorsPrimaryAssets.push(_primaryAsset);
397             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto1) {
398                 if (balancerCrypto1Concentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
399                 balancerCrypto1Concentrators[_primaryAsset] = _concentrator;
400                 balancerCrypto1ConcentratorsPrimaryAssets.push(_primaryAsset);
401             } else if (_targetAsset == _concentratorTargetAssets.fortCrypto2) {
402                 if (balancerCrypto2Concentrators[_primaryAsset] != address(0)) revert AlreadyRegistered();
403                 balancerCrypto2Concentrators[_primaryAsset] = _concentrator;
404                 balancerCrypto2ConcentratorsPrimaryAssets.push(_primaryAsset);
405             } else {
406                 revert InvalidTargetAsset();
407             }
408         }
409 
410         emit RegisterAMMConcentrator(_isCurve, _concentrator, _targetAsset, _primaryAsset);
411     }
412 
413     /// @dev Update the addresses of the Concentrator's Target Asset Vaults
414     /// @param _fortETH - The address of the Fortress Auto-Manager Vault for ETH
415     /// @param _fortUSD - The address of the Fortress Auto-Manager Vault for USD
416     /// @param _fortCrypto1 - The address of the Fortress Auto-Manager Vault for Market exposure
417     /// @param _fortCrypto2 - The address of the Fortress Auto-Manager Vault for Market exposure
418     function updateConcentratorsTargetAssets(address _fortETH, address _fortUSD, address _fortCrypto1, address _fortCrypto2) onlyOwner external {
419         TargetAsset storage _concentratorTargetAssets = concentratorTargetAssets;
420 
421         _concentratorTargetAssets.fortETH = _fortETH;
422         _concentratorTargetAssets.fortUSD = _fortUSD;
423         _concentratorTargetAssets.fortCrypto1 = _fortCrypto1;
424         _concentratorTargetAssets.fortCrypto2 = _fortCrypto2;
425 
426         emit UpdateConcentratorsTargetAssets(_fortETH, _fortUSD, _fortCrypto1, _fortCrypto2);
427     }
428 
429     /// @dev Update the list of owners.
430     /// @param _index - The slot on the list.
431     /// @param _owner - The address of the new owner.
432     function updateOwner(uint256 _index, address _owner) onlyOwner external {
433         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
434 
435         owners[_index] = _owner;
436 
437         emit UpdateOwner(_index, _owner);
438     }
439 
440     /********************************** Events & Errors **********************************/
441 
442     event RegisterAMMCompounder(bool indexed _isCurve, address _compounder, address _primaryAsset);
443     event RegisterAMMConcentrator(bool indexed _isCurve, address _concentrator, address _targetAsset, address _primaryAsset);
444     event RegisterTokenCompounder(address _compounder, address _primaryAsset);
445     event UpdateConcentratorsTargetAssets(address _fortETH, address _fortUSD, address _fortCrypto1, address _fortCrypto2);
446     event UpdateOwner(uint256 _index, address _owner);
447     
448     error Unauthorized();
449     error AlreadyRegistered();
450     error InvalidTargetAsset();
451     error InvalidAMMType();
452 }