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
28     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
29     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
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
76     /**
77     * @dev Constructor sets the `issuer` of the contract to the sender
78     * account.
79     */
80     constructor() public {
81         _issuer = msg.sender;
82     }
83 
84     /**
85    * @return the address of the issuer.
86    */
87     function issuer() public view returns(address) {
88         return _issuer;
89     }
90 
91     /**
92     * @dev Reject all Ether from being sent here. (Hopefully, we can prevent user accidents.)
93     */
94     function() external payable {
95         require(msg.sender == address(this));
96     }
97 
98     /**
99      * @dev Gets token name (ERC-20 compatibility).
100      * @return string token name.
101      */
102     function name() public constant returns (string) {
103         return "EterArt";
104     }
105 
106     /**
107      * @dev Gets token symbol (ERC-20 compatibility).
108      * @return string token symbol.
109      */
110     function symbol() public constant returns (string) {
111         return "WAW";
112     }
113 
114     /**
115      * @dev Gets token URL.
116      * @param _tokenId uint256 ID of the token to get URL of.
117      * @return string token URL.
118      */
119     function tokenMetadata(uint256 _tokenId) public constant returns (string) {
120         return strConcat(baseInfoUrl, strConcat("0x", uint2hexstr(_tokenId)));
121     }
122 
123     /**
124      * @dev Gets contract all minted tokens number.
125      * @return uint256 contract all minted tokens number.
126      */
127     function totalSupply() public constant returns (uint256) {
128         return totalTokenSupply;
129     }
130 
131     /**
132      * @dev Gets tokens number of specified address.
133      * @param _owner address to query tokens number of.
134      * @return uint256 number of tokens owned by the specified address.
135      */
136     function balanceOf(address _owner) public constant returns (uint balance) {
137         balance = ownedTokens[_owner].items.length;
138     }
139 
140     /**
141      * @dev Gets token by index of specified address.
142      * @param _owner address to query tokens number of.
143      * @param _index uint256 index of the token to get.
144      * @return uint256 token ID from specified address tokens list by specified index.
145      */
146     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint tokenId) {
147         tokenId = ownedTokens[_owner].items[_index];
148     }
149 
150     /**
151      * @dev Approve token ownership transfer to another address.
152      * @param _to address to change token ownership to.
153      * @param _tokenId uint256 token ID to change ownership of.
154      */
155     function approve(address _to, uint256 _tokenId) public {
156         require(_to != msg.sender);
157         require(registry[_tokenId].owner == msg.sender);
158         registry[_tokenId].newOwner = _to;
159         emit Approval(registry[_tokenId].owner, _to, _tokenId);
160     }
161 
162     /**
163      * @dev Internal method that transfer token to another address.
164      * Run some checks and internal contract data manipulations.
165      * @param _to address new token owner address.
166      * @param _tokenId uint256 token ID to transfer to specified address.
167      */
168     function _transfer(address _to, uint256 _tokenId) internal {
169         if (registry[_tokenId].owner != address(0)) {
170             require(registry[_tokenId].owner != _to);
171             removeByValue(registry[_tokenId].owner, _tokenId);
172         }
173         else {
174             totalTokenSupply = totalTokenSupply + 1;
175         }
176 
177         require(_to != address(0));
178 
179         push(_to, _tokenId);
180         emit Transfer(registry[_tokenId].owner, _to, _tokenId);
181         registry[_tokenId].owner = _to;
182         registry[_tokenId].newOwner = address(0);
183         registry[_tokenId].price = 0;
184     }
185 
186     /**
187      * @dev Take ownership of specified token.
188      * Only if current token owner approve that.
189      * @param _tokenId uint256 token ID to take ownership of.
190      */
191     function takeOwnership(uint256 _tokenId) public {
192         require(registry[_tokenId].newOwner == msg.sender);
193         _transfer(msg.sender, _tokenId);
194     }
195 
196     /**
197      * @dev Change baseInfoUrl contract property value.
198      * @param url string new baseInfoUrl value.
199      */
200     function changeBaseInfoUrl(string url) public {
201         require(msg.sender == _issuer);
202         baseInfoUrl = url;
203     }
204 
205     /**
206      * @dev Change issuer contract address.
207      * @param _to address of new contract issuer.
208      */
209     function changeIssuer(address _to) public {
210         require(msg.sender == _issuer);
211         _issuer = _to;
212     }
213 
214     /**
215      * @dev Withdraw all contract balance value to contract issuer.
216      */
217     function withdraw() public {
218         require(msg.sender == _issuer);
219         withdraw(_issuer, address(this).balance);
220     }
221 
222     /**
223      * @dev Withdraw all contract balance value to specified address.
224      * @param _to address to transfer value.
225      */
226     function withdraw(address _to) public {
227         require(msg.sender == _issuer);
228         withdraw(_to, address(this).balance);
229     }
230 
231     /**
232      * @dev Withdraw specified wei number to address.
233      * @param _to address to transfer value.
234      * @param _value uint wei amount value.
235      */
236     function withdraw(address _to, uint _value) public {
237         require(msg.sender == _issuer);
238         require(_value <= address(this).balance);
239         _to.transfer(address(this).balance);
240     }
241 
242     /**
243      * @dev Gets specified token owner address.
244      * @param token uint256 token ID.
245      * @return address specified token owner address.
246      */
247     function ownerOf(uint256 token) public constant returns (address owner) {
248         owner = registry[token].owner;
249     }
250 
251     /**
252      * @dev Gets specified token price.
253      * @param token uint256 token ID.
254      * @return uint specified token price.
255      */
256     function getPrice(uint token) public view returns (uint) {
257         return registry[token].price;
258     }
259 
260     /**
261      * @dev Direct transfer specified token to another address.
262      * @param _to address new token owner address.
263      * @param _tokenId uint256 token ID to transfer to specified address.
264      */
265     function transfer(address _to, uint256 _tokenId) public {
266         require(registry[_tokenId].owner == msg.sender);
267         _transfer(_to, _tokenId);
268     }
269 
270     /**
271      * @dev Change specified token price.
272      * Used for: change token price,
273      * withdraw token from sale (set token price to 0 (zero))
274      * and for put up token for sale (set token price > 0)
275      * @param token uint token ID to change price of.
276      * @param price uint new token price.
277      */
278     function changePrice(uint token, uint price) public {
279         require(registry[token].owner == msg.sender);
280         registry[token].price = price;
281     }
282 
283     /**
284      * @dev Buy specified token if it's marked as for sale (token price > 0).
285      * Run some checks, calculate fee and transfer token to msg.sender.
286      * @param _tokenId uint token ID to buy.
287      */
288     function buy(uint _tokenId) public payable {
289         require(registry[_tokenId].price > 0);
290 
291         uint calcedFee = ((registry[_tokenId].price / 100) * feePercent);
292         uint value = msg.value - calcedFee;
293 
294         require(registry[_tokenId].price <= value);
295         registry[_tokenId].owner.transfer(value);
296         _transfer(msg.sender, _tokenId);
297     }
298 
299     /**
300      * @dev Mint token.
301      */
302     function mint(uint _tokenId, address _to) public {
303         require(msg.sender == _issuer);
304         require(registry[_tokenId].owner == 0x0);
305         _transfer(_to, _tokenId);
306     }
307 
308     /**
309      * @dev Mint token.
310      */
311     function mint(
312         string length,
313         uint _tokenId,
314         uint price,
315         uint8 v,
316         bytes32 r,
317         bytes32 s
318     ) public payable {
319 
320         string memory m_price = uint2hexstr(price);
321         string memory m_token = uint2hexstr(_tokenId);
322 
323         require(msg.value >= price);
324         require(ecrecover(keccak256("\x19Ethereum Signed Message:\n", length, m_token, m_price), v, r, s) == _issuer);
325         require(registry[_tokenId].owner == 0x0);
326         _transfer(msg.sender, _tokenId);
327     }
328 
329     /**
330      * UTILS
331      */
332 
333     /**
334      * @dev Add token to specified address tokens list.
335      * @param owner address address of token owner to add token to.
336      * @param value uint token ID to add.
337      */
338     function push(address owner, uint value) private {
339 
340         if (ownedTokens[owner].lookup[value] > 0) {
341             return;
342         }
343         ownedTokens[owner].lookup[value] = ownedTokens[owner].items.push(value);
344     }
345 
346     /**
347      * @dev Remove token by ID from specified address tokens list.
348      * @param owner address address of token owner to remove token from.
349      * @param value uint token ID to remove.
350      */
351     function removeByValue(address owner, uint value) private {
352         uint index = ownedTokens[owner].lookup[value];
353         if (index == 0) {
354             return;
355         }
356         if (index < ownedTokens[owner].items.length) {
357             uint256 lastItem = ownedTokens[owner].items[ownedTokens[owner].items.length - 1];
358             ownedTokens[owner].items[index - 1] = lastItem;
359             ownedTokens[owner].lookup[lastItem] = index;
360         }
361         ownedTokens[owner].items.length -= 1;
362         delete ownedTokens[owner].lookup[value];
363     }
364 
365 
366     /**
367      * @dev String concatenation.
368      * @param _a string first string.
369      * @param _b string second string.
370      * @return string result of string concatenation.
371      */
372     function strConcat(string _a, string _b) internal pure returns (string){
373         bytes memory _ba = bytes(_a);
374         bytes memory _bb = bytes(_b);
375         string memory abcde = new string(_ba.length + _bb.length);
376         bytes memory babcde = bytes(abcde);
377         uint k = 0;
378         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
379         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
380 
381         return string(babcde);
382     }
383 
384     /**
385      * @dev Convert long to hex string.
386      * @param i uint value to convert.
387      * @return string specified value converted to hex string.
388      */
389     function uint2hexstr(uint i) internal pure returns (string) {
390         if (i == 0) return "0";
391         uint j = i;
392         uint length;
393         while (j != 0) {
394             length++;
395             j = j >> 4;
396         }
397         uint mask = 15;
398         bytes memory bstr = new bytes(length);
399         uint k = length - 1;
400         while (i != 0){
401             uint curr = (i & mask);
402             bstr[k--] = curr > 9 ? byte(55 + curr) : byte(48 + curr); // 55 = 65 - 10
403             i = i >> 4;
404         }
405 
406         return string(bstr);
407     }
408 
409 }