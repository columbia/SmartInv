1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address tokenOwner) public view returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint256 tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
13 }
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         require(c >= a);
22         return c;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         require(b <= a);
26         c = a - b;
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         if (a == 0) {
31             return 0;
32         }
33         c = a * b;
34         require(c / a == b);
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
38         require(b != 0);
39         c = a / b;
40         return c;
41     }
42 }
43 
44 contract GGCToken is ERC20Interface{
45     using SafeMath for uint256;
46     using SafeMath for uint8;
47 
48     // ------------------------------------------------------------------------
49     // Events
50     // ------------------------------------------------------------------------
51     //typeNo WL 1, ACL 2, BL 3, FeeL 4, TransConL 5, GGCPool 6, GGEPool 7
52     event ListLog(address addr, uint8 indexed typeNo, bool active);
53     event Trans(address indexed fromAddr, address indexed toAddr, uint256 transAmount, uint256 ggcAmount, uint256 ggeAmount, uint64 time);
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55     event Deposit(address indexed sender, uint value);
56 
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint8 public ggcFee; 
61     uint8 public ggeFee; 
62     uint8 public maxFee;
63     uint256 public _totalSupply;
64 
65     bool public feeLocked; 
66     bool public transContractLocked;
67 
68     address public owner;
69     address public ggcPoolAddr;
70     address public ggePoolAddr;     
71     address private ownerContract = address(0x0);
72     
73     mapping(address => uint256) balances;
74     mapping(address => mapping(address => uint256)) allowed;
75     mapping(address => bool) public whiteList;
76     mapping(address => bool) public allowContractList;
77     mapping(address => bool) public blackList;
78     
79     constructor() public {
80         symbol = "GGC";
81         name = "GramGold Coin";
82         owner = msg.sender;
83         decimals = 8;
84         ggcFee = 2;
85         ggeFee = 1; 
86         maxFee = 3;
87         _totalSupply = 600 * 10**uint256(decimals);
88         balances[owner] = _totalSupply;
89         ggcPoolAddr = address(0x0);
90         ggePoolAddr = address(0x0);
91         feeLocked = false;
92         transContractLocked = true;
93         whiteList[owner] = true; 
94         emit ListLog(owner, 1, true);
95         emit Transfer(address(0x0), owner, _totalSupply);
96     }
97     
98     /**
99     * @dev Allow current contract owner transfer ownership to other address
100     */
101     function AssignGGCOwner(address _ownerContract) 
102     public 
103     onlyOwner 
104     notNull(_ownerContract) 
105     {
106         uint256 remainTokens = balances[owner];
107         ownerContract = _ownerContract;
108         balances[owner] = 0;
109         balances[ownerContract] = balances[ownerContract].add(remainTokens);
110         whiteList[ownerContract] = true; 
111         emit ListLog(ownerContract, 1, true);
112         emit Transfer(owner, ownerContract, remainTokens);
113         emit OwnershipTransferred(owner, ownerContract);
114         owner = ownerContract;
115     }
116 
117     /**
118     * @dev Check if the address is a wallet or a contract
119     */
120     function isContract(address _addr) 
121     private 
122     view 
123     returns (bool) 
124     {
125         if(allowContractList[_addr] || !transContractLocked){
126             return false;
127         }
128 
129         uint256 codeLength = 0;
130 
131         assembly {
132             codeLength := extcodesize(_addr)
133         }
134         
135         return (codeLength > 0);
136     }
137 
138     /**
139     * @dev transfer _value from msg.sender to receiver
140     * Both sender and receiver pays a transaction fees
141     * The transaction fees will be transferred into GGCPool and GGEPool
142     */
143     function transfer(address _to, uint256 _value) 
144     public 
145     notNull(_to) 
146     returns (bool success) 
147     {
148         uint256 ggcFeeFrom;
149         uint256 ggeFeeFrom;
150         uint256 ggcFeeTo;
151         uint256 ggeFeeTo;
152 
153         if (feeLocked) {
154             ggcFeeFrom = 0;
155             ggeFeeFrom = 0;
156             ggcFeeTo = 0;
157             ggeFeeTo = 0;
158         }else{
159             (ggcFeeFrom, ggeFeeFrom) = feesCal(msg.sender, _value);
160             (ggcFeeTo, ggeFeeTo) = feesCal(_to, _value);
161         }
162 
163         require(balances[msg.sender] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));
164         success = _transfer(msg.sender, _to, _value.sub(ggcFeeTo).sub(ggeFeeTo));
165         require(success);
166         success = _transfer(msg.sender, ggcPoolAddr, ggcFeeFrom.add(ggcFeeTo));
167         require(success);
168         success = _transfer(msg.sender, ggePoolAddr, ggeFeeFrom.add(ggeFeeTo));
169         require(success);
170 
171         balances[msg.sender] = balances[msg.sender].sub(_value.add(ggcFeeFrom).add(ggeFeeFrom));
172         balances[_to] = balances[_to].add(_value.sub(ggcFeeTo).sub(ggeFeeTo));
173         balances[ggcPoolAddr] = balances[ggcPoolAddr].add(ggcFeeFrom).add(ggcFeeTo);
174         balances[ggePoolAddr] = balances[ggePoolAddr].add(ggeFeeFrom).add(ggeFeeTo); 
175 
176         emit Trans(msg.sender, _to, _value, ggcFeeFrom.add(ggcFeeTo), ggeFeeFrom.add(ggeFeeTo), uint64(now));
177         return true;
178     }
179 
180     /**
181     * @dev transfer _value from contract owner to receiver
182     * Both contract owner and receiver pay transaction fees 
183     * The transaction fees will be transferred into GGCPool and GGEPool
184     */
185     function transferFrom(address _from, address _to, uint256 _value) 
186     public 
187     notNull(_to) 
188     returns (bool success) 
189     {
190         uint256 ggcFeeFrom;
191         uint256 ggeFeeFrom;
192         uint256 ggcFeeTo;
193         uint256 ggeFeeTo;
194 
195         if (feeLocked) {
196             ggcFeeFrom = 0;
197             ggeFeeFrom = 0;
198             ggcFeeTo = 0;
199             ggeFeeTo = 0;
200         }else{
201             (ggcFeeFrom, ggeFeeFrom) = feesCal(_from, _value);
202             (ggcFeeTo, ggeFeeTo) = feesCal(_to, _value);
203         }
204 
205         require(balances[_from] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));
206         require(allowed[_from][msg.sender] >= _value.add(ggcFeeFrom).add(ggeFeeFrom));
207 
208         success = _transfer(_from, _to, _value.sub(ggcFeeTo).sub(ggeFeeTo));
209         require(success);
210         success = _transfer(_from, ggcPoolAddr, ggcFeeFrom.add(ggcFeeTo));
211         require(success);
212         success = _transfer(_from, ggePoolAddr, ggeFeeFrom.add(ggeFeeTo));
213         require(success);
214 
215         balances[_from] = balances[_from].sub(_value.add(ggcFeeFrom).add(ggeFeeFrom));
216         balances[_to] = balances[_to].add(_value.sub(ggcFeeTo).sub(ggeFeeTo));
217         balances[ggcPoolAddr] = balances[ggcPoolAddr].add(ggcFeeFrom).add(ggcFeeTo);
218         balances[ggePoolAddr] = balances[ggePoolAddr].add(ggeFeeFrom).add(ggeFeeTo); 
219 
220         emit Trans(_from, _to, _value, ggcFeeFrom.add(ggcFeeTo), ggeFeeFrom.add(ggeFeeTo), uint64(now));
221         return true;
222     }
223 
224     /**
225     * @dev calculate transaction fee base on address and value.
226     * Check whiteList
227     */
228     function feesCal(address _addr, uint256 _value)
229     public
230     view
231     notNull(_addr) 
232     returns (uint256 _ggcFee, uint256 _ggeFee)
233     {
234         if(whiteList[_addr]){
235             return (0, 0);
236         }else{
237             _ggcFee = _value.mul(ggcFee).div(1000).div(2);
238             _ggeFee = _value.mul(ggeFee).div(1000).div(2);
239             return (_ggcFee, _ggeFee);
240         }
241     }
242 
243     /**
244     * @dev both transfer and transferfrom are dispatched here
245     * Check blackList
246     */
247     function _transfer(address _from, address _to, uint256 _value) 
248     internal 
249     notNull(_from) 
250     notNull(_to) 
251     returns (bool) 
252     {
253         require(!blackList[_from]);
254         require(!blackList[_to]);       
255         require(!isContract(_to));
256         
257         emit Transfer(_from, _to, _value);
258         
259         return true;
260     }
261 
262     /**
263     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264     * @param _spender The address which will spend the funds.
265     * @param _value The amount of tokens to be spent.
266     */
267     function approve(address _spender, uint256 _value) 
268     public 
269     returns (bool success) 
270     {
271         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
272             return false;
273         }
274 
275         allowed[msg.sender][_spender] = _value;
276         emit Approval(msg.sender, _spender, _value);
277         return true;
278     }
279 
280     /**
281     * @dev Function to check the amount of tokens that an owner allowed to a spender.
282     * @param _tokenOwner address The address which owns the funds.
283     * @param _spender address The address which will spend the funds.
284     * @return A uint256 specifying the amount of tokens still available for the spender.
285     */
286     function allowance(address _tokenOwner, address _spender) 
287     public 
288     view 
289     returns (uint256 remaining) 
290     {
291         return allowed[_tokenOwner][_spender];
292     }
293     
294     function() 
295     payable
296     {
297         if (msg.value > 0)
298             emit Deposit(msg.sender, msg.value);
299     }
300 
301     /**
302     * @dev Reject all ERC223 compatible tokens
303     * @param from_ address The address that is transferring the tokens
304     * @param value_ uint256 the amount of the specified token
305     * @param data_ Bytes The data passed from the caller.
306     */
307     function tokenFallback(address from_, uint256 value_, bytes data_) 
308     external 
309     {
310         from_;
311         value_;
312         data_;
313         revert();
314     }
315     
316     // ------------------------------------------------------------------------
317     // Modifiers
318     // ------------------------------------------------------------------------
319     modifier onlyOwner {
320         require(msg.sender == owner);
321         _;
322     }
323 
324     modifier notNull(address _address) {
325         require(_address != address(0x0));
326         _;
327     }
328 
329     // ------------------------------------------------------------------------
330     // onlyOwner API
331     // ------------------------------------------------------------------------
332     function setGGCAddress(address _addr) 
333     public 
334     notNull(_addr) 
335     onlyOwner 
336     {
337         if(ggcPoolAddr == address(0x0)){
338             ggcPoolAddr = _addr;    
339         }else{
340             ggcPoolAddr = owner;
341         }
342         
343         emit ListLog(ggcPoolAddr, 6, false);
344     }
345 
346     function setGGEAddress(address _addr) 
347     public 
348     notNull(_addr) 
349     onlyOwner 
350     {
351         if(ggePoolAddr == address(0x0)){
352             ggePoolAddr = _addr;    
353         }else{
354             ggePoolAddr = owner;
355         }
356                         
357         emit ListLog(ggePoolAddr, 7, false);
358     }
359 
360     function setGGCFee(uint8 _val) 
361     public 
362     onlyOwner 
363     {
364         require(ggeFee.add(_val) <= maxFee);
365         ggcFee = _val;
366     }
367 
368     function setGGEFee(uint8 _val) 
369     public 
370     onlyOwner 
371     {
372         require(ggcFee.add(_val) <= maxFee);
373         ggeFee = _val;
374     }
375     
376     function addBlacklist(address _addr) public notNull(_addr) onlyOwner {
377         blackList[_addr] = true; 
378         emit ListLog(_addr, 3, true);
379     }
380     
381     function delBlackList(address _addr) public notNull(_addr) onlyOwner {
382         delete blackList[_addr];                
383         emit ListLog(_addr, 3, false);
384     }
385 
386     function setFeeLocked(bool _lock) 
387     public 
388     onlyOwner 
389     {
390         feeLocked = _lock;    
391         emit ListLog(address(0x0), 4, _lock); 
392     }
393 
394     function setTransContractLocked(bool _lock) 
395     public 
396     onlyOwner 
397     {
398         transContractLocked = _lock;                  
399         emit ListLog(address(0x0), 5, _lock); 
400     }
401 
402     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) 
403     public 
404     onlyOwner 
405     returns (bool success) 
406     {
407         return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
408     }
409 
410     function reclaimEther(address _addr) 
411     external 
412     onlyOwner 
413     {
414         assert(_addr.send(this.balance));
415     }
416   
417     function mintToken(address _targetAddr, uint256 _mintedAmount) 
418     public 
419     onlyOwner 
420     {
421         balances[_targetAddr] = balances[_targetAddr].add(_mintedAmount);
422         _totalSupply = _totalSupply.add(_mintedAmount);
423         
424         emit Transfer(address(0x0), _targetAddr, _mintedAmount);
425     }
426  
427     function burnToken(uint256 _burnedAmount) 
428     public 
429     onlyOwner 
430     {
431         require(balances[owner] >= _burnedAmount);
432         
433         balances[owner] = balances[owner].sub(_burnedAmount);
434         _totalSupply = _totalSupply.sub(_burnedAmount);
435         
436         emit Transfer(owner, address(0x0), _burnedAmount);
437     }
438 
439     function addWhiteList(address _addr) 
440     public 
441     notNull(_addr) 
442     onlyOwner 
443     {
444         whiteList[_addr] = true; 
445         emit ListLog(_addr, 1, true);
446     }
447   
448     function delWhiteList(address _addr) 
449     public 
450     notNull(_addr) 
451     onlyOwner
452     {
453         delete whiteList[_addr];
454         emit ListLog(_addr, 1, false);
455     }
456 
457     function addAllowContractList(address _addr) 
458     public 
459     notNull(_addr) 
460     onlyOwner 
461     {
462         allowContractList[_addr] = true; 
463         emit ListLog(_addr, 2, true);
464     }
465   
466     function delAllowContractList(address _addr) 
467     public 
468     notNull(_addr) 
469     onlyOwner 
470     {
471         delete allowContractList[_addr];
472         emit ListLog(_addr, 2, false);
473     }
474 
475     function increaseApproval(address _spender, uint256 _addedValue) 
476     public 
477     notNull(_spender) 
478     onlyOwner returns (bool) 
479     {
480         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
481         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
482         return true;
483    }
484 
485     function decreaseApproval(address _spender, uint256 _subtractedValue) 
486     public 
487     notNull(_spender) 
488     onlyOwner returns (bool) 
489     {
490         uint256 oldValue = allowed[msg.sender][_spender];
491         if (_subtractedValue > oldValue) { 
492             allowed[msg.sender][_spender] = 0;
493         } else {
494             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
495         }
496         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
497         return true;
498     }
499 
500     function changeName(string _name, string _symbol) 
501     public
502     onlyOwner
503     {
504         name = _name;
505         symbol = _symbol;
506     }
507     // ------------------------------------------------------------------------
508     // Public view API
509     // ------------------------------------------------------------------------
510     function balanceOf(address _tokenOwner) 
511     public 
512     view 
513     returns (uint256 balance) 
514     {
515         return balances[_tokenOwner];
516     }
517     
518     function totalSupply() 
519     public 
520     view 
521     returns (uint256) 
522     {
523         return _totalSupply.sub(balances[address(0x0)]);
524     }
525 }