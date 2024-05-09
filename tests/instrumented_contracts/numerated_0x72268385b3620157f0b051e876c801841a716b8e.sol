1 /**
2  * Token name: KT
3  * Interface: ERC721
4  * This token is established by Krypital Group LLC, mainly used as a gift for Krypital supporters.
5  * Total supply of KTs is set to 2100.
6  * A KT holder can either hold it as a souvenir (leave message on the message board), or play the game by merging/decomposing tokens.
7  */
8 
9 pragma solidity ^0.4.19;
10 
11 
12 /**
13  * @title safemath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library safemath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 
59 
60 /**
61  * @title ownable
62  * @dev The ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract ownable {
66   address public owner;
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor () public {
75     owner = msg.sender;
76   }
77 
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address newOwner) public onlyOwner {
93     require(newOwner != address(0));
94     emit OwnershipTransferred(owner, newOwner);
95     owner = newOwner;
96   }
97 
98 }
99 
100 
101 contract erc721 {
102   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
103   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
104 
105   function balanceOf(address _owner) public view returns (uint256 _balance);
106   function ownerOf(uint256 _tokenId) public view returns (address _owner);
107   function transfer(address _to, uint256 _tokenId) public;
108   function approve(address _to, uint256 _tokenId) public;
109   function takeOwnership(uint256 _tokenId) public;
110 }
111 
112 
113 /**
114  *  @title KTaccess
115  *  @author Yihan -- CyberMiles
116  *  @dev This contract is for regulating the owners' addr.
117  *  Inherited by KTfactory.
118  */
119 contract KTaccess is ownable{
120     address public o1Address;
121     address public o2Address;
122     address public o3Address;
123     
124     modifier onlyOLevel() {
125         require(
126             msg.sender == o1Address ||
127             msg.sender == o2Address ||
128             msg.sender == o3Address ||
129             msg.sender == owner
130         );
131         _;
132     }
133 
134     function setO1(address _newAddr) external onlyOLevel {
135         require(_newAddr != address(0));
136 
137         o1Address = _newAddr;
138     }
139 
140     function setO2(address _newAddr) external onlyOLevel {
141         require(_newAddr != address(0));
142 
143         o2Address = _newAddr;
144     }
145     
146     function setO3(address _newAddr) external onlyOLevel {
147         require(_newAddr != address(0));
148 
149         o3Address = _newAddr;
150     }
151 
152 }
153 
154 
155 /**
156  * @title KTfactory
157  * @author Yihan -- CyberMiles
158  * @dev This main contract for creating KTs.
159  * 
160  * A KT, which is the token issued by Krypital, has the following properties: 
161  * an officail note that can be created only by the contract owner;
162  * a personal note that can be modified by the current owner of the token;
163  * a bool value indicating if the token is currently frozen by Krypital;
164  * a gene which is a hashed value that changes when mutate (merge or decompose). This is for some future interesting apps :D 
165  * level, namely, the level of the token. Apparently higher is better :D
166  * id, the key used to map to the associated KT.
167  * 
168  */
169 
170 contract KTfactory is ownable, KTaccess {
171 
172   using safemath for uint256;
173 
174   uint256 public maxId;
175 
176   uint256 public initial_supply;
177 
178   uint256 public curr_number;
179 
180   event NewKT(string note, uint256 gene, uint256 level, uint256 tokenId);
181   event UpdateNote(string newNote, uint256 tokenId);
182   event PauseToken(uint256 tokenId);
183   event UnpauseToken(uint256 tokenId);
184 
185   struct KT {
186     string officialNote;
187     string personalNote;
188     bool paused;
189     uint256 gene;
190     uint256 level;
191     uint256 id;
192   }
193 
194   mapping (uint256 => KT) public KTs;
195 
196   mapping (uint => address) public KTToOwner;
197   mapping (address => uint) ownerKTCount;
198 
199   modifier onlyOwnerOf(uint token_id) {
200     require(msg.sender == KTToOwner[token_id]);
201     _;
202   }
203 
204   modifier whenNotFrozen(uint token_id) {
205     require(KTs[token_id].paused == false);
206     _;
207   }
208 
209   modifier withinTotal() {
210     require(curr_number<= initial_supply);
211     _;
212   }
213 
214   modifier hasKT(uint token_id) {
215     require(KTs[token_id].id != 0);
216     _;
217   }
218     
219     /**
220      * @dev The constructor. Sets the initial supply and some other global variables.
221      * That's right, Krypital will only issue 2100 tokens in total. It also means the total number of KTs will not exceed this number!
222      */
223   constructor() public {
224     initial_supply = 2100;
225     maxId=0;
226     curr_number=0;
227   }
228 
229     /**
230      * @dev The creator of KTs. Only done by Krypital.
231      * @param oNote - the official, special note left only by Krypital!
232      */
233   function _createKT(string oNote) public onlyOLevel withinTotal {
234     uint thisId = maxId + 1;
235     string pNote;
236     uint256 thisGene = uint256(keccak256(oNote));
237     
238     KT memory thisKT = KT({
239         officialNote: oNote, 
240         personalNote: pNote, 
241         paused: false, 
242         gene: thisGene, 
243         level: 1, 
244         id: thisId
245     });
246     
247     KTs[thisId] = thisKT;
248     maxId = maxId + 1;
249     curr_number = curr_number + 1;
250     KTToOwner[thisId] = msg.sender;
251     ownerKTCount[msg.sender]++;
252     emit NewKT(oNote, thisGene, 1, thisId);
253   }
254     
255     /**
256      * @dev This method is for editing your personal note!
257      * @param note - the note you want the old one to be replaced by
258      * @param token_id - just token id
259      */
260   function _editPersonalNote(string note, uint token_id) public onlyOwnerOf(token_id) hasKT(token_id){
261     KT storage currKT = KTs[token_id];
262     currKT.personalNote = note;
263     emit UpdateNote(note, token_id);
264   }
265     
266     /**
267      * @dev Pauses a token, done by Krypital
268      * When a token is paused by Krypital, the owner of the token can still update the personal note but the ownership cannot be transferred.
269      * @param token_id - just token id
270      */
271   function pauseToken(uint token_id) public onlyOLevel hasKT(token_id){
272     KT storage currKT = KTs[token_id];
273     currKT.paused = true;
274     emit PauseToken(token_id);
275   }
276   
277   /**
278    * @dev Unpauses a token, done by Krypital
279    * @param token_id - just token id
280    */
281   function unpauseToken(uint token_id) public onlyOLevel hasKT(token_id){
282     KT storage currKT = KTs[token_id];
283     currKT.paused = false;
284     emit UnpauseToken(token_id);
285   }
286 
287 }
288 
289 
290 /**
291  * @title KT
292  * @author Yihan -- CyberMiles
293  * @dev This contract is the contract regulating the transfer, decomposition, merging mechanism amaong the tokens.
294  */
295 contract KT is KTfactory, erc721 {
296 
297   using safemath for uint256;
298 
299   mapping (uint => address) KTApprovals;
300   
301   /**
302    * @dev The modifer to regulate a KT's decomposability.
303    * A level 1 KT is not decomposable.
304    * @param token_id - simply token id.
305    */
306   modifier decomposeAllowed(uint token_id){
307     require(KTs[token_id].level > 1);
308     _;
309   }
310 
311   event Decompose(uint256 tokenId);
312   event Merge(uint256 tokenId1, uint256 tokenId2);
313 
314     /**
315      * @dev This is for getting the ether back to the contract owner's account. Just in case someone generous sends the creator some ethers :P
316      */
317   function withdraw() external onlyOwner {
318     owner.transfer(this.balance);
319   }
320 
321     /**
322      * @dev For checking how many tokens you own.
323      * @param _owner - the owner's addr
324      */
325   function balanceOf(address _owner) public view returns(uint256) {
326     return ownerKTCount[_owner];
327   }
328     
329     /**
330      * @dev For checking the owner of the given token.
331      * @param _tokenId - just token id
332      */
333   function ownerOf(uint256 _tokenId) public view returns(address) {
334     return KTToOwner[_tokenId];
335   }
336 
337     /**
338      * @dev the private helper function for transfering ownership.
339      * @param _from - current KT owner
340      * @param _to - new KT owner
341      * @param _tokenId - just token id
342      */
343   function _transfer(address _from, address _to, uint256 _tokenId) private hasKT(_tokenId) {
344     ownerKTCount[_to] = ownerKTCount[_to].add(1);
345     ownerKTCount[msg.sender] = ownerKTCount[msg.sender].sub(1);
346     KTToOwner[_tokenId] = _to;
347     emit Transfer(_from, _to, _tokenId);
348   }
349 
350     /**
351      * @dev This method can be called if you are the token owner and you want to transfer the token to someone else.
352      * @param _to - new KT owner
353      * @param _tokenId - just token id
354      */
355   function transfer(address _to, uint256 _tokenId) public whenNotFrozen(_tokenId) onlyOwnerOf(_tokenId) hasKT(_tokenId){
356     require(_to != address(0));
357     _transfer(msg.sender, _to, _tokenId);
358   }
359     
360     /**
361      * @dev An approved user can 'claim' a token of another user.
362      * @param _to - new KT owner
363      * @param _tokenId - just token id
364      */
365   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) hasKT(_tokenId) {
366     require(_to != address(0));
367     KTApprovals[_tokenId] = _to;
368     emit Approval(msg.sender, _to, _tokenId);
369   }
370     
371     /**
372      * @dev The user to be approved must be approved by the current token holder.
373      * @param _tokenId - just token id
374      */
375   function takeOwnership(uint256 _tokenId) public whenNotFrozen(_tokenId) hasKT(_tokenId){
376     require(KTApprovals[_tokenId] == msg.sender);
377     address owner = ownerOf(_tokenId);
378     _transfer(owner, msg.sender, _tokenId);
379   }
380 
381   /**
382    * @dev This method is for decomposing (or split) a token. Only can be done by token holder when token is not frozen.
383    * Note: one of the tokens will take the original token's place, that is, the old ID will actually map to a new token!
384    * Level down by 1!!! A level 1 token cannot be decomposed.
385    * The genes of the two new born tokens will be both identical to the old token.
386    * Notes of the two new tokens are identical to the original token.
387    */
388   function decompose(uint256 token_id) public whenNotFrozen(token_id) onlyOwnerOf(token_id) decomposeAllowed(token_id) hasKT(token_id) withinTotal{
389     KT storage decomposed = KTs[token_id];
390     decomposed.level = decomposed.level-1;
391     decomposed.gene = decomposed.gene/2;
392 
393     KT memory newKT = KT({
394       officialNote: decomposed.officialNote,
395       personalNote: decomposed.personalNote,
396       paused: false,
397       gene: decomposed.gene,
398       level: decomposed.level,
399       id: maxId.add(1)
400     });
401     
402     maxId=maxId.add(1);
403     curr_number=curr_number.add(1);
404     KTs[maxId]=newKT;
405     KTToOwner[maxId]=KTToOwner[token_id];
406     ownerKTCount[msg.sender]=ownerKTCount[msg.sender].add(1);
407 
408     emit Decompose(token_id);
409   }
410 
411     /**
412      * @dev This function is for merging 2 tokens. Only tokens with the same levels can be merge. A user can only choose to merge from his own tokens.
413      * After merging, id and official note are merged to the previous token passed in the args.
414      * NOTE that the notes associated with the second token will be wiped out! Use with your caution.
415      * Level up by 1!!!
416      * New gene = (gene1 + gene2) / 2
417      * @param id1 - the ID to the 1st token, this ID will remain after merging.
418      * @param id2 - the ID of the 2nd token, this ID will map to nothing after merging!!
419      */
420   function merge(uint256 id1, uint256 id2) public hasKT(id1) hasKT(id2) whenNotFrozen(id1) whenNotFrozen(id2) onlyOwnerOf(id1) onlyOwnerOf(id2){
421     require(KTs[id1].level == KTs[id2].level);
422     KT storage token1 = KTs[id1];
423     token1.gene = (token1.gene + KTs[id2].gene) / 2;
424     token1.level = (token1.level).add(1);
425 
426     KT memory toDelete = KT ({
427       officialNote: "",
428       personalNote: "",
429       paused: false,
430       gene: 0,
431       level: 0,
432       id: 0
433     });
434 
435     KTs[id2] = toDelete;
436     curr_number = curr_number.sub(1);
437     KTToOwner[id2] = address(0);
438     ownerKTCount[msg.sender] = ownerKTCount[msg.sender].sub(1);
439 
440     emit Merge(id1, id2);
441   }
442   
443 }