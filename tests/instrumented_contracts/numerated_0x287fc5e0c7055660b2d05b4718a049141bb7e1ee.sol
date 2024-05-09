1 // ----------------------------------------------------------------------------------------------
2 // Developer Nechesov Andrey & ObjectMicro, Inc 
3 // ----------------------------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/issues/20
6 
7 pragma solidity ^0.4.24;    
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
63   contract Bqt_Token is ERC20Interface {
64 
65       string public constant symbol = "BQT";
66       string public constant name = "BQT token";
67       uint8 public constant decimals = 18; 
68            
69       uint256 public constant maxTokens = 800*10**6*10**18; 
70       uint256 public constant ownerSupply = maxTokens*51/100;
71       uint256 _totalSupply = ownerSupply;  
72 
73       uint256 public constant token_price = 10**18*1/800; 
74       uint256 public pre_ico_start = 1531872000; 
75       uint256 public ico_start = 1533081600; 
76       uint256 public ico_finish = 1540944000; 
77       uint public constant minValuePre = 10**18*1/1000000; 
78       uint public constant minValue = 10**18*1/1000000; 
79       uint public constant maxValue = 3000*10**18;
80 
81       uint8 public constant exchange_coefficient = 102;
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
139       function Bqt_Token() {
140           //owner = msg.sender;
141           owner = 0x3d143e5f256a4fbc16ef23b29aadc0db67bf0ec2;
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
164       //Change pre_ico_start date
165       function change_pre_ico_start(uint256 _pre_ico_start) onlyModerator returns (bool result) {
166           pre_ico_start = _pre_ico_start;
167           return true;
168       }
169 
170       //Change ico_start date
171       function change_ico_start(uint256 _ico_start) onlyModerator returns (bool result) {
172           ico_start = _ico_start;
173           return true;
174       }
175 
176       //Change ico_finish date
177       function change_ico_finish(uint256 _ico_finish) onlyModerator returns (bool result) {
178           ico_finish = _ico_finish;
179           return true;
180       }
181    
182       // Total tokens on user address
183       function balanceOf(address _owner) constant returns (uint256 balance) {
184           return balances[_owner];
185       }
186    
187       // Transfer the balance from owner's account to another account
188       function transfer(address _to, uint256 _amount) returns (bool success) {          
189 
190           if (balances[msg.sender] >= _amount 
191               && _amount > 0
192               && balances[_to] + _amount > balances[_to]) {
193               balances[msg.sender] -= _amount;
194               balances[_to] += _amount;
195               Transfer(msg.sender, _to, _amount);
196               return true;
197           } else {
198               return false;
199           }
200       }
201    
202       // Send _value amount of tokens from address _from to address _to
203       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
204       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
205       // fees in sub-currencies; the command should fail unless the _from account has
206       // deliberately authorized the sender of the message via some mechanism; we propose
207       // these standardized APIs for approval:
208       function transferFrom(
209           address _from,
210           address _to,
211           uint256 _amount
212      ) returns (bool success) {         
213 
214          if (balances[_from] >= _amount
215              && allowed[_from][msg.sender] >= _amount
216              && _amount > 0
217              && balances[_to] + _amount > balances[_to]) {
218              balances[_from] -= _amount;
219              allowed[_from][msg.sender] -= _amount;
220              balances[_to] += _amount;
221              Transfer(_from, _to, _amount);
222              return true;
223          } else {
224              return false;
225          }
226      }
227   
228      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
229      // If this function is called again it overwrites the current allowance with _value.
230      function approve(address _spender, uint256 _amount) returns (bool success) {
231          allowed[msg.sender][_spender] = _amount;
232          Approval(msg.sender, _spender, _amount);
233          return true;
234      }
235     
236      //Return param, how many tokens can send _spender from _owner account  
237      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
238          return allowed[_owner][_spender];
239      } 
240 
241       /**
242       * Buy tokens on pre-ico and ico with bonuses on time boundaries
243       */
244       function tokens_buy() payable returns (bool) { 
245 
246         uint256 tnow = now;
247         
248         //if(tnow < pre_ico_start) throw;
249         if(tnow > ico_finish) throw;
250         if(_totalSupply >= maxTokens) throw;
251         if(!(msg.value >= token_price)) throw;
252         if(!(msg.value >= minValue)) throw;
253         if(msg.value > maxValue) throw;
254 
255         uint tokens_buy = (msg.value*10**18).div(token_price);
256         uint tokens_buy_total;
257 
258         if(!(tokens_buy > 0)) throw;   
259         
260         //Bonus for total tokens amount for all contract
261         uint b1 = 0;
262         //Time bonus on Pre-ICO && ICO
263         uint b2 = 0;
264         //Individual bonus for tokens amount
265         uint b3 = 0;
266 
267         if(_totalSupply <= 5*10**6*10**18) {
268           b1 = tokens_buy*30/100;
269         }
270         if((5*10**6*10**18 < _totalSupply)&&(_totalSupply <= 10*10**6*10**18)) {
271           b1 = tokens_buy*25/100;
272         }
273         if((10*10**6*10**18 < _totalSupply)&&(_totalSupply <= 15*10**6*10**18)) {
274           b1 = tokens_buy*20/100;
275         }
276         if((15*10**6*10**18 < _totalSupply)&&(_totalSupply <= 20*10**6*10**18)) {
277           b1 = tokens_buy*15/100;
278         }
279         if((20*10**6*10**18 < _totalSupply)&&(_totalSupply <= 25*10**6*10**18)) {
280           b1 = tokens_buy*10/100;
281         }
282         if(25*10**6*10**18 <= _totalSupply) {
283           b1 = tokens_buy*5/100;
284         }        
285 
286         if(tnow < ico_start) {
287           b2 = tokens_buy*50/100;
288         }
289         if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*5)){
290           b2 = tokens_buy*10/100;
291         } 
292         if((ico_start + 86400*5 <= tnow)&&(tnow < ico_start + 86400*10)){
293           b2 = tokens_buy*8/100;        
294         } 
295         if((ico_start + 86400*10 <= tnow)&&(tnow < ico_start + 86400*20)){
296           b2 = tokens_buy*6/100;        
297         } 
298         if((ico_start + 86400*20 <= tnow)&&(tnow < ico_start + 86400*30)){
299           b2 = tokens_buy*4/100;        
300         } 
301         if(ico_start + 86400*30 <= tnow){
302           b2 = tokens_buy*2/100;        
303         }
304         
305 
306         if((1000*10**18 <= tokens_buy)&&(5000*10**18 <= tokens_buy)) {
307           b3 = tokens_buy*5/100;
308         }
309         if((5001*10**18 <= tokens_buy)&&(10000*10**18 < tokens_buy)) {
310           b3 = tokens_buy*10/100;
311         }
312         if((10001*10**18 <= tokens_buy)&&(15000*10**18 < tokens_buy)) {
313           b3 = tokens_buy*15/100;
314         }
315         if((15001*10**18 <= tokens_buy)&&(20000*10**18 < tokens_buy)) {
316           b3 = tokens_buy*20/100;
317         }
318         if(20001*10**18 <= tokens_buy) {
319           b3 = tokens_buy*25/100;
320         }
321 
322         tokens_buy_total = tokens_buy.add(b1);
323         tokens_buy_total = tokens_buy_total.add(b2);
324         tokens_buy_total = tokens_buy_total.add(b3);        
325 
326         if(_totalSupply.add(tokens_buy_total) > maxTokens) throw;
327         _totalSupply = _totalSupply.add(tokens_buy_total);
328         balances[msg.sender] = balances[msg.sender].add(tokens_buy_total);         
329 
330         return true;
331       }
332       
333       /**
334       * Get total SELL orders
335       */      
336       function orders_sell_total () constant returns (uint256) {
337         return orders_sell_list.length;
338       } 
339 
340       /**
341       * Get how many tokens can buy from this SELL order
342       */
343       function get_orders_sell_amount(address _from) constant returns(uint) {
344 
345         uint _amount_max = 0;
346 
347         if(!(orders_sell_amount[_from] > 0)) return _amount_max;
348 
349         if(balanceOf(_from) > 0) _amount_max = balanceOf(_from);
350         if(orders_sell_amount[_from] < _amount_max) _amount_max = orders_sell_amount[_from];
351 
352         return _amount_max;
353       }
354 
355       /**
356       * User create SELL order.  
357       */
358       function order_sell(uint256 _max_amount, uint256 _price) returns (bool) {
359 
360         if(!(_max_amount > 0)) throw;
361         if(!(_price > 0)) throw;        
362 
363         orders_sell_amount[msg.sender] = _max_amount;
364         orders_sell_price[msg.sender] = (_price*exchange_coefficient).div(100);
365         orders_sell_list.push(msg.sender);        
366 
367         Order_sell(msg.sender, _max_amount, orders_sell_price[msg.sender]);      
368 
369         return true;
370       }
371 
372       /**
373       * Order Buy tokens - it's order search sell order from user _from and if all ok, send token and money 
374       */
375       function order_buy(address _from, uint256 _max_price) payable returns (bool) {
376         
377         if(!(msg.value > 0)) throw;
378         if(!(_max_price > 0)) throw;        
379         if(!(orders_sell_amount[_from] > 0)) throw;
380         if(!(orders_sell_price[_from] > 0)) throw; 
381         if(orders_sell_price[_from] > _max_price) throw;
382 
383         uint _amount = (msg.value*10**18).div(orders_sell_price[_from]);
384         uint _amount_from = get_orders_sell_amount(_from);
385 
386         if(_amount > _amount_from) _amount = _amount_from;        
387         if(!(_amount > 0)) throw;        
388 
389         uint _total_money = (orders_sell_price[_from]*_amount).div(10**18);
390         if(_total_money > msg.value) throw;
391 
392         uint _seller_money = (_total_money*100).div(exchange_coefficient);
393         uint _buyer_money = msg.value - _total_money;
394 
395         if(_seller_money > msg.value) throw;
396         if(_seller_money + _buyer_money > msg.value) throw;
397 
398         if(_seller_money > 0) _from.send(_seller_money);
399         if(_buyer_money > 0) msg.sender.send(_buyer_money);
400 
401         orders_sell_amount[_from] -= _amount;        
402         balances[_from] -= _amount;
403         balances[msg.sender] += _amount; 
404 
405         Order_execute(_from, msg.sender, _amount, orders_sell_price[_from]);
406 
407       }
408       
409  }