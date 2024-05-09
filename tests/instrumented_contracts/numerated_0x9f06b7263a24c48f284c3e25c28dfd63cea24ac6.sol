1 pragma solidity ^0.4.18;
2 library SafeMath {
3     
4    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12  
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19  
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24  
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30   function percent(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = (a * b)/100;
32     uint256 k = a * b;
33     assert(a == 0 || k / a == b);
34     return c;
35   }
36   
37 }
38 
39 contract Ownable {
40 address public owner;
41 function Ownable() public {    owner = msg.sender;  }
42 
43 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 modifier onlyOwner() {    require(msg.sender == owner);    _;  }
46 
47 function transferOwnership(address newOwner) public onlyOwner {
48 require(newOwner != address(0));
49 OwnershipTransferred(owner, newOwner);
50 owner = newOwner;
51   }
52 
53 }
54 
55 contract ERC20Basic {
56   uint256 public totalSupply=1000000;
57   function balanceOf(address who) public constant returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60  
61 }
62 contract BasicToken is ERC20Basic, Ownable {
63     using SafeMath for uint256;
64     mapping (address => uint) public Account_balances;
65     mapping (address => uint) public Account_frozen;
66     mapping (address => uint) public Account_timePayout; 
67     
68     event FrozenAccount_event(address target, uint frozen);
69 
70 
71   function transfer(address _toaddress, uint256 _value) public returns (bool) {
72     require(Account_frozen[msg.sender]==0 );
73     require(Account_frozen[_toaddress]==0 );
74     Account_timePayout[_toaddress]=Account_timePayout[msg.sender];
75     Account_balances[msg.sender] = Account_balances[msg.sender].sub(_value);
76     Account_balances[_toaddress] = Account_balances[_toaddress].add(_value);
77     Transfer(msg.sender, _toaddress, _value);
78     return true;
79   }
80  
81   function balanceOf(address _owner) public constant returns (uint256 balance) {
82     return Account_balances[_owner];
83      }
84   
85  function BasicToken()    public {   
86      Account_balances[msg.sender] =   totalSupply;    
87           }
88  }
89 contract AESconstants is BasicToken {
90     string public constant name = "Adept Ethereum Stocks";
91     string public constant symbol = "AES";
92     string public constant tagline = "AES - when resoluteness is rewarded!";
93     uint32 public constant decimals = 0;
94 }
95 contract Freeze_contract is AESconstants {
96    
97 function Freeze(address _address, uint _uint)   private {
98 Account_frozen[_address] = _uint;
99 FrozenAccount_event(_address, _uint);
100 }    
101     
102 // mapping (address => uint) public frozenAccount;
103 // 0 NO FREEZE
104 // 1 Freeze onlyOwner
105 // 2 Freeze user    
106 
107 //Freeze user //this is done to freeze your account. To avoid an attack: a block of dividend payments using spam transactions.
108 function user_on_freeze() public  {     require(Account_frozen[msg.sender]==0);  Freeze(msg.sender,2);   }
109 function user_off_freeze() public {    require(Account_frozen[msg.sender]==2);   Freeze(msg.sender,0);   }
110 //Freeze used bounty company
111 
112 
113 function pay_Bounty(address _address, uint _sum_pay )  onlyOwner public {
114 transfer(_address, _sum_pay); 
115 Freeze(_address, 1);
116 } 
117 
118 function offFreeze_Bounty(address _address) onlyOwner public { Freeze(_address, 0); }     
119    
120 }
121 
122 
123 contract AES_token_contract is Freeze_contract {
124 using SafeMath for uint;
125 
126 uint public next_payout=now + 90 days;
127 uint public payout = 0; // Бюджет дивидентов
128 
129 //--------Выплата доли  
130 function Take_payout() public {
131 //Проверка можно ли пользователю запрашивать
132 require(Account_timePayout[msg.sender] < now);
133 //Проверка периода, если период прошел начисляем  бюджет выплат
134 if(next_payout<now){
135 payout=this.balance; 
136 next_payout=now + 90 days;
137 }   
138 
139 msg.sender.transfer(payout.mul(Account_balances[msg.sender]).div(totalSupply));
140 Account_timePayout[msg.sender]=next_payout;
141       }
142 
143 function() external payable {} 
144    
145  }
146 contract Hype is Ownable {
147 using SafeMath for uint;  
148 address public investors;
149 function Hype(address _addres)  onlyOwner public {investors=_addres;    }
150     mapping (uint => address) public level;    
151     uint private price=5000000000000000;      // in wei    1000 finney in 1 ether
152     uint public step_level=0;
153     uint public step_pay=0;
154     uint private constant percent_hype=10;
155     uint private constant percent_investors=3;
156     uint private bonus=price.percent(100+percent_hype);
157     
158 function() external payable {
159 require(msg.value > 4999999999999999);
160 uint amt_deposit=msg.value.div(price); // Количество шагов // обязательно перед выплатой инвесторам
161 investors.transfer(msg.value.percent(percent_investors));       //Переводим процент инвесторам
162 
163  for (  uint i= 0; i < amt_deposit; i++) { 
164         if (level[step_pay].send(bonus)==true){
165           step_pay++;
166                                               }
167      level[step_level]=msg.sender;
168      step_level++;
169                                               }
170                                               }
171 
172    
173 }
174 contract BigHype is Ownable {
175 using SafeMath for uint;  
176 address public investors;
177 function BigHype(address _addres)  onlyOwner public {investors=_addres;      }
178 
179 struct info {
180         address i_address;
181         uint i_balance;
182             }
183 
184     mapping (uint => info) public level;    
185     uint public step_level=0;
186     uint public step_pay=0;
187     uint private constant percent_hype=10;
188     uint private constant percent_investors=3;
189  
190 function() external payable {
191 require(msg.value > 4999999999999999); 
192 investors.transfer(msg.value.percent(percent_investors));       
193 uint bonus=(level[step_pay].i_balance).percent(100+percent_hype);  
194  if (step_level>0 && level[step_pay].i_address.send(bonus)==true){
195           step_pay++;
196                                                                  }
197      level[step_level].i_address=msg.sender;
198      level[step_level].i_balance=msg.value;
199      step_level++;
200 }
201 
202 }
203 
204 
205 contract Crowdsale is Ownable {
206   
207 address private	multisig = msg.sender; 
208 bool private share_team_AES=false;
209 
210 
211 using SafeMath for uint;
212 
213 AES_token_contract   public AEStoken  = new AES_token_contract(); 
214 Hype     public hype    = new Hype(AEStoken);
215 BigHype  public bighype = new BigHype(AEStoken);
216 
217 uint public Time_Start_Crowdsale= 1518210000; // 1518210000  - 10 February 2018
218 
219 // Выплата команде и баунти
220 function Take_share_team_AES() onlyOwner public {
221 require(share_team_AES == false);
222 AEStoken.transfer(multisig,500000); 
223 share_team_AES=true;
224 }
225 
226 // старт
227 function For_admin() onlyOwner public {
228 AEStoken.transferOwnership(multisig); 
229 hype.transferOwnership(multisig); 
230 bighype.transferOwnership(multisig); 
231 }
232 
233 
234 function getTokensSale() public  view returns(uint){  return AEStoken.balanceOf(this);  }
235 function getBalance_in_token() public view returns(uint){  return AEStoken.balanceOf(msg.sender); }
236  
237 modifier isSaleTime() {  require(Time_Start_Crowdsale<now);  _;  } 
238  
239  // Всего 1 000 000 токенов AES
240  // 400 000 баунти          40%
241  // 100 000 команда проекта 10%
242  // 500 000 SALE IN ICO     50%
243 
244  
245    function createTokens() isSaleTime private  {
246       
247         uint Tokens_on_Sale = AEStoken.balanceOf(this);      
248         uint CenaTokena=1000000000000000; //1 finney= 1000 Szabo =0.002 Ether  //   1000 Szabo= 1 finney
249         
250         uint Discount=0;
251         
252       // Скидка от остатка для распродажи
253             if(Tokens_on_Sale>400000)   {Discount+=20;}   //Szabo
254        else if(Tokens_on_Sale>300000)   {Discount+=15; }   //Szabo
255        else if(Tokens_on_Sale>200000)   {Discount+=10; }   //2000 Szabo   1000 Szabo= 1 finney
256        else if(Tokens_on_Sale>100000)   {Discount+=5; } 
257        
258        // Скидка от объема
259             if(msg.value> 1000000000000000000 && Tokens_on_Sale>2500 )  {Discount+=20; }   // Если покупка больше чем на 1 эфиров 
260        else if(msg.value>  900000000000000000 && Tokens_on_Sale>1500 )  {Discount+=15;  }   // Если покупка больше чем на 0.9 эфиров 
261        else if(msg.value>  600000000000000000 && Tokens_on_Sale>500  )  {Discount+=10;  }   // Если покупка больше чем на 0.6 эфира 
262        else if(msg.value>  300000000000000000 && Tokens_on_Sale>250  )  {Discount+=5;  }   // Если покупка больше чем на 0.3 эфир 
263        
264        //Скидка от времени
265      uint256   Time_Discount=now-Time_Start_Crowdsale;
266              if(Time_Discount < 3 days)   {Discount+=20; }
267         else if(Time_Discount < 5 days)   {Discount+=15; }       
268         else if(Time_Discount < 10 days)  {Discount+=10; }
269         else if(Time_Discount < 20 days)  {Discount+=5;  } 
270          
271      CenaTokena=CenaTokena.percent(100-Discount); // Делаем скидку
272      uint256 Tokens=msg.value.div(CenaTokena); // Узнаем сколько токенов купили
273        
274         if (Tokens_on_Sale>=Tokens)   {         
275             multisig.transfer(msg.value);
276           }
277      else {
278         multisig.transfer(msg.value.mul(Tokens_on_Sale.div(Tokens)));   // Оплату приняли сколько влезло
279         msg.sender.transfer(msg.value.mul(Tokens-Tokens_on_Sale).div(Tokens));  // Что не влезло назад
280         Tokens=Tokens_on_Sale;
281         }
282         
283        AEStoken.transfer(msg.sender, Tokens);
284         
285         }
286        
287  
288     function() external payable {
289      
290       if (AEStoken.balanceOf(this)>0)  { createTokens(); }
291       else { AEStoken.transfer(msg.value); }// После окончания ICO принимаем пожертвования
292         
293     }
294     
295 }