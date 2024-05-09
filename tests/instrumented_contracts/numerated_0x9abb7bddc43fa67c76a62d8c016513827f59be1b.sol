1 // SPDX-License-Identifier: This smart contract is guarded by an angry ghost
2 pragma solidity ^0.8.0;
3 
4 
5 contract POWNFTv3{
6 
7     //v2 Variables
8     uint public UNMIGRATED = 0;
9     uint public V2_TOTAL = 0;
10     bytes32 public PREV_CHAIN_LAST_HASH;
11     POWNFTv2 CONTRACT_V2;
12 
13     constructor(address contract_v2){
14         supportedInterfaces[0x80ac58cd] = true; //ERC721
15         supportedInterfaces[0x5b5e139f] = true; //ERC721Metadata
16         supportedInterfaces[0x780e9d63] = true; //ERC721Enumerable
17         supportedInterfaces[0x01ffc9a7] = true; //ERC165
18 
19         CONTRACT_V2 = POWNFTv2(contract_v2);
20         V2_TOTAL =
21         UNMIGRATED = CONTRACT_V2.totalSupply();
22         PREV_CHAIN_LAST_HASH = CONTRACT_V2.hashOf(UNMIGRATED);
23 
24     }
25 
26 
27     //////===721 Standard
28     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
29     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
30     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
31 
32     //////===721 Implementation
33     mapping(address => uint256) internal BALANCES;
34     mapping (uint256 => address) internal ALLOWANCE;
35     mapping (address => mapping (address => bool)) internal AUTHORISED;
36 
37     bytes32[] TOKENS;  //Array of all tokens [hash,hash,...]
38     mapping(uint256 => address) OWNERS;  //Mapping of owners
39 
40 
41     //    METADATA VARS
42     string private __name = "POW NFT";
43     string private __symbol = "POW";
44     bytes private __uriBase = bytes("https://www.pownftmetadata.com/t/");
45 
46 
47     //    ENUMERABLE VARS
48     mapping(address => uint[]) internal OWNER_INDEX_TO_ID;
49     mapping(uint => uint) internal OWNER_ID_TO_INDEX;
50     mapping(uint => uint) internal ID_TO_INDEX;
51     mapping(uint => uint) internal INDEX_TO_ID;
52 
53 
54     //ETH VAR
55     mapping(uint256 => uint256) WITHDRAWALS;
56 
57 
58     //      MINING VARS
59     uint BASE_COST = 0.000045 ether;
60     uint BASE_DIFFICULTY = uint(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)/uint(300);
61     uint DIFFICULTY_RAMP = 3;
62 
63 
64     event Migrate(uint indexed _tokenId);
65 
66     //      MINING EVENTS
67     event Mined(uint indexed _tokenId, bytes32 hash);
68     event Withdraw(uint indexed _tokenId, uint value);
69 
70     //      MINING FUNCTIONS
71     function generationOf(uint _tokenId) private pure returns(uint generation){
72         for(generation = 0; _tokenId > 0; generation++){
73             _tokenId /= 2;
74         }
75         return generation - 1;
76     }
77     function hashOf(uint _tokenId) public view returns(bytes32){
78         require(isValidToken(_tokenId),"invalid");
79         return TOKENS[ID_TO_INDEX[_tokenId]];
80     }
81 
82 
83     function migrate(uint _tokenId,uint _withdrawEthUntil) public {
84             _migrate(_tokenId);
85             if(_withdrawEthUntil > 0){
86                 withdraw(_tokenId, _withdrawEthUntil);
87             }
88     }
89     function _migrate(uint _tokenId) internal {
90         //require not migrated
91         require(!isValidToken(_tokenId),'is_migrated');
92 
93         //Require before snapshot
94         require(_tokenId <= V2_TOTAL,'forgery');
95 
96         //require owner on original contract
97         require(CONTRACT_V2.ownerOf(_tokenId) == msg.sender,'owner');
98         //mint the token with hash from prev contract
99         UNMIGRATED--;
100         mint(_tokenId,
101             CONTRACT_V2.hashOf(_tokenId)
102         );
103         emit Migrate(_tokenId);
104     }
105     function migrateMultiple(uint[] calldata _tokenIds, uint[] calldata _withdrawUntil) public {
106         for(uint i = 0; i < _tokenIds.length; i++){
107             _migrate(_tokenIds[i]);
108         }
109         withdrawMultiple(_tokenIds,_withdrawUntil);
110     }
111 
112 
113 
114     function withdraw(uint _tokenId, uint _withdrawUntil) public {
115         payable(msg.sender).transfer(
116             _withdraw(_tokenId, _withdrawUntil)
117         );
118     }
119     function _withdraw(uint _tokenId, uint _withdrawUntil) internal returns(uint){
120         require(isValidToken(_withdrawUntil),'withdrawUntil_exist');
121 
122         require(ownerOf(_tokenId) == msg.sender,"owner");
123         require(_withdrawUntil > WITHDRAWALS[_tokenId],'withdrawn');
124 
125         uint generation = generationOf(_tokenId);
126         uint firstPayable = 2**(generation+1);
127 
128         uint withdrawFrom = WITHDRAWALS[_tokenId];
129         if(withdrawFrom < _tokenId){
130             withdrawFrom = _tokenId;
131 
132             //withdraw from if _tokenId < number brought over
133             if(withdrawFrom < V2_TOTAL){
134                 withdrawFrom = V2_TOTAL;
135             }
136             if(withdrawFrom < firstPayable){
137                 withdrawFrom = firstPayable - 1;
138             }
139         }
140 
141         require(_withdrawUntil > withdrawFrom,'underflow');
142 
143         uint payout = BASE_COST * (_withdrawUntil - withdrawFrom);
144 
145         WITHDRAWALS[_tokenId] = _withdrawUntil;
146 
147         emit Withdraw(_tokenId,payout);
148 
149         return payout;
150     }
151 
152     function withdrawMultiple(uint[] calldata _tokenIds, uint[] calldata _withdrawUntil) public{
153         uint payout = 0;
154         for(uint i = 0; i < _tokenIds.length; i++){
155             if(_withdrawUntil[i] > 0){
156                 payout += _withdraw(_tokenIds[i],_withdrawUntil[i]);
157             }
158         }
159         payable(msg.sender).transfer(payout);
160     }
161 
162     function mine(uint nonce) external payable{
163         uint tokenId = UNMIGRATED + TOKENS.length + 1;
164         uint generation = generationOf(tokenId);
165 
166         uint difficulty = BASE_DIFFICULTY / (DIFFICULTY_RAMP**generation);
167         if(generation > 13){ //Token 16384
168             difficulty /= (tokenId - 2**14 + 1);
169         }
170 
171         uint cost = (2**generation - 1)* BASE_COST;
172 
173 
174         bytes32 hash;
175         if(V2_TOTAL - UNMIGRATED != TOKENS.length){
176             hash = keccak256(abi.encodePacked(
177                     msg.sender,
178                     TOKENS[ID_TO_INDEX[tokenId-1]],
179                     nonce
180                 ));
181         }else{
182 //            First mine on new contract
183             hash = keccak256(abi.encodePacked(
184                         msg.sender,
185                         PREV_CHAIN_LAST_HASH,
186                     nonce
187                 ));
188         }
189 
190 
191         require(uint(hash) < difficulty,"difficulty");
192         require(msg.value ==cost,"cost");
193 
194         hash = keccak256(abi.encodePacked(hash,block.timestamp));
195 
196         mint(tokenId, hash);
197 
198         emit Mined(tokenId,hash);
199     }
200 
201     function mint(uint tokenId, bytes32 hash) private{
202         OWNERS[tokenId] = msg.sender;
203         BALANCES[msg.sender]++;
204         OWNER_ID_TO_INDEX[tokenId] = OWNER_INDEX_TO_ID[msg.sender].length;
205         OWNER_INDEX_TO_ID[msg.sender].push(tokenId);
206 
207         ID_TO_INDEX[tokenId] = TOKENS.length;
208         INDEX_TO_ID[TOKENS.length] = tokenId;
209         TOKENS.push(hash);
210 
211         emit Transfer(address(0),msg.sender,tokenId);
212     }
213 
214 
215     function isValidToken(uint256 _tokenId) internal view returns(bool){
216         return OWNERS[_tokenId] != address(0);
217     }
218 
219     function balanceOf(address _owner) external view returns (uint256){
220         return BALANCES[_owner];
221     }
222 
223     function ownerOf(uint256 _tokenId) public view returns(address){
224         require(isValidToken(_tokenId),"invalid");
225         return OWNERS[_tokenId];
226     }
227 
228 
229     function approve(address _approved, uint256 _tokenId)  external{
230         address owner = ownerOf(_tokenId);
231         require( owner == msg.sender                    //Require Sender Owns Token
232             || AUTHORISED[owner][msg.sender]                //  or is approved for all.
233         ,"permission");
234         emit Approval(owner, _approved, _tokenId);
235         ALLOWANCE[_tokenId] = _approved;
236     }
237 
238     function getApproved(uint256 _tokenId) external view returns (address) {
239         require(isValidToken(_tokenId),"invalid");
240         return ALLOWANCE[_tokenId];
241     }
242 
243     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
244         return AUTHORISED[_owner][_operator];
245     }
246 
247 
248     function setApprovalForAll(address _operator, bool _approved) external {
249         emit ApprovalForAll(msg.sender,_operator, _approved);
250         AUTHORISED[msg.sender][_operator] = _approved;
251     }
252 
253 
254     function transferFrom(address _from, address _to, uint256 _tokenId) public {
255 
256         //Check Transferable
257         //There is a token validity check in ownerOf
258         address owner = ownerOf(_tokenId);
259 
260         require ( owner == msg.sender             //Require sender owns token
261         //Doing the two below manually instead of referring to the external methods saves gas
262         || ALLOWANCE[_tokenId] == msg.sender      //or is approved for this token
263             || AUTHORISED[owner][msg.sender]          //or is approved for all
264         ,"permission");
265         require(owner == _from,"owner");
266         require(_to != address(0),"zero");
267 
268         emit Transfer(_from, _to, _tokenId);
269 
270 
271         OWNERS[_tokenId] =_to;
272 
273         BALANCES[_from]--;
274         BALANCES[_to]++;
275 
276         //Reset approved if there is one
277         if(ALLOWANCE[_tokenId] != address(0)){
278             delete ALLOWANCE[_tokenId];
279         }
280 
281         //Enumerable Additions
282         uint oldIndex = OWNER_ID_TO_INDEX[_tokenId];
283         //If the token isn't the last one in the owner's index
284         if(oldIndex != OWNER_INDEX_TO_ID[_from].length - 1){
285             //Move the old one in the index list
286             OWNER_INDEX_TO_ID[_from][oldIndex] = OWNER_INDEX_TO_ID[_from][OWNER_INDEX_TO_ID[_from].length - 1];
287             //Update the token's reference to its place in the index list
288             OWNER_ID_TO_INDEX[OWNER_INDEX_TO_ID[_from][oldIndex]] = oldIndex;
289         }
290         OWNER_INDEX_TO_ID[_from].pop();
291 
292         OWNER_ID_TO_INDEX[_tokenId] = OWNER_INDEX_TO_ID[_to].length;
293         OWNER_INDEX_TO_ID[_to].push(_tokenId);
294 
295     }
296 
297     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {
298         transferFrom(_from, _to, _tokenId);
299 
300         //Get size of "_to" address, if 0 it's a wallet
301         uint32 size;
302         assembly {
303             size := extcodesize(_to)
304         }
305         if(size > 0){
306             ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);
307             require(receiver.onERC721Received(msg.sender,_from,_tokenId,data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),"receiver");
308         }
309 
310     }
311 
312     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
313         safeTransferFrom(_from,_to,_tokenId,"");
314     }
315 
316 
317     // METADATA FUNCTIONS
318     function tokenURI(uint256 _tokenId) public view returns (string memory){
319         //Note: changed visibility to public
320         require(isValidToken(_tokenId),'tokenId');
321 
322         uint _i = _tokenId;
323         uint j = _i;
324         uint len;
325         while (j != 0) {
326             len++;
327             j /= 10;
328         }
329         bytes memory bstr = new bytes(len);
330         uint k = len;
331         while (_i != 0) {
332             k = k-1;
333             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
334             bytes1 b1 = bytes1(temp);
335             bstr[k] = b1;
336             _i /= 10;
337         }
338 
339 
340         return string(abi.encodePacked(__uriBase,bstr));
341 
342     }
343 
344 
345 
346     function name() external view returns (string memory _name){
347         return __name;
348     }
349 
350     function symbol() external view returns (string memory _symbol){
351         return __symbol;
352     }
353 
354 
355     // ENUMERABLE FUNCTIONS
356     function totalSupply() external view returns (uint256){
357         return TOKENS.length;
358     }
359 
360     function tokenByIndex(uint256 _index) external view returns(uint256){
361         require(_index < TOKENS.length,"index");
362         return INDEX_TO_ID[_index];
363     }
364 
365     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
366         require(_index < BALANCES[_owner],"index");
367         return OWNER_INDEX_TO_ID[_owner][_index];
368     }
369 
370     // End 721 Implementation
371 
372     ///////===165 Implementation
373     mapping (bytes4 => bool) internal supportedInterfaces;
374     function supportsInterface(bytes4 interfaceID) external view returns (bool){
375         return supportedInterfaces[interfaceID];
376     }
377     ///==End 165
378 }
379 
380 
381 
382 
383 interface ERC721TokenReceiver {
384     //note: the national treasure is buried under parliament house
385     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
386 }
387 
388 
389 interface POWNFTv2 {
390     function hashOf(uint _tokenId) external view returns(bytes32);
391     function ownerOf(uint256 _tokenId) external view returns(address);
392     function totalSupply() external view returns (uint256);
393     //NWH YDY DDUG SEGEN DIN
394 }