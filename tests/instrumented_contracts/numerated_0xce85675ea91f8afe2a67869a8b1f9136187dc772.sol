1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable 
9 {
10   address public owner;
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12     
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 }
39 
40 contract NFT 
41 {
42   function totalSupply() public constant returns (uint);
43   function balanceOf(address) public constant returns (uint);
44   function tokenOfOwnerByIndex(address owner, uint index) public constant returns (uint);
45   function ownerOf(uint tokenId) public constant returns (address);
46   function transfer(address to, uint tokenId) public;
47   function takeOwnership(uint tokenId) public;
48   function approve(address beneficiary, uint tokenId) public;
49   function metadata(uint tokenId) public constant returns (string);
50 }
51 
52 contract NFTEvents 
53 {
54   event TokenCreated(uint tokenId, address owner, string metadata);
55   event TokenDestroyed(uint tokenId, address owner);
56   event TokenTransferred(uint tokenId, address from, address to);
57   event TokenTransferAllowed(uint tokenId, address beneficiary);
58   event TokenTransferDisallowed(uint tokenId, address beneficiary);
59   event TokenMetadataUpdated(uint tokenId, address owner, string data);
60 }
61 
62 contract BasicNFT is NFT, NFTEvents 
63 {
64   uint public totalTokens;
65 
66   // Array of owned tokens for a user
67   mapping(address => uint[]) public ownedTokens;
68   mapping(address => uint) _virtualLength;
69   mapping(uint => uint) _tokenIndexInOwnerArray;
70 
71   // Mapping from token ID to owner
72   mapping(uint => address) public tokenOwner;
73 
74   // Allowed transfers for a token (only one at a time)
75   mapping(uint => address) public allowedTransfer;
76 
77   // Metadata associated with each token
78   mapping(uint => string) public tokenMetadata;
79 
80   function totalSupply() public constant returns (uint) 
81   {
82     return totalTokens;
83   }
84 
85   function balanceOf(address owner) public constant returns (uint) 
86   {
87     return _virtualLength[owner];
88   }
89 
90   function tokenOfOwnerByIndex(address owner, uint index) public constant returns (uint) 
91   {
92     require(index >= 0 && index < balanceOf(owner));
93     return ownedTokens[owner][index];
94   }
95 
96   function getAllTokens(address owner) public constant returns (uint[]) 
97   {
98     uint size = _virtualLength[owner];
99     uint[] memory result = new uint[](size);
100     for (uint i = 0; i < size; i++) {
101       result[i] = ownedTokens[owner][i];
102     }
103     return result;
104   }
105 
106   function ownerOf(uint tokenId) public constant returns (address) 
107   {
108     return tokenOwner[tokenId];
109   }
110 
111   function transfer(address to, uint tokenId) public
112   {
113     require(tokenOwner[tokenId] == msg.sender || allowedTransfer[tokenId] == msg.sender);
114     _transfer(tokenOwner[tokenId], to, tokenId);
115   }
116 
117   function takeOwnership(uint tokenId) public 
118   {
119     require(allowedTransfer[tokenId] == msg.sender);
120     _transfer(tokenOwner[tokenId], msg.sender, tokenId);
121   }
122 
123   function approve(address beneficiary, uint tokenId) public 
124   {
125     require(msg.sender == tokenOwner[tokenId]);
126     if (allowedTransfer[tokenId] != 0) 
127     {
128       allowedTransfer[tokenId] = 0;
129       TokenTransferDisallowed(tokenId, allowedTransfer[tokenId]);
130     }
131     allowedTransfer[tokenId] = beneficiary;
132     TokenTransferAllowed(tokenId, beneficiary);
133   }
134 
135   function metadata(uint tokenId) constant public returns (string) 
136   {
137     return tokenMetadata[tokenId];
138   }
139 
140   function updateTokenMetadata(uint tokenId, string _metadata) internal returns(bool)
141   {
142     require(msg.sender == tokenOwner[tokenId]);
143     tokenMetadata[tokenId] = _metadata;
144     TokenMetadataUpdated(tokenId, msg.sender, _metadata);
145     return true;
146   }
147 
148   function _transfer(address from, address to, uint tokenId) internal returns(bool)
149   {
150     allowedTransfer[tokenId] = 0;
151     _removeTokenFrom(from, tokenId);
152     _addTokenTo(to, tokenId);
153     TokenTransferred(tokenId, from, to);
154     return true;
155   }
156 
157   function _removeTokenFrom(address from, uint tokenId) internal 
158   {
159     require(_virtualLength[from] > 0);
160     uint length = _virtualLength[from];
161     uint index = _tokenIndexInOwnerArray[tokenId];
162     uint swapToken = ownedTokens[from][length - 1];
163     ownedTokens[from][index] = swapToken;
164     _tokenIndexInOwnerArray[swapToken] = index;
165     _virtualLength[from]--;
166   }
167 
168   function _addTokenTo(address owner, uint tokenId) internal 
169   {
170     if (ownedTokens[owner].length == _virtualLength[owner]) 
171     {
172       ownedTokens[owner].push(tokenId);
173     } 
174     else 
175     {
176       ownedTokens[owner][_virtualLength[owner]] = tokenId;
177     }
178     tokenOwner[tokenId] = owner;
179     _tokenIndexInOwnerArray[tokenId] = _virtualLength[owner];
180     _virtualLength[owner]++;
181   }
182 }
183 
184 contract PlanetToken is Ownable, BasicNFT 
185 {
186   string public name = 'Planet Tokens';
187   string public symbol = 'PT';
188    
189   mapping (uint => uint) public cordX;
190   mapping (uint => uint) public cordY;
191   mapping (uint => uint) public cordZ;
192   mapping (uint => uint) public lifeD;
193   mapping (uint => uint) public lifeN;
194   mapping (uint => uint) public lifeA;    
195   mapping (uint => uint) public latestPing;
196     
197   struct planet
198   {
199     uint x;
200     uint y;
201     uint z;
202     string name;
203     address owner;
204     string liason;
205     string url;
206     uint cost;
207     uint index;
208   }
209     
210   struct _donations
211   {
212       uint start;
213       uint genesis;
214       uint interval;
215       uint ppp;
216       uint amount;
217       uint checkpoint;
218   }
219 
220   mapping(uint => planet) planets;
221   mapping(address => _donations) donations;
222   
223   string private universe;
224   uint private min_donation;
225   address private donation_address;
226   uint private coordinate_limit;
227 
228   event TokenPing(uint tokenId);
229 
230   function () public payable 
231   {
232       donation_address.transfer(msg.value);
233   }
234     
235   function PlanetToken(string UniverseName, uint CoordinateLimit, address DonationAddress, uint StartingWeiDonation, uint BlockIntervals, uint WeiPerPlanet) public
236   {
237       universe = UniverseName;
238       min_donation = StartingWeiDonation;
239       coordinate_limit = CoordinateLimit;
240       donation_address = DonationAddress;
241       donations[donation_address].start = min_donation;
242       donations[donation_address].genesis = block.number;
243       donations[donation_address].checkpoint = block.number;
244       donations[donation_address].interval = BlockIntervals;
245       donations[donation_address].ppp = WeiPerPlanet;
246       donations[donation_address].amount = min_donation;
247   }
248 
249   function assignNewPlanet(address beneficiary, uint x, uint y, uint z, string _planetName, string liason, string url) public payable 
250   {  
251     // Check current fee
252     uint MinimumDonation = donations[donation_address].amount;
253       
254     // Check required paramters
255     require(tokenOwner[buildTokenId(x, y, z)] == 0);
256     require(msg.value >= MinimumDonation);
257     require(x <= coordinate_limit);
258     require(y <= coordinate_limit);
259     require(z <= coordinate_limit);
260      
261     // Update token records
262     latestPing[buildTokenId(x, y, z)] = now;
263     _addTokenTo(beneficiary, buildTokenId(x, y, z));
264     totalTokens++;
265     tokenMetadata[buildTokenId(x, y, z)] = _planetName;
266 
267     // Update galactic records
268     cordX[buildTokenId(x, y, z)] = x;
269     cordY[buildTokenId(x, y, z)] = y;
270     cordZ[buildTokenId(x, y, z)] = z;
271 
272     // Update DNA records
273     lifeD[buildTokenId(x, y, z)] = uint256(keccak256(x, '|x|', msg.sender, '|', universe));
274     lifeN[buildTokenId(x, y, z)] = uint256(keccak256(y, '|y|', msg.sender, '|', universe));
275     lifeA[buildTokenId(x, y, z)] = uint256(keccak256(z, '|z|', msg.sender, '|', universe));
276       
277     // Map the planet object too ...
278     planets[buildTokenId(x, y, z)].x = x;
279     planets[buildTokenId(x, y, z)].x = y;
280     planets[buildTokenId(x, y, z)].x = z;
281     planets[buildTokenId(x, y, z)].name = _planetName;
282     planets[buildTokenId(x, y, z)].owner = beneficiary;
283     planets[buildTokenId(x, y, z)].liason = liason;
284     planets[buildTokenId(x, y, z)].url = url;
285     planets[buildTokenId(x, y, z)].index = totalTokens - 1;
286     planets[buildTokenId(x, y, z)].cost = msg.value;
287 
288     // Finalize process
289     TokenCreated(buildTokenId(x, y, z), beneficiary, _planetName);  
290     donation_address.transfer(msg.value);
291       
292     // Update donation info
293     uint this_block = block.number;
294     uint new_checkpoint = donations[donation_address].checkpoint + donations[donation_address].interval; 
295     if(this_block > new_checkpoint)
296     {
297         donations[donation_address].checkpoint = this_block;
298         donations[donation_address].amount = donations[donation_address].ppp * totalTokens;
299     }
300   }
301     
302   function MinimumDonation() public view returns(uint)
303   {
304       return donations[donation_address].amount;
305   }
306     
307   function BlocksToGo() public view returns(uint)
308   {
309       uint this_block = block.number;
310       uint next_block = donations[donation_address].checkpoint + donations[donation_address].interval;
311       if(this_block < next_block)
312       {
313           return next_block - this_block;
314       }
315       else
316       {
317           return 0;
318       }
319   }
320     
321   function GetLiasonName(uint x, uint y, uint z) public view returns(string)
322   {
323       return planets[buildTokenId(x, y, z)].liason;
324   }
325 
326   function GetLiasonURL(uint x, uint y, uint z) public view returns(string)
327   {
328       return planets[buildTokenId(x, y, z)].url;
329   }
330     
331   function GetIndex(uint x, uint y, uint z) public view returns(uint)
332   {
333       return planets[buildTokenId(x, y, z)].index;
334   }
335     
336   function GetCost(uint x, uint y, uint z) public view returns(uint)
337   {
338       return planets[buildTokenId(x, y, z)].cost;
339   }
340     
341   function UpdatedDonationAddress(address NewAddress) onlyOwner public
342   {
343       address OldAddress = donation_address;
344       donation_address = NewAddress;
345       donations[donation_address].start = donations[OldAddress].start;
346       donations[donation_address].genesis = donations[OldAddress].genesis;
347       donations[donation_address].checkpoint = donations[OldAddress].checkpoint;
348       donations[donation_address].interval = donations[OldAddress].interval;
349       donations[donation_address].ppp = donations[OldAddress].ppp;
350       donations[donation_address].amount = donations[OldAddress].amount;
351       
352   }
353 
354   function ping(uint tokenId) public 
355   {
356     require(msg.sender == tokenOwner[tokenId]);
357     latestPing[tokenId] = now;
358     TokenPing(tokenId);
359   }
360 
361   function buildTokenId(uint x, uint y, uint z) public view returns (uint256) 
362   {
363     return uint256(keccak256(x, '|', y, '|', z, '|', universe));
364   }
365 
366   function exists(uint x, uint y, uint z) public constant returns (bool) 
367   {
368     return ownerOfPlanet(x, y, z) != 0;
369   }
370 
371   function ownerOfPlanet(uint x, uint y, uint z) public constant returns (address) 
372   {
373     return tokenOwner[buildTokenId(x, y, z)];
374   }
375 
376   function transferPlanet(address to, uint x, uint y, uint z) public 
377   {
378     require(msg.sender == tokenOwner[buildTokenId(x, y, z)]);
379     planets[buildTokenId(x, y, z)].owner = to;
380   }
381 
382   function planetName(uint x, uint y, uint z) constant public returns (string) 
383   {
384     return tokenMetadata[buildTokenId(x, y, z)];
385   }
386     
387   function planetCordinates(uint tokenId) public constant returns (uint[]) 
388   {
389     uint[] memory data = new uint[](3);
390     data[0] = cordX[tokenId];
391     data[1] = cordY[tokenId];
392     data[2] = cordZ[tokenId];
393     return data;
394   }
395     
396   function planetLife(uint x, uint y, uint z) constant public returns (uint[]) 
397   {
398     uint[] memory dna = new uint[](3);
399     dna[0] = lifeD[buildTokenId(x, y, z)];
400     dna[1] = lifeN[buildTokenId(x, y, z)];
401     dna[2] = lifeA[buildTokenId(x, y, z)];
402     return dna;
403   }
404 
405   function updatePlanetName(uint x, uint y, uint z, string _planetName) public 
406   {
407     if(updateTokenMetadata(buildTokenId(x, y, z), _planetName))
408     {
409         planets[buildTokenId(x, y, z)].name = _planetName;
410     }
411   }
412   
413   function updatePlanetLiason(uint x, uint y, uint z, string LiasonName) public 
414   {
415     require(msg.sender == tokenOwner[buildTokenId(x, y, z)]);
416     planets[buildTokenId(x, y, z)].liason = LiasonName;
417   }
418     
419   function updatePlanetURL(uint x, uint y, uint z, string LiasonURL) public 
420   {
421     require(msg.sender == tokenOwner[buildTokenId(x, y, z)]);
422     planets[buildTokenId(x, y, z)].url = LiasonURL;
423   }
424 }