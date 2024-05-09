1 library SafeMath {
2     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3         if (a == 0) {
4             return 0;
5         }
6         uint256 c = a * b;
7         assert(c / a == b);
8         return c;
9     }
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c>= a);
21         return c;
22     }
23 }
24 contract ERC721 {
25     function approve( address _to, uint256 _tokenId) public;
26     function balanceOf(address _owner) public view returns (uint256 balance);
27     function implementsERC721() public pure returns (bool);
28     function ownerOf(uint256 _tokenId) public view returns (address addr);
29     function takeOwnership(uint256 _tokenId) public;
30     function totalSupply() public view returns (uint256 supply);
31     function transferFrom(address _from, address _to, uint256 _tokenId) public;
32     function transfer(address _to, uint256 _tokenId) public;
33 
34     event Transfer(address indexed from, address indexed to, uint256 tokenId);
35     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
36 }
37 
38 contract AthleteToken is ERC721 {
39     string public constant NAME = "CryptoFantasy";
40     string public constant SYMBOL = "Athlete";
41     uint256 private constant initPrice = 0.001 ether;
42     event Birth(uint256 tokenId, address owner);
43     event TokenSold(uint256 tokenId, uint256 sellPrice, address sellOwner, address buyOwner, string athleteId);
44     event Transfer(address from, address to, uint256 tokenId);
45     mapping (uint256 => address) public athleteIndexToOwner;
46 
47     mapping (address => uint256) private ownershipTokenCount;
48 
49     
50     mapping (uint256 => address) public athleteIndexToApproved;
51     mapping (uint256 => uint256) private athleteIndexToPrice;
52     mapping (uint256 => uint256) private athleteIndexToActualFee;
53     mapping (uint256 => uint256) private athleteIndexToSiteFee;
54     mapping (uint256 => address) private athleteIndexToActualWalletId;
55     mapping (uint256 => string) private athleteIndexToAthleteID;
56     mapping (uint256 => bool) private athleteIndexToAthleteVerificationState;
57     address public ceoAddress;
58     address public cooAddress;
59     uint256 public promoCreatedCount;
60 
61     struct Athlete {
62         string  athleteId;
63         address actualAddress;
64         uint256 actualFee;
65         uint256 siteFee;
66         uint256 sellPrice;
67         bool    isVerified;
68     }
69     Athlete[] private athletes;
70     mapping (uint256 => Athlete) private athleteIndexToAthlete;
71     modifier onlyCEO() {
72         require(msg.sender == ceoAddress);
73         _;
74     }
75     modifier onlyCOO() {
76         require(msg.sender == cooAddress);
77         _;
78     }
79     modifier onlyCLevel() {
80         require(msg.sender == ceoAddress || msg.sender == cooAddress);
81         _;
82     }
83 
84     function AthleteToken() public {
85         ceoAddress = msg.sender;
86         cooAddress = msg.sender;
87     }
88 
89     function approve( address _to, uint256 _tokenId ) public {
90         require(_owns(msg.sender, _tokenId));
91         athleteIndexToApproved[_tokenId] = _to;
92         Approval(msg.sender, _to, _tokenId);
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return ownershipTokenCount[_owner];
97     }
98 
99     function createOfAthleteCard(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO returns (uint256 _newAthleteId) {
100         
101         address _athleteOwner = address(this);
102         bool _verified = true;
103         if ( _sellPrice <= 0 ) {
104             _sellPrice = initPrice;
105         }
106         if ( _actualAddress == address(0) ){
107             _actualAddress = ceoAddress;
108             _verified = false;
109         }
110         
111         Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice, isVerified: _verified });
112         uint256 newAthleteId = athletes.push(_athlete) - 1;
113         
114         require(newAthleteId == uint256(uint32(newAthleteId)));
115         Birth(newAthleteId, _athleteOwner);
116         
117         athleteIndexToPrice[newAthleteId] = _sellPrice;
118         athleteIndexToActualFee[newAthleteId] = _actualFee;
119         athleteIndexToSiteFee[newAthleteId] = _siteFee;
120         athleteIndexToActualWalletId[newAthleteId] = _actualAddress;
121         athleteIndexToAthleteID[newAthleteId] = _athleteId;
122         athleteIndexToAthlete[newAthleteId] = _athlete;
123         athleteIndexToAthleteVerificationState[newAthleteId] = _verified;
124         
125         _transfer(address(0), _athleteOwner, newAthleteId);
126         return newAthleteId;
127     }
128     
129     function changeOriginWalletIdForAthlete( uint256 _tokenId, address _oringinWalletId ) public onlyCOO returns( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {
130         athleteIndexToActualWalletId[_tokenId] = _oringinWalletId;
131         Athlete storage athlete = athletes[_tokenId];
132         athlete.actualAddress = _oringinWalletId;
133         athleteId     = athlete.athleteId;
134         actualAddress = athlete.actualAddress;
135         actualFee     = athlete.actualFee;
136         siteFee       = athlete.siteFee;
137         sellPrice     = priceOf(_tokenId);
138         owner         = ownerOf(_tokenId);
139     }
140     
141     function changeSellPriceForAthlete( uint256 _tokenId, uint256 _newSellPrice ) public onlyCOO returns( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {
142         athleteIndexToPrice[_tokenId] = _newSellPrice;
143         Athlete storage athlete = athletes[_tokenId];
144         athlete.sellPrice = _newSellPrice;
145         athleteId     = athlete.athleteId;
146         actualAddress = athlete.actualAddress;
147         actualFee     = athlete.actualFee;
148         siteFee       = athlete.siteFee;
149         sellPrice     = athlete.sellPrice;
150         owner         = ownerOf(_tokenId);
151     }
152     
153     function createContractOfAthlete(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO{
154         _createOfAthlete(address(this), _athleteId, _actualAddress, _actualFee, _siteFee, _sellPrice);
155     }
156 
157     function getAthlete(uint256 _tokenId) public view returns ( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {
158         Athlete storage athlete = athletes[_tokenId];
159         athleteId     = athlete.athleteId;
160         actualAddress = athlete.actualAddress;
161         actualFee     = athlete.actualFee;
162         siteFee       = athlete.siteFee;
163         sellPrice     = priceOf(_tokenId);
164         owner         = ownerOf(_tokenId);
165     }
166 
167     function implementsERC721() public pure returns (bool) {
168         return true;
169     }
170     function name() public pure returns (string) {
171         return NAME;
172     }
173     function ownerOf(uint256 _tokenId) public view returns (address owner) {
174         owner = athleteIndexToOwner[_tokenId];
175         require(owner != address(0));
176     }
177     function payout(address _to) public onlyCLevel {
178         _payout(_to);
179     }
180     function purchase(uint256 _tokenId) public payable {
181         address sellOwner = athleteIndexToOwner[_tokenId];
182         address buyOwner = msg.sender;
183         uint256 sellPrice = msg.value;
184 
185         //make sure token owner is not sending to self
186         require(sellOwner != buyOwner);
187         //safely check to prevent against an unexpected 0x0 default
188         require(_addressNotNull(buyOwner));
189         //make sure sent amount is greater than or equal to the sellPrice
190         require(msg.value >= sellPrice);
191         uint256 actualFee = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToActualFee[_tokenId]), 100)); // calculate actual fee
192         uint256 siteFee   = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToSiteFee[_tokenId]), 100));   // calculate site fee
193         uint256 payment   = uint256(SafeMath.sub(sellPrice, SafeMath.add(actualFee, siteFee)));   //payment for seller
194 
195         _transfer(sellOwner, buyOwner, _tokenId);
196         //Pay previous tokenOwner if owner is not contract
197         if ( sellOwner != address(this) ) {
198             sellOwner.transfer(payment); // (1-(actual_fee+site_fee))*sellPrice
199         }
200         TokenSold(_tokenId, sellPrice, sellOwner, buyOwner, athletes[_tokenId].athleteId);
201         address actualWallet = athleteIndexToActualWalletId[_tokenId];
202         actualWallet.transfer(actualFee);
203             
204         ceoAddress.transfer(siteFee);
205 
206     }
207 
208     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
209         return athleteIndexToPrice[_tokenId];
210     }
211     function setCEO(address _newCEO) public onlyCEO {
212         require(_newCEO != address(0));
213         ceoAddress = _newCEO;
214     }
215     function setCOO(address _newCOO) public onlyCEO {
216         require(_newCOO != address(0));
217         cooAddress = _newCOO;
218     }
219     function symbol() public pure returns (string) {
220         return SYMBOL;
221     }
222     function takeOwnership(uint256 _tokenId) public {
223         address newOwner = msg.sender;
224         address oldOwner = athleteIndexToOwner[_tokenId];
225         
226         require(_addressNotNull(newOwner));
227         require(_approved(newOwner, _tokenId));
228         _transfer(oldOwner, newOwner, _tokenId);
229     }
230 
231     function tokenOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
232         uint256 tokenCount = balanceOf(_owner);
233         if ( tokenCount == 0 ) {
234             return new uint256[](0);
235         }
236         else {
237             uint256[] memory result = new uint256[](tokenCount);
238             uint256 totalAthletes = totalSupply();
239             uint256 resultIndex = 0;
240             uint256 athleteId;
241 
242             for(athleteId = 0; athleteId <= totalAthletes; athleteId++) {
243                 if (athleteIndexToOwner[athleteId] == _owner) {
244                     result[resultIndex] = athleteId;
245                     resultIndex++;
246                 }
247             }
248             return result;
249         }
250     }
251 
252     function totalSupply() public view returns (uint256 total) {
253         return athletes.length;
254     }
255 
256     function transfer( address _to, uint256 _tokenId ) public {
257         require(_owns(msg.sender, _tokenId));
258         require(_addressNotNull(_to));
259 
260         _transfer(msg.sender, _to, _tokenId);
261     }
262 
263     function transferFrom( address _from, address _to, uint256 _tokenId ) public {
264         require(_owns(_from, _tokenId));
265         require(_approved(_to, _tokenId));
266         require(_addressNotNull(_to));
267 
268         _transfer(_from, _to, _tokenId);
269     }
270 
271     function _addressNotNull(address _to) private pure returns (bool) {
272         return _to != address(0);
273     }
274     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
275         return athleteIndexToApproved[_tokenId] == _to;
276     }
277 
278     function _createOfAthlete(address _athleteOwner, string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) private {
279         
280         bool _verified = true;
281         // Check sell price and origin wallet id
282         if ( _sellPrice <= 0 ) {
283             _sellPrice = initPrice;
284         }
285         if ( _actualAddress == address(0) ){
286             _actualAddress = ceoAddress;
287             _verified = false;
288         }
289         
290         Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice, isVerified: _verified });
291         uint256 newAthleteId = athletes.push(_athlete) - 1;
292         
293         require(newAthleteId == uint256(uint32(newAthleteId)));
294         Birth(newAthleteId, _athleteOwner);
295         
296         athleteIndexToPrice[newAthleteId] = _sellPrice;
297         athleteIndexToActualFee[newAthleteId] = _actualFee;
298         athleteIndexToSiteFee[newAthleteId] = _siteFee;
299         athleteIndexToActualWalletId[newAthleteId] = _actualAddress;
300         athleteIndexToAthleteID[newAthleteId] = _athleteId;
301         athleteIndexToAthlete[newAthleteId] = _athlete;
302         athleteIndexToAthleteVerificationState[newAthleteId] = _verified;
303         
304         _transfer(address(0), _athleteOwner, newAthleteId);
305 
306     }
307 
308     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
309         return claimant == athleteIndexToOwner[_tokenId];
310     }
311     function _payout(address _to) private {
312         if (_to == address(0)) {
313             ceoAddress.transfer(this.balance);
314         }
315         else {
316             _to.transfer(this.balance);
317         }
318     }
319     function _transfer(address _from, address _to, uint256 _tokenId) private {
320         ownershipTokenCount[_to]++;
321         athleteIndexToOwner[_tokenId] = _to;
322         if (_from != address(0)) {
323             ownershipTokenCount[_from]--;
324             delete athleteIndexToApproved[_tokenId];
325         }
326         Transfer(_from, _to, _tokenId);
327     }
328 
329 }