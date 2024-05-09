1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     /**
27     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
45 contract ERC721 {
46     // Required methods
47     function approve(address _to, uint256 _tokenId) public;
48     function balanceOf(address _owner) public view returns (uint256 balance);
49     function implementsERC721() public pure returns (bool);
50     function ownerOf(uint256 _tokenId) public view returns (address addr);
51     function takeOwnership(uint256 _tokenId) public;
52     function totalSupply() public view returns (uint256 total);
53     function transferFrom(address _from, address _to, uint256 _tokenId) public;
54     function transfer(address _to, uint256 _tokenId) public;
55 
56     event Transfer(address indexed from, address indexed to, uint256 tokenId);
57     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
58 }
59 
60 contract WorldCupToken is ERC721 {
61 
62     /*****------ EVENTS -----*****/
63     // @dev whenever a token is sold.
64     event WorldCupTokenWereSold(address indexed curOwner, uint256 indexed tokenId, uint256 oldPrice, uint256 newPrice, address indexed prevOwner, uint256 traddingTime);//indexed
65     // @dev whenever Share Bonus.
66 	event ShareBonus(address indexed toOwner, uint256 indexed tokenId, uint256 indexed traddingTime, uint256 remainingAmount);
67 	// @dev Present. 
68     event Present(address indexed fromAddress, address indexed toAddress, uint256 amount, uint256 presentTime);
69     // @dev Transfer event as defined in ERC721. 
70     event Transfer(address from, address to, uint256 tokenId);
71 
72     /*****------- CONSTANTS -------******/
73     mapping (uint256 => address) public worldCupIdToOwnerAddress;  //@dev A mapping from world cup team id to the address that owns them. 
74     mapping (address => uint256) private ownerAddressToTokenCount; //@dev A mapping from owner address to count of tokens that address owns.
75     mapping (uint256 => address) public worldCupIdToAddressForApproved; // @dev A mapping from token id to an address that has been approved to call.
76     mapping (uint256 => uint256) private worldCupIdToPrice; // @dev A mapping from token id to the price of the token.
77     //mapping (uint256 => uint256) private worldCupIdToOldPrice; // @dev A mapping from token id to the old price of the token.
78     string[] private worldCupTeamDescribe;
79 	uint256 private SHARE_BONUS_TIME = uint256(now);
80     address public ceoAddress;
81     address public cooAddress;
82 
83     /*****------- MODIFIERS -------******/
84     modifier onlyCEO() {
85         require(msg.sender == ceoAddress);
86         _;
87     }
88 
89     modifier onlyCLevel() {
90         require(
91             msg.sender == ceoAddress ||
92             msg.sender == cooAddress
93         );
94         _;
95     }
96 
97     function setCEO(address _newCEO) public onlyCEO {
98         require(_newCEO != address(0));
99         ceoAddress = _newCEO;
100     }
101 
102     function setCOO(address _newCOO) public onlyCEO {
103         require(_newCOO != address(0));
104         cooAddress = _newCOO;
105     }
106 	
107 	function destroy() public onlyCEO {
108 		selfdestruct(ceoAddress);
109     }
110 	
111 	function payAllOut() public onlyCLevel {
112        ceoAddress.transfer(this.balance);
113     }
114 
115     /*****------- CONSTRUCTOR -------******/
116     function WorldCupToken() public {
117         ceoAddress = msg.sender;
118         cooAddress = msg.sender;
119 	    for (uint256 i = 0; i < 32; i++) {
120 		    uint256 newWorldCupTeamId = worldCupTeamDescribe.push("I love world cup!") - 1;
121             worldCupIdToPrice[newWorldCupTeamId] = 0 ether;//SafeMath.sub(uint256(3.2 ether), SafeMath.mul(uint256(0.1 ether), i));
122 	        //worldCupIdToOldPrice[newWorldCupTeamId] = 0 ether;
123             _transfer(address(0), msg.sender, newWorldCupTeamId);
124 	    }
125     }
126 
127     /*****------- PUBLIC FUNCTIONS -------******/
128     function approve(address _to, uint256 _tokenId) public {
129         require(_isOwner(msg.sender, _tokenId));
130         worldCupIdToAddressForApproved[_tokenId] = _to;
131         Approval(msg.sender, _to, _tokenId);
132     }
133 
134     /// For querying balance of a particular account
135     function balanceOf(address _owner) public view returns (uint256 balance) {
136         return ownerAddressToTokenCount[_owner];
137     }
138 
139     /// @notice Returns all the world cup team information by token id.
140     function getWorlCupByID(uint256 _tokenId) public view returns (string wctDesc, uint256 sellingPrice, address owner) {
141         wctDesc = worldCupTeamDescribe[_tokenId];
142         sellingPrice = worldCupIdToPrice[_tokenId];
143         owner = worldCupIdToOwnerAddress[_tokenId];
144     }
145 
146     function implementsERC721() public pure returns (bool) {
147         return true;
148     }
149 
150     /// @dev Required for ERC-721 compliance.
151     function name() public pure returns (string) {
152         return "WorldCupToken";
153     }
154   
155     /// @dev Required for ERC-721 compliance.
156     function symbol() public pure returns (string) {
157         return "WCT";
158     }
159 
160     // @dev Required for ERC-721 compliance.
161     function ownerOf(uint256 _tokenId) public view returns (address owner) {
162         owner = worldCupIdToOwnerAddress[_tokenId];
163         require(owner != address(0));
164         return owner;
165     }
166   
167     function setWorldCupTeamDesc(uint256 _tokenId, string descOfOwner) public {
168         if(ownerOf(_tokenId) == msg.sender){
169 	        worldCupTeamDescribe[_tokenId] = descOfOwner;
170 	    }
171     }
172 
173 	/// Allows someone to send ether and obtain the token
174     ///function PresentToCEO() public payable {
175 	///    ceoAddress.transfer(msg.value);
176 	///	Present(msg.sender, ceoAddress, msg.value, uint256(now));
177 	///}
178 	
179     // Allows someone to send ether and obtain the token
180     function buyWorldCupTeamToken(uint256 _tokenId) public payable {
181         address oldOwner = worldCupIdToOwnerAddress[_tokenId];
182         address newOwner = msg.sender;
183         require(oldOwner != newOwner); // Make sure token owner is not sending to self
184         require(_addressNotNull(newOwner)); //Safety check to prevent against an unexpected 0x0 default.
185 
186 	    uint256 oldSoldPrice = worldCupIdToPrice[_tokenId];//worldCupIdToOldPrice[_tokenId];
187 	    uint256 diffPrice = SafeMath.sub(msg.value, oldSoldPrice);
188 	    uint256 priceOfOldOwner = SafeMath.add(oldSoldPrice, SafeMath.div(diffPrice, 2));
189 	    uint256 priceOfDevelop = SafeMath.div(diffPrice, 4);
190 	    worldCupIdToPrice[_tokenId] = msg.value;//SafeMath.add(msg.value, SafeMath.div(msg.value, 10));
191 	    //worldCupIdToOldPrice[_tokenId] = msg.value;
192 
193         _transfer(oldOwner, newOwner, _tokenId);
194         if (oldOwner != address(this)) {
195 	        oldOwner.transfer(priceOfOldOwner);
196         }
197 	    ceoAddress.transfer(priceOfDevelop);
198 	    if(this.balance >= uint256(3.2 ether)){
199             if((uint256(now) - SHARE_BONUS_TIME) >= 86400){
200 		        for(uint256 i=0; i<32; i++){
201 		            worldCupIdToOwnerAddress[i].transfer(0.1 ether);
202 					ShareBonus(worldCupIdToOwnerAddress[i], i, uint256(now), this.balance);
203 		        }
204 			    SHARE_BONUS_TIME = uint256(now);
205 			    //ShareBonus(SHARE_BONUS_TIME, this.balance);
206 		    }
207 	    }
208 	    WorldCupTokenWereSold(newOwner, _tokenId, oldSoldPrice, msg.value, oldOwner, uint256(now));
209 	}
210 
211     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
212         return worldCupIdToPrice[_tokenId];
213     }
214 
215     /// @dev Required for ERC-721 compliance.
216     function takeOwnership(uint256 _tokenId) public {
217         address newOwner = msg.sender;
218         address oldOwner = worldCupIdToOwnerAddress[_tokenId];
219 
220         // Safety check to prevent against an unexpected 0x0 default.
221         require(_addressNotNull(newOwner));
222 
223         // Making sure transfer is approved
224         require(_approved(newOwner, _tokenId));
225 
226         _transfer(oldOwner, newOwner, _tokenId);
227     }
228 
229     function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
230         uint256 tokenCount = balanceOf(_owner);
231         if (tokenCount == 0) {
232             return new uint256[](0);
233         } else {
234             uint256[] memory result = new uint256[](tokenCount);
235             uint256 totalCars = totalSupply();
236             uint256 resultIndex = 0;
237 
238             uint256 carId;
239             for (carId = 0; carId <= totalCars; carId++) {
240                 if (worldCupIdToOwnerAddress[carId] == _owner) {
241                     result[resultIndex] = carId;
242                     resultIndex++;
243                 }
244             }
245             return result;
246         }
247     }
248   
249     function getCEO() public view returns (address ceoAddr) {
250         return ceoAddress;
251     }
252 
253     //Required for ERC-721 compliance.
254     function totalSupply() public view returns (uint256 total) {
255         return worldCupTeamDescribe.length;
256     }
257   
258     //return BonusPool $
259     function getBonusPool() public view returns (uint256) {
260         return this.balance;
261     }
262   
263     function getTimeFromPrize() public view returns (uint256) {
264         return uint256(now) - SHARE_BONUS_TIME;
265     }
266 
267     /// @dev Required for ERC-721 compliance.
268     function transfer(address _to, uint256 _tokenId) public {
269         require(_isOwner(msg.sender, _tokenId));
270         require(_addressNotNull(_to));
271 
272         _transfer(msg.sender, _to, _tokenId);
273     }
274 
275     /// @dev Required for ERC-721 compliance.
276     function transferFrom(address _from, address _to, uint256 _tokenId) public {
277         require(_isOwner(_from, _tokenId));
278         require(_approved(_to, _tokenId));
279         require(_addressNotNull(_to));
280 
281         _transfer(_from, _to, _tokenId);
282     }
283 
284     /********----------- PRIVATE FUNCTIONS ------------********/
285     function _addressNotNull(address _to) private pure returns (bool) {
286         return _to != address(0);
287     }
288 
289     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
290         return worldCupIdToAddressForApproved[_tokenId] == _to;
291     }
292 
293     function _isOwner(address checkAddress, uint256 _tokenId) private view returns (bool) {
294         return checkAddress == worldCupIdToOwnerAddress[_tokenId];
295     }
296 
297     function _transfer(address _from, address _to, uint256 _tokenId) private {
298         ownerAddressToTokenCount[_to]++;
299         worldCupIdToOwnerAddress[_tokenId] = _to;  //transfer ownership
300 
301         if (_from != address(0)) {
302             ownerAddressToTokenCount[_from]--;
303             delete worldCupIdToAddressForApproved[_tokenId];
304         }
305         Transfer(_from, _to, _tokenId);
306     }
307 }