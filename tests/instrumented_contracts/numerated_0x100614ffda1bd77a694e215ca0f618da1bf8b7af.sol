1 pragma solidity 0.4.24;
2 
3  /**
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
48 contract FlexionCoin is ERC20 { 
49     
50     using SafeMath for uint256;
51     string public constant name = "FLEXION";            // Name of the token
52     string public constant symbol = "FXN";              // Symbol of token
53     uint8 public constant decimals = 18;
54     uint public _totalsupply = 360000000 * 10 ** 18;    // 360 million total supply // muliplies dues to decimal precision
55     address public owner;                               // Owner of this contract
56     uint256 public _price_token_PRE = 16000;            // 1 Ether = 16000 tokens in Pre-ICO
57     uint256 public _price_token_ICO1 = 8000;            // 1 Ether = 8000 tokens in ICO Phase 1
58     uint256 public _price_token_ICO2 = 4000;            // 1 Ether = 4000 tokens in ICO Phase 2
59     uint256 public _price_token_ICO3 = 2666;            // 1 Ether = 2666 tokens in ICO Phase 3
60     uint256 public _price_token_ICO4 = 2000;            // 1 Ether = 2000 tokens in ICO Phase 4
61     uint256 no_of_tokens;
62     uint256 bonus_token;
63     uint256 total_token;
64     bool stopped = false;
65     uint256 public pre_startdate;
66     uint256 public ico1_startdate;
67     uint256 ico_first;
68     uint256 ico_second;
69     uint256 ico_third;
70     uint256 ico_fourth;
71     uint256 pre_enddate;
72     uint256 public eth_received;                        // Total ether received in the contract
73     uint256 maxCap_public = 240000000 * 10 ** 18;       // 240 million in Public Sale
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76 
77     enum Stages {
78         NOTSTARTED,
79         PREICO,
80         ICO,
81         PAUSED,
82         ENDED
83     }
84     
85     Stages public stage;
86     
87     modifier atStage(Stages _stage) {
88         if (stage != _stage)
89             // Contract not in expected state
90             revert();
91         _;
92     }
93     
94     modifier onlyOwner() {
95         if (msg.sender != owner) {
96             revert();
97         }
98         _;
99     }
100 
101     function FlexionCoin() public {
102         owner = msg.sender;
103         balances[owner] = 120000000 * 10 ** 18;         // 100 million to owner & 20 million to referral bonus
104         stage = Stages.NOTSTARTED;
105         Transfer(0, owner, balances[owner]);
106     }
107   
108     function () public payable {
109         require(stage != Stages.ENDED);
110         require(!stopped && msg.sender != owner);
111             if( stage == Stages.PREICO && now <= pre_enddate ) { 
112                 require (eth_received <= 1500 ether);                       // Hardcap
113                 eth_received = (eth_received).add(msg.value);
114                 no_of_tokens = ((msg.value).mul(_price_token_PRE)); 
115                 require (no_of_tokens >= (500 * 10 ** 18));                 // 500 min purchase
116                 bonus_token  = ((no_of_tokens).mul(50)).div(100);           // 50% bonus in Pre-ICO
117                 total_token  = no_of_tokens + bonus_token;
118                 transferTokens(msg.sender,total_token);
119             }
120             else if (stage == Stages.ICO && now <= ico_fourth ) {
121                     
122                 if( now < ico_first )
123                 {
124                     no_of_tokens = (msg.value).mul(_price_token_ICO1);
125                     require (no_of_tokens >= (100 * 10 ** 18));             // 100 min purchase
126                     bonus_token  = ((no_of_tokens).mul(40)).div(100);       // 40% bonus in ICO Phase 1
127                     total_token  = no_of_tokens + bonus_token;
128                     transferTokens(msg.sender,total_token);
129                 }   
130                 else if( now >= ico_first && now < ico_second )
131                 {
132                     no_of_tokens = (msg.value).mul(_price_token_ICO2);
133                     require (no_of_tokens >= (100 * 10 ** 18));             // 100 min purchase
134                     bonus_token  = ((no_of_tokens).mul(30)).div(100);       // 30% bonus in ICO Phase 2
135                     total_token  = no_of_tokens + bonus_token;
136                     transferTokens(msg.sender,total_token);
137                 }
138                 else if( now >= ico_second && now < ico_third )
139                 {
140                     no_of_tokens = (msg.value).mul(_price_token_ICO3);
141                     require (no_of_tokens >= (100 * 10 ** 18));             // 100 min purchase
142                     bonus_token  = ((no_of_tokens).mul(20)).div(100);       // 20% bonus in ICO Phase 3
143                     total_token  = no_of_tokens + bonus_token;
144                     transferTokens(msg.sender,total_token);
145                 }
146                 else if( now >= ico_third && now < ico_fourth )
147                 {
148                     no_of_tokens = (msg.value).mul(_price_token_ICO4);
149                     require (no_of_tokens >= (100 * 10 ** 18));             // 100 min purchase    
150                     bonus_token  = ((no_of_tokens).mul(10)).div(100);       // 10% bonus in ICO Phase 4
151                     total_token  = no_of_tokens + bonus_token;
152                     transferTokens(msg.sender,total_token);
153                 }
154             }
155             else
156             {
157                 revert();
158             }
159     }
160     
161     function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
162     {
163         stage   = Stages.PREICO;
164         stopped = false;
165         balances[address(this)] =  maxCap_public;
166         pre_startdate = now;
167         pre_enddate   = now + 30 days;                                      // 30 days PREICO
168         Transfer(0, address(this), balances[address(this)]);
169     }
170      
171     function start_ICO() public onlyOwner atStage(Stages.PREICO)
172     {
173         require(now > pre_enddate);
174         stage   = Stages.ICO;
175         stopped = false;
176         ico1_startdate = now;
177         ico_first  = now + 15 days;
178         ico_second = ico_first + 15 days;
179         ico_third  = ico_second + 15 days;
180         ico_fourth = ico_third + 15 days;
181         Transfer(0, address(this), balances[address(this)]);
182     }
183     
184     // called by the owner, pause ICO
185     function PauseICO() external onlyOwner
186     {
187         stopped = true;
188     }
189 
190     // called by the owner, resumes ICO
191     function ResumeICO() external onlyOwner
192     {
193         stopped = false;
194     }
195    
196     function end_ICO() external onlyOwner atStage(Stages.ICO)
197     {
198         require(now > ico_fourth);
199         stage = Stages.ENDED;
200         _totalsupply = (_totalsupply).sub(balances[address(this)]);
201         balances[address(this)] = 0;
202         Transfer(address(this), 0 , balances[address(this)]);
203     }
204 
205     // what is the total supply of the ech tokens
206     function totalSupply() public view returns (uint256 total_Supply) {
207         total_Supply = _totalsupply;
208     }
209     
210     // What is the balance of a particular account?
211     function balanceOf(address _owner) public view returns (uint256 balance) {
212         return balances[_owner];
213     }
214     
215     // Send _value amount of tokens from address _from to address _to
216     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
217     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
218     // fees in sub-currencies; the command should fail unless the _from account has
219     // deliberately authorized the sender of the message via some mechanism; we propose
220     // these standardized APIs for approval:
221     function transferFrom( address _from, address _to, uint256 _amount ) public returns (bool success) {
222         require( _to != 0x0);
223         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
224         balances[_from] = (balances[_from]).sub(_amount);
225         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
226         balances[_to] = (balances[_to]).add(_amount);
227         Transfer(_from, _to, _amount);
228         return true;
229     }
230     
231     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
232     // If this function is called again it overwrites the current allowance with _value.
233     function approve(address _spender, uint256 _amount) public returns (bool success) {
234         require( _spender != 0x0);
235         allowed[msg.sender][_spender] = _amount;
236         Approval(msg.sender, _spender, _amount);
237         return true;
238     }
239   
240     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
241         require( _owner != 0x0 && _spender !=0x0);
242         return allowed[_owner][_spender];
243     }
244 
245     // Transfer the balance from owner's account to another account
246     function transfer(address _to, uint256 _amount) public returns (bool success) {
247         require( _to != 0x0);
248         require(balances[msg.sender] >= _amount && _amount >= 0);
249         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
250         balances[_to] = (balances[_to]).add(_amount);
251         Transfer(msg.sender, _to, _amount);
252         return true;
253     }
254     
255     // Transfer the balance from owner's account to another account
256     function transferTokens(address _to, uint256 _amount) private returns (bool success) {
257         require( _to != 0x0);       
258         require(balances[address(this)] >= _amount && _amount > 0);
259         balances[address(this)] = (balances[address(this)]).sub(_amount);
260         balances[_to] = (balances[_to]).add(_amount);
261         Transfer(address(this), _to, _amount);
262         return true;
263     }
264  
265     function drain() external onlyOwner {
266         owner.transfer(this.balance);
267     }
268 }