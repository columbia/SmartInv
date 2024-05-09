1 /// Smart Signature Beta v0.1
2 
3 pragma solidity ^0.4.20;
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
48 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
49 contract ERC721 {
50     // Required methods
51     function totalSupply() public view returns (uint256 total);
52     function balanceOf(address _owner) public view returns (uint256 balance);
53     function ownerOf(uint256 _tokenId) public view returns (address owner);
54     function approve(address _to, uint256 _tokenId) public;
55     function transfer(address _to, uint256 _tokenId) public;
56     function transferFrom(address _from, address _to, uint256 _tokenId) public;
57 
58     // Events
59     event Transfer(address from, address to, uint256 tokenId);
60     event Approval(address owner, address approved, uint256 tokenId);
61 
62     // Optional
63     function name() public view returns (string name);
64     function symbol() public view returns (string symbol);
65     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
66     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
67 
68     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
69     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
70 }
71 
72 contract SmartSignature is ERC721{
73   using SafeMath for uint256;
74 
75   event Bought (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
76   event Sold (uint256 indexed _tokenId, address indexed _owner, uint256 _price);
77   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
78   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
79 
80   address private owner;
81   
82   uint256 counter;
83   mapping (uint256 => address) private ownerOftoken;
84   mapping (uint256 => uint256) private priceOftoken;
85   mapping (uint256 => address) private approvedOftoken;
86   mapping (uint256 => address) private creatorOftoken;
87   mapping (uint256 => uint256) private parentOftoken;
88   mapping (uint256 => uint256) private balanceOfToken;  
89   mapping (uint256 => uint256) private freeOftoken;  
90 
91   function SmartSignature () public {
92     owner = msg.sender;
93     creatorOftoken[counter] = ownerOftoken[counter] = msg.sender;
94     priceOftoken[counter] = 1 ether;
95     parentOftoken[counter] = 0;
96     freeOftoken[counter] = now + 120;    
97     counter += 1;    
98   }
99 
100   /* Modifiers */
101   modifier onlyOwner(uint256 _tokenId) {
102     require(ownerOftoken[_tokenId] == msg.sender);
103     _;
104   }
105   
106   modifier onlyCreator(uint256 _tokenId) {
107     require(creatorOftoken[_tokenId] == msg.sender);
108     _;
109   }  
110 
111   /* Owner */
112   function setCreator (address _creator, uint _tokenId) onlyCreator(_tokenId) public {
113     creatorOftoken[_tokenId] = _creator;
114   }
115 
116   /* Withdraw */
117 
118   function withdrawAllFromToken (uint256 _tokenId) onlyCreator(_tokenId) public {
119     uint256 t = balanceOfToken[_tokenId];
120     uint256 r = t / 20;
121     balanceOfToken[_tokenId] = 0;
122     balanceOfToken[parentOftoken[_tokenId]] += r;
123     msg.sender.transfer(t - r);      
124   }
125 
126   function withdrawAmountFromToken (uint256 _tokenId, uint256 t) onlyCreator(_tokenId) public {
127     if (t > balanceOfToken[_tokenId]) t = balanceOfToken[_tokenId];
128     uint256 r = t / 20;
129     balanceOfToken[_tokenId] = 0;
130     balanceOfToken[parentOftoken[_tokenId]] += r;
131     msg.sender.transfer(t - r); 
132   }
133   
134   function withdrawAll() public {
135       require(msg.sender == owner);
136       owner.transfer(this.balance);
137   }
138 
139   /* Buying */
140   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
141     return _price.mul(117).div(98);
142   }
143 
144   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
145     return _price.div(20); // 5%
146   }
147 
148   function buy (uint256 _tokenId) payable public {
149     require(priceOf(_tokenId) > 0);
150     require(ownerOf(_tokenId) != address(0));
151     require(msg.value >= priceOf(_tokenId));
152     require(ownerOf(_tokenId) != msg.sender);
153     require(!isContract(msg.sender));
154     require(msg.sender != address(0));
155 
156     address oldOwner = ownerOf(_tokenId);
157     address newOwner = msg.sender;
158     uint256 price = priceOf(_tokenId);
159     uint256 excess = msg.value.sub(price);
160 
161     _transfer(oldOwner, newOwner, _tokenId);
162     priceOftoken[_tokenId] = nextPriceOf(_tokenId);
163 
164     Bought(_tokenId, newOwner, price);
165     Sold(_tokenId, oldOwner, price);
166 
167     // Devevloper's cut which is left in contract and accesed by
168     // `withdrawAll` and `withdrawAmountTo` methods.
169     uint256 devCut = calculateDevCut(price);
170 
171     // Transfer payment to old owner minus the developer's cut.
172     oldOwner.transfer(price.sub(devCut));
173     uint256 shareHolderCut = devCut.div(20);
174     ownerOftoken[parentOftoken[_tokenId]].transfer(shareHolderCut);
175     balanceOfToken[_tokenId] += devCut.sub(shareHolderCut);
176 
177     if (excess > 0) {
178       newOwner.transfer(excess);
179     }
180   }
181 
182   /* ERC721 */
183 
184   function name() public view returns (string name) {
185     return "smartsignature.io";
186   }
187 
188   function symbol() public view returns (string symbol) {
189     return "SSI";
190   }
191 
192   function totalSupply() public view returns (uint256 _totalSupply) {
193     return counter;
194   }
195 
196   function balanceOf (address _owner) public view returns (uint256 _balance) {
197     uint256 counter = 0;
198 
199     for (uint256 i = 0; i < counter; i++) {
200       if (ownerOf(i) == _owner) {
201         counter++;
202       }
203     }
204 
205     return counter;
206   }
207 
208   function ownerOf (uint256 _tokenId) public view returns (address _owner) {
209     return ownerOftoken[_tokenId];
210   }
211   
212   function creatorOf (uint256 _tokenId) public view returns (address _creator) {
213     return creatorOftoken[_tokenId];
214   }  
215   
216   function parentOf (uint256 _tokenId) public view returns (uint256 _parent) {
217     return parentOftoken[_tokenId];
218   }    
219   
220   function freeOf (uint256 _tokenId) public view returns (uint256 _free) {
221     return freeOftoken[_tokenId];
222   }    
223   
224   function balanceFromToken (uint256 _tokenId) public view returns (uint256 _balance) {
225     return balanceOfToken[_tokenId];
226   }      
227   
228   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
229     uint256[] memory tokens = new uint256[](balanceOf(_owner));
230 
231     uint256 tokenCounter = 0;
232     for (uint256 i = 0; i < counter; i++) {
233       if (ownerOf(i) == _owner) {
234         tokens[tokenCounter] = i;
235         tokenCounter += 1;
236       }
237     }
238 
239     return tokens;
240   }
241 
242   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
243     return priceOf(_tokenId) > 0;
244   }
245 
246   function approvedFor(uint256 _tokenId) public view returns (address _approved) {
247     return approvedOftoken[_tokenId];
248   }
249 
250   function approve(address _to, uint256 _tokenId) public {
251     require(msg.sender != _to);
252     require(tokenExists(_tokenId));
253     require(ownerOf(_tokenId) == msg.sender);
254 
255     if (_to == 0) {
256       if (approvedOftoken[_tokenId] != 0) {
257         delete approvedOftoken[_tokenId];
258         Approval(msg.sender, 0, _tokenId);
259       }
260     } else {
261       approvedOftoken[_tokenId] = _to;
262       Approval(msg.sender, _to, _tokenId);
263     }
264   }
265 
266   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
267   function transfer(address _to, uint256 _tokenId) public {
268     require(msg.sender == ownerOf(_tokenId));
269     _transfer(msg.sender, _to, _tokenId);
270   }
271 
272   function transferFrom(address _from, address _to, uint256 _tokenId) public {
273     require(approvedFor(_tokenId) == msg.sender);
274     _transfer(_from, _to, _tokenId);
275   }
276 
277   function _transfer(address _from, address _to, uint256 _tokenId) internal {
278     require(tokenExists(_tokenId));
279     require(ownerOf(_tokenId) == _from);
280     require(_to != address(0));
281     require(_to != address(this));
282 
283     ownerOftoken[_tokenId] = _to;
284     approvedOftoken[_tokenId] = 0;
285 
286     Transfer(_from, _to, _tokenId);
287   }
288 
289   /* Read */
290 
291   function priceOf (uint256 _tokenId) public view returns (uint256 _price) {
292     return priceOftoken[_tokenId];
293   }
294 
295   function nextPriceOf (uint256 _tokenId) public view returns (uint256 _nextPrice) {
296     return calculateNextPrice(priceOf(_tokenId));
297   }
298 
299   function allOf (uint256 _tokenId) external view returns (address _owner, address _creator, uint256 _price, uint256 _nextPrice) {
300     return (ownerOftoken[_tokenId], creatorOftoken[_tokenId], priceOftoken[_tokenId], nextPriceOf(_tokenId));
301   }
302 
303   /* Util */
304   function isContract(address addr) internal view returns (bool) {
305     uint size;
306     assembly { size := extcodesize(addr) } // solium-disable-line
307     return size > 0;
308   }
309   
310   function changePrice(uint256 _tokenId, uint256 _price) onlyOwner(_tokenId) public {
311     require(now >= freeOftoken[_tokenId]);
312     priceOftoken[_tokenId] = _price;
313   }
314   
315   function issueToken(uint256 _price, uint256 _frozen, uint256 _parent) public {
316     require(_parent <= counter);
317     creatorOftoken[counter] = ownerOftoken[counter] = msg.sender;
318     priceOftoken[counter] = _price;
319     parentOftoken[counter] = _parent;
320     freeOftoken[counter] = now + _frozen;
321     counter += 1;
322   }  
323 }