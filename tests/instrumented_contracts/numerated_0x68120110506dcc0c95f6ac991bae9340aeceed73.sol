1 pragma solidity ^0.4.25;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2019 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * TL;DR - A simple posts manager.
9  * 
10  *         TL;DR is slang for "Too Long; Didn't Read"
11  *
12  * Version 19.3.15
13  *
14  * https://d14na.org
15  * support@d14na.org
16  */
17 
18 
19 /*******************************************************************************
20  *
21  * ERC Token Standard #20 Interface
22  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
23  */
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 
37 /*******************************************************************************
38  *
39  * ECRecovery
40  *
41  * Contract function to validate signature of pre-approved token transfers.
42  * (borrowed from LavaWallet)
43  */
44 contract ECRecovery {
45     function recover(bytes32 hash, bytes sig) public pure returns (address);
46 }
47 
48 
49 /*******************************************************************************
50  *
51  * Owned contract
52  */
53 contract Owned {
54     address public owner;
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         newOwner = _newOwner;
70     }
71 
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74 
75         emit OwnershipTransferred(owner, newOwner);
76 
77         owner = newOwner;
78 
79         newOwner = address(0);
80     }
81 }
82 
83 
84 /*******************************************************************************
85  * 
86  * Zer0netDb Interface
87  */
88 contract Zer0netDbInterface {
89     /* Interface getters. */
90     function getAddress(bytes32 _key) external view returns (address);
91     function getBool(bytes32 _key)    external view returns (bool);
92     function getBytes(bytes32 _key)   external view returns (bytes);
93     function getInt(bytes32 _key)     external view returns (int);
94     function getString(bytes32 _key)  external view returns (string);
95     function getUint(bytes32 _key)    external view returns (uint);
96 
97     /* Interface setters. */
98     function setAddress(bytes32 _key, address _value) external;
99     function setBool(bytes32 _key, bool _value) external;
100     function setBytes(bytes32 _key, bytes _value) external;
101     function setInt(bytes32 _key, int _value) external;
102     function setString(bytes32 _key, string _value) external;
103     function setUint(bytes32 _key, uint _value) external;
104 
105     /* Interface deletes. */
106     function deleteAddress(bytes32 _key) external;
107     function deleteBool(bytes32 _key) external;
108     function deleteBytes(bytes32 _key) external;
109     function deleteInt(bytes32 _key) external;
110     function deleteString(bytes32 _key) external;
111     function deleteUint(bytes32 _key) external;
112 }
113 
114 
115 /*******************************************************************************
116  *
117  * @notice TL;DR
118  *
119  * @dev Simple key-value store of short posts.
120  */
121 contract TLDR is Owned {
122     /* Initialize predecessor contract. */
123     address private _predecessor;
124 
125     /* Initialize successor contract. */
126     address private _successor;
127     
128     /* Initialize revision number. */
129     uint private _revision;
130 
131     /* Initialize Zer0net Db contract. */
132     Zer0netDbInterface private _zer0netDb;
133     
134     /* Set namespace. */
135     string _namespace = 'tldr';
136 
137     event Posted(
138         bytes32 indexed postId,
139         address indexed owner,
140         bytes body
141     );
142 
143     /***************************************************************************
144      *
145      * Constructor
146      */
147     constructor() public {
148         /* Initialize Zer0netDb (eternal) storage database contract. */
149         // NOTE We hard-code the address here, since it should never change.
150         _zer0netDb = Zer0netDbInterface(0xE865Fe1A1A3b342bF0E2fcB11fF4E3BCe58263af);
151 
152         /* Initialize (aname) hash. */
153         bytes32 hash = keccak256(abi.encodePacked('aname.', _namespace));
154 
155         /* Set predecessor address. */
156         _predecessor = _zer0netDb.getAddress(hash);
157 
158         /* Verify predecessor address. */
159         if (_predecessor != 0x0) {
160             /* Retrieve the last revision number (if available). */
161             uint lastRevision = TLDR(_predecessor).getRevision();
162             
163             /* Set (current) revision number. */
164             _revision = lastRevision + 1;
165         }
166     }
167 
168     /**
169      * @dev Only allow access to an authorized Zer0net administrator.
170      */
171     modifier onlyAuthBy0Admin() {
172         /* Verify write access is only permitted to authorized accounts. */
173         require(_zer0netDb.getBool(keccak256(
174             abi.encodePacked(msg.sender, '.has.auth.for.', _namespace))) == true);
175 
176         _;      // function code is inserted here
177     }
178 
179     /**
180      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
181      */
182     function () public payable {
183         /* Cancel this transaction. */
184         revert('Oops! Direct payments are NOT permitted here.');
185     }
186 
187 
188     /***************************************************************************
189      * 
190      * ACTIONS
191      * 
192      */
193 
194     /**
195      * Save Post
196      */
197     function savePost(
198         string _title,
199         bytes _body
200     ) external returns (bool success) {
201         _setPost(msg.sender, _title, _body);
202 
203         /* Return success. */
204         return true;
205     }
206     
207     // function addFavorite(
208     //     bytes32 _postId
209     // ) external returns (bool success) {
210     //     bytes32[] storage favorites = _favorites[msg.sender];
211         
212     //     /* Add to favorites. */
213     //     favorites.push(_postId);
214         
215     //     /* Return success. */
216     //     return true;
217     // }
218 
219     // function removeFavorite(
220     //     bytes32 _postId
221     // ) external returns (bool success) {
222     //     bytes32[] storage favorites = _favorites[msg.sender];
223         
224     //     /* Add to favorites. */
225     //     favorites.push(_postId);
226         
227     //     /* Return success. */
228     //     return true;
229     // }
230 
231 
232     /***************************************************************************
233      * 
234      * GETTERS
235      * 
236      */
237 
238     /**
239      * Get Post (Metadata)
240      * 
241      * Retrieves the location and block number of the post data
242      * stored for the specified `_postId`.
243      * 
244      * NOTE: DApps can then read the `Posted` event from the Ethereum 
245      *       Event Log, at the specified point, to recover the stored metadata.
246      */
247     function getPost(
248         bytes32 _postId
249     ) external view returns (
250         address location,
251         uint blockNum
252     ) {
253         /* Retrieve location. */
254         location = _zer0netDb.getAddress(_postId);
255 
256         /* Retrieve block number. */
257         blockNum = _zer0netDb.getUint(_postId);
258     }
259 
260     // function getFavorites(
261     //     address _owner
262     // ) external view returns (bytes32[] favorites) {
263     //     favorites = _favorites[_owner];
264     // }
265 
266     /**
267      * Get Revision (Number)
268      */
269     function getRevision() public view returns (uint) {
270         return _revision;
271     }
272 
273     /**
274      * Get Predecessor (Address)
275      */
276     function getPredecessor() public view returns (address) {
277         return _predecessor;
278     }
279     
280     /**
281      * Get Successor (Address)
282      */
283     function getSuccessor() public view returns (address) {
284         return _successor;
285     }
286     
287 
288     /***************************************************************************
289      * 
290      * SETTERS
291      * 
292      */
293 
294     /**
295      * Set Post (Metadata)
296      * 
297      * Stores the location and block number of the metadata being added 
298      * to the Ethereum Event Log.
299      * 
300      * Cost to Broadcast an Event
301      * ---------------------------------------
302      *         8 gas per byte of `_data`
303      *     + 375 gas per LOG operation
304      *     + 375 gas per topic
305      */
306     function _setPost(
307         address _owner, 
308         string _title,
309         bytes _body
310     ) private returns (bool success) {
311         /* Calculate post id. */
312         bytes32 postId = calcPostId(_owner, _title);
313         
314         /* Set location. */
315         _zer0netDb.setAddress(postId, address(this));
316 
317         /* Set block number. */
318         _zer0netDb.setUint(postId, block.number);
319 
320         /* Broadcast event. */
321         emit Posted(postId, _owner, _body);
322 
323         /* Return success. */
324         return true;
325     }
326 
327     /**
328      * Set Successor
329      * 
330      * This is the contract address that replaced this current instnace.
331      */
332     function setSuccessor(
333         address _newSuccessor
334     ) onlyAuthBy0Admin external returns (bool success) {
335         /* Set successor contract. */
336         _successor = _newSuccessor;
337         
338         /* Return success. */
339         return true;
340     }
341 
342 
343     /***************************************************************************
344      * 
345      * INTERFACES
346      * 
347      */
348 
349     /**
350      * Supports Interface (EIP-165)
351      * 
352      * (see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md)
353      * 
354      * NOTE: Must support the following conditions:
355      *       1. (true) when interfaceID is 0x01ffc9a7 (EIP165 interface)
356      *       2. (false) when interfaceID is 0xffffffff
357      *       3. (true) for any other interfaceID this contract implements
358      *       4. (false) for any other interfaceID
359      */
360     function supportsInterface(
361         bytes4 _interfaceID
362     ) external pure returns (bool) {
363         /* Initialize constants. */
364         bytes4 InvalidId = 0xffffffff;
365         bytes4 ERC165Id = 0x01ffc9a7;
366 
367         /* Validate condition #2. */
368         if (_interfaceID == InvalidId) {
369             return false;
370         }
371 
372         /* Validate condition #1. */
373         if (_interfaceID == ERC165Id) {
374             return true;
375         }
376         
377         // TODO Add additional interfaces here.
378         
379         /* Return false (for condition #4). */
380         return false;
381     }
382 
383 
384     /***************************************************************************
385      * 
386      * UTILITIES
387      * 
388      */
389 
390     /**
391      * Calculate Post Id
392      */
393     function calcPostId(
394         address _owner,
395         string _title
396     ) public view returns (
397         bytes32 postId
398     ) {
399         /* Calculate the post id. */
400         postId = keccak256(abi.encodePacked(
401             _namespace, '.', _owner, '.', _title));
402     }
403 
404     /**
405      * Transfer Any ERC20 Token
406      *
407      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
408      *
409      * @dev Provides an ERC20 interface, which allows for the recover
410      *      of any accidentally sent ERC20 tokens.
411      */
412     function transferAnyERC20Token(
413         address _tokenAddress, 
414         uint _tokens
415     ) public onlyOwner returns (bool success) {
416         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
417     }
418 }