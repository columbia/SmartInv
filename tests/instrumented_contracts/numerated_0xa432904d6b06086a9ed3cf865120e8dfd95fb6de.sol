1 pragma solidity 0.5.4;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address tokenOwner) external view returns (uint balance);
6     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
7     function transfer(address to, uint tokens) external returns (bool success);
8     function approve(address spender, uint tokens) external returns (bool success);
9     function transferFrom(address from, address to, uint tokens) external returns (bool success);
10 }
11 
12 interface IERC721 {
13 
14     function ownerOf(uint256 _tokenId) external view returns (address);
15 
16     function transferFrom(address _from, address _to, uint256 _tokenId) external;
17 
18     function approve(address _approved, uint256 _tokenId) external;
19 
20 
21     function setApprovalForAll(address _operator, bool _approved) external;
22 
23     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
24 
25     function getApproved(uint256 _tokenId) external view returns (address);
26 
27     function balanceOf(address _owner) external view returns (uint256);
28 
29 
30     function tokenURI(uint256 _tokenId) external view returns (string memory);
31 
32     function baseTokenURI() external view returns (string memory);
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
35     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
36     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
37 
38 
39 }
40 
41 library Strings {
42     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
43     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
44         bytes memory _ba = bytes(_a);
45         bytes memory _bb = bytes(_b);
46         bytes memory _bc = bytes(_c);
47         bytes memory _bd = bytes(_d);
48         bytes memory _be = bytes(_e);
49         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
50         bytes memory babcde = bytes(abcde);
51         uint k = 0;
52         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
53         for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
54         for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
55         for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
56         for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
57         return string(babcde);
58     }
59 
60     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
61         return strConcat(_a, _b, _c, _d, "");
62     }
63 
64     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
65         return strConcat(_a, _b, _c, "", "");
66     }
67 
68     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
69         return strConcat(_a, _b, "", "", "");
70     }
71 
72     function uint2str(uint i) internal pure returns (string memory) {
73         if (i == 0) return "0";
74         uint j = i;
75         uint len;
76         while (j != 0) {
77             len++;
78             j /= 10;
79         }
80         bytes memory bstr = new bytes(len);
81         uint k = len - 1;
82         while (i != 0) {
83             bstr[k--] = byte(uint8(48 + i % 10));
84             i /= 10;
85         }
86         return string(bstr);
87     }
88 
89     function bytes32ToString(bytes32 x) internal pure returns (string memory) {
90         bytes memory bytesString = new bytes(32);
91         uint charCount = 0;
92         for (uint j = 0; j < 32; j++) {
93             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
94             if (char != 0) {
95                 bytesString[charCount] = char;
96                 charCount++;
97             }
98         }
99         bytes memory bytesStringTrimmed = new bytes(charCount);
100         for (uint j = 0; j < charCount; j++) {
101             bytesStringTrimmed[j] = bytesString[j];
102         }
103         return string(bytesStringTrimmed);
104     }
105 
106 }
107 
108 /**
109  * @title Ownable
110  * @dev The Ownable contract has an owner address, and provides basic authorization control
111  * functions, this simplifies the implementation of "user permissions".
112  */
113 contract Ownable {
114     address public owner;
115     address public secondary;
116 
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
122      * account.
123      */
124     constructor(address _secondary) public {
125         owner = msg.sender;
126         secondary = _secondary != address(0) ? _secondary : msg.sender;
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         require(msg.sender == owner, "Only owner");
134         _;
135     }
136 
137     modifier onlyOwnerOrSecondary() {
138         require(msg.sender == owner || msg.sender == secondary, "Only owner or secondary");
139         _;
140     }
141 
142     /**
143      * @dev Allows the current owner to transfer control of the contract to a newOwner.
144      * @param newOwner The address to transfer ownership to.
145      */
146     function transferOwnership(address newOwner) public onlyOwner {
147         require(newOwner != address(0), "Transfer to null address is not allowed");
148         emit OwnershipTransferred(owner, newOwner);
149         owner = newOwner;
150     }
151 
152     function setSecondary(address _secondary) public onlyOwner {
153         secondary = _secondary;
154     }
155 
156 }
157 
158 contract Beneficiary is Ownable {
159 
160     address payable public beneficiary;
161 
162     constructor(address _secondary) public Ownable(_secondary) {
163         beneficiary = msg.sender;
164     }
165 
166     function setBeneficiary(address payable _beneficiary) public onlyOwner {
167         beneficiary = _beneficiary;
168     }
169 
170     function withdrawal(uint256 value) public onlyOwner {
171         if (value > address(this).balance) {
172             revert("Insufficient balance");
173         }
174 
175         beneficiaryPayout(value);
176     }
177 
178     function withdrawalAll() public onlyOwner {
179         beneficiaryPayout(address(this).balance);
180     }
181 
182     function withdrawERC20Token(address payable _erc20, uint value) public onlyOwner {
183         require(IERC20(_erc20).transfer(beneficiary, value));
184         emit BeneficiaryERC20Payout(_erc20, value);
185     }
186 
187     function beneficiaryPayout(uint256 value) internal {
188         beneficiary.transfer(value);
189         emit BeneficiaryPayout(value);
190     }
191 
192     function beneficiaryERC20Payout(IERC20 _erc20, uint256 value) internal {
193         _erc20.transfer(beneficiary, value);
194         emit BeneficiaryERC20Payout(address(_erc20), value);
195     }
196 
197     event BeneficiaryPayout(uint256 value);
198     event BeneficiaryERC20Payout(address tokenAddress, uint256 value);
199 }
200 
201 contract Manageable is Beneficiary {
202 
203     uint256 DECIMALS = 10e8;
204 
205     bool maintenance = false;
206 
207     mapping(address => bool) public managers;
208 
209     modifier onlyManager() {
210 
211         require(managers[msg.sender] || msg.sender == address(this), "Only managers allowed");
212         _;
213     }
214 
215     modifier notOnMaintenance() {
216         require(!maintenance);
217         _;
218     }
219 
220     constructor(address _secondary) public  Beneficiary(_secondary) {
221         managers[msg.sender] = true;
222     }
223 
224     function setMaintenanceStatus(bool _status) public onlyManager {
225         maintenance = _status;
226         emit Maintenance(_status);
227     }
228 
229     function setManager(address _manager) public onlyOwnerOrSecondary {
230         managers[_manager] = true;
231     }
232 
233     function deleteManager(address _manager) public onlyOwnerOrSecondary {
234         delete managers[_manager];
235     }
236 
237     event Maintenance(bool status);
238 
239     event FailedPayout(address to, uint256 value);
240 
241 }
242 
243 contract LockableToken is Manageable {
244     mapping(uint256 => bool) public locks;
245 
246     modifier onlyNotLocked(uint256 _tokenId) {
247         require(!locks[_tokenId]);
248         _;
249     }
250 
251     function isLocked(uint256 _tokenId) public view returns (bool) {
252         return locks[_tokenId];
253     }
254 
255     function lockToken(uint256 _tokenId) public onlyManager {
256         locks[_tokenId] = true;
257     }
258 
259     function unlockToken(uint256 _tokenId) public onlyManager {
260         locks[_tokenId] = false;
261     }
262 
263     function _lockToken(uint256 _tokenId) internal {
264         locks[_tokenId] = true;
265     }
266 
267     function _unlockToken(uint256 _tokenId) internal {
268         locks[_tokenId] = false;
269     }
270 
271 }
272 
273 contract ERC721 is Manageable, LockableToken, IERC721 {
274 
275     using Strings for string;
276 
277     mapping(address => uint256) public balances;
278     mapping(uint256 => address) public approved;
279     mapping(address => mapping(address => bool)) private operators;
280     mapping(uint256 => address) private tokenOwner;
281 
282     uint256 public totalSupply = 0;
283 
284     string private _tokenURI = "";
285 
286     modifier onlyTokenOwner(uint256 _tokenId) {
287         require(msg.sender == tokenOwner[_tokenId]);
288         _;
289     }
290 
291     function setBaseTokenURI(string memory _newTokenURI) public onlyManager {
292         _tokenURI = _newTokenURI;
293     }
294 
295     function ownerOf(uint256 _tokenId) public view returns (address) {
296         return tokenOwner[_tokenId];
297     }
298 
299     function transferFrom(address _from, address _to, uint256 _tokenId) public onlyNotLocked(_tokenId) {
300         require(_isApprovedOrOwner(msg.sender, _tokenId));
301 
302         _transfer(_from, _to, _tokenId);
303     }
304 
305     function approve(address _approved, uint256 _tokenId) public onlyNotLocked(_tokenId)  {
306         address owner = ownerOf(_tokenId);
307         require(_approved != owner);
308         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
309 
310         approved[_tokenId] = _approved;
311 
312         emit Approval(owner, _approved, _tokenId);
313     }
314 
315 
316     function setApprovalForAll(address _operator, bool _approved) public {
317         require(_operator != msg.sender);
318 
319         operators[msg.sender][_operator] = _approved;
320         emit ApprovalForAll(msg.sender, _operator, _approved);
321     }
322 
323     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
324         return operators[_owner][_operator];
325     }
326 
327     function getApproved(uint256 _tokenId) public view returns (address) {
328         return approved[_tokenId];
329     }
330 
331     function balanceOf(address _owner) public view returns (uint256) {
332         return balances[_owner];
333     }
334 
335 
336     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
337         address owner = ownerOf(tokenId);
338         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
339     }
340 
341     function transfer(address  _from, address  _to, uint256 _tokenId) public onlyTokenOwner(_tokenId) onlyNotLocked(_tokenId) {
342         _transfer(_from, _to, _tokenId);
343     }
344 
345     function _transfer(address  _from, address  _to, uint256 _tokenId) internal {
346         require(ownerOf(_tokenId) == _from);
347 
348         delete approved[_tokenId];
349 
350         if(_from != address(0)) {
351             balances[_from]--;
352         } else {
353             totalSupply++;
354         }
355 
356         if(_to != address(0)) {
357             balances[_to]++;
358         }
359 
360         tokenOwner[_tokenId] = _to;
361 
362         emit Transfer(_from, _to, _tokenId);
363     }
364 
365     function _mint(uint256 _tokenId, address _owner) internal {
366         _transfer(address(0), _owner, _tokenId);
367     }
368 
369     function _burn(uint256 _tokenId) internal {
370         _transfer(ownerOf(_tokenId), address(0), _tokenId);
371     }
372 
373 
374     function baseTokenURI() public view returns (string memory) {
375         return _tokenURI;
376     }
377 
378     function tokenURI(uint256 _tokenId) external view returns (string memory) {
379         return Strings.strConcat(
380             baseTokenURI(),
381             Strings.uint2str(_tokenId)
382         );
383     }
384 
385 
386     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
387     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
388     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
389 
390 
391 }
392 
393 
394 
395 contract Citizen is Manageable, ERC721 {
396 
397     struct Token {
398         uint8[7] special;
399         uint8 generation;
400         bytes32 look;
401     }
402 
403     Token[] public tokens;
404 
405     constructor(address _secondary) public Manageable(_secondary) {}
406 
407     function mint(address _owner, uint8[7] memory _special, uint8 _generation, bytes32 _look) public onlyManager returns (uint256){
408         tokens.push(Token(_special, _generation, _look));
409         _mint(tokens.length - 1, _owner);
410         return tokens.length - 1;
411     }
412 
413     function incSpecial(uint256 _tokenId, uint8 _specId) public onlyManager {
414         require(_specId < 8 && tokens[_tokenId].special[_specId] < 12);
415 
416         emit SpecChanged(_tokenId, _specId, tokens[_tokenId].special[_specId]);
417     }
418 
419     function decSpecial(uint256 _tokenId, uint8 _specId) public onlyManager {
420         require(_specId < 8 && tokens[_tokenId].special[_specId] > 0);
421 
422         tokens[_tokenId].special[_specId]--;
423         emit SpecChanged(_tokenId, _specId, tokens[_tokenId].special[_specId]);
424     }
425 
426     function getSpecial(uint256 _tokenId) public view returns (uint8[7] memory) {
427         return tokens[_tokenId].special;
428     }
429 
430     function setLook(uint256 _tokenId, bytes32 _look) public onlyManager {
431         tokens[_tokenId].look = _look;
432     }
433 
434     function burn(uint256 _tokenId) public onlyManager {
435         _burn(_tokenId);
436     }
437 
438 
439     event SpecChanged(uint256 _tokenId, uint8 _specId, uint8 _value);
440 
441 }