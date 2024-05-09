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
39     /****  CONSTANTS ****/
40     string public constant NAME = "CryptoFantasy";
41     string public constant SYMBOL = "AthleteToken";
42 
43     uint256 private constant initPrice = 0.001 ether;
44     uint256 private constant PROMO_CREATION_LIMIT = 50000;
45 
46     /*** EVENTS  */
47     event Birth(uint256 tokenId, address owner);
48     event TokenSold(uint256 tokenId, uint256 sellPrice, address sellOwner, address buyOwner, string athleteId);
49     event Transfer(address from, address to, uint256 tokenId);
50 
51     /*** STORAGE */
52     // A mapping from athlete IDs to the address that owns them. All athletes have some valid owner address.
53     mapping (uint256 => address) public athleteIndexToOwner;
54 
55     // A mapping from owner address to count of tokens that address owns.
56     // Used internally inside balanceOf() to resolve ownership count.
57     mapping (address => uint256) private ownershipTokenCount;
58 
59     /**
60         *** A mapping from athleteIDs to an address that has been approved to call transferFrom(). 
61         *** Each athlete can only have one approved address for transfer at any time.
62         *** A ZERO value means no approval is outstanding.
63      */
64     mapping (uint256 => address) public athleteIndexToApproved;
65 
66     // A mapping from athleteIDs to the price of the token.
67     mapping (uint256 => uint256) private athleteIndexToPrice;
68 
69     // A mapping from athleteIDs to the actual fee of the token.
70     mapping (uint256 => uint256) private athleteIndexToActualFee;
71 
72     // A mapping from athleteIDs to the site fee of the token.
73     mapping (uint256 => uint256) private athleteIndexToSiteFee;
74 
75     // A mapping from athleteIDs to the actual wallet address of the token
76     mapping (uint256 => address) private athleteIndexToActualWalletId;
77 
78     // A mapping of athleteIDs
79     mapping (uint256 => string) private athleteIndexToAthleteID;
80 
81 
82     // The addresses of the accounts (or contracts) that can execute actions within each roles.
83     address public ceoAddress;
84     address public cooAddress;
85 
86     uint256 public promoCreatedCount;
87 
88     /** ATHLETE DATATYPE */
89     struct Athlete {
90         string  athleteId;
91         address actualAddress;
92         uint256 actualFee;
93         uint256 siteFee;
94         uint256 sellPrice;
95     }
96     Athlete[] private athletes;
97 
98     mapping (uint256 => Athlete) private athleteIndexToAthlete;
99 
100     modifier onlyCEO() {
101         require(msg.sender == ceoAddress);
102         _;
103     }
104     modifier onlyCOO() {
105         require(msg.sender == cooAddress);
106         _;
107     }
108     modifier onlyCLevel() {
109         require(msg.sender == ceoAddress || msg.sender == cooAddress);
110         _;
111     }
112 
113     /** CONSTRUCTOR */
114     function AthleteToken() public {
115         ceoAddress = msg.sender;
116         cooAddress = msg.sender;
117     }
118 
119     /*** PUBLIC FUNCTIONS */
120     function approve( address _to, uint256 _tokenId ) public {
121         require(_owns(msg.sender, _tokenId));
122         athleteIndexToApproved[_tokenId] = _to;
123         Approval(msg.sender, _to, _tokenId);
124     }
125 
126     function balanceOf(address _owner) public view returns (uint256 balance) {
127         return ownershipTokenCount[_owner];
128     }
129 
130 
131     function createPromoAthlete(address _owner, string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint _sellPrice) public onlyCOO {
132         require(promoCreatedCount < PROMO_CREATION_LIMIT);
133 
134         address athleteOwner = _owner;
135         if ( athleteOwner == address(0) ) {
136             athleteOwner = cooAddress;
137         }
138         if ( _sellPrice <= 0 ) {
139             _sellPrice = initPrice;
140         }
141         promoCreatedCount++;
142 
143         _createOfAthlete(athleteOwner, _athleteId, _actualAddress, _actualFee, _siteFee, _sellPrice);
144     }
145 
146 
147     function createContractOfAthlete(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO{
148         _createOfAthlete(address(this), _athleteId, _actualAddress, _actualFee, _siteFee, _sellPrice);
149     }
150 
151     function getAthlete(uint256 _tokenId) public view returns ( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {
152         Athlete storage athlete = athletes[_tokenId];
153         athleteId     = athlete.athleteId;
154         actualAddress = athlete.actualAddress;
155         actualFee     = athlete.actualFee;
156         siteFee       = athlete.siteFee;
157         sellPrice     = priceOf(_tokenId);
158         owner         = ownerOf(_tokenId);
159     }
160 
161     function implementsERC721() public pure returns (bool) {
162         return true;
163     }
164     function name() public pure returns (string) {
165         return NAME;
166     }
167     function ownerOf(uint256 _tokenId) public view returns (address owner) {
168         owner = athleteIndexToOwner[_tokenId];
169         require(owner != address(0));
170     }
171     function payout(address _to) public onlyCLevel {
172         _payout(_to);
173     }
174     function purchase(uint256 _tokenId) public payable {
175         address sellOwner = athleteIndexToOwner[_tokenId];
176         address buyOwner = msg.sender;
177 
178         uint256 sellPrice = priceOf(_tokenId);
179 
180         //make sure token owner is not sending to self
181         require(sellOwner != buyOwner);
182         //safely check to prevent against an unexpected 0x0 default
183         require(_addressNotNull(buyOwner));
184 
185         //make sure sent amount is greater than or equal to the sellPrice
186         require(msg.value >= sellPrice);
187 
188         uint256 actualFee = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToActualFee[_tokenId]), 100)); // calculate actual fee
189         uint256 siteFee   = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToSiteFee[_tokenId]), 100));   // calculate site fee
190         uint256 payment   = uint256(SafeMath.sub(sellPrice, SafeMath.add(actualFee, siteFee)));   //payment for seller
191 
192         _transfer(sellOwner, buyOwner, _tokenId);
193 
194         //Pay previous tokenOwner if owner is not contract
195         if ( sellOwner != address(this) ) {
196             sellOwner.transfer(payment); // (1-(actual_fee+site_fee))*sellPrice
197         }
198 
199         TokenSold(_tokenId, sellPrice, sellOwner, buyOwner, athletes[_tokenId].athleteId);
200         msg.sender.transfer(siteFee);
201 
202         address actualWallet = athleteIndexToActualWalletId[_tokenId];
203         actualWallet.transfer(actualFee);
204 
205         ceoAddress.transfer(siteFee);
206 
207     }
208 
209     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
210         return athleteIndexToPrice[_tokenId];
211     }
212     function setCEO(address _newCEO) public onlyCEO {
213         require(_newCEO != address(0));
214         ceoAddress = _newCEO;
215     }
216     function setCOO(address _newCOO) public onlyCEO {
217         require(_newCOO != address(0));
218         cooAddress = _newCOO;
219     }
220     function symbol() public pure returns (string) {
221         return SYMBOL;
222     }
223     function takeOwnership(uint256 _tokenId) public {
224         address newOwner = msg.sender;
225         address oldOwner = athleteIndexToOwner[_tokenId];
226         
227         require(_addressNotNull(newOwner));
228         require(_approved(newOwner, _tokenId));
229         _transfer(oldOwner, newOwner, _tokenId);
230     }
231 
232     function tokenOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
233         uint256 tokenCount = balanceOf(_owner);
234         if ( tokenCount == 0 ) {
235             return new uint256[](0);
236         }
237         else {
238             uint256[] memory result = new uint256[](tokenCount);
239             uint256 totalAthletes = totalSupply();
240             uint256 resultIndex = 0;
241             uint256 athleteId;
242 
243             for(athleteId = 0; athleteId <= totalAthletes; athleteId++) {
244                 if (athleteIndexToOwner[athleteId] == _owner) {
245                     result[resultIndex] = athleteId;
246                     resultIndex++;
247                 }
248             }
249             return result;
250         }
251     }
252 
253     function totalSupply() public view returns (uint256 total) {
254         return athletes.length;
255     }
256 
257     function transfer( address _to, uint256 _tokenId ) public {
258         require(_owns(msg.sender, _tokenId));
259         require(_addressNotNull(_to));
260 
261         _transfer(msg.sender, _to, _tokenId);
262     }
263 
264     function transferFrom( address _from, address _to, uint256 _tokenId ) public {
265         require(_owns(_from, _tokenId));
266         require(_approved(_to, _tokenId));
267         require(_addressNotNull(_to));
268 
269         _transfer(_from, _to, _tokenId);
270     }
271 
272     /** PRIVATE FUNCTIONS */
273     function _addressNotNull(address _to) private pure returns (bool) {
274         return _to != address(0);
275     }
276     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
277         return athleteIndexToApproved[_tokenId] == _to;
278     }
279 
280     //TODO -----------------------------------------------------------------------------------------------------------------------------------------
281     function _createOfAthlete(address _athleteOwner, string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) private {
282         
283         Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice });
284         
285         uint256 newAthleteId = athletes.push(_athlete) - 1;
286  
287         if ( _sellPrice <= 0 ) {
288             _sellPrice = initPrice;
289         }
290         require(newAthleteId == uint256(uint32(newAthleteId)));
291         Birth(newAthleteId, _athleteOwner);
292         
293         athleteIndexToPrice[newAthleteId] = _sellPrice;
294         athleteIndexToActualFee[newAthleteId] = _actualFee;
295         athleteIndexToSiteFee[newAthleteId] = _siteFee;
296         athleteIndexToActualWalletId[newAthleteId] = _actualAddress;
297         athleteIndexToAthleteID[newAthleteId] = _athleteId;
298         athleteIndexToAthlete[newAthleteId] = _athlete;
299 
300         _transfer(address(0), _athleteOwner, newAthleteId);
301 
302     }
303 
304     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
305         return claimant == athleteIndexToOwner[_tokenId];
306     }
307     function _payout(address _to) private {
308         if (_to == address(0)) {
309             ceoAddress.transfer(this.balance);
310         }
311         else {
312             _to.transfer(this.balance);
313         }
314     }
315     function _transfer(address _from, address _to, uint256 _tokenId) private {
316         ownershipTokenCount[_to]++;
317         athleteIndexToOwner[_tokenId] = _to;
318         if (_from != address(0)) {
319             ownershipTokenCount[_from]--;
320             delete athleteIndexToApproved[_tokenId];
321         }
322         Transfer(_from, _to, _tokenId);
323     }
324 
325 }