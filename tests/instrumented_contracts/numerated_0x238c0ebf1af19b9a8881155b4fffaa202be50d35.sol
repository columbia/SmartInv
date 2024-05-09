1 pragma solidity ^0.5.2;
2 
3 interface ERC721TokenReceiver {
4 
5   /**
6    * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
7    * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
8    * of other than the magic value MUST result in the transaction being reverted.
9    * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
10    * @notice The contract address is always the message sender. A wallet/broker/auction application
11    * MUST implement the wallet interface if it will accept safe transfers.
12    * @param _operator The address which called `safeTransferFrom` function.
13    * @param _from The address which previously owned the token.
14    * @param _tokenId The NFT identifier which is being transferred.
15    * @param _data Additional data with no specified format.
16    */
17     function onERC721Received(
18         address _operator,
19         address _from,
20         uint256 _tokenId,
21         bytes calldata _data
22     ) external returns(bytes4);
23     
24 }
25 
26 contract ICOStickers {
27     using SafeMath for uint256;
28     using SafeMath for int256;
29     address constant internal NULL_ADDRESS = 0x0000000000000000000000000000000000000000;
30     
31     // ERC721 requires ERC165
32     mapping(bytes4 => bool) internal supportedInterfaces;
33     
34     // ERC721
35     address[] internal idToOwner;
36     address[] internal idToApprovals;
37     mapping (address => uint256) internal ownerToNFTokenCount;
38     mapping (address => mapping (address => bool)) internal ownerToOperators;
39     bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
40     
41     // ERC721Metadata
42     string constant public name = "0xchan ICO Stickers";
43     string constant public symbol = "ZCIS";
44     
45     // Custom
46     string constant internal uriStart = "https://0xchan.net/stickers/obj_properties/";
47     uint256[] public tokenProperty;
48     address[] public originalTokenOwner;
49     address internal badgeGiver;
50     address internal owner;
51     address internal newOwner;
52     
53     
54     // ERC721 Events
55     event Transfer(
56         address indexed _from,
57         address indexed _to,
58         uint256 indexed _tokenId
59     );
60     event Approval(
61         address indexed _owner,
62         address indexed _approved,
63         uint256 indexed _tokenId
64     );
65     event ApprovalForAll(
66         address indexed _owner,
67         address indexed _operator,
68         bool _approved
69     );
70     
71     modifier canOperate(uint256 _tokenId) {
72         address tokenOwner = idToOwner[_tokenId];
73         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
74         _;
75     }
76     
77     modifier canTransfer(uint256 _tokenId) {
78         address tokenOwner = idToOwner[_tokenId];
79         require(
80             tokenOwner == msg.sender
81             || getApproved(_tokenId) == msg.sender
82             || ownerToOperators[tokenOwner][msg.sender]
83         );
84         _;
85     }
86     
87     modifier validNFToken(uint256 _tokenId) {
88         require(idToOwner[_tokenId] != NULL_ADDRESS);
89         _;
90     }
91     
92     modifier onlyOwner {
93         require(msg.sender == owner);
94         _;
95     }
96     
97     modifier onlyBadgeGiver {
98         require(msg.sender == badgeGiver);
99         _;
100     }
101     
102     constructor() public {
103         supportedInterfaces[0x01ffc9a7] = true; // ERC165
104         supportedInterfaces[0x80ac58cd] = true; // ERC721
105         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
106         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
107         
108         owner = msg.sender;
109         badgeGiver = msg.sender;
110     }
111     
112     // Custom functions
113     function setNewOwner(address o) public onlyOwner {
114         newOwner = o;
115     }
116     
117     function acceptNewOwner() public {
118         require(msg.sender == newOwner);
119         owner = msg.sender;
120     }
121     
122     function revokeOwnership() public onlyOwner {
123         owner = NULL_ADDRESS;
124         newOwner = NULL_ADDRESS;
125     }
126     
127 	function setBadgeGiver(address g) public onlyOwner {
128 	    badgeGiver = g;
129 	}
130     
131     function giveSticker(address _to, uint256 _property) public onlyBadgeGiver {
132         require(_to != NULL_ADDRESS);
133         uint256 _tokenId = tokenProperty.length;
134         
135         idToOwner.length ++;
136         idToApprovals.length ++;
137         tokenProperty.length ++;
138         originalTokenOwner.length ++;
139         
140         addNFToken(_to, _tokenId);
141         tokenProperty[_tokenId] = _property;
142         originalTokenOwner[_tokenId] = _to;
143     
144         emit Transfer(NULL_ADDRESS, _to, _tokenId);
145     }
146     
147     // ERC721Enumerable functions
148     
149     function totalSupply() external view returns(uint256) {
150         return tokenProperty.length;
151     }
152     
153     function tokenOfOwnerByIndex(uint256 _tokenId) external view returns(address _owner) {
154         _owner = idToOwner[_tokenId];
155         require(_owner != NULL_ADDRESS);
156     }
157     
158     function tokenByIndex(uint256 _index) public view returns (uint256) {
159         require(_index < tokenProperty.length);
160         return _index;
161     }
162     
163     // ERC721Metadata functions
164     
165     function tokenURI(uint256 _tokenId) validNFToken(_tokenId) public view returns (string memory)
166     {
167         return concatStrings(uriStart, uint256ToString(_tokenId));
168     }
169     
170     // ERC721 functions
171     
172     function balanceOf(address _owner) external view returns(uint256) {
173         require(_owner != NULL_ADDRESS);
174         return ownerToNFTokenCount[_owner];
175     }
176     
177     function ownerOf(uint256 _tokenId) external view returns(address _owner){
178         _owner = idToOwner[_tokenId];
179         require(_owner != NULL_ADDRESS);
180     }
181     
182     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external {
183         _safeTransferFrom(_from, _to, _tokenId, _data);
184     }
185     
186     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
187         _safeTransferFrom(_from, _to, _tokenId, "");
188     }
189     
190     function supportsInterface(bytes4 _interfaceID) external view returns(bool) {
191         return supportedInterfaces[_interfaceID];
192     }
193     
194     function transferFrom(address _from, address _to, uint256 _tokenId) external canTransfer(_tokenId) validNFToken(_tokenId) {
195         address tokenOwner = idToOwner[_tokenId];
196         require(tokenOwner == _from);
197         require(_to != NULL_ADDRESS);
198         _transfer(_to, _tokenId);
199     }
200     
201     function approve(address _approved, uint256 _tokenId) external canOperate(_tokenId) validNFToken(_tokenId) {
202         address tokenOwner = idToOwner[_tokenId];
203         require(_approved != tokenOwner);
204         
205         idToApprovals[_tokenId] = _approved;
206         emit Approval(tokenOwner, _approved, _tokenId);
207     }
208     
209     function setApprovalForAll(address _operator, bool _approved) external {
210         require(_operator != NULL_ADDRESS);
211         ownerToOperators[msg.sender][_operator] = _approved;
212         emit ApprovalForAll(msg.sender, _operator, _approved);
213     }
214     
215     function getApproved(uint256 _tokenId) public view validNFToken(_tokenId) returns (address){
216         return idToApprovals[_tokenId];
217     }
218     
219     function isApprovedForAll(address _owner, address _operator) external view returns(bool) {
220         require(_owner != NULL_ADDRESS);
221         require(_operator != NULL_ADDRESS);
222         return ownerToOperators[_owner][_operator];
223     }
224     
225     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) internal canTransfer(_tokenId) validNFToken(_tokenId) {
226         address tokenOwner = idToOwner[_tokenId];
227         require(tokenOwner == _from);
228         require(_to != NULL_ADDRESS);
229         
230         _transfer(_to, _tokenId);
231         
232         if (isContract(_to)) {
233             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
234             require(retval == MAGIC_ON_ERC721_RECEIVED);
235         }
236     }
237     
238     function _transfer(address _to, uint256 _tokenId) private {
239         address from = idToOwner[_tokenId];
240         clearApproval(_tokenId);
241         removeNFToken(from, _tokenId);
242         addNFToken(_to, _tokenId);
243         emit Transfer(from, _to, _tokenId);
244     }
245     
246     function clearApproval(uint256 _tokenId) private {
247         if(idToApprovals[_tokenId] != NULL_ADDRESS){
248             delete idToApprovals[_tokenId];
249         }
250     }
251 
252     function removeNFToken(address _from, uint256 _tokenId) internal {
253         require(idToOwner[_tokenId] == _from);
254         assert(ownerToNFTokenCount[_from] > 0);
255         ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
256         delete idToOwner[_tokenId];
257     }
258 
259     function addNFToken(address _to, uint256 _tokenId) internal {
260         require(idToOwner[_tokenId] == NULL_ADDRESS);
261         idToOwner[_tokenId] = _to;
262         ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
263     }
264     
265     //If bytecode exists at _addr then the _addr is a contract.
266     function isContract(address _addr) internal view returns(bool) {
267         uint length;
268         assembly {
269             //retrieve the size of the code on target address, this needs assembly
270             length := extcodesize(_addr)
271         }
272         return (length>0);
273     }
274     
275     // Functions used for generating the URI
276     function amountOfZeros(uint256 num, uint256 base) public pure returns(uint256){
277         uint256 result = 0;
278         num /= base;
279         while (num > 0){
280             num /= base;
281             result += 1;
282         }
283         return result;
284     }
285     
286     function uint256ToString(uint256 num) public pure returns(string memory){
287         if (num == 0){
288             return "0";
289         }
290         uint256 numLen = amountOfZeros(num, 10) + 1;
291         bytes memory result = new bytes(numLen);
292         while(num != 0){
293             numLen -= 1;
294             result[numLen] = byte(uint8((num - (num / 10 * 10)) + 48));
295             num /= 10;
296         }
297         return string(result);
298     }
299     
300     function concatStrings(string memory str1, string memory str2) public pure returns (string memory){
301         uint256 str1Len = bytes(str1).length;
302         uint256 str2Len = bytes(str2).length;
303         uint256 resultLen = str1Len + str1Len;
304         bytes memory result = new bytes(resultLen);
305         uint256 i;
306         
307         for (i = 0; i < str1Len; i += 1){
308             result[i] = bytes(str1)[i];
309         }
310         for (i = 0; i < str2Len; i += 1){
311             result[i + str1Len] = bytes(str2)[i];
312         }
313         return string(result);
314     }
315 }
316 
317 /**
318  * @title SafeMath
319  * @dev Math operations with safety checks that throw on error
320  */
321 library SafeMath {
322     
323     /**
324     * @dev Multiplies two numbers, throws on overflow.
325     */
326     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
327         if (a == 0 || b == 0) {
328            return 0;
329         }
330         c = a * b;
331         assert(c / a == b);
332         return c;
333     }
334     
335     /**
336     * @dev Integer division of two numbers, truncating the quotient.
337     */
338     function div(uint256 a, uint256 b) internal pure returns(uint256) {
339         // assert(b > 0); // Solidity automatically throws when dividing by 0
340         // uint256 c = a / b;
341         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
342         return a / b;
343     }
344     
345     /**
346     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
347     */
348     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
349         assert(b <= a);
350         return a - b;
351     }
352     
353     /**
354     * @dev Adds two numbers, throws on overflow.
355     */
356     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
357         c = a + b;
358         assert(c >= a);
359         return c;
360     }
361     
362     /**
363     * @dev Subtracts two numbers, throws on underflow
364     */
365     function sub(int256 a, int256 b) internal pure returns(int256 c) {
366         c = a - b;
367         assert(c <= a);
368         return c;
369     }
370     
371     /**
372     * @dev Adds two numbers, throws on overflow.
373     */
374     function add(int256 a, int256 b) internal pure returns(int256 c) {
375         c = a + b;
376         assert(c >= a);
377         return c;
378     }
379 }