1 pragma solidity 0.4.19;
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
48 contract OTPPAY is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "OTPPAY";
52 
53     // Symbol of token
54     string public constant symbol = "OTP";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 1000000000 * 10 ** 18; // 1 billion total supply // muliplies dues to decimal precision
57     address public owner;                    // Owner of this contract
58     uint256 public _price_tokn_PRE = 16000;  // 1 Ether = 16000 coins
59     uint256 public _price_tokn_ICO1;
60     uint256 public _price_tokn_ICO2;
61     uint256 no_of_tokens;
62     uint256 bonus_token;
63     uint256 total_token;
64     uint256 refferaltoken;
65     bool stopped = false;
66     uint256 public pre_startdate;
67     uint256 public ico1_startdate;
68     uint256 public ico2_startdate;
69     uint256 pre_enddate;
70     uint256 ico1_enddate;
71     uint256 ico2_enddate;
72     uint256 maxCap_PRE;
73     uint256 maxCap_ICO1;
74     uint256 maxCap_ICO2;
75     address central_account;
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79     
80      enum Stages {
81         NOTSTARTED,
82         PREICO,
83         ICO1,
84         ICO2,
85         PAUSED,
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
103     modifier onlycentralAccount {
104         require(msg.sender == central_account);
105         _;
106     }
107 
108     function OTPPAY() public
109     {
110         owner = msg.sender;
111         balances[owner] = 319000000 * 10 **18; // 319 million to owner
112         stage = Stages.NOTSTARTED;
113         Transfer(0, owner, balances[owner]);
114     }
115   
116     function () public payable 
117     {
118         require(stage != Stages.ENDED);
119         require(!stopped && msg.sender != owner);
120             if( stage == Stages.PREICO && now <= pre_enddate )
121             { 
122                 no_of_tokens =((msg.value).mul(_price_tokn_PRE));
123                 bonus_token = ((no_of_tokens).mul(20)).div(100); // 20 percent bonus token
124                 total_token = no_of_tokens + bonus_token;
125                 transferTokens(msg.sender,total_token);
126                }
127                
128             
129             else if(stage == Stages.ICO1 && now <= ico1_enddate )
130             {
131              
132                no_of_tokens =((msg.value).mul(_price_tokn_ICO1));
133                 bonus_token = ((no_of_tokens).mul(15)).div(100); // 15 percent bonus token
134                 total_token = no_of_tokens + bonus_token;
135                 transferTokens(msg.sender,total_token);
136             }
137             
138             else if(stage == Stages.ICO2 && now <= ico2_enddate)
139             {
140                no_of_tokens =((msg.value).mul(_price_tokn_ICO2));
141                 bonus_token = ((no_of_tokens).mul(10)).div(100); // 10 percent bonus token
142                 total_token = no_of_tokens + bonus_token;
143                 transferTokens(msg.sender,total_token);
144             }
145         else
146         {
147             revert();
148         }
149     }
150      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
151       {
152           stage = Stages.PREICO;
153           stopped = false;
154           maxCap_PRE = 72000000 * 10 **18;  // 60(pre) + 12(bonus) = 72 million
155            balances[address(this)] = maxCap_PRE;
156           pre_startdate = now;
157           pre_enddate = now + 30 days;
158           Transfer(0, address(this), balances[address(this)]);
159           }
160       
161       function start_ICO1(uint256 price_tokn_ico1) public onlyOwner atStage(Stages.PREICO)
162       {
163           require(price_tokn_ico1 !=0);
164           require(now > pre_enddate || balances[address(this)] == 0);
165           stage = Stages.ICO1;
166           stopped = false;
167           _price_tokn_ICO1 = price_tokn_ico1;
168           maxCap_ICO1 = 345000000 * 10 **18; // 345 million
169           balances[address(this)] = (balances[address(this)]).add(maxCap_ICO1) ;
170           ico1_startdate = now;
171           ico1_enddate = now + 30 days;
172           Transfer(0, address(this), balances[address(this)]);
173       }
174     
175     function start_ICO2(uint256 price_tokn_ico2) public onlyOwner atStage(Stages.ICO1)
176       {
177           require(price_tokn_ico2 !=0);
178           require(now > ico1_enddate || balances[address(this)] == 0);
179           stage = Stages.ICO2;
180           stopped = false;
181           _price_tokn_ICO2 = price_tokn_ico2;
182           maxCap_ICO2 = 264000000 * 10 **18; // 264 million
183           balances[address(this)] = (balances[address(this)]).add(maxCap_ICO2) ;
184           ico2_startdate = now;     
185           ico2_enddate = now + 30 days;
186           Transfer(0, address(this), balances[address(this)]);
187           
188       }
189     
190      
191     // called by the owner, pause ICO
192     function PauseICO() external onlyOwner
193     {
194         stopped = true;
195        }
196 
197     // called by the owner , resumes ICO
198     function ResumeICO() external onlyOwner
199     {
200         stopped = false;
201       }
202    
203      
204      
205       function end_ICO(uint256 _refferaltoken) external onlyOwner atStage(Stages.ICO2)
206      {
207          require(_refferaltoken !=0);
208          require(now > ico2_enddate || balances[address(this)] == 0);
209          stage = Stages.ENDED;
210          refferaltoken = _refferaltoken;
211          balances[address(this)] = (balances[address(this)]).sub(refferaltoken * 10 **18);
212          balances[owner] = (balances[owner]).add(refferaltoken * 10 **18);
213          _totalsupply = (_totalsupply).sub(balances[address(this)]);
214          balances[address(this)] = 0;
215          Transfer(address(this), 0 , balances[address(this)]);
216          Transfer(address(this), owner, refferaltoken);
217          
218      }
219      
220      function set_centralAccount(address central_Acccount) external onlyOwner
221     {
222         central_account = central_Acccount;
223     }
224 
225 
226 
227     // what is the total supply of the ech tokens
228      function totalSupply() public view returns (uint256 total_Supply) {
229          total_Supply = _totalsupply;
230      }
231     
232     // What is the balance of a particular account?
233      function balanceOf(address _owner)public view returns (uint256 balance) {
234          return balances[_owner];
235      }
236     
237     // Send _value amount of tokens from address _from to address _to
238      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
239      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
240      // fees in sub-currencies; the command should fail unless the _from account has
241      // deliberately authorized the sender of the message via some mechanism; we propose
242      // these standardized APIs for approval:
243      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
244      require( _to != 0x0);
245      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
246      balances[_from] = (balances[_from]).sub(_amount);
247      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
248      balances[_to] = (balances[_to]).add(_amount);
249      Transfer(_from, _to, _amount);
250      return true;
251          }
252     
253    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
254      // If this function is called again it overwrites the current allowance with _value.
255      function approve(address _spender, uint256 _amount)public returns (bool success) {
256          require( _spender != 0x0);
257          allowed[msg.sender][_spender] = _amount;
258          Approval(msg.sender, _spender, _amount);
259          return true;
260      }
261   
262      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
263          require( _owner != 0x0 && _spender !=0x0);
264          return allowed[_owner][_spender];
265    }
266 
267      // Transfer the balance from owner's account to another account
268      function transfer(address _to, uint256 _amount)public returns (bool success) {
269         require( _to != 0x0);
270         require(balances[msg.sender] >= _amount && _amount >= 0);
271         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
272         balances[_to] = (balances[_to]).add(_amount);
273         Transfer(msg.sender, _to, _amount);
274              return true;
275          }
276     
277           // Transfer the balance from owner's account to another account
278     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
279         require( _to != 0x0);       
280         require(balances[address(this)] >= _amount && _amount > 0);
281         balances[address(this)] = (balances[address(this)]).sub(_amount);
282         balances[_to] = (balances[_to]).add(_amount);
283         Transfer(address(this), _to, _amount);
284         return true;
285         }
286     
287     function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {
288         require( _to != 0x0); 
289         require (balances[_from] >= _amount && _amount > 0);
290         balances[_from] = (balances[_from]).sub(_amount);
291         balances[_to] = (balances[_to]).add(_amount);
292         Transfer(_from, _to, _amount);
293         return true;
294     }
295 
296     
297     function drain() external onlyOwner {
298         owner.transfer(this.balance);
299     }
300     
301 }