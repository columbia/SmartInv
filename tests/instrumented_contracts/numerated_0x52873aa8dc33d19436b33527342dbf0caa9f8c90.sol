1 pragma solidity ^0.4.21;
2 
3 contract ERC721 {
4     // Required methods
5     function approve(address _to, uint256 _tokenId) public;
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function implementsERC721() public pure returns (bool);
8     function ownerOf(uint256 _tokenId) public view returns (address addr);
9     function takeOwnership(uint256 _tokenId) public;
10     function totalSupply() public view returns (uint256 total);
11     function transferFrom(address _from, address _to, uint256 _tokenId) public;
12     function transfer(address _to, uint256 _tokenId) public;
13 
14     event Transfer(address indexed from, address indexed to, uint256 tokenId);
15     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
16 
17     // Optional
18     // function name() public view returns (string name);
19     // function symbol() public view returns (string symbol);
20     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
21     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
22 }
23 
24 
25 contract Ownable {
26     address public owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     /**
31      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32      * account.
33      */
34     function Ownable() public {
35         owner = msg.sender;
36     }
37 
38 
39     /**
40      * @dev Throws if called by any account other than the owner.
41      */
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47 
48     /**
49      * @dev Allows the current owner to transfer control of the contract to a newOwner.
50      * @param newOwner The address to transfer ownership to.
51      */
52     function transferOwnership(address newOwner) public onlyOwner {
53         require(newOwner != address(0));
54         OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56     }
57 
58 }
59 
60 
61 library SafeMath {
62 
63     /**
64     * @dev Multiplies two numbers, throws on overflow.
65     */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75     /**
76     * @dev Integer division of two numbers, truncating the quotient.
77     */
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return c;
83     }
84 
85     /**
86     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87     */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         assert(b <= a);
90         return a - b;
91     }
92 
93     /**
94     * @dev Adds two numbers, throws on overflow.
95     */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 }
102 
103 contract CountryJackpot is ERC721, Ownable{
104     using SafeMath for uint256;
105     /// @dev The TokenSold event is fired whenever a token is sold.
106     event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
107 
108     /// @dev Transfer event as defined in current draft of ERC721.
109     event Transfer(address from, address to, uint256 tokenId);
110 
111     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
112     string public constant NAME = "EtherCup2018"; // solhint-disable-line
113     string public constant SYMBOL = "EthCup"; // solhint-disable-line
114 
115     //starting price for country token
116     uint256 private startingPrice = 0.01 ether;
117 
118     //step limits to increase purchase price of token effectively
119     uint256 private firstStepLimit =  1 ether;
120     uint256 private secondStepLimit = 3 ether;
121     uint256 private thirdStepLimit = 10 ether;
122 
123     //Final Jackpot value, when all buying/betting closes
124     uint256 private finalJackpotValue = 0;
125 
126     //Flag to show if the Jackpot has completed
127     bool public jackpotCompleted = false;
128 
129     /*** DATATYPES ***/
130     struct Country {
131         string name;
132     }
133 
134     Country[] private countries;
135 
136     /// @dev A mapping from country IDs to the address that owns them. All countries have some valid owner address.
137     mapping (uint256 => address) public countryIndexToOwner;
138     // A mapping from country id to address to show if the Country approved for transfer
139     mapping (uint256 => address) public countryIndexToApproved;
140     // A mapping from country id to ranks to show what rank of the Country
141     mapping (uint256 => uint256) public countryToRank;
142     //A mapping from country id to price to store the last purchase price of a country
143     mapping (uint256 => uint256) private countryToLastPrice;
144     // A mapping from country id to boolean which checks if the user has claimed jackpot for his country token
145     mapping (uint256 => bool) public  jackpotClaimedForCountry;
146     // A mapping from ranks to the ether to be won from the jackpot.
147     mapping (uint256 => uint256) public rankShare;
148 
149     // Counts how many tokens a user has.
150     mapping (address => uint256) private ownershipTokenCount;
151 
152     // @dev A mapping from countryIds to the price of the token.
153     mapping (uint256 => uint256) private countryIndexToPrice;
154 
155     //@notice Constructor that setups the share for each rank
156     function CountryJackpot() public{
157         rankShare[1] = 76;
158         rankShare[2] = 56;
159         rankShare[3] = 48;
160         rankShare[4] = 44;
161         rankShare[5] = 32;
162         rankShare[6] = 24;
163         rankShare[7] = 16;
164     }
165 
166     //@notice Aprrove the transfer of token. A user must own the token to approve it
167     function approve( address _to, uint256 _tokenId) public {
168       // Caller must own token.
169         require(_owns(msg.sender, _tokenId));
170         require(_addressNotNull(_to));
171 
172         countryIndexToApproved[_tokenId] = _to;
173         emit Approval(msg.sender, _to, _tokenId);
174     }
175 
176     //@notice Get count of how many tokens an address has
177     function balanceOf(address _owner) public view returns (uint256 balance) {
178         return ownershipTokenCount[_owner];
179     }
180 
181     //@notice Create a country with a name, called only by the owner
182     function createCountry(string _name) public onlyOwner{
183         _createCountry(_name, startingPrice);
184     }
185 
186     //@notice An address can claim his win from the jackpot after the jackpot is completed
187     function getEther(uint256 _countryIndex) public {
188         require(countryIndexToOwner[_countryIndex] == msg.sender);
189         require(jackpotCompleted);
190         require(countryToRank[_countryIndex] != 0);
191         require(!jackpotClaimedForCountry[_countryIndex]);
192 
193         jackpotClaimedForCountry[_countryIndex] = true;
194         uint256 _rankShare = rankShare[countryToRank[_countryIndex]];
195 
196         uint256 amount = ((finalJackpotValue).mul(_rankShare)).div(1000);
197         msg.sender.transfer(amount);
198     }
199 
200     //@notice Get complete information about a country token
201     function getCountry(uint256 _tokenId) public view returns (
202         string ,
203         uint256 ,
204         address ,
205         uint256
206     ) {
207         Country storage country = countries[_tokenId];
208         string memory countryName = country.name;
209         uint256 sellingPrice = countryIndexToPrice[_tokenId];
210         uint256 rank = countryToRank[_tokenId];
211         address owner = countryIndexToOwner[_tokenId];
212         return (countryName, sellingPrice, owner, rank);
213     }
214 
215     //@notice Get the current balance of the contract.
216     function getContractBalance() public view returns(uint256) {
217         return (address(this).balance);
218     }
219 
220     //@notice Get the total jackpot value, which is contract balance if the jackpot is not completed.Else
221     //its retrieved from variable jackpotCompleted
222     function getJackpotTotalValue() public view returns(uint256) {
223         if(jackpotCompleted){
224             return finalJackpotValue;
225         } else{
226             return address(this).balance;
227         }
228     }
229 
230     function implementsERC721() public pure returns (bool) {
231         return true;
232     }
233 
234 
235     /// @dev Required for ERC-721 compliance.
236     function name() public pure returns (string) {
237         return NAME;
238     }
239 
240     //@notice Get the owner of a country token
241     /// For querying owner of token
242     /// @param _tokenId The tokenID for owner inquiry
243     /// @dev Required for ERC-721 compliance.
244     function ownerOf(uint256 _tokenId)
245         public
246         view
247         returns (address)
248     {
249         address owner = countryIndexToOwner[_tokenId];
250         return (owner);
251     }
252 
253     //@dev this function is required to recieve funds
254     function () payable {
255     }
256 
257 
258     //@notice Allows someone to send ether and obtain a country token
259     function purchase(uint256 _tokenId) public payable {
260         require(!jackpotCompleted);
261         require(msg.sender != owner);
262         address oldOwner = countryIndexToOwner[_tokenId];
263         address newOwner = msg.sender;
264 
265         // Making sure token owner is not sending to self
266         require(oldOwner != newOwner);
267 
268         // Safety check to prevent against an unexpected 0x0 default.
269         require(_addressNotNull(newOwner));
270 
271         // Making sure sent amount is greater than or equal to the sellingPrice
272         require(msg.value >= sellingPrice);
273 
274         uint256 sellingPrice = countryIndexToPrice[_tokenId];
275         uint256 lastSellingPrice = countryToLastPrice[_tokenId];
276 
277         // Update prices
278         if (sellingPrice.mul(2) < firstStepLimit) {
279             // first stage
280             countryIndexToPrice[_tokenId] = sellingPrice.mul(2);
281         } else if (sellingPrice.mul(4).div(10) < secondStepLimit) {
282             // second stage
283             countryIndexToPrice[_tokenId] = sellingPrice.add(sellingPrice.mul(4).div(10));
284         } else if(sellingPrice.mul(2).div(10) < thirdStepLimit){
285             // third stage
286             countryIndexToPrice[_tokenId] = sellingPrice.add(sellingPrice.mul(2).div(10));
287         }else {
288             // fourth stage
289             countryIndexToPrice[_tokenId] = sellingPrice.add(sellingPrice.mul(15).div(100));
290         }
291 
292         _transfer(oldOwner, newOwner, _tokenId);
293 
294         //update last price to current selling price
295         countryToLastPrice[_tokenId] = sellingPrice;
296         // Pay previous tokenOwner if owner is not initial creator of country
297         if (oldOwner != owner) {
298             uint256 priceDifference = sellingPrice.sub(lastSellingPrice);
299             uint256 oldOwnerPayment = lastSellingPrice.add(priceDifference.sub(priceDifference.div(2)));
300             oldOwner.transfer(oldOwnerPayment);
301         }
302 
303         emit TokenSold(_tokenId, sellingPrice, countryIndexToPrice[_tokenId], oldOwner, newOwner, countries[_tokenId].name);
304 
305         uint256 purchaseExcess = msg.value.sub(sellingPrice);
306         msg.sender.transfer(purchaseExcess);
307     }
308 
309     //@notice set country rank by providing index, country name and rank
310     function setCountryRank(uint256 _tokenId, string _name, uint256 _rank) public onlyOwner{
311         require(_compareStrings(countries[_tokenId].name, _name));
312         countryToRank[_tokenId] = _rank;
313     }
314 
315     ///@notice set jackpotComplete to true and transfer 20 percent share of jackpot to owner
316     function setJackpotCompleted() public onlyOwner{
317         jackpotCompleted = true;
318         finalJackpotValue = address(this).balance;
319         uint256 jackpotShare = ((address(this).balance).mul(20)).div(100);
320         msg.sender.transfer(jackpotShare);
321     }
322 
323     /// @dev Required for ERC-721 compliance.
324     function symbol() public pure returns (string) {
325         return SYMBOL;
326     }
327 
328     /// @notice Allow pre-approved user to take ownership of a token
329     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
330     /// @dev Required for ERC-721 compliance.
331     function takeOwnership(uint256 _tokenId) public {
332         address newOwner = msg.sender;
333         address oldOwner = countryIndexToOwner[_tokenId];
334 
335         // Safety check to prevent against an unexpected 0x0 default.
336         require(_addressNotNull(newOwner));
337 
338         // Making sure transfer is approved
339         require(_approved(newOwner, _tokenId));
340 
341         _transfer(oldOwner, newOwner, _tokenId);
342     }
343 
344 
345     /// @notice Get all tokens of a particular address
346     function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
347         uint256 tokenCount = balanceOf(_owner);
348         if (tokenCount == 0) {
349             // Return an empty array
350             return new uint256[](0);
351         } else {
352             uint256[] memory result = new uint256[](tokenCount);
353             uint256 totalCountries = totalSupply();
354             uint256 resultIndex = 0;
355             uint256 countryId;
356 
357             for (countryId = 0; countryId < totalCountries; countryId++) {
358                 if (countryIndexToOwner[countryId] == _owner)
359                 {
360                     result[resultIndex] = countryId;
361                     resultIndex++;
362                 }
363             }
364             return result;
365         }
366     }
367 
368     /// @notice Total amount of country tokens.
369     /// @dev Required for ERC-721 compliance.
370     function totalSupply() public view returns (uint256 total) {
371         return countries.length;
372     }
373 
374     /// @notice Owner initates the transfer of the token to another account
375     /// @param _to The address for the token to be transferred to.
376     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
377     /// @dev Required for ERC-721 compliance.
378     function transfer(
379         address _to,
380         uint256 _tokenId
381     ) public {
382         require(!jackpotCompleted);
383         require(_owns(msg.sender, _tokenId));
384         require(_addressNotNull(_to));
385 
386         _transfer(msg.sender, _to, _tokenId);
387     }
388 
389     /// @notice Third-party initiates transfer of token from address _from to address _to
390     /// @param _from The address for the token to be transferred from.
391     /// @param _to The address for the token to be transferred to.
392     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
393     /// @dev Required for ERC-721 compliance.
394     function transferFrom(
395         address _from,
396         address _to,
397         uint256 _tokenId
398     ) public {
399         require(!jackpotCompleted);
400         require(_owns(_from, _tokenId));
401         require(_approved(_to, _tokenId));
402         require(_addressNotNull(_to));
403 
404         _transfer(_from, _to, _tokenId);
405     }
406 
407     /*** PRIVATE FUNCTIONS ***/
408     /// Safety check on _to address to prevent against an unexpected 0x0 default.
409     function _addressNotNull(address _to) private pure returns (bool) {
410         return _to != address(0);
411     }
412 
413     /// For checking approval of transfer for address _to
414     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
415         return countryIndexToApproved[_tokenId] == _to;
416     }
417 
418 
419     /// For creating Country
420     function _createCountry(string _name, uint256 _price) private {
421         Country memory country = Country({
422             name: _name
423         });
424 
425         uint256 newCountryId = countries.push(country) - 1;
426 
427         countryIndexToPrice[newCountryId] = _price;
428         countryIndexToOwner[newCountryId] = msg.sender;
429         ownershipTokenCount[msg.sender] = ownershipTokenCount[msg.sender].add(1);
430     }
431 
432     /// Check for token ownership
433     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
434         return claimant == countryIndexToOwner[_tokenId];
435     }
436 
437     /// @dev Assigns ownership of a specific Country to an address.
438     function _transfer(address _from, address _to, uint256 _tokenId) private {
439         // clear any previously approved ownership exchange
440         delete countryIndexToApproved[_tokenId];
441 
442         // Since the number of countries is capped to 32 we can't overflow this
443         ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
444         //transfer ownership
445         countryIndexToOwner[_tokenId] = _to;
446 
447         ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
448         // Emit the transfer event.
449         emit Transfer(_from, _to, _tokenId);
450     }
451 
452     function _compareStrings(string a, string b) private pure returns (bool){
453         return keccak256(a) == keccak256(b);
454     }
455 }