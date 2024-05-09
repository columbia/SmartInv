1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: contracts/IEntityStorage.sol
56 
57 interface IEntityStorage {
58     function storeBulk(uint256[] _tokenIds, uint256[] _attributes) external;
59     function store(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external;
60     function remove(uint256 _tokenId) external;
61     function list() external view returns (uint256[] tokenIds);
62     function getAttributes(uint256 _tokenId) external view returns (uint256 attrs, uint256[] compIds);
63     function updateAttributes(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external;
64     function totalSupply() external view returns (uint256);
65 }
66 
67 // File: contracts/Ownable.sol
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address public owner;
76     address public newOwner;
77     
78     // mapping for creature Type to Sale
79     address[] internal controllers;
80     //mapping(address => address) internal controllers;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83    /**
84    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85    * account.
86    */
87     constructor() public {
88         owner = msg.sender;
89     }
90    
91     /**
92     * @dev Throws if called by any account that's not a superuser.
93     */
94     modifier onlyController() {
95         require(isController(msg.sender), "only Controller");
96         _;
97     }
98 
99     modifier onlyOwnerOrController() {
100         require(msg.sender == owner || isController(msg.sender), "only Owner Or Controller");
101         _;
102     }
103 
104     /**
105     * @dev Throws if called by any account other than the owner.
106     */
107     modifier onlyOwner() {
108         require(msg.sender == owner, "sender address must be the owner's address");
109         _;
110     }
111 
112     /**
113     * @dev Allows the current owner to transfer control of the contract to a newOwner.
114     * @param _newOwner The address to transfer ownership to.
115     */
116     function transferOwnership(address _newOwner) public onlyOwner {
117         require(address(0) != _newOwner, "new owner address must not be the owner's address");
118         newOwner = _newOwner;
119     }
120 
121     /**
122     * @dev Allows the new owner to confirm that they are taking control of the contract..tr
123     */
124     function acceptOwnership() public {
125         require(msg.sender == newOwner, "sender address must not be the new owner's address");
126         emit OwnershipTransferred(owner, msg.sender);
127         owner = msg.sender;
128         newOwner = address(0);
129     }
130 
131     function isController(address _controller) internal view returns(bool) {
132         for (uint8 index = 0; index < controllers.length; index++) {
133             if (controllers[index] == _controller) {
134                 return true;
135             }
136         }
137         return false;
138     }
139 
140     function getControllers() public onlyOwner view returns(address[]) {
141         return controllers;
142     }
143 
144     /**
145     * @dev Allows a new controllers to be added
146     * @param _controller The address controller.
147     */
148     function addController(address _controller) public onlyOwner {
149         require(address(0) != _controller, "controller address must not be 0");
150         require(_controller != owner, "controller address must not be the owner's address");
151         for (uint8 index = 0; index < controllers.length; index++) {
152             if (controllers[index] == _controller) {
153                 return;
154             }
155         }
156         controllers.push(_controller);
157     }
158 
159     /**
160     * @dev Allows a new controllers to be added
161     * @param _controller The address controller.
162     */
163     function removeController(address _controller) public onlyOwner {
164         require(address(0) != _controller, "controller address must not be 0");
165         for (uint8 index = 0; index < controllers.length; index++) {
166             if (controllers[index] == _controller) {
167                 delete controllers[index];
168             }
169         }
170     }
171 }
172 
173 // File: contracts/CBCreatureStorage.sol
174 
175 /**
176 * @title CBCreatureStorage
177 * @dev Composable storage contract for recording attribute data and attached components for a CryptoBeasties card. 
178 * CryptoBeasties content and source code is Copyright (C) 2018 PlayStakes LLC, All rights reserved.
179 */
180 contract CBCreatureStorage is Ownable, IEntityStorage { 
181     using SafeMath for uint256;  
182 
183     struct Token {
184         uint256 tokenId;
185         uint256 attributes;
186         uint256[] componentIds;
187         uint index;
188     }
189 
190     // Array with all Tokens, used for enumeration
191     uint256[] internal allTokens;
192 
193     // Maps token ids to data
194     mapping(uint256 => Token) internal tokens;
195 
196     event Stored(uint256 tokenId, uint256 attributes, uint256[] componentIds);
197     event Removed(uint256 tokenId);
198 
199     /**
200     * @dev Constructor function
201     */
202     constructor() public {
203     }
204 
205     /**
206     * @dev Returns whether the specified token exists
207     * @param _tokenId uint256 ID of the token to query the existence of
208     * @return whether the token exists
209     */
210     function exists(uint256 _tokenId) public view returns (bool) {
211         return tokens[_tokenId].tokenId == _tokenId;
212     }
213 
214     /**
215     * @dev Bulk Load of Tokens
216     * @param _tokenIds Array of tokenIds
217     * @param _attributes Array of packed attributes value
218     */
219     function storeBulk(uint256[] _tokenIds, uint256[] _attributes) external onlyOwnerOrController {
220         uint256[] memory _componentIds;
221         uint startIndex = allTokens.length;
222         for (uint index = 0; index < _tokenIds.length; index++) {
223             require(!this.exists(_tokenIds[index]));
224             allTokens.push(_tokenIds[index]);
225             tokens[_tokenIds[index]] = Token(_tokenIds[index], _attributes[index], _componentIds, startIndex + index);
226             emit Stored(_tokenIds[index], _attributes[index], _componentIds);
227         }
228     }
229     
230     /**
231     * @dev Create a new CryptoBeasties Token
232     * @param _tokenId ID of the token
233     * @param _attributes Packed attributes value
234     * @param _componentIds Array of CryptoBeasties componentIds (i.e. PowerStones)
235     */
236     function store(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external onlyOwnerOrController {
237         require(!this.exists(_tokenId));
238         allTokens.push(_tokenId);
239         tokens[_tokenId] = Token(_tokenId, _attributes, _componentIds, allTokens.length - 1);
240         emit Stored(_tokenId, _attributes, _componentIds);
241     }
242 
243     /**
244     * @dev Remove a CryptoBeasties Token from storage
245     * @param _tokenId ID of the token
246     */
247     function remove(uint256 _tokenId) external onlyOwnerOrController {
248         require(_tokenId > 0);
249         require(exists(_tokenId));
250         
251         uint doomedTokenIndex = tokens[_tokenId].index;
252         
253         delete tokens[_tokenId];
254 
255         // Reorg allTokens array
256         uint lastTokenIndex = allTokens.length.sub(1);
257         uint256 lastTokenId = allTokens[lastTokenIndex];
258 
259         // update the moved token's index
260         tokens[lastTokenId].index = doomedTokenIndex;
261         
262         allTokens[doomedTokenIndex] = lastTokenId;
263         allTokens[lastTokenIndex] = 0;
264 
265         allTokens.length--;
266         emit Removed(_tokenId);
267     }
268 
269     /**
270     * @dev List all CryptoBeasties Tokens in storage
271     */
272     function list() external view returns (uint256[] tokenIds) {
273         return allTokens;
274     }
275 
276     /**
277     * @dev Gets attributes and componentIds (i.e. PowerStones) for a CryptoBeastie
278     * @param _tokenId uint256 for the given token
279     */
280     function getAttributes(uint256 _tokenId) external view returns (uint256 attrs, uint256[] compIds) {
281         require(exists(_tokenId));
282         return (tokens[_tokenId].attributes, tokens[_tokenId].componentIds);
283     }
284 
285     /**
286     * @dev Update CryptoBeasties attributes and Component Ids (i.e. PowerStones) CryptoBeastie
287     * @param _tokenId uint256 ID of the token to update
288     * @param _attributes Packed attributes value
289     * @param _componentIds Array of CryptoBeasties componentIds (i.e. PowerStones)
290     */
291     function updateAttributes(uint256 _tokenId, uint256 _attributes, uint256[] _componentIds) external onlyOwnerOrController {
292         require(exists(_tokenId));
293         require(_attributes > 0);
294         tokens[_tokenId].attributes = _attributes;
295         tokens[_tokenId].componentIds = _componentIds;
296         emit Stored(_tokenId, _attributes, _componentIds);
297     }
298 
299     /**
300     * @dev Get the total number of tokens in storage
301     */
302     function totalSupply() external view returns (uint256) {
303         return allTokens.length;
304     }
305 
306 }