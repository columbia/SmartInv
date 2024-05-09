1 /***
2 * 
3 *           _____                    _____                _____                    _____          
4 *          /\    \                  /\    \              /\    \                  /\    \         
5 *         /::\    \                /::\    \            /::\    \                /::\    \        
6 *        /::::\    \              /::::\    \           \:::\    \              /::::\    \       
7 *       /::::::\    \            /::::::\    \           \:::\    \            /::::::\    \      
8 *      /:::/\:::\    \          /:::/\:::\    \           \:::\    \          /:::/\:::\    \     
9 *     /:::/  \:::\    \        /:::/__\:::\    \           \:::\    \        /:::/  \:::\    \    
10 *    /:::/    \:::\    \      /::::\   \:::\    \          /::::\    \      /:::/    \:::\    \   
11 *   /:::/    / \:::\    \    /::::::\   \:::\    \        /::::::\    \    /:::/    / \:::\    \  
12 *  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\ ___\      /:::/\:::\    \  /:::/    /   \:::\    \ 
13 * /:::/____/     \:::|    |/:::/__\:::\   \:::|    |    /:::/  \:::\____\/:::/____/     \:::\____\
14 * \:::\    \     /:::|____|\:::\   \:::\  /:::|____|   /:::/    \::/    /\:::\    \      \::/    /
15 *  \:::\    \   /:::/    /  \:::\   \:::\/:::/    /   /:::/    / \/____/  \:::\    \      \/____/ 
16 *   \:::\    \ /:::/    /    \:::\   \::::::/    /   /:::/    /            \:::\    \             
17 *    \:::\    /:::/    /      \:::\   \::::/    /   /:::/    /              \:::\    \            
18 *     \:::\  /:::/    /        \:::\  /:::/    /    \::/    /                \:::\    \           
19 *      \:::\/:::/    /          \:::\/:::/    /      \/____/                  \:::\    \          
20 *       \::::::/    /            \::::::/    /                                 \:::\    \         
21 *        \::::/    /              \::::/    /                                   \:::\____\        
22 *         \::/____/                \::/____/                                     \::/    /        
23 *          ~~                       ~~                                            \/____/         
24 *                                                                                                 
25 * 
26 *     
27 * https://dbtc.plus v1.0.1
28 */
29 
30 pragma solidity 0.5.17;   
31 
32 library SafeMath {
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, "SafeMath: subtraction overflow");
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b > 0, "SafeMath: division by zero");
61         uint256 c = a / b;
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0, "SafeMath: modulo by zero");
67         return a % b;
68     }
69 }
70 
71 interface InterfaceDividend {
72     function withdrawDividendsEverything() external returns(bool);
73 }
74 
75 
76 contract ownerShip
77 {
78     address payable public owner;
79     address payable public newOwner;
80 
81     event OwnershipTransferredEv(uint256 timeOfEv, address payable indexed previousOwner, address payable indexed newOwner);
82 
83     constructor() public 
84     {
85         owner = msg.sender;
86     }
87 
88     modifier onlyOwner() 
89     {
90         require(msg.sender == owner);
91         _;
92     }
93 
94 
95     function transferOwnership(address payable _newOwner) public onlyOwner 
96     {
97         newOwner = _newOwner;
98     }
99 
100     function acceptOwnership() public 
101     {
102         require(msg.sender == newOwner);
103         emit OwnershipTransferredEv(now, owner, newOwner);
104         owner = newOwner;
105         newOwner = address(0);
106     }
107 
108 }
109 
110 contract DBTC is ownerShip {
111   
112     using SafeMath for uint256;       
113     string constant public name="Decentralized Bitcoin";
114     string constant public symbol="DBTC";
115     uint256 constant public decimals=18;
116     uint256 public totalSupply = 210000 * ( 10 ** decimals);
117     uint256 public minTotalSupply = 2100 * ( 10 ** decimals);
118     uint256 public constant minSupply = 21 * ( 10 ** decimals);
119     uint256 public  _burnPercent = 500;  // 500 = 5%
120     uint256 public  _burnPercentAll = 1000;  // 1000 = 10%
121     uint256 public constant _invite1Percent = 300;  // 300 = 3%
122     uint256 public constant _invite2Percent = 200;  // 200 =2%
123     address public constant uni = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
124     address public constant AirdropAddress = address(0x91De8F260f05d0aB3C51911d8B43793D82B84d66);
125     address public constant CreateAddress = address(0x4b5d1ebFe85f399B728F655f77142459470549A6);
126     address public TradeAddress;
127     
128     address public dividendContractAdderess;
129 
130     struct Miner {
131       address address1;
132       address address2;
133     }
134 
135     mapping(address => Miner) public miners;
136 
137     mapping (address => uint256) public balanceOf;
138     mapping (address => mapping (address => uint256)) public allowance;
139 
140     event Transfer(address indexed from, address indexed to, uint256 value);
141     event Approval(address indexed approvedBy, address indexed spender, uint256 value);
142     event WhitelistFrom(address _addr, bool _whitelisted);
143     event WhitelistTo(address _addr, bool _whitelisted);
144 
145     mapping(address => bool) public whitelistFrom;
146     mapping(address => bool) public whitelistTo;
147   
148     constructor( ) public
149     {
150         balanceOf[CreateAddress] = 170000 * ( 10 ** decimals);
151         balanceOf[AirdropAddress] = 40000 * ( 10 ** decimals);
152         emit Transfer(address(0), CreateAddress, 170000 * ( 10 ** decimals));
153         emit Transfer(address(0), AirdropAddress, 40000 * ( 10 ** decimals));
154     }
155     
156     function () payable external {}
157     
158 
159     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
160         return whitelistFrom[_from]||whitelistTo[_to];
161     }
162 
163     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
164         emit WhitelistTo(_addr, _whitelisted);
165         whitelistTo[_addr] = _whitelisted;
166     }
167 
168     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
169         emit WhitelistFrom(_addr, _whitelisted);
170         whitelistFrom[_addr] = _whitelisted;
171     }
172 
173     function _transfer(address _from, address _to, uint _value) internal {
174         require(_value <= balanceOf[_from], 'Not enough balance');  
175         balanceOf[_from] = balanceOf[_from].sub(_value);    
176         balanceOf[_to] = balanceOf[_to].add(_value);        
177 
178         emit Transfer(_from, _to, _value);
179     }
180 
181     function transfer(address _to, uint256 _value) public returns (bool success) {
182 
183         if(totalSupply <= minTotalSupply){
184             _burnPercent = 0;
185             _burnPercentAll = 0;
186         }
187 
188         uint256 invite1to = calculatePercentage(_value,_invite1Percent);
189         uint256 invite2to = calculatePercentage(_value,_invite2Percent);
190         uint256 tokensToBurn = calculatePercentage(_value,_burnPercent);
191         uint256 tokensToBurnAll = calculatePercentage(_value,_burnPercentAll);
192 
193         if(_isWhitelisted(msg.sender, _to)){
194             if ( _to != msg.sender && _to != TradeAddress && _to != uni && _to != AirdropAddress && _to != CreateAddress){
195                 if(miners[_to].address1 == address(0)){
196                     miners[_to].address1 = msg.sender;
197                 }
198             }
199             _transfer(msg.sender, _to, _value - tokensToBurnAll);
200             _burn(msg.sender, tokensToBurnAll);
201             return true;
202         }
203 
204         if(msg.sender == uni && _to == TradeAddress){
205             _transfer(msg.sender, _to, _value);
206             return true;
207         } else if (msg.sender == TradeAddress && _to == uni){
208             _transfer(msg.sender, _to, _value);
209             return true;
210         }
211 
212         if(msg.sender == TradeAddress  && _to != uni){
213             if (miners[_to].address1 != address(0) && miners[_to].address2 != address(0)){
214                 if (balanceOf[miners[_to].address1] >= minSupply && balanceOf[miners[_to].address2] >= minSupply){
215                     _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
216                     _transfer(msg.sender, miners[_to].address1,invite1to);
217                     _transfer(msg.sender, miners[_to].address2,invite2to);
218                     _burn(msg.sender, tokensToBurn);
219                     return true;
220                 } else if (balanceOf[miners[_to].address1] >= minSupply && balanceOf[miners[_to].address2] < minSupply){
221                     _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
222                     _transfer(msg.sender, miners[_to].address1,invite1to);
223                     _burn(msg.sender, tokensToBurn + invite2to);
224                     return true;
225                 } else if (balanceOf[miners[_to].address1] < minSupply && balanceOf[miners[_to].address2] >= minSupply){
226                     _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
227                     _transfer(msg.sender, miners[_to].address2,invite2to);
228                     _burn(msg.sender, tokensToBurn + invite1to);
229                     return true;
230                 } else {
231                     _transfer(msg.sender, _to, _value - tokensToBurnAll);
232                     _burn(msg.sender, tokensToBurnAll);
233                     return true;
234                 }
235             } else if (miners[_to].address1 != address(0)){
236                 if (balanceOf[miners[_to].address1] >= minSupply){
237                     _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn );
238                     _transfer(msg.sender, miners[_to].address1,invite1to);
239                     _burn(msg.sender, tokensToBurn + invite2to);
240                     return true;
241                 } else {
242                     _transfer(msg.sender, _to, _value - tokensToBurnAll);
243                     _burn(msg.sender, tokensToBurnAll);
244                     return true;
245                 }
246             }        
247         }
248 
249         if (miners[msg.sender].address1 != address(0) && miners[msg.sender].address2 != address(0) && miners[_to].address1 != address(0)){
250             if (balanceOf[miners[msg.sender].address1] >= minSupply && balanceOf[miners[msg.sender].address2] >= minSupply){
251                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
252                 _transfer(msg.sender, miners[msg.sender].address1,invite1to);
253                 _transfer(msg.sender, miners[msg.sender].address2,invite2to);
254                 _burn(msg.sender, tokensToBurn);
255                 return true;
256             } else if (balanceOf[miners[msg.sender].address1] >= minSupply && balanceOf[miners[msg.sender].address2] < minSupply){
257                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
258                 _transfer(msg.sender, miners[msg.sender].address1,invite1to);
259                 _burn(msg.sender, tokensToBurn + invite2to);
260                 return true;
261             } else if (balanceOf[miners[msg.sender].address1] < minSupply && balanceOf[miners[msg.sender].address2] >= minSupply){
262                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
263                 _transfer(msg.sender, miners[msg.sender].address2,invite2to);
264                 _burn(msg.sender, tokensToBurn + invite1to);
265                 return true;
266             } else {
267                 _transfer(msg.sender, _to, _value - tokensToBurnAll);
268                 _burn(msg.sender, tokensToBurnAll);
269                 return true;
270             }
271         } else if (miners[msg.sender].address1 != address(0) && miners[msg.sender].address2 != address(0) && miners[_to].address1 == address(0)){
272             if (balanceOf[miners[msg.sender].address1] >= minSupply && balanceOf[miners[msg.sender].address2] >= minSupply){
273 
274                 if ( _to != msg.sender && _to != TradeAddress && _to != uni && _to != AirdropAddress && _to != CreateAddress){
275                     if(miners[_to].address1 == address(0)){
276                         if(balanceOf[msg.sender] >= minSupply){
277                         miners[_to].address1 = msg.sender;
278                         miners[_to].address2 = miners[msg.sender].address1;
279                         }
280                     }
281                 }
282 
283                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
284                 _transfer(msg.sender, miners[msg.sender].address1,invite1to);
285                 _transfer(msg.sender, miners[msg.sender].address2,invite2to);
286                 _burn(msg.sender, tokensToBurn);
287                 return true;
288             } else if (balanceOf[miners[msg.sender].address1] >= minSupply && balanceOf[miners[msg.sender].address2] < minSupply){
289 
290                 if ( _to != msg.sender && _to != TradeAddress && _to != uni && _to != AirdropAddress && _to != CreateAddress){
291                     if(miners[_to].address1 == address(0)){
292                         if(balanceOf[msg.sender] >= minSupply){
293                         miners[_to].address1 = msg.sender;
294                         }
295                     }
296                 }
297 
298                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
299                 _transfer(msg.sender, miners[msg.sender].address1,invite1to);
300                 _burn(msg.sender, tokensToBurn + invite2to);
301                 return true;
302             } else if (balanceOf[miners[msg.sender].address1] < minSupply && balanceOf[miners[msg.sender].address2] >= minSupply){
303                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
304                 _transfer(msg.sender, miners[msg.sender].address2,invite2to);
305                 _burn(msg.sender, tokensToBurn + invite1to );
306                 return true;
307             } else {
308                 _transfer(msg.sender, _to, _value - tokensToBurnAll);
309                 _burn(msg.sender, tokensToBurnAll);
310                 return true;
311             }
312         } else if (miners[msg.sender].address1 != address(0) && miners[msg.sender].address2 == address(0) && miners[_to].address1 == address(0)){
313             if (balanceOf[miners[msg.sender].address1] >= minSupply){
314 
315                 if ( _to != msg.sender && _to != TradeAddress && _to != uni && _to != AirdropAddress && _to != CreateAddress){
316                     if(balanceOf[msg.sender] >= minSupply){
317                     miners[_to].address1 = msg.sender;
318                     miners[_to].address2 = miners[msg.sender].address1;
319                     }
320                 }
321 
322                 _transfer(msg.sender, _to, _value - invite1to - invite2to - tokensToBurn);
323                 _transfer(msg.sender, miners[msg.sender].address1,invite1to);
324                 _burn(msg.sender, tokensToBurn + invite2to);
325                 return true;
326             } else {
327                 _transfer(msg.sender, _to, _value - tokensToBurnAll );
328                 _burn(msg.sender, tokensToBurnAll);
329                 return true;
330           }
331         } else if (miners[msg.sender].address1 == address(0) && miners[msg.sender].address2 == address(0) && miners[_to].address1 == address(0)){
332 
333                 if ( _to != msg.sender && _to != TradeAddress && _to != uni && _to != AirdropAddress && _to != CreateAddress){
334                     if(balanceOf[msg.sender] >= minSupply){
335                     miners[_to].address1 = msg.sender;
336                     }
337                 }
338 
339                 _transfer(msg.sender, _to, _value - tokensToBurnAll);
340                 _burn(msg.sender, tokensToBurnAll);
341                 return true;
342         }
343 
344         if(miners[_to].address1 == address(0)){
345             if(balanceOf[msg.sender] >= minSupply){
346             miners[_to].address1 = msg.sender;
347             }
348         }
349 
350         _transfer(msg.sender, _to, _value - tokensToBurnAll);
351         _burn(msg.sender, tokensToBurnAll);
352         return true;
353 
354     }
355 
356     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
357 
358         if(totalSupply <= minTotalSupply){
359             _burnPercent = 0;
360             _burnPercentAll = 0;
361         }
362 
363         uint256 tokensToBurn = calculatePercentage(_value,_burnPercent);
364         uint256 invite1to = calculatePercentage(_value,_invite1Percent);
365         uint256 invite2to = calculatePercentage(_value,_invite2Percent);
366         uint256 tokensToBurnAll = calculatePercentage(_value,_burnPercentAll);
367         
368         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
369 
370         if(_isWhitelisted(_from, _to)){
371             if ( _to != _from && _to != TradeAddress && _to != uni && _to != AirdropAddress && _to != CreateAddress){
372                 if ( miners[_to].address1 == address(0) ){
373                     miners[_to].address1 = _from;
374                 }
375             }
376             _transfer(_from, _to, _value - tokensToBurnAll);
377             _burn(_from, tokensToBurnAll);
378             return true;
379         }
380 
381         if(_from == uni && _to == TradeAddress){
382             _transfer(_from, _to, _value);
383             return true;
384         } else if (_from == TradeAddress && _to == uni){
385             _transfer(_from, _to, _value);
386             return true;
387         } 
388 
389         if (miners[_from].address1 != address(0) && miners[_from].address2 != address(0)){
390             if (balanceOf[miners[_from].address1] >= minSupply && balanceOf[miners[_from].address2] >= minSupply){
391                 _transfer(_from, _to, _value - invite1to - invite2to - tokensToBurn);
392                 _transfer(_from, miners[_from].address1,invite1to);
393                 _transfer(_from, miners[_from].address2,invite2to);
394                 _burn(_from, tokensToBurn);
395                 return true;
396             } else if (balanceOf[miners[_from].address1] >= minSupply && balanceOf[miners[_from].address2] < minSupply){
397                 _transfer(_from, _to, _value - invite1to - invite2to - tokensToBurn);
398                 _transfer(_from, miners[_from].address1,invite1to);
399                 _burn(_from, tokensToBurn + invite2to);
400                 return true;
401             } else if (balanceOf[miners[_from].address1] < minSupply && balanceOf[miners[_from].address2] >= minSupply){
402                 _transfer(_from, _to, _value - invite1to - invite2to - tokensToBurn);
403                 _transfer(_from, miners[_from].address2,invite2to);
404                 _burn(_from, tokensToBurn + invite1to);
405                 return true;
406             } else {
407                 _transfer(_from, _to, _value - tokensToBurnAll);
408                 _burn(_from, tokensToBurnAll);
409                 return true;
410             }
411         } else if (miners[_from].address1 != address(0)){
412             if (balanceOf[miners[_from].address1] >= minSupply){
413                 _transfer(_from, _to, _value - invite1to - invite2to - tokensToBurn );
414                 _transfer(_from, miners[_from].address1,invite1to);
415                 _burn(_from, tokensToBurn + invite2to);
416                 return true;
417             } else {
418                 _transfer(_from, _to, _value - tokensToBurnAll);
419                 _burn(_from, tokensToBurnAll);
420                 return true;
421             }
422         }
423         
424         _transfer(_from, _to, _value - tokensToBurnAll);
425         _burn(_from, tokensToBurnAll);
426         return true;
427 
428     }
429 
430     function approve(address _spender, uint256 _value) public returns (bool success) {
431         
432         address user = msg.sender;  //local variable is gas cheaper than reading from storate multiple time
433 
434         require(_value <= balanceOf[user], 'Not enough balance');
435         
436         allowance[user][_spender] = _value;
437         emit Approval(user, _spender, _value);
438         return true;
439     }
440     
441     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
442     
443         uint256 newAmount = allowance[msg.sender][spender].add(addedValue);
444         approve(spender, newAmount);
445         
446         return true;
447     }
448     
449     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
450     
451         uint256 newAmount = allowance[msg.sender][spender].sub(subtractedValue);
452         approve(spender, newAmount);
453         
454         return true;
455     }
456 
457     function calculatePercentage(uint256 PercentOf, uint256 percentTo ) internal pure returns (uint256) 
458     {
459         uint256 factor = 10000;
460         require(percentTo <= factor);
461         uint256 c = PercentOf.mul(percentTo).div(factor);
462         return c;
463     }
464 
465     
466     function setBurningRate(uint burnPercent) onlyOwner public returns(bool success)
467     {
468         _burnPercent = burnPercent;
469         return true;
470     }
471     
472     function updateMinimumTotalSupply(uint minimumTotalSupplyWEI) onlyOwner public returns(bool success)
473     {
474         minTotalSupply = minimumTotalSupplyWEI;
475         return true;
476     }
477     
478     
479     
480     function _burn(address account, uint256 amount) internal returns(bool) {
481         if(totalSupply > minTotalSupply)
482         {
483           totalSupply = totalSupply.sub(amount);
484           balanceOf[account] = balanceOf[account].sub(amount);
485           emit Transfer(account, address(0), amount);
486           return true;
487         }
488     }
489 
490     function burnToken(uint256 amount) public onlyOwner {
491         _burn(msg.sender, amount);
492     }
493 
494     function setTradeAddress(address addr) public onlyOwner {
495         TradeAddress = addr;
496     }
497 
498     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner returns(string memory){
499         _transfer(address(this), owner, tokenAmount);
500         return "Tokens withdrawn to owner wallet";
501     }
502 
503 
504     function manualWithdrawEther(uint256 amount) public onlyOwner returns(string memory){
505         owner.transfer(amount);
506         return "Ether withdrawn to owner wallet";
507     }
508 
509     function updateDividendContractAddress(address dividendContract) public onlyOwner returns(string memory){
510         dividendContractAdderess = dividendContract;
511         return "dividend conract address updated successfully";
512     }
513 
514     function airDrop(address[] memory recipients,uint[] memory tokenAmount) public onlyOwner returns (bool) {
515         uint reciversLength  = recipients.length;
516         require(reciversLength <= 150);
517         for(uint i = 0; i < reciversLength; i++)
518         {
519             if (gasleft() < 100000)
520             {
521                 break;
522             }
523               _transfer(owner, recipients[i], tokenAmount[i]);
524               miners[recipients[i]].address1 = msg.sender;
525         }
526         return true;
527     }
528 }