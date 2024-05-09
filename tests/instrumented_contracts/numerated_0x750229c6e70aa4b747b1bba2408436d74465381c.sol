1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 
5   address public contractOwner;
6 
7   event ContractOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
10     contractOwner = msg.sender;
11   }
12 
13   modifier onlyContractOwner() {
14     require(msg.sender == contractOwner);
15     _;
16   }
17 
18   function transferContractOwnership(address _newOwner) public onlyContractOwner {
19     require(_newOwner != address(0));
20     ContractOwnershipTransferred(contractOwner, _newOwner);
21     contractOwner = _newOwner;
22   }
23   
24   function payoutFromContract() public onlyContractOwner {
25       contractOwner.transfer(this.balance);
26   }  
27 
28 }
29 
30 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
31 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
32 contract ERC721 {
33   // Required methods
34   function approve(address _to, uint256 _tokenId) public;
35   function balanceOf(address _owner) public view returns (uint256 balance);
36   function implementsERC721() public pure returns (bool);
37   function ownerOf(uint256 _tokenId) public view returns (address addr);
38   function takeOwnership(uint256 _tokenId) public;
39   function totalSupply() public view returns (uint256 total);
40   function transferFrom(address _from, address _to, uint256 _tokenId) public;
41   function transfer(address _to, uint256 _tokenId) public;
42 
43   event Transfer(address indexed from, address indexed to, uint256 tokenId);
44   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
45 
46   // Optional
47   // function name() public view returns (string name);
48   // function symbol() public view returns (string symbol);
49   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
50   // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
51   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
52 }
53 
54 contract CryptoCinema is ERC721, Ownable {
55 
56   event FilmCreated(uint256 tokenId, string name, address owner);
57   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
58   event Transfer(address from, address to, uint256 tokenId);
59 
60   string public constant NAME = "Film";
61   string public constant SYMBOL = "FilmToken";
62 
63   uint256 private startingPrice = 0.01 ether;
64 
65   mapping (uint256 => address) public filmIdToOwner;
66 
67   mapping (address => uint256) private ownershipTokenCount;
68 
69   mapping (uint256 => address) public filmIdToApproved;
70 
71   mapping (uint256 => uint256) private filmIdToPrice;
72 
73   /*** DATATYPES ***/
74   struct Film {
75     string name;
76   }
77 
78   Film[] private films;
79 
80   function approve(address _to, uint256 _tokenId) public { //ERC721
81     // Caller must own token.
82     require(_owns(msg.sender, _tokenId));
83     filmIdToApproved[_tokenId] = _to;
84     Approval(msg.sender, _to, _tokenId);
85   }
86 
87   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
88     return ownershipTokenCount[_owner];
89   }
90 
91   function createFilmToken(string _name, uint256 _price) public onlyContractOwner {
92     _createFilm(_name, msg.sender, _price);
93   }
94 
95   function create18FilmsTokens() public onlyContractOwner {
96      uint256 totalFilms = totalSupply();
97 	 
98 	 require (totalFilms<1); // only 3 tokens for start
99 	 
100 	 for (uint8 i=1; i<=18; i++)
101 		_createFilm("Film", address(this), startingPrice);
102 	
103   }
104   
105   function getFilm(uint256 _tokenId) public view returns (string filmName, uint256 sellingPrice, address owner) {
106     Film storage film = films[_tokenId];
107     filmName = film.name;
108     sellingPrice = filmIdToPrice[_tokenId];
109     owner = filmIdToOwner[_tokenId];
110   }
111 
112   function implementsERC721() public pure returns (bool) {
113     return true;
114   }
115 
116   function name() public pure returns (string) { //ERC721
117     return NAME;
118   }
119 
120   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
121     owner = filmIdToOwner[_tokenId];
122     require(owner != address(0));
123   }
124 
125   // Allows someone to send ether and obtain the token
126   function purchase(uint256 _tokenId) public payable {
127     address oldOwner = filmIdToOwner[_tokenId];
128     address newOwner = msg.sender;
129 
130     uint256 sellingPrice = filmIdToPrice[_tokenId];
131 
132     require(oldOwner != newOwner);
133     require(_addressNotNull(newOwner));
134     require(msg.value >= sellingPrice);
135 
136     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100)); //97% to previous owner
137 
138 	
139     // The price increases by 20% 
140     filmIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 12), 10)); 
141 
142     _transfer(oldOwner, newOwner, _tokenId);
143 
144     // Pay previous tokenOwner if owner is not contract
145     if (oldOwner != address(this)) {
146       oldOwner.transfer(payment); //
147     }
148 
149     TokenSold(_tokenId, sellingPrice, filmIdToPrice[_tokenId], oldOwner, newOwner, films[_tokenId].name);
150 	
151     if (msg.value > sellingPrice) { //if excess pay
152 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
153 		msg.sender.transfer(purchaseExcess);
154 	}
155   }
156   
157   function symbol() public pure returns (string) { //ERC721
158     return SYMBOL;
159   }
160 
161   function takeOwnership(uint256 _tokenId) public { //ERC721
162     address newOwner = msg.sender;
163     address oldOwner = filmIdToOwner[_tokenId];
164 
165     require(_addressNotNull(newOwner));
166     require(_approved(newOwner, _tokenId));
167 
168     _transfer(oldOwner, newOwner, _tokenId);
169   }
170 
171   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
172     return filmIdToPrice[_tokenId];
173   }
174 
175   function allFilmsInfo(uint256 _startFilmId) public view returns (address[] owners, uint256[] prices) { //for web site view
176 	
177 	uint256 totalFilms = totalSupply();
178 	
179     if (totalFilms == 0 || _startFilmId >= totalFilms) {
180         // Return an empty array
181       return (new address[](0), new uint256[](0));
182     }
183 	
184 	uint256 indexTo;
185 	if (totalFilms > _startFilmId+1000)
186 		indexTo = _startFilmId + 1000;
187 	else 	
188 		indexTo = totalFilms;
189 		
190     uint256 totalResultFilms = indexTo - _startFilmId;		
191 		
192 	address[] memory owners_res = new address[](totalResultFilms);
193 	uint256[] memory prices_res = new uint256[](totalResultFilms);
194 	
195 	for (uint256 filmId = _startFilmId; filmId < indexTo; filmId++) {
196 	  owners_res[filmId - _startFilmId] = filmIdToOwner[filmId];
197 	  prices_res[filmId - _startFilmId] = filmIdToPrice[filmId];
198 	}
199 	
200 	return (owners_res, prices_res);
201   }
202   
203   function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view
204     uint256 tokenCount = balanceOf(_owner);
205     if (tokenCount == 0) {
206         // Return an empty array
207       return new uint256[](0);
208     } else {
209       uint256[] memory result = new uint256[](tokenCount);
210       uint256 totalFilms = totalSupply();
211       uint256 resultIndex = 0;
212 
213       uint256 filmId;
214       for (filmId = 0; filmId <= totalFilms; filmId++) {
215         if (filmIdToOwner[filmId] == _owner) {
216           result[resultIndex] = filmId;
217           resultIndex++;
218         }
219       }
220       return result;
221     }
222   }
223 
224   function totalSupply() public view returns (uint256 total) { //ERC721
225     return films.length;
226   }
227 
228   function transfer(address _to, uint256 _tokenId) public { //ERC721
229     require(_owns(msg.sender, _tokenId));
230     require(_addressNotNull(_to));
231 
232 	_transfer(msg.sender, _to, _tokenId);
233   }
234 
235   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
236     require(_owns(_from, _tokenId));
237     require(_approved(_to, _tokenId));
238     require(_addressNotNull(_to));
239 
240     _transfer(_from, _to, _tokenId);
241   }
242 
243 
244   /* PRIVATE FUNCTIONS */
245   function _addressNotNull(address _to) private pure returns (bool) {
246     return _to != address(0);
247   }
248 
249   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
250     return filmIdToApproved[_tokenId] == _to;
251   }
252 
253   function _createFilm(string _name, address _owner, uint256 _price) private {
254     Film memory _film = Film({
255       name: _name
256     });
257     uint256 newFilmId = films.push(_film) - 1;
258 
259     require(newFilmId == uint256(uint32(newFilmId))); //check maximum limit of tokens
260 
261     FilmCreated(newFilmId, _name, _owner);
262 
263     filmIdToPrice[newFilmId] = _price;
264 
265     _transfer(address(0), _owner, newFilmId);
266   }
267 
268   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
269     return _checkedAddr == filmIdToOwner[_tokenId];
270   }
271 
272 function _transfer(address _from, address _to, uint256 _tokenId) private {
273     ownershipTokenCount[_to]++;
274     filmIdToOwner[_tokenId] = _to;
275 
276     // When creating new films _from is 0x0, but we can't account that address.
277     if (_from != address(0)) {
278       ownershipTokenCount[_from]--;
279       // clear any previously approved ownership exchange
280       delete filmIdToApproved[_tokenId];
281     }
282 
283     // Emit the transfer event.
284     Transfer(_from, _to, _tokenId);
285   }
286 }
287 
288 library SafeMath {
289 
290   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291     if (a == 0) {
292       return 0;
293     }
294     uint256 c = a * b;
295     assert(c / a == b);
296     return c;
297   }
298 
299   function div(uint256 a, uint256 b) internal pure returns (uint256) {
300     // assert(b > 0); // Solidity automatically throws when dividing by 0
301     uint256 c = a / b;
302     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303     return c;
304   }
305 
306   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
307     assert(b <= a);
308     return a - b;
309   }
310 
311   function add(uint256 a, uint256 b) internal pure returns (uint256) {
312     uint256 c = a + b;
313     assert(c >= a);
314     return c;
315   }
316 }