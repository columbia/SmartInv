1 pragma solidity ^0.4.19;
2 
3 /**
4  * New Art
5  *
6  * An ERC721 compatible public registry with support for operators.
7  * Vist https://www.newart.org for more information.
8  *
9  * Copyright NEW ART Co., Ltd.
10  */
11 
12 
13 /**
14  * Interface for required functionality in the ERC721 standard
15  * for non-fungible tokens.
16  *
17  * Author: Nadav Hollander (nadav at dharma.io)
18  */
19 contract ERC721 {
20     // Function
21     function totalSupply() public view returns (uint256 _totalSupply);
22     function balanceOf(address _owner) public view returns (uint256 _balance);
23     function ownerOf(uint _tokenId) public view returns (address _owner);
24     function approve(address _to, uint _tokenId) public;
25     function getApproved(uint _tokenId) public view returns (address _approved);
26     function transferFrom(address _from, address _to, uint _tokenId) public;
27     function transfer(address _to, uint _tokenId) public;
28     function implementsERC721() public view returns (bool _implementsERC721);
29 
30     // Events
31     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
32     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
33 
34     // Optional Operator Extension
35     event AuthorizedOperator(address indexed _owner, address indexed _operator);
36     event RevokedOperator(address indexed _owner, address indexed _operator);
37     function authorizeOperator(address _operator) public;
38     function revokeOperator(address _operator) public;
39     function isOperatorFor(address _operator, address _owner) public constant returns (bool);
40 }
41 
42 /**
43  * Interface for optional functionality in the ERC721 standard
44  * for non-fungible tokens.
45  *
46  * Author: Nadav Hollander (nadav at dharma.io)
47  */
48 contract DetailedERC721 is ERC721 {
49     function name() public view returns (string _name);
50     function symbol() public view returns (string _symbol);
51     function tokenMetadata(uint _tokenId) public view returns (string _infoUrl);
52     function tokenOfOwnerByIndex(address _owner, uint _index) public view returns (uint _tokenId);
53 }
54 
55 /**
56  * @title NonFungibleToken
57  *
58  * Generic implementation for both required and optional functionality in
59  * the ERC721 standard for non-fungible tokens.
60  *
61  * Heavily inspired by Decentraland's generic implementation:
62  * https://github.com/decentraland/land/blob/master/contracts/BasicNFT.sol
63  *
64  * Standard Author: dete
65  * Implementation Author: Nadav Hollander <nadav at dharma.io>
66  */
67 contract NonFungibleToken is DetailedERC721 {
68     string public name;
69     string public symbol;
70 
71     uint public numTokensTotal;
72 
73     mapping(uint => address) internal tokenIdToOwner;
74     mapping(uint => address) internal tokenIdToApprovedAddress;
75     mapping(uint => string) internal tokenIdToMetadata;
76     mapping(address => uint[]) internal ownerToTokensOwned;
77     mapping(uint => uint) internal tokenIdToOwnerArrayIndex;
78     mapping(address => mapping(address => bool)) internal ownerToOperators;
79 
80     modifier onlyExtantToken(uint _tokenId) {
81         require(ownerOf(_tokenId) != address(0));
82         _;
83     }
84 
85     function name()
86         public
87         view
88         returns (string _name)
89     {
90         return name;
91     }
92 
93     function symbol()
94         public
95         view
96         returns (string _symbol)
97     {
98         return symbol;
99     }
100 
101     function totalSupply()
102         public
103         view
104         returns (uint256 _totalSupply)
105     {
106         return numTokensTotal;
107     }
108 
109     function balanceOf(address _owner)
110         public
111         view
112         returns (uint _balance)
113     {
114         return ownerToTokensOwned[_owner].length;
115     }
116 
117     function ownerOf(uint _tokenId)
118         public
119         view
120         returns (address _owner)
121     {
122         return _ownerOf(_tokenId);
123     }
124 
125     function tokenMetadata(uint _tokenId)
126         public
127         view
128         returns (string _infoUrl)
129     {
130         return tokenIdToMetadata[_tokenId];
131     }
132 
133     function approve(address _to, uint _tokenId)
134         public
135         onlyExtantToken(_tokenId)
136     {
137         require(msg.sender == ownerOf(_tokenId) || isOperatorFor(msg.sender, ownerOf(_tokenId)));
138         require(msg.sender != _to);
139 
140         if (_getApproved(_tokenId) != address(0) ||
141                 _to != address(0)) {
142             _approve(_to, _tokenId);
143             Approval(msg.sender, _to, _tokenId);
144         }
145     }
146 
147     function authorizeOperator(address _operator) public {
148       ownerToOperators[msg.sender][_operator] = true;
149       AuthorizedOperator(msg.sender, _operator);
150     }
151 
152     function revokeOperator(address _operator) public {
153       ownerToOperators[msg.sender][_operator] = false;
154       RevokedOperator(msg.sender, _operator);
155     }
156 
157     function isOperatorFor(address _operator, address _owner) public constant returns (bool) {
158       return ownerToOperators[_owner][_operator];
159     }
160 
161     function transferFrom(address _from, address _to, uint _tokenId)
162         public
163         onlyExtantToken(_tokenId)
164     {
165         require(getApproved(_tokenId) == msg.sender);
166         require(ownerOf(_tokenId) == _from);
167         require(_to != address(0));
168 
169         _clearApprovalAndTransfer(_from, _to, _tokenId);
170 
171         Approval(_from, 0, _tokenId);
172         Transfer(_from, _to, _tokenId);
173     }
174 
175     function transfer(address _to, uint _tokenId)
176         public
177         onlyExtantToken(_tokenId)
178     {
179         require(ownerOf(_tokenId) == msg.sender || isOperatorFor(msg.sender, ownerOf(_tokenId)));
180         require(_to != address(0));
181 
182         _clearApprovalAndTransfer(msg.sender, _to, _tokenId);
183 
184         Approval(msg.sender, 0, _tokenId);
185         Transfer(msg.sender, _to, _tokenId);
186     }
187 
188     function tokenOfOwnerByIndex(address _owner, uint _index)
189         public
190         view
191         returns (uint _tokenId)
192     {
193         return _getOwnerTokenByIndex(_owner, _index);
194     }
195 
196     function getOwnerTokens(address _owner)
197         public
198         view
199         returns (uint[] _tokenIds)
200     {
201         return _getOwnerTokens(_owner);
202     }
203 
204     function implementsERC721()
205         public
206         view
207         returns (bool _implementsERC721)
208     {
209         return true;
210     }
211 
212     function getApproved(uint _tokenId)
213         public
214         view
215         returns (address _approved)
216     {
217         return _getApproved(_tokenId);
218     }
219 
220     function approvedFor(uint _tokenId)
221         public
222         view
223         returns (address _approved)
224     {
225         return _getApproved(_tokenId);
226     }
227 
228     function _clearApprovalAndTransfer(address _from, address _to, uint _tokenId)
229         internal
230     {
231         _clearTokenApproval(_tokenId);
232         _removeTokenFromOwnersList(_from, _tokenId);
233         _setTokenOwner(_tokenId, _to);
234         _addTokenToOwnersList(_to, _tokenId);
235     }
236 
237     function _ownerOf(uint _tokenId)
238         internal
239         view
240         returns (address _owner)
241     {
242         return tokenIdToOwner[_tokenId];
243     }
244 
245     function _approve(address _to, uint _tokenId)
246         internal
247     {
248         tokenIdToApprovedAddress[_tokenId] = _to;
249     }
250 
251     function _getApproved(uint _tokenId)
252         internal
253         view
254         returns (address _approved)
255     {
256         return tokenIdToApprovedAddress[_tokenId];
257     }
258 
259     function _getOwnerTokens(address _owner)
260         internal
261         view
262         returns (uint[] _tokens)
263     {
264         return ownerToTokensOwned[_owner];
265     }
266 
267     function _getOwnerTokenByIndex(address _owner, uint _index)
268         internal
269         view
270         returns (uint _tokens)
271     {
272         return ownerToTokensOwned[_owner][_index];
273     }
274 
275     function _clearTokenApproval(uint _tokenId)
276         internal
277     {
278         tokenIdToApprovedAddress[_tokenId] = address(0);
279     }
280 
281     function _setTokenOwner(uint _tokenId, address _owner)
282         internal
283     {
284         tokenIdToOwner[_tokenId] = _owner;
285     }
286 
287     function _addTokenToOwnersList(address _owner, uint _tokenId)
288         internal
289     {
290         ownerToTokensOwned[_owner].push(_tokenId);
291         tokenIdToOwnerArrayIndex[_tokenId] = ownerToTokensOwned[_owner].length - 1;
292     }
293 
294     function _removeTokenFromOwnersList(address _owner, uint _tokenId)
295         internal
296     {
297         uint length = ownerToTokensOwned[_owner].length;
298         uint index = tokenIdToOwnerArrayIndex[_tokenId];
299         uint swapToken = ownerToTokensOwned[_owner][length - 1];
300 
301         ownerToTokensOwned[_owner][index] = swapToken;
302         tokenIdToOwnerArrayIndex[swapToken] = index;
303 
304         delete ownerToTokensOwned[_owner][length - 1];
305         ownerToTokensOwned[_owner].length--;
306     }
307 
308     function _insertTokenMetadata(uint _tokenId, string _metadata)
309         internal
310     {
311         tokenIdToMetadata[_tokenId] = _metadata;
312     }
313 }
314 
315 /**
316  * @title SafeMath
317  * @dev Math operations with safety checks that throw on error
318  */
319 library SafeMath {
320 
321   /**
322   * @dev Multiplies two numbers, throws on overflow.
323   */
324   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
325     if (a == 0) {
326       return 0;
327     }
328     uint256 c = a * b;
329     assert(c / a == b);
330     return c;
331   }
332 
333   /**
334   * @dev Integer division of two numbers, truncating the quotient.
335   */
336   function div(uint256 a, uint256 b) internal pure returns (uint256) {
337     // assert(b > 0); // Solidity automatically throws when dividing by 0
338     uint256 c = a / b;
339     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
340     return c;
341   }
342 
343   /**
344   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
345   */
346   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
347     assert(b <= a);
348     return a - b;
349   }
350 
351   /**
352   * @dev Adds two numbers, throws on overflow.
353   */
354   function add(uint256 a, uint256 b) internal pure returns (uint256) {
355     uint256 c = a + b;
356     assert(c >= a);
357     return c;
358   }
359 }
360 
361 /**
362  * @title MintableNonFungibleToken
363  *
364  * Superset of the ERC721 standard that allows for the minting
365  * of non-fungible tokens.
366  */
367 contract MintableNonFungibleToken is NonFungibleToken {
368     using SafeMath for uint;
369 
370     event Mint(address indexed _to, uint256 indexed _tokenId);
371 
372     modifier onlyNonexistentToken(uint _tokenId) {
373         require(tokenIdToOwner[_tokenId] == address(0));
374         _;
375     }
376 
377     function mint(address _owner, uint256 _tokenId, address _approvedAddress, string _metadata)
378         public
379         onlyNonexistentToken(_tokenId)
380     {
381         _setTokenOwner(_tokenId, _owner);
382         _addTokenToOwnersList(_owner, _tokenId);
383         _approve(_approvedAddress, _tokenId);
384         _insertTokenMetadata(_tokenId, _metadata);
385 
386         numTokensTotal = numTokensTotal.add(1);
387 
388         Mint(_owner, _tokenId);
389     }
390 }