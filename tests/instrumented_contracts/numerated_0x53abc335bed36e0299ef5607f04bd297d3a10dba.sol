1 pragma solidity ^0.4.20;
2 
3 /** 
4  * Created by RigCraft Team
5  * If you have any questions please visit the official discord channel
6  * https://discord.gg/zJCf7Fh
7  * or read The FAQ at 
8  * https://rigcraft.io/#faq
9  **/
10 
11 contract ERC721Basic {
12   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
13   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
14   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
15 
16   function balanceOf(address _owner) public view returns (uint256 _balance);
17   function ownerOf(uint256 _tokenId) public view returns (address _owner);
18   function exists(uint256 _tokenId) public view returns (bool _exists);
19 
20   function approve(address _to, uint256 _tokenId) public;
21   function getApproved(uint256 _tokenId) public view returns (address _operator);
22   function setApprovalForAll(address _operator, bool _approved) public;
23   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
24 
25   function transferFrom(address _from, address _to, uint256 _tokenId) public;
26   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
27   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data ) public;
28 }
29 
30 contract ERC721Receiver {
31 
32   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
33 
34   function onERC721Received(address _from,uint256 _tokenId,bytes _data) public returns(bytes4);
35 }
36 
37 contract ERC721Metadata {
38    
39     function tokenURI(uint256 _tokenId) external view returns (string);
40 }
41 
42 contract Administration
43 {
44     address owner;
45     bool active = true;
46     bool open = true;
47     
48     function Administration() public
49     {
50         owner = msg.sender;
51     }
52     
53     modifier onlyOwner() 
54     {
55         require(owner == msg.sender);
56         _;
57     }
58     
59     modifier isActive()
60     {
61         require(active == true);
62         _;
63     }
64     
65     modifier isOpen()
66     {
67         require(open == true);
68         _;
69     }
70     
71     function setActive(bool _active) external onlyOwner
72     {
73         active = _active;
74     }
75     
76     function setOpen(bool _open) external onlyOwner
77     {
78         open = _open;
79     }
80 }
81 
82 // core
83 contract RigCraftPresalePackageToken is ERC721Basic, Administration, ERC721Metadata {
84     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
85     
86     struct PresalePackage
87     {
88         uint8 packageId;
89         uint16 serialNumber;
90     }
91     
92     PresalePackage[] packages;
93     
94     // Mapping from token ID to owner
95     mapping (uint256 => address) internal tokenOwner;
96     mapping (uint256 => address) internal tokenApprovals;
97     mapping (address => uint256) internal ownedTokensCount;
98     mapping (address => mapping (address => bool)) internal operatorApprovals;
99     
100     RigCraftPresalePackageManager private presaleHandler;
101     string URIBase;
102     
103     string public constant name = "RigCraftPresalePackage";
104     string public constant symbol = "RCPT";
105     
106     function SetPresaleHandler(address addr) external onlyOwner
107     {
108         presaleHandler = RigCraftPresalePackageManager(addr);
109     }
110     
111     function setURIBase(string _base) external onlyOwner
112     {
113         URIBase = _base;
114     }
115     
116     modifier onlyOwnerOf(uint256 _tokenId) {
117         require(ownerOf(_tokenId) == msg.sender);
118         _;
119     }
120 
121     modifier canTransfer(uint256 _tokenId) {
122         require(isApprovedOrOwner(msg.sender, _tokenId));
123         _;
124     }
125     
126     /**
127     * PUBLIC INTERFACE
128     **/
129     function balanceOf(address _owner) public view isOpen returns (uint256) {
130         require(_owner != address(0));
131         return ownedTokensCount[_owner];
132     }
133 
134     function ownerOf(uint256 _tokenId) public view isOpen returns (address) {
135         address owner = tokenOwner[_tokenId];
136         require(owner != address(0));
137         return owner;
138     }
139 
140     function exists(uint256 _tokenId) public view isOpen returns (bool) {
141         address owner = tokenOwner[_tokenId];
142         return owner != address(0);
143     }
144     
145     function totalSupply() public view returns (uint256) {
146         return packages.length;
147     }
148 
149     function approve(address _to, uint256 _tokenId) public
150     isOpen
151     isActive
152     {
153         address owner = ownerOf(_tokenId);
154         require(_to != owner);
155         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
156         
157         if (getApproved(_tokenId) != address(0) || _to != address(0)) {
158             tokenApprovals[_tokenId] = _to;
159             emit Approval(owner, _to, _tokenId);
160         }
161     }
162     
163     function getApproved(uint256 _tokenId) public view isOpen returns (address) {
164         return tokenApprovals[_tokenId];
165     }
166     
167     function setApprovalForAll(address _to, bool _approved) public
168     isActive
169     isOpen
170     {
171         require(_to != msg.sender);
172         operatorApprovals[msg.sender][_to] = _approved;
173         emit ApprovalForAll(msg.sender, _to, _approved);
174     }
175 
176     function isApprovedForAll( address _owner, address _operator) public view
177     isOpen
178     returns (bool)
179     {
180         return operatorApprovals[_owner][_operator];
181     }
182 
183     function transferFrom(address _from, address _to, uint256 _tokenId) public
184     canTransfer(_tokenId)
185     isActive
186     isOpen
187     {
188         require(_from != address(0));
189         require(_to != address(0));
190         
191         clearApproval(_from, _tokenId);
192         removeTokenFrom(_from, _tokenId);
193         addTokenTo(_to, _tokenId);
194         
195         emit Transfer(_from, _to, _tokenId);
196     }
197     
198     function safeTransferFrom(address _from, address _to, uint256 _tokenId)
199     public
200     canTransfer(_tokenId)
201     isActive
202     isOpen
203     {
204         safeTransferFrom(_from, _to, _tokenId, "");
205     }
206 
207     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data)
208     public
209     canTransfer(_tokenId)
210     isActive
211     isOpen
212     {
213         transferFrom(_from, _to, _tokenId);
214         require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
215     }
216 
217     /**
218     * INTERNALS
219     **/
220     function isApprovedOrOwner(address _spender,uint256 _tokenId) internal view
221     returns (bool)
222     {
223         address owner = ownerOf(_tokenId);
224         return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
225     }
226     
227     function clearApproval(address _owner, uint256 _tokenId) internal {
228         require(ownerOf(_tokenId) == _owner);
229         if (tokenApprovals[_tokenId] != address(0)) {
230             tokenApprovals[_tokenId] = address(0);
231             emit Approval(_owner, address(0), _tokenId);
232         }
233     }
234 
235     function addTokenTo(address _to, uint256 _tokenId) internal 
236     {
237         require(tokenOwner[_tokenId] == address(0));
238         tokenOwner[_tokenId] = _to;
239         ownedTokensCount[_to] += 1;
240     }
241 
242     function removeTokenFrom(address _from, uint256 _tokenId) internal 
243     {
244         require(ownerOf(_tokenId) == _from);
245         require(ownedTokensCount[_from] > 0);
246         ownedTokensCount[_from] -= 1;
247         tokenOwner[_tokenId] = address(0);
248     }
249 
250     function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data)
251     internal
252     returns (bool)
253     {
254         uint256 codeSize;
255         assembly { codeSize := extcodesize(_to) }
256         if (codeSize == 0) {
257             return true;
258         }
259         bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
260         return (retval == ERC721_RECEIVED);
261     }
262     
263     function tokenURI(uint256 _tokenId) external view returns (string)
264     {
265         string memory tokenNumber = uint2str(_tokenId);
266         
267         uint pos = bytes(URIBase).length;
268         bytes memory retVal  = new bytes(bytes(tokenNumber).length + bytes(URIBase).length);
269         uint i = 0;
270         
271         for(i = 0; i < bytes(URIBase).length; ++i)
272         {
273             retVal[i] = bytes(URIBase)[i];
274         }
275         for(i = 0; i < bytes(tokenNumber).length; ++i)
276         {
277             retVal[pos + i] = bytes(tokenNumber)[i];
278         }
279         
280         return string(retVal);
281     }
282     
283     function uint2str(uint256 i) internal pure returns (string)
284     {
285         if (i == 0) return "0";
286         uint j = i;
287         uint length;
288         while (j != 0){
289             length++;
290             j /= 10;
291         }
292         bytes memory bstr = new bytes(length);
293         uint k = length - 1;
294         while (i != 0){
295             bstr[k--] = byte(48 + i % 10);
296             i /= 10;
297         }
298         return string(bstr);
299     }
300     
301     // Get all token IDs of address
302     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) 
303     {
304         uint256 tokenCount = balanceOf(_owner);
305         
306         if (tokenCount == 0) 
307         {
308             // Return an empty array
309             return new uint256[](0);
310         } else 
311         {
312             uint256[] memory result = new uint256[](tokenCount);
313             uint256 resultIndex = 0;
314             
315             // We count on the fact that all cats have IDs starting at 1 and increasing
316             // sequentially up to the totalCat count.
317             uint256 tokenId;
318             
319             for (tokenId = 0; tokenId < packages.length; tokenId++) 
320             {
321                 if (tokenOwner[tokenId] == _owner) 
322                 {
323                     result[resultIndex] = tokenId;
324                     resultIndex++;
325                 }
326             }
327         
328             return result;
329         }
330     }
331     
332     /**
333     * EXTERNALS
334     **/
335     function GetTokenData(uint256 _tokenId) external view returns(uint8 presalePackadeId, uint16 serialNO) 
336     {
337         require(_tokenId < packages.length);
338         
339         presalePackadeId = packages[_tokenId].packageId;
340         serialNO = packages[_tokenId].serialNumber;
341     }
342     
343     function CreateToken(address _owner, uint8 _packageId, uint16 _serial) external
344     isActive
345     isOpen
346     {
347         require(msg.sender == address(presaleHandler));
348         uint256 tokenId = packages.length;
349         packages.length += 1;
350         
351         packages[tokenId].packageId = _packageId;
352         packages[tokenId].serialNumber = _serial;
353         
354         addTokenTo(_owner, tokenId);
355     }
356 }
357 
358 // presale
359 contract RigCraftPresalePackageManager
360 {
361     address owner;
362     
363     bool public isActive;
364     
365     uint16[]    public presalePackSold;
366     uint16[]    public presalePackLimit;
367     uint256[]   public presalePackagePrice;
368     
369     mapping(address=>uint256) addressRefferedCount;
370     mapping(address=>uint256) addressRefferredSpending;
371     address[] referralAddressIndex;
372     
373     uint256 public totalFundsSoFar;
374     
375     RigCraftPresalePackageToken private presaleTokenContract;
376     
377     function RigCraftPresalePackageManager() public
378     {
379         owner = msg.sender;
380         isActive = false;
381         presaleTokenContract = RigCraftPresalePackageToken(address(0));
382         
383         presalePackSold.length     = 5;
384         presalePackLimit.length    = 5;
385         presalePackagePrice.length = 5;
386        
387         // starter pack 
388         presalePackLimit[0]    = 65000;
389         presalePackagePrice[0] = 0.1 ether;
390         
391         // snow white
392         presalePackLimit[1]    = 50;
393         presalePackagePrice[1] = 0.33 ether;
394         
395         // 6x66 black
396         presalePackLimit[2]    = 66;
397         presalePackagePrice[2] = 0.66 ether;
398         
399         // blue legandary
400         presalePackLimit[3]    = 50;
401         presalePackagePrice[3] = 0.99 ether;
402         
403         // lifetime share
404         presalePackLimit[4]    = 100;
405         presalePackagePrice[4] = 1 ether;
406     }
407     
408     function SetActive(bool _active) external
409     {
410         require(msg.sender == owner);
411         isActive = _active;
412     } 
413     
414     function SetPresaleHandler(address addr) external
415     {
416         require(msg.sender == owner);
417         presaleTokenContract = RigCraftPresalePackageToken(addr);
418     }
419     
420     function AddNewPresalePackage(uint16 limit, uint256 price) external 
421     {
422         require(msg.sender == owner);
423         require(limit > 0);
424         require(isActive);
425         
426         presalePackLimit.length += 1;
427         presalePackLimit[presalePackLimit.length-1] = limit;
428         
429         presalePackagePrice.length += 1;
430         presalePackagePrice[presalePackagePrice.length-1] = price;
431         
432         presalePackSold.length += 1;
433     }
434     
435     // ETH handler
436     function BuyPresalePackage(uint8 packageId, address referral) external payable
437     {
438         require(isActive);
439         require(packageId < presalePackLimit.length);
440         require(msg.sender != referral);
441         require(presalePackLimit[packageId] > presalePackSold[packageId]);
442 
443         require(presaleTokenContract != RigCraftPresalePackageToken(address(0)));
444 
445         // check money
446         require(msg.value >= presalePackagePrice[packageId]);
447         
448         presalePackSold[packageId]++;
449         
450         totalFundsSoFar += msg.value;
451         
452         presaleTokenContract.CreateToken(msg.sender, packageId, presalePackSold[packageId]);
453         
454         if(referral != address(0))
455         {
456             if(addressRefferedCount[referral] == 0)
457             {
458                 referralAddressIndex.length += 1;
459                 referralAddressIndex[referralAddressIndex.length-1] = referral;
460             }
461             addressRefferedCount[referral] += 1;
462             addressRefferredSpending[referral] += msg.value;
463         }
464     }
465 
466     // referral system 
467     function GetAllReferralAddresses() external view returns (address[] referred)
468     {
469         referred = referralAddressIndex;
470     }
471     
472     function GetReferredCount() external view returns (uint256)
473     {
474         return referralAddressIndex.length;
475     }
476     
477     function GetReferredAt(uint256 idx) external view returns (address)
478     {
479         require(idx < referralAddressIndex.length);
480         return referralAddressIndex[idx];
481     }
482     
483     function GetReferralDataOfAddress(address addr) external view returns (uint256 count, uint256 spending)
484     {
485         count = addressRefferedCount[addr];
486         spending = addressRefferredSpending[addr];
487     }
488 
489     // withdraw 
490     function withdraw() external
491     {
492         require(msg.sender == owner);
493         owner.transfer(address(this).balance);
494     }
495 }