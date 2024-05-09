1 pragma solidity ^0.4.23;
2 
3 pragma solidity ^0.4.23;
4 
5 contract Operators
6 {
7     mapping (address=>bool) ownerAddress;
8     mapping (address=>bool) operatorAddress;
9 
10     constructor() public
11     {
12         ownerAddress[msg.sender] = true;
13     }
14 
15     modifier onlyOwner()
16     {
17         require(ownerAddress[msg.sender]);
18         _;
19     }
20 
21     function isOwner(address _addr) public view returns (bool) {
22         return ownerAddress[_addr];
23     }
24 
25     function addOwner(address _newOwner) external onlyOwner {
26         require(_newOwner != address(0));
27 
28         ownerAddress[_newOwner] = true;
29     }
30 
31     function removeOwner(address _oldOwner) external onlyOwner {
32         delete(ownerAddress[_oldOwner]);
33     }
34 
35     modifier onlyOperator() {
36         require(isOperator(msg.sender));
37         _;
38     }
39 
40     function isOperator(address _addr) public view returns (bool) {
41         return operatorAddress[_addr] || ownerAddress[_addr];
42     }
43 
44     function addOperator(address _newOperator) external onlyOwner {
45         require(_newOperator != address(0));
46 
47         operatorAddress[_newOperator] = true;
48     }
49 
50     function removeOperator(address _oldOperator) external onlyOwner {
51         delete(operatorAddress[_oldOperator]);
52     }
53 }
54 
55 pragma solidity ^0.4.23;
56 
57 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
58 contract PluginInterface
59 {
60     /// @dev simply a boolean to indicate this is the contract we expect to be
61     function isPluginInterface() public pure returns (bool);
62 
63     function onRemove() public;
64 
65     /// @dev Begins new feature.
66     /// @param _cutieId - ID of token to auction, sender must be owner.
67     /// @param _parameter - arbitrary parameter
68     /// @param _seller - Old owner, if not the message sender
69     function run(
70         uint40 _cutieId,
71         uint256 _parameter,
72         address _seller
73     )
74     public
75     payable;
76 
77     /// @dev Begins new feature, approved and signed by COO.
78     /// @param _cutieId - ID of token to auction, sender must be owner.
79     /// @param _parameter - arbitrary parameter
80     function runSigned(
81         uint40 _cutieId,
82         uint256 _parameter,
83         address _owner
84     ) external payable;
85 
86     function withdraw() external;
87 }
88 
89 pragma solidity ^0.4.23;
90 
91 interface PluginsInterface
92 {
93     function isPlugin(address contractAddress) external view returns(bool);
94     function withdraw() external;
95     function setMinSign(uint40 _newMinSignId) external;
96 
97     function runPluginOperator(
98         address _pluginAddress,
99         uint40 _signId,
100         uint40 _cutieId,
101         uint128 _value,
102         uint256 _parameter,
103         address _sender) external payable;
104 }
105 
106 pragma solidity ^0.4.23;
107 
108 pragma solidity ^0.4.23;
109 
110 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
111 /// @author https://BlockChainArchitect.io
112 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
113 interface ConfigInterface
114 {
115     function isConfig() external pure returns (bool);
116 
117     function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);
118     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);
119     function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);
120     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);
121 
122     function getCooldownIndexCount() external view returns (uint256);
123 
124     function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);
125     function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);
126 
127     function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);
128 
129     function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);
130 }
131 
132 
133 contract CutieCoreInterface
134 {
135     function isCutieCore() pure public returns (bool);
136 
137     ConfigInterface public config;
138 
139     function transferFrom(address _from, address _to, uint256 _cutieId) external;
140     function transfer(address _to, uint256 _cutieId) external;
141 
142     function ownerOf(uint256 _cutieId)
143         external
144         view
145         returns (address owner);
146 
147     function getCutie(uint40 _id)
148         external
149         view
150         returns (
151         uint256 genes,
152         uint40 birthTime,
153         uint40 cooldownEndTime,
154         uint40 momId,
155         uint40 dadId,
156         uint16 cooldownIndex,
157         uint16 generation
158     );
159 
160     function getGenes(uint40 _id)
161         public
162         view
163         returns (
164         uint256 genes
165     );
166 
167 
168     function getCooldownEndTime(uint40 _id)
169         public
170         view
171         returns (
172         uint40 cooldownEndTime
173     );
174 
175     function getCooldownIndex(uint40 _id)
176         public
177         view
178         returns (
179         uint16 cooldownIndex
180     );
181 
182 
183     function getGeneration(uint40 _id)
184         public
185         view
186         returns (
187         uint16 generation
188     );
189 
190     function getOptional(uint40 _id)
191         public
192         view
193         returns (
194         uint64 optional
195     );
196 
197 
198     function changeGenes(
199         uint40 _cutieId,
200         uint256 _genes)
201         public;
202 
203     function changeCooldownEndTime(
204         uint40 _cutieId,
205         uint40 _cooldownEndTime)
206         public;
207 
208     function changeCooldownIndex(
209         uint40 _cutieId,
210         uint16 _cooldownIndex)
211         public;
212 
213     function changeOptional(
214         uint40 _cutieId,
215         uint64 _optional)
216         public;
217 
218     function changeGeneration(
219         uint40 _cutieId,
220         uint16 _generation)
221         public;
222 
223     function createSaleAuction(
224         uint40 _cutieId,
225         uint128 _startPrice,
226         uint128 _endPrice,
227         uint40 _duration
228     )
229     public;
230 
231     function getApproved(uint256 _tokenId) external returns (address);
232     function totalSupply() view external returns (uint256);
233     function createPromoCutie(uint256 _genes, address _owner) external;
234     function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;
235     function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);
236     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
237     function restoreCutieToAddress(uint40 _cutieId, address _recipient) external;
238     function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) external;
239     function createGen0AuctionWithTokens(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration, address[] allowedTokens) external;
240     function createPromoCutieWithGeneration(uint256 _genes, address _owner, uint16 _generation) external;
241     function createPromoCutieBulk(uint256[] _genes, address _owner, uint16 _generation) external;
242 }
243 
244 
245 contract Plugins is Operators, PluginsInterface
246 {
247     event SignUsed(uint40 signId, address sender);
248     event MinSignSet(uint40 signId);
249 
250     uint40 public minSignId;
251     mapping(uint40 => address) public usedSignes;
252     address public signerAddress;
253 
254     mapping(address => PluginInterface) public plugins;
255     PluginInterface[] public pluginsArray;
256     CutieCoreInterface public coreContract;
257 
258     function setSigner(address _newSigner) external onlyOwner {
259         signerAddress = _newSigner;
260     }
261 
262     /// @dev Sets the reference to the plugin contract.
263     /// @param _address - Address of plugin contract.
264     function addPlugin(address _address) external onlyOwner
265     {
266         PluginInterface candidateContract = PluginInterface(_address);
267 
268         // verify that a contract is what we expect
269         require(candidateContract.isPluginInterface());
270 
271         // Set the new contract address
272         plugins[_address] = candidateContract;
273         pluginsArray.push(candidateContract);
274     }
275 
276     /// @dev Remove plugin and calls onRemove to cleanup
277     function removePlugin(address _address) external onlyOwner
278     {
279         plugins[_address].onRemove();
280         delete plugins[_address];
281 
282         uint256 kindex = 0;
283         while (kindex < pluginsArray.length)
284         {
285             if (address(pluginsArray[kindex]) == _address)
286             {
287                 pluginsArray[kindex] = pluginsArray[pluginsArray.length-1];
288                 pluginsArray.length--;
289             }
290             else
291             {
292                 kindex++;
293             }
294         }
295     }
296 
297     /// @dev Common function to be used also in backend
298     function hashArguments(
299         address _pluginAddress,
300         uint40 _signId,
301         uint40 _cutieId,
302         uint128 _value,
303         uint256 _parameter)
304     public pure returns (bytes32 msgHash)
305     {
306         msgHash = keccak256(abi.encode(_pluginAddress, _signId, _cutieId, _value, _parameter));
307     }
308 
309     /// @dev Common function to be used also in backend
310     function getSigner(
311         address _pluginAddress,
312         uint40 _signId,
313         uint40 _cutieId,
314         uint128 _value,
315         uint256 _parameter,
316         uint8 _v,
317         bytes32 _r,
318         bytes32 _s
319     )
320     public pure returns (address)
321     {
322         bytes32 msgHash = hashArguments(_pluginAddress, _signId, _cutieId, _value, _parameter);
323         return ecrecover(msgHash, _v, _r, _s);
324     }
325 
326     /// @dev Common function to be used also in backend
327     function isValidSignature(
328         address _pluginAddress,
329         uint40 _signId,
330         uint40 _cutieId,
331         uint128 _value,
332         uint256 _parameter,
333         uint8 _v,
334         bytes32 _r,
335         bytes32 _s
336     )
337     public
338     view
339     returns (bool)
340     {
341         return getSigner(_pluginAddress, _signId, _cutieId, _value, _parameter, _v, _r, _s) == signerAddress;
342     }
343 
344     /// @dev Put a cutie up for plugin feature with signature.
345     ///  Can be used for items equip, item sales and other features.
346     ///  Signatures are generated by Operator role.
347     function runPluginSigned(
348         address _pluginAddress,
349         uint40 _signId,
350         uint40 _cutieId,
351         uint128 _value,
352         uint256 _parameter,
353         uint8 _v,
354         bytes32 _r,
355         bytes32 _s
356     )
357         external
358 //        whenNotPaused
359         payable
360     {
361         require (isValidSignature(_pluginAddress, _signId, _cutieId, _value, _parameter, _v, _r, _s));
362 
363         require(address(plugins[_pluginAddress]) != address(0));
364 
365         require (usedSignes[_signId] == address(0));
366 
367         require (_signId >= minSignId);
368         // value can also be zero for free calls
369 
370         require (_value <= msg.value);
371 
372         usedSignes[_signId] = msg.sender;
373 
374         if (_cutieId > 0)
375         {
376             // If cutie is already on any auction or in adventure, this will throw
377             // as it will be owned by the other contract.
378             // If _cutieId is 0, then cutie is not used on this feature.
379 
380             coreContract.checkOwnerAndApprove(msg.sender, _cutieId, _pluginAddress);
381         }
382 
383         emit SignUsed(_signId, msg.sender);
384 
385         // Plugin contract throws if inputs are invalid and clears
386         // transfer after escrowing the cutie.
387         plugins[_pluginAddress].runSigned.value(_value)(
388             _cutieId,
389             _parameter,
390             msg.sender
391         );
392     }
393 
394     /// @dev Put a cutie up for plugin feature as Operator.
395     ///  Can be used for items equip, item sales and other features.
396     ///  Signatures are generated by Operator role.
397     function runPluginOperator(
398         address _pluginAddress,
399         uint40 _signId,
400         uint40 _cutieId,
401         uint128 _value,
402         uint256 _parameter,
403         address _sender)
404         external payable onlyOperator
405     {
406         require(address(plugins[_pluginAddress]) != address(0));
407 
408         require (usedSignes[_signId] == address(0));
409 
410         require (_signId >= minSignId);
411         // value can also be zero for free calls
412 
413 
414         require (_value <= msg.value);
415 
416         usedSignes[_signId] = _sender;
417 
418         emit SignUsed(_signId, _sender);
419 
420 
421         // Plugin contract throws if inputs are invalid and clears
422         // transfer after escrowing the cutie.
423         plugins[_pluginAddress].runSigned.value(_value)(
424             _cutieId,
425             _parameter,
426             _sender
427         );
428     }
429 
430     function setSignAsUsed(uint40 _signId, address _sender) external onlyOperator
431     {
432         usedSignes[_signId] = _sender;
433         emit SignUsed(_signId, _sender);
434     }
435 
436     /// @dev Sets minimal signId, than can be used.
437     ///       All unused signatures less than signId will be cancelled on off-chain server
438     ///       and unused items will be transfered back to owner.
439     function setMinSign(uint40 _newMinSignId) external onlyOperator
440     {
441         require (_newMinSignId > minSignId);
442         minSignId = _newMinSignId;
443         emit MinSignSet(minSignId);
444     }
445 
446     /// @dev Put a cutie up for plugin feature.
447     function runPlugin(
448         address _pluginAddress,
449         uint40 _cutieId,
450         uint256 _parameter
451     ) external payable
452     {
453         // If cutie is already on any auction or in adventure, this will throw
454         // because it will be owned by the other contract.
455         // If _cutieId is 0, then cutie is not used on this feature.
456         require(address(plugins[_pluginAddress]) != address(0));
457         if (_cutieId > 0)
458         {
459             coreContract.checkOwnerAndApprove(msg.sender, _cutieId, _pluginAddress);
460         }
461 
462         // Plugin contract throws if inputs are invalid and clears
463         // transfer after escrowing the cutie.
464         plugins[_pluginAddress].run.value(msg.value)(
465             _cutieId,
466             _parameter,
467             msg.sender
468         );
469     }
470 
471     function isPlugin(address contractAddress) external view returns(bool)
472     {
473         return address(plugins[contractAddress]) != address(0);
474     }
475 
476     function setup(address _address) external onlyOwner
477     {
478         coreContract = CutieCoreInterface(_address);
479     }
480 
481     function withdraw() external
482     {
483         require(msg.sender == address(coreContract));
484         for (uint32 i = 0; i < pluginsArray.length; ++i)
485         {
486             pluginsArray[i].withdraw();
487         }
488     }
489 }