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
31   function balanceOf(address _owner) public view returns (uint256 balance);
32   function implementsERC721() public pure returns (bool);
33   function ownerOf(uint256 _tokenId) public view returns (address addr);
34   function totalSupply() public view returns (uint256 total);
35   function transfer(address _to, uint256 _tokenId) public;
36 
37   event Transfer(address indexed from, address indexed to, uint256 tokenId);
38 
39   // Optional
40   // function name() public view returns (string name);
41   // function symbol() public view returns (string symbol);
42   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
43   // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
44   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
45 }
46 
47 contract EthPiranha is ERC721, Ownable {
48 
49   event PiranhaCreated(uint256 tokenId, string name, address owner);
50   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
51   event Transfer(address from, address to, uint256 tokenId);
52 
53   string public constant NAME = "Piranha";
54   string public constant SYMBOL = "PiranhaToken";
55 
56   mapping (uint256 => address) private piranhaIdToOwner;
57 
58   mapping (address => uint256) private ownershipTokenCount;
59   
60    /*** DATATYPES ***/
61   struct Piranha {
62     string name;
63 	uint8 size;
64 	uint256 gen;
65 	uint8 unique;
66 	uint256 growthStartTime;
67 	uint256 sellPrice;
68 	uint8 hungry;
69   }
70 
71   Piranha[] public piranhas;
72   
73   uint256 private breedingCost = 0.001 ether;
74   uint256 private biteCost = 0.001 ether;
75 
76   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
77     return ownershipTokenCount[_owner];
78   }
79 
80   function createPiranhaToken(string _name, address _owner, uint256 _price, uint8 _size, uint8 _hungry) public onlyContractOwner {
81 		//Emit new tokens ONLY GEN 1 
82 		_createPiranha(_name, _owner, _price, _size, 1, 0, _hungry);
83   }
84 
85   function implementsERC721() public pure returns (bool) {
86     return true;
87   }
88 
89   function name() public pure returns (string) { //ERC721
90     return NAME;
91   }
92 
93   function symbol() public pure returns (string) { //ERC721
94     return SYMBOL;
95   }  
96 
97   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
98     owner = piranhaIdToOwner[_tokenId];
99     require(owner != address(0));
100   }
101 
102   function buy(uint256 _tokenId) public payable {
103     address oldOwner = piranhaIdToOwner[_tokenId];
104     address newOwner = msg.sender;
105 
106 	Piranha storage piranha = piranhas[_tokenId];
107 
108     uint256 sellingPrice = piranha.sellPrice;
109 
110     require(oldOwner != newOwner);
111     require(_addressNotNull(newOwner));
112     require(msg.value >= sellingPrice && sellingPrice > 0);
113 
114     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100)); //97% to previous owner, 3% dev tax
115 
116     // Stop selling
117     piranha.sellPrice=0;
118 	piranha.hungry=0;
119 
120     _transfer(oldOwner, newOwner, _tokenId);
121 
122     // Pay previous tokenOwner if owner is not contract
123     if (oldOwner != address(this)) {
124       oldOwner.transfer(payment); //
125     }
126 
127     TokenSold(_tokenId, sellingPrice, 0, oldOwner, newOwner, piranhas[_tokenId].name);
128 	
129     if (msg.value > sellingPrice) { //if excess pay
130 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
131 		msg.sender.transfer(purchaseExcess);
132 	}
133   }
134   
135   function changePiranhaName(uint256 _tokenId, string _name) public payable {
136 	require (piranhaIdToOwner[_tokenId] == msg.sender && msg.value == biteCost);
137 	require(bytes(_name).length <= 15);
138 	
139 	Piranha storage piranha = piranhas[_tokenId];
140 	piranha.name = _name;
141   }
142   
143   function changeBeedingCost(uint256 _newCost) public onlyContractOwner {
144     require(_newCost > 0);
145 	breedingCost=_newCost;
146   }  
147 
148   function changeBiteCost(uint256 _newCost) public onlyContractOwner {
149     require(_newCost > 0);
150 	biteCost=_newCost;
151   }    
152   
153   function startSelling(uint256 _tokenId, uint256 _price) public {
154 	require (piranhaIdToOwner[_tokenId] == msg.sender);
155 	
156 	Piranha storage piranha = piranhas[_tokenId];
157 	piranha.sellPrice = _price;
158   }  
159 
160   function stopSelling(uint256 _tokenId) public {
161 	require (piranhaIdToOwner[_tokenId] == msg.sender);
162 
163 	Piranha storage piranha = piranhas[_tokenId];
164 	require (piranha.sellPrice > 0);
165 	
166 	piranha.sellPrice = 0;
167   }  
168   
169   function hungry(uint256 _tokenId) public {
170 	require (piranhaIdToOwner[_tokenId] == msg.sender);
171 
172 	Piranha storage piranha = piranhas[_tokenId];
173 	require (piranha.hungry == 0);
174 	
175 	uint8 piranhaSize=uint8(piranha.size+(now-piranha.growthStartTime)/300);
176 
177 	require (piranhaSize < 240);
178 	
179 	piranha.hungry = 1;
180   }   
181 
182   function notHungry(uint256 _tokenId) public {
183 	require (piranhaIdToOwner[_tokenId] == msg.sender);
184 
185 	Piranha storage piranha = piranhas[_tokenId];
186 	require (piranha.hungry == 1);
187 	
188 	piranha.hungry = 0;
189   }   
190 
191   function bite(uint256 _tokenId, uint256 _victimTokenId) public payable {
192 	require (piranhaIdToOwner[_tokenId] == msg.sender);
193 	require (msg.value == biteCost);
194 	
195 	Piranha storage piranha = piranhas[_tokenId];
196 	Piranha storage victimPiranha = piranhas[_victimTokenId];
197 	require (piranha.hungry == 1 && victimPiranha.hungry == 1);
198 
199 	uint8 vitimPiranhaSize=uint8(victimPiranha.size+(now-victimPiranha.growthStartTime)/300);
200 	
201 	require (vitimPiranhaSize>40); // don't bite a small
202 
203 	uint8 piranhaSize=uint8(piranha.size+(now-piranha.growthStartTime)/300)+10;
204 	
205 	if (piranhaSize>240) { 
206 	    piranha.size = 240; //maximum
207 		piranha.hungry = 0;
208 	} else {
209 	    piranha.size = piranhaSize;
210 	}
211      
212 	//decrease victim size 
213 	if (vitimPiranhaSize>=50) {
214 	    vitimPiranhaSize-=10;
215 	    victimPiranha.size = vitimPiranhaSize;
216 	}
217     else {
218 		victimPiranha.size=40;
219 	}
220 	
221 	piranha.growthStartTime=now;
222 	victimPiranha.growthStartTime=now;
223 	
224   }    
225   
226   function breeding(uint256 _maleTokenId, uint256 _femaleTokenId) public payable {
227   
228     require (piranhaIdToOwner[_maleTokenId] ==  msg.sender && piranhaIdToOwner[_femaleTokenId] == msg.sender);
229 	require (msg.value == breedingCost);
230 
231 	Piranha storage piranhaMale = piranhas[_maleTokenId];
232 	Piranha storage piranhaFemale = piranhas[_femaleTokenId];
233 	
234 	uint8 maleSize=uint8(piranhaMale.size+(now-piranhaMale.growthStartTime)/300);
235 	if (maleSize>240)
236 	   piranhaMale.size=240;
237 	else 
238 	   piranhaMale.size=maleSize;
239 
240 	uint8 femaleSize=uint8(piranhaFemale.size+(now-piranhaFemale.growthStartTime)/300);
241 	if (femaleSize>240)
242 	   piranhaFemale.size=240;
243 	else 
244 	   piranhaFemale.size=femaleSize;
245 	   
246 	require (piranhaMale.size > 150 && piranhaFemale.size > 150);
247 	
248 	uint8 newbornSize = uint8(SafeMath.div(SafeMath.add(piranhaMale.size, piranhaMale.size),4));
249 	
250 	uint256 maxGen=piranhaFemale.gen;
251 	uint256 minGen=piranhaMale.gen;
252 	
253 	if (piranhaMale.gen > piranhaFemale.gen) {
254 		maxGen=piranhaMale.gen;
255 		minGen=piranhaFemale.gen;
256 	} 
257 	
258 	uint256 randNum = uint256(block.blockhash(block.number-1));
259 	uint256 newbornGen;
260 	uint8 newbornUnique = uint8(randNum%100+1); //chance to get rare piranha
261 	
262 	if (randNum%(10+maxGen) == 1) { // new generation, difficult depends on maxgen
263 		newbornGen = SafeMath.add(maxGen,1);
264 	} else if (maxGen == minGen) {
265 		newbornGen = maxGen;
266 	} else {
267 		newbornGen = SafeMath.add(randNum%(maxGen-minGen+1),minGen);
268 	}
269 	
270 	// 5% chance to get rare piranhas for each gen
271 	if (newbornUnique > 5) 
272 		newbornUnique = 0;
273 		
274      //initiate new size, cancel selling
275 	 piranhaMale.size = uint8(SafeMath.div(piranhaMale.size,2));		
276      piranhaFemale.size = uint8(SafeMath.div(piranhaFemale.size,2));	
277 
278 	 piranhaMale.growthStartTime = now;	 
279 	 piranhaFemale.growthStartTime = now;	 
280 
281 	 piranhaMale.sellPrice = 0;	 
282 	 piranhaFemale.sellPrice = 0;	 
283 		
284 	_createPiranha("EthPiranha", msg.sender, 0, newbornSize, newbornGen, newbornUnique, 0);
285   
286   }
287   
288   function allPiranhasInfo(uint256 _startPiranhaId) public view returns (address[] owners, uint256[] sizes, uint8[] hungry, uint256[] prices) { //for web site view
289 	
290 	Piranha storage piranha;
291 	uint256 indexTo = totalSupply();
292 	
293     if (indexTo == 0 || _startPiranhaId >= indexTo) {
294         // Return an empty array
295       return (new address[](0), new uint256[](0), new uint8[](0), new uint256[](0));
296     }
297 
298 	if (indexTo > _startPiranhaId+1000)
299 		indexTo = _startPiranhaId + 1000;
300 		
301     uint256 totalResultPiranhas = indexTo - _startPiranhaId;		
302 		
303 	address[] memory owners_res = new address[](totalResultPiranhas);
304 	uint256[] memory size_res = new uint256[](totalResultPiranhas);
305 	uint8[] memory hungry_res = new uint8[](totalResultPiranhas);
306 	uint256[] memory prices_res = new uint256[](totalResultPiranhas);
307 	
308 	for (uint256 piranhaId = _startPiranhaId; piranhaId < indexTo; piranhaId++) {
309 	  piranha = piranhas[piranhaId];
310 	  
311 	  owners_res[piranhaId - _startPiranhaId] = piranhaIdToOwner[piranhaId];
312       size_res[piranhaId - _startPiranhaId] = uint256(piranha.size+(now-piranha.growthStartTime)/300);	  
313 	  hungry_res[piranhaId - _startPiranhaId] = piranha.hungry;
314 	  prices_res[piranhaId - _startPiranhaId] = piranha.sellPrice;
315 	}
316 	
317 	return (owners_res, size_res, hungry_res, prices_res);
318   }
319   
320   function totalSupply() public view returns (uint256 total) { //ERC721
321     return piranhas.length;
322   }
323 
324   function transfer(address _to, uint256 _tokenId) public { //ERC721
325     require(_owns(msg.sender, _tokenId));
326     require(_addressNotNull(_to));
327 
328 	_transfer(msg.sender, _to, _tokenId);
329   }
330 
331 
332   /* PRIVATE FUNCTIONS */
333   function _addressNotNull(address _to) private pure returns (bool) {
334     return _to != address(0);
335   }
336 
337 
338   function _createPiranha(string _name, address _owner, uint256 _price, uint8 _size, uint256 _gen, uint8 _unique, uint8 _hungry) private {
339     Piranha memory _piranha = Piranha({
340       name: _name,
341 	  size: _size,
342 	  gen: _gen,
343 	  unique: _unique,	  
344 	  growthStartTime: now,
345 	  sellPrice: _price,
346 	  hungry: _hungry
347     });
348     uint256 newPiranhaId = piranhas.push(_piranha) - 1;
349 
350     require(newPiranhaId == uint256(uint32(newPiranhaId))); //check maximum limit of tokens
351 
352     PiranhaCreated(newPiranhaId, _name, _owner);
353 
354     _transfer(address(0), _owner, newPiranhaId);
355   }
356 
357   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
358     return _checkedAddr == piranhaIdToOwner[_tokenId];
359   }
360 
361   function _transfer(address _from, address _to, uint256 _tokenId) private {
362     ownershipTokenCount[_to]++;
363     piranhaIdToOwner[_tokenId] = _to;
364 
365     // When creating new piranhas _from is 0x0, but we can't account that address.
366     if (_from != address(0)) {
367       ownershipTokenCount[_from]--;
368     }
369 
370     // Emit the transfer event.
371     Transfer(_from, _to, _tokenId);
372   }
373 }
374 
375 library SafeMath {
376 
377   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
378     if (a == 0) {
379       return 0;
380     }
381     uint256 c = a * b;
382     assert(c / a == b);
383     return c;
384   }
385 
386   function div(uint256 a, uint256 b) internal pure returns (uint256) {
387     // assert(b > 0); // Solidity automatically throws when dividing by 0
388     uint256 c = a / b;
389     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390     return c;
391   }
392 
393   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
394     assert(b <= a);
395     return a - b;
396   }
397 
398   function add(uint256 a, uint256 b) internal pure returns (uint256) {
399     uint256 c = a + b;
400     assert(c >= a);
401     return c;
402   }
403 }