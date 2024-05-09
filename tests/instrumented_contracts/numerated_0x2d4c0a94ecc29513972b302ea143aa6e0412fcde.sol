1 pragma solidity ^0.4.18;
2 
3 // Created by Roman Oznobin (oz_r@mail.ru) - http://code-expert.pro
4 // Owner is Alexey Malashkin (leningrad18@yandex.ru)
5 // Smart contract for BasisToken of Ltd "KKM" (armaturaplus@mail.ru) - http://ruarmatura.ru/
6 
7 library SafeMath {
8 
9   function mul(uint a, uint b) internal pure returns (uint) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint a, uint b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41 
42   address public owner;
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56      address inp_sender = msg.sender;
57      bool chekk = msg.sender == owner;
58     require(chekk);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     owner = newOwner;
69   }
70 
71 }
72 
73 // The contract...
74 
75 contract BasisIco  {
76 
77   using SafeMath for uint;
78   
79     string public constant name = "Basis Token";
80 
81     string public constant symbol = "BSS";
82 
83     uint32 public constant decimals = 0;  
84     
85     struct Investor {
86         address holder;
87         uint tokens;
88 
89     }
90   
91     Investor[] internal Cast_Arr;
92      
93     Investor tmp_investor;  
94       
95   
96   // Used to set wallet for owner, bounty and developer
97   // To that address Ether will be sended if Ico will have sucsess done
98   // Untill Ico is no finish and is no sucsess, all Ether are closed from anybody on ICO contract wallet
99   address internal constant owner_wallet = 0x79d8af6eEA6Aeeaf7a3a92D348457a5C4f0eEe1B;
100   address public constant owner = 0x79d8af6eEA6Aeeaf7a3a92D348457a5C4f0eEe1B;
101   address internal constant developer = 0xf2F1A92AD7f1124ef8900931ED00683f0B3A5da7;
102 
103   //
104   //address public bounty_wallet = 0x79d8af6eEA6Aeeaf7a3a92D348457a5C4f0eEe1B;
105 
106   uint public constant bountyPercent = 4;
107   
108 
109   //address public bounty_reatricted_addr;
110   //Base price for BSS ICO. Show how much Wei is in 1 BSS. During ICO price calculate from the $rate
111   uint internal constant rate = 3300000000000000;
112   
113     uint public token_iso_price;
114 // Генерируется в Crowdsale constructor
115 //  BasisToken public token = new BasisToken();
116 
117   // Time sructure of Basis ico
118   // start_declaration of first round of Basis ico - Presale ( start_declaration of token creation and ico Presale )
119   uint public start_declaration = 1511384400;
120   // The period for calculate the time structure of Basis ico, amount of the days
121   uint public ico_period = 15;
122   // First round finish - Presale finish
123   uint public presale_finish;
124   // ico Second raund start.
125   uint public second_round_start;
126   // Basis ico finish, all mint are closed
127   uint public ico_finish = start_declaration + (ico_period * 1 days).mul(6);
128 
129 
130   // Limmits and callculation of total minted Basis token
131     uint public constant hardcap = 1536000;
132     // minimal for softcap
133     uint public softcap = 150000;
134     // Total suplied Basis token during ICO
135     uint public bssTotalSuply;
136     // Wei raised during ICO
137     uint public weiRaised;
138   //  list of owners and token balances 
139     mapping(address => uint) public ico_balances;
140   //  list of owners and ether balances for refund    
141     mapping(address => uint) public ico_investor;
142    
143     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
144     event  Finalized();  
145     event Transfer(address indexed from, address indexed to, uint256 value);    
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 
148     
149     bool RefundICO =false;
150     bool isFinalized =false;
151     // The map of allowed tokens for external address access
152     mapping (address => mapping (address => uint256)) allowed;
153     
154 // The constractor of contract ...
155   function BasisIco() public     {
156 
157  
158     weiRaised = 0;
159     bssTotalSuply = 0;
160   
161     
162     token_iso_price = rate.mul(80).div(100); 
163 
164 
165 
166     presale_finish = start_declaration + (ico_period * 1 days);
167     second_round_start = start_declaration + (ico_period * 1 days).mul(2);
168   }
169   
170     modifier saleIsOn() {
171       require(now > start_declaration && now < ico_finish);
172       _;
173     }
174 
175     modifier NoBreak() {
176       require(now < presale_finish  || now > second_round_start);
177       _;
178     }
179 
180     modifier isUnderHardCap() {
181       require (bssTotalSuply <= hardcap);
182       _;
183     }  
184     
185     modifier onlyOwner() {
186          address inp_sender = msg.sender;
187          bool chekk = msg.sender == owner;
188         require(chekk);
189     _;
190      }
191   
192     function setPrice () public isUnderHardCap saleIsOn {
193           if  (now < presale_finish ){
194                // Chek total supply BSS for price level changes
195               if( bssTotalSuply > 50000 && bssTotalSuply <= 100000 ) {
196                   token_iso_price = rate.mul(85).div(100);
197               }
198                 if( bssTotalSuply > 100000 && bssTotalSuply <= 150000 ) {
199                   token_iso_price = rate.mul(90).div(100);
200                   }
201 
202           }
203           else {
204                if(bssTotalSuply <= 200000) {
205                    token_iso_price = rate.mul(90).div(100);
206                } else { if(bssTotalSuply <= 400000) {
207                         token_iso_price = rate.mul(95).div(100);
208                         }
209                         else {
210                         token_iso_price = rate;
211                         }
212                       }
213            }
214     } 
215     
216     function getActualPrice() public returns (uint) {
217         setPrice ();        
218         return token_iso_price;
219     }  
220     
221      function validPurchase(uint _msg_value) internal constant returns (bool) {
222      bool withinPeriod = now >= start_declaration && now <= ico_finish;
223      bool nonZeroPurchase = _msg_value != 0;
224      return withinPeriod && nonZeroPurchase;
225    }
226    
227    function token_mint(address _investor, uint _tokens, uint _wei) internal {
228        
229        ico_balances[_investor] = ico_balances[_investor].add(_tokens);
230        tmp_investor.holder = _investor;
231        tmp_investor.tokens = _tokens;
232        Cast_Arr.push(tmp_investor);
233        ico_investor[_investor]= ico_investor[_investor].add(_wei);
234    }
235     
236    function buyTokens() external payable saleIsOn NoBreak {
237      
238      //require(beneficiary != address(0));
239      require(validPurchase(msg.value));
240 
241      uint256 weiAmount = msg.value;
242 
243      // calculate token amount to be created
244      uint256 tokens = weiAmount.div(token_iso_price);
245      if  (now < presale_finish ){
246          require ((bssTotalSuply + tokens) <= softcap);
247      }
248     require ((bssTotalSuply + tokens) < hardcap);
249      // update state
250      weiRaised = weiRaised.add(weiAmount);
251 
252      token_mint( msg.sender, tokens, msg.value);
253      TokenPurchase(msg.sender, msg.sender, weiAmount, tokens);
254 
255      //forwardFunds();
256      bssTotalSuply += tokens;
257     }
258 
259    // fallback function can be used to buy tokens
260    function () external payable {
261      buyTokensFor(msg.sender);
262    } 
263 
264    function buyTokensFor(address beneficiary) public payable saleIsOn NoBreak {
265      
266      require(beneficiary != address(0));
267      require(validPurchase(msg.value));
268 
269      uint256 weiAmount = msg.value;
270 
271      // calculate token amount to be created
272      uint256 tokens = weiAmount.div(token_iso_price);
273       if  (now < presale_finish ){
274          require ((bssTotalSuply + tokens) <= softcap);
275      }
276     require ((bssTotalSuply + tokens) < hardcap);
277      // update state
278      weiRaised = weiRaised.add(weiAmount);
279 
280      token_mint( beneficiary, tokens, msg.value);
281      TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
282 
283      //forwardFunds();
284      bssTotalSuply += tokens;
285  }
286  
287    function extraTokenMint(address beneficiary, uint _tokens) external payable saleIsOn onlyOwner {
288      
289     require(beneficiary != address(0));
290     require ((bssTotalSuply + _tokens) < hardcap);
291     
292     uint weiAmount = _tokens.mul(token_iso_price);
293      // update state
294     weiRaised = weiRaised.add(weiAmount);
295 
296      token_mint( beneficiary, _tokens, msg.value);
297      TokenPurchase(msg.sender, beneficiary, weiAmount, _tokens);
298 
299      //forwardFunds();
300      bssTotalSuply += _tokens;
301   }
302 
303   function goalReached() public constant returns (bool) {
304     return bssTotalSuply >= softcap;
305   }
306   
307   function bounty_mining () internal {
308     uint bounty_tokens = bssTotalSuply.mul(bountyPercent).div(100);
309     uint tmp_z = 0;
310     token_mint(owner_wallet, bounty_tokens, tmp_z);
311     bssTotalSuply += bounty_tokens;
312     }  
313   
314   // vault finalization task, called when owner calls finalize()
315   function finalization() public onlyOwner {
316     require (now > ico_finish);
317     if (goalReached()) {
318         bounty_mining ();
319         EtherTakeAfterSoftcap ();
320         } 
321     else {
322         RefundICO = true;    
323     }
324     isFinalized = true;
325     Finalized();
326   }  
327 
328   function investor_Refund()  public {
329         require (RefundICO && isFinalized);
330         address investor = msg.sender;
331         uint for_refund = ico_investor[msg.sender];
332         investor.transfer(for_refund);
333 
334   }
335   
336   function EtherTakeAfterSoftcap () onlyOwner public {
337       require ( bssTotalSuply >= softcap );
338       uint for_developer = this.balance;
339       for_developer = for_developer.mul(6).div(100);
340       developer.transfer(for_developer);
341       owner.transfer(this.balance);
342   }
343 
344   function balanceOf(address _owner) constant public returns (uint256 balance) {
345     return ico_balances[_owner];
346   }
347   
348    function transfer(address _to, uint256 _value) public returns (bool) {
349     ico_balances[msg.sender] = ico_balances[msg.sender].sub(_value);
350     ico_balances[_to] = ico_balances[_to].add(_value);
351     Transfer(msg.sender, _to, _value);
352     return true;
353   } 
354 
355   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
356     var _allowance = allowed[_from][msg.sender];
357 
358     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
359     require (_value <= _allowance);
360 
361     ico_balances[_to] = ico_balances[_to].add(_value);
362     ico_balances[_from] = ico_balances[_from].sub(_value);
363     allowed[_from][msg.sender] = _allowance.sub(_value);
364     Transfer(_from, _to, _value);
365     return true;
366   }
367   
368   function approve(address _spender, uint256 _value) public returns (bool) {
369 
370     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
371 
372     allowed[msg.sender][_spender] = _value;
373     Approval(msg.sender, _spender, _value);
374     return true;
375   }  
376 
377   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
378     return allowed[_owner][_spender];
379   }
380 
381 }