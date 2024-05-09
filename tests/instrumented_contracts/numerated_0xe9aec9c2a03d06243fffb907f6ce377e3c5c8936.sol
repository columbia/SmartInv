1 pragma solidity ^0.4.11;
2     
3    // ----------------------------------------------------------------------------------------------
4    // Developer Nechesov Andrey: Facebook.com/Nechesov   
5    // Enjoy. (c) PRCR.org ICO Platform 2017. The PRCR Licence.
6    // ----------------------------------------------------------------------------------------------
7     
8    // ERC Token Standard #20 Interface
9    // https://github.com/ethereum/EIPs/issues/20
10   contract ERC20Interface {
11       // Get the total token supply
12       function totalSupply() constant returns (uint256 totalSupply);
13    
14       // Get the account balance of another account with address _owner
15       function balanceOf(address _owner) constant returns (uint256 balance);
16    
17       // Send _value amount of tokens to address _to
18       function transfer(address _to, uint256 _value) returns (bool success);
19    
20       // Send _value amount of tokens from address _from to address _to
21       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22    
23       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
24       // If this function is called again it overwrites the current allowance with _value.
25       // this function is required for some DEX functionality
26       function approve(address _spender, uint256 _value) returns (bool success);
27    
28       // Returns the amount which _spender is still allowed to withdraw from _owner
29       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30    
31       // Triggered when tokens are transferred.
32       event Transfer(address indexed _from, address indexed _to, uint256 _value);
33    
34       // Triggered whenever approve(address _spender, uint256 _value) is called.
35       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36   }  
37    
38   contract CentraToken is ERC20Interface {
39 
40       string public constant symbol = "Centra";
41       string public constant name = "Centra token";
42       uint8 public constant decimals = 18; 
43            
44       uint256 public constant maxTokens = 100000000*10**18; 
45       uint256 public constant ownerSupply = maxTokens*32/100;
46       uint256 _totalSupply = ownerSupply;  
47 
48       uint256 public constant token_price = 1/400*10**18; 
49       uint public constant ico_start = 1501891200;
50       uint public constant ico_finish = 1507248000; 
51       uint public constant minValuePre = 100*10**18; 
52       uint public constant minValue = 1*10**18; 
53       uint public constant maxValue = 3000*10**18;       
54 
55       uint public constant card_gold_minamount  = 30*10**18;
56       uint public constant card_gold_first = 1000;
57       mapping(address => uint) cards_gold_check; 
58       address[] public cards_gold;
59 
60       uint public constant card_black_minamount = 100*10**18;
61       uint public constant card_black_first = 500;
62       mapping(address => uint) public cards_black_check; 
63       address[] public cards_black;
64 
65       uint public constant card_titanium_minamount  = 500*10**18;
66       uint public constant card_titanium_first = 200;
67       mapping(address => uint) cards_titanium_check; 
68       address[] public cards_titanium;
69 
70       uint public constant card_blue_minamount  = 5/10*10**18;
71       uint public constant card_blue_first = 100000000;
72       mapping(address => uint) cards_blue_check; 
73       address[] public cards_blue;
74 
75       uint public constant card_start_minamount  = 1/10*10**18;
76       uint public constant card_start_first = 100000000;
77       mapping(address => uint) cards_start_check; 
78       address[] public cards_start;
79 
80       using SafeMath for uint;      
81       
82       // Owner of this contract
83       address public owner;
84    
85       // Balances for each account
86       mapping(address => uint256) balances;
87    
88       // Owner of account approves the transfer of an amount to another account
89       mapping(address => mapping (address => uint256)) allowed;
90    
91       // Functions with this modifier can only be executed by the owner
92       modifier onlyOwner() {
93           if (msg.sender != owner) {
94               throw;
95           }
96           _;
97       }      
98    
99       // Constructor
100       function CentraToken() {
101           owner = msg.sender;
102           balances[owner] = ownerSupply;
103       }
104       
105       //default function for buy tokens      
106       function() payable {        
107           tokens_buy();        
108       }
109       
110       function totalSupply() constant returns (uint256 totalSupply) {
111           totalSupply = _totalSupply;
112       }
113 
114       //Withdraw money from contract balance to owner
115       function withdraw() onlyOwner returns (bool result) {
116           owner.send(this.balance);
117           return true;
118       }
119    
120       // What is the balance of a particular account?
121       function balanceOf(address _owner) constant returns (uint256 balance) {
122           return balances[_owner];
123       }
124    
125       // Transfer the balance from owner's account to another account
126       function transfer(address _to, uint256 _amount) returns (bool success) {
127 
128           if(now < ico_start) throw;
129 
130           if (balances[msg.sender] >= _amount 
131               && _amount > 0
132               && balances[_to] + _amount > balances[_to]) {
133               balances[msg.sender] -= _amount;
134               balances[_to] += _amount;
135               Transfer(msg.sender, _to, _amount);
136               return true;
137           } else {
138               return false;
139           }
140       }
141    
142       // Send _value amount of tokens from address _from to address _to
143       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
144       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
145       // fees in sub-currencies; the command should fail unless the _from account has
146       // deliberately authorized the sender of the message via some mechanism; we propose
147       // these standardized APIs for approval:
148       function transferFrom(
149           address _from,
150           address _to,
151           uint256 _amount
152      ) returns (bool success) {
153 
154          if(now < ico_start) throw;
155 
156          if (balances[_from] >= _amount
157              && allowed[_from][msg.sender] >= _amount
158              && _amount > 0
159              && balances[_to] + _amount > balances[_to]) {
160              balances[_from] -= _amount;
161              allowed[_from][msg.sender] -= _amount;
162              balances[_to] += _amount;
163              Transfer(_from, _to, _amount);
164              return true;
165          } else {
166              return false;
167          }
168      }
169   
170      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
171      // If this function is called again it overwrites the current allowance with _value.
172      function approve(address _spender, uint256 _amount) returns (bool success) {
173          allowed[msg.sender][_spender] = _amount;
174          Approval(msg.sender, _spender, _amount);
175          return true;
176      }
177   
178      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
179          return allowed[_owner][_spender];
180      }
181      //get total black cards
182     function cards_black_total() constant returns (uint) { 
183       return cards_black.length;
184     }
185     //get total gold cards
186     function cards_gold_total() constant returns (uint) { 
187       return cards_gold.length;
188     }    
189     //get total titanium cards
190     function cards_titanium_total() constant returns (uint) { 
191       return cards_titanium.length;
192     }
193     //get total blue cards
194     function cards_blue_total() constant returns (uint) { 
195       return cards_blue.length;
196     }
197 
198     //get total start cards
199     function cards_start_total() constant returns (uint) { 
200       return cards_start.length;
201     }
202 
203       /**
204       * Buy tokens pre-sale and sale 
205       */
206       function tokens_buy() payable returns (bool) { 
207 
208         uint tnow = now;
209         
210         if(tnow > ico_finish) throw;        
211         if(_totalSupply >= maxTokens) throw;
212         if(!(msg.value >= token_price)) throw;
213         if(!(msg.value >= minValue)) throw;
214         if(msg.value > maxValue) throw;
215 
216         uint tokens_buy = msg.value/token_price*10**18;
217 
218         if(!(tokens_buy > 0)) throw;   
219 
220         if(tnow < ico_start){
221           if(!(msg.value >= minValuePre)) throw;
222           tokens_buy = tokens_buy*125/100;
223         } 
224         if((ico_start + 86400*0 <= tnow)&&(tnow < ico_start + 86400*2)){
225           tokens_buy = tokens_buy*120/100;
226         } 
227         if((ico_start + 86400*2 <= tnow)&&(tnow < ico_start + 86400*7)){
228           tokens_buy = tokens_buy*110/100;        
229         } 
230         if((ico_start + 86400*7 <= tnow)&&(tnow < ico_start + 86400*14)){
231           tokens_buy = tokens_buy*105/100;        
232         }         
233 
234         if(_totalSupply.add(tokens_buy) > maxTokens) throw;
235         _totalSupply = _totalSupply.add(tokens_buy);
236         balances[msg.sender] = balances[msg.sender].add(tokens_buy); 
237 
238         if((msg.value >= card_gold_minamount)
239           &&(msg.value < card_black_minamount)
240           &&(cards_gold.length < card_gold_first)
241           &&(cards_gold_check[msg.sender] != 1)
242           ) {
243           cards_gold.push(msg.sender);
244           cards_gold_check[msg.sender] = 1;
245         }       
246 
247         if((msg.value >= card_black_minamount)
248           &&(msg.value < card_titanium_minamount)
249           &&(cards_black.length < card_black_first)
250           &&(cards_black_check[msg.sender] != 1)
251           ) {
252           cards_black.push(msg.sender);
253           cards_black_check[msg.sender] = 1;
254         }        
255 
256         if((msg.value >= card_titanium_minamount)
257           &&(cards_titanium.length < card_titanium_first)
258           &&(cards_titanium_check[msg.sender] != 1)
259           ) {
260           cards_titanium.push(msg.sender);
261           cards_titanium_check[msg.sender] = 1;
262         }
263 
264         if((msg.value >= card_blue_minamount)
265           &&(msg.value < card_gold_minamount)
266           &&(cards_blue.length < card_blue_first)
267           &&(cards_blue_check[msg.sender] != 1)
268           ) {
269           cards_blue.push(msg.sender);
270           cards_blue_check[msg.sender] = 1;
271         }
272 
273         if((msg.value >= card_start_minamount)
274           &&(msg.value < card_blue_minamount)
275           &&(cards_start.length < card_start_first)
276           &&(cards_start_check[msg.sender] != 1)
277           ) {
278           cards_start.push(msg.sender);
279           cards_start_check[msg.sender] = 1;
280         }
281 
282         return true;
283       }
284       
285  }
286 
287  /**
288    * Math operations with safety checks
289    */
290   library SafeMath {
291     function mul(uint a, uint b) internal returns (uint) {
292       uint c = a * b;
293       assert(a == 0 || c / a == b);
294       return c;
295     }
296 
297     function div(uint a, uint b) internal returns (uint) {
298       // assert(b > 0); // Solidity automatically throws when dividing by 0
299       uint c = a / b;
300       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301       return c;
302     }
303 
304     function sub(uint a, uint b) internal returns (uint) {
305       assert(b <= a);
306       return a - b;
307     }
308 
309     function add(uint a, uint b) internal returns (uint) {
310       uint c = a + b;
311       assert(c >= a);
312       return c;
313     }
314 
315     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
316       return a >= b ? a : b;
317     }
318 
319     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
320       return a < b ? a : b;
321     }
322 
323     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
324       return a >= b ? a : b;
325     }
326 
327     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
328       return a < b ? a : b;
329     }
330 
331     function assert(bool assertion) internal {
332       if (!assertion) {
333         throw;
334       }
335     }
336   }