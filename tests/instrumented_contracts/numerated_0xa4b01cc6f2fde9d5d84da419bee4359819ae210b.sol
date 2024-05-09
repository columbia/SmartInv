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
13     function transfer(address _to, uint256 _tokenId) external ;
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
53     
54     // load GTO to Virtual Gift contract, to interact with GTO
55     ERC20 GTO = ERC20(0x00C5bBaE50781Be1669306b9e001EFF57a2957b09d);
56     
57     // Gift data
58     struct Gift {
59         // gift price
60         uint256 price;
61         // gift description
62         string description;
63     }
64     
65     address public owner;
66     
67     event Transfer(address indexed _from, address indexed _to, uint256 _GiftId);
68     event Approval(address indexed _owner, address indexed _approved, uint256 _GiftId);
69     event Creation(address indexed _owner, uint256 indexed GiftId);
70     
71     string public constant name = "VirtualGift";
72     string public constant symbol = "VTG";
73     
74     // Gift object storage in array
75     Gift[] giftStorage;
76     
77     // total Gift of an address
78     mapping(address => uint256) private balances;
79     
80     // index of Gift array to Owner
81     mapping(uint256 => address) private GiftIndexToOwners;
82     
83     // Gift exist or not
84     mapping(uint256 => bool) private GiftExists;
85     
86     // mapping from owner and approved address to GiftId
87     mapping(address => mapping (address => uint256)) private allowed;
88     
89     // mapping from owner and index Gift of owner to GiftId
90     mapping(address => mapping(uint256 => uint256)) private ownerIndexToGifts;
91     
92     // Gift metadata
93     mapping(uint256 => string) GiftLinks;
94 
95     modifier onlyOwner(){
96          require(msg.sender == owner);
97          _;
98     }
99 
100     modifier onlyGiftOwner(uint256 GiftId){
101         require(msg.sender == GiftIndexToOwners[GiftId]);
102         _;
103     }
104     
105     modifier validGift(uint256 GiftId){
106         require(GiftExists[GiftId]);
107         _;
108     }
109 
110     /// @dev constructor
111     function VirtualGift()
112     public{
113         owner = msg.sender;
114         // save temporaryly new Gift
115         Gift memory newGift = Gift({
116             price: 0,
117             description: "MYTHICAL"
118         });
119         // push to array and return the length is the id of new Gift
120         uint256 mythicalGift = giftStorage.push(newGift) - 1; // id = 0
121         // mythical Gift is not exist
122         GiftExists[mythicalGift] = false;
123         // assign url for Gift
124         GiftLinks[mythicalGift] = "mythicalGift";
125         // This will assign ownership, and also emit the Transfer event as
126         // per ERC721 draft
127         _transfer(0, msg.sender, mythicalGift);
128         // event create new Gift for msg.sender
129         Creation(msg.sender, mythicalGift);
130     }
131     
132     /// @dev this function change GTO address, this mean you can use many token to buy gift
133     /// by change GTO address to BNB address
134     /// @param newAddress is new address of GTO or another Gift like BNB
135     function changeGTOAddress(address newAddress)
136     public
137     onlyOwner{
138         GTO = ERC20(newAddress);
139     }
140     
141     /// @dev return current GTO address
142     function getGTOAddress()
143     public
144     constant
145     returns (address) {
146         return address(GTO);
147     }
148     
149     /// @dev return total supply of Gift
150     /// @return length of Gift storage array, except Gift Zero
151     function totalSupply()
152     public 
153     constant
154     returns (uint256){
155         // exclusive Gift Zero
156         return giftStorage.length - 1;
157     }
158     
159     /// @dev allow people to buy Gift
160     /// @param GiftId : id of gift user want to buy
161     function buy(uint256 GiftId) 
162     validGift(GiftId)
163     public {
164         // get old owner of Gift
165         address oldowner = ownerOf(GiftId);
166         // tell gifto transfer GTO from new owner to oldowner
167         // NOTE: new owner MUST approve for Virtual Gift contract to take his balance
168         require(GTO.transferFrom(msg.sender, oldowner, giftStorage[GiftId].price) == true);
169         // assign new owner for GiftId
170         // TODO: old owner should have something to confirm that he want to sell this Gift
171         _transfer(oldowner, msg.sender, GiftId);
172     }
173     
174     /// @dev owner send gift to recipient when VG was approved
175     /// @param recipient : received gift
176     /// @param GiftId : id of gift which recipient want to buy
177     function sendGift(address recipient, uint256 GiftId)
178     onlyGiftOwner(GiftId)
179     validGift(GiftId)
180     public {
181         // transfer GTO to owner
182         // require(GTO.transfer(msg.sender, giftStorage[GiftId].price) == true);
183         // transfer gift to recipient
184         _transfer(msg.sender, recipient, GiftId);
185     }
186     
187     /// @dev get total Gift of an address
188     /// @param _owner to get balance
189     /// @return balance of an address
190     function balanceOf(address _owner) 
191     public 
192     constant 
193     returns (uint256 balance){
194         return balances[_owner];
195     }
196     
197     function isExist(uint256 GiftId)
198     public
199     constant
200     returns(bool){
201         return GiftExists[GiftId];
202     }
203     
204     /// @dev get owner of an Gift id
205     /// @param _GiftId : id of Gift to get owner
206     /// @return owner : owner of an Gift id
207     function ownerOf(uint256 _GiftId)
208     public
209     constant 
210     returns (address _owner) {
211         require(GiftExists[_GiftId]);
212         return GiftIndexToOwners[_GiftId];
213     }
214     
215     /// @dev approve Gift id from msg.sender to an address
216     /// @param _to : address is approved
217     /// @param _GiftId : id of Gift in array
218     function approve(address _to, uint256 _GiftId)
219     validGift(_GiftId)
220     public {
221         require(msg.sender == ownerOf(_GiftId));
222         require(msg.sender != _to);
223         
224         allowed[msg.sender][_to] = _GiftId;
225         Approval(msg.sender, _to, _GiftId);
226     }
227     
228     /// @dev get id of Gift was approved from owner to spender
229     /// @param _owner : address owner of Gift
230     /// @param _spender : spender was approved
231     /// @return GiftId
232     function allowance(address _owner, address _spender) 
233     public 
234     constant 
235     returns (uint256 GiftId) {
236         return allowed[_owner][_spender];
237     }
238     
239     /// @dev a spender take owner ship of Gift id, when he was approved
240     /// @param _GiftId : id of Gift has being takeOwnership
241     function takeOwnership(uint256 _GiftId)
242     validGift(_GiftId)
243     public {
244         // get oldowner of Giftid
245         address oldOwner = ownerOf(_GiftId);
246         // new owner is msg sender
247         address newOwner = msg.sender;
248         
249         require(newOwner != oldOwner);
250         // newOwner must be approved by oldOwner
251         require(allowed[oldOwner][newOwner] == _GiftId);
252 
253         // transfer Gift for new owner
254         _transfer(oldOwner, newOwner, _GiftId);
255 
256         // delete approve when being done take owner ship
257         delete allowed[oldOwner][newOwner];
258 
259         Transfer(oldOwner, newOwner, _GiftId);
260     }
261     
262     /// @dev transfer ownership of a specific Gift to an address.
263     /// @param _from : address owner of Giftid
264     /// @param _to : address's received
265     /// @param _GiftId : Gift id
266     function _transfer(address _from, address _to, uint256 _GiftId) 
267     internal {
268         // Since the number of Gift is capped to 2^32 we can't overflow this
269         balances[_to]++;
270         // transfer ownership
271         GiftIndexToOwners[_GiftId] = _to;
272         // When creating new Gift _from is 0x0, but we can't account that address.
273         if (_from != address(0)) {
274             balances[_from]--;
275         }
276         // Emit the transfer event.
277         Transfer(_from, _to, _GiftId);
278     }
279     
280     /// @dev transfer ownership of Giftid from msg sender to an address
281     /// @param _to : address's received
282     /// @param _GiftId : Gift id
283     function transfer(address _to, uint256 _GiftId)
284     validGift(_GiftId)
285     external {
286         // not transfer to zero
287         require(_to != 0x0);
288         // address received different from sender
289         require(msg.sender != _to);
290         // sender must be owner of Giftid
291         require(msg.sender == ownerOf(_GiftId));
292         // do not send to Gift contract
293         require(_to != address(this));
294         
295         _transfer(msg.sender, _to, _GiftId);
296     }
297     
298     /// @dev transfer Giftid was approved by _from to _to
299     /// @param _from : address owner of Giftid
300     /// @param _to : address is received
301     /// @param _GiftId : Gift id
302     function transferFrom(address _from, address _to, uint256 _GiftId)
303     validGift(_GiftId)
304     external {
305         require(_from == ownerOf(_GiftId));
306         // Check for approval and valid ownership
307         require(allowance(_from, msg.sender) == _GiftId);
308         // address received different from _owner
309         require(_from != _to);
310         
311         // Safety check to prevent against an unexpected 0x0 default.
312         require(_to != address(0));
313         // Disallow transfers to this contract to prevent accidental misuse.
314         // The contract should never own any Gift
315         require(_to != address(this));
316 
317         // Reassign ownership (also clears pending approvals and emits Transfer event).
318         _transfer(_from, _to, _GiftId);
319     }
320     
321     /// @dev Returns a list of all Gift IDs assigned to an address.
322     /// @param _owner The owner whose Gift we are interested in.
323     /// @notice This method MUST NEVER be called by smart contract code. First, it's fairly
324     ///  expensive (it walks the entire Gift array looking for Gift belonging to owner),
325     /// @return ownerGifts : list Gift of owner
326     function GiftsOfOwner(address _owner) 
327     public 
328     view 
329     returns(uint256[] ownerGifts) {
330         
331         uint256 GiftCount = balanceOf(_owner);
332         if (GiftCount == 0) {
333             // Return an empty array
334             return new uint256[](0);
335         } else {
336             uint256[] memory result = new uint256[](GiftCount);
337             uint256 total = totalSupply();
338             uint256 resultIndex = 0;
339 
340             // We count on the fact that all Gift have IDs starting at 1 and increasing
341             // sequentially up to the totalCat count.
342             uint256 GiftId;
343             
344             // scan array and filter Gift of owner
345             for (GiftId = 0; GiftId <= total; GiftId++) {
346                 if (GiftIndexToOwners[GiftId] == _owner) {
347                     result[resultIndex] = GiftId;
348                     resultIndex++;
349                 }
350             }
351 
352             return result;
353         }
354     }
355     
356     /// @dev Returns a Gift IDs assigned to an address.
357     /// @param _owner The owner whose Gift we are interested in.
358     /// @param _index to owner Gift list
359     /// @notice This method MUST NEVER be called by smart contract code. First, it's fairly
360     ///  expensive (it walks the entire Gift array looking for Gift belonging to owner),
361     ///  it is only supported for web3 calls, and
362     ///  not contract-to-contract calls.
363     function giftOwnerByIndex(address _owner, uint256 _index)
364     external
365     constant 
366     returns (uint256 GiftId) {
367         uint256[] memory ownerGifts = GiftsOfOwner(_owner);
368         return ownerGifts[_index];
369     }
370     
371     /// @dev get Gift metadata (url) from GiftLinks
372     /// @param _GiftId : Gift id
373     /// @return infoUrl : url of Gift
374     function GiftMetadata(uint256 _GiftId)
375     public
376     constant
377     returns (string infoUrl) {
378         return GiftLinks[_GiftId];
379     }
380     
381     /// @dev function create new Gift
382     /// @param _price : Gift property
383     /// @param _description : Gift property
384     /// @return GiftId
385     function createGift(uint256 _price, string _description, string _url)
386     public
387     onlyOwner
388     returns (uint256) {
389         // save temporarily new Gift
390         Gift memory newGift = Gift({
391             price: _price,
392             description: _description
393         });
394         // push to array and return the length is the id of new Gift
395         uint256 newGiftId = giftStorage.push(newGift) - 1;
396         // turn on existen
397         GiftExists[newGiftId] = true;
398         // assin gift url
399         GiftLinks[newGiftId] = _url;
400         // event create new Gift for msg.sender
401         Creation(msg.sender, newGiftId);
402         
403         // This will assign ownership, and also emit the Transfer event as
404         // per ERC721 draft
405         _transfer(0, msg.sender, newGiftId);
406         
407         return newGiftId;
408     }
409     
410     /// @dev get Gift property
411     /// @param GiftId : id of Gift
412     /// @return properties of Gift
413     function getGift(uint256 GiftId)
414     public
415     constant 
416     returns (uint256, string){
417         if(GiftId > giftStorage.length){
418             return (0, "");
419         }
420         Gift memory newGift = giftStorage[GiftId];
421         return (newGift.price, newGift.description);
422     }
423     
424     /// @dev change gift properties
425     /// @param GiftId : to change
426     /// @param _price : new price of gift
427     /// @param _description : new description
428     /// @param _giftUrl : new url 
429     function updateGift(uint256 GiftId, uint256 _price, string _description, string _giftUrl)
430     public
431     onlyOwner {
432         // check Gift exist First
433         require(GiftExists[GiftId]);
434         // setting new properties
435         giftStorage[GiftId].price = _price;
436         giftStorage[GiftId].description = _description;
437         GiftLinks[GiftId] = _giftUrl;
438     }
439     
440     /// @dev remove gift 
441     /// @param GiftId : gift id to remove
442     function removeGift(uint256 GiftId)
443     public
444     onlyOwner {
445         // just setting GiftExists equal to false
446         GiftExists[GiftId] = false;
447     }
448     
449     /// @dev withdraw GTO in this contract
450     function withdrawGTO()
451     onlyOwner
452     public {
453         GTO.transfer(owner, GTO.balanceOf(address(this)));
454     }
455     
456 }