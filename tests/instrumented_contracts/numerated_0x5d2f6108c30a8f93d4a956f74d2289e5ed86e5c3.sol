1 pragma solidity 0.4.21;
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
48 contract TANDER is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "TANDER";
52 
53     // Symbol of token
54     string public constant symbol = "TDR";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 10000000000000 *10 ** 18; // 10 TRILLION TDR
57     address public owner;
58     uint256 constant public _price_tokn = 1000 ; 
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
72     address ethFundMain = 0x0070570A1D3F5CcaD6A74B3364D13C475BF9bD6a; // Owner's Account
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
104     function TANDER() public
105     {
106         owner = msg.sender;
107         balances[owner] = 2000000000000 *10 ** 18;  // 2 TRILLION TDR FOR RESERVE
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
135             total_token = no_of_tokens + bonus_token;
136            Numtokens= Numtokens.add(no_of_tokens);
137              bonustokn= bonustokn.add(bonus_token);
138             transferTokens(msg.sender,total_token);
139         
140         }
141     else {
142             revert();
143         }
144        
145     }
146 
147     
148     //bonus calculation for preico on per day basis
149      function bonuscalpre() private returns (uint256 cp)
150         {
151           uint bon = 8;
152              bonusCalculationFactor = (block.timestamp.sub(pre_startdate)).div(604800); //time period in seconds
153             if(bonusCalculationFactor == 0)
154             {
155                 bon = 8;
156             }
157          
158             else{
159                  bon -= bonusCalculationFactor* 8;
160             }
161             return bon;
162           
163         }
164         
165  
166   
167      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
168       {
169           stage = Stages.PREICO;
170           stopped = false;
171           maxCap_PRE = 3000000000000 * 10 ** 18;  // 3 TRILLION
172           balances[address(this)] = maxCap_PRE;
173           pre_startdate = now;
174           pre_enddate = now + 90 days; //time for preICO
175           Transfer(0, address(this), balances[address(this)]);
176           }
177     
178     
179       function start_ICO() public onlyOwner atStage(Stages.PREICO)
180       {
181           stage = Stages.ICO;
182           stopped = false;
183           maxCap_ICO = 5000000000000 * 10 **18;   // 5 TRILLION
184           balances[address(this)] = balances[address(this)].add(maxCap_ICO);
185          ico_startdate = now;
186          ico_enddate = now + 180 days; //time for ICO
187           Transfer(0, address(this), balances[address(this)]);
188           }
189           
190    
191     // called by the owner, pause ICO
192     function StopICO() external onlyOwner  {
193         stopped = true;
194       
195     }
196 
197     // called by the owner , resumes ICO
198     function releaseICO() external onlyOwner
199     {
200         stopped = false;
201       
202     }
203     
204      function end_ICO() external onlyOwner atStage(Stages.ICO)
205      {
206          require(now > ico_enddate);
207          stage = Stages.ENDED;
208          icoRunningStatus= false;
209         _totalsupply = (_totalsupply).sub(balances[address(this)]);
210          balances[address(this)] = 0;
211          Transfer(address(this), 0 , balances[address(this)]);
212          
213      }
214       // This function can be used by owner in emergency to update running status parameter
215         function fixSpecications(bool RunningStatus ) external onlyOwner
216         {
217            icoRunningStatus = RunningStatus;
218         }
219      
220     // what is the total supply of the ech tokens
221      function totalSupply() public view returns (uint256 total_Supply) {
222          total_Supply = _totalsupply;
223      }
224     
225     // What is the balance of a particular account?
226      function balanceOf(address _owner)public view returns (uint256 balance) {
227          return balances[_owner];
228      }
229     
230     // Send _value amount of tokens from address _from to address _to
231      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
232      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
233      // fees in sub-currencies; the command should fail unless the _from account has
234      // deliberately authorized the sender of the message via some mechanism; we propose
235      // these standardized APIs for approval:
236      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
237      require( _to != 0x0);
238      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
239      balances[_from] = (balances[_from]).sub(_amount);
240      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
241      balances[_to] = (balances[_to]).add(_amount);
242      Transfer(_from, _to, _amount);
243      return true;
244          }
245     
246    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
247      // If this function is called again it overwrites the current allowance with _value.
248      function approve(address _spender, uint256 _amount)public returns (bool success) {
249          require(!icoRunningStatus);
250          require( _spender != 0x0);
251          allowed[msg.sender][_spender] = _amount;
252          Approval(msg.sender, _spender, _amount);
253          return true;
254      }
255   
256      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
257          require( _owner != 0x0 && _spender !=0x0);
258          return allowed[_owner][_spender];
259    }
260     // Transfer the balance from owner's account to another account
261      function transfer(address _to, uint256 _amount) public returns (bool success) {
262          if(icoRunningStatus && msg.sender == owner)
263          {
264             require(balances[owner] >= _amount && _amount >= 0 && balances[_to] + _amount > balances[_to]);
265             balances[owner] = (balances[owner]).sub(_amount);
266             balances[_to] = (balances[_to]).add(_amount);
267             Transfer(owner, _to, _amount);
268             return true;
269          }
270        
271          else if(!icoRunningStatus)
272          {
273             require(balances[msg.sender] >= _amount && _amount >= 0 && balances[_to] + _amount > balances[_to]);
274             balances[msg.sender] = (balances[msg.sender]).sub(_amount);
275             balances[_to] = (balances[_to]).add(_amount);
276             Transfer(msg.sender, _to, _amount);
277             return true;
278          } 
279          
280          else 
281          revert();
282      }
283   
284 
285           // Transfer the balance from owner's account to another account
286     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
287         require( _to != 0x0);       
288         require(balances[address(this)] >= _amount && _amount > 0);
289         balances[address(this)] = (balances[address(this)]).sub(_amount);
290         balances[_to] = (balances[_to]).add(_amount);
291         Transfer(address(this), _to, _amount);
292         return true;
293         }
294 
295         function transferby(address _to,uint256 _amount) external onlyOwner returns(bool success) {
296         require( _to != 0x0); 
297         require(balances[address(this)] >= _amount && _amount > 0);
298         balances[address(this)] = (balances[address(this)]).sub(_amount);
299         balances[_to] = (balances[_to]).add(_amount);
300         Transfer(address(this), _to, _amount);
301         return true;
302     }
303     
304  
305     	//In case the ownership needs to be transferred
306 	function transferOwnership(address newOwner)public onlyOwner
307 	{
308 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
309 	    balances[owner] = 0;
310 	    owner = newOwner;
311 	}
312 
313     
314     function drain() external onlyOwner {
315         ethFundMain.transfer(this.balance);
316     }
317     
318 }