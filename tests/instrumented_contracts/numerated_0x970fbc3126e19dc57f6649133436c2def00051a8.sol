1 // File: contracts/ERC721.sol
2 
3 // eterart-contract
4 // contracts/ERC721.sol
5 
6 
7 pragma solidity ^0.4.24;
8 
9 
10 /**
11  * @title ERC-721 contract interface.
12  */
13 contract ERC721 {
14     // ERC20 compatible functions.
15     function name() public constant returns (string);
16     function symbol() public constant returns (string);
17     function totalSupply() public constant returns (uint256);
18     function balanceOf(address _owner) public constant returns (uint);
19     // Functions that define ownership.
20     function ownerOf(uint256 _tokenId) public constant returns (address);
21     function approve(address _to, uint256 _tokenId) public;
22     function takeOwnership(uint256 _tokenId) public;
23     function transfer(address _to, uint256 _tokenId) public;
24     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint);
25     // Token metadata.
26     function tokenMetadata(uint256 _tokenId) public constant returns (string);
27     // Events.
28     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
29     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
30 }
31 
32 // File: contracts/EterArt.sol
33 
34 // eterart-contract
35 // contracts/EterArt.sol
36 
37 
38 pragma solidity ^0.4.24;
39 
40 
41 /**
42  * @title EterArt contract.
43  */
44 contract EterArt is ERC721 {
45 
46     // Art structure for tokens ownership registry.
47     struct Art {
48         uint256 price;
49         address owner;
50         address newOwner;
51     }
52 
53     struct Token {
54         uint256[] items;
55         mapping(uint256 => uint) lookup;
56     }
57 
58     // Mapping from token ID to owner.
59     mapping (address => Token) internal ownedTokens;
60 
61     // All minted tokens number (ERC-20 compatibility).
62     uint256 public totalTokenSupply;
63 
64     // Token issuer address
65     address public _issuer;
66 
67     // Tokens ownership registry.
68     mapping (uint => Art) public registry;
69 
70     // Token metadata base URL.
71     string public baseInfoUrl = "https://www.eterart.com/art/";
72 
73     // Fee in percents
74     uint public feePercent = 5;
75 
76     // Change price event
77     event ChangePrice(uint indexed token, uint indexed price);
78 
79     /**
80     * @dev Constructor sets the `issuer` of the contract to the sender
81     * account.
82     */
83     constructor() public {
84         _issuer = msg.sender;
85     }
86 
87     /**
88    * @return the address of the issuer.
89    */
90     function issuer() public view returns(address) {
91         return _issuer;
92     }
93 
94     /**
95     * @dev Reject all Ether from being sent here. (Hopefully, we can prevent user accidents.)
96     */
97     function() external payable {
98         require(msg.sender == address(this));
99     }
100 
101     /**
102      * @dev Gets token name (ERC-20 compatibility).
103      * @return string token name.
104      */
105     function name() public constant returns (string) {
106         return "EterArt";
107     }
108 
109     /**
110      * @dev Gets token symbol (ERC-20 compatibility).
111      * @return string token symbol.
112      */
113     function symbol() public constant returns (string) {
114         return "WAW";
115     }
116 
117     /**
118      * @dev Gets token URL.
119      * @param _tokenId uint256 ID of the token to get URL of.
120      * @return string token URL.
121      */
122     function tokenMetadata(uint256 _tokenId) public constant returns (string) {
123         return strConcat(baseInfoUrl, strConcat("0x", uint2hexstr(_tokenId)));
124     }
125 
126     /**
127      * @dev Gets contract all minted tokens number.
128      * @return uint256 contract all minted tokens number.
129      */
130     function totalSupply() public constant returns (uint256) {
131         return totalTokenSupply;
132     }
133 
134     /**
135      * @dev Gets tokens number of specified address.
136      * @param _owner address to query tokens number of.
137      * @return uint256 number of tokens owned by the specified address.
138      */
139     function balanceOf(address _owner) public constant returns (uint balance) {
140         balance = ownedTokens[_owner].items.length;
141     }
142 
143     /**
144      * @dev Gets token by index of specified address.
145      * @param _owner address to query tokens number of.
146      * @param _index uint256 index of the token to get.
147      * @return uint256 token ID from specified address tokens list by specified index.
148      */
149     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint tokenId) {
150         tokenId = ownedTokens[_owner].items[_index];
151     }
152 
153     /**
154      * @dev Approve token ownership transfer to another address.
155      * @param _to address to change token ownership to.
156      * @param _tokenId uint256 token ID to change ownership of.
157      */
158     function approve(address _to, uint256 _tokenId) public {
159         require(_to != msg.sender);
160         require(registry[_tokenId].owner == msg.sender);
161         registry[_tokenId].newOwner = _to;
162         emit Approval(registry[_tokenId].owner, _to, _tokenId);
163     }
164 
165     /**
166      * @dev Internal method that transfer token to another address.
167      * Run some checks and internal contract data manipulations.
168      * @param _to address new token owner address.
169      * @param _tokenId uint256 token ID to transfer to specified address.
170      */
171     function _transfer(address _to, uint256 _tokenId) internal {
172         if (registry[_tokenId].owner != address(0)) {
173             require(registry[_tokenId].owner != _to);
174             removeByValue(registry[_tokenId].owner, _tokenId);
175         }
176         else {
177             totalTokenSupply = totalTokenSupply + 1;
178         }
179 
180         require(_to != address(0));
181 
182         push(_to, _tokenId);
183         emit Transfer(registry[_tokenId].owner, _to, _tokenId);
184         registry[_tokenId].owner = _to;
185         registry[_tokenId].newOwner = address(0);
186         registry[_tokenId].price = 0;
187     }
188 
189     /**
190      * @dev Take ownership of specified token.
191      * Only if current token owner approve that.
192      * @param _tokenId uint256 token ID to take ownership of.
193      */
194     function takeOwnership(uint256 _tokenId) public {
195         require(registry[_tokenId].newOwner == msg.sender);
196         _transfer(msg.sender, _tokenId);
197     }
198 
199     /**
200      * @dev Change baseInfoUrl contract property value.
201      * @param url string new baseInfoUrl value.
202      */
203     function changeBaseInfoUrl(string url) public {
204         require(msg.sender == _issuer);
205         baseInfoUrl = url;
206     }
207 
208     /**
209      * @dev Change issuer contract address.
210      * @param _to address of new contract issuer.
211      */
212     function changeIssuer(address _to) public {
213         require(msg.sender == _issuer);
214         _issuer = _to;
215     }
216 
217     /**
218      * @dev Withdraw all contract balance value to contract issuer.
219      */
220     function withdraw() public {
221         require(msg.sender == _issuer);
222         withdraw(_issuer, address(this).balance);
223     }
224 
225     /**
226      * @dev Withdraw all contract balance value to specified address.
227      * @param _to address to transfer value.
228      */
229     function withdraw(address _to) public {
230         require(msg.sender == _issuer);
231         withdraw(_to, address(this).balance);
232     }
233 
234     /**
235      * @dev Withdraw specified wei number to address.
236      * @param _to address to transfer value.
237      * @param _value uint wei amount value.
238      */
239     function withdraw(address _to, uint _value) public {
240         require(msg.sender == _issuer);
241         require(_value <= address(this).balance);
242         _to.transfer(address(this).balance);
243     }
244 
245     /**
246      * @dev Gets specified token owner address.
247      * @param token uint256 token ID.
248      * @return address specified token owner address.
249      */
250     function ownerOf(uint256 token) public constant returns (address owner) {
251         owner = registry[token].owner;
252     }
253 
254     /**
255      * @dev Gets specified token price.
256      * @param token uint256 token ID.
257      * @return uint specified token price.
258      */
259     function getPrice(uint token) public view returns (uint) {
260         return registry[token].price;
261     }
262 
263     /**
264      * @dev Direct transfer specified token to another address.
265      * @param _to address new token owner address.
266      * @param _tokenId uint256 token ID to transfer to specified address.
267      */
268     function transfer(address _to, uint256 _tokenId) public {
269         require(registry[_tokenId].owner == msg.sender);
270         _transfer(_to, _tokenId);
271     }
272 
273     /**
274      * @dev Change specified token price.
275      * Used for: change token price,
276      * withdraw token from sale (set token price to 0 (zero))
277      * and for put up token for sale (set token price > 0)
278      * @param token uint token ID to change price of.
279      * @param price uint new token price.
280      */
281     function changePrice(uint token, uint price) public {
282         require(registry[token].owner == msg.sender);
283         registry[token].price = price;
284         emit ChangePrice(token, price);
285     }
286 
287     /**
288      * @dev Buy specified token if it's marked as for sale (token price > 0).
289      * Run some checks, calculate fee and transfer token to msg.sender.
290      * @param _tokenId uint token ID to buy.
291      */
292     function buy(uint _tokenId) public payable {
293         require(registry[_tokenId].price > 0);
294 
295         uint fee = ((registry[_tokenId].price / 100) * feePercent);
296         uint value = msg.value - fee;
297 
298         require(registry[_tokenId].price <= value);
299         registry[_tokenId].owner.transfer(value);
300         _transfer(msg.sender, _tokenId);
301     }
302 
303     /**
304      * @dev Mint token.
305      */
306     function mint(uint _tokenId, address _to) public {
307         require(msg.sender == _issuer);
308         require(registry[_tokenId].owner == 0x0);
309         _transfer(_to, _tokenId);
310     }
311 
312     /**
313      * @dev Mint token.
314      */
315     function mint(
316         string length,
317         uint _tokenId,
318         uint price,
319         uint8 v,
320         bytes32 r,
321         bytes32 s
322     ) public payable {
323 
324         string memory m_price = uint2hexstr(price);
325         string memory m_token = uint2hexstr(_tokenId);
326 
327         require(msg.value >= price);
328         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n", length, m_token, m_price), v, r, s) == _issuer);
329         require(registry[_tokenId].owner == 0x0);
330         _transfer(msg.sender, _tokenId);
331     }
332 
333     /**
334      * UTILS
335      */
336 
337     /**
338      * @dev Add token to specified address tokens list.
339      * @param owner address address of token owner to add token to.
340      * @param value uint token ID to add.
341      */
342     function push(address owner, uint value) private {
343 
344         if (ownedTokens[owner].lookup[value] > 0) {
345             return;
346         }
347         ownedTokens[owner].lookup[value] = ownedTokens[owner].items.push(value);
348     }
349 
350     /**
351      * @dev Remove token by ID from specified address tokens list.
352      * @param owner address address of token owner to remove token from.
353      * @param value uint token ID to remove.
354      */
355     function removeByValue(address owner, uint value) private {
356         uint index = ownedTokens[owner].lookup[value];
357         if (index == 0) {
358             return;
359         }
360         if (index < ownedTokens[owner].items.length) {
361             uint256 lastItem = ownedTokens[owner].items[ownedTokens[owner].items.length - 1];
362             ownedTokens[owner].items[index - 1] = lastItem;
363             ownedTokens[owner].lookup[lastItem] = index;
364         }
365         ownedTokens[owner].items.length -= 1;
366         delete ownedTokens[owner].lookup[value];
367     }
368 
369     /**
370      * @dev String concatenation.
371      * @param _a string first string.
372      * @param _b string second string.
373      * @return string result of string concatenation.
374      */
375     function strConcat(string _a, string _b) internal pure returns (string){
376         bytes memory _ba = bytes(_a);
377         bytes memory _bb = bytes(_b);
378         string memory abcde = new string(_ba.length + _bb.length);
379         bytes memory babcde = bytes(abcde);
380         uint k = 0;
381         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
382         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
383 
384         return string(babcde);
385     }
386 
387     /**
388      * @dev Convert long to hex string.
389      * @param i uint value to convert.
390      * @return string specified value converted to hex string.
391      */
392     function uint2hexstr(uint i) internal pure returns (string) {
393         if (i == 0) return "0";
394         uint j = i;
395         uint length;
396         while (j != 0) {
397             length++;
398             j = j >> 4;
399         }
400         uint mask = 15;
401         bytes memory bstr = new bytes(length);
402         uint k = length - 1;
403         while (i != 0) {
404             uint curr = (i & mask);
405             bstr[k--] = curr > 9 ? byte(55 + curr) : byte(48 + curr); // 55 = 65 - 10
406             i = i >> 4;
407         }
408 
409         return string(bstr);
410     }
411 
412 }