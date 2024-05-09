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
48 contract ZEROCoin is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "ZEROCoin";
52 
53     // Symbol of token
54     string public constant symbol = "ZERO";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 1295000000 * 10 ** 18; // 1.295 billion total supply // muliplies dues to decimal precision
57     address public owner;                    // Owner of this contract
58     uint256 public _price_tokn_PRE = 38000;  // 1 Ether = 38000 coins
59     uint256 public _price_tokn_ICO= 24000;   // 1 Ether = 24000 coins
60     uint256 no_of_tokens;
61     uint256 bonus_token;
62     uint256 total_token;
63     bool stopped = false;
64     uint256 public pre_startdate;
65     uint256 public ico1_startdate;
66     uint256 ico_first;
67     uint256 ico_second;
68     uint256 ico_third;
69     uint256 ico_fourth;
70     uint256 pre_enddate;
71   
72     uint256 public eth_received; // total ether received in the contract
73     uint256 maxCap_public = 777000000 * 10 **18;  //  777 million in Public Sale
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76     /** Who are our advisors (iterable) */
77     mapping (address => bool) private Advisors;
78     
79      /** How many advisors we have now */
80     uint public advisorCount;
81 
82     enum Stages {
83         NOTSTARTED,
84         PREICO,
85         ICO,
86         PAUSED,
87         ENDED
88     }
89     Stages public stage;
90     
91     modifier atStage(Stages _stage) {
92         if (stage != _stage)
93             // Contract not in expected state
94             revert();
95         _;
96     }
97     
98      modifier onlyOwner() {
99         if (msg.sender != owner) {
100             revert();
101         }
102         _;
103     }
104 
105     function ZEROCoin() public
106     {
107         owner = msg.sender;
108         balances[owner] = 518000000 * 10 **18; // 518 million to owner
109         stage = Stages.NOTSTARTED;
110         Transfer(0, owner, balances[owner]);
111     }
112   
113     function () public payable 
114     {
115         require(stage != Stages.ENDED);
116         require(!stopped && msg.sender != owner);
117             if( stage == Stages.PREICO && now <= pre_enddate )
118             { 
119                 require (eth_received <= 1500 ether);
120               eth_received = (eth_received).add(msg.value);
121                 no_of_tokens =((msg.value).mul(_price_tokn_PRE));
122                 bonus_token = ((no_of_tokens).mul(58)).div(100); // 58 percent bonus token
123                 total_token = no_of_tokens + bonus_token;
124                 transferTokens(msg.sender,total_token);
125                }
126                
127              else if(stage == Stages.ICO && now <= ico_fourth ){
128                     
129                 if( now < ico_first )
130             {
131               no_of_tokens =(msg.value).mul(_price_tokn_ICO);
132                 bonus_token = ((no_of_tokens).mul(15)).div(100); // 15% bonus
133                 total_token = no_of_tokens + bonus_token;
134                 transferTokens(msg.sender,total_token);
135                 
136                 
137             }   
138             
139               else if(now >= ico_first && now < ico_second)
140             {
141                 
142                 
143                   no_of_tokens =(msg.value).mul(_price_tokn_ICO);
144                 bonus_token = ((no_of_tokens).mul(10)).div(100); // 10% bonus
145                 total_token = no_of_tokens + bonus_token;
146                 transferTokens(msg.sender,total_token);
147                 
148                 
149             }
150              else if(now >= ico_second && now < ico_third)
151             {
152                 
153                    no_of_tokens =(msg.value).mul(_price_tokn_ICO);
154                 bonus_token = ((no_of_tokens).mul(5)).div(100); // 5% bonus
155                 total_token = no_of_tokens + bonus_token;
156                 transferTokens(msg.sender,total_token);
157                 
158                 
159             }
160             
161              else if(now >= ico_third && now < ico_fourth)
162             {
163                 
164                    
165              no_of_tokens =(msg.value).mul(_price_tokn_ICO);      // 0% Bonus
166                 total_token = no_of_tokens;
167                 transferTokens(msg.sender,total_token);
168                 
169                 
170             }
171              }
172         else
173         {
174             revert();
175         }
176     
177     }
178      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
179       {
180           stage = Stages.PREICO;
181           stopped = false;
182            balances[address(this)] =  maxCap_public;
183           pre_startdate = now;
184           pre_enddate = now + 16 days;
185           Transfer(0, address(this), balances[address(this)]);
186           }
187       
188       function start_ICO() public onlyOwner atStage(Stages.PREICO)
189       {
190           require(now > pre_enddate || eth_received >= 1500 ether);
191           stage = Stages.ICO;
192           stopped = false;
193           ico1_startdate = now;
194            ico_first = now + 15 days;
195           ico_second = ico_first + 15 days;
196           ico_third = ico_second + 15 days;
197           ico_fourth = ico_third + 15 days;
198           Transfer(0, address(this), balances[address(this)]);
199       }
200     
201     // called by the owner, pause ICO
202     function PauseICO() external onlyOwner
203     {
204         stopped = true;
205        }
206 
207     // called by the owner , resumes ICO
208     function ResumeICO() external onlyOwner
209     {
210         stopped = false;
211       }
212    
213      
214      
215      function end_ICO() external onlyOwner atStage(Stages.ICO)
216      {
217          require(now > ico_fourth);
218          stage = Stages.ENDED;
219          _totalsupply = (_totalsupply).sub(balances[address(this)]);
220          balances[address(this)] = 0;
221          Transfer(address(this), 0 , balances[address(this)]);
222          
223      }
224 
225     // what is the total supply of the ech tokens
226      function totalSupply() public view returns (uint256 total_Supply) {
227          total_Supply = _totalsupply;
228      }
229     
230     // What is the balance of a particular account?
231      function balanceOf(address _owner)public view returns (uint256 balance) {
232          return balances[_owner];
233      }
234     
235     // Send _value amount of tokens from address _from to address _to
236      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
237      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
238      // fees in sub-currencies; the command should fail unless the _from account has
239      // deliberately authorized the sender of the message via some mechanism; we propose
240      // these standardized APIs for approval:
241      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
242      require( _to != 0x0);
243      require(stage == Stages.ENDED);
244      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
245      
246      if(isAdvisor(_to)) {
247          require(now > ico1_startdate + 150 days);
248      }
249      
250      balances[_from] = (balances[_from]).sub(_amount);
251      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
252      balances[_to] = (balances[_to]).add(_amount);
253      Transfer(_from, _to, _amount);
254      return true;
255          }
256     
257     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
258      // If this function is called again it overwrites the current allowance with _value.
259      function approve(address _spender, uint256 _amount)public returns (bool success) {
260          require( _spender != 0x0);
261          allowed[msg.sender][_spender] = _amount;
262          Approval(msg.sender, _spender, _amount);
263          return true;
264      }
265   
266      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
267          require( _owner != 0x0 && _spender !=0x0);
268          return allowed[_owner][_spender];
269     }
270 
271      // Transfer the balance from owner's account to another account
272      function transfer(address _to, uint256 _amount)public returns (bool success) {
273         require( _to != 0x0);
274         require(stage == Stages.ENDED);
275         require(balances[msg.sender] >= _amount && _amount >= 0);
276         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
277         balances[_to] = (balances[_to]).add(_amount);
278         Transfer(msg.sender, _to, _amount);
279              return true;
280          }
281     
282     // Transfer the balance from owner's account to another account
283     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
284         require( _to != 0x0);       
285         require(balances[address(this)] >= _amount && _amount > 0);
286         balances[address(this)] = (balances[address(this)]).sub(_amount);
287         balances[_to] = (balances[_to]).add(_amount);
288         Transfer(address(this), _to, _amount);
289         return true;
290     }
291  
292     // Transfer the balance from owner's account to advisor's account
293     function transferToAdvisors(address _to, uint256 _amount) private returns(bool success) {
294         require( _to != 0x0);       
295         require(balances[address(this)] >= _amount && _amount > 0);
296         balances[address(this)] = (balances[address(this)]).sub(_amount);
297         
298         // if this is a new advisor
299         if(!isAdvisor(_to)) {
300           addAdvisor(_to);
301           advisorCount++;
302         }
303         
304         balances[_to] = (balances[_to]).add(_amount);
305         Transfer(address(this), _to, _amount);
306         return true;
307     }
308  
309     function addAdvisor(address _advisor) public {
310         Advisors[_advisor]=true;
311     }
312 
313     function isAdvisor(address _advisor) public returns(bool ){
314         return Advisors[_advisor];
315     }
316     
317     function drain() external onlyOwner {
318         owner.transfer(this.balance);
319     }
320     
321 }