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
22     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
23     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
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
52 contract VirtualGift is ERC721 {
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
79     //Mapping gift type to gift limit.
80     mapping(uint256 => uint256) private giftTypeToGiftLimit;
81 
82     
83     //mapping gift template to gift selled sum.
84     mapping(uint256 => uint256) private giftTypeToSelledSum;
85 
86     //Gift template known as 0 generation gift
87     struct GiftTemplateToken {
88         uint256 giftPrice;
89         uint256 giftLimit;
90         //gift image url
91         string giftImgUrl;
92         //gift animation url
93         string giftName;
94     }
95     //virtual gift token
96     struct GiftToken {
97         uint256 giftPrice;
98         uint256 giftType;
99         //gift image url
100         string giftImgUrl;
101         //gift animation url
102         string giftName;
103     }     
104 
105     modifier onlyHavePermission(){
106         require(allowPermission[msg.sender] == true || msg.sender == defaultGiftOwner);
107         _;
108     }
109 
110     modifier onlyOwner(){
111          require(msg.sender == defaultGiftOwner);
112          _;
113     }
114 
115     //@dev Constructor 
116     function VirtualGift() public {
117 
118         defaultGiftOwner = msg.sender;
119         
120         GiftToken memory newGift = GiftToken({
121             giftPrice: 0,
122             giftType: 0,
123             giftImgUrl: "",
124             giftName: ""
125         });
126 
127          GiftTemplateToken memory newGiftTemplate = GiftTemplateToken({
128                 giftPrice: 0,
129                 giftLimit: 0,
130                 giftImgUrl: "",
131                 giftName: ""
132             });
133         
134         giftStorageArry.push(newGift); // id = 0
135         giftTemplateStorageArry.push(newGiftTemplate);
136        
137     }
138 
139     function addPermission(address _addr) 
140     public 
141     onlyOwner{
142         allowPermission[_addr] = true;
143     }
144     
145     function removePermission(address _addr) 
146     public 
147     onlyOwner{
148         allowPermission[_addr] = false;
149     }
150 
151 
152      ///@dev Buy a gift while create a new gift based on gift template.
153      ///Make sure to call Gifto.approve() fist, before calling this function
154     function sendGift(uint256 _type, 
155                       address recipient)
156                      public 
157                      onlyHavePermission
158                      returns(uint256 _giftId)
159                      {
160         //Check if the created gifts sum <  gift Limit
161         require(giftTypeToSelledSum[_type] < giftTemplateStorageArry[_type].giftLimit);
162          //_type must be a valid value
163         require(_type > 0 && _type < giftTemplateStorageArry.length);
164         //Mint a virtual gift.
165         _giftId = _mintGift(_type, recipient);
166         giftTypeToSelledSum[_type]++;
167         return _giftId;
168     }
169 
170     /// @dev Mint gift.
171     function _mintGift(uint256 _type, 
172                        address recipient)
173                      internal returns (uint256) 
174                      {
175 
176         GiftToken memory newGift = GiftToken({
177             giftPrice: giftTemplateStorageArry[_type].giftPrice,
178             giftType: _type,
179             giftImgUrl: giftTemplateStorageArry[_type].giftImgUrl,
180             giftName: giftTemplateStorageArry[_type].giftName
181         });
182         
183         uint256 giftId = giftStorageArry.push(newGift) - 1;
184         //Add giftid to gift template mapping 
185         giftTemplateIdToGiftids[_type].push(giftId);
186         giftExists[giftId] = true;
187         //Reassign Ownership for new owner
188         _transfer(0, recipient, giftId);
189         //Trigger Ethereum Event
190         Creation(msg.sender, giftId);
191         return giftId;
192     }
193 
194     /// @dev Initiate gift template.
195     /// A gift template means a gift of "0" generation's
196     function createGiftTemplate(uint256 _price,
197                          uint256 _limit, 
198                          string _imgUrl,
199                          string _giftName) 
200                          public onlyHavePermission
201                          returns (uint256 giftTemplateId)
202                          {
203         //Check these variables
204         require(_price > 0);
205         bytes memory imgUrlStringTest = bytes(_imgUrl);
206         bytes memory giftNameStringTest = bytes(_giftName);
207         require(imgUrlStringTest.length > 0);
208         require(giftNameStringTest.length > 0);
209         require(_limit > 0);
210         require(msg.sender != address(0));
211         //Create GiftTemplateToken
212         GiftTemplateToken memory newGiftTemplate = GiftTemplateToken({
213                 giftPrice: _price,
214                 giftLimit: _limit,
215                 giftImgUrl: _imgUrl,
216                 giftName: _giftName
217         });
218         //Push GiftTemplate into storage.
219         giftTemplateId = giftTemplateStorageArry.push(newGiftTemplate) - 1;
220         giftTypeToGiftLimit[giftTemplateId] = _limit;
221         return giftTemplateId;
222         
223     }
224     
225     function updateTemplate(uint256 templateId, 
226                             uint256 _newPrice, 
227                             uint256 _newlimit, 
228                             string _newUrl, 
229                             string _newName)
230     public
231     onlyOwner {
232         giftTemplateStorageArry[templateId].giftPrice = _newPrice;
233         giftTemplateStorageArry[templateId].giftLimit = _newlimit;
234         giftTemplateStorageArry[templateId].giftImgUrl = _newUrl;
235         giftTemplateStorageArry[templateId].giftName = _newName;
236     }
237     
238     function getGiftSoldFromType(uint256 giftType)
239     public
240     constant
241     returns(uint256){
242         return giftTypeToSelledSum[giftType];
243     }
244 
245     //@dev Retrieving gifts by template.
246     function getGiftsByTemplateId(uint256 templateId) 
247     public 
248     constant 
249     returns(uint256[] giftsId) {
250         return giftTemplateIdToGiftids[templateId];
251     }
252  
253     //@dev Retrievings all gift template ids
254     function getAllGiftTemplateIds() 
255     public 
256     constant 
257     returns(uint256[]) {
258         
259         if (giftTemplateStorageArry.length > 1) {
260             uint256 theLength = giftTemplateStorageArry.length - 1;
261             uint256[] memory resultTempIds = new uint256[](theLength);
262             uint256 resultIndex = 0;
263            
264             for (uint256 i = 1; i <= theLength; i++) {
265                 resultTempIds[resultIndex] = i;
266                 resultIndex++;
267             }
268              return resultTempIds;
269         }
270         require(giftTemplateStorageArry.length > 1);
271        
272     }
273 
274     //@dev Retrieving gift template by it's id
275     function getGiftTemplateById(uint256 templateId) 
276                                 public constant returns(
277                                 uint256 _price,
278                                 uint256 _limit,
279                                 string _imgUrl,
280                                 string _giftName
281                                 ){
282         require(templateId > 0);
283         require(templateId < giftTemplateStorageArry.length);
284         GiftTemplateToken memory giftTemplate = giftTemplateStorageArry[templateId];
285         _price = giftTemplate.giftPrice;
286         _limit = giftTemplate.giftLimit;
287         _imgUrl = giftTemplate.giftImgUrl;
288         _giftName = giftTemplate.giftName;
289         return (_price, _limit, _imgUrl, _giftName);
290     }
291 
292     /// @dev Retrieving gift info by gift id.
293     function getGift(uint256 _giftId) 
294                     public constant returns (
295                     uint256 giftType,
296                     uint256 giftPrice,
297                     string imgUrl,
298                     string giftName
299                     ) {
300         require(_giftId < giftStorageArry.length);
301         GiftToken memory gToken = giftStorageArry[_giftId];
302         giftType = gToken.giftType;
303         giftPrice = gToken.giftPrice;
304         imgUrl = gToken.giftImgUrl;
305         giftName = gToken.giftName;
306         return (giftType, giftPrice, imgUrl, giftName);
307     }
308 
309     /// @dev transfer gift to a new owner.
310     /// @param _to : 
311     /// @param _giftId :
312     function transfer(address _to, uint256 _giftId) external returns (bool success){
313         require(giftExists[_giftId]);
314         require(_to != 0x0);
315         require(msg.sender != _to);
316         require(msg.sender == ownerOf(_giftId));
317         require(_to != address(this));
318         _transfer(msg.sender, _to, _giftId);
319         return true;
320     }
321 
322     /// @dev change Gifto contract's address or another type of token, like Ether.
323     /// @param newAddress Gifto contract address
324     function setGiftoAddress(address newAddress) public onlyOwner {
325         Gifto = ERC20(newAddress);
326     }
327     
328     /// @dev Retrieving Gifto contract adress
329     function getGiftoAddress() public constant returns (address giftoAddress) {
330         return address(Gifto);
331     }
332 
333     /// @dev returns total supply for this token
334     function totalSupply() public  constant returns (uint256){
335         return giftStorageArry.length - 1;
336     }
337     
338     //@dev 
339     //@param _owner 
340     //@return 
341     function balanceOf(address _owner)  public  constant  returns (uint256 giftSum) {
342         return balances[_owner];
343     }
344     
345     /// @dev 
346     /// @return owner
347     function ownerOf(uint256 _giftId) public constant returns (address _owner) {
348         require(giftExists[_giftId]);
349         return giftIndexToOwners[_giftId];
350     }
351     
352     /// @dev approved owner 
353     /// @param _to :
354     function approve(address _to, uint256 _giftId) public {
355         require(msg.sender == ownerOf(_giftId));
356         require(msg.sender != _to);
357         
358         ownerToApprovedAddsToGifIds[msg.sender][_to] = _giftId;
359         //Ethereum Event
360         Approval(msg.sender, _to, _giftId);
361     }
362     
363     /// @dev 
364     /// @param _owner : 
365     /// @param _spender :
366     function allowance(address _owner, address _spender) public constant returns (uint256 giftId) {
367         return ownerToApprovedAddsToGifIds[_owner][_spender];
368     }
369     
370     /// @dev 
371     /// @param _giftId :
372     function takeOwnership(uint256 _giftId) public {
373         //Check if exits
374         require(giftExists[_giftId]);
375         
376         address oldOwner = ownerOf(_giftId);
377         address newOwner = msg.sender;
378         
379         require(newOwner != oldOwner);
380         //New owner has to be approved by oldowner.
381         require(ownerToApprovedAddsToGifIds[oldOwner][newOwner] == _giftId);
382 
383         //transfer gift for new owner
384         _transfer(oldOwner, newOwner, _giftId);
385         delete ownerToApprovedAddsToGifIds[oldOwner][newOwner];
386         //Ethereum Event
387         Transfer(oldOwner, newOwner, _giftId);
388     }
389     
390     /// @dev transfer gift for new owner "_to"
391     /// @param _from : 
392     /// @param _to : 
393     /// @param _giftId :
394     function _transfer(address _from, address _to, uint256 _giftId) internal {
395         require(balances[_to] + 1 > balances[_to]);
396         balances[_to]++;
397         giftIndexToOwners[_giftId] = _to;
398    
399         if (_from != address(0)) {
400             balances[_from]--;
401         }
402         
403         //Ethereum event.
404         Transfer(_from, _to, _giftId);
405     }
406     
407     /// @dev transfer Gift for new owner(_to) which is approved.
408     /// @param _from : address of owner of gift
409     /// @param _to : recipient address
410     /// @param _giftId : gift id
411     function transferFrom(address _from, address _to, uint256 _giftId) external {
412 
413         require(_to != address(0));
414         require(_to != address(this));
415         //Check if this spender(_to) is approved to the gift.
416         require(ownerToApprovedAddsToGifIds[_from][_to] == _giftId);
417         require(_from == ownerOf(_giftId));
418 
419         //@dev reassign ownership of the gift. 
420         _transfer(_from, _to, _giftId);
421         //Delete approved spender
422         delete ownerToApprovedAddsToGifIds[_from][_to];
423     }
424     
425     /// @dev Retrieving gifts by address _owner
426     function giftsOfOwner(address _owner)  public view returns (uint256[] ownerGifts) {
427         
428         uint256 giftCount = balanceOf(_owner);
429         if (giftCount == 0) {
430             return new uint256[](0);
431         } else {
432             uint256[] memory result = new uint256[](giftCount);
433             uint256 total = totalSupply();
434             uint256 resultIndex = 0;
435 
436             uint256 giftId;
437             
438             for (giftId = 0; giftId <= total; giftId++) {
439                 if (giftIndexToOwners[giftId] == _owner) {
440                     result[resultIndex] = giftId;
441                     resultIndex++;
442                 }
443             }
444 
445             return result;
446         }
447     }
448      
449     /// @dev withdraw GTO and ETH in this contract 
450     function withdrawGTO() 
451     onlyOwner 
452     public { 
453         Gifto.transfer(defaultGiftOwner, Gifto.balanceOf(address(this))); 
454     }
455     
456     function withdraw()
457     onlyOwner
458     public
459     returns (bool){
460         return defaultGiftOwner.send(this.balance);
461     }
462 }