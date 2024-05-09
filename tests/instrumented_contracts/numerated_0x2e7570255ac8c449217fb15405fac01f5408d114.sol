1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5   address public ceoWallet;
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   constructor() public {
10     owner = msg.sender;
11     ceoWallet = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) public onlyOwner {
20     require(newOwner != address(0));
21     emit OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 }
25 
26 // Interface for contracts conforming to ERC-721: Non-Fungible Tokens
27 contract ERC721 {
28   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
29   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
30 
31   function balanceOf(address _owner) public view returns (uint256 _balance);
32   function ownerOf(uint256 _tokenId) public view returns (address _owner);
33   function transfer(address _to, uint256 _tokenId) public;
34   function approve(address _to, uint256 _tokenId) public;
35   function takeOwnership(uint256 _tokenId) public;
36   function totalSupply() public view returns (uint256 total);
37 }
38 
39 
40 contract CryptoRomeControl is Ownable {
41 
42     bool public paused = false;
43 
44     modifier whenNotPaused() {
45         require(!paused);
46         _;
47     }
48 
49     modifier whenPaused {
50         require(paused);
51         _;
52     }
53 
54     function transferWalletOwnership(address newWalletAddress) onlyOwner public {
55       require(newWalletAddress != address(0));
56       ceoWallet = newWalletAddress;
57     }
58 
59     function pause() external onlyOwner whenNotPaused {
60         paused = true;
61     }
62 
63     function unpause() public onlyOwner whenPaused {
64         paused = false;
65     }
66 }
67 
68 contract Centurions is ERC721, CryptoRomeControl {
69 
70     // Name and symbol of the non fungible token, as defined in ERC721.
71     string public constant name = "CryptoRomeCenturion";
72     string public constant symbol = "CROMEC";
73 
74     struct Centurion {
75         uint256 level;
76         uint256 experience;
77         uint256 askingPrice;
78     }
79 
80     uint256[50] public expForLevels = [
81         0,   // 0
82         20,
83         50,
84         100,
85         200,
86         400,  // 5
87         800,
88         1400,
89         2100,
90         3150,
91         4410,  // 10
92         5740,
93         7460,
94         8950,
95         10740,
96         12880,
97         15460,
98         18550,
99         22260,
100         26710,
101         32050, // 20
102         38500,
103         46200,
104         55400,
105         66500,
106         79800,
107         95700,
108         115000,
109         138000,
110         166000,
111         200000, // 30
112         240000,
113         290000,
114         350000,
115         450000,
116         580000,
117         820000,
118         1150000,
119         1700000,
120         2600000,
121         3850000, // 40
122         5800000,
123         8750000,
124         13000000,
125         26000000,
126         52000000,
127         104000000,
128         208000000,
129         416000000,
130         850000000 // 49
131     ];
132 
133     Centurion[] internal allCenturionTokens;
134 
135     string internal tokenURIs;
136 
137     // Map of Centurion to the owner
138     mapping (uint256 => address) public centurionIndexToOwner;
139     mapping (address => uint256) ownershipTokenCount;
140     mapping (uint256 => address) centurionIndexToApproved;
141 
142     modifier onlyOwnerOf(uint256 _tokenId) {
143         require(centurionIndexToOwner[_tokenId] == msg.sender);
144         _;
145     }
146 
147     function getCenturion(uint256 _tokenId) external view
148         returns (
149             uint256 level,
150             uint256 experience,
151             uint256 askingPrice
152         ) {
153         Centurion storage centurion = allCenturionTokens[_tokenId];
154 
155         level = centurion.level;
156         experience = centurion.experience;
157         askingPrice = centurion.askingPrice;
158     }
159 
160     function updateTokenUri(uint256 _tokenId, string _tokenURI) public whenNotPaused onlyOwner {
161         _setTokenURI(_tokenId, _tokenURI);
162     }
163 
164     function createCenturion() public whenNotPaused onlyOwner returns (uint256) {
165         uint256 finalId = _createCenturion(msg.sender);
166         return finalId;
167     }
168 
169     function issueCenturion(address _to) public whenNotPaused onlyOwner returns (uint256) {
170         uint256 finalId = _createCenturion(msg.sender);
171         _transfer(msg.sender, _to, finalId);
172         return finalId;
173     }
174 
175     function listCenturion(uint256 _askingPrice) public whenNotPaused onlyOwner returns (uint256) {
176         uint256 finalId = _createCenturion(msg.sender);
177         allCenturionTokens[finalId].askingPrice = _askingPrice;
178         return finalId;
179     }
180 
181     function sellCenturion(uint256 _tokenId, uint256 _askingPrice) onlyOwnerOf(_tokenId) whenNotPaused public {
182         allCenturionTokens[_tokenId].askingPrice = _askingPrice;
183     }
184 
185     function cancelCenturionSale(uint256 _tokenId) onlyOwnerOf(_tokenId) whenNotPaused public {
186         allCenturionTokens[_tokenId].askingPrice = 0;
187     }
188 
189     function purchaseCenturion(uint256 _tokenId) whenNotPaused public payable {
190         require(allCenturionTokens[_tokenId].askingPrice > 0);
191         require(msg.value >= allCenturionTokens[_tokenId].askingPrice);
192         allCenturionTokens[_tokenId].askingPrice = 0;
193         uint256 fee = devFee(msg.value);
194         ceoWallet.transfer(fee);
195         centurionIndexToOwner[_tokenId].transfer(SafeMath.sub(address(this).balance, fee));
196         _transfer(centurionIndexToOwner[_tokenId], msg.sender, _tokenId);
197     }
198 
199     function _transfer(address _from, address _to, uint256 _tokenId) internal {
200         ownershipTokenCount[_to] = SafeMath.add(ownershipTokenCount[_to], 1);
201         centurionIndexToOwner[_tokenId] = _to;
202         if (_from != address(0)) {
203             // clear any previously approved ownership exchange
204             ownershipTokenCount[_from] = SafeMath.sub(ownershipTokenCount[_from], 1);
205             delete centurionIndexToApproved[_tokenId];
206         }
207     }
208 
209     function _createCenturion(address _owner) internal returns (uint) {
210         Centurion memory _centurion = Centurion({
211             level: 1,
212             experience: 0,
213             askingPrice: 0
214         });
215         uint256 newCenturionId = allCenturionTokens.push(_centurion) - 1;
216 
217         // Only 1000 centurions should ever exist (0-999)
218         require(newCenturionId < 1000);
219         _transfer(0, _owner, newCenturionId);
220         return newCenturionId;
221     }
222 
223     function devFee(uint256 amount) internal pure returns(uint256){
224         return SafeMath.div(SafeMath.mul(amount, 3), 100);
225     }
226 
227     // Functions for ERC721 Below:
228 
229     // Check is address has approval to transfer centurion.
230     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
231         return centurionIndexToApproved[_tokenId] == _claimant;
232     }
233 
234     function exists(uint256 _tokenId) public view returns (bool) {
235         address owner = centurionIndexToOwner[_tokenId];
236         return owner != address(0);
237     }
238 
239     function addExperience(uint256 _tokenId, uint256 _exp) public whenNotPaused onlyOwner returns (uint256) {
240         require(exists(_tokenId));
241         allCenturionTokens[_tokenId].experience = SafeMath.add(allCenturionTokens[_tokenId].experience, _exp);
242         for (uint256 i = allCenturionTokens[_tokenId].level; i < 50; i++) {
243             if (allCenturionTokens[_tokenId].experience >= expForLevels[i]) {
244                allCenturionTokens[_tokenId].level = allCenturionTokens[_tokenId].level + 1;
245             } else {
246                 break;
247             }
248         }
249         return allCenturionTokens[_tokenId].level;
250     }
251 
252     function tokenURI(uint256 _tokenId) public view returns (string) {
253         require(exists(_tokenId));
254         return tokenURIs;
255     }
256 
257     function _setTokenURI(uint256 _tokenId, string _uri) internal {
258         require(exists(_tokenId));
259         tokenURIs = _uri;
260     }
261 
262     // Sets a centurion as approved for transfer to another address.
263     function _approve(uint256 _tokenId, address _approved) internal {
264         centurionIndexToApproved[_tokenId] = _approved;
265     }
266 
267     // Returns the number of Centurions owned by a specific address.
268     function balanceOf(address _owner) public view returns (uint256 count) {
269         return ownershipTokenCount[_owner];
270     }
271 
272     // Transfers a Centurion to another address. If transferring to a smart
273     // contract ensure that it is aware of ERC-721.
274     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {
275         require(_to != address(0));
276         require(_to != address(this));
277 
278         _transfer(msg.sender, _to, _tokenId);
279         emit Transfer(msg.sender, _to, _tokenId);
280     }
281 
282     //  Permit another address the right to transfer a specific Centurion via
283     //  transferFrom().
284     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {
285         _approve(_tokenId, _to);
286 
287         emit Approval(msg.sender, _to, _tokenId);
288     }
289 
290     // Transfer a Centurion owned by another address, for which the calling address
291     // has previously been granted transfer approval by the owner.
292     function takeOwnership(uint256 _tokenId) public {
293         require(centurionIndexToApproved[_tokenId] == msg.sender);
294         address owner = ownerOf(_tokenId);
295         _transfer(owner, msg.sender, _tokenId);
296         emit Transfer(owner, msg.sender, _tokenId);
297   }
298 
299     // 1000 Centurions will ever exist
300     function totalSupply() public view returns (uint) {
301         return allCenturionTokens.length;
302     }
303 
304     function ownerOf(uint256 _tokenId) public view returns (address owner)
305     {
306         owner = centurionIndexToOwner[_tokenId];
307         require(owner != address(0));
308     }
309 
310     // List of all Centurion IDs assigned to an address.
311     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
312         uint256 tokenCount = balanceOf(_owner);
313 
314         if (tokenCount == 0) {
315             return new uint256[](0);
316         } else {
317             uint256[] memory result = new uint256[](tokenCount);
318             uint256 totalCenturions = totalSupply();
319             uint256 resultIndex = 0;
320             uint256 centurionId;
321 
322             for (centurionId = 0; centurionId < totalCenturions; centurionId++) {
323                 if (centurionIndexToOwner[centurionId] == _owner) {
324                     result[resultIndex] = centurionId;
325                     resultIndex++;
326                 }
327             }
328             return result;
329         }
330     }
331 }
332 
333 library SafeMath {
334   /**
335   * @dev Multiplies two numbers, throws on overflow.
336   */
337   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338     if (a == 0) {
339       return 0;
340     }
341     uint256 c = a * b;
342     assert(c / a == b);
343     return c;
344   }
345 
346   /**
347   * @dev Integer division of two numbers, truncating the quotient.
348   */
349   function div(uint256 a, uint256 b) internal pure returns (uint256) {
350     // assert(b > 0); // Solidity automatically throws when dividing by 0
351     uint256 c = a / b;
352     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
353     return c;
354   }
355   /**
356   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
357   */
358   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
359     assert(b <= a);
360     return a - b;
361   }
362   /**
363   * @dev Adds two numbers, throws on overflow.
364   */
365   function add(uint256 a, uint256 b) internal pure returns (uint256) {
366     uint256 c = a + b;
367     assert(c >= a);
368     return c;
369   }
370 }