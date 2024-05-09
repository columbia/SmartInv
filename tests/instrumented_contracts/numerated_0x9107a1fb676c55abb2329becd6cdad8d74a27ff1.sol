1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     if (a == 0) {
12       return 0;
13     }
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) public view returns (uint256);
72   function transferFrom(address from, address to, uint256 value) public returns (bool);
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 
80 
81 /**
82  * @title SafeERC20
83  * @dev Wrappers around ERC20 operations that throw on failure.
84  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
85  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
86  */
87 library SafeERC20 {
88   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
89     assert(token.transfer(to, value));
90   }
91 
92   function safeTransferFrom(
93     ERC20 token,
94     address from,
95     address to,
96     uint256 value
97   )
98     internal
99   {
100     assert(token.transferFrom(from, to, value));
101   }
102 
103   function safeApprove(ERC20 token, address spender, uint256 value) internal {
104     assert(token.approve(spender, value));
105   }
106 }
107 
108 
109 
110 
111 
112 
113 /**
114  * @title Smart contract Osliki Classifieds
115  *
116  * @dev This is part of the Decentralized Osliki Platform (DOP).
117  */
118 contract OslikiClassifieds {
119   using SafeMath for uint;
120   using SafeERC20 for ERC20;
121 
122   ERC20 public oslikToken; // OSLIK Token (OT) address (ERC20 compatible token)
123   address public oslikiFoundation; // Osliki Foundation (OF) address
124 
125   uint public upPrice = 1 ether; // same decimals for OSLIK tokens
126   uint public reward = 20 ether; // same decimals for OSLIK tokens
127 
128   string[] public catsRegister;
129   Ad[] public ads;
130   Comment[] public comments;
131 
132   mapping (address => uint[]) internal adsByUser;
133   mapping (string => uint[]) internal adsByCat;
134 
135   event EventNewCategory(uint catId, string catName);
136   event EventNewAd(address indexed from, uint indexed catId, uint adId);
137   event EventEditAd(address indexed from, uint indexed catId, uint indexed adId);
138   event EventNewComment(address indexed from, uint indexed catId, uint indexed adId, uint cmntId);
139   event EventUpAd(address indexed from, uint indexed catId, uint indexed adId);
140   event EventReward(address indexed to, uint reward);
141 
142   struct Ad {
143     address user;
144     uint catId;
145     string text;
146     uint[] comments;
147     uint createdAt;
148     uint updatedAt;
149   }
150 
151   struct Comment {
152     address user;
153     uint adId;
154     string text;
155     uint createdAt;
156   }
157 
158   constructor(
159     ERC20 _oslikToken,
160     address _oslikiFoundation
161   ) public {
162     require(address(_oslikToken) != address(0), "_oslikToken is not assigned.");
163     require(_oslikiFoundation != address(0), "_oslikiFoundation is not assigned.");
164 
165     oslikToken = _oslikToken;
166     oslikiFoundation = _oslikiFoundation;
167   }
168 
169   function _newAd(
170     uint catId,
171     string text // format 'ipfs hash,ipfs hash...'
172   ) private returns (bool) {
173     require(bytes(text).length != 0, "Text is empty");
174 
175     ads.push(Ad({
176       user: msg.sender,
177       catId: catId,
178       text: text,
179       comments: new uint[](0),
180       createdAt: now,
181       updatedAt: now
182     }));
183 
184     uint adId = ads.length - 1;
185 
186     adsByCat[catsRegister[catId]].push(adId);
187     adsByUser[msg.sender].push(adId);
188 
189     if (adsByUser[msg.sender].length == 1 && reward > 0 && oslikToken.allowance(oslikiFoundation, address(this)) >= reward) {
190       uint balanceOfBefore = oslikToken.balanceOf(oslikiFoundation);
191 
192       if (balanceOfBefore >= reward) {
193         oslikToken.safeTransferFrom(oslikiFoundation, msg.sender, reward);
194 
195         uint balanceOfAfter = oslikToken.balanceOf(oslikiFoundation);
196         assert(balanceOfAfter == balanceOfBefore.sub(reward));
197 
198         emit EventReward(msg.sender, reward);
199       }
200     }
201 
202     emit EventNewAd(msg.sender, catId, adId);
203 
204     return true;
205   }
206 
207   function newAd(
208     uint catId,
209     string text // format 'ipfs hash,ipfs hash...'
210   ) public {
211     require(catId < catsRegister.length, "Category not found");
212 
213     assert(_newAd(catId, text));
214   }
215 
216   function newCatWithAd(
217     string catName,
218     string text // format 'ipfs hash,ipfs hash...'
219   ) public {
220     require(bytes(catName).length != 0, "Category is empty");
221     require(adsByCat[catName].length == 0, "Category already exists");
222 
223     catsRegister.push(catName);
224     uint catId = catsRegister.length - 1;
225 
226     emit EventNewCategory(catId, catName);
227 
228     assert(_newAd(catId, text));
229   }
230 
231   function editAd(
232     uint adId,
233     string text // format 'ipfs hash,ipfs hash...'
234   ) public {
235     require(adId < ads.length, "Ad id not found");
236     require(bytes(text).length != 0, "Text is empty");
237 
238     Ad storage ad = ads[adId];
239 
240     require(msg.sender == ad.user, "Sender not authorized.");
241     //require(!_stringsEqual(ad.text, text), "New text is the same");
242 
243     ad.text = text;
244     ad.updatedAt = now;
245 
246     emit EventEditAd(msg.sender, ad.catId, adId);
247   }
248 
249   function newComment(
250     uint adId,
251     string text
252   ) public {
253     require(adId < ads.length, "Ad id not found");
254     require(bytes(text).length != 0, "Text is empty");
255 
256     Ad storage ad = ads[adId];
257 
258     comments.push(Comment({
259       user: msg.sender,
260       adId: adId,
261       text: text,
262       createdAt: now
263     }));
264 
265     uint cmntId = comments.length - 1;
266 
267     ad.comments.push(cmntId);
268 
269     emit EventNewComment(msg.sender, ad.catId, adId, cmntId);
270   }
271 
272   function upAd(
273     uint adId
274   ) public {
275     require(adId < ads.length, "Ad id not found");
276 
277     Ad memory ad = ads[adId];
278 
279     require(msg.sender == ad.user, "Sender not authorized.");
280 
281     adsByCat[catsRegister[ad.catId]].push(adId);
282 
283     uint balanceOfBefore = oslikToken.balanceOf(oslikiFoundation);
284 
285     oslikToken.safeTransferFrom(msg.sender, oslikiFoundation, upPrice);
286 
287     uint balanceOfAfter = oslikToken.balanceOf(oslikiFoundation);
288     assert(balanceOfAfter == balanceOfBefore.add(upPrice));
289 
290     emit EventUpAd(msg.sender, ad.catId, adId);
291   }
292 
293   /*function _stringsEqual(string a, string b) private pure returns (bool) {
294    return keccak256(a) == keccak256(b);
295   }*/
296 
297   modifier onlyFoundation {
298     require(msg.sender == oslikiFoundation, "Sender not authorized.");
299     _;
300   }
301 
302   function _changeUpPrice(uint newUpPrice) public onlyFoundation {
303     upPrice = newUpPrice;
304   }
305 
306   function _changeReward(uint newReward) public onlyFoundation {
307     reward = newReward;
308   }
309 
310   function _changeOslikiFoundation(address newAddress) public onlyFoundation {
311     require(newAddress != address(0));
312     oslikiFoundation = newAddress;
313   }
314 
315 
316   function getCatsCount() public view returns (uint) {
317     return catsRegister.length;
318   }
319 
320   function getCommentsCount() public view returns (uint) {
321     return comments.length;
322   }
323 
324   function getCommentsCountByAd(uint adId) public view returns (uint) {
325     return ads[adId].comments.length;
326   }
327 
328   function getAllCommentIdsByAd(uint adId) public view returns (uint[]) {
329     return ads[adId].comments;
330   }
331 
332   function getCommentIdByAd(uint adId, uint index) public view returns (uint) {
333     return ads[adId].comments[index];
334   }
335 
336 
337   function getAdsCount() public view returns (uint) {
338     return ads.length;
339   }
340 
341 
342   function getAdsCountByUser(address user) public view returns (uint) {
343     return adsByUser[user].length;
344   }
345 
346   function getAdIdByUser(address user, uint index) public view returns (uint) {
347     return adsByUser[user][index];
348   }
349 
350   function getAllAdIdsByUser(address user) public view returns (uint[]) {
351     return adsByUser[user];
352   }
353 
354 
355   function getAdsCountByCat(uint catId) public view returns (uint) {
356     return adsByCat[catsRegister[catId]].length;
357   }
358 
359   function getAdIdByCat(uint catId, uint index) public view returns (uint) {
360     return adsByCat[catsRegister[catId]][index];
361   }
362 
363   function getAllAdIdsByCat(uint catId) public view returns (uint[]) {
364     return adsByCat[catsRegister[catId]];
365   }
366 
367 }