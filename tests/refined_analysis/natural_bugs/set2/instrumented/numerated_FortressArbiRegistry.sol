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
17 //  _____         _                   _____     _   _ _____         _     _           
18 // |   __|___ ___| |_ ___ ___ ___ ___|  _  |___| |_|_| __  |___ ___|_|___| |_ ___ _ _ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|     |  _| . | |    -| -_| . | |_ -|  _|  _| | |
20 // |__|  |___|_| |_| |_| |___|___|___|__|__|_| |___|_|__|__|___|_  |_|___|_| |_| |_  |
21 //                                                             |___|             |___|
22 
23 // Github - https://github.com/FortressFinance
24 
25 contract FortressArbiRegistry {
26 
27     struct AMMCompounder {
28         string symbol;
29         string name;
30         address compounder;
31         address[] underlyingAssets;
32     }
33 
34     struct TokenCompounder {
35         string symbol;
36         string name;
37         address compounder;
38     }
39 
40     struct AMMConcentrator {
41         string symbol;
42         string name;
43         address concentrator;
44         address compounder;
45         address[] underlyingAssets;
46     }
47 
48     /// @notice The list of CurveCompounder assets.
49     address[] public curveCompoundersList;
50     /// @notice The list of BalancerCompounder assets.
51     address[] public balancerCompoundersList;
52     /// @notice The list of TokenCompounder assets.
53     address[] public tokenCompoundersList;
54     /// @notice The list of balancerGlpConcentrators assets.
55     address[] public balancerGlpConcentratorsList;
56     /// @notice The list of balancerEthConcentrators assets.
57     address[] public balancerEthConcentratorsList;
58     /// @notice The list of curveGlpConcentrators assets.
59     address[] public curveGlpConcentratorsList;
60     /// @notice The list of curveEthConcentrators assets.
61     address[] public curveEthConcentratorsList;
62     /// @notice The mapping from vault asset to CurveCompounder info.
63     mapping(address => AMMCompounder) public curveCompounders;
64     /// @notice The mapping from vault asset to BalancerCompounder info.
65     mapping(address => AMMCompounder) public balancerCompounders;
66     /// @notice The mapping from vault asset to TokenCompounder info.
67     mapping(address => TokenCompounder) public tokenCompounders;
68     /// @notice The mapping from vault asset to Balancer GLP Concentrator info.
69     mapping(address => AMMConcentrator) public balancerGlpConcentrators;
70     /// @notice The mapping from vault asset to Balancer ETH Concentrator info.
71     mapping(address => AMMConcentrator) public balancerEthConcentrators;
72     /// @notice The mapping from vault asset to Curve Glp Concentrator info.
73     mapping(address => AMMConcentrator) public curveGlpConcentrators;
74     /// @notice The mapping from vault asset to Curve ETH Concentrator info.
75     mapping(address => AMMConcentrator) public curveEthConcentrators;
76     /// @notice The addresses of the contract owners.
77     address[2] public owners;
78 
79     /********************************** Constructor **********************************/
80 
81     constructor(address _owner) {
82         owners[0] = _owner;
83     }
84 
85     /********************************** View Functions **********************************/
86 
87     /** Curve Compounder **/
88 
89     /// @dev Get the list of addresses of CurveCompounders assets.
90     /// @return - The list of addresses.
91     function getCurveCompoundersList() public view returns (address[] memory) {
92         return curveCompoundersList;
93     }
94 
95     /// @dev Get the CurveCompounder of a specific asset.
96     /// @param _asset - The asset address.
97     /// @return - The address of the specific CurveCompounder.
98     function getCurveCompounder(address _asset) public view returns (address) {
99         return curveCompounders[_asset].compounder;
100     }
101 
102     /// @dev Get the symbol of the receipt token of a specific CurveCompounder.
103     /// @param _asset - The asset address.
104     /// @return - The symbol of the receipt token.
105     function getCurveCompounderSymbol(address _asset) public view returns (string memory) {
106         return curveCompounders[_asset].symbol;
107     }
108 
109     /// @dev Get the name of the receipt token of a specific CurveCompounder.
110     /// @param _asset - The asset address.
111     /// @return - The name of the receipt token.
112     function getCurveCompounderName(address _asset) public view returns (string memory) {
113         return curveCompounders[_asset].name;
114     }
115 
116     /// @dev Get the underlying assets of a specific CurveCompounder.
117     /// @param _asset - The asset address.
118     /// @return - The addresses of underlying assets.
119     function getCurveCompounderUnderlyingAssets(address _asset) public view returns (address[] memory) {
120         return curveCompounders[_asset].underlyingAssets;
121     }
122 
123     /** Balancer Compounder **/
124 
125     /// @dev Get the list of addresses of BalancerCompounders assets.
126     /// @return - The list of addresses.
127     function getBalancerCompoundersList() public view returns (address[] memory) {
128         return balancerCompoundersList;
129     }
130 
131     /// @dev Get the BalancerCompounder of a specific asset.
132     /// @param _asset - The asset address.
133     /// @return - The address of the specific BalancerCompounder.
134     function getBalancerCompounder(address _asset) public view returns (address) {
135         return balancerCompounders[_asset].compounder;
136     }
137 
138     /// @dev Get the symbol of the receipt token of a specific BalancerCompounder.
139     /// @param _asset - The asset address.
140     /// @return - The symbol of the receipt token.
141     function getBalancerCompounderSymbol(address _asset) public view returns (string memory) {
142         return balancerCompounders[_asset].symbol;
143     }
144 
145     /// @dev Get the name of the receipt token of a specific BalancerCompounder.
146     /// @param _asset - The asset address.
147     /// @return - The name of the receipt token.
148     function getBalancerCompounderName(address _asset) public view returns (string memory) {
149         return balancerCompounders[_asset].name;
150     }
151 
152     /// @dev Get the underlying assets of a specific CurveCompounder.
153     /// @param _asset - The asset address.
154     /// @return - The addresses of underlying assets.
155     function getBalancerCompounderUnderlyingAssets(address _asset) public view returns (address[] memory) {
156         return balancerCompounders[_asset].underlyingAssets;
157     }
158 
159     /** Token Compounder **/
160 
161     /// @dev Get the list of addresses of TokenCompounders assets.
162     /// @return - The list of addresses.
163     function getTokenCompoundersList() public view returns (address[] memory) {
164         return tokenCompoundersList;
165     }
166 
167     /// @dev Get the TokenCompounder of a specific asset.
168     /// @param _asset - The asset address.
169     /// @return - The address of the specific BalancerCompounder.
170     function getTokenCompounder(address _asset) public view returns (address) {
171         return tokenCompounders[_asset].compounder;
172     }
173 
174     /// @dev Get the symbol of the receipt token of a specific TokenCompounder.
175     /// @param _asset - The asset address.
176     /// @return - The symbol of the receipt token.
177     function getTokenCompounderSymbol(address _asset) public view returns (string memory) {
178         return tokenCompounders[_asset].symbol;
179     }
180 
181     /// @dev Get the name of the receipt token of a specific TokenCompounder.
182     /// @param _asset - The asset address.
183     /// @return - The name of the receipt token.
184     function getTokenCompounderName(address _asset) public view returns (string memory) {
185         return tokenCompounders[_asset].name;
186     }
187 
188     /** Balancer GLP Concentrator **/
189 
190     /// @dev Get the list of addresses of BalancerGlpConcentrators assets.
191     /// @return - The list of addresses.
192     function getBalancerGlpConcentratorsList() public view returns (address[] memory) {
193         return balancerGlpConcentratorsList;
194     }
195 
196     /// @dev Get the BalancerGlpConcentrator of a specific asset.
197     /// @param _asset - The asset address.
198     /// @return - The address of a specific BalancerGlpConcentrator.
199     function getBalancerGlpConcentrator(address _asset) public view returns (address) {
200         return balancerGlpConcentrators[_asset].concentrator;
201     }
202 
203     /// @dev Get the BalancerGlpConcentrator Compounder of a specific asset.
204     /// @param _asset - The asset address.
205     /// @return - The address of the specific BalancerGlpConcentrator Compounder.
206     function getBalancerGlpConcentratorCompounder(address _asset) public view returns (address) {
207         return balancerGlpConcentrators[_asset].compounder;
208     }
209 
210     /// @dev Get the symbol of the receipt token of a specific BalancerGlpConcentrator.
211     /// @param _asset - The asset address.
212     /// @return - The symbol of the receipt token.
213     function getBalancerGlpConcentratorSymbol(address _asset) public view returns (string memory) {
214         return balancerGlpConcentrators[_asset].symbol;
215     }
216 
217     /// @dev Get the name of the receipt token of a specific BalancerGlpConcentrator.
218     /// @param _asset - The asset address.
219     /// @return - The name of the receipt token.
220     function getBalancerGlpConcentratorName(address _asset) public view returns (string memory) {
221         return balancerGlpConcentrators[_asset].name;
222     }
223 
224     /// @dev Get the underlying assets of a specific BalancerGlpConcentrator.
225     /// @param _asset - The asset address.
226     /// @return - The addresses of underlying assets.
227     function getBalancerGlpConcentratorUnderlyingAssets(address _asset) public view returns (address[] memory) {
228         return balancerGlpConcentrators[_asset].underlyingAssets;
229     }
230 
231     /** Balancer ETH Concentrator **/ 
232     
233     /// @dev Get the list of addresses of BalancerEthConcentrators assets.
234     /// @return - The list of addresses.
235     function getBalancerEthConcentratorsList() public view returns (address[] memory) {
236         return balancerEthConcentratorsList;
237     }
238 
239     /// @dev Get the BalancerEthConcentrators of a specific asset.
240     /// @param _asset - The asset address.
241     /// @return - The address of a specific BalancerEthConcentrators.
242     function getBalancerEthConcentrators(address _asset) public view returns (address) {
243         return balancerEthConcentrators[_asset].concentrator;
244     }
245 
246     /// @dev Get the BalancerEthConcentrators Compounder of a specific asset.
247     /// @param _asset - The asset address.
248     /// @return - The address of the specific BalancerEthConcentrators Compounder.
249     function getBalancerEthConcentratorCompounder(address _asset) public view returns (address) {
250         return balancerEthConcentrators[_asset].compounder;
251     }
252 
253     /// @dev Get the symbol of the receipt token of a specific BalancerEthConcentrators.
254     /// @param _asset - The asset address.
255     /// @return - The symbol of the receipt token.
256     function getBalancerEthConcentratorsSymbol(address _asset) public view returns (string memory) {
257         return balancerEthConcentrators[_asset].symbol;
258     }
259 
260     /// @dev Get the name of the receipt token of a specific BalancerEthConcentrators.
261     /// @param _asset - The asset address.
262     /// @return - The name of the receipt token.
263     function getBalancerEthConcentratorsName(address _asset) public view returns (string memory) {
264         return balancerEthConcentrators[_asset].name;
265     }
266 
267     /// @dev Get the underlying assets of a specific BalancerEthConcentrators.
268     /// @param _asset - The asset address.
269     /// @return - The addresses of underlying assets.
270     function getBalancerEthConcentratorsUnderlyingAssets(address _asset) public view returns (address[] memory) {
271         return balancerEthConcentrators[_asset].underlyingAssets;
272     }
273 
274     /** Curve GLP Concentrator **/
275 
276     /// @dev Get the list of addresses of CurveGlpConcentrators assets.
277     /// @return - The list of addresses.
278     function getCurveGlpConcentratorsList() public view returns (address[] memory) {
279         return curveGlpConcentratorsList;
280     }
281 
282     /// @dev Get the CurveGlpConcentrator of a specific asset.
283     /// @param _asset - The asset address.
284     /// @return - The address of a specific CurveGlpConcentrator.
285     function getCurveGlpConcentrator(address _asset) public view returns (address) {
286         return curveGlpConcentrators[_asset].concentrator;
287     }
288 
289     /// @dev Get the CurveGlpConcentrator Compounder of a specific asset.
290     /// @param _asset - The asset address.
291     /// @return - The address of the specific CurveGlpConcentrator Compounder.
292     function getCurveGlpConcentratorCompounder(address _asset) public view returns (address) {
293         return curveGlpConcentrators[_asset].compounder;
294     }
295 
296     /// @dev Get the symbol of the receipt token of a specific CurveGlpConcentrator.
297     /// @param _asset - The asset address.
298     /// @return - The symbol of the receipt token.
299     function getCurveGlpConcentratorSymbol(address _asset) public view returns (string memory) {
300         return curveGlpConcentrators[_asset].symbol;
301     }
302 
303     /// @dev Get the name of the receipt token of a specific CurveGlpConcentrator.
304     /// @param _asset - The asset address.
305     /// @return - The name of the receipt token.
306     function getCurveGlpConcentratorName(address _asset) public view returns (string memory) {
307         return curveGlpConcentrators[_asset].name;
308     }
309 
310     /// @dev Get the underlying assets of a specific CurveGlpConcentrator.
311     /// @param _asset - The asset address.
312     /// @return - The addresses of underlying assets.
313     function getCurveGlpConcentratorUnderlyingAssets(address _asset) public view returns (address[] memory) {
314         return curveGlpConcentrators[_asset].underlyingAssets;
315     }
316 
317     /** Curve ETH Concentrator **/
318 
319     /// @dev Get the list of addresses of CurveEthConcentrators assets.
320     /// @return - The list of addresses.
321     function getCurveEthConcentratorsList() public view returns (address[] memory) {
322         return curveEthConcentratorsList;
323     }
324 
325     /// @dev Get the CurveEthConcentrators of a specific asset.
326     /// @param _asset - The asset address.
327     /// @return - The address of a specific CurveEthConcentrators.
328     function getCurveEthConcentrators(address _asset) public view returns (address) {
329         return curveEthConcentrators[_asset].concentrator;
330     }
331 
332     /// @dev Get the CurveEthConcentrators Compounder of a specific asset.
333     /// @param _asset - The asset address.
334     /// @return - The address of the specific CurveEthConcentrators Compounder.
335     function getCurveEthConcentratorsCompounder(address _asset) public view returns (address) {
336         return curveEthConcentrators[_asset].compounder;
337     }
338 
339     /// @dev Get the symbol of the receipt token of a specific CurveEthConcentrators.
340     /// @param _asset - The asset address.
341     /// @return - The symbol of the receipt token.
342     function getCurveEthConcentratorsSymbol(address _asset) public view returns (string memory) {
343         return curveEthConcentrators[_asset].symbol;
344     }
345 
346     /// @dev Get the name of the receipt token of a specific CurveEthConcentrators.
347     /// @param _asset - The asset address.
348     /// @return - The name of the receipt token.
349     function getCurveEthConcentratorsName(address _asset) public view returns (string memory) {
350         return curveEthConcentrators[_asset].name;
351     }
352 
353     /// @dev Get the underlying assets of a specific CurveEthConcentrators.
354     /// @param _asset - The asset address.
355     /// @return - The addresses of underlying assets.
356     function getCurveEthConcentratorsUnderlyingAssets(address _asset) public view returns (address[] memory) {
357         return curveEthConcentrators[_asset].underlyingAssets;
358     }
359 
360     /********************************** Restricted Functions **********************************/
361 
362     /// @dev Register a CurveCompounder.
363     /// @param _compounder - The address of the Compounder.
364     /// @param _asset - The address of the asset.
365     /// @param _symbol - The symbol of the receipt token.
366     /// @param _name - The name of the receipt token.
367     /// @param _underlyingAssets - The addresses of the underlying assets.
368     function registerCurveCompounder(address _compounder, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets) public {
369         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
370         if(curveCompounders[_asset].compounder != address(0)) revert AlreadyRegistered();
371 
372         curveCompounders[_asset] = AMMCompounder({
373             symbol: _symbol,
374             name: _name,
375             compounder: _compounder,
376             underlyingAssets: _underlyingAssets
377         });
378 
379         curveCompoundersList.push(_asset);
380         emit RegisterCurveCompounder(_compounder, _asset, _symbol, _name, _underlyingAssets);
381     }
382 
383     /// @dev Register a BalancerCompounder.
384     /// @param _compounder - The address of the Compounder.
385     /// @param _asset - The address of the asset.
386     /// @param _symbol - The symbol of the receipt token.
387     /// @param _name - The name of the receipt token.
388     /// @param _underlyingAssets - The addresses of the underlying assets.
389     function registerBalancerCompounder(address _compounder, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets) public {
390         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
391         if(curveCompounders[_asset].compounder != address(0)) revert AlreadyRegistered();
392 
393         balancerCompounders[_asset] = AMMCompounder({
394             symbol: _symbol,
395             name: _name,
396             compounder: _compounder,
397             underlyingAssets: _underlyingAssets
398         });
399         
400         balancerCompoundersList.push(_asset);
401         emit RegisterBalancerCompounder(_compounder, _asset, _symbol, _name, _underlyingAssets);
402     }
403 
404     /// @dev Register a TokenCompounder.
405     /// @param _compounder - The address of the Compounder.
406     /// @param _asset - The address of the asset.
407     /// @param _symbol - The symbol of the receipt token.
408     /// @param _name - The name of the receipt token.
409     function registerTokenCompounder(address _compounder, address _asset, string memory _symbol, string memory _name) public {
410         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
411         if(tokenCompounders[_asset].compounder != address(0)) revert AlreadyRegistered();
412 
413         tokenCompounders[_asset] = TokenCompounder({
414             symbol: _symbol,
415             name: _name,
416             compounder: _compounder
417         });
418         
419         tokenCompoundersList.push(_asset);
420         emit RegisterTokenCompounder(_compounder, _asset, _symbol, _name);
421     }
422 
423     /// @dev Register a BalancerGlpConcentrator.
424     /// @param _concentrator - The address of the Concentrator.
425     /// @param _asset - The address of the asset.
426     /// @param _symbol - The symbol of the receipt token.
427     /// @param _name - The name of the receipt token.
428     /// @param _underlyingAssets - The addresses of the underlying assets.
429     /// @param _compounder - The address of the vault we concentrate the rewards into.
430     function registerBalancerGlpConcentrator(address _concentrator, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets, address _compounder) public {
431         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
432         if(balancerGlpConcentrators[_asset].concentrator != address(0)) revert AlreadyRegistered();
433 
434         balancerGlpConcentrators[_asset] = AMMConcentrator({
435             symbol: _symbol,
436             name: _name,
437             concentrator: _concentrator,
438             compounder: _compounder,
439             underlyingAssets: _underlyingAssets
440         });
441         
442         balancerGlpConcentratorsList.push(_asset);
443         emit RegisterBalancerGlpConcentrator(_compounder, _asset, _symbol, _name, _underlyingAssets, _compounder);
444     }
445 
446     /// @dev Register a BalancerEthConcentrator.
447     /// @param _concentrator - The address of the Concentrator.
448     /// @param _asset - The address of the asset.
449     /// @param _symbol - The symbol of the receipt token.
450     /// @param _name - The name of the receipt token.
451     /// @param _underlyingAssets - The addresses of the underlying assets.
452     /// @param _compounder - The address of the vault we concentrate the rewards into.
453     function registerBalancerEthConcentrator(address _concentrator, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets, address _compounder) public {
454         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
455         if(balancerEthConcentrators[_asset].concentrator != address(0)) revert AlreadyRegistered();
456 
457         balancerEthConcentrators[_asset] = AMMConcentrator({
458             symbol: _symbol,
459             name: _name,
460             concentrator: _concentrator,
461             compounder: _compounder,
462             underlyingAssets: _underlyingAssets
463         });
464         
465         balancerEthConcentratorsList.push(_asset);
466         emit RegisterBalancerEthConcentrator(_compounder, _asset, _symbol, _name, _underlyingAssets, _compounder);
467     }
468 
469     /// @dev Register a CurveConcentrator.
470     /// @param _concentrator - The address of the Concentrator.
471     /// @param _asset - The address of the asset.
472     /// @param _symbol - The symbol of the receipt token.
473     /// @param _name - The name of the receipt token.
474     /// @param _underlyingAssets - The addresses of the underlying assets.
475     /// @param _compounder - The address of the vault we concentrate the rewards into.
476     function registerCurveGlpConcentrator(address _concentrator, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets, address _compounder) public {
477         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
478         if(curveGlpConcentrators[_asset].concentrator != address(0)) revert AlreadyRegistered();
479 
480         curveGlpConcentrators[_asset] = AMMConcentrator({
481             symbol: _symbol,
482             name: _name,
483             concentrator: _concentrator,
484             compounder: _compounder,
485             underlyingAssets: _underlyingAssets
486         });
487         
488         curveGlpConcentratorsList.push(_asset);
489         emit RegisterCurveGlpConcentrator(_compounder, _asset, _symbol, _name, _underlyingAssets, _compounder);
490     }
491 
492     /// @dev Register a CurveConcentrator.
493     /// @param _concentrator - The address of the Concentrator.
494     /// @param _asset - The address of the asset.
495     /// @param _symbol - The symbol of the receipt token.
496     /// @param _name - The name of the receipt token.
497     /// @param _underlyingAssets - The addresses of the underlying assets.
498     /// @param _compounder - The address of the vault we concentrate the rewards into.
499     function registerCurveEthConcentrator(address _concentrator, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets, address _compounder) public {
500         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
501         if(curveEthConcentrators[_asset].concentrator != address(0)) revert AlreadyRegistered();
502 
503         curveEthConcentrators[_asset] = AMMConcentrator({
504             symbol: _symbol,
505             name: _name,
506             concentrator: _concentrator,
507             compounder: _compounder,
508             underlyingAssets: _underlyingAssets
509         });
510         
511         curveEthConcentratorsList.push(_asset);
512         emit RegisterCurveEthConcentrator(_compounder, _asset, _symbol, _name, _underlyingAssets, _compounder);
513     }
514 
515     /// @dev Update the list of owners.
516     /// @param _index - The slot on the list.
517     /// @param _owner - The address of the new owner.
518     function updateOwner(uint256 _index, address _owner) public {
519         if(msg.sender != owners[0] && msg.sender != owners[1]) revert Unauthorized();
520 
521         owners[_index] = _owner;
522     }
523 
524     /********************************** Events & Errors **********************************/
525 
526     event RegisterCurveCompounder(address indexed _curveCompounder, address indexed _asset, string _symbol, string _name, address[] _underlyingAssets);
527     event RegisterBalancerCompounder(address indexed _balancerCompounder, address indexed _asset, string _symbol, string _name, address[] _underlyingAssets);
528     event RegisterTokenCompounder(address indexed _compounder, address indexed _asset, string _symbol, string _name);
529     event RegisterBalancerGlpConcentrator(address indexed _balancerConcentrator, address indexed _asset, string _symbol, string _name, address[] _underlyingAssets, address _compounder);
530     event RegisterBalancerEthConcentrator(address indexed _balancerConcentrator, address indexed _asset, string _symbol, string _name, address[] _underlyingAssets, address _compounder);
531     event RegisterCurveGlpConcentrator(address indexed _curveConcentrator, address indexed _asset, string _symbol, string _name, address[] _underlyingAssets, address _compounder);
532     event RegisterCurveEthConcentrator(address indexed _curveConcentrator, address indexed _asset, string _symbol, string _name, address[] _underlyingAssets, address _compounder);
533 
534     error Unauthorized();
535     error AlreadyRegistered();
536 }
