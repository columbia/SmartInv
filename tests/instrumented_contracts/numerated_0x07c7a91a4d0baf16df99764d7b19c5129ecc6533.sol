1 pragma solidity ^0.4.18;
2 
3 contract ERC721 {
4     // ERC20 compatible functions
5     // use variable getter
6     // function name() constant returns (string name);
7     // function symbol() constant returns (string symbol);
8     function totalSupply() public constant returns (uint256);
9     function balanceOf(address _owner) public constant returns (uint balance);
10     function ownerOf(uint256 _tokenId) public constant returns (address owner);
11     function approve(address _to, uint256 _tokenId) public ;
12     function allowance(address _owner, address _spender) public constant returns (uint256 tokenId);
13     function transfer(address _to, uint256 _tokenId) external returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _tokenId) external;
15     
16     // Optional
17     // function takeOwnership(uint256 _tokenId) public ;
18     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external constant returns (uint tokenId);
19     // function tokenMetadata(uint256 _tokenId) public constant returns (string infoUrl);
20     
21     // Events
22     event Transfer(address _from, address _to, uint256 _tokenId);
23     event Approval(address _owner, address _approved, uint256 _tokenId);
24 }
25 
26 contract ERC20 {
27     // Get the total token supply
28     function totalSupply() public constant returns (uint256 _totalSupply);
29  
30     // Get the account balance of another account with address _owner
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32  
33     // Send _value amount of tokens to address _to
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     
36     // transfer _value amount of token approved by address _from
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38     
39     // approve an address with _value amount of tokens
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     // get remaining token approved by _owner to _spender
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
44   
45     // Triggered when tokens are transferred.
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47  
48     // Triggered whenever approve(address _spender, uint256 _value) is called.
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 contract SpecialGift is ERC721 {
53     string public name = "VirtualGift";             
54     uint8 public decimals = 0;                
55     string public symbol = "VTG";                 
56     string public version = "1.0";  
57 
58     address private defaultGiftOwner;
59     
60     mapping(address => bool) allowPermission;
61 
62     ERC20 private Gifto = ERC20(0x00C5bBaE50781Be1669306b9e001EFF57a2957b09d);
63     
64     event Creation(address indexed _owner, uint256 indexed tokenId);
65     //Gift token storage.
66     GiftToken[] giftStorageArry;
67     //Gift template storage.
68     GiftTemplateToken[] giftTemplateStorageArry;
69     //mapping address to it's gift sum
70     mapping(address => uint256) private balances;
71     //mapping gift id to owner
72     mapping(uint256 => address) private giftIndexToOwners;
73     //tells the gift is existed by gift id
74     mapping(uint256 => bool) private giftExists;
75     //mapping current owner to approved owners to gift
76     mapping(address => mapping (address => uint256)) private ownerToApprovedAddsToGifIds;
77     //mapping gift template id to gift ids
78     mapping(uint256 => uint256[]) private giftTemplateIdToGiftids;
79     //mapping address to allready bought sum.
80     mapping(address => mapping(uint256 => uint256)) private addressToBoughtSum;
81     //Mapping gift type to gift limit.
82     mapping(uint256 => uint256) private giftTypeToGiftLimit;
83     //Single address can limitation.
84     uint256 constant NO_LIMIT = 0;
85     uint256 private singleAddressBuyLimit = 1;
86     
87     //mapping gift template to gift selled sum.
88     mapping(uint256 => uint256) private giftTypeToSelledSum;
89 
90     //Gift template known as 0 generation gift
91     struct GiftTemplateToken {
92         uint256 giftPrice;
93         uint256 giftLimit;
94         //gift image url
95         string giftImgUrl;
96         //gift animation url
97         string giftName;
98     }
99     //Special gift token
100     struct GiftToken {
101         uint256 giftPrice;
102         uint256 giftType;
103         //gift image url
104         string giftImgUrl;
105         //gift animation url
106         string giftName;
107     }     
108 
109     modifier onlyHavePermission(){
110         require(allowPermission[msg.sender] == true || msg.sender == defaultGiftOwner);
111         _;
112     }
113 
114     modifier onlyOwner(){
115          require(msg.sender == defaultGiftOwner);
116          _;
117     }
118 
119     //@dev Constructor 
120     function SpecialGift() public {
121 
122         defaultGiftOwner = msg.sender;
123         
124         GiftToken memory newGift = GiftToken({
125             giftPrice: 0,
126             giftType: 0,
127             giftImgUrl: "",
128             giftName: ""
129         });
130 
131          GiftTemplateToken memory newGiftTemplate = GiftTemplateToken({
132                 giftPrice: 0,
133                 giftLimit: 0,
134                 giftImgUrl: "",
135                 giftName: ""
136             });
137         
138         giftStorageArry.push(newGift); // id = 0
139         giftTemplateStorageArry.push(newGiftTemplate);
140        
141     }
142 
143     function addPermission(address _addr) 
144     public 
145     onlyOwner{
146         allowPermission[_addr] = true;
147     }
148     
149     function removePermission(address _addr) 
150     public 
151     onlyOwner{
152         allowPermission[_addr] = false;
153     }
154 
155 
156      ///@dev Buy a gift while create a new gift based on gift template.
157      ///Make sure to call Gifto.approve() fist, before calling this function
158     function sendGift(uint256 _type, 
159                       address recipient)
160                      public 
161                      onlyHavePermission
162                      returns(uint256 _giftId)
163                      {
164         //Check if there is a buy Limit for buyer address
165         require(addressToBoughtSum[recipient][_type] < singleAddressBuyLimit);
166         //Check if the created gifts sum <  gift Limit
167         require(giftTypeToSelledSum[_type] < giftTemplateStorageArry[_type].giftLimit);
168          //_type must be a valid value
169         require(_type > 0 && _type < giftTemplateStorageArry.length);
170         //Mint a special gift.
171         _giftId = _mintGift(_type, recipient);
172         giftTypeToSelledSum[_type]++;
173         addressToBoughtSum[recipient][_type]++;
174         return _giftId;
175     }
176 
177     /// @dev Mint gift.
178     function _mintGift(uint256 _type, 
179                        address recipient)
180                      internal returns (uint256) 
181                      {
182 
183         GiftToken memory newGift = GiftToken({
184             giftPrice: giftTemplateStorageArry[_type].giftPrice,
185             giftType: _type,
186             giftImgUrl: giftTemplateStorageArry[_type].giftImgUrl,
187             giftName: giftTemplateStorageArry[_type].giftName
188         });
189         
190         uint256 giftId = giftStorageArry.push(newGift) - 1;
191         //Add giftid to gift template mapping 
192         giftTemplateIdToGiftids[_type].push(giftId);
193         giftExists[giftId] = true;
194         //Reassign Ownership for new owner
195         _transfer(0, recipient, giftId);
196         //Trigger Ethereum Event
197         Creation(msg.sender, giftId);
198         return giftId;
199     }
200 
201     /// @dev Initiate gift template.
202     /// A gift template means a gift of "0" generation's
203     function createGiftTemplate(uint256 _price,
204                          uint256 _limit, 
205                          string _imgUrl,
206                          string _giftName) 
207                          public onlyHavePermission
208                          returns (uint256 giftTemplateId)
209                          {
210         //Check these variables
211         require(_price > 0);
212         bytes memory imgUrlStringTest = bytes(_imgUrl);
213         bytes memory giftNameStringTest = bytes(_giftName);
214         require(imgUrlStringTest.length > 0);
215         require(giftNameStringTest.length > 0);
216         require(_limit > 0);
217         require(msg.sender != address(0));
218         //Create GiftTemplateToken
219         GiftTemplateToken memory newGiftTemplate = GiftTemplateToken({
220                 giftPrice: _price,
221                 giftLimit: _limit,
222                 giftImgUrl: _imgUrl,
223                 giftName: _giftName
224         });
225         //Push GiftTemplate into storage.
226         giftTemplateId = giftTemplateStorageArry.push(newGiftTemplate) - 1;
227         giftTypeToGiftLimit[giftTemplateId] = _limit;
228         return giftTemplateId;
229         
230     }
231     
232     function updateTemplate(uint256 templateId, 
233                             uint256 _newPrice, 
234                             uint256 _newlimit, 
235                             string _newUrl, 
236                             string _newName)
237     public
238     onlyOwner {
239         giftTemplateStorageArry[templateId].giftPrice = _newPrice;
240         giftTemplateStorageArry[templateId].giftLimit = _newlimit;
241         giftTemplateStorageArry[templateId].giftImgUrl = _newUrl;
242         giftTemplateStorageArry[templateId].giftName = _newName;
243     }
244     
245     function getGiftSoldFromType(uint256 giftType)
246     public
247     constant
248     returns(uint256){
249         return giftTypeToSelledSum[giftType];
250     }
251 
252     //@dev Retrieving gifts by template.
253     function getGiftsByTemplateId(uint256 templateId) 
254     public 
255     constant 
256     returns(uint256[] giftsId) {
257         return giftTemplateIdToGiftids[templateId];
258     }
259  
260     //@dev Retrievings all gift template ids
261     function getAllGiftTemplateIds() 
262     public 
263     constant 
264     returns(uint256[]) {
265         
266         if (giftTemplateStorageArry.length > 1) {
267             uint256 theLength = giftTemplateStorageArry.length - 1;
268             uint256[] memory resultTempIds = new uint256[](theLength);
269             uint256 resultIndex = 0;
270            
271             for (uint256 i = 1; i <= theLength; i++) {
272                 resultTempIds[resultIndex] = i;
273                 resultIndex++;
274             }
275              return resultTempIds;
276         }
277         require(giftTemplateStorageArry.length > 1);
278        
279     }
280 
281     //@dev Retrieving gift template by it's id
282     function getGiftTemplateById(uint256 templateId) 
283                                 public constant returns(
284                                 uint256 _price,
285                                 uint256 _limit,
286                                 string _imgUrl,
287                                 string _giftName
288                                 ){
289         require(templateId > 0);
290         require(templateId < giftTemplateStorageArry.length);
291         GiftTemplateToken memory giftTemplate = giftTemplateStorageArry[templateId];
292         _price = giftTemplate.giftPrice;
293         _limit = giftTemplate.giftLimit;
294         _imgUrl = giftTemplate.giftImgUrl;
295         _giftName = giftTemplate.giftName;
296         return (_price, _limit, _imgUrl, _giftName);
297     }
298 
299     /// @dev Retrieving gift info by gift id.
300     function getGift(uint256 _giftId) 
301                     public constant returns (
302                     uint256 giftType,
303                     uint256 giftPrice,
304                     string imgUrl,
305                     string giftName
306                     ) {
307         require(_giftId < giftStorageArry.length);
308         GiftToken memory gToken = giftStorageArry[_giftId];
309         giftType = gToken.giftType;
310         giftPrice = gToken.giftPrice;
311         imgUrl = gToken.giftImgUrl;
312         giftName = gToken.giftName;
313         return (giftType, giftPrice, imgUrl, giftName);
314     }
315 
316     /// @dev transfer gift to a new owner.
317     /// @param _to : 
318     /// @param _giftId :
319     function transfer(address _to, uint256 _giftId) external returns (bool success){
320         require(giftExists[_giftId]);
321         require(_to != 0x0);
322         require(msg.sender != _to);
323         require(msg.sender == ownerOf(_giftId));
324         require(_to != address(this));
325         _transfer(msg.sender, _to, _giftId);
326         return true;
327     }
328 
329     /// @dev change Gifto contract's address or another type of token, like Ether.
330     /// @param newAddress Gifto contract address
331     function setGiftoAddress(address newAddress) public onlyOwner {
332         Gifto = ERC20(newAddress);
333     }
334     
335     /// @dev Retrieving Gifto contract adress
336     function getGiftoAddress() public constant returns (address giftoAddress) {
337         return address(Gifto);
338     }
339 
340     /// @dev returns total supply for this token
341     function totalSupply() public  constant returns (uint256){
342         return giftStorageArry.length - 1;
343     }
344     
345     //@dev 
346     //@param _owner 
347     //@return 
348     function balanceOf(address _owner)  public  constant  returns (uint256 giftSum) {
349         return balances[_owner];
350     }
351     
352     /// @dev 
353     /// @return owner
354     function ownerOf(uint256 _giftId) public constant returns (address _owner) {
355         require(giftExists[_giftId]);
356         return giftIndexToOwners[_giftId];
357     }
358     
359     /// @dev approved owner 
360     /// @param _to :
361     function approve(address _to, uint256 _giftId) public {
362         require(msg.sender == ownerOf(_giftId));
363         require(msg.sender != _to);
364         
365         ownerToApprovedAddsToGifIds[msg.sender][_to] = _giftId;
366         //Ethereum Event
367         Approval(msg.sender, _to, _giftId);
368     }
369     
370     /// @dev 
371     /// @param _owner : 
372     /// @param _spender :
373     function allowance(address _owner, address _spender) public constant returns (uint256 giftId) {
374         return ownerToApprovedAddsToGifIds[_owner][_spender];
375     }
376     
377     /// @dev 
378     /// @param _giftId :
379     function takeOwnership(uint256 _giftId) public {
380         //Check if exits
381         require(giftExists[_giftId]);
382         
383         address oldOwner = ownerOf(_giftId);
384         address newOwner = msg.sender;
385         
386         require(newOwner != oldOwner);
387         //New owner has to be approved by oldowner.
388         require(ownerToApprovedAddsToGifIds[oldOwner][newOwner] == _giftId);
389 
390         //transfer gift for new owner
391         _transfer(oldOwner, newOwner, _giftId);
392         delete ownerToApprovedAddsToGifIds[oldOwner][newOwner];
393         //Ethereum Event
394         Transfer(oldOwner, newOwner, _giftId);
395     }
396     
397     /// @dev transfer gift for new owner "_to"
398     /// @param _from : 
399     /// @param _to : 
400     /// @param _giftId :
401     function _transfer(address _from, address _to, uint256 _giftId) internal {
402         require(balances[_to] + 1 > balances[_to]);
403         balances[_to]++;
404         giftIndexToOwners[_giftId] = _to;
405    
406         if (_from != address(0)) {
407             balances[_from]--;
408         }
409         
410         //Ethereum event.
411         Transfer(_from, _to, _giftId);
412     }
413     
414     /// @dev transfer Gift for new owner(_to) which is approved.
415     /// @param _from : address of owner of gift
416     /// @param _to : recipient address
417     /// @param _giftId : gift id
418     function transferFrom(address _from, address _to, uint256 _giftId) external {
419 
420         require(_to != address(0));
421         require(_to != address(this));
422         //Check if this spender(_to) is approved to the gift.
423         require(ownerToApprovedAddsToGifIds[_from][_to] == _giftId);
424         require(_from == ownerOf(_giftId));
425 
426         //@dev reassign ownership of the gift. 
427         _transfer(_from, _to, _giftId);
428         //Delete approved spender
429         delete ownerToApprovedAddsToGifIds[_from][_to];
430     }
431     
432     /// @dev Retrieving gifts by address _owner
433     function giftsOfOwner(address _owner)  public view returns (uint256[] ownerGifts) {
434         
435         uint256 giftCount = balanceOf(_owner);
436         if (giftCount == 0) {
437             return new uint256[](0);
438         } else {
439             uint256[] memory result = new uint256[](giftCount);
440             uint256 total = totalSupply();
441             uint256 resultIndex = 0;
442 
443             uint256 giftId;
444             
445             for (giftId = 0; giftId <= total; giftId++) {
446                 if (giftIndexToOwners[giftId] == _owner) {
447                     result[resultIndex] = giftId;
448                     resultIndex++;
449                 }
450             }
451 
452             return result;
453         }
454     }
455      
456     /// @dev withdraw GTO and ETH in this contract 
457     function withdrawGTO() 
458     onlyOwner 
459     public { 
460         Gifto.transfer(defaultGiftOwner, Gifto.balanceOf(address(this))); 
461     }
462     
463     function withdraw()
464     onlyOwner
465     public
466     returns (bool){
467         return defaultGiftOwner.send(this.balance);
468     }
469 }