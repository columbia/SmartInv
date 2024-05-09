1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity >=0.8.0;
3 
4 /// This file is forked from Solmate v6,
5 /// We stand on the shoulders of giants
6 interface IERC721 {
7     function ownerOf(uint256 tokenId) external view returns (address owner);
8 }
9 
10 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
11 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
12 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
13 contract VAYC2 {
14     /*///////////////////////////////////////////////////////////////
15                                  EVENTS
16     //////////////////////////////////////////////////////////////*/
17     event Transfer(address indexed from, address indexed to, uint256 indexed id);
18     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
19     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /*///////////////////////////////////////////////////////////////
23                           METADATA STORAGE/LOGIC
24     //////////////////////////////////////////////////////////////*/
25     string private constant NOT_LIVE = "Sale not live";
26     string private constant INCORRECT_PRICE = "Gotta pay right money";
27     string private constant MINTED_OUT = "Max supply reached";
28     string private constant FROZEN = "DATA_FROZEN";
29     string private constant MIGRATED = "MIGRATION_OVER";
30 
31     string private token_metadata = "ipfs://QmUp2pBkqiGhdztfs5ym3AGttA5L8JLAUEPRawEKinRVcJ/";
32 
33     string public name;
34     string public symbol;
35 
36     address public owner;
37     uint16 public totalSupply;
38     uint16 public counter = 0;
39     uint16 public constant  MAX_SUPPLY =  10000; // only first 10000 were minted
40 
41     bool public saleMode = false;
42     bool public market_frozen = false;
43     bool public metadata_frozen = false;
44     bool public migration_over = false;
45     uint8 public giveawaysMinted = 0;
46     address public market = address(0); //initialize to an address nobody controls
47     uint256 public constant COST_MAYC =   0.042069 ether;
48     uint256 public constant COST_PUBLIC = 0.069420 ether;
49     uint8 constant MAX_MINT = 10;
50     uint8 constant GIVEAWAY_LIMIT = 100;
51 
52     IERC721 private MAYC = IERC721(0x60E4d786628Fea6478F785A6d7e704777c86a7c6);
53     IERC721 private BAYC = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
54     IERC721 private BAKC = IERC721(0xba30E5F9Bb24caa003E9f2f0497Ad287FDF95623);
55     IERC721 private OLD_VAYC = IERC721(0x99FE9b46e8e2559EAc3c7BD5dd8f55238D89FBD0);
56 
57     /*///////////////////////////////////////////////////////////////
58                             ERC721 STORAGE
59     //////////////////////////////////////////////////////////////*/
60     mapping(address => uint256) public balanceOf;
61     mapping(uint256 => address) public ownerOf;
62     mapping(uint256 => address) public getApproved;
63     mapping(address => mapping(address => bool)) public isApprovedForAll;
64 
65     /*///////////////////////////////////////////////////////////////
66                               ERC721/165/173 LOGIC
67     //////////////////////////////////////////////////////////////*/
68 
69     function approve(address spender, uint256 id) external {
70         address tokenOwner = ownerOf[id];
71 
72         require(msg.sender == tokenOwner || isApprovedForAll[tokenOwner][msg.sender], "NOT_AUTHORIZED");
73 
74         getApproved[id] = spender;
75 
76         emit Approval(owner, spender, id);
77     }
78 
79     function setApprovalForAll(address operator, bool approved) external {
80         isApprovedForAll[msg.sender][operator] = approved;
81 
82         emit ApprovalForAll(msg.sender, operator, approved);
83     }
84 
85     function transferFrom(
86         address from,
87         address to,
88         uint256 id
89     ) public {
90         require(from == ownerOf[id], "WRONG_FROM");
91 
92         require(to != address(0), "INVALID_RECIPIENT");
93 
94         require(
95             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
96             "NOT_AUTHORIZED"
97         );
98 
99         // Underflow of the sender's balance is impossible because we check for
100         // ownership above and the recipient's balance can't realistically overflow.
101         unchecked {
102             balanceOf[from]--;
103 
104             balanceOf[to]++;
105         }
106 
107         ownerOf[id] = to;
108 
109         delete getApproved[id];
110 
111         emit Transfer(from, to, id);
112     }
113 
114     function safeTransferFrom(
115         address from,
116         address to,
117         uint256 id
118     ) external {
119         transferFrom(from, to, id);
120 
121         require(
122             to.code.length == 0 ||
123                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
124                 ERC721TokenReceiver.onERC721Received.selector,
125             "UNSAFE_RECIPIENT"
126         );
127     }
128 
129     function safeTransferFrom(
130         address from,
131         address to,
132         uint256 id,
133         bytes memory data
134     ) external {
135         transferFrom(from, to, id);
136 
137         require(
138             to.code.length == 0 ||
139                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
140                 ERC721TokenReceiver.onERC721Received.selector,
141             "UNSAFE_RECIPIENT"
142         );
143     }
144 
145     function transferOwnership(address _newOwner) external onlyOwner {
146         emit OwnershipTransferred(owner, _newOwner);
147         owner = _newOwner;
148     }
149 
150     function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
151         return
152             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165 interfaces
153             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721 tokens
154             interfaceId == 0x7f5828d0 || // ERC173 Interface ID for ERC173 ownership
155             interfaceId == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
156     }
157 
158     /*///////////////////////////////////////////////////////////////
159                        VAYC SPECIFIC LOGIC 
160     //////////////////////////////////////////////////////////////*/
161 
162 
163     //
164     // Modifiers
165     //
166 
167     modifier onlyOwner() {
168         require(msg.sender == owner, "Ownable: caller is not the owner");
169         _;
170     }
171 
172     modifier duringMigration() {
173         require(migration_over == false, MIGRATED);
174         _;
175     }
176 
177     modifier duringSale() {
178         require(saleMode == true, NOT_LIVE);
179         _;
180     }
181 
182     constructor(string memory _name, string memory _symbol) {
183         name = _name;
184         symbol = _symbol;
185         owner = msg.sender;
186         emit OwnershipTransferred(address(0), msg.sender);
187     }
188 
189     function setMarket(address _market) external onlyOwner {
190         require(market_frozen == false, FROZEN);
191         market_frozen = true;
192         market = _market;
193     }
194 
195     function saleToPause() external onlyOwner {
196         saleMode = false;
197     }
198 
199     function saleToPublic() external onlyOwner {
200         saleMode = true;
201     }
202 
203     function withdraw(uint amount) external onlyOwner {
204         if(amount == 0) {
205             payable(owner).transfer(address(this).balance);
206         } else {
207             payable(owner).transfer(amount);
208         }
209     }
210 
211     //
212     // Minting
213     //
214 
215     function mintPublic(uint16 num) external payable duringSale {
216         require(msg.value == COST_PUBLIC * num, INCORRECT_PRICE);
217         _mintY(num);
218     }
219 
220     function mintWL(uint16 num, uint tokenId) external payable duringSale {
221         bool baycFan =
222             (msg.sender == MAYC.ownerOf(tokenId)) ||
223             (msg.sender == BAYC.ownerOf(tokenId)) ||
224             (msg.sender == BAKC.ownerOf(tokenId));
225         require(baycFan, "Not whitelisted");
226         require(msg.value == COST_MAYC * num, INCORRECT_PRICE);
227         _mintY(num);
228     }
229 
230     function mintGiveaway(uint8 num) external onlyOwner {
231         require(giveawaysMinted < GIVEAWAY_LIMIT, "No more giveaways");
232         giveawaysMinted += num;
233         _mintY(num);
234     }
235 
236 
237     function _mintY(uint16 num) internal {
238         require(num <= MAX_MINT, "Max 10 per TX");
239         require(totalSupply + num < MAX_SUPPLY, MINTED_OUT);
240         require(msg.sender.code.length == 0, "Hack harder bot master"); // bypassable, but raises level of effort
241         uint id = counter;
242         uint num_already_minted = 0;
243         while(num_already_minted < num){
244             if (ownerOf[id] == address(0)) {
245                 ownerOf[id] = msg.sender;
246                 emit Transfer(address(0), msg.sender, id);
247                 num_already_minted += 1;
248             }
249             id += 1;
250         }
251         unchecked {
252             balanceOf[msg.sender] += num;
253             counter = uint16(id);
254             totalSupply = totalSupply + num;
255         }
256     }
257 
258     //
259     // Migration logic
260     //
261 
262     function _migrateTo(uint id, address person) internal {
263         ownerOf[id] = person;
264         emit Transfer(address(0), msg.sender, id);
265         balanceOf[person] += 1;
266     }
267 
268     function endMigration() public onlyOwner {
269         migration_over = true;
270     }
271 
272     function setMigrationSupply(uint16 _supply, uint16 _counter) public onlyOwner duringMigration {
273         totalSupply = _supply;
274         counter = _counter;
275     }
276 
277     function migrateByHand(uint[] calldata tokenIds) public onlyOwner duringMigration {
278         for (uint i; i < tokenIds.length; i++) {
279             _migrateTo(tokenIds[i], OLD_VAYC.ownerOf(tokenIds[i]));
280         }
281     }
282 
283     function migrateBulk(uint16 start, uint16 end) public onlyOwner duringMigration {
284         for (uint16 i = start; i < end; i++) {
285             _migrateTo(i, OLD_VAYC.ownerOf(i));
286         }
287     }
288 
289 
290     //
291     // TokenURI logic
292     //
293 
294     function uintToString(uint256 value) internal pure returns (string memory) {
295         // stolen from OpenZeppelin Strings library
296         // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
297         if (value == 0) {
298             return "0";
299         }
300         uint256 temp = value;
301         uint256 digits;
302         while (temp != 0) {
303             digits++;
304             temp /= 10;
305         }
306         bytes memory buffer = new bytes(digits);
307         while (value != 0) {
308             digits -= 1;
309             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
310             value /= 10;
311         }
312         return string(buffer);
313     }
314 
315     function setTokenMetadata(string calldata url) public onlyOwner {
316         require(metadata_frozen == false, FROZEN);
317         metadata_frozen = true;
318         token_metadata = url;
319     }
320 
321     function tokenURI(uint256 id) external view returns (string memory) {
322         if(ownerOf[id] == address(0))
323             return "";
324         return string(abi.encodePacked(string(abi.encodePacked(token_metadata, uintToString(id))), ".json"));
325     }
326 
327     //
328     // Market Integration
329     //
330 
331     function marketTransferFrom(address from, address to, uint256 id) external {
332         require(msg.sender == address(market), "INVALID_CALLER");
333         require(to != address(0), "INVALID_RECIPIENT");
334         unchecked {
335             balanceOf[from]--;
336 
337             balanceOf[to]++;
338         }
339 
340         ownerOf[id] = to;
341 
342         delete getApproved[id];
343 
344         emit Transfer(from, to, id);
345 
346         require(
347             to.code.length == 0 ||
348                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
349                 ERC721TokenReceiver.onERC721Received.selector,
350             "UNSAFE_RECIPIENT"
351         );
352 
353     }
354 
355 }
356 
357 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
358 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
359 interface ERC721TokenReceiver {
360     function onERC721Received(
361         address operator,
362         address from,
363         uint256 id,
364         bytes calldata data
365     ) external returns (bytes4);
366 }