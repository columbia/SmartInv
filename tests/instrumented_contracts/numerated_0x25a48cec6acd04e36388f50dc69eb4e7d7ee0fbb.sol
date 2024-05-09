1 pragma solidity ^0.4.20;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) onlyOwner public {
20     require(newOwner != address(0));
21   emit OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 
25 }
26 
27 
28 contract ERC721 {
29     
30     function totalSupply() public view returns (uint256 total);
31     function balanceOf(address _owner) public view returns (uint256 balance);
32     function ownerOf(uint256 _tokenId) external view returns (address owner, uint256 tokenId);
33     function approve(address _to, uint256 _tokenId) external;
34     function transfer(address _to, uint256 _tokenId) external payable;
35     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
36 
37 
38     event Transfer(address from, address to, uint256 tokenId);
39     event Approval(address owner, address approved, uint256 tokenId);
40     
41     
42     
43 }
44 
45 
46 
47 contract JockeyControl  {
48 
49     address public ceoAddress=0xf75Da6b04108394fDD349f47d58452A6c8Aeb236;
50     address public ctoAddress=0x833184cE7DF8E56a716B7738548BfC488E428Da5;
51  
52 
53     modifier onCEO() {
54         require(msg.sender == ceoAddress);
55         _;
56     }
57 
58     modifier onCTO() {
59         require(msg.sender == ctoAddress);
60         _;
61     }
62 
63     modifier onlyC() {
64         require(
65             msg.sender == ceoAddress ||
66             msg.sender == ctoAddress
67         );
68         _;
69     }
70 
71  
72 }
73 
74 
75 
76 
77 
78 contract HoresBasis is  JockeyControl {
79    
80     event Birth(address owner, uint256 JockeyId);
81    
82     event Transfer(address from, address to, uint256 tokenId);
83 
84     struct Jockey {
85         uint64 birthTime;
86         uint256 dna1;
87         uint256 dna2;
88         uint256 dna3;
89         uint256 dna4;
90         uint256 dna5;
91         uint256 dna6;
92         uint256 dna7;
93         uint256 dna8;
94         
95     }
96 
97 
98     Jockey[] jockeys;
99 
100     mapping (uint256 => address) jockeyOwnerIndex;
101     
102     mapping (uint256 => uint256) public jockeyIndexPrice;
103     
104     mapping (uint256 => uint256) public jockeyHair;
105     
106     mapping (uint256 => uint256) public jockeySkin;
107     
108     mapping (uint256 => uint256) public jockeyHLength;
109     
110     mapping (uint256 => bool)  jockeyIndexForSale;
111 
112     mapping (address => uint256) tokenOwnershipCount;
113 
114 
115    uint256 public saleFee = 20;
116 
117    
118    
119  
120     function _transfer(address _from, address _to, uint256 _tokenId) internal {
121         tokenOwnershipCount[_to]++;
122         jockeyOwnerIndex[_tokenId] = _to;
123         
124         if (_from != address(0)) {
125             tokenOwnershipCount[_from]--;
126          
127         }
128        emit Transfer(_from, _to, _tokenId);
129        
130     }
131     
132     
133     function _sell(address _from,  uint256 _tokenId, uint256 value) internal {
134      
135      if(jockeyIndexForSale[_tokenId]==true){
136          
137               uint256 price = jockeyIndexPrice[_tokenId];
138             
139             require(price<=value);
140             
141          uint256 Fee = price / saleFee;
142             
143           uint256  oPrice= price - Fee;
144             
145             address _to = msg.sender;
146             
147             tokenOwnershipCount[_to]++;
148             jockeyOwnerIndex[_tokenId] = _to;
149             
150             jockeyIndexForSale[_tokenId]=false;
151             
152             
153             if (_from != address(0)) {
154                 tokenOwnershipCount[_from]--;
155                
156             }
157                  
158            emit Transfer(_from, _to, _tokenId);
159              
160              _from.transfer(oPrice);
161              
162              ceoAddress.transfer(Fee);
163              
164             uint256 bidExcess = value - oPrice - Fee;
165             _to.transfer(bidExcess);
166             
167             
168      }else{
169           _to.transfer(value);
170      }
171       
172     }
173     
174     
175 	
176     function _newJockey(
177         uint256 _genes1,
178         uint256 _genes2,
179         uint256 _genes3,
180         uint256 _genes4,
181         uint256 _genes5,
182         uint256 _genes6,
183         uint256 _genes7,
184         uint256 _genes8,
185         address _owner
186     )
187         internal
188         returns (uint)
189     {
190    
191    
192    
193    
194         Jockey memory _jockey = Jockey({
195            birthTime: uint64(now),
196            
197              
198         dna1:_genes1,
199         dna2: _genes2,
200         dna3 : _genes3,
201         dna4 : _genes4,
202         dna5 : _genes5,
203         dna6 : _genes6,
204         dna7:_genes7,
205         dna8: _genes8
206             
207         });
208        
209        
210         
211        uint256 newJockeyId;
212 	   
213      newJockeyId = jockeys.push(_jockey)-1;
214      
215   
216         require(newJockeyId == uint256(uint32(newJockeyId)));
217 
218 
219         
220         
221        emit Birth(_owner, newJockeyId);
222 
223         _transfer(0, _owner, newJockeyId);
224 
225         return newJockeyId;  
226     }
227 
228 
229 
230 }
231 
232 
233 contract JockeyOwnership is HoresBasis, ERC721{
234 
235   string public constant  name = "CryptoJockey";
236     string public constant symbol = "CHJ";
237      uint8 public constant decimals = 0; 
238 
239     function jockeyForSale(uint256 _tokenId, uint256 price) external {
240   
241      address  ownerof =  jockeyOwnerIndex[_tokenId];
242         require(ownerof == msg.sender);
243         jockeyIndexPrice[_tokenId] = price;
244         jockeyIndexForSale[_tokenId]= true;
245 		}
246 		
247  function changePrice(uint256 _tokenId, uint256 price) external {
248   
249      address  ownerof =  jockeyOwnerIndex[_tokenId];
250         require(ownerof == msg.sender);
251         require(jockeyIndexForSale[_tokenId] == true);
252        
253              
254               jockeyIndexPrice[_tokenId] = price;
255          
256 		}
257 
258  function jockeyNotForSale(uint256 _tokenId) external {
259          address  ownerof =  jockeyOwnerIndex[_tokenId];
260             require(ownerof == msg.sender);
261         jockeyIndexForSale[_tokenId]= false;
262 
263     }
264 
265 
266     function _owns(address _applicant, uint256 _tokenId) internal view returns (bool) {
267         return jockeyOwnerIndex[_tokenId] == _applicant;
268     }
269 
270 
271     function balanceOf(address _owner) public view returns (uint256 count) {
272         return tokenOwnershipCount[_owner];
273     }
274 
275     function transfer(
276         address _to,
277         uint256 _tokenId
278     )
279         external
280         payable
281     {
282         require(_to != address(0));
283 		
284         require(_to != address(this));
285  
286         require(_owns(msg.sender, _tokenId));
287        _transfer(msg.sender, _to, _tokenId);
288     }
289 
290     function approve(
291         address _to,
292         uint256 _tokenId
293     )
294         external 
295     {
296        require(_owns(msg.sender, _tokenId));
297 
298         emit Approval(msg.sender, _to, _tokenId);
299     }
300 
301     function transferFrom(address _from, address _to, uint256 _tokenId ) external payable {
302         
303         if(_from != msg.sender){
304               require(_to == msg.sender);
305                  
306                 require(_from==jockeyOwnerIndex[_tokenId]);
307         
308                _sell(_from,  _tokenId, msg.value);
309             
310         }else{
311             
312           _to.transfer(msg.value);
313         }
314  
315     }
316 
317     function totalSupply() public view returns (uint) {
318         return jockeys.length;
319     }
320 
321     function ownerOf(uint256 _tokenId)  external view returns (address owner, uint256 tokenId)  {
322         owner = jockeyOwnerIndex[_tokenId];
323         tokenId=_tokenId;
324        
325        return;
326        
327     }
328 
329        function jockeyFS(uint256 _tokenId) external view  returns (bool buyable, uint256 tokenId) {
330         buyable = jockeyIndexForSale[_tokenId];
331         tokenId=_tokenId;
332        return;
333        
334     }
335 	
336 	function jockeyPr(uint256 _tokenId) external view  returns (uint256 price, uint256 tokenId) {
337         price = jockeyIndexPrice[_tokenId];
338         tokenId=_tokenId;
339        return;
340        
341     }
342 
343  function setSaleFee(uint256 val) external onCTO {
344         saleFee = val;
345     }
346 
347     
348 }
349 
350 
351 contract JockeyMinting is JockeyOwnership {
352 
353     uint256 public  JOCKEY_LIMIT = 20000;
354 
355 
356     function createJockey(uint256 _genes1,uint256 _genes2,uint256 _genes3,uint256 _genes4,uint256 _genes5,uint256 _genes6,uint256 _genes7,uint256 _genes8,uint256 jHair,uint256 jHLenth,uint256 jSkin, address _owner) external onlyC {
357         address jockeyOwner = _owner;
358         
359    require(jockeys.length < JOCKEY_LIMIT);
360 
361             
362               _newJockey(  _genes1, _genes2, _genes3, _genes4, _genes5, _genes6,_genes7, _genes8,  jockeyOwner);
363             
364             
365         uint256   jId=jockeys.length;
366             
367         jockeyHair[jId] = jHair;
368         jockeyHLength[jId] = jHLenth;
369         jockeySkin[jId] = jSkin;
370             
371         
372     }
373 
374    
375 }
376 
377 
378 contract GetTheJockey is JockeyMinting {
379 
380 
381     function getJockey(uint256 _id)
382         external
383         view
384         returns (
385         uint256 price,
386         uint256 id,
387         bool forSale,
388         uint256 birthTime,
389         uint256 _genes1,
390         uint256 _genes2,
391         uint256 _genes3,
392         uint256 _genes4,
393         uint256 _genes5,
394         uint256 _genes6,
395         uint256 _genes7,
396         uint256 _genes8
397 		
398     ) {
399 		price = jockeyIndexPrice[_id];
400         id = uint256(_id);
401 		forSale = jockeyIndexForSale[_id];
402         Jockey storage horseman = jockeys[_id];
403         birthTime = uint256(horseman.birthTime);
404         _genes1 = horseman.dna1;
405         _genes2 = horseman.dna2;
406         _genes3 = horseman.dna3;
407         _genes4 = horseman.dna4;
408         _genes5 = horseman.dna5;
409         _genes6 = horseman.dna6;  
410         _genes7 = horseman.dna7;
411         _genes8 = horseman.dna8;
412 
413     }
414 
415   
416 
417 }