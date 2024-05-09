1 // ----------------------------------------------------------------------------------------------
2 // Developer Nechesov Andrey & ObjectMicro, Inc 
3 // ----------------------------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/issues/20
6 
7 pragma solidity ^0.4.23;    
8 
9   library SafeMath {
10     function mul(uint256 a, uint256 b) internal returns (uint256) {
11       uint256 c = a * b;
12       assert(a == 0 || c / a == b);
13       return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal returns (uint256) {
17       // assert(b > 0); // Solidity automatically throws when dividing by 0
18       uint256 c = a / b;
19       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20       return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal returns (uint256) {
24       assert(b <= a);
25       return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal returns (uint256) {
29       uint256 c = a + b;
30       assert(c >= a);
31       return c;
32     }
33   }
34 
35   contract ERC20Interface {
36       // Get the total token supply
37       function totalSupply() constant returns (uint256 totalSupply);
38    
39       // Get the account balance of another account with address _owner
40       function balanceOf(address _owner) constant returns (uint256 balance);
41    
42       // Send _value amount of tokens to address _to
43       function transfer(address _to, uint256 _value) returns (bool success);
44    
45       // Send _value amount of tokens from address _from to address _to
46       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
47    
48       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
49       // If this function is called again it overwrites the current allowance with _value.
50       // this function is required for some DEX functionality
51       function approve(address _spender, uint256 _value) returns (bool success);
52    
53       // Returns the amount which _spender is still allowed to withdraw from _owner
54       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
55    
56       // Triggered when tokens are transferred.
57       event Transfer(address indexed _from, address indexed _to, uint256 _value);
58    
59       // Triggered whenever approve(address _spender, uint256 _value) is called.
60       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61   }  
62    
63   contract Iou_Token is ERC20Interface {
64 
65       string public constant symbol = "IOU";
66       string public constant name = "IOU token";
67       uint8 public constant decimals = 18; 
68            
69       uint256 public constant maxTokens = 800*10**6*10**18; 
70       uint256 public constant ownerSupply = maxTokens*30/100;
71       uint256 _totalSupply = ownerSupply;  
72 
73       uint256 public constant token_price = 10**18*1/800; 
74       uint256 public pre_ico_start = 1528416000; 
75       uint256 public ico_start = 1531008000; 
76       uint256 public ico_finish = 1541635200; 
77       uint public constant minValuePre = 10**18*1/1000000; 
78       uint public constant minValue = 10**18*1/1000000; 
79       uint public constant maxValue = 3000*10**18;
80 
81       uint public coef = 102;
82 
83       using SafeMath for uint;
84       
85       // Owner of this contract
86       address public owner;
87       address public moderator;
88    
89       // Balances for each account
90       mapping(address => uint256) balances;
91    
92       // Owner of account approves the transfer of an amount to another account
93       mapping(address => mapping (address => uint256)) allowed;
94 
95       // Orders holders who wish sell tokens, save amount
96       mapping(address => uint256) public orders_sell_amount;
97 
98       // Orders holders who wish sell tokens, save price
99       mapping(address => uint256) public orders_sell_price;
100 
101       //orders list
102       address[] public orders_sell_list;
103 
104       // Triggered on set SELL order
105       event Order_sell(address indexed _owner, uint256 _max_amount, uint256 _price);      
106 
107       // Triggered on execute SELL order
108       event Order_execute(address indexed _from, address indexed _to, uint256 _amount, uint256 _price);      
109    
110       // Functions with this modifier can only be executed by the owner
111       modifier onlyOwner() {
112           if (msg.sender != owner) {
113               throw;
114           }
115           _;
116       }
117 
118       // Functions with this modifier can only be executed by the moderator
119       modifier onlyModerator() {
120           if (msg.sender != moderator) {
121               throw;
122           }
123           _;
124       }
125 
126       // Functions change owner
127       function changeOwner(address _owner) onlyOwner returns (bool result) {                    
128           owner = _owner;
129           return true;
130       }            
131 
132       // Functions change moderator
133       function changeModerator(address _moderator) onlyOwner returns (bool result) {                    
134           moderator = _moderator;
135           return true;
136       }            
137    
138       // Constructor
139       function Iou_Token() {
140           //owner = msg.sender;
141           owner = 0x25f701bff644601a4bb9c3daff3b9978e2455bcd;
142           moderator = 0x788C45Dd60aE4dBE5055b5Ac02384D5dc84677b0;
143           balances[owner] = ownerSupply;
144       }
145       
146       //default function      
147       function() payable {        
148           tokens_buy();        
149       }
150       
151       function totalSupply() constant returns (uint256 totalSupply) {
152           totalSupply = _totalSupply;
153       }
154 
155       //Withdraw money from contract balance to owner
156       function withdraw(uint256 _amount) onlyOwner returns (bool result) {
157           uint256 balance;
158           balance = this.balance;
159           if(_amount > 0) balance = _amount;
160           owner.send(balance);
161           return true;
162       }
163 
164       //Change coef
165       function change_coef(uint256 _coef) onlyOwner returns (bool result) {
166           coef = _coef;
167           return true;
168       }
169 
170       //Change pre_ico_start date
171       function change_pre_ico_start(uint256 _pre_ico_start) onlyModerator returns (bool result) {
172           pre_ico_start = _pre_ico_start;
173           return true;
174       }
175 
176       //Change ico_start date
177       function change_ico_start(uint256 _ico_start) onlyModerator returns (bool result) {
178           ico_start = _ico_start;
179           return true;
180       }
181 
182       //Change ico_finish date
183       function change_ico_finish(uint256 _ico_finish) onlyModerator returns (bool result) {
184           ico_finish = _ico_finish;
185           return true;
186       }
187    
188       // Total tokens on user address
189       function balanceOf(address _owner) constant returns (uint256 balance) {
190           return balances[_owner];
191       }
192    
193       // Transfer the balance from owner's account to another account
194       function transfer(address _to, uint256 _amount) returns (bool success) {          
195 
196           if (balances[msg.sender] >= _amount 
197               && _amount > 0
198               && balances[_to] + _amount > balances[_to]) {
199               balances[msg.sender] -= _amount;
200               balances[_to] += _amount;
201               Transfer(msg.sender, _to, _amount);
202               return true;
203           } else {
204               return false;
205           }
206       }
207    
208       // Send _value amount of tokens from address _from to address _to
209       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
210       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
211       // fees in sub-currencies; the command should fail unless the _from account has
212       // deliberately authorized the sender of the message via some mechanism; we propose
213       // these standardized APIs for approval:
214       function transferFrom(
215           address _from,
216           address _to,
217           uint256 _amount
218      ) returns (bool success) {         
219 
220          if (balances[_from] >= _amount
221              && allowed[_from][msg.sender] >= _amount
222              && _amount > 0
223              && balances[_to] + _amount > balances[_to]) {
224              balances[_from] -= _amount;
225              allowed[_from][msg.sender] -= _amount;
226              balances[_to] += _amount;
227              Transfer(_from, _to, _amount);
228              return true;
229          } else {
230              return false;
231          }
232      }
233   
234      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
235      // If this function is called again it overwrites the current allowance with _value.
236      function approve(address _spender, uint256 _amount) returns (bool success) {
237          allowed[msg.sender][_spender] = _amount;
238          Approval(msg.sender, _spender, _amount);
239          return true;
240      }
241     
242      //Return param, how many tokens can send _spender from _owner account  
243      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
244          return allowed[_owner][_spender];
245      } 
246 
247       /**
248       * Buy tokens on pre-ico and ico with bonuses on time boundaries
249       */
250       function tokens_buy() payable returns (bool) { 
251 
252         uint256 tnow = now;
253         
254         if(tnow < pre_ico_start) throw;
255         if(tnow > ico_finish) throw;
256         if(_totalSupply >= maxTokens) throw;
257         if(!(msg.value >= token_price)) throw;
258         if(!(msg.value >= minValue)) throw;
259         if(msg.value > maxValue) throw;
260 
261         uint tokens_buy = (msg.value*10**18).div(token_price);
262         uint tokens_buy_total;
263 
264         if(!(tokens_buy > 0)) throw;   
265         
266         //Bonus for total tokens amount for all contract
267         uint b1 = 0;
268         //Time bonus on Pre-ICO && ICO
269         uint b2 = 0;
270         //Individual bonus for tokens amount
271         uint b3 = 0;
272 
273         if(_totalSupply <= 10*10**6*10**18) {
274           b1 = tokens_buy*30/100;
275         }
276         if((10*10**6*10**18 < _totalSupply)&&(_totalSupply <= 20*10**6*10**18)) {
277           b1 = tokens_buy*25/100;
278         }
279         if((20*10**6*10**18 < _totalSupply)&&(_totalSupply <= 30*10**6*10**18)) {
280           b1 = tokens_buy*20/100;
281         }
282         if((30*10**6*10**18 < _totalSupply)&&(_totalSupply <= 40*10**6*10**18)) {
283           b1 = tokens_buy*15/100;
284         }
285         if((40*10**6*10**18 < _totalSupply)&&(_totalSupply <= 50*10**6*10**18)) {
286           b1 = tokens_buy*10/100;
287         }
288         if(50*10**6*10**18 <= _totalSupply) {
289           b1 = tokens_buy*5/100;
290         }        
291 
292         if(tnow < ico_start) {
293           b2 = tokens_buy*40/100;
294         }
295         if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*5)){
296           b2 = tokens_buy*5/100;
297         } 
298         if((ico_start + 86400*5 <= tnow)&&(tnow < ico_start + 86400*10)){
299           b2 = tokens_buy*4/100;        
300         } 
301         if((ico_start + 86400*10 <= tnow)&&(tnow < ico_start + 86400*20)){
302           b2 = tokens_buy*5/100;        
303         } 
304         if((ico_start + 86400*20 <= tnow)&&(tnow < ico_start + 86400*30)){
305           b2 = tokens_buy*2/100;        
306         } 
307         if(ico_start + 86400*30 <= tnow){
308           b2 = tokens_buy*1/100;        
309         }
310         
311 
312         if((1000*10**18 <= tokens_buy)&&(5000*10**18 <= tokens_buy)) {
313           b3 = tokens_buy*5/100;
314         }
315         if((5001*10**18 <= tokens_buy)&&(10000*10**18 < tokens_buy)) {
316           b3 = tokens_buy*75/10/100;
317         }
318         if((10001*10**18 <= tokens_buy)&&(15000*10**18 < tokens_buy)) {
319           b3 = tokens_buy*10/100;
320         }
321         if((15001*10**18 <= tokens_buy)&&(20000*10**18 < tokens_buy)) {
322           b3 = tokens_buy*125/10/100;
323         }
324         if(20001*10**18 <= tokens_buy) {
325           b3 = tokens_buy*15/100;
326         }
327 
328         tokens_buy_total = tokens_buy.add(b1);
329         tokens_buy_total = tokens_buy_total.add(b2);
330         tokens_buy_total = tokens_buy_total.add(b3);        
331 
332         if(_totalSupply.add(tokens_buy_total) > maxTokens) throw;
333         _totalSupply = _totalSupply.add(tokens_buy_total);
334         balances[msg.sender] = balances[msg.sender].add(tokens_buy_total);         
335 
336         return true;
337       }
338       
339       /**
340       * Get total SELL orders
341       */      
342       function orders_sell_total () constant returns (uint256) {
343         return orders_sell_list.length;
344       } 
345 
346       /**
347       * Get how many tokens can buy from this SELL order
348       */
349       function get_orders_sell_amount(address _from) constant returns(uint) {
350 
351         uint _amount_max = 0;
352 
353         if(!(orders_sell_amount[_from] > 0)) return _amount_max;
354 
355         if(balanceOf(_from) > 0) _amount_max = balanceOf(_from);
356         if(orders_sell_amount[_from] < _amount_max) _amount_max = orders_sell_amount[_from];
357 
358         return _amount_max;
359       }
360 
361       /**
362       * User create SELL order.  
363       */
364       function order_sell(uint256 _max_amount, uint256 _price) returns (bool) {
365 
366         if(!(_max_amount > 0)) throw;
367         if(!(_price > 0)) throw;        
368 
369         orders_sell_amount[msg.sender] = _max_amount;
370         orders_sell_price[msg.sender] = (_price*coef).div(100);
371         orders_sell_list.push(msg.sender);        
372 
373         Order_sell(msg.sender, _max_amount, orders_sell_price[msg.sender]);      
374 
375         return true;
376       }
377 
378       /**
379       * Order Buy tokens - it's order search sell order from user _from and if all ok, send token and money 
380       */
381       function order_buy(address _from, uint256 _max_price) payable returns (bool) {
382         
383         if(!(msg.value > 0)) throw;
384         if(!(_max_price > 0)) throw;        
385         if(!(orders_sell_amount[_from] > 0)) throw;
386         if(!(orders_sell_price[_from] > 0)) throw; 
387         if(orders_sell_price[_from] > _max_price) throw;
388 
389         uint _amount = (msg.value*10**18).div(orders_sell_price[_from]);
390         uint _amount_from = get_orders_sell_amount(_from);
391 
392         if(_amount > _amount_from) _amount = _amount_from;        
393         if(!(_amount > 0)) throw;        
394 
395         uint _total_money = (orders_sell_price[_from]*_amount).div(10**18);
396         if(_total_money > msg.value) throw;
397 
398         uint _seller_money = (_total_money*100).div(coef);
399         uint _buyer_money = msg.value - _total_money;
400 
401         if(_seller_money > msg.value) throw;
402         if(_seller_money + _buyer_money > msg.value) throw;
403 
404         if(_seller_money > 0) _from.send(_seller_money);
405         if(_buyer_money > 0) msg.sender.send(_buyer_money);
406 
407         orders_sell_amount[_from] -= _amount;        
408         balances[_from] -= _amount;
409         balances[msg.sender] += _amount; 
410 
411         Order_execute(_from, msg.sender, _amount, orders_sell_price[_from]);
412 
413       }
414       
415  }