1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 pragma solidity ^0.4.24;
6 
7 
8 pragma solidity ^0.4.24;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 
52 
53 /**
54  * @title Pausable
55  * @dev Base contract which allows children to implement an emergency stop mechanism.
56  */
57 contract Pausable is Ownable {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is not paused.
66    */
67   modifier whenNotPaused() {
68     require(!paused);
69     _;
70   }
71 
72   /**
73    * @dev Modifier to make a function callable only when the contract is paused.
74    */
75   modifier whenPaused() {
76     require(paused);
77     _;
78   }
79 
80   /**
81    * @dev called by the owner to pause, triggers stopped state
82    */
83   function pause() onlyOwner whenNotPaused public {
84     paused = true;
85     emit Pause();
86   }
87 
88   /**
89    * @dev called by the owner to unpause, returns to normal state
90    */
91   function unpause() onlyOwner whenPaused public {
92     paused = false;
93     emit Unpause();
94   }
95 }
96 
97 pragma solidity ^0.4.24;
98 
99 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
100 contract PluginInterface
101 {
102     /// @dev simply a boolean to indicate this is the contract we expect to be
103     function isPluginInterface() public pure returns (bool);
104 
105     function onRemove() public;
106 
107     /// @dev Begins new feature.
108     /// @param _cutieId - ID of token to auction, sender must be owner.
109     /// @param _parameter - arbitrary parameter
110     /// @param _seller - Old owner, if not the message sender
111     function run(
112         uint40 _cutieId,
113         uint256 _parameter,
114         address _seller
115     ) 
116     public
117     payable;
118 
119     /// @dev Begins new feature, approved and signed by COO.
120     /// @param _cutieId - ID of token to auction, sender must be owner.
121     /// @param _parameter - arbitrary parameter
122     function runSigned(
123         uint40 _cutieId,
124         uint256 _parameter,
125         address _owner
126     )
127     external
128     payable;
129 
130     function withdraw() public;
131 }
132 
133 pragma solidity ^0.4.24;
134 
135 pragma solidity ^0.4.24;
136 
137 /// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.
138 /// @author https://BlockChainArchitect.io
139 /// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.
140 contract ConfigInterface
141 {
142     function isConfig() public pure returns (bool);
143 
144     function getCooldownIndexFromGeneration(uint16 _generation) public view returns (uint16);
145     
146     function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) public view returns (uint40);
147 
148     function getCooldownIndexCount() public view returns (uint256);
149     
150     function getBabyGen(uint16 _momGen, uint16 _dadGen) public pure returns (uint16);
151 
152     function getTutorialBabyGen(uint16 _dadGen) public pure returns (uint16);
153 
154     function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);
155 }
156 
157 
158 contract CutieCoreInterface
159 {
160     function isCutieCore() pure public returns (bool);
161 
162     ConfigInterface public config;
163 
164     function transferFrom(address _from, address _to, uint256 _cutieId) external;
165     function transfer(address _to, uint256 _cutieId) external;
166 
167     function ownerOf(uint256 _cutieId)
168         external
169         view
170         returns (address owner);
171 
172     function getCutie(uint40 _id)
173         external
174         view
175         returns (
176         uint256 genes,
177         uint40 birthTime,
178         uint40 cooldownEndTime,
179         uint40 momId,
180         uint40 dadId,
181         uint16 cooldownIndex,
182         uint16 generation
183     );
184 
185     function getGenes(uint40 _id)
186         public
187         view
188         returns (
189         uint256 genes
190     );
191 
192 
193     function getCooldownEndTime(uint40 _id)
194         public
195         view
196         returns (
197         uint40 cooldownEndTime
198     );
199 
200     function getCooldownIndex(uint40 _id)
201         public
202         view
203         returns (
204         uint16 cooldownIndex
205     );
206 
207 
208     function getGeneration(uint40 _id)
209         public
210         view
211         returns (
212         uint16 generation
213     );
214 
215     function getOptional(uint40 _id)
216         public
217         view
218         returns (
219         uint64 optional
220     );
221 
222 
223     function changeGenes(
224         uint40 _cutieId,
225         uint256 _genes)
226         public;
227 
228     function changeCooldownEndTime(
229         uint40 _cutieId,
230         uint40 _cooldownEndTime)
231         public;
232 
233     function changeCooldownIndex(
234         uint40 _cutieId,
235         uint16 _cooldownIndex)
236         public;
237 
238     function changeOptional(
239         uint40 _cutieId,
240         uint64 _optional)
241         public;
242 
243     function changeGeneration(
244         uint40 _cutieId,
245         uint16 _generation)
246         public;
247 
248     function createSaleAuction(
249         uint40 _cutieId,
250         uint128 _startPrice,
251         uint128 _endPrice,
252         uint40 _duration
253     )
254     public;
255 
256     function getApproved(uint256 _tokenId) external returns (address);
257 }
258 
259 
260 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
261 contract CutiePluginBase is PluginInterface, Pausable
262 {
263     function isPluginInterface() public pure returns (bool)
264     {
265         return true;
266     }
267 
268     // Reference to contract tracking NFT ownership
269     CutieCoreInterface public coreContract;
270 
271     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
272     // Values 0-10,000 map to 0%-100%
273     uint16 public ownerFee;
274 
275     // @dev Throws if called by any account other than the owner.
276     modifier onlyCore() {
277         require(msg.sender == address(coreContract));
278         _;
279     }
280 
281     /// @dev Constructor creates a reference to the NFT ownership contract
282     ///  and verifies the owner cut is in the valid range.
283     /// @param _coreAddress - address of a deployed contract implementing
284     ///  the Nonfungible Interface.
285     /// @param _fee - percent cut the owner takes on each auction, must be
286     ///  between 0-10,000.
287     function setup(address _coreAddress, uint16 _fee) public {
288         require(_fee <= 10000);
289         require(msg.sender == owner);
290         ownerFee = _fee;
291         
292         CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);
293         require(candidateContract.isCutieCore());
294         coreContract = candidateContract;
295     }
296 
297     // @dev Set the owner's fee.
298     //  @param fee should be between 0-10,000.
299     function setFee(uint16 _fee) public
300     {
301         require(_fee <= 10000);
302         require(msg.sender == owner);
303 
304         ownerFee = _fee;
305     }
306 
307     /// @dev Returns true if the claimant owns the token.
308     /// @param _claimant - Address claiming to own the token.
309     /// @param _cutieId - ID of token whose ownership to verify.
310     function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {
311         return (coreContract.ownerOf(_cutieId) == _claimant);
312     }
313 
314     /// @dev Escrows the NFT, assigning ownership to this contract.
315     /// Throws if the escrow fails.
316     /// @param _owner - Current owner address of token to escrow.
317     /// @param _cutieId - ID of token whose approval to verify.
318     function _escrow(address _owner, uint40 _cutieId) internal {
319         // it will throw if transfer fails
320         coreContract.transferFrom(_owner, this, _cutieId);
321     }
322 
323     /// @dev Transfers an NFT owned by this contract to another address.
324     /// Returns true if the transfer succeeds.
325     /// @param _receiver - Address to transfer NFT to.
326     /// @param _cutieId - ID of token to transfer.
327     function _transfer(address _receiver, uint40 _cutieId) internal {
328         // it will throw if transfer fails
329         coreContract.transfer(_receiver, _cutieId);
330     }
331 
332     /// @dev Computes owner's cut of a sale.
333     /// @param _price - Sale price of NFT.
334     function _computeFee(uint128 _price) internal view returns (uint128) {
335         // NOTE: We don't use SafeMath (or similar) in this function because
336         //  all of our entry functions carefully cap the maximum values for
337         //  currency (at 128-bits), and ownerFee <= 10000 (see the require()
338         //  statement in the ClockAuction constructor). The result of this
339         //  function is always guaranteed to be <= _price.
340         return _price * ownerFee / 10000;
341     }
342 
343     function withdraw() public
344     {
345         require(
346             msg.sender == owner ||
347             msg.sender == address(coreContract)
348         );
349         if (address(this).balance > 0)
350         {
351             address(coreContract).transfer(address(this).balance);
352         }
353     }
354 
355     function onRemove() public onlyCore
356     {
357         withdraw();
358     }
359 
360     function run(
361         uint40,
362         uint256,
363         address
364     ) 
365         public
366         payable
367         onlyCore
368     {
369         revert();
370     }
371 }
372 
373 pragma solidity ^0.4.24;
374 
375 pragma solidity ^0.4.24;
376 
377 // ----------------------------------------------------------------------------
378 contract ERC20Interface {
379 
380     // ERC Token Standard #223 Interface
381     // https://github.com/ethereum/EIPs/issues/223
382 
383     string public symbol;
384     string public  name;
385     uint8 public decimals;
386 
387     function transfer(address _to, uint _value, bytes _data) external returns (bool success);
388 
389     // approveAndCall
390     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
391 
392     // ERC Token Standard #20 Interface
393     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
394 
395 
396     function totalSupply() public constant returns (uint);
397     function balanceOf(address tokenOwner) public constant returns (uint balance);
398     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
399     function transfer(address to, uint tokens) public returns (bool success);
400     function approve(address spender, uint tokens) public returns (bool success);
401     function transferFrom(address from, address to, uint tokens) public returns (bool success);
402     event Transfer(address indexed from, address indexed to, uint tokens);
403     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
404 
405     // bulk operations
406     function transferBulk(address[] to, uint[] tokens) public;
407     function approveBulk(address[] spender, uint[] tokens) public;
408 }
409 
410 
411 
412 contract CuteCoinInterface is ERC20Interface
413 {
414     function mint(address target, uint256 mintedAmount) public;
415     function mintBulk(address[] target, uint256[] mintedAmount) external;
416     function burn(uint256 amount) external;
417 }
418 
419 
420 /// @dev Receives and transfers money from item buyer to seller for Blockchain Cuties
421 /// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase
422 contract CoinMinting is CutiePluginBase
423 {
424     CuteCoinInterface token;
425 
426     function setToken(CuteCoinInterface _token)
427         external
428         onlyOwner
429     {
430         token = _token;
431     }
432 
433     function run(
434         uint40,
435         uint256,
436         address
437     )
438         public
439         payable
440         onlyCore
441     {
442         revert();
443     }
444 
445     function runSigned(uint40, uint256 _parameter, address _target)
446         external
447         payable
448         onlyCore
449     {
450         token.mint(_target, _parameter);
451     }
452 }