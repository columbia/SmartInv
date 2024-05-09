1 pragma solidity ^0.4.21;
2     
3    // ----------------------------------------------------------------------------------------------
4    // Project Delta 
5    // DELTA - New Crypto-Platform with own currency, verified semantic contracts and multi blockchains!
6    // Site: http://delta.money
7    // Telegram Chat: @deltacoin
8    // Telegram News: @deltaico
9    // CEO Nechesov Andrey http://facebook.com/Nechesov     
10    // Ltd. "Delta"   
11    // Tokens Delta: BUY and SELL into this smart contract on exchange
12    // ----------------------------------------------------------------------------------------------
13     
14   library SafeMath {
15     function mul(uint256 a, uint256 b) internal returns (uint256) {
16       uint256 c = a * b;
17       assert(a == 0 || c / a == b);
18       return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal returns (uint256) {
22       // assert(b > 0); // Solidity automatically throws when dividing by 0
23       uint256 c = a / b;
24       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25       return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal returns (uint256) {
29       assert(b <= a);
30       return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal returns (uint256) {
34       uint256 c = a + b;
35       assert(c >= a);
36       return c;
37     }
38   }
39 
40    // ERC Token Standard #20 Interface
41    // https://github.com/ethereum/EIPs/issues/20
42 
43   contract ERC20Interface {
44       // Get the total token supply
45       function totalSupply() constant returns (uint256 totalSupply);
46    
47       // Get the account balance of another account with address _owner
48       function balanceOf(address _owner) constant returns (uint256 balance);
49    
50       // Send _value amount of tokens to address _to
51       function transfer(address _to, uint256 _value) returns (bool success);
52    
53       // Send _value amount of tokens from address _from to address _to
54       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
55    
56       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
57       // If this function is called again it overwrites the current allowance with _value.
58       // this function is required for some DEX functionality
59       function approve(address _spender, uint256 _value) returns (bool success);
60    
61       // Returns the amount which _spender is still allowed to withdraw from _owner
62       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
63    
64       // Triggered when tokens are transferred.
65       event Transfer(address indexed _from, address indexed _to, uint256 _value);
66    
67       // Triggered whenever approve(address _spender, uint256 _value) is called.
68       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69   }
70 
71   contract MigrationAgent {
72     function migrateFrom(address _from, uint256 _value);
73   }      
74    
75   contract TokenBase is ERC20Interface {
76 
77       using SafeMath for uint;
78 
79       string public constant symbol = "DELTA";
80       string public constant name = "DELTA token";
81       uint8 public constant decimals = 18; 
82            
83       uint256 public constant maxTokens = (2**32-1)*10**18; 
84       uint256 public constant ownerSupply = maxTokens*25/100;
85       uint256 _totalSupply = ownerSupply;              
86 
87       // For future
88       // If migration to a new contract is allowed
89       bool public migrationAllowed = false;
90 
91       // New contract address
92       address public migrationAddress;
93 
94       // How many tokens were migrated to a new contract 
95       uint256 public totalMigrated = 0; 
96       
97       // Owner of this contract
98       address public owner;
99    
100       // Balances for each account
101       mapping(address => uint256) balances;
102    
103       // Owner of account approves the transfer of an amount to another account
104       mapping(address => mapping (address => uint256)) allowed;
105 
106       // Orders holders who wish sell tokens, save amount
107       mapping(address => uint256) public orders_sell_amount;
108 
109       // Orders holders who wish sell tokens, save price
110       mapping(address => uint256) public orders_sell_price;
111 
112       //orders list
113       address[] public orders_sell_list;
114 
115       // Triggered orders sell/buy
116       event Orders_sell(address indexed _from, address indexed _to, uint256 _amount, uint256 _price, uint256 _seller_money, uint256 _buyer_money);
117    
118       // Functions with this modifier can only be executed by the owner
119       modifier onlyOwner() {
120           if (msg.sender != owner) {
121               throw;
122           }
123           _;
124       }
125 
126       // Migrate tokens to a new contract
127       function migrate(uint256 _value) external {
128           require(migrationAllowed);
129           require(migrationAddress != 0x0);
130           require(_value > 0);
131           require(_value <= balances[msg.sender]);
132 
133           balances[msg.sender] = balances[msg.sender].sub(_value);
134           _totalSupply = _totalSupply.sub(_value);
135           totalMigrated = totalMigrated.add(_value);
136 
137           MigrationAgent(migrationAddress).migrateFrom(msg.sender, _value);
138       }  
139       
140       function configureMigrate(bool _migrationAllowed, address _migrationAddress) onlyOwner {
141           migrationAllowed = _migrationAllowed;
142           migrationAddress = _migrationAddress;
143       }
144 
145   }
146 
147   contract DELTA_Token is TokenBase {
148 
149       using SafeMath for uint;
150 
151       uint256 public constant token_price = 10**18*1/100; 
152 
153       uint public pre_ico_start = 1522540800;
154       uint public ico_start = 1525132800;
155       uint public ico_finish = 1530403200;             
156 
157       uint public p1 = 250;             
158       uint public p2 = 200;             
159       uint public p3 = 150;             
160       uint public p4 = 125;             
161       uint public p5 = 100;
162 
163       uint public coef = 105;      
164    
165       // Constructor
166       function DELTA_Token() {
167           owner = msg.sender;
168           balances[owner] = ownerSupply;
169       }
170       
171       //default function for buy tokens      
172       function() payable {        
173           tokens_buy();        
174       }
175       
176       function totalSupply() constant returns (uint256 totalSupply) {
177           totalSupply = _totalSupply;
178       }
179 
180       //Withdraw money from contract balance to owner
181       function withdraw(uint256 _amount) onlyOwner returns (bool result) {
182           uint256 balance;
183           balance = this.balance;
184           if(_amount > 0) balance = _amount;
185           owner.send(balance);
186           return true;
187       }
188 
189       //Change coef
190       function change_coef(uint256 _coef) onlyOwner returns (bool result) {
191           coef = _coef;
192           return true;
193       }
194 
195       function change_p1(uint256 _p1) onlyOwner returns (bool result) {
196           p1 = _p1;
197           return true;
198       }
199 
200       function change_p2(uint256 _p2) onlyOwner returns (bool result) {
201           p2 = _p2;
202           return true;
203       }
204 
205       function change_p3(uint256 _p3) onlyOwner returns (bool result) {
206           p3 = _p3;
207           return true;
208       }
209 
210       function change_p4(uint256 _p4) onlyOwner returns (bool result) {
211           p4 = _p4;
212           return true;
213       }
214 
215       function change_p5(uint256 _p5) onlyOwner returns (bool result) {
216           p5 = _p5;
217           return true;
218       }
219 
220       //Change pre_ico_start date
221       function change_pre_ico_start(uint256 _pre_ico_start) onlyOwner returns (bool result) {
222           pre_ico_start = _pre_ico_start;
223           return true;
224       }
225 
226       //Change ico_start date
227       function change_ico_start(uint256 _ico_start) onlyOwner returns (bool result) {
228           ico_start = _ico_start;
229           return true;
230       }
231 
232       //Change ico_finish date
233       function change_ico_finish(uint256 _ico_finish) onlyOwner returns (bool result) {
234           ico_finish = _ico_finish;
235           return true;
236       }
237    
238       // What is the balance of a particular account?
239       function balanceOf(address _owner) constant returns (uint256 balance) {
240           return balances[_owner];
241       }
242    
243       // Transfer the balance from owner's account to another account
244       function transfer(address _to, uint256 _amount) returns (bool success) {          
245 
246           if (balances[msg.sender] >= _amount 
247               && _amount > 0
248               && balances[_to] + _amount > balances[_to]) {
249               balances[msg.sender] -= _amount;
250               balances[_to] += _amount;
251               Transfer(msg.sender, _to, _amount);
252               return true;
253           } else {
254               return false;
255           }
256       }
257    
258       // Send _value amount of tokens from address _from to address _to
259       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
260       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
261       // fees in sub-currencies; the command should fail unless the _from account has
262       // deliberately authorized the sender of the message via some mechanism; we propose
263       // these standardized APIs for approval:
264       function transferFrom(
265           address _from,
266           address _to,
267           uint256 _amount
268      ) returns (bool success) {         
269 
270          if (balances[_from] >= _amount
271              && allowed[_from][msg.sender] >= _amount
272              && _amount > 0
273              && balances[_to] + _amount > balances[_to]) {
274              balances[_from] -= _amount;
275              allowed[_from][msg.sender] -= _amount;
276              balances[_to] += _amount;
277              Transfer(_from, _to, _amount);
278              return true;
279          } else {
280              return false;
281          }
282      }
283   
284      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
285      // If this function is called again it overwrites the current allowance with _value.
286      function approve(address _spender, uint256 _amount) returns (bool success) {
287          allowed[msg.sender][_spender] = _amount;
288          Approval(msg.sender, _spender, _amount);
289          return true;
290      }
291   
292      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
293          return allowed[_owner][_spender];
294      } 
295 
296       /**
297       * Buy tokens on pre-ico and ico 
298       */
299       function tokens_buy() payable returns (bool) { 
300 
301         uint tnow = now;        
302         
303         require(tnow <= ico_finish);
304         require(_totalSupply < maxTokens);
305         require(msg.value >= token_price);        
306 
307         uint tokens_buy = msg.value*10**18/token_price;
308 
309         require(tokens_buy > 0);   
310         
311         if(tnow < ico_start + 86400*0){          
312           tokens_buy = tokens_buy*p1/100;
313         } 
314         if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){
315           tokens_buy = tokens_buy*p2/100;
316         } 
317         if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){
318           tokens_buy = tokens_buy*p3/100;        
319         } 
320         if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){
321           tokens_buy = tokens_buy*p4/100;        
322         }
323         if(ico_start + 86400*14 <= tnow){
324           tokens_buy = tokens_buy*p5/100;        
325         }         
326 
327         require(_totalSupply.add(tokens_buy) <= maxTokens);
328         _totalSupply = _totalSupply.add(tokens_buy);
329         balances[msg.sender] = balances[msg.sender].add(tokens_buy);         
330 
331         return true;
332       }      
333 
334       function orders_sell_total () constant returns (uint) {
335         return orders_sell_list.length;
336       } 
337 
338       function get_orders_sell_amount(address _from) constant returns(uint) {
339 
340         uint _amount_max = 0;
341 
342         if(!(orders_sell_amount[_from] > 0)) return _amount_max;
343 
344         if(balanceOf(_from) > 0) _amount_max = balanceOf(_from);
345         if(orders_sell_amount[_from] < _amount_max) _amount_max = orders_sell_amount[_from];
346 
347         return _amount_max;
348       }
349 
350       /**
351       * Order Sell tokens  
352       */
353       function order_sell(uint256 _max_amount, uint256 _price) returns (bool) {
354 
355         require(_max_amount > 0);
356         require(_price > 0);        
357 
358         orders_sell_amount[msg.sender] = _max_amount;
359         orders_sell_price[msg.sender] = (_price*coef).div(100);
360         orders_sell_list.push(msg.sender);        
361 
362         return true;
363       }
364 
365       function order_buy(address _from, uint256 _max_price) payable returns (bool) {
366         
367         require(msg.value > 0);
368         require(_max_price > 0);        
369         require(orders_sell_amount[_from] > 0);
370         require(orders_sell_price[_from] > 0); 
371         require(orders_sell_price[_from] <= _max_price);
372 
373         uint _amount = (msg.value*10**18).div(orders_sell_price[_from]);
374         uint _amount_from = get_orders_sell_amount(_from);
375 
376         if(_amount > _amount_from) _amount = _amount_from;        
377         require(_amount > 0);        
378 
379         uint _total_money = (orders_sell_price[_from]*_amount).div(10**18);        
380         require(_total_money <= msg.value);
381 
382         uint _seller_money = (_total_money*100).div(coef);
383         uint _buyer_money = msg.value - _total_money;
384 
385         require(_seller_money > 0);        
386         require(_seller_money + _buyer_money <= msg.value);
387         
388         _from.send(_seller_money);
389         msg.sender.send(_buyer_money);
390 
391         orders_sell_amount[_from] -= _amount;        
392         balances[_from] -= _amount;
393         balances[msg.sender] += _amount; 
394 
395         Orders_sell(_from, msg.sender, _amount, orders_sell_price[_from], _seller_money, _buyer_money);
396 
397       }
398       
399  }