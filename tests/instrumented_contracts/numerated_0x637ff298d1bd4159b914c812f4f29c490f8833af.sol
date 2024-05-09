1 pragma solidity ^0.4.13;
2 
3 contract EInterface { 
4    	  
5     function allowance(address _owner, address _spender) constant returns (uint256 remaining) { }
6     function transferFrom(address _from, address _to, uint256 _value)  {}
7 }
8 
9 
10 contract BidAskX {  
11    
12     //--------------------------------------------------------------------------EInterface
13     function allow_spend(address _coin) private returns(uint){  
14         EInterface pixiu = EInterface(_coin);
15         uint allow = pixiu.allowance(msg.sender, this);
16         return allow;
17         
18     }
19              
20     function transferFromTx(address _coin, address _from, address _to, uint256 _value) private {
21         EInterface pixiu = EInterface(_coin); 
22         pixiu.transferFrom(_from, _to, _value);
23     }     
24     
25     //--------------------------------------------------------------------------event
26     event Logs(string); 
27     event Log(string data, uint value, uint value1); 
28     event Println(address _address,uint32 number, uint price, uint qty, uint ex_qty, bool isClosed,uint32 n32);
29     event Paydata(address indexed payer, uint256 value, bytes data, uint256 balances);
30         
31     //--------------------------------------------------------------------------admin
32     mapping (address => AdminType) admins;  
33     address[] adminArray;   
34     enum AdminType { none, normal, agent, admin, widthdraw }
35 
36     //--------------------------------------------------------------------------member
37     struct Member {
38         bool isExists;                                    
39         bool isWithdraw;                                  
40         uint deposit;
41         uint withdraw;
42         uint balances;
43         uint bid_amount;
44         uint tx_amount;
45         uint ask_qty;
46         uint tx_qty;
47         address agent;
48     }
49     mapping (address => Member) public members;  
50     address[] public memberArray;
51 
52     //--------------------------------------------------------------------------order
53     uint32 public order_number=1;
54     struct OrderSheet {
55         bool isAsk;
56         uint32 number;
57         address owner;
58         uint price;
59         uint qty;
60         uint amount;
61         uint exFee;
62         uint ex_qty;
63         bool isClosed;
64     }
65     address[] public tokensArray; 
66     mapping (address => bool) tokens; 
67     mapping (address => uint32[]) public token_ask; 
68     mapping (address => uint32[]) public token_bid; 
69     mapping (address => mapping(address => uint32[])) public token_member_order;
70     mapping (address => mapping(uint32 => OrderSheet)) public token_orderSheet;  
71 
72     //--------------------------------------------------------------------------public
73     bool public isPayable = true;
74     bool public isWithdrawable = true;
75     bool public isRequireData = false;
76 	uint public MinimalPayValue = 0;
77 	uint public exFeeRate = 1000;
78 	uint public exFeeTotal = 0;
79     
80 
81     function BidAskX(){  
82         
83         adminArray.push(msg.sender); 
84         admins[msg.sender]=AdminType.widthdraw;
85         //ask(this);
86         
87     }
88 
89     function list_token_ask(address _token){
90         uint32[] storage numbers = token_ask[_token];
91         for(uint i=0;i<numbers.length;i++){
92             uint32 n32 = numbers[i];
93             OrderSheet storage oa = token_orderSheet[_token][n32];
94             Println(oa.owner, oa.number, oa.price, oa.qty, oa.ex_qty, oa.isClosed,n32);
95         }
96     }
97     
98     function list_token_bid(address _token){
99         uint32[] storage numbers = token_bid[_token];
100         for(uint i=0;i<numbers.length;i++){
101             uint32 n32 = numbers[i];
102             OrderSheet storage oa = token_orderSheet[_token][n32];
103             Println(oa.owner, oa.number, oa.price, oa.qty, oa.ex_qty, oa.isClosed,n32);
104         }
105     }
106      
107     function tokens_push(address _token) private {
108         if(tokens[_token]!=true){
109             tokensArray.push(_token);
110             tokens[_token]=true;
111         }
112     }
113     
114     function token_member_order_pop(address _token, address _sender, uint32 _number) private {
115         for(uint i=0;k<token_member_order[_token][_sender].length-1;i++){
116             if(token_member_order[_token][_sender][i]==_number){
117                 for(uint k=i;k<token_member_order[_token][_sender].length-2;k++){
118                     token_bid[_token][k]=token_bid[_token][k+1];
119                 }
120                 token_member_order[_token][_sender].length-=1;
121                 break;
122             }
123         }
124     }
125  
126     function members_push(address _address) private {
127         if (members[_address].isExists != true) {
128             members[_address].isExists = true;
129             members[_address].isWithdraw = true; 
130             members[msg.sender].deposit=0;
131             members[msg.sender].withdraw=0;
132             members[msg.sender].balances =0;
133             members[msg.sender].tx_amount=0;
134             members[msg.sender].bid_amount=0;
135             members[msg.sender].ask_qty=0;
136             members[msg.sender].tx_qty=0;
137             members[msg.sender].agent=address(0);
138             memberArray.push(_address); 
139         }
140     }
141         
142     function cancel( address _token,uint32 _number){ 
143         OrderSheet storage od = token_orderSheet[_token][_number];
144         if(od.owner==msg.sender){
145             uint i;
146             uint k;
147             if(od.isAsk){
148                 
149                 for(i=0; i<token_ask[_token].length;i++){
150                     if(token_ask[_token][i]==_number){
151                         od.isClosed = true;
152                         members[msg.sender].ask_qty - od.qty + od.ex_qty;
153                         for(k=i;k<token_ask[_token].length-2;k++){
154                             token_ask[_token][k]=token_ask[_token][k+1];
155                         }
156                         token_ask[_token].length-=1;
157                         break;
158                     }
159                 }
160                 
161             } else {
162             
163                 for(i=0; i<token_bid[_token].length;i++){
164                     if(token_bid[_token][i]==_number){
165                         od.isClosed = true;
166                         members[msg.sender].bid_amount - od.amount + od.price*od.ex_qty;
167                         for(k=i;k<token_bid[_token].length-2;k++){
168                             token_bid[_token][k]=token_bid[_token][k+1];
169                         }
170                         token_bid[_token].length-=1;
171                         break;
172                     }
173                 }
174                 
175             }
176             token_member_order_pop(_token, msg.sender, _number);
177         } else {
178             Logs("The order owner not match");
179         }
180     }
181     
182     function bid( address _token, uint _qty, uint _priceEth, uint _priceWei){ 
183         tokens_push(_token); 
184         uint256 _price = _priceEth *10**18 + _priceWei;
185         uint exFee = (_qty * _price) / exFeeRate;
186         uint amount = (_qty * _price)+exFee;
187         
188         uint unclose = members[msg.sender].bid_amount - members[msg.sender].tx_amount;
189         uint remaining = members[msg.sender].balances - unclose;
190         if(remaining >= amount){
191             OrderSheet memory od;
192             od.isAsk = false;
193             od.number = order_number;
194             od.owner = msg.sender;
195             od.price = _price;
196             od.qty = _qty;
197             od.ex_qty=0;
198             od.exFee = (_price * _qty)/exFeeRate;
199             od.amount = (_price * _qty) + od.exFee;
200             od.isClosed=false; 
201             token_orderSheet[_token][order_number]=od; 
202             members[msg.sender].bid_amount+=amount;
203             token_member_order[_token][msg.sender].push(order_number);
204             bid_match(_token,token_orderSheet[_token][order_number],token_ask[_token]); 
205             if(token_orderSheet[_token][order_number].isClosed==false){
206                 token_bid[_token].push(order_number);   
207                 Println(od.owner, od.number, od.price, od.qty, od.ex_qty, od.isClosed,777);
208             }
209             order_number++;
210         } else {
211             Log("You need more money for bid", remaining, amount);
212         }
213     }
214     
215     function ask( address _token, uint _qty, uint _priceEth, uint _priceWei){ 
216         tokens_push(_token); 
217         uint256 _price = _priceEth *10**18 + _priceWei;
218         uint unclose = members[msg.sender].ask_qty - members[msg.sender].tx_qty;
219         uint remaining = allow_spend(_token) - unclose;
220         uint exFee = (_price * _qty)/exFeeRate;
221         if(members[msg.sender].balances < exFee){
222             Log("You need to deposit ether to acoount befor ask", exFee, members[msg.sender].balances);
223         } else if(remaining >= _qty){
224             members_push(msg.sender);
225             OrderSheet memory od;
226             od.isAsk = true;
227             od.number = order_number;
228             od.owner = msg.sender;
229             od.price = _price;
230             od.qty = _qty;
231             od.ex_qty=0;
232             od.exFee = exFee;
233             od.amount = (_price * _qty) - exFee;
234             od.isClosed=false; 
235             token_orderSheet[_token][order_number]=od; 
236             members[msg.sender].ask_qty+=_qty;
237             token_member_order[_token][msg.sender].push(order_number);
238             ask_match(_token,token_orderSheet[_token][order_number],token_bid[_token]);
239             if(od.isClosed==false){
240                 token_ask[_token].push(order_number);  
241                 Log("Push order number to token_ask",order_number,0);
242             }
243             order_number++;
244         } else {
245             Log("You need approve your token for transfer",0,0);
246         }
247     }
248      
249     function ask_match(address _token, OrderSheet storage od, uint32[] storage token_match) private { 
250         for(uint i=token_match.length;i>0 && od.qty>od.ex_qty;i--){
251             uint32 n32 = token_match[i-1];
252             OrderSheet storage oa = token_orderSheet[_token][n32];
253             uint qty = oa.qty-oa.ex_qty;
254             if(oa.isClosed==false && qty>0){
255                 uint ex_qty = (qty>od.qty?od.qty:qty);
256                 uint ex_price = oa.price;
257                 uint exFee = (ex_qty * ex_price) / exFeeRate;
258                 uint amount = (ex_qty * ex_price);
259                 Println(oa.owner, oa.number, oa.price, oa.qty, oa.ex_qty, oa.isClosed,n32);
260                 
261                 if(members[oa.owner].balances >= amount && od.price <= oa.price){
262                     od.ex_qty += ex_qty;
263                     if(oa.ex_qty+ex_qty>=oa.qty){
264                         token_orderSheet[_token][n32].isClosed = true; 
265                         for(uint k=i-1;k<token_match.length-2;k++){
266                             token_match[k]=token_match[k+1];
267                         }
268                     }
269                     token_orderSheet[_token][n32].ex_qty += ex_qty; 
270                     transferFromTx(_token,  msg.sender, oa.owner, ex_qty); 
271                     
272                     members[oa.owner].balances -= (amount+exFee);
273                     members[oa.owner].tx_amount += (amount+exFee);
274                     members[oa.owner].tx_qty += ex_qty;
275 
276                     members[msg.sender].balances += (amount-exFee);
277                     members[msg.sender].tx_amount += (amount-exFee);
278                     members[msg.sender].tx_qty += ex_qty;
279                     
280                     if(od.ex_qty+ex_qty>=od.qty){
281                         od.isClosed = true; 
282                     } 
283                     exFeeTotal += exFee;
284                 }
285             }
286         } 
287     }
288     
289     function bid_match(address _token, OrderSheet storage od, uint32[] storage token_match) private { 
290         for(uint i=token_match.length;i>0 && od.qty>od.ex_qty;i--){
291             uint32 n32 = token_match[i-1];
292             OrderSheet storage oa = token_orderSheet[_token][n32];
293             uint qty = oa.qty-oa.ex_qty;
294             if(oa.isClosed==false && qty>0){
295                 uint ex_qty = (qty>od.qty?od.qty:qty);
296                 uint ex_price = oa.price;
297                 uint exFee = (ex_qty * ex_price) / exFeeRate;
298                 uint amount = (ex_qty * ex_price);
299                 Println(oa.owner, oa.number, oa.price, oa.qty, oa.ex_qty, oa.isClosed,222); 
300                 if(members[msg.sender].balances >= amount && oa.price <= od.price){
301                     od.ex_qty += ex_qty;
302                     if(oa.ex_qty+ex_qty>=oa.qty){
303                         token_orderSheet[_token][n32].isClosed = true; 
304                         for(uint k=i-1;k<token_match.length-2;k++){
305                             token_match[k]=token_match[k+1];
306                         }
307                     }
308                     token_orderSheet[_token][n32].ex_qty += ex_qty; 
309                     //transferFromTx(_token, oa.owner, msg.sender, ex_qty); 
310                     members[od.owner].balances += (amount-exFee);
311                     members[od.owner].tx_amount += (amount-exFee); 
312                     members[od.owner].tx_qty += ex_qty; 
313 
314                     members[msg.sender].balances -= (amount+exFee);
315                     members[msg.sender].tx_amount += (amount+exFee);
316                     members[msg.sender].tx_qty += ex_qty;
317                     
318                     if(od.ex_qty+ex_qty>=od.qty){
319                         od.isClosed = true; 
320                     }
321                     exFeeTotal += exFee;
322                 } 
323             }
324         } 
325     }
326     
327   
328     //--------------------------------------------------------------------------member function
329     function withdraw(uint _eth, uint _wei) {
330         
331         for(uint i=0;i<tokensArray.length-1;i++){
332             address token = tokensArray[i];
333             uint32[] storage order = token_member_order[token][msg.sender];
334             for(uint j=0;j<order.length-1;j++){
335                 cancel( token,order[j]);
336             }
337         }
338         
339         uint balances = members[msg.sender].balances;
340         uint withdraws = _eth*10**18 + _wei;
341         require( balances >= withdraws);
342         require( this.balance >= withdraws);
343         require(isWithdrawable);
344         require(members[msg.sender].isWithdraw);
345         msg.sender.transfer(withdraws);
346         members[msg.sender].balances -= withdraws;
347         members[msg.sender].withdraw += withdraws;  
348 
349     }
350             
351     function get_this_balance() constant returns(uint256 _eth,uint256 _wei){
352       
353         _eth = this.balance / 10**18 ;
354         _wei = this.balance - _eth * 10**18 ;
355       
356     }
357     
358     
359     function pay() public payable returns (bool) {
360         
361         require(msg.value > MinimalPayValue);
362         require(isPayable);
363         
364         
365         if(admins[msg.sender] == AdminType.widthdraw){
366 
367         }else{
368             
369             if(isRequireData){
370                 require(admins[address(msg.data[0])] > AdminType.none);   
371             }
372         
373             members_push(msg.sender);
374             members[msg.sender].balances += msg.value;
375             members[msg.sender].deposit += msg.value;
376             if(admins[address(msg.data[0])]>AdminType.none){
377                 members[msg.sender].agent = address(msg.data[0]);
378             }
379 
380     		Paydata(msg.sender, msg.value, msg.data, members[msg.sender].balances);
381 		
382         }
383         
384         return true;
385     
386     }
387 
388    
389   
390 
391     //--------------------------------------------------------------------------admin function
392     
393     modifier onlyAdmin() {
394         require(admins[msg.sender] > AdminType.agent);
395         _;
396     }
397 
398     function admin_list() onlyAdmin constant returns(address[] _adminArray){
399         
400         _adminArray = adminArray; 
401         
402     }    
403     
404     function admin_typeOf(address admin) onlyAdmin constant returns(AdminType adminType){
405           
406         adminType= admins[admin];
407         
408     }
409     
410     function admin_add_modify(address admin, AdminType adminType) onlyAdmin {
411         
412         require(admins[admin] > AdminType.agent);
413         if(admins[admin] < AdminType.normal){
414             adminArray.push(admin);
415         }
416         admins[admin]=AdminType(adminType);
417         
418     }
419     
420     function admin_del(address admin) onlyAdmin {
421         
422         require(admin!=msg.sender);
423         require(admins[admin] > AdminType.agent);
424         if(admins[admin] > AdminType.none){
425             admins[admin] = AdminType.none;
426             for (uint i = 0; i < adminArray.length - 1; i++) {
427                 if (adminArray[i] == admin) {
428                     adminArray[i] = adminArray[adminArray.length - 1];
429                     adminArray.length -= 1;
430                     break;
431                 }
432             }
433         }
434         
435     }
436 
437     function admin_withdraw(uint _eth, uint _wei) onlyAdmin {
438 
439         require(admins[msg.sender] > AdminType.admin);
440         uint256 amount = _eth * 10**18 + _wei;
441 		require(this.balance >= amount);
442 		msg.sender.transfer(amount); 
443         
444     }
445         
446 
447 	function admin_exFeeRate(uint _rate) onlyAdmin {
448 	    
449 	    exFeeRate = _rate;
450 	    
451 	}
452      	
453     function admin_MinimalPayValue(uint _eth, uint _wei) onlyAdmin {
454 	    
455 	    MinimalPayValue = _eth*10*18 + _wei;
456 	    
457 	}
458      
459     function admin_isRequireData(bool _requireData) onlyAdmin{
460     
461         isRequireData = _requireData;
462         
463     }
464     
465     function admin_isPayable(bool _payable) onlyAdmin{
466     
467         isPayable = _payable;
468         
469     }
470     
471     function admin_isWithdrawable(bool _withdrawable) onlyAdmin{
472         
473         isWithdrawable = _withdrawable;
474         
475     }
476     
477     function admin_member_isWithdraw(address _member, bool _withdrawable) onlyAdmin {
478         if(members[_member].isExists == true) {
479             members[_member].isWithdraw = _withdrawable;
480         } else {
481             Logs("member not existes");
482         }
483     }
484     
485     
486 }