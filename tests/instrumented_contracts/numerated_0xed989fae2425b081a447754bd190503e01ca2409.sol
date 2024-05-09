1 pragma solidity ^0.4.24;
2 
3 /*
4 * This contract implements the ERC721 standard and provides services for DigiRights platform 
5 */
6 interface ERC721 {
7     
8     /*
9     * Mandatory functions of ERC721 standard
10     */
11     function totalSupply() external view returns (uint256 total);
12     function balanceOf(bytes32 _owner) external view returns (uint256 balance);
13     function ownerOf(uint256 _tokenId) external view returns (bytes32 owner);
14     function approve(bytes32 _from,bytes32 _to, uint256 _tokenId) external;
15     function transferFrom(bytes32 _from, bytes32 _to, uint256 _tokenId) external;
16 
17         
18     /*
19     * Events 
20     */
21     event Transfer(bytes32 from, bytes32 to, uint256 tokenId);
22     event Approval(bytes32 owner, bytes32 approved, uint256 tokenId);
23 
24     // ERC-165 Compatibility
25     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
26 }
27 
28 contract DigiRights is ERC721 {
29 
30     string private NAME = "Ionixx DigiRights";
31     string private SYMBOL = "INX DIGI";
32 
33     bytes4 constant InterfaceID_ERC165 =
34     bytes4(keccak256("supportsInterface(bytes4)"));
35 
36     bytes4 constant InterfaceID_ERC721 =
37     bytes4(keccak256("name()")) ^
38     bytes4(keccak256("symbol()")) ^
39     bytes4(keccak256("totalSupply()")) ^
40     bytes4(keccak256("balanceOf(bytes32)")) ^
41     bytes4(keccak256("ownerOf(uint256)")) ^
42     bytes4(keccak256("approve(bytes32,uint256)")) ^
43     bytes4(keccak256("transfer(bytes32,uint256)")) ^
44     bytes4(keccak256("transferFrom(bytes32,bytes32,uint256)")) ^
45     bytes4(keccak256("tokensOfOwner(bytes32)"));
46 
47     /*  @desc Metadata of the token implemented as a structure
48         @attributes owner: Creator of the Token
49         @attributes name: Name of the file
50         @attributes descripton: descripton of the file
51         @attributes file_hash: hash of the file
52     */
53     struct Token {
54         bytes32 owner;
55         string name;
56         string description;
57         string file_hash;
58         uint256 token_id;
59         uint256 timestamp;
60         string file_type;
61         string extension;
62     }
63 
64     Token[] tokens;
65 
66     mapping (uint256 => bytes32) public ownerOf;
67     mapping (bytes32 => uint256) ownerTokenCount;
68     mapping (uint256 => bytes32) public tokenIndexToApproved;   
69     mapping(string => bool) filehash;
70     
71     event Created(bytes32 owner, uint256 tokenId);
72     
73     
74  
75     /*  @desc provides the name of the token
76         @return string: name of the token
77     */
78     function name() external view returns (string) {
79         return NAME;
80     }
81     
82     /*  @desc provides the symbol of the token
83         @return string: symbol of the token
84     */
85     function symbol() external view returns (string) {
86         return SYMBOL;
87     }
88     
89     /*  @desc provides the total supply limit of the token
90         @return uint256: total supply
91     */
92     function totalSupply() external view returns (uint256) {
93         return tokens.length;
94     }
95     
96     /*  @desc provides the total number of tokens owned by the user
97         @param _owner: owner hash
98         @return uint256: number of tokens
99     */
100     function balanceOf(bytes32 _owner) external view returns (uint256) {
101         return ownerTokenCount[_owner];
102     }
103     
104     /*  @desc provides the owner of the given token
105         @param _tokenId: token ID
106         @return uint256: number of tokens
107     */
108     function ownerOf(uint256 _tokenId) external view returns (bytes32 owner) {
109         owner = ownerOf[_tokenId];
110     }
111     
112     /*  @desc approves a user to use his/her token
113         @param _from: from hash
114         @param _to: to hash
115         @param _tokenId: token ID
116     */
117     function approve(bytes32 _from,bytes32 _to, uint256 _tokenId) external {
118         require(_owns(_from, _tokenId));
119 
120         tokenIndexToApproved[_tokenId] = _to;
121         emit Approval(ownerOf[_tokenId], tokenIndexToApproved[_tokenId], _tokenId);
122     }
123     
124     /*  @desc transfers token from one hash to another hash when they have approval
125         @param _from: from hash
126         @param _to: to hash
127         @param _tokenId: token ID
128     */
129     function transferFrom(bytes32 _from, bytes32 _to, uint256 _tokenId) external {
130         require(_to.length != 0 );
131         require(_to != _from);
132         require(_owns(_from, _tokenId));
133 
134         _transfer(_from, _to, _tokenId);
135     }
136 
137     /*  @desc provides the tokens owned by an user
138         @param _owner: owner hash
139         @param tokenIds: token ID as array
140     */
141     function tokensOfOwner(bytes32 _owner) external view returns (uint256[]) {
142         uint256 balance = this.balanceOf(_owner);
143 
144         if (balance == 0) {
145             return new uint256[](0);
146         } else {
147             uint256[] memory result = new uint256[](balance);
148             uint256 maxTokenId = this.totalSupply();
149             uint256 idx = 0;
150 
151             uint256 tokenId;
152             for (tokenId = 0; tokenId <= maxTokenId; tokenId++) {
153                 if (ownerOf[tokenId] == _owner) {
154                     result[idx] = tokenId;
155                     idx++;
156                 }
157             }
158             return result;
159         }
160 
161     }
162     
163     /*  @desc obtains ther token details
164         @param _owner: owner hash 
165         @param _tokenId: token ID 
166         @return owner: owner hash
167         @return name: file name
168         @return description: file description
169         @return hash: file hash
170     */
171     function getToken(bytes32 _owner,uint256 _tokenId) external view returns (bytes32 owner,string token_name,string description,string file_hash,
172         uint256 token_id,
173         uint256 timestamp,
174         string file_type,string extension) {
175         require(_owns(_owner,_tokenId) == true);
176         uint256 length = this.totalSupply();
177         require(_tokenId < length);
178         Token memory token = tokens[_tokenId];
179         owner = token.owner;
180         token_name = token.name;
181         description = token.description;
182         file_hash = token.file_hash;
183         token_id = token.token_id;
184         timestamp = token.timestamp;
185         file_type=token.file_type;
186         extension=token.extension;
187     }
188 
189     /*  @desc checks if the contract supports interface
190         @param _interfaceID: interface ID 
191         @return bool: flag if the interface is implemented or not
192     */
193     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
194         return ((_interfaceID == InterfaceID_ERC165) || (_interfaceID == InterfaceID_ERC721));
195     }
196     
197     /*  @desc creates a new token and assigns it to the user
198         @param _from: from hash
199         @param name: file name
200         @param description: file description
201         @param hash: file hash
202     */
203     function createToken(bytes32 _from,string token_name,string description,string file_hash,string file_type , string extension) public {
204         require(_from.length != 0 );
205         require(filehash[file_hash] == false);
206         filehash[file_hash] = true;
207         mint(_from,token_name,description,file_hash ,file_type,extension);
208         
209     }
210     
211     /*
212     * Internal functions
213     */
214     function _owns(bytes32 _claimant, uint256 _tokenId) internal view returns (bool) {
215         return ownerOf[_tokenId] == _claimant;
216     }
217 
218     function _approvedFor(bytes32 _claimant, uint256 _tokenId) internal view returns (bool) {
219         return tokenIndexToApproved[_tokenId] == _claimant;
220     }
221 
222     function _transfer(bytes32 _from, bytes32 _to, uint256 _tokenId) internal {
223         
224         ownerTokenCount[_to]++;
225         ownerOf[_tokenId] = _to;
226 
227         if (_from.length != 0 ) {
228             ownerTokenCount[_from]--;
229             delete tokenIndexToApproved[_tokenId];
230         }
231 
232         emit Transfer(_from, _to, _tokenId);
233     }
234     
235     function mint(bytes32 owner,string token_name,string description,string hash,string file_type, string extension) internal {
236         Token memory token = Token({
237             owner:owner,
238             name:token_name,
239             description:description,
240             file_hash:hash,
241             file_type: file_type,
242             extension: extension,
243             token_id: this.totalSupply(),
244             timestamp:block.timestamp
245         });
246         uint256 tokenId =tokens.push(token) - 1;
247         emit Created(owner, tokenId);
248         _transfer(0, owner, tokenId);
249     }
250 }