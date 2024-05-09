1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     } 
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     } 
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     } 
21 }
22 
23 library SafeMath8{
24      function add(uint8 a, uint8 b) internal pure returns (uint8) {
25         uint8 c = a + b;
26         require(c >= a);
27 
28         return c;
29     }
30     
31     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
32         require(b <= a);
33         uint8 c = a - b;
34         return c;
35     }
36    
37  }
38 
39 
40 library SafeMath16{
41      function add(uint16 a, uint16 b) internal pure returns (uint16) {
42         uint16 c = a + b;
43         require(c >= a);
44 
45         return c;
46     }
47     
48     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
49         require(b <= a);
50         uint16 c = a - b;
51         return c;
52     }
53     
54      function mul(uint16 a, uint16 b) internal pure returns (uint16) {
55         if (a == 0) {
56             return 0;
57         }
58         uint16 c = a * b;
59         require(c / a == b);
60         return c;
61     }
62     
63     function div(uint16 a, uint16 b) internal pure returns (uint16) {
64         require(b > 0);
65         uint16 c = a / b;
66         return c;
67     }
68  }
69 
70 
71 
72 
73 
74 
75 contract ERC20Interface {
76     function totalSupply() public constant returns (uint);
77     function balanceOf(address tokenOwner) public constant returns (uint balance);
78     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
79     function transfer(address to, uint tokens) public returns (bool success);
80     function approve(address spender, uint tokens) public returns (bool success);
81     function transferFrom(address from, address to, uint tokens) public returns (bool success);
82 
83     event Transfer(address indexed from, address indexed to, uint tokens);
84     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85 }
86 
87 
88 
89 
90 
91 
92 
93 contract ApproveAndCallFallBack {
94     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
95 }
96 
97 
98 
99 
100 
101 contract Owned {
102     address public owner;
103     address public newOwner;
104     
105 
106     event OwnershipTransferred(address indexed _from, address indexed _to);
107 
108     constructor() public {
109         owner = msg.sender;
110     }
111 
112     modifier onlyOwner {
113         require(msg.sender == owner); 
114         _;
115     }
116 
117     function transferOwnership(address _newOwner) public onlyOwner {
118         newOwner = _newOwner;
119     }
120     function acceptOwnership() public {
121         require(msg.sender == newOwner);
122         emit OwnershipTransferred(owner, newOwner);
123         owner = newOwner;
124         newOwner = address(0);
125     }
126 }
127 
128 
129 
130 interface controller{
131     function mintToken(address target, uint mintedAmount) external;
132     function burnToken(uint8 boxIndex, address target, uint mintedAmount) external;
133     function control(uint8 boxIndex, uint8 indexMaterial, address target, uint256 amount) external;
134     function setMaterialRate(uint indexMaterial, uint8 rate) external;                                  
135     function setAddMaterial(uint8 rate) external;                                                       
136     function setAddMaterialAll(uint8 rate1,uint8 rate2,uint8 rate3,uint8 rate4,uint8 rate5,uint8 rate6,uint8 rate7,uint8 rate8,uint8 rate9,uint8 rate10) external; 
137     function setAddMaterialEight(uint8 rate1,uint8 rate2,uint8 rate3,uint8 rate4,uint8 rate5,uint8 rate6,uint8 rate7,uint8 rate8) external; 
138     function balanceOf(address tokenOwner) external view returns (uint);                                
139     function set_material_address(address _material_address) external;
140     function set_pet_address(address _pet_address) external;
141 }
142 
143 
144 contract Factroy is Owned{
145     
146     using SafeMath for uint;
147     using SafeMath16 for uint16;
148     
149     address[] public newContracts;
150     address personcall_address;
151    
152     uint16 public box_contract_amount = 0;
153     
154      
155     function createConstruct(string _name, uint8 _level) public onlyOwner{
156         address newContract = new createTreasure(_name, _level);
157         newContracts.push(newContract);
158         box_contract_amount = box_contract_amount.add(1);
159     } 
160     
161     
162     function controlMintokenManager(uint8 _index,address target, uint mintedAmount) public{       
163          require(msg.sender == owner);
164          controller mintokener = controller(newContracts[_index]);
165          mintokener.mintToken(target, mintedAmount);
166     } 
167     
168 
169      
170     function controlMintoken(uint8 _index,address target, uint mintedAmount) public{        
171          require(msg.sender == personcall_address);
172          controller mintokener = controller(newContracts[_index]);
173          mintokener.mintToken(target, mintedAmount);
174     } 
175     
176     function controlBurntoken(uint8 _index,address target, uint mintedAmount) public{       
177          require(msg.sender == personcall_address);
178          controller burntokener = controller(newContracts[_index]);
179          uint8 boxIndex;
180          if(_index<5){
181              boxIndex = 0;
182          }else if(_index<10){
183              boxIndex = 1;
184          }else if(_index<15){
185              boxIndex = 2;
186          }else if(_index<20){
187              boxIndex = 3;
188          }else if(_index<25){
189              boxIndex = 4;
190          }else{
191              boxIndex = 5;
192          }
193 
194          burntokener.burnToken(boxIndex, target, mintedAmount);
195          
196     }
197  
198     
199     function controlMaterialRate(uint8 _index, uint8 materialIndex, uint8 rate ) public onlyOwner{   
200          controller setMaterailTokener = controller(newContracts[_index]);
201          setMaterailTokener.setMaterialRate(materialIndex,rate);
202          
203     }
204     
205     function controlAddMaterial(uint8 _index,uint8 rate) public onlyOwner{        
206         controller setAddMaterialler = controller(newContracts[_index]);
207         setAddMaterialler.setAddMaterial(rate);
208     }  
209     
210     function controlAddMaterialAll(uint8 _index,uint8 rate1,uint8 rate2,uint8 rate3,uint8 rate4,uint8 rate5,uint8 rate6,uint8 rate7,uint8 rate8,uint8 rate9,uint8 rate10) public onlyOwner{  
211         controller setAddMaterialler = controller(newContracts[_index]);
212         setAddMaterialler.setAddMaterialAll(rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8,rate9,rate10);
213     }
214     
215     function controlAddMaterialEight(uint8 _index,uint8 rate1,uint8 rate2,uint8 rate3,uint8 rate4,uint8 rate5,uint8 rate6,uint8 rate7,uint8 rate8) public onlyOwner{  
216         controller setAddMaterialler = controller(newContracts[_index]);
217         setAddMaterialler.setAddMaterialEight(rate1,rate2,rate3,rate4,rate5,rate6,rate7,rate8);
218     } 
219 
220     function controlSearchBoxCount(uint8 _index,address target) public view returns (uint) {   
221          controller setSearchMaterialCnt = controller(newContracts[_index]);
222          return setSearchMaterialCnt.balanceOf(target);
223     }
224     
225     function controlSet_material_address(address _new_material_address) public onlyOwner{
226         for(uint8 i=0;i<25;i++){
227             controller setter = controller(newContracts[i]);
228             setter.set_material_address(_new_material_address);
229         }
230     }
231     
232     function controlSet_pet_address(address _new_pet_address) public onlyOwner{
233         for(uint8 i=25;i<30;i++){
234             controller setter = controller(newContracts[i]);
235             setter.set_pet_address(_new_pet_address);
236         }
237     }
238     
239     function set_personcall(address _new_personcall) public onlyOwner {
240         personcall_address = _new_personcall;
241     }
242         
243 
244 
245 }
246 
247 
248 
249 
250 
251 contract createTreasure is ERC20Interface, Owned {
252 
253     event whatOfHerb(address indexed target, uint8 boxIndex, uint8 materialIndex, uint materialAmount);
254     
255     
256     using SafeMath for uint;
257     using SafeMath8 for uint8;
258     using SafeMath16 for uint16;
259     string public symbol;
260     string public  name;
261     uint8 public decimals;
262     uint8 public level;
263     uint _totalSupply;
264     
265     address  material_address=0x65844f2e98495b6c8780f689c5d13bb7f4975d65;
266     address  pet_address;
267 
268     mapping(address => uint) balances;
269     mapping(address => mapping(address => uint)) allowed;
270     
271     
272     uint8[] public  materialRate;  
273     uint[] public materialCount;      
274     
275 
276 
277     
278     
279     
280     constructor(string _symbol, uint8 _level) public {
281     
282         symbol = _symbol;
283         level = _level;
284         decimals = 0;
285         _totalSupply = 0;
286         balances[owner] = _totalSupply;
287         
288         emit Transfer(address(0), owner, _totalSupply);
289 
290     }
291     
292     
293     
294     
295     function setAddMaterialAll(uint8 rate1,uint8 rate2,uint8 rate3,uint8 rate4,uint8 rate5,uint8 rate6,uint8 rate7,uint8 rate8,uint8 rate9,uint8 rate10) public onlyOwner{
296       materialRate.push(rate1);
297       materialRate.push(rate2);
298       materialRate.push(rate3);
299       materialRate.push(rate4);
300       materialRate.push(rate5);
301       materialRate.push(rate6);
302       materialRate.push(rate7);
303       materialRate.push(rate8);
304       materialRate.push(rate9);
305       materialRate.push(rate10);
306       
307       for(uint8 o=0;o<10;o++){
308           materialCount.push(0);
309       }
310 
311     }
312     
313      
314     
315     
316     function setAddMaterialEight(uint8 rate1,uint8 rate2,uint8 rate3,uint8 rate4,uint8 rate5,uint8 rate6,uint8 rate7,uint8 rate8) public onlyOwner{
317       materialRate.push(rate1);
318       materialRate.push(rate2);
319       materialRate.push(rate3);
320       materialRate.push(rate4);
321       materialRate.push(rate5);
322       materialRate.push(rate6);
323       materialRate.push(rate7);
324       materialRate.push(rate8);
325    
326       for(uint8 o=0;o<8;o++){
327           materialCount.push(0);
328       }
329 
330     }
331     
332     
333     
334     
335     function set_material_address(address _material_address) public onlyOwner{
336       material_address = _material_address;
337     }
338     
339     
340     
341     
342     function set_pet_address(address _pet_address) public onlyOwner{
343       pet_address = _pet_address;
344     }
345  
346  
347     
348     
349     
350     function setAddMaterial(uint8 rate) public onlyOwner{
351       materialRate.push(rate);
352       materialCount.push(0);
353     }
354     
355     
356     
357     
358     function setMaterialRate(uint8 materialIndex, uint8 rate) public onlyOwner{
359         materialRate[materialIndex] = rate;
360     }
361     
362 
363     
364     
365     
366     function arrLength() public view returns(uint){
367         return materialRate.length;
368     }
369     
370     function arrLengthCount() public view returns(uint){
371         return materialCount.length;
372     }
373 
374 
375     
376     
377     
378     function totalSupply() public view returns (uint) {
379         return _totalSupply.sub(balances[address(0)]);
380     }
381 
382 
383     
384     
385     
386     function balanceOf(address tokenOwner) public view returns (uint balance) {
387         return balances[tokenOwner];
388     }
389 
390 
391     
392     
393     
394     
395     
396     function transfer(address to, uint tokens) public returns (bool success) {
397         balances[msg.sender] = balances[msg.sender].sub(tokens);
398         balances[to] = balances[to].add(tokens);
399         emit Transfer(msg.sender, to, tokens);
400         return true;
401     }
402 
403 
404     function approve(address spender, uint tokens) public returns (bool success) {
405         allowed[msg.sender][spender] = tokens;
406         emit Approval(msg.sender, spender, tokens);
407         return true;
408     }
409 
410 
411     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
412         balances[from] = balances[from].sub(tokens);
413         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
414         balances[to] = balances[to].add(tokens);
415         emit Transfer(from, to, tokens);
416         return true;
417     }
418  
419 
420     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
421         return allowed[tokenOwner][spender];
422     }
423 
424 
425     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
426         allowed[msg.sender][spender] = tokens;
427         emit Approval(msg.sender, spender, tokens);
428         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
429         return true;
430     }
431      
432     
433     
434 
435     
436     
437     
438     function mintToken(address target, uint mintedAmount) public onlyOwner { 
439         
440         balances[target] = balances[target].add(mintedAmount);
441         _totalSupply = _totalSupply.add(mintedAmount);
442         emit Transfer(address(this), target, mintedAmount);
443     }
444 
445 
446     
447     
448     
449    
450     function burnToken(uint8 boxIndex, address target, uint mintedAmount) public onlyOwner {
451         
452         require(balances[target] >= mintedAmount);
453         balances[target] = balances[target].sub(mintedAmount);
454         _totalSupply = _totalSupply.sub(mintedAmount);
455 
456         emit Transfer(target, address(0), mintedAmount);
457         address factory_address;
458          
459         if(boxIndex < 5){
460             factory_address = material_address;
461         }else{
462             factory_address = pet_address;
463         }
464         
465         
466         controller control2 = controller(factory_address);
467         
468         for(uint8 j=0;j<materialRate.length;j++){
469             materialCount[j] = 0; 
470         }
471         
472         
473         for(uint16 i=1;i<=mintedAmount;i++){            
474             uint16 random = get_random(i);
475             uint16 totalRate = 0;
476              for(uint8 m=0;m<materialRate.length;m++){         
477                 totalRate = totalRate.add(materialRate[m]);
478                 if(random < totalRate){ 
479                   materialCount[m] = uint(materialCount[m].add(1));
480                   break;
481                 }
482              }
483         }
484 
485         for(uint8 n=0;n<materialRate.length;n++){
486             if(materialCount[n] !=0){
487                 control2.control(boxIndex, n, target, materialCount[n]);          
488                 emit whatOfHerb(target,boxIndex,n,materialCount[n]);              
489             }
490         }
491 
492     }
493     
494     function get_random(uint amount) private view returns(uint16){
495         
496         uint16 total;
497         for(uint8 i=0;i<materialRate.length;i++){
498             total = total.add(materialRate[i]);
499         }
500         uint16 ramdon = uint16(keccak256(abi.encodePacked(now + uint(amount),blockhash(block.number-1)))); 
501         
502         return uint16(ramdon) % total;
503     } 
504     
505    
506     function () public payable {
507         revert();
508     }
509 
510 
511     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
512         return ERC20Interface(tokenAddress).transfer(owner, tokens);
513     }
514 }