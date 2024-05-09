1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /*
53  * Ownable
54  *
55  * Base contract with an owner.
56  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
57  */
58 
59 contract Ownable {
60     address public owner;
61     function Ownable() {
62     owner = msg.sender;
63     }
64 
65   modifier onlyOwner() {
66     if (msg.sender == owner)
67       _;
68   }
69 
70   function transferOwnership(address newOwner) onlyOwner {
71     if (newOwner != address(0)) owner = newOwner;
72   }
73 
74 }
75 
76 // @title Interface for contracts conforming to ERC-721 Non-Fungible Tokens
77 // @author Dieter Shirley dete@axiomzen.co (httpsgithub.comdete)
78 contract ERC721 {
79     //Required methods
80     function approve(address _to, uint256 _tokenId) public;
81     function balanceOf(address _owner) public view returns (uint256 balance);
82     function implementsERC721() public pure returns (bool);
83     function ownerOf(uint256 _tokenId) public view returns (address addr);
84     function takeOwnership(uint256 _tokenId) public;
85     function totalSupply() public view returns (uint256 total);
86     function transferFrom(address _from, address _to, uint256 _tokenId) public;
87     function transfer(address _to, uint256 _tokenId) public;
88 
89     event Transfer(address indexed from, address indexed to, uint256 tokenId);
90     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
91 
92     //Optional
93     //function name() public view returns (string name);
94     //function symbol() public view returns (string symbol);
95     //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
96     //function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
97 }
98 
99 
100 contract Avatarium is Ownable, ERC721 {
101 
102 
103     // --- Events --- //
104 
105 
106     // @dev The Birth event is fired, whenever a new Avatar has been created.
107     event Birth(
108         uint256 tokenId, 
109         string name, 
110         address owner);
111 
112     // @dev The TokenSold event is fired, whenever a token is sold.
113     event TokenSold(
114         uint256 tokenId, 
115         uint256 oldPrice, 
116         uint256 newPrice, 
117         address prevOwner, 
118         address winner, 
119         string name);
120     
121     
122     // --- Constants --- //
123 
124 
125     // The name and the symbol of the NFT, as defined in ERC-721.
126     string public constant NAME = "Avatarium";
127     string public constant SYMBOL = "ΛV";
128 
129     // Prices and iteration steps
130     uint256 private startingPrice = 0.02 ether;
131     uint256 private firstIterationLimit = 0.05 ether;
132     uint256 private secondIterationLimit = 0.5 ether;
133 
134     // Addresses that can execute important functions.
135     address public addressCEO;
136     address public addressCOO;
137 
138 
139     // --- Storage --- //
140 
141 
142     // @dev A mapping from Avatar ID to the owner's address.
143     mapping (uint => address) public avatarIndexToOwner;
144 
145     // @dev A mapping from the owner's address to the tokens it owns.
146     mapping (address => uint256) public ownershipTokenCount;
147 
148     // @dev A mapping from Avatar's ID to an address that has been approved
149     // to call transferFrom().
150     mapping (uint256 => address) public avatarIndexToApproved;
151 
152     // @dev A private mapping from Avatar's ID to its price.
153     mapping (uint256 => uint256) private avatarIndexToPrice;
154 
155 
156     // --- Datatypes --- //
157 
158 
159     // The main struct
160     struct Avatar {
161         string name;
162     }
163 
164     Avatar[] public avatars;
165 
166 
167     // --- Access Modifiers --- //
168 
169 
170     // @dev Access only to the CEO-functionality.
171     modifier onlyCEO() {
172         require(msg.sender == addressCEO);
173         _;
174     }
175 
176     // @dev Access only to the COO-functionality.
177     modifier onlyCOO() {
178         require(msg.sender == addressCOO);
179         _;
180     }
181 
182     // @dev Access to the C-level in general.
183     modifier onlyCLevel() {
184         require(msg.sender == addressCEO || msg.sender == addressCOO);
185         _;
186     }
187 
188 
189     // --- Constructor --- //
190 
191 
192     function Avatarium() public {
193         addressCEO = msg.sender;
194         addressCOO = msg.sender;
195     }
196 
197 
198     // --- Public functions --- //
199 
200 
201     //@dev Assigns a new address as the CEO. Only available to the current CEO.
202     function setCEO(address _newCEO) public onlyCEO {
203         require(_newCEO != address(0));
204 
205         addressCEO = _newCEO;
206     }
207 
208     // @dev Assigns a new address as the COO. Only available to the current COO.
209     function setCOO(address _newCOO) public onlyCEO {
210         require(_newCOO != address(0));
211 
212         addressCOO = _newCOO;
213     }
214 
215     // @dev Grants another address the right to transfer a token via 
216     // takeOwnership() and transferFrom()
217     function approve(address _to, uint256 _tokenId) public {
218         // Check the ownership
219         require(_owns(msg.sender, _tokenId));
220 
221         avatarIndexToApproved[_tokenId] = _to;
222 
223         // Fire the event
224         Approval(msg.sender, _to, _tokenId);
225     }
226 
227     // @dev Checks the balanse of the address, ERC-721 compliance
228     function balanceOf(address _owner) public view returns (uint256 balance) {
229         return ownershipTokenCount[_owner];
230     }
231 
232     // @dev Creates a new Avatar
233     function createAvatar(string _name, uint256 _rank) public onlyCLevel {
234         _createAvatar(_name, address(this), _rank);
235     }
236 
237     // @dev Returns the information on a certain Avatar
238     function getAvatar(uint256 _tokenId) public view returns (
239         string avatarName,
240         uint256 sellingPrice,
241         address owner
242     ) {
243         Avatar storage avatar = avatars[_tokenId];
244         avatarName = avatar.name;
245         sellingPrice = avatarIndexToPrice[_tokenId];
246         owner = avatarIndexToOwner[_tokenId];
247     }
248 
249     function implementsERC721() public pure returns (bool) {
250         return true;
251     }
252 
253     // @dev Queries the owner of the token.
254     function ownerOf(uint256 _tokenId) public view returns (address owner) {
255         owner = avatarIndexToOwner[_tokenId];
256         require(owner != address(0));
257     }
258 
259     function payout(address _to) public onlyCLevel {
260         _payout(_to);
261     }
262 
263     // @dev Allows to purchase an Avatar for Ether.
264     function purchase(uint256 _tokenId) public payable {
265         address oldOwner = avatarIndexToOwner[_tokenId];
266         address newOwner = msg.sender;
267 
268         uint256 sellingPrice = avatarIndexToPrice[_tokenId];
269 
270         require(oldOwner != newOwner);
271         require(_addressNotNull(newOwner));
272         require(msg.value == sellingPrice);
273 
274         uint256 payment = uint256(SafeMath.div(
275                                   SafeMath.mul(sellingPrice, 94), 100));
276         uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
277 
278         // Updating prices
279         if (sellingPrice < firstIterationLimit) {
280         // first stage
281             avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
282         } else if (sellingPrice < secondIterationLimit) {
283         // second stage
284             avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
285         } else {
286         // third stage
287             avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
288         }
289 
290         _transfer(oldOwner, newOwner, _tokenId);
291 
292         // Pay previous token Owner, if it's not the contract
293         if (oldOwner != address(this)) {
294             oldOwner.transfer(payment);
295         }
296 
297         // Fire event
298         
299         TokenSold(
300             _tokenId,
301             sellingPrice,
302             avatarIndexToPrice[_tokenId],
303             oldOwner,
304             newOwner,
305             avatars[_tokenId].name);
306 
307         // Transferring excessess back to the sender
308         msg.sender.transfer(purchaseExcess);
309     }
310 
311     // @dev Queries the price of a token.
312     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
313         return avatarIndexToPrice[_tokenId];
314     }
315     
316     //@dev Allows pre-approved user to take ownership of a token.
317     function takeOwnership(uint256 _tokenId) public {
318         address newOwner = msg.sender;
319         address oldOwner = avatarIndexToOwner[_tokenId];
320 
321         // Safety check to prevent against an unexpected 0x0 default.
322         require(_addressNotNull(newOwner));
323 
324         //Making sure transfer is approved
325         require(_approved(newOwner, _tokenId));
326 
327         _transfer(oldOwner, newOwner, _tokenId);
328     }
329 
330     // @dev Required for ERC-721 compliance.
331     function totalSupply() public view returns (uint256 total) {
332         return avatars.length;
333     }
334 
335     // @dev Owner initates the transfer of the token to another account.
336     function transfer(
337         address _to,
338         uint256 _tokenId
339     ) public {
340         require(_owns(msg.sender, _tokenId));
341         require(_addressNotNull(_to));
342 
343         _transfer(msg.sender, _to, _tokenId);
344     }
345 
346     // @dev Third-party initiates transfer of token from address _from to
347     // address _to.
348     function transferFrom(
349         address _from,
350         address _to,
351         uint256 _tokenId
352     ) public {
353         require(_owns(_from, _tokenId));
354         require(_approved(_to, _tokenId));
355         require(_addressNotNull(_to));
356 
357         _transfer(_from, _to, _tokenId);
358     }
359 
360 
361     // --- Private Functions --- // 
362 
363 
364     // Safety check on _to address to prevent against an unexpected 0x0 default.
365     function _addressNotNull(address _to) private pure returns (bool) {
366         return _to != address(0);
367     }
368 
369     // For checking approval of transfer for address _to
370     function _approved(address _to, uint256 _tokenId)
371     private 
372     view 
373     returns (bool) {
374         return avatarIndexToApproved[_tokenId] == _to;
375     }
376 
377     // For creating Avatars.
378     function _createAvatar(
379         string _name,
380         address _owner, 
381         uint256 _rank) 
382         private {
383     
384     // Getting the startingPrice
385     uint256 _price;
386     if (_rank == 1) {
387         _price = startingPrice;
388     } else if (_rank == 2) {
389         _price = 2 * startingPrice;
390     } else if (_rank == 3) {
391         _price = SafeMath.mul(4, startingPrice);
392     } else if (_rank == 4) {
393         _price = SafeMath.mul(8, startingPrice);
394     } else if (_rank == 5) {
395         _price = SafeMath.mul(16, startingPrice);
396     } else if (_rank == 6) {
397         _price = SafeMath.mul(32, startingPrice);
398     } else if (_rank == 7) {
399         _price = SafeMath.mul(64, startingPrice);
400     } else if (_rank == 8) {
401         _price = SafeMath.mul(128, startingPrice);
402     } else if (_rank == 9) {
403         _price = SafeMath.mul(256, startingPrice);
404     } 
405 
406     Avatar memory _avatar = Avatar({name: _name});
407 
408     uint256 newAvatarId = avatars.push(_avatar) - 1;
409 
410     avatarIndexToPrice[newAvatarId] = _price;
411 
412     // Fire event
413     Birth(newAvatarId, _name, _owner);
414 
415     // Transfer token to the contract
416     _transfer(address(0), _owner, newAvatarId);
417     }
418 
419     // @dev Checks for token ownership.
420     function _owns(address claimant, uint256 _tokenId) 
421     private 
422     view 
423     returns (bool) {
424         return claimant == avatarIndexToOwner[_tokenId];
425     }
426 
427     // @dev Pays out balance on contract
428     function _payout(address _to) private {
429         if (_to == address(0)) {
430             addressCEO.transfer(this.balance);
431         } else {
432             _to.transfer(this.balance);
433         }
434     }
435 
436     // @dev Assigns ownership of a specific Avatar to an address.
437     function _transfer(address _from, address _to, uint256 _tokenId) private {
438         ownershipTokenCount[_to]++;
439         avatarIndexToOwner[_tokenId] = _to;
440 
441         if (_from != address(0)) {
442             ownershipTokenCount[_from]--;
443             delete avatarIndexToApproved[_tokenId];
444         }
445 
446         // Fire event
447         Transfer(_from, _to, _tokenId);
448     }
449 }