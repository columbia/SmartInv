1 pragma solidity 0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address who)public view returns (uint256);
39   function allowance(address owner, address spender)public view returns (uint);
40   function transferFrom(address from, address to, uint value)public returns (bool ok);
41   function approve(address spender, uint value)public returns (bool ok);
42   function transfer(address to, uint value)public returns (bool ok);
43   event Transfer(address indexed from, address indexed to, uint value);
44   event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract SPCoin is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "SP Coin";
52 
53     // Symbol of token
54     string public constant symbol = "SPS";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 2500000000 *10 ** 18; // 2.5 Billion SPS Coins
57     address public owner;
58     uint256 constant public _price_tokn = 20000 ; 
59     uint256 no_of_tokens;
60     uint256 bonus_token;
61     uint256 total_token;
62     bool stopped = false;
63     uint256 public pre_startdate;
64     uint256 public ico_startdate;
65     uint256 pre_enddate;
66     uint256 ico_enddate;
67     uint256 maxCap_PRE;
68     uint256 maxCap_ICO;
69     bool public icoRunningStatus = true;
70     mapping(address => uint) balances;
71     mapping(address => mapping(address => uint)) allowed;
72     address ethFundMain = 0x649BbCF5625E78f8A1dE1AE07d9D5E3E0fDCa932; 
73     uint256 public Numtokens;
74     uint256 public bonustokn;
75     uint256 public ethreceived;
76     uint bonusCalculationFactor;
77     uint public bonus;
78     uint x ;
79  
80     
81      enum Stages {
82         NOTSTARTED,
83         PREICO,
84         ICO,
85         ENDED
86     }
87     Stages public stage;
88     
89     modifier atStage(Stages _stage) {
90         if (stage != _stage)
91             // Contract not in expected state
92             revert();
93         _;
94     }
95     
96      modifier onlyOwner() {
97         if (msg.sender != owner) {
98             revert();
99         }
100         _;
101     }
102   
103    
104     function SPCoin() public
105     {
106         owner = msg.sender;
107         balances[owner] = 1250000000 *10 ** 18;  // 1.25 billion given to owner
108         stage = Stages.NOTSTARTED;
109         Transfer(0, owner, balances[owner]);
110     }
111   
112     function () public payable 
113     {
114         require(stage != Stages.ENDED);
115         require(!stopped && msg.sender != owner);
116     if( stage == Stages.PREICO && now <= pre_enddate )
117         {  
118             no_of_tokens =(msg.value).mul(_price_tokn);
119             ethreceived = ethreceived.add(msg.value);
120             bonus= bonuscalpre();
121             bonus_token = ((no_of_tokens).mul(bonus)).div(100);  // bonus calculation
122             total_token = no_of_tokens + bonus_token;
123             Numtokens= Numtokens.add(no_of_tokens);
124              bonustokn= bonustokn.add(bonus_token);
125             transferTokens(msg.sender,total_token);
126          }
127          
128          
129     else
130     if(stage == Stages.ICO && now <= ico_enddate )
131         {
132              
133             no_of_tokens =((msg.value).mul(_price_tokn));
134             ethreceived = ethreceived.add(msg.value);
135           bonus= bonuscalico(msg.value);
136             bonus_token = ((no_of_tokens).mul(bonus)).div(100);  // bonus calculation
137             total_token = no_of_tokens + bonus_token;
138            Numtokens= Numtokens.add(no_of_tokens);
139              bonustokn= bonustokn.add(bonus_token);
140             transferTokens(msg.sender,total_token);
141         
142         }
143     else {
144             revert();
145         }
146        
147     }
148 
149     
150     //bonuc calculation for preico on per day basis
151      function bonuscalpre() private returns (uint256 cp)
152         {
153           uint bon = 30;
154              bonusCalculationFactor = (block.timestamp.sub(pre_startdate)).div(86400); //time period in seconds
155             if(bonusCalculationFactor == 0)
156             {
157                 bon = 30;
158             }
159           else if(bonusCalculationFactor >= 15)
160             {
161               bon = 2;
162             }
163             else{
164                  bon -= bonusCalculationFactor* 2;
165             }
166             return bon;
167           
168         }
169         //bonus calculation for ICO on purchase basis
170   function bonuscalico(uint256 y) private returns (uint256 cp){
171      x = y/(10**18);
172      uint bon;
173       if (x>=2 && x <5){
174           bon = 1;
175       }
176       else  if (x>=5 && x <15){
177           bon = 2;
178       }
179       else  if (x>=15 && x <25){
180           bon = 3;
181       }
182       else  if (x>=25 && x <40){
183           bon = 4;
184       }
185       else  if (x>=40 && x <60){
186           bon = 5;
187       }
188       else  if (x>=60 && x <70){
189           bon = 6;
190       }
191       else  if (x>=70 && x <80){
192           bon = 7;
193       }
194       else  if (x>=80 && x <90){
195           bon = 8;
196       }
197      else  if (x>=90 && x <100){
198           bon = 9;
199       }
200       else  if (x>=100){
201           bon = 10;
202       }
203       else{
204       bon = 0;
205       }
206       
207       return bon;
208   }
209   
210      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
211       {
212           stage = Stages.PREICO;
213           stopped = false;
214           maxCap_PRE = 350000000 * 10 ** 18;  // 350 million
215           balances[address(this)] = maxCap_PRE;
216           pre_startdate = now;
217           pre_enddate = now + 20 days; //time for preICO
218           Transfer(0, address(this), balances[address(this)]);
219           }
220     
221     
222       function start_ICO() public onlyOwner atStage(Stages.PREICO)
223       {
224           stage = Stages.ICO;
225           stopped = false;
226           maxCap_ICO = 900000000 * 10 **18;   // 900 million
227           balances[address(this)] = balances[address(this)].add(maxCap_ICO);
228          ico_startdate = now;
229          ico_enddate = now + 25 days; //time for ICO
230           Transfer(0, address(this), balances[address(this)]);
231           }
232           
233    
234     // called by the owner, pause ICO
235     function StopICO() external onlyOwner  {
236         stopped = true;
237       
238     }
239 
240     // called by the owner , resumes ICO
241     function releaseICO() external onlyOwner
242     {
243         stopped = false;
244       
245     }
246     
247      function end_ICO() external onlyOwner atStage(Stages.ICO)
248      {
249          require(now > ico_enddate);
250          stage = Stages.ENDED;
251          icoRunningStatus= false;
252         _totalsupply = (_totalsupply).sub(balances[address(this)]);
253          balances[address(this)] = 0;
254          Transfer(address(this), 0 , balances[address(this)]);
255          
256      }
257       // This function can be used by owner in emergency to update running status parameter
258         function fixSpecications(bool RunningStatus ) external onlyOwner
259         {
260            icoRunningStatus = RunningStatus;
261         }
262      
263     // what is the total supply of the ech tokens
264      function totalSupply() public view returns (uint256 total_Supply) {
265          total_Supply = _totalsupply;
266      }
267     
268     // What is the balance of a particular account?
269      function balanceOf(address _owner)public view returns (uint256 balance) {
270          return balances[_owner];
271      }
272     
273     // Send _value amount of tokens from address _from to address _to
274      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
275      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
276      // fees in sub-currencies; the command should fail unless the _from account has
277      // deliberately authorized the sender of the message via some mechanism; we propose
278      // these standardized APIs for approval:
279      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
280      require( _to != 0x0);
281      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
282      balances[_from] = (balances[_from]).sub(_amount);
283      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
284      balances[_to] = (balances[_to]).add(_amount);
285      Transfer(_from, _to, _amount);
286      return true;
287          }
288     
289    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
290      // If this function is called again it overwrites the current allowance with _value.
291      function approve(address _spender, uint256 _amount)public returns (bool success) {
292          require(!icoRunningStatus);
293          require( _spender != 0x0);
294          allowed[msg.sender][_spender] = _amount;
295          Approval(msg.sender, _spender, _amount);
296          return true;
297      }
298   
299      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
300          require( _owner != 0x0 && _spender !=0x0);
301          return allowed[_owner][_spender];
302    }
303     // Transfer the balance from owner's account to another account
304      function transfer(address _to, uint256 _amount) public returns (bool success) {
305          if(icoRunningStatus && msg.sender == owner)
306          {
307             require(balances[owner] >= _amount && _amount >= 0 && balances[_to] + _amount > balances[_to]);
308             balances[owner] = (balances[owner]).sub(_amount);
309             balances[_to] = (balances[_to]).add(_amount);
310             Transfer(owner, _to, _amount);
311             return true;
312          }
313        
314          else if(!icoRunningStatus)
315          {
316             require(balances[msg.sender] >= _amount && _amount >= 0 && balances[_to] + _amount > balances[_to]);
317             balances[msg.sender] = (balances[msg.sender]).sub(_amount);
318             balances[_to] = (balances[_to]).add(_amount);
319             Transfer(msg.sender, _to, _amount);
320             return true;
321          } 
322          
323          else 
324          revert();
325      }
326   
327 
328           // Transfer the balance from owner's account to another account
329     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
330         require( _to != 0x0);       
331         require(balances[address(this)] >= _amount && _amount > 0);
332         balances[address(this)] = (balances[address(this)]).sub(_amount);
333         balances[_to] = (balances[_to]).add(_amount);
334         Transfer(address(this), _to, _amount);
335         return true;
336         }
337 
338         function transferby(address _to,uint256 _amount) external onlyOwner returns(bool success) {
339         require( _to != 0x0); 
340         require(balances[address(this)] >= _amount && _amount > 0);
341         balances[address(this)] = (balances[address(this)]).sub(_amount);
342         balances[_to] = (balances[_to]).add(_amount);
343         Transfer(address(this), _to, _amount);
344         return true;
345     }
346     
347  
348     	//In case the ownership needs to be transferred
349 	function transferOwnership(address newOwner)public onlyOwner
350 	{
351 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
352 	    balances[owner] = 0;
353 	    owner = newOwner;
354 	}
355 
356     
357     function drain() external onlyOwner {
358         ethFundMain.transfer(this.balance);
359     }
360     
361 }