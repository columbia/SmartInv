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
72     address ethFundMain = 0x649BbCF5625E78f8A1dE1AE07d9D5E3E0fDCa932; // Suchapp's cold wallet
73     mapping (address => bool) public whitelisted;
74     uint256 public Numtokens;
75     uint256 public bonustokn;
76     uint256 public ethreceived;
77     uint constant public minimumInvestment = 1 ether; // 1 ether is minimum minimumInvestment
78     uint bonusCalculationFactor;
79     uint public bonus;
80     uint x ;
81     
82      enum Stages {
83         NOTSTARTED,
84         PREICO,
85         ICO,
86         ENDED
87     }
88     Stages public stage;
89     
90     modifier atStage(Stages _stage) {
91         if (stage != _stage)
92             // Contract not in expected state
93             revert();
94         _;
95     }
96     
97      modifier onlyOwner() {
98         if (msg.sender != owner) {
99             revert();
100         }
101         _;
102     }
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
114         require(stage != Stages.ENDED && msg.value >= minimumInvestment);
115         require(!stopped && msg.sender != owner);
116         require(whitelisted[msg.sender]);
117     if( stage == Stages.PREICO && now <= pre_enddate )
118         {  
119             no_of_tokens =(msg.value).mul(_price_tokn);
120             ethreceived = ethreceived.add(msg.value);
121             bonus= bonuscalpre();
122             bonus_token = ((no_of_tokens).mul(bonus)).div(100);  // bonus calculation
123             total_token = no_of_tokens + bonus_token;
124             Numtokens= Numtokens.add(no_of_tokens);
125              bonustokn= bonustokn.add(bonus_token);
126             transferTokens(msg.sender,total_token);
127          }
128          
129          
130     else
131     if(stage == Stages.ICO && now <= ico_enddate )
132         {
133              
134             no_of_tokens =((msg.value).mul(_price_tokn));
135             ethreceived = ethreceived.add(msg.value);
136           bonus= bonuscalico(msg.value);
137             bonus_token = ((no_of_tokens).mul(bonus)).div(100);  // bonus calculation
138             total_token = no_of_tokens + bonus_token;
139            Numtokens= Numtokens.add(no_of_tokens);
140              bonustokn= bonustokn.add(bonus_token);
141             transferTokens(msg.sender,total_token);
142         
143         }
144     else {
145             revert();
146         }
147        
148     }
149 
150     
151     //bonuc calculation for preico on per day basis
152      function bonuscalpre() private returns (uint256 cp)
153         {
154           uint bon = 30;
155              bonusCalculationFactor = (block.timestamp.sub(pre_startdate)).div(86400); //time period in seconds
156             if(bonusCalculationFactor == 0)
157             {
158                 bon = 30;
159             }
160           else if(bonusCalculationFactor >= 15)
161             {
162               bon = 2;
163             }
164             else{
165                  bon -= bonusCalculationFactor* 2;
166             }
167             return bon;
168           
169         }
170         //bonus calculation for ICO on purchase basis
171   function bonuscalico(uint256 y) private returns (uint256 cp){
172      x = y/(10**18);
173      uint bon;
174       if (x>=2 && x <5){
175           bon = 1;
176       }
177       else  if (x>=5 && x <15){
178           bon = 2;
179       }
180       else  if (x>=15 && x <25){
181           bon = 3;
182       }
183       else  if (x>=25 && x <40){
184           bon = 4;
185       }
186       else  if (x>=40 && x <60){
187           bon = 5;
188       }
189       else  if (x>=60 && x <70){
190           bon = 6;
191       }
192       else  if (x>=70 && x <80){
193           bon = 7;
194       }
195       else  if (x>=80 && x <90){
196           bon = 8;
197       }
198      else  if (x>=90 && x <100){
199           bon = 9;
200       }
201       else  if (x>=100){
202           bon = 10;
203       }
204       else{
205       bon = 0;
206       }
207       
208       return bon;
209   }
210     
211      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
212       {
213           stage = Stages.PREICO;
214           stopped = false;
215           maxCap_PRE = 350000000 * 10 ** 18;  // 350 million
216           balances[address(this)] = maxCap_PRE;
217           pre_startdate = now;
218           pre_enddate = now + 20 days; //time for preICO
219           Transfer(0, address(this), balances[address(this)]);
220           }
221     
222     
223       function start_ICO() public onlyOwner atStage(Stages.PREICO)
224       {
225           stage = Stages.ICO;
226           stopped = false;
227           maxCap_ICO = 900000000 * 10 **18;   // 900 million
228           balances[address(this)] = balances[address(this)].add(maxCap_ICO);
229          ico_startdate = now;
230          ico_enddate = now + 25 days; //time for ICO
231           Transfer(0, address(this), balances[address(this)]);
232           }
233           
234    
235     // called by the owner, pause ICO
236     function StopICO() external onlyOwner  {
237         stopped = true;
238       
239     }
240 
241     // called by the owner , resumes ICO
242     function releaseICO() external onlyOwner
243     {
244         stopped = false;
245       
246     }
247     
248        
249     function setWhiteListAddresses(address _investor) external onlyOwner{
250            whitelisted[_investor] = true;
251        }
252        
253       
254      function end_ICO() external onlyOwner atStage(Stages.ICO)
255      {
256          require(now > ico_enddate);
257          stage = Stages.ENDED;
258          icoRunningStatus= false;
259         _totalsupply = (_totalsupply).sub(balances[address(this)]);
260          balances[address(this)] = 0;
261          Transfer(address(this), 0 , balances[address(this)]);
262          
263      }
264       // This function can be used by owner in emergency to update running status parameter
265         function fixSpecications(bool RunningStatus ) external onlyOwner
266         {
267            icoRunningStatus = RunningStatus;
268         }
269      
270     // what is the total supply of the ech tokens
271      function totalSupply() public view returns (uint256 total_Supply) {
272          total_Supply = _totalsupply;
273      }
274     
275     // What is the balance of a particular account?
276      function balanceOf(address _owner)public view returns (uint256 balance) {
277          return balances[_owner];
278      }
279     
280     // Send _value amount of tokens from address _from to address _to
281      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
282      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
283      // fees in sub-currencies; the command should fail unless the _from account has
284      // deliberately authorized the sender of the message via some mechanism; we propose
285      // these standardized APIs for approval:
286      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
287      require( _to != 0x0);
288      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
289      balances[_from] = (balances[_from]).sub(_amount);
290      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
291      balances[_to] = (balances[_to]).add(_amount);
292      Transfer(_from, _to, _amount);
293      return true;
294          }
295     
296    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
297      // If this function is called again it overwrites the current allowance with _value.
298      function approve(address _spender, uint256 _amount)public returns (bool success) {
299          require(!icoRunningStatus);
300          require( _spender != 0x0);
301          allowed[msg.sender][_spender] = _amount;
302          Approval(msg.sender, _spender, _amount);
303          return true;
304      }
305   
306      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
307          require( _owner != 0x0 && _spender !=0x0);
308          return allowed[_owner][_spender];
309    }
310     // Transfer the balance from owner's account to another account
311      function transfer(address _to, uint256 _amount) public returns (bool success) {
312          if(icoRunningStatus && msg.sender == owner)
313          {
314             require(balances[owner] >= _amount && _amount >= 0 && balances[_to] + _amount > balances[_to]);
315             balances[owner] = (balances[owner]).sub(_amount);
316             balances[_to] = (balances[_to]).add(_amount);
317             Transfer(owner, _to, _amount);
318             return true;
319          }
320        
321          else if(!icoRunningStatus)
322          {
323             require(balances[msg.sender] >= _amount && _amount >= 0 && balances[_to] + _amount > balances[_to]);
324             balances[msg.sender] = (balances[msg.sender]).sub(_amount);
325             balances[_to] = (balances[_to]).add(_amount);
326             Transfer(msg.sender, _to, _amount);
327             return true;
328          } 
329          
330          else 
331          revert();
332      }
333   
334 
335           // Transfer the balance from owner's account to another account
336     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
337         require( _to != 0x0);       
338         require(balances[address(this)] >= _amount && _amount > 0);
339         balances[address(this)] = (balances[address(this)]).sub(_amount);
340         balances[_to] = (balances[_to]).add(_amount);
341         Transfer(address(this), _to, _amount);
342         return true;
343         }
344     
345  
346     	//In case the ownership needs to be transferred
347 	function transferOwnership(address newOwner)public onlyOwner
348 	{
349 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
350 	    balances[owner] = 0;
351 	    owner = newOwner;
352 	}
353 
354     
355     function drain() external onlyOwner {
356         ethFundMain.transfer(this.balance);
357     }
358     
359 }