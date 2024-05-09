1 pragma solidity ^0.4.24;
2 
3 	library SafeMath {
4 
5 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6 		if (a == 0) {
7 		  return 0;
8 		}
9 
10 		c = a * b;
11 		assert(c / a == b);
12 		return c;
13 	  }
14 
15 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 		return a / b;
17 	  }
18 
19 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20 		assert(b <= a);
21 		return a - b;
22 	  }
23 
24 	  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25 		c = a + b;
26 		assert(c >= a);
27 		return c;
28 	  }
29 	}
30 	
31 	contract ReentrancyGuard {
32 
33 	uint256 private guardCounter = 1;
34 		modifier nonReentrant() {
35 			guardCounter += 1;
36 			uint256 localCounter = guardCounter;
37 			_;
38 			require(localCounter == guardCounter);
39 		}
40 
41 	}
42 	
43 	interface ERC165 {
44 	  function supportsInterface(bytes4 _interfaceId)
45 		external view	returns (bool);
46 	}
47 
48 	contract ERC721Receiver {
49 	  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
50 	  function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data)
51 		public returns(bytes4);
52 	}
53 
54 	library AddressUtils {
55 	  function isContract(address addr) internal view returns (bool) {
56 		uint256 size;
57 		assembly { size := extcodesize(addr) }
58 		return size > 0;
59 	  }
60 	}
61 
62 	contract Ownable {
63 	  address public owner;
64 
65 	  event OwnershipRenounced(address indexed previousOwner);
66 	  event OwnershipTransferred(
67 		address indexed previousOwner,
68 		address indexed newOwner
69 	  );
70 
71 	  constructor() public {
72 		owner = msg.sender;
73 	  }
74 
75 	  modifier onlyOwner() {
76 		require(msg.sender == owner);
77 		_;
78 	  }
79 
80 	  function renounceOwnership() public onlyOwner {
81 		emit OwnershipRenounced(owner);
82 		owner = address(0);
83 	  }
84 
85 	  function transferOwnership(address _newOwner) public onlyOwner {
86 		_transferOwnership(_newOwner);
87 	  }
88 
89 	  function _transferOwnership(address _newOwner) internal {
90 		require(_newOwner != address(0));
91 		emit OwnershipTransferred(owner, _newOwner);
92 		owner = _newOwner;
93 	  }
94 	}
95 
96 	contract SupportsInterfaceWithLookup is ERC165 {
97 	  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
98 
99 	  mapping(bytes4 => bool) internal supportedInterfaces;
100 
101 	  constructor() public {_registerInterface(InterfaceId_ERC165);}
102 
103 	  function supportsInterface(bytes4 _interfaceId)
104 		external view returns (bool) {return supportedInterfaces[_interfaceId];
105 	  }
106 
107 	  function _registerInterface(bytes4 _interfaceId) internal {
108 		require(_interfaceId != 0xffffffff);
109 		supportedInterfaces[_interfaceId] = true;
110 	  }
111 	}
112 
113 	contract ERC721Basic is ERC165 {
114 	  event Transfer(address indexed _from,	address indexed _to, uint256 indexed _tokenId);
115 	  event Approval(address indexed _owner, address indexed _approved,	uint256 indexed _tokenId);
116 	  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
117 
118 	  function balanceOf(address _owner) public view returns (uint256 _balance);
119 	  function ownerOf(uint256 _tokenId) public view returns (address _owner);
120 	  function exists(uint256 _tokenId) public view returns (bool _exists);
121 
122 	  function approve(address _to, uint256 _tokenId) public;
123 	  function getApproved(uint256 _tokenId)
124 		public view returns (address _operator);
125 
126 	  function setApprovalForAll(address _operator, bool _approved) public;
127 	  function isApprovedForAll(address _owner, address _operator) public view returns (bool);
128 
129 	  function transferFrom(address _from, address _to, uint256 _tokenId) public;
130 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId)	public;
131 
132 	  function safeTransferFrom(
133 		address _from, address _to,	uint256 _tokenId,	bytes _data)
134 		public;
135 	}
136 
137 	contract ERC721Enumerable is ERC721Basic {
138 	  function totalSupply() public view returns (uint256);
139 	  function tokenOfOwnerByIndex(address _owner, uint256 _index)
140 		public view	returns (uint256 _tokenId);
141 	  function tokenByIndex(uint256 _index) public view returns (uint256);
142 	}
143 
144 	contract ERC721Metadata is ERC721Basic {
145 	  function name() external view returns (string _name);
146 	  function symbol() external view returns (string _symbol);
147 	  function tokenURI(uint256 _tokenId) public view returns (string);
148 	}
149 
150 	contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {}
151 
152 	contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
153 
154 	  bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
155 	  bytes4 private constant InterfaceId_ERC721Exists = 0x4f558e79;
156 	  using SafeMath for uint256;
157 	  using AddressUtils for address;
158 	  bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
159 	  mapping (uint256 => address) internal tokenOwner;
160 	  mapping (uint256 => address) internal tokenApprovals;
161 	  mapping (address => uint256) internal ownedTokensCount;
162 	  mapping (address => mapping (address => bool)) internal operatorApprovals;
163 	  modifier onlyOwnerOf(uint256 _tokenId) {
164 		require(ownerOf(_tokenId) == msg.sender);
165 		_;
166 	  }
167 
168 	  modifier canTransfer(uint256 _tokenId) {
169 		require(isApprovedOrOwner(msg.sender, _tokenId));
170 		_;
171 	  }
172 
173 	  constructor() public {
174 		_registerInterface(InterfaceId_ERC721);
175 		_registerInterface(InterfaceId_ERC721Exists);
176 	  }
177 
178 	  function balanceOf(address _owner) public view returns (uint256) {
179 		require(_owner != address(0));
180 		return ownedTokensCount[_owner];
181 	  }
182 
183 	  function ownerOf(uint256 _tokenId) public view returns (address) {
184 		address owner = tokenOwner[_tokenId];
185 		require(owner != address(0));
186 		return owner;
187 	  }
188 
189 	  function exists(uint256 _tokenId) public view returns (bool) {
190 		address owner = tokenOwner[_tokenId];
191 		return owner != address(0);
192 	  }
193 
194 	  function approve(address _to, uint256 _tokenId) public {
195 		address owner = ownerOf(_tokenId);
196 		require(_to != owner);
197 		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
198 		tokenApprovals[_tokenId] = _to;
199 		emit Approval(owner, _to, _tokenId);
200 	  }
201 
202 	  function getApproved(uint256 _tokenId) public view returns (address) {
203 		return tokenApprovals[_tokenId];
204 	  }
205 
206 	  function setApprovalForAll(address _to, bool _approved) public {
207 		require(_to != msg.sender);
208 		operatorApprovals[msg.sender][_to] = _approved;
209 		emit ApprovalForAll(msg.sender, _to, _approved);
210 	  }
211 
212 	  function isApprovedForAll(address _owner,	address _operator)	public view	returns (bool)
213 	  {return operatorApprovals[_owner][_operator];
214     }
215 
216 	  function transferFrom(address _from, address _to,	uint256 _tokenId)	public canTransfer(_tokenId) {
217 		require(_from != address(0));
218 		require(_to != address(0));
219 		clearApproval(_from, _tokenId);
220 		removeTokenFrom(_from, _tokenId);
221 		addTokenTo(_to, _tokenId);
222 		emit Transfer(_from, _to, _tokenId);
223 	  }
224 
225 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
226 		safeTransferFrom(_from, _to, _tokenId, "");
227 	  }
228 
229 	  function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) public canTransfer(_tokenId) {
230 		transferFrom(_from, _to, _tokenId);
231 		require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
232 	  }
233 
234 	  function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
235 		address owner = ownerOf(_tokenId);
236 		return (
237 		  _spender == owner ||
238 		  getApproved(_tokenId) == _spender ||
239 		  isApprovedForAll(owner, _spender)
240 		);
241 	  }
242 
243 	  function _mint(address _to, uint256 _tokenId) internal {
244 		require(_to != address(0));
245 		addTokenTo(_to, _tokenId);
246 		emit Transfer(address(0), _to, _tokenId);
247 	  }
248 
249 	  function _burn(address _owner, uint256 _tokenId) internal {
250 		clearApproval(_owner, _tokenId);
251 		removeTokenFrom(_owner, _tokenId);
252 		emit Transfer(_owner, address(0), _tokenId);
253 	  }
254 
255 	  function clearApproval(address _owner, uint256 _tokenId) internal {
256 		require(ownerOf(_tokenId) == _owner);
257 		if (tokenApprovals[_tokenId] != address(0)) {
258 		  tokenApprovals[_tokenId] = address(0);
259 		}
260 	  }
261 
262 	  function addTokenTo(address _to, uint256 _tokenId) internal {
263 		require(tokenOwner[_tokenId] == address(0));
264 		tokenOwner[_tokenId] = _to;
265 		ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
266 	  }
267 
268 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
269 		require(ownerOf(_tokenId) == _from);
270 		ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
271 		tokenOwner[_tokenId] = address(0);
272 	  }
273 
274 	  function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool) {
275 		if (!_to.isContract()) {return true;
276     }
277 
278 		bytes4 retval = ERC721Receiver(_to).onERC721Received(
279 		msg.sender, _from, _tokenId, _data);
280 		return (retval == ERC721_RECEIVED);
281 	  }
282 	}
283 
284 	contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
285 
286 	  bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
287 	  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
288 	  string internal name_;
289 	  string internal symbol_;
290 	  mapping(address => uint256[]) internal ownedTokens;
291 	  mapping(uint256 => uint256) internal ownedTokensIndex;
292 	  uint256[] internal allTokens;
293 	  mapping(uint256 => uint256) internal allTokensIndex;
294 	  mapping(uint256 => string) internal tokenURIs;
295 
296 	  constructor(string _name, string _symbol) public {
297 		name_ = _name;
298 		symbol_ = _symbol;
299 		_registerInterface(InterfaceId_ERC721Enumerable);
300 		_registerInterface(InterfaceId_ERC721Metadata);
301 	  }
302 
303 	  function name() external view returns (string) {return name_;}
304 
305 	  function symbol() external view returns (string) {return symbol_;}
306 
307 	  function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
308       require(_index < balanceOf(_owner));
309       return ownedTokens[_owner][_index];
310 	  }
311 
312 	  function totalSupply() public view returns (uint256) {
313       return allTokens.length;
314 	  }
315 
316 	  function tokenByIndex(uint256 _index) public view returns (uint256) {
317       require(_index < totalSupply());
318       return allTokens[_index];
319 	  }
320 
321 	  function _setTokenURI(uint256 _tokenId, string _uri) internal {
322       require(exists(_tokenId));
323       tokenURIs[_tokenId] = _uri;
324 	  }
325 
326 	  function addTokenTo(address _to, uint256 _tokenId) internal {
327       super.addTokenTo(_to, _tokenId);
328       uint256 length = ownedTokens[_to].length;
329       ownedTokens[_to].push(_tokenId);
330       ownedTokensIndex[_tokenId] = length;
331 	  }
332 
333 	  function removeTokenFrom(address _from, uint256 _tokenId) internal {
334       super.removeTokenFrom(_from, _tokenId);
335       uint256 tokenIndex = ownedTokensIndex[_tokenId];
336       uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
337       uint256 lastToken = ownedTokens[_from][lastTokenIndex];
338       ownedTokens[_from][tokenIndex] = lastToken;
339       ownedTokens[_from][lastTokenIndex] = 0;
340       ownedTokens[_from].length--;
341       ownedTokensIndex[_tokenId] = 0;
342       ownedTokensIndex[lastToken] = tokenIndex;
343 	  }
344 
345 	  function _mint(address _to, uint256 _tokenId) internal {
346       super._mint(_to, _tokenId);
347       allTokensIndex[_tokenId] = allTokens.length;
348       allTokens.push(_tokenId);
349 	  }
350 
351 	  function _burn(address _owner, uint256 _tokenId) internal {
352       super._burn(_owner, _tokenId);
353       if (bytes(tokenURIs[_tokenId]).length != 0) {
354         delete tokenURIs[_tokenId];
355 		}
356 
357 		uint256 tokenIndex = allTokensIndex[_tokenId];
358 		uint256 lastTokenIndex = allTokens.length.sub(1);
359 		uint256 lastToken = allTokens[lastTokenIndex];
360 		allTokens[tokenIndex] = lastToken;
361 		allTokens[lastTokenIndex] = 0;
362 		allTokens.length--;
363 		allTokensIndex[_tokenId] = 0;
364 		allTokensIndex[lastToken] = tokenIndex;
365 	  }
366 	}
367 
368 	contract Buddies is ERC721Token, Ownable {
369 
370     constructor() ERC721Token("BlockTimeBuddies", "BTB") public {}
371 
372     // CONSTANTS
373     address client;
374     string host_chain = "bitchain";
375     address host_contract = 0x8a47D36907E51651d8996644ca1cAB525067Ca11;
376     uint256 max_supply = 1000000;
377     mapping(uint256 => uint256) tokenIDs; // Option for extended interoperability
378     bool interoperable = false; // [fully] interoperable = "true" uses input _ID in tokenIDs mapping, "false" uses index + 1
379     string baseurl = "https://api.blocktime.solutions/buddies/";
380 
381     function manageInterop(bool new_setting) public onlyOwner {
382       interoperable = new_setting;
383     }
384 
385     function viewInterop() public view returns (bool fully_interoperable) {
386       fully_interoperable = interoperable;
387     }
388 
389     function manageBaseURL(string new_baseurl) public onlyOwner {
390       baseurl = new_baseurl;
391     }
392 
393     function viewBaseURL() public view returns (string base_url) {
394       base_url = baseurl;
395     }
396 
397     function viewHost() public view returns (string h_chain, address h_contract) {
398       h_chain = host_chain;
399       h_contract = host_contract;
400     }
401 
402     event BoughtToken(address indexed buyer, uint256 tokenId);
403 
404     function moreSupply() internal view returns (bool moreOK) {
405       moreOK = true;
406       if (allTokens.length + 1 > max_supply) {moreOK = false;}
407       return moreOK;
408     }
409 
410     function mintToken (uint256 _ID) onlyOwner external {
411       uint256 index = allTokens.length + 1;
412       require(moreSupply() == true, "All allowed tokens have been created already!");
413       _mint(msg.sender, index);
414       {interoperable == true ? tokenIDs[index] = _ID : tokenIDs[index] = index;}
415       emit BoughtToken(msg.sender, index);
416     }
417 
418 	  function mintTokenForClient (uint256 _ID, address _client) onlyOwner external {
419       uint256 index = allTokens.length + 1;
420       require(moreSupply() == true, "All allowed tokens have been minted already!");
421       _mint(_client, index);
422       {interoperable == true ? tokenIDs[index] = _ID : tokenIDs[index] = index;}
423       emit BoughtToken(_client, index);
424 	  }
425 
426 	  function transferOwnTokens (uint256[] _ids, address _to) external {
427           uint256 n_tokens = _ids.length;
428           address _from = msg.sender;
429           require(_to != address(0));
430     
431           for (uint it = 0; it < n_tokens; it++) {
432             require(isApprovedOrOwner(msg.sender, _ids[it]));}	
433           for (uint i = 0; i < n_tokens; i++) {
434             clearApproval(_from, _ids[i]);
435             removeTokenFrom(_from, _ids[i]);
436             addTokenTo(_to, _ids[i]);
437             emit Transfer(_from, _to, _ids[i]);}
438 	  }
439 
440 	  function myTokens() external view returns (uint256[]) {
441   		return ownedTokens[msg.sender];
442 	  }
443 
444     function uintTostr(uint i) internal pure returns (string){
445       if (i == 0) return "0"; uint j = i; uint length;
446       while (j != 0){length++;j /= 10;} bytes memory bstr = new bytes(length); uint k = length - 1;
447       while (i != 0){bstr[k--] = byte(48 + i % 10);i /= 10;}
448       return string(bstr);
449     }
450 
451     function tokenURI(uint256 _ID) public view returns (string URI) {
452       require(exists(_ID));
453       URI = string(abi.encodePacked(baseurl, uintTostr(tokenIDs[_ID])));
454     }
455 
456     function nativeID(uint256 _ID) public view returns (uint hostID) {
457       require(exists(_ID));
458       hostID = tokenIDs[_ID];
459     }
460       
461     function checkBalance() external onlyOwner view returns (uint256 contractBalance) {
462 		  contractBalance = address(this).balance;
463 	  }
464     
465     function withdrawBalance() external onlyOwner {
466       owner.transfer(address(this).balance);
467     }
468 
469 }