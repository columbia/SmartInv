1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath
8 {
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title SafeMath32
51  * @dev SafeMath library implemented for uint32
52  */
53 library SafeMath32
54 {
55   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
56     if (a == 0) {
57       return 0;
58     }
59     uint32 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint32 a, uint32 b) internal pure returns (uint32) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint32 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint32 a, uint32 b) internal pure returns (uint32) {
77     uint32 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title SafeMath16
85  * @dev SafeMath library implemented for uint16
86  */
87 library SafeMath16
88 {
89   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
90     if (a == 0) {
91       return 0;
92     }
93     uint16 c = a * b;
94     assert(c / a == b);
95     return c;
96   }
97 
98   function div(uint16 a, uint16 b) internal pure returns (uint16) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint16 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   function add(uint16 a, uint16 b) internal pure returns (uint16) {
111     uint16 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 pragma solidity ^0.4.24;
117 
118 /**
119  * @title DeSocializedAdmin
120  * @author Chad R. Banks
121  * @dev This contract provides basic authorization control functions.
122  */
123  
124 
125 contract DeSocializedAdmin
126 {
127     using SafeMath for uint256;
128     using SafeMath32 for uint32;
129     using SafeMath16 for uint16;
130 
131     mapping (address => uint256) admins;
132     mapping (string => uint256) options;
133     
134     address public feewallet;
135     
136     event AdminOptionChange(address indexed admin, string option, uint256 value);
137     event AdminStatusChange(address indexed admin, uint256 newStatus);
138     event AdminWalletChange(address indexed admin, address indexed wallet);
139     event AdminWithdrawl(address indexed admin, uint256 amount);
140   
141     /**
142     * @dev The DeSocializedAdmin constructor sets the original values.
143     */
144     constructor() public
145     {
146         feewallet = msg.sender;
147         admins[msg.sender] = 100;
148         options["likefee"] = 1000000000000;     // 0.000001 ETH
149         options["dissfee"] = 1000000000000;     // 0.000001 ETH
150         options["minefee"] = 10000000000000;    // 0.00001 ETH
151         options["regifee"] = 10000000000000000; // 0.01 ETH
152     }
153   
154     /**
155     * @dev Throws if called by any address other than an admin.
156     */
157     modifier onlyAdmin()
158     {
159         require(admins[msg.sender] >= 1);
160         _;
161     }
162   
163     /**
164     * @dev Allows the current owner to add/remove another admins status.
165     */
166     function setAdminStatus(address user, uint status) public onlyAdmin
167     {
168         require(user != address(0));
169         require(status <= admins[msg.sender]);
170         require(admins[user] <= admins[msg.sender]);
171         admins[user] = status;
172         emit AdminStatusChange(user, status);
173     }
174     
175     /**
176      * @dev Return the admin status for another address.
177      */
178     function getAdminStatus(address user) public view returns(uint)
179     {
180         return admins[user];
181     }
182     
183     /**
184      * @dev Change the wallet that funds are stored in.
185      */
186     function setFeeWallet(address _wallet) public onlyAdmin
187     {
188         feewallet = _wallet;
189         emit AdminWalletChange(msg.sender, _wallet);
190     }
191     
192     /**
193      * @dev Change an options value.
194      */
195     function setOption(string option, uint value) public onlyAdmin
196     {
197         options[option] = value;
198         emit AdminOptionChange(msg.sender, option, value);
199     }
200     
201     /**
202      * @dev Returns the option value for a given key.
203      */
204     function getOption(string option) public view returns(uint)
205     {
206         return options[option];
207     }
208     
209     /**
210      * @dev Returns the eth balance of this wallet
211      */
212     function getWalletBalance( ) public view returns(uint)
213     {
214         return address(this).balance;
215     }
216     
217     /**
218      * @dev Withdraw funds from this contract.
219      */
220     function withdrawl(uint amt) external onlyAdmin
221     {
222         require(amt <= address(this).balance);
223         msg.sender.transfer(amt);
224         emit AdminWithdrawl(msg.sender, amt);
225     }
226 }
227 pragma solidity ^0.4.24;
228 
229 /**
230  * @title DeSocializedMain
231  * @author Chad R. Banks
232  * @dev The DeSocializedMain will hold the basic social media functionality.
233  */
234 
235 
236 contract DeSocializedMain is DeSocializedAdmin
237 {
238     using SafeMath for uint256;
239     using SafeMath32 for uint32;
240     using SafeMath16 for uint16;
241 
242     struct Block
243     {
244         address poster;
245         string message;
246         uint dislikes;
247         uint likes;
248         uint mined;
249         uint id;
250     }
251 
252     Block[] public blocks;
253     
254     mapping (uint => address) public blockToOwner;
255     mapping (address => uint) ownerBlockCount;
256     
257     mapping (string => address) handleToAddress;
258     mapping (address => string) public addressToHandle;
259     
260     event NewBlock(uint pid, address sender);
261     event BlockLiked(uint pid, uint value);
262     event BlockDisliked(uint pid, uint value);
263     event HandleRegistered(address _user, string _handle);
264     event AdminHandleRegistered(address _admin, address _user, string _handle);
265 
266     /**
267      * @dev saveBlock is how users post new content.
268      */
269     function saveBlock( string _m ) public payable
270     {
271         require(msg.value >= options["minefee"]);
272         feewallet.transfer(msg.value);
273         
274         uint id = blocks.push( Block( msg.sender, _m, 0, 0, uint(now), 0 ) ) - 1;
275         blocks[id].id = id;
276         blockToOwner[id] = msg.sender;
277         ownerBlockCount[msg.sender] = ownerBlockCount[msg.sender].add(1);
278         
279         emit NewBlock(id, msg.sender);
280     }
281     
282     /**
283      * @dev Allows a user to like another users block.
284      */
285     function likeBlock( uint _bid ) public payable
286     {
287         require(msg.value >= options["likefee"]);
288         address owner = blockToOwner[_bid];
289         owner.transfer(msg.value);
290         
291         Block storage b = blocks[_bid];
292         b.likes = b.likes.add(1);
293         
294         emit BlockLiked(_bid, msg.value);
295     }
296 
297     /**
298      * @dev Allows a user to dislike another users block.
299      */
300     function dissBlock( uint _bid ) public payable
301     {
302         require(msg.value >= options["dissfee"]);
303         feewallet.transfer(msg.value);
304         
305         Block storage b = blocks[_bid];
306         b.dislikes = b.dislikes.add(1);
307         
308         emit BlockDisliked(_bid, msg.value);
309     }
310     
311     
312     /**
313      * @dev This will allow an admin to register a user.
314      */
315     function registerUser( address _user, string _handle ) public onlyAdmin
316     {
317         require( handleToAddress[ _handle ] == 0 );
318         _verify( _user, _handle );
319         
320         emit AdminHandleRegistered(msg.sender, _user, _handle);
321     }
322     
323     /**
324      * @dev Allows general users to register their handle.
325      */
326     function register( string _handle ) public payable
327     {
328         require( handleToAddress[ _handle ] == 0 );
329         
330         uint fee = options["regifee"];
331         require(msg.value >= fee);
332         feewallet.transfer(fee);
333         
334         _verify( msg.sender, _handle );
335         
336         emit HandleRegistered(msg.sender, _handle);
337     }
338     
339     /**
340      * @dev Internal verify function.
341      */
342     function _verify( address _user, string _handle ) internal
343     {
344         if( keccak256( abi.encodePacked(addressToHandle[ _user ]) ) != keccak256( abi.encodePacked("") ) )
345         {
346             handleToAddress[ addressToHandle[ _user ] ] = 0;
347         }
348         
349         addressToHandle[ _user ] = _handle;
350         handleToAddress[ _handle ] = _user;
351     }
352     
353     
354     /**
355      * @dev Get a certain number of blocks in ascending order.
356      */
357     function getBlocks(uint _bid, uint _len) external view returns(uint[])
358     {
359         uint[] memory result = new uint[](_len);
360         uint counter = 0;
361         for (uint i = _bid; i < (_bid+_len); i++)
362         {
363             if( blockToOwner[i] != 0 )
364             {
365                 result[counter] = i;
366                 counter++;
367             }
368         }
369         return result;
370     }
371 
372     /**
373      * @dev Get a certain number of blocks in descending order.
374      */
375     function getBlocksDesc(uint _bid, uint _len) external view returns(uint[])
376     {
377         uint[] memory result = new uint[](_len);
378         uint counter = 0;
379         
380         if(_bid == 0)
381         {
382             for (uint i = blocks.length; i > (blocks.length-_len); i--)
383             {
384                 if( blockToOwner[i] != 0 && counter < _len )
385                 {
386                     result[counter] = i;
387                     counter++;
388                 }
389             }
390         }
391         else
392         {
393             for (uint x = _bid; x > (_bid-_len); x--)
394             {
395                 if( blockToOwner[x] != 0 && counter < _len )
396                 {
397                     result[counter] = x;
398                     counter++;
399                 }
400             }
401         }
402         
403         return result;
404     }
405     
406     /**
407      * @dev Get a certain number of an addresses blocks in ascending order.
408      */
409     function getBlocksByOwner(uint _bid, uint _len, address _owner) external view returns(uint[])
410     {
411         uint[] memory result = new uint[](_len);
412         uint counter = 0;
413         for (uint i = _bid; i < (_bid+_len); i++)
414         {
415             if (blockToOwner[i] == _owner)
416             {
417                 result[counter] = i;
418                 counter++;
419             }
420         }
421         return result;
422     }
423 
424     /**
425      * @dev Get a certain number of an addresses blocks in descending order.
426      */
427     function getBlocksByOwnerDesc(uint _bid, uint _len, address _owner) external view returns(uint[])
428     {
429         uint[] memory result = new uint[](_len);
430         uint counter = 0;
431         
432         if(_bid == 0)
433         {
434             for (uint i = blocks.length; i > (blocks.length-_len); i--)
435             {
436                 if (blockToOwner[i] == _owner && counter < _len )
437                 {
438                     result[counter] = i;
439                     counter++;
440                 }
441             }
442         }
443         else
444         {
445             for (uint x = _bid; x > (_bid-_len); x--)
446             {
447                 if (blockToOwner[x] == _owner && counter < _len )
448                 {
449                     result[counter] = x;
450                     counter++;
451                 }
452             }
453         }
454         return result;
455     }
456 
457     /**
458      * @dev Get all blocks for a given address.
459      */
460     function getAllBlocksByOwner(address _owner) external view returns(uint[])
461     {
462         uint[] memory result = new uint[](ownerBlockCount[_owner]);
463         uint counter = 0;
464         for (uint i = 0; i < blocks.length; i++)
465         {
466             if (blockToOwner[i] == _owner)
467             {
468                 result[counter] = i;
469                 counter++;
470             }
471         }
472         return result;
473     }
474 
475     /**
476      * @dev Return the number of owners an address has.
477      */
478     function balanceOf(address _owner) public view returns (uint256 _balance)
479     {
480         return ownerBlockCount[_owner];
481     }
482     
483     /**
484      * @dev Return the address of a blocks owner.
485      */
486     function ownerOf(uint256 _tokenId) public view returns (address _owner)
487     {
488         return blockToOwner[_tokenId];
489     }
490     
491     /**
492      * @dev Return the address of a blocks owner.
493      */
494     function getUserPair( address _user ) public view returns (address, string)
495     {
496         return ( _user, addressToHandle[_user] );
497     }
498 }