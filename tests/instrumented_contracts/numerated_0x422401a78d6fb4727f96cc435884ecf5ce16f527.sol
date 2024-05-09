1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8   // Required methods
9   function approve(address _to, uint256 _tokenId) public;
10   function balanceOf(address _owner) public view returns (uint256 balance);
11   function implementsERC721() public pure returns (bool);
12   function ownerOf(uint256 _tokenId) public view returns (address addr);
13   function takeOwnership(uint256 _tokenId) public;
14   function totalSupply() public view returns (uint256 total);
15   function transferFrom(address _from, address _to, uint256 _tokenId) public;
16   function transfer(address _to, uint256 _tokenId) public;
17 
18   event Transfer(address indexed from, address indexed to, uint256 tokenId);
19   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21   // Optional
22   // function name() public view returns (string name);
23   // function symbol() public view returns (string symbol);
24   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
25   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
26 }
27 
28 
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
41     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (_a == 0) {
45       return 0;
46     }
47 
48     c = _a * _b;
49     assert(c / _a == _b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
57     // assert(_b > 0); // Solidity automatically throws when dividing by 0
58     // uint256 c = _a / _b;
59     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
60     return _a / _b;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     assert(_b <= _a);
68     return _a - _b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     c = _a + _b;
76     assert(c >= _a);
77     return c;
78   }
79 }
80 
81 contract FollowersToken is ERC721 {
82 
83 	string public constant NAME 		= "FollowersToken";
84 	string public constant SYMBOL 		= "FWTK";
85 
86 	uint256 private startingPrice	= 0.05 ether;
87 	uint256 private firstStepLimit 	= 6.4 ether;
88 	uint256 private secondStepLimit = 120.9324 ether;
89 	uint256 private thirdStepLimit 	= 792.5423 ether;
90 
91 	bool 	private isPresale;
92 
93 	mapping (uint256 => address) public personIndexToOwner;
94 	mapping (address => uint256) private ownershipTokenCount;
95 	mapping (uint256 => address) public personIndexToApproved;
96 	mapping (uint256 => uint256) private personIndexToPrice;
97 	mapping (uint256 => uint256) private personIndexToPriceLevel;
98 
99 	address public ceoAddress;
100 	address public cooAddress;
101 
102 	struct Person {
103 		string name;
104 	}
105 
106 	Person[] private persons;
107 
108 	modifier onlyCEO() {
109 		require(msg.sender == ceoAddress);
110 		_;
111 	}
112 
113 	modifier onlyCOO() {
114 		require(msg.sender == cooAddress);
115 		_;
116 	}
117 
118 	modifier onlyCLevel() {
119 		require( msg.sender == ceoAddress || msg.sender == cooAddress );
120 		_;
121 	}
122 
123 	constructor() public {
124 		ceoAddress = msg.sender;
125 		cooAddress = msg.sender;
126 		isPresale  = true;
127 	}
128 
129 	function startPresale() public onlyCLevel {
130 		isPresale = true;
131 	}
132 
133 	function stopPresale() public onlyCLevel {
134 		isPresale = false;
135 	}
136 
137 	function presale() public view returns ( bool presaleStatus ) {
138 		return isPresale;
139 	}
140 
141 	function approve( address _to, uint256 _tokenId ) public {
142 		// Caller must own token.
143 		require( _owns( msg.sender , _tokenId ) );
144 		personIndexToApproved[_tokenId] = _to;
145 		emit Approval( msg.sender , _to , _tokenId );
146 	}
147 
148 	function balanceOf(address _owner) public view returns (uint256 balance) {
149 		return ownershipTokenCount[_owner];
150 	}
151 
152 	function createContractPerson( string _name , uint256 _price , address _owner ) public onlyCOO {
153 		if ( _price <= 0 ) {
154 			_price = startingPrice;
155 		}
156 		_createPerson( _name , _owner , _price );
157 	}
158 
159 	function getPerson(uint256 _tokenId) public view returns ( string personName, uint256 sellingPrice, address owner , uint256 sellingPriceNext , uint256 priceLevel ) {
160 		Person storage person = persons[_tokenId];
161 		personName 			= person.name;
162 		sellingPrice 		= personIndexToPrice[_tokenId];
163 		owner 				= personIndexToOwner[_tokenId];
164 		priceLevel 			= personIndexToPriceLevel[ _tokenId ];
165 		sellingPriceNext 	= _calcNextPrice( _tokenId );
166 	}
167 
168 	function _calcNextPrice( uint256 _tokenId ) private view returns ( uint256 nextSellingPrice ) {
169 		uint256 sellingPrice 	= priceOf( _tokenId );
170 		if( isPresale == true ){
171 			nextSellingPrice =  uint256( SafeMath.div( SafeMath.mul( sellingPrice, 400 ) , 100 ) );
172 		}else{
173 			if ( sellingPrice < firstStepLimit ) {
174 				nextSellingPrice =  uint256( SafeMath.div( SafeMath.mul( sellingPrice, 200 ) , 100 ) );
175 			} else if ( sellingPrice < secondStepLimit ) {
176 				nextSellingPrice =  uint256( SafeMath.div( SafeMath.mul( sellingPrice, 180 ) , 100 ) );
177 			} else if ( sellingPrice < thirdStepLimit ) {
178 				nextSellingPrice =  uint256( SafeMath.div( SafeMath.mul( sellingPrice, 160 ) , 100 ) );
179 			} else {
180 				nextSellingPrice  =  uint256( SafeMath.div( SafeMath.mul( sellingPrice, 140 ) , 100 ) );
181 			}
182 		}
183 		return nextSellingPrice;
184 	}
185 
186 	function implementsERC721() public pure returns (bool) {
187 		return true;
188 	}
189 
190 	function name() public pure returns (string) {
191 		return NAME;
192 	}
193 
194 	function ownerOf( uint256 _tokenId ) public view returns ( address owner ){
195 		owner = personIndexToOwner[_tokenId];
196 		require( owner != address(0) );
197 	}
198 
199 	function payout( address _to ) public onlyCLevel {
200 		_payout( _to );
201 	}
202 
203 	function purchase(uint256 _tokenId) public payable {
204 		address oldOwner 		= personIndexToOwner[_tokenId];
205 		address newOwner 		= msg.sender;
206 		uint256 sellingPrice 	= personIndexToPrice[_tokenId];
207 
208 		require( oldOwner != newOwner );
209 		require( _addressNotNull( newOwner ) );
210 		require( msg.value >= sellingPrice );
211 
212 		uint256 payment 		= uint256( SafeMath.div( SafeMath.mul( sellingPrice , 94 ) , 100 ) );
213 		uint256 purchaseExcess 	= SafeMath.sub( msg.value , sellingPrice );
214 
215 		if( isPresale == true ){
216 			require( personIndexToPriceLevel[ _tokenId ] == 0 );
217 		}
218 		personIndexToPrice[ _tokenId ] 		= _calcNextPrice( _tokenId );
219 		personIndexToPriceLevel[ _tokenId ] = SafeMath.add( personIndexToPriceLevel[ _tokenId ] , 1 );
220 
221 		_transfer( oldOwner , newOwner , _tokenId );
222 
223 		if ( oldOwner != address(this) ) {
224 			oldOwner.transfer( payment );
225 		}
226 
227 		msg.sender.transfer( purchaseExcess );
228 	}
229 
230 	function priceOf(uint256 _tokenId) public view returns (uint256 price) {
231 		return personIndexToPrice[_tokenId];
232 	}
233 
234 	function setCEO(address _newCEO) public onlyCEO {
235 		require(_newCEO != address(0));
236 		ceoAddress = _newCEO;
237 	}
238 
239 	function setCOO(address _newCOO) public onlyCEO {
240 		require(_newCOO != address(0));
241 		cooAddress = _newCOO;
242 	}
243 
244 	function symbol() public pure returns (string) {
245 		return SYMBOL;
246 	}
247 
248 	function takeOwnership(uint256 _tokenId) public {
249 		address newOwner = msg.sender;
250 		address oldOwner = personIndexToOwner[_tokenId];
251 		require(_addressNotNull(newOwner));
252 		require(_approved(newOwner, _tokenId));
253 		_transfer(oldOwner, newOwner, _tokenId);
254 	}
255 
256 	function tokensOfOwner(address _owner) public view returns( uint256[] ownerTokens ) {
257 		uint256 tokenCount = balanceOf(_owner);
258 		if (tokenCount == 0) {
259 			return new uint256[](0);
260 		} else {
261 			uint256[] memory result = new uint256[](tokenCount);
262 			uint256 totalPersons = totalSupply();
263 			uint256 resultIndex = 0;
264 			uint256 personId;
265 			for (personId = 0; personId <= totalPersons; personId++) {
266 				if (personIndexToOwner[personId] == _owner) {
267 					result[resultIndex] = personId;
268 					resultIndex++;
269 				}
270 			}
271 			return result;
272 		}
273 	}
274 
275 	function totalSupply() public view returns (uint256 total) {
276 		return persons.length;
277 	}
278 
279 	function transfer( address _to, uint256 _tokenId ) public {
280 		require( _owns(msg.sender, _tokenId ) );
281 		require( _addressNotNull( _to ) );
282 		_transfer( msg.sender, _to, _tokenId );
283 	}
284 
285 	function transferFrom( address _from, address _to, uint256 _tokenId ) public {
286 		require(_owns(_from, _tokenId));
287 		require(_approved(_to, _tokenId));
288 		require(_addressNotNull(_to));
289 		_transfer(_from, _to, _tokenId);
290 	}
291 
292 	function _addressNotNull(address _to) private pure returns (bool) {
293 		return _to != address(0);
294 	}
295 
296 	function _approved(address _to, uint256 _tokenId) private view returns (bool) {
297 		return personIndexToApproved[_tokenId] == _to;
298 	}
299 
300 	function _createPerson( string _name, address _owner, uint256 _price ) private {
301 		Person memory _person = Person({
302 			name: _name
303 		});
304 
305 		uint256 newPersonId = persons.push(_person) - 1;
306 		require(newPersonId == uint256(uint32(newPersonId)));
307 		personIndexToPrice[newPersonId] = _price;
308 		personIndexToPriceLevel[ newPersonId ] = 0;
309 		_transfer( address(0) , _owner, newPersonId);
310 	}
311 
312 	function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
313 		return claimant == personIndexToOwner[_tokenId];
314 	}
315 
316 	function _payout(address _to) private {
317 		if (_to == address(0)) {
318 			ceoAddress.transfer( address( this ).balance );
319 		} else {
320 			_to.transfer( address( this ).balance );
321 		}
322 	}
323 
324 	function _transfer(address _from, address _to, uint256 _tokenId) private {
325 		ownershipTokenCount[_to] = SafeMath.add( ownershipTokenCount[_to] , 1 );
326 		personIndexToOwner[_tokenId] = _to;
327 		if (_from != address(0)) {
328 			ownershipTokenCount[_from] = SafeMath.sub( ownershipTokenCount[_from] , 1 );
329 			delete personIndexToApproved[_tokenId];
330 		}
331 		emit Transfer(_from, _to, _tokenId);
332 	}
333 
334 }