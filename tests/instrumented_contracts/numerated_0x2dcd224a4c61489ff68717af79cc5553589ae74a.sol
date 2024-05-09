1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8     // Required methods
9     function approve(address _to, uint256 _tokenId) public;
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function implementsERC721() public pure returns (bool);
12     function ownerOf(uint256 _tokenId) public view returns (address addr);
13     function takeOwnership(uint256 _tokenId) public;
14     function totalSupply() public view returns (uint256 total);
15     function transferFrom(address _from, address _to, uint256 _tokenId) public;
16     function transfer(address _to, uint256 _tokenId) public;
17 
18     event Transfer(address indexed from, address indexed to, uint256 tokenId);
19     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21     // Optional
22     // function name() public view returns (string name);
23     // function symbol() public view returns (string symbol);
24     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
25     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
26 }
27 
28 
29 contract SportStarToken is ERC721 {
30 
31     // ***** EVENTS
32 
33     // @dev Transfer event as defined in current draft of ERC721.
34     //  ownership is assigned, including births.
35     event Transfer(address from, address to, uint256 tokenId);
36 
37 
38 
39     // ***** STORAGE
40 
41     // @dev A mapping from token IDs to the address that owns them. All tokens have
42     //  some valid owner address.
43     mapping (uint256 => address) public tokenIndexToOwner;
44 
45     // @dev A mapping from owner address to count of tokens that address owns.
46     //  Used internally inside balanceOf() to resolve ownership count.
47     mapping (address => uint256) private ownershipTokenCount;
48 
49     // @dev A mapping from TokenIDs to an address that has been approved to call
50     //  transferFrom(). Each Token can only have one approved address for transfer
51     //  at any time. A zero value means no approval is outstanding.
52     mapping (uint256 => address) public tokenIndexToApproved;
53 
54     // Additional token data
55     mapping (uint256 => bytes32) public tokenIndexToData;
56 
57     address public ceoAddress;
58     address public masterContractAddress;
59 
60     uint256 public promoCreatedCount;
61 
62 
63 
64     // ***** DATATYPES
65 
66     struct Token {
67         string name;
68     }
69 
70     Token[] private tokens;
71 
72 
73 
74     // ***** ACCESS MODIFIERS
75 
76     modifier onlyCEO() {
77         require(msg.sender == ceoAddress);
78         _;
79     }
80 
81     modifier onlyMasterContract() {
82         require(msg.sender == masterContractAddress);
83         _;
84     }
85 
86 
87 
88     // ***** CONSTRUCTOR
89 
90     function SportStarToken() public {
91         ceoAddress = msg.sender;
92     }
93 
94 
95 
96     // ***** PRIVILEGES SETTING FUNCTIONS
97 
98     function setCEO(address _newCEO) public onlyCEO {
99         require(_newCEO != address(0));
100 
101         ceoAddress = _newCEO;
102     }
103 
104     function setMasterContract(address _newMasterContract) public onlyCEO {
105         require(_newMasterContract != address(0));
106 
107         masterContractAddress = _newMasterContract;
108     }
109 
110 
111 
112     // ***** PUBLIC FUNCTIONS
113 
114     // @notice Returns all the relevant information about a specific token.
115     // @param _tokenId The tokenId of the token of interest.
116     function getToken(uint256 _tokenId) public view returns (
117         string tokenName,
118         address owner
119     ) {
120         Token storage token = tokens[_tokenId];
121         tokenName = token.name;
122         owner = tokenIndexToOwner[_tokenId];
123     }
124 
125     // @param _owner The owner whose sport star tokens we are interested in.
126     // @dev This method MUST NEVER be called by smart contract code. First, it's fairly
127     //  expensive (it walks the entire Tokens array looking for tokens belonging to owner),
128     //  but it also returns a dynamic array, which is only supported for web3 calls, and
129     //  not contract-to-contract calls.
130     function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens) {
131         uint256 tokenCount = balanceOf(_owner);
132         if (tokenCount == 0) {
133             // Return an empty array
134             return new uint256[](0);
135         } else {
136             uint256[] memory result = new uint256[](tokenCount);
137             uint256 totalTokens = totalSupply();
138             uint256 resultIndex = 0;
139 
140             uint256 tokenId;
141             for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
142                 if (tokenIndexToOwner[tokenId] == _owner) {
143                     result[resultIndex] = tokenId;
144                     resultIndex++;
145                 }
146             }
147             return result;
148         }
149     }
150 
151     function getTokenData(uint256 _tokenId) public view returns (bytes32 tokenData) {
152         return tokenIndexToData[_tokenId];
153     }
154 
155 
156 
157     // ***** ERC-721 FUNCTIONS
158 
159     // @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
160     // @param _to The address to be granted transfer approval. Pass address(0) to
161     //  clear all approvals.
162     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
163     function approve(address _to, uint256 _tokenId) public {
164         // Caller must own token.
165         require(_owns(msg.sender, _tokenId));
166 
167         tokenIndexToApproved[_tokenId] = _to;
168 
169         Approval(msg.sender, _to, _tokenId);
170     }
171 
172     // For querying balance of a particular account
173     // @param _owner The address for balance query
174     function balanceOf(address _owner) public view returns (uint256 balance) {
175         return ownershipTokenCount[_owner];
176     }
177 
178     function name() public pure returns (string) {
179         return "CryptoSportStars";
180     }
181 
182     function symbol() public pure returns (string) {
183         return "SportStarToken";
184     }
185 
186     function implementsERC721() public pure returns (bool) {
187         return true;
188     }
189 
190     // For querying owner of token
191     // @param _tokenId The tokenID for owner inquiry
192     function ownerOf(uint256 _tokenId) public view returns (address owner)
193     {
194         owner = tokenIndexToOwner[_tokenId];
195         require(owner != address(0));
196     }
197 
198     // @notice Allow pre-approved user to take ownership of a token
199     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
200     function takeOwnership(uint256 _tokenId) public {
201         address newOwner = msg.sender;
202         address oldOwner = tokenIndexToOwner[_tokenId];
203 
204         // Safety check to prevent against an unexpected 0x0 default.
205         require(_addressNotNull(newOwner));
206 
207         // Making sure transfer is approved
208         require(_approved(newOwner, _tokenId));
209 
210         _transfer(oldOwner, newOwner, _tokenId);
211     }
212 
213     // For querying totalSupply of token
214     function totalSupply() public view returns (uint256 total) {
215         return tokens.length;
216     }
217 
218     // Owner initates the transfer of the token to another account
219     // @param _to The address for the token to be transferred to.
220     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
221     function transfer(address _to, uint256 _tokenId) public {
222         require(_owns(msg.sender, _tokenId));
223         require(_addressNotNull(_to));
224 
225         _transfer(msg.sender, _to, _tokenId);
226     }
227 
228     // Third-party initiates transfer of token from address _from to address _to
229     // @param _from The address for the token to be transferred from.
230     // @param _to The address for the token to be transferred to.
231     // @param _tokenId The ID of the Token that can be transferred if this call succeeds.
232     function transferFrom(address _from, address _to, uint256 _tokenId) public {
233         require(_owns(_from, _tokenId));
234         require(_approved(_to, _tokenId));
235         require(_addressNotNull(_to));
236 
237         _transfer(_from, _to, _tokenId);
238     }
239 
240 
241 
242     // ONLY MASTER CONTRACT FUNCTIONS
243 
244     function createToken(string _name, address _owner) public onlyMasterContract returns (uint256 _tokenId) {
245         return _createToken(_name, _owner);
246     }
247 
248     function updateOwner(address _from, address _to, uint256 _tokenId) public onlyMasterContract {
249         _transfer(_from, _to, _tokenId);
250     }
251 
252     function setTokenData(uint256 _tokenId, bytes32 tokenData) public onlyMasterContract {
253         tokenIndexToData[_tokenId] = tokenData;
254     }
255 
256 
257 
258     // PRIVATE FUNCTIONS
259 
260     // Safety check on _to address to prevent against an unexpected 0x0 default.
261     function _addressNotNull(address _to) private pure returns (bool) {
262         return _to != address(0);
263     }
264 
265     // For checking approval of transfer for address _to
266     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
267         return tokenIndexToApproved[_tokenId] == _to;
268     }
269 
270     // For creating Token
271     function _createToken(string _name, address _owner) private returns (uint256 _tokenId) {
272         Token memory _token = Token({
273             name: _name
274             });
275         uint256 newTokenId = tokens.push(_token) - 1;
276 
277         // It's probably never going to happen, 4 billion tokens are A LOT, but
278         // let's just be 100% sure we never let this happen.
279         require(newTokenId == uint256(uint32(newTokenId)));
280 
281         // This will assign ownership, and also emit the Transfer event as
282         // per ERC721 draft
283         _transfer(address(0), _owner, newTokenId);
284 
285         return newTokenId;
286     }
287 
288     // Check for token ownership
289     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
290         return claimant == tokenIndexToOwner[_tokenId];
291     }
292 
293     // @dev Assigns ownership of a specific Token to an address.
294     function _transfer(address _from, address _to, uint256 _tokenId) private {
295         // Since the number of tokens is capped to 2^32 we can't overflow this
296         ownershipTokenCount[_to]++;
297         //transfer ownership
298         tokenIndexToOwner[_tokenId] = _to;
299 
300         // When creating new tokens _from is 0x0, but we can't account that address.
301         if (_from != address(0)) {
302             ownershipTokenCount[_from]--;
303             // clear any previously approved ownership exchange
304             delete tokenIndexToApproved[_tokenId];
305         }
306 
307         // Emit the transfer event.
308         Transfer(_from, _to, _tokenId);
309     }
310 }