1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4 
5   address public contractOwner;
6 
7   function Ownable() public {
8     contractOwner = msg.sender;
9   }
10 
11   modifier onlyContractOwner() {
12     require(msg.sender == contractOwner);
13     _;
14   }
15 
16   function transferContractOwnership(address _newOwner) public onlyContractOwner {
17     require(_newOwner != address(0));
18     contractOwner = _newOwner;
19   }
20   
21   function contractWithdraw() public onlyContractOwner {
22       contractOwner.transfer(this.balance);
23   }  
24 
25 }
26 
27 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
28 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
29 contract ERC721 {
30   // Required methods
31   function approve(address _to, uint256 _tokenId) public;
32   function balanceOf(address _owner) public view returns (uint256 balance);
33   function implementsERC721() public pure returns (bool);
34   function ownerOf(uint256 _tokenId) public view returns (address addr);
35   function takeOwnership(uint256 _tokenId) public;
36   function totalSupply() public view returns (uint256 total);
37   function transferFrom(address _from, address _to, uint256 _tokenId) public;
38   function transfer(address _to, uint256 _tokenId) public;
39 
40   event Transfer(address indexed from, address indexed to, uint256 tokenId);
41   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
42 
43   // Optional
44   // function name() public view returns (string name);
45   // function symbol() public view returns (string symbol);
46   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
47   // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
48   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
49 }
50 
51 contract EthPiranha is ERC721, Ownable {
52 
53   event PiranhaCreated(uint256 tokenId, string name, address owner);
54   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
55   event Transfer(address from, address to, uint256 tokenId);
56 
57   string public constant NAME = "Piranha";
58   string public constant SYMBOL = "PiranhaToken";
59 
60   mapping (uint256 => address) private piranhaIdToOwner;
61 
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   mapping (uint256 => address) private piranhaIdToApproved;
65   
66    /*** DATATYPES ***/
67   struct Piranha {
68     string name;
69 	uint8 size;
70 	uint256 gen;
71 	uint8 unique;
72 	uint256 growthStartTime;
73 	uint256 sellPrice;
74 	uint8 hungry;
75   }
76 
77   Piranha[] public piranhas;
78 
79   function approve(address _to, uint256 _tokenId) public { //ERC721
80     // Caller must own token.
81     require(_owns(msg.sender, _tokenId));
82     piranhaIdToApproved[_tokenId] = _to;
83     Approval(msg.sender, _to, _tokenId);
84   }
85 
86   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
87     return ownershipTokenCount[_owner];
88   }
89 
90   function createPiranhaTokens() public onlyContractOwner {
91      for (uint8 i=0; i<15; i++) {
92 		_createPiranha("EthPiranha", msg.sender, 20 finney, 160, 1, 0);
93 	}
94   }
95 
96   function implementsERC721() public pure returns (bool) {
97     return true;
98   }
99 
100   function name() public pure returns (string) { //ERC721
101     return NAME;
102   }
103 
104   function symbol() public pure returns (string) { //ERC721
105     return SYMBOL;
106   }  
107 
108   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
109     owner = piranhaIdToOwner[_tokenId];
110     require(owner != address(0));
111   }
112 
113   function buy(uint256 _tokenId) public payable {
114     address oldOwner = piranhaIdToOwner[_tokenId];
115     address newOwner = msg.sender;
116 
117 	Piranha storage piranha = piranhas[_tokenId];
118 
119     uint256 sellingPrice = piranha.sellPrice;
120 
121     require(oldOwner != newOwner);
122     require(_addressNotNull(newOwner));
123     require(msg.value >= sellingPrice && sellingPrice > 0);
124 
125     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100)); //97% to previous owner, 3% dev tax
126 
127     // Stop selling
128     piranha.sellPrice=0;
129 	piranha.hungry=0;
130 
131     _transfer(oldOwner, newOwner, _tokenId);
132 
133     // Pay previous tokenOwner if owner is not contract
134     if (oldOwner != address(this)) {
135       oldOwner.transfer(payment); //
136     }
137 
138     TokenSold(_tokenId, sellingPrice, 0, oldOwner, newOwner, piranhas[_tokenId].name);
139 	
140     if (msg.value > sellingPrice) { //if excess pay
141 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
142 		msg.sender.transfer(purchaseExcess);
143 	}
144   }
145   
146   function changePiranhaName(uint256 _tokenId, string _name) public payable {
147 	require (piranhaIdToOwner[_tokenId] == msg.sender && msg.value == 0.001 ether);
148 	require(bytes(_name).length <= 15);
149 	
150 	Piranha storage piranha = piranhas[_tokenId];
151 	piranha.name = _name;
152   }
153   
154   function startSelling(uint256 _tokenId, uint256 _price) public {
155 	require (piranhaIdToOwner[_tokenId] == msg.sender);
156 	
157 	Piranha storage piranha = piranhas[_tokenId];
158 	piranha.sellPrice = _price;
159   }  
160 
161   function stopSelling(uint256 _tokenId) public {
162 	require (piranhaIdToOwner[_tokenId] == msg.sender);
163 
164 	Piranha storage piranha = piranhas[_tokenId];
165 	require (piranha.sellPrice > 0);
166 	
167 	piranha.sellPrice = 0;
168   }  
169   
170   function hungry(uint256 _tokenId) public {
171 	require (piranhaIdToOwner[_tokenId] == msg.sender);
172 
173 	Piranha storage piranha = piranhas[_tokenId];
174 	require (piranha.hungry == 0);
175 	
176 	uint8 piranhaSize=uint8(piranha.size+(now-piranha.growthStartTime)/900);
177 
178 	require (piranhaSize < 240);
179 	
180 	piranha.hungry = 1;
181   }   
182 
183   function notHungry(uint256 _tokenId) public {
184 	require (piranhaIdToOwner[_tokenId] == msg.sender);
185 
186 	Piranha storage piranha = piranhas[_tokenId];
187 	require (piranha.hungry == 1);
188 	
189 	piranha.hungry = 0;
190   }   
191 
192   function bite(uint256 _tokenId, uint256 _victimTokenId) public payable {
193 	require (piranhaIdToOwner[_tokenId] == msg.sender);
194 	require (msg.value == 1 finney);
195 	
196 	Piranha storage piranha = piranhas[_tokenId];
197 	Piranha storage victimPiranha = piranhas[_victimTokenId];
198 	require (piranha.hungry == 1 && victimPiranha.hungry == 1);
199 
200 	uint8 vitimPiranhaSize=uint8(victimPiranha.size+(now-victimPiranha.growthStartTime)/900);
201 	
202 	require (vitimPiranhaSize>40); // don't bite a small
203 
204 	uint8 piranhaSize=uint8(piranha.size+(now-piranha.growthStartTime)/900)+10;
205 	
206 	if (piranhaSize>240) { 
207 	    piranha.size = 240; //maximum
208 		piranha.hungry = 0;
209 	} else {
210 	    piranha.size = piranhaSize;
211 	}
212      
213 	//decrease victim size 
214 	if (vitimPiranhaSize>=50) {
215 	    vitimPiranhaSize-=10;
216 	    victimPiranha.size = vitimPiranhaSize;
217 	}
218     else {
219 		victimPiranha.size=40;
220 	}
221 	
222 	piranha.growthStartTime=now;
223 	victimPiranha.growthStartTime=now;
224 	
225   }    
226   
227   function breeding(uint256 _maleTokenId, uint256 _femaleTokenId) public payable {
228   
229     require (piranhaIdToOwner[_maleTokenId] ==  msg.sender && piranhaIdToOwner[_femaleTokenId] == msg.sender);
230 	require (msg.value == 0.01 ether);
231 
232 	Piranha storage piranhaMale = piranhas[_maleTokenId];
233 	Piranha storage piranhaFemale = piranhas[_femaleTokenId];
234 	
235 	uint8 maleSize=uint8(piranhaMale.size+(now-piranhaMale.growthStartTime)/900);
236 	if (maleSize>240)
237 	   piranhaMale.size=240;
238 	else 
239 	   piranhaMale.size=maleSize;
240 
241 	uint8 femaleSize=uint8(piranhaFemale.size+(now-piranhaFemale.growthStartTime)/900);
242 	if (femaleSize>240)
243 	   piranhaFemale.size=240;
244 	else 
245 	   piranhaFemale.size=femaleSize;
246 	   
247 	require (piranhaMale.size > 150 && piranhaFemale.size > 150);
248 	
249 	uint8 newbornSize = uint8(SafeMath.div(SafeMath.add(piranhaMale.size, piranhaMale.size),4));
250 	
251 	uint256 maxGen=piranhaFemale.gen;
252 	uint256 minGen=piranhaMale.gen;
253 	
254 	if (piranhaMale.gen > piranhaFemale.gen) {
255 		maxGen=piranhaMale.gen;
256 		minGen=piranhaFemale.gen;
257 	} 
258 	
259 	uint256 randNum = uint256(block.blockhash(block.number-1));
260 	uint256 newbornGen;
261 	uint8 newbornUnique = uint8(randNum%100+1); //chance to get rare piranha
262 	
263 	if (randNum%(10+maxGen) == 1) { // new generation, difficult depends on maxgen
264 		newbornGen = SafeMath.add(maxGen,1);
265 	} else if (maxGen == minGen) {
266 		newbornGen = maxGen;
267 	} else {
268 		newbornGen = SafeMath.add(randNum%(maxGen-minGen+1),minGen);
269 	}
270 	
271 	// 5% chance to get rare piranhas for each gen
272 	if (newbornUnique > 5) 
273 		newbornUnique = 0;
274 		
275      //initiate new size, cancel selling
276 	 piranhaMale.size = uint8(SafeMath.div(piranhaMale.size,2));		
277      piranhaFemale.size = uint8(SafeMath.div(piranhaFemale.size,2));	
278 
279 	 piranhaMale.growthStartTime = now;	 
280 	 piranhaFemale.growthStartTime = now;	 
281 
282 	 piranhaMale.sellPrice = 0;	 
283 	 piranhaFemale.sellPrice = 0;	 
284 		
285 	_createPiranha("EthPiranha", msg.sender, 0, newbornSize, newbornGen, newbornUnique);
286   
287   }
288   
289   function takeOwnership(uint256 _tokenId) public { //ERC721
290     address newOwner = msg.sender;
291     address oldOwner = piranhaIdToOwner[_tokenId];
292 
293     require(_addressNotNull(newOwner));
294     require(_approved(newOwner, _tokenId));
295 
296     _transfer(oldOwner, newOwner, _tokenId);
297   }
298 
299   function allPiranhasInfo(uint256 _startPiranhaId) public view returns (address[] owners, uint8[] sizes, uint8[] hungry, uint256[] prices) { //for web site view
300 	
301 	uint256 totalPiranhas = totalSupply();
302 	Piranha storage piranha;
303 	
304     if (totalPiranhas == 0 || _startPiranhaId >= totalPiranhas) {
305         // Return an empty array
306       return (new address[](0), new uint8[](0), new uint8[](0), new uint256[](0));
307     }
308 
309 	
310 	uint256 indexTo;
311 	if (totalPiranhas > _startPiranhaId+1000)
312 		indexTo = _startPiranhaId + 1000;
313 	else 	
314 		indexTo = totalPiranhas;
315 		
316     uint256 totalResultPiranhas = indexTo - _startPiranhaId;		
317 		
318 	address[] memory owners_res = new address[](totalResultPiranhas);
319 	uint8[] memory size_res = new uint8[](totalResultPiranhas);
320 	uint8[] memory hungry_res = new uint8[](totalResultPiranhas);
321 	uint256[] memory prices_res = new uint256[](totalResultPiranhas);
322 	
323 	for (uint256 piranhaId = _startPiranhaId; piranhaId < indexTo; piranhaId++) {
324 	  piranha = piranhas[piranhaId];
325 	  
326 	  owners_res[piranhaId - _startPiranhaId] = piranhaIdToOwner[piranhaId];
327 	  hungry_res[piranhaId - _startPiranhaId] = piranha.hungry;
328 	  size_res[piranhaId - _startPiranhaId] = uint8(piranha.size+(now-piranha.growthStartTime)/900);
329 	  prices_res[piranhaId - _startPiranhaId] = piranha.sellPrice;
330 	}
331 	
332 	return (owners_res, size_res, hungry_res, prices_res);
333   }
334   
335   function totalSupply() public view returns (uint256 total) { //ERC721
336     return piranhas.length;
337   }
338 
339   function transfer(address _to, uint256 _tokenId) public { //ERC721
340     require(_owns(msg.sender, _tokenId));
341     require(_addressNotNull(_to));
342 
343 	_transfer(msg.sender, _to, _tokenId);
344   }
345 
346   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
347     require(_owns(_from, _tokenId));
348     require(_approved(_to, _tokenId));
349     require(_addressNotNull(_to));
350 
351     _transfer(_from, _to, _tokenId);
352   }
353 
354 
355   /* PRIVATE FUNCTIONS */
356   function _addressNotNull(address _to) private pure returns (bool) {
357     return _to != address(0);
358   }
359 
360   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
361     return piranhaIdToApproved[_tokenId] == _to;
362   }
363 
364   function _createPiranha(string _name, address _owner, uint256 _price, uint8 _size, uint256 _gen, uint8 _unique) private {
365     Piranha memory _piranha = Piranha({
366       name: _name,
367 	  size: _size,
368 	  gen: _gen,
369 	  unique: _unique,	  
370 	  growthStartTime: now,
371 	  sellPrice: _price,
372 	  hungry: 0
373     });
374     uint256 newPiranhaId = piranhas.push(_piranha) - 1;
375 
376     require(newPiranhaId == uint256(uint32(newPiranhaId))); //check maximum limit of tokens
377 
378     PiranhaCreated(newPiranhaId, _name, _owner);
379 
380     _transfer(address(0), _owner, newPiranhaId);
381   }
382 
383   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
384     return _checkedAddr == piranhaIdToOwner[_tokenId];
385   }
386 
387   function _transfer(address _from, address _to, uint256 _tokenId) private {
388     ownershipTokenCount[_to]++;
389     piranhaIdToOwner[_tokenId] = _to;
390 
391     // When creating new piranhas _from is 0x0, but we can't account that address.
392     if (_from != address(0)) {
393       ownershipTokenCount[_from]--;
394       // clear any previously approved ownership exchange
395       delete piranhaIdToApproved[_tokenId];
396     }
397 
398     // Emit the transfer event.
399     Transfer(_from, _to, _tokenId);
400   }
401 }
402 
403 library SafeMath {
404 
405   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406     if (a == 0) {
407       return 0;
408     }
409     uint256 c = a * b;
410     assert(c / a == b);
411     return c;
412   }
413 
414   function div(uint256 a, uint256 b) internal pure returns (uint256) {
415     // assert(b > 0); // Solidity automatically throws when dividing by 0
416     uint256 c = a / b;
417     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418     return c;
419   }
420 
421   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422     assert(b <= a);
423     return a - b;
424   }
425 
426   function add(uint256 a, uint256 b) internal pure returns (uint256) {
427     uint256 c = a + b;
428     assert(c >= a);
429     return c;
430   }
431 }