1 // SPDX-License-Identifier: This smart contract is guarded by an angry ghost
2 pragma solidity ^0.8.0;
3 
4 contract POWNFT{
5 
6 
7     constructor(){
8         supportedInterfaces[0x80ac58cd] = true; //ERC721
9         supportedInterfaces[0x5b5e139f] = true; //ERC721Metadata
10         supportedInterfaces[0x780e9d63] = true; //ERC721Enumerable
11         supportedInterfaces[0x01ffc9a7] = true; //ERC165
12 
13         //Issue token 0 to creator
14         mint(1,bytes32(0));
15     }
16 
17 
18     //////===721 Standard
19     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
20     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
21     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
22 
23     //////===721 Implementation
24     mapping(address => uint256) internal BALANCES;
25     mapping (uint256 => address) internal ALLOWANCE;
26     mapping (address => mapping (address => bool)) internal AUTHORISED;
27 
28     bytes32[] TOKENS;  //Array of all tokens [hash,hash,...]
29     mapping(uint256 => address) OWNERS;  //Mapping of owners
30 
31 
32     mapping(uint256 => uint256) WITHDRAWALS;
33 
34     //    METADATA VARS
35     string private __name = "POW NFT";
36     string private __symbol = "POW";
37     bytes private __uriBase = bytes("https://www.pownftmetadata.com/d/");
38 
39 
40     //    ENUMERABLE VARS
41     mapping(address => uint[]) internal OWNER_INDEX_TO_ID;
42     mapping(uint => uint) internal OWNER_ID_TO_INDEX;
43     mapping(uint => uint) internal ID_TO_INDEX;
44 
45 
46     //      MINING VARS
47     uint BASE_COST = 0.00003 ether;
48     uint BASE_DIFFICULTY = uint(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)/uint(2);
49     uint DIFFICULTY_RAMP = 5;
50 
51 
52     //      MINING EVENTS
53     event Mined(uint indexed _tokenId, bytes32 hash);
54     event Withdraw(uint indexed _tokenId, uint value);
55 
56     //      MINING FUNCTIONS
57     function generationOf(uint _tokenId) private pure returns(uint generation){
58         for(generation = 0; _tokenId > 0; generation++){
59             _tokenId /= 2;
60         }
61         return generation - 1;
62     }
63     function hashOf(uint _tokenId) public view returns(bytes32){
64         require(isValidToken(_tokenId),"invalid");
65         return TOKENS[_tokenId - 1];
66     }
67 
68     function withdraw(uint _tokenId) public{
69         require(msg.sender == ownerOf(_tokenId),'owner');
70 
71         uint generation = generationOf(_tokenId);
72 
73 
74         uint last = 2**(generation+1)-1;
75         uint payout = 0;
76         for(uint i = TOKENS.length; i > last && i > WITHDRAWALS[_tokenId]; i--){
77             payout += BASE_COST;
78         }
79         WITHDRAWALS[_tokenId] = TOKENS.length;
80         emit Withdraw(_tokenId,payout);
81         payable(msg.sender).transfer(payout);
82 
83     }
84     function withdrawMultiple(uint[] calldata _tokenIds) public{
85         for(uint i = 0; i < _tokenIds.length; i++){
86             withdraw(_tokenIds[i]);
87         }
88     }
89 
90     function mine(uint nonce) external payable{
91         uint tokenId = TOKENS.length + 1;
92         uint generation = generationOf(tokenId);
93 
94         uint difficulty = BASE_DIFFICULTY / (DIFFICULTY_RAMP**generation);
95         if(generation > 13){
96             difficulty /= (tokenId - 2**14 + 1);
97         }
98 
99 
100         uint cost = (2**generation - 1)* BASE_COST;
101 
102 
103         bytes32 hash = keccak256(abi.encodePacked(msg.sender,TOKENS[tokenId-2],nonce));
104 
105         require(uint(hash) < difficulty,"difficulty");
106         require(msg.value ==cost,"cost");
107 
108         mint(tokenId,keccak256(abi.encodePacked(hash,block.timestamp)));
109     }
110 
111     function mint(uint tokenId, bytes32 hash) private{
112         OWNERS[tokenId] = msg.sender;
113         BALANCES[msg.sender]++;
114         OWNER_ID_TO_INDEX[tokenId] = OWNER_INDEX_TO_ID[msg.sender].length;
115         OWNER_INDEX_TO_ID[msg.sender].push(tokenId);
116 
117         ID_TO_INDEX[tokenId] = TOKENS.length;
118         TOKENS.push(hash);
119 
120         emit Mined(tokenId,hash);
121         emit Transfer(address(0),msg.sender,tokenId);
122     }
123 
124 
125     function isValidToken(uint256 _tokenId) internal view returns(bool){
126         return OWNERS[_tokenId] != address(0);
127     }
128 
129     function balanceOf(address _owner) external view returns (uint256){
130         return BALANCES[_owner];
131     }
132 
133     function ownerOf(uint256 _tokenId) public view returns(address){
134         require(isValidToken(_tokenId),"invalid");
135         return OWNERS[_tokenId];
136     }
137 
138 
139     function approve(address _approved, uint256 _tokenId)  external{
140         address owner = ownerOf(_tokenId);
141         require( owner == msg.sender                    //Require Sender Owns Token
142             || AUTHORISED[owner][msg.sender]                //  or is approved for all.
143         ,"permission");
144         emit Approval(owner, _approved, _tokenId);
145         ALLOWANCE[_tokenId] = _approved;
146     }
147 
148     function getApproved(uint256 _tokenId) external view returns (address) {
149         require(isValidToken(_tokenId),"invalid");
150         return ALLOWANCE[_tokenId];
151     }
152 
153     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
154         return AUTHORISED[_owner][_operator];
155     }
156 
157 
158     function setApprovalForAll(address _operator, bool _approved) external {
159         emit ApprovalForAll(msg.sender,_operator, _approved);
160         AUTHORISED[msg.sender][_operator] = _approved;
161     }
162 
163 
164     function transferFrom(address _from, address _to, uint256 _tokenId) public {
165 
166         //Check Transferable
167         //There is a token validity check in ownerOf
168         address owner = ownerOf(_tokenId);
169 
170         require ( owner == msg.sender             //Require sender owns token
171         //Doing the two below manually instead of referring to the external methods saves gas
172         || ALLOWANCE[_tokenId] == msg.sender      //or is approved for this token
173             || AUTHORISED[owner][msg.sender]          //or is approved for all
174         ,"permission");
175         require(owner == _from,"owner");
176         require(_to != address(0),"zero");
177 
178         emit Transfer(_from, _to, _tokenId);
179 
180 
181         OWNERS[_tokenId] =_to;
182 
183         BALANCES[_from]--;
184         BALANCES[_to]++;
185 
186         //Reset approved if there is one
187         if(ALLOWANCE[_tokenId] != address(0)){
188             delete ALLOWANCE[_tokenId];
189         }
190 
191         //Enumerable Additions
192         uint oldIndex = OWNER_ID_TO_INDEX[_tokenId];
193         //If the token isn't the last one in the owner's index
194         if(oldIndex != OWNER_INDEX_TO_ID[_from].length - 1){
195             //Move the old one in the index list
196             OWNER_INDEX_TO_ID[_from][oldIndex] = OWNER_INDEX_TO_ID[_from][OWNER_INDEX_TO_ID[_from].length - 1];
197             //Update the token's reference to its place in the index list
198             OWNER_ID_TO_INDEX[OWNER_INDEX_TO_ID[_from][oldIndex]] = oldIndex;
199         }
200         //OWNER_INDEX_TO_ID[_from].length--;
201         OWNER_INDEX_TO_ID[_from].pop();
202 
203         OWNER_ID_TO_INDEX[_tokenId] = OWNER_INDEX_TO_ID[_to].length;
204         OWNER_INDEX_TO_ID[_to].push(_tokenId);
205 
206     }
207 
208     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {
209         transferFrom(_from, _to, _tokenId);
210 
211         //Get size of "_to" address, if 0 it's a wallet
212         uint32 size;
213         assembly {
214             size := extcodesize(_to)
215         }
216         if(size > 0){
217             ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);
218             require(receiver.onERC721Received(msg.sender,_from,_tokenId,data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")),"receiver");
219         }
220 
221     }
222 
223     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
224         safeTransferFrom(_from,_to,_tokenId,"");
225     }
226 
227 
228     // METADATA FUNCTIONS
229     function tokenURI(uint256 _tokenId) public view returns (string memory){
230         //Note: changed visibility to public
231         require(isValidToken(_tokenId),'tokenId');
232 
233         uint _i = _tokenId;
234         uint j = _i;
235         uint len;
236         while (j != 0) {
237             len++;
238             j /= 10;
239         }
240         bytes memory bstr = new bytes(len);
241         uint k = len;
242         while (_i != 0) {
243             k = k-1;
244             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
245             bytes1 b1 = bytes1(temp);
246             bstr[k] = b1;
247             _i /= 10;
248         }
249 
250 
251         return string(abi.encodePacked(__uriBase,bstr));
252 
253     }
254 
255 
256 
257     function name() external view returns (string memory _name){
258         return __name;
259     }
260 
261     function symbol() external view returns (string memory _symbol){
262         return __symbol;
263     }
264 
265 
266     // ENUMERABLE FUNCTIONS
267     function totalSupply() external view returns (uint256){
268         return TOKENS.length;
269     }
270 
271     function tokenByIndex(uint256 _index) external view returns(uint256){
272         require(_index < TOKENS.length,"index");
273         return _index + 1;
274     }
275 
276     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
277         require(_index < BALANCES[_owner],"index");
278         return OWNER_INDEX_TO_ID[_owner][_index];
279     }
280 
281     // End 721 Implementation
282 
283     ///////===165 Implementation
284     mapping (bytes4 => bool) internal supportedInterfaces;
285     function supportsInterface(bytes4 interfaceID) external view returns (bool){
286         return supportedInterfaces[interfaceID];
287     }
288     ///==End 165
289 }
290 
291 
292 
293 
294 interface ERC721TokenReceiver {
295     //note: the national treasure is buried under parliament house
296     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
297 }