1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
46 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
47 contract ERC721 {
48     // Required methods
49     function totalSupply() public view returns (uint256 total);
50     function balanceOf(address _owner) public view returns (uint256 balance);
51     function ownerOf(uint256 _tokenId) public view returns (address owner);
52     function approve(address _to, uint256 _tokenId) public;
53     function transfer(address _to, uint256 _tokenId) public;
54     function transferFrom(address _from, address _to, uint256 _tokenId) public;
55 
56     // Events
57     event Transfer(address from, address to, uint256 tokenId);
58     event Approval(address owner, address approved, uint256 tokenId);
59 
60     // Optional
61     function name() public view returns (string name);
62     function symbol() public view returns (string symbol);
63     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
64     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
65 
66     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
67     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
68 }
69 
70 contract SmartSignature is ERC721{
71   using SafeMath for uint256;
72 
73   event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
74   event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
75   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
76   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
77 
78   address private owner;
79   
80   uint256 counter;
81   mapping (uint256 => address) private ownerOfToken;
82   mapping (uint256 => uint256) private priceOfToken;
83   mapping (uint256 => address) private approvedOfToken;
84   mapping (uint256 => address) private creatorOfToken;
85   mapping (uint256 => uint256) private parentOfToken;
86   mapping (uint256 => uint256) private balanceOfToken;  
87   mapping (uint256 => uint256) private free1OfToken; 
88   mapping (uint256 => uint256) private free2OfToken; 
89    
90   function SmartSignature () public {
91     owner = msg.sender;
92     creatorOfToken[counter] = ownerOfToken[counter] = msg.sender;
93     priceOfToken[counter] = 1 ether;
94     parentOfToken[counter] = 0;
95     free1OfToken[counter] = 0;
96     free2OfToken[counter] = 0;    
97     counter += 1;    
98   }
99 
100   /* Modifiers */
101   modifier onlyOwner(uint256 _tokenId) {
102     require(ownerOfToken[_tokenId] == msg.sender);
103     _;
104   }
105   
106   modifier onlyCreator(uint256 _tokenId) {
107     require(creatorOfToken[_tokenId] == msg.sender);
108     _;
109   }  
110 
111   modifier onlyRoot() {
112     require(creatorOfToken[0] == msg.sender);
113     _;
114   }
115 
116   /* Owner */
117   function setCreator (address _creator, uint _tokenId) onlyCreator(_tokenId) public {
118     creatorOfToken[_tokenId] = _creator;
119   }
120 
121   /* Judge Fake Token */
122   function judgeFakeToken (uint256 _tokenId) onlyRoot() public {
123     creatorOfToken[_tokenId] = msg.sender;
124   }
125 
126   function judgeFakeTokenAndTransfer (uint256 _tokenId, address _plaintiff) onlyRoot() public {    
127     creatorOfToken[_tokenId] = _plaintiff;
128   }  
129 
130   /* Withdraw */
131   function withdrawAllFromRoot () onlyRoot() public {
132     uint256 t = balanceOfToken[0];
133     balanceOfToken[0] = 0;
134     msg.sender.transfer(t);         
135   }
136   
137   function withdrawAllFromToken (uint256 _tokenId) onlyCreator(_tokenId) public {
138     uint256 t = balanceOfToken[_tokenId];
139     uint256 r = t / 20;
140     balanceOfToken[_tokenId] = 0;
141     balanceOfToken[parentOfToken[_tokenId]] += r;
142     msg.sender.transfer(t - r);      
143   }
144 
145   function withdrawAmountFromToken (uint256 _tokenId, uint256 t) onlyCreator(_tokenId) public {
146     if (t > balanceOfToken[_tokenId]) t = balanceOfToken[_tokenId];
147     uint256 r = t / 20;
148     balanceOfToken[_tokenId] = 0;
149     balanceOfToken[parentOfToken[_tokenId]] += r;
150     msg.sender.transfer(t - r); 
151   }
152   
153   function withdrawAll() public {
154       require(msg.sender == owner);
155       owner.transfer(this.balance);
156   }
157 
158   /* Buying */
159   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
160     return _price.mul(117).div(98);
161   }
162 
163   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
164     return _price.div(20); // 5%
165   }
166 
167   function buy (uint256 _tokenId) payable public {
168     require(priceOf(_tokenId) > 0);
169     require(ownerOf(_tokenId) != address(0));
170     require(msg.value >= priceOf(_tokenId));
171     require(ownerOf(_tokenId) != msg.sender);
172     require(!isContract(msg.sender));
173     require(msg.sender != address(0));
174     require(now >= free1OfToken[_tokenId]);
175 
176     address oldOwner = ownerOf(_tokenId);
177     address newOwner = msg.sender;
178     uint256 price = priceOf(_tokenId);
179     uint256 excess = msg.value.sub(price);
180 
181     _transfer(oldOwner, newOwner, _tokenId);
182     priceOfToken[_tokenId] = nextPriceOf(_tokenId);
183 
184     Bought(_tokenId, newOwner, price);
185     Sold(_tokenId, oldOwner, price);
186 
187     // Devevloper's cut which is left in contract and accesed by
188     // `withdrawAll` and `withdrawAmountTo` methods.
189     uint256 devCut = calculateDevCut(price);
190 
191     // Transfer payment to old owner minus the developer's cut.
192     oldOwner.transfer(price.sub(devCut));
193     uint256 shareHolderCut = devCut.div(20);
194     ownerOfToken[parentOfToken[_tokenId]].transfer(shareHolderCut);
195     balanceOfToken[_tokenId] += devCut.sub(shareHolderCut);
196 
197     if (excess > 0) {
198       newOwner.transfer(excess);
199     }
200   }
201 
202   /* ERC721 */
203 
204   function name() public view returns (string name) {
205     return "smartsignature.io";
206   }
207 
208   function symbol() public view returns (string symbol) {
209     return "SSI";
210   }
211 
212   function totalSupply() public view returns (uint256 _totalSupply) {
213     return counter;
214   }
215 
216   function balanceOf (address _owner) public view returns (uint256 _balance) {
217     uint256 t = 0;
218     for (uint256 i = 0; i < counter; i++) {
219       if (ownerOf(i) == _owner) {
220         t++;
221       }
222     }
223     return t;
224   }
225 
226   function ownerOf (uint256 _tokenId) public view returns (address _owner) {
227     return ownerOfToken[_tokenId];
228   }
229   
230   function creatorOf (uint256 _tokenId) public view returns (address _creator) {
231     return creatorOfToken[_tokenId];
232   }  
233   
234   function parentOf (uint256 _tokenId) public view returns (uint256 _parent) {
235     return parentOfToken[_tokenId];
236   }    
237   
238   function free1Of (uint256 _tokenId) public view returns (uint256 _free) {
239     return free1OfToken[_tokenId];
240   }    
241 
242   function free2Of (uint256 _tokenId) public view returns (uint256 _free) {
243     return free2OfToken[_tokenId];
244   }      
245   
246   function balanceFromToken (uint256 _tokenId) public view returns (uint256 _balance) {
247     return balanceOfToken[_tokenId];
248   }      
249   
250   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
251     uint256[] memory tokens = new uint256[](balanceOf(_owner));
252 
253     uint256 tokenCounter = 0;
254     for (uint256 i = 0; i < counter; i++) {
255       if (ownerOf(i) == _owner) {
256         tokens[tokenCounter] = i;
257         tokenCounter += 1;
258       }
259     }
260 
261     return tokens;
262   }
263 
264   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
265     return priceOf(_tokenId) > 0;
266   }
267 
268   function approvedFor(uint256 _tokenId) public view returns (address _approved) {
269     return approvedOfToken[_tokenId];
270   }
271 
272   function approve(address _to, uint256 _tokenId) public {
273     require(msg.sender != _to);
274     require(tokenExists(_tokenId));
275     require(ownerOf(_tokenId) == msg.sender);
276 
277     if (_to == 0) {
278       if (approvedOfToken[_tokenId] != 0) {
279         delete approvedOfToken[_tokenId];
280         Approval(msg.sender, 0, _tokenId);
281       }
282     } else {
283       approvedOfToken[_tokenId] = _to;
284       Approval(msg.sender, _to, _tokenId);
285     }
286   }
287 
288   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
289   function transfer(address _to, uint256 _tokenId) public {
290     require(msg.sender == ownerOf(_tokenId));
291     _transfer(msg.sender, _to, _tokenId);
292   }
293 
294   function transferFrom(address _from, address _to, uint256 _tokenId) public {
295     require(approvedFor(_tokenId) == msg.sender);
296     _transfer(_from, _to, _tokenId);
297   }
298 
299   function _transfer(address _from, address _to, uint256 _tokenId) internal {
300     require(tokenExists(_tokenId));
301     require(ownerOf(_tokenId) == _from);
302     require(_to != address(0));
303     require(_to != address(this));
304 
305     ownerOfToken[_tokenId] = _to;
306     approvedOfToken[_tokenId] = 0;
307 
308     Transfer(_from, _to, _tokenId);
309   }
310 
311   /* Read */
312 
313   function priceOf (uint256 _tokenId) public view returns (uint256 _price) {
314     return priceOfToken[_tokenId];
315   }
316 
317   function nextPriceOf (uint256 _tokenId) public view returns (uint256 _nextPrice) {
318     return calculateNextPrice(priceOf(_tokenId));
319   }
320 
321   function allOf (uint256 _tokenId) external view returns (address _owner, address _creator, uint256 _price, uint256 _nextPrice) {
322     return (ownerOfToken[_tokenId], creatorOfToken[_tokenId], priceOfToken[_tokenId], nextPriceOf(_tokenId));
323   }
324 
325   /* Util */
326   function isContract(address addr) internal view returns (bool) {
327     uint size;
328     assembly { size := extcodesize(addr) } // solium-disable-line
329     return size > 0;
330   }
331   
332   function changePrice(uint256 _tokenId, uint256 _price, uint256 _frozen1, uint256 _frozen2) onlyOwner(_tokenId) public {
333     require(now >= free2OfToken[_tokenId]);
334     priceOfToken[_tokenId] = _price;
335     free1OfToken[_tokenId] = now + _frozen1;
336     free2OfToken[_tokenId] = now + _frozen1 + _frozen2;
337   }
338   
339   function issueToken(uint256 _price, uint256 _frozen1, uint256 _frozen2, uint256 _parent) public {
340     require(_parent <= counter);
341     creatorOfToken[counter] = ownerOfToken[counter] = msg.sender;
342     priceOfToken[counter] = _price;
343     parentOfToken[counter] = _parent;
344     free1OfToken[counter] = now + _frozen1;
345     free2OfToken[counter] = now + _frozen1 + _frozen2;
346     counter += 1;
347   }  
348 }