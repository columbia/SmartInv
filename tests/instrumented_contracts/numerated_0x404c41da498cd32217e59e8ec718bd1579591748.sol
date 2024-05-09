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
48 contract WinexlCoins is ERC20 { 
49     
50     using SafeMath for uint256;
51     string public constant name = "WINEXLCOINS";        // Name of the token
52     string public constant symbol = "WNX";              // Symbol of token
53     uint8 public constant decimals = 18;
54     uint public _totalsupply = 100000000 * 10 ** 18;    // 100 million total supply // muliplies dues to decimal precision
55     address public owner;                               // Owner of this contract
56     uint256 public _price_token_PRE = 3500;             // 1 Ether = 3500 tokens in Pre-ICO
57     uint256 public _price_token_ICO1 = 3000;            // 1 Ether = 3000 tokens in ICO Phase 1
58     uint256 public _price_token_ICO2 = 2500;            // 1 Ether = 2500 tokens in ICO Phase 2
59     uint256 no_of_tokens;
60     uint256 bonus_token;
61     uint256 total_token;
62     bool stopped = false;
63     uint256 public pre_startdate;
64     uint256 public ico1_startdate;
65     uint256 ico_first;
66     uint256 ico_second;
67     uint256 pre_enddate;
68     uint256 public eth_received;                        // Total ether received in the contract
69     uint256 maxCap_public = 10000000 * 10 ** 18;        // 10 million in Public Sale
70     mapping(address => uint) balances;
71     mapping(address => mapping(address => uint)) allowed;
72     uint public contractBalance = balances[address(this)];
73 
74     enum Stages {
75         NOTSTARTED,
76         PREICO,
77         ICO,
78         PAUSED,
79         ENDED
80     }
81     
82     Stages public stage;
83     
84     modifier atStage(Stages _stage) {
85         if (stage != _stage)
86             // Contract not in expected state
87             revert();
88         _;
89     }
90     
91     modifier onlyOwner() {
92         if (msg.sender != owner) {
93             revert();
94         }
95         _;
96     }
97 
98     function WinexlCoins() public {
99         owner = msg.sender;
100         balances[owner] = 90000000 * 10 ** 18;         // 90 million to owner
101         stage = Stages.NOTSTARTED;
102         Transfer(0, owner, balances[owner]);
103     }
104   
105     function () public payable {
106         require(stage != Stages.ENDED);
107         require(!stopped && msg.sender != owner);
108             if( stage == Stages.PREICO && now <= pre_enddate ) { 
109                 require (eth_received <= 1500 ether);                       // Hardcap
110                 eth_received = (eth_received).add(msg.value);
111                 no_of_tokens = ((msg.value).mul(_price_token_PRE)); 
112                 bonus_token  = ((no_of_tokens).mul(30)).div(100);           // 30% bonus in Pre-ICO
113                 total_token  = no_of_tokens + bonus_token;
114                 transferTokens(msg.sender,total_token);
115             }
116             else if (stage == Stages.ICO && now <= ico_second ) {
117                     
118                 if( now < ico_first )
119                 {
120                     no_of_tokens = (msg.value).mul(_price_token_ICO1);
121                     bonus_token  = ((no_of_tokens).mul(20)).div(100);       // 20% bonus in ICO Phase 1
122                     total_token  = no_of_tokens + bonus_token;
123                     transferTokens(msg.sender,total_token);
124                 }   
125                 else if( now >= ico_first && now < ico_second )
126                 {
127                     no_of_tokens = (msg.value).mul(_price_token_ICO2);
128                     bonus_token  = ((no_of_tokens).mul(10)).div(100);       // 10% bonus in ICO Phase 2
129                     total_token  = no_of_tokens + bonus_token;
130                     transferTokens(msg.sender,total_token);
131                 }
132                 
133             }
134             else
135             {
136                 revert();
137             }
138     }
139     
140     function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
141     {
142         stage   = Stages.PREICO;
143         stopped = false;
144         balances[address(this)] =  maxCap_public;
145         pre_startdate = now;
146         pre_enddate   = now + 15 days;                                      // 15 days PREICO
147         Transfer(0, address(this), balances[address(this)]);
148     }
149      
150     function start_ICO() public onlyOwner atStage(Stages.PREICO)
151     {
152         require(now > pre_enddate);
153         stage   = Stages.ICO;
154         stopped = false;
155         ico1_startdate = now;
156         ico_first  = now + 15 days;
157         ico_second = ico_first + 40 days;
158         
159         Transfer(0, address(this), balances[address(this)]);
160     }
161     
162     // called by the owner, pause ICO
163     function PauseICO() external onlyOwner
164     {
165         stopped = true;
166     }
167 
168     // called by the owner, resumes ICO
169     function ResumeICO() external onlyOwner
170     {
171         stopped = false;
172     }
173    
174     function end_ICO() external onlyOwner atStage(Stages.ICO)
175     {
176         require(now > ico_second);
177         stage = Stages.ENDED;
178         _totalsupply = (_totalsupply).sub(balances[address(this)]);
179         balances[address(this)] = 0;
180         Transfer(address(this), 0 , balances[address(this)]);
181     }
182 
183     // what is the total supply of the ech tokens
184     function totalSupply() public view returns (uint256 total_Supply) {
185         total_Supply = _totalsupply;
186     }
187     
188     // What is the balance of a particular account?
189     function balanceOf(address _owner) public view returns (uint256 balance) {
190         return balances[_owner];
191     }
192     
193     // Send _value amount of tokens from address _from to address _to
194     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
195     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
196     // fees in sub-currencies; the command should fail unless the _from account has
197     // deliberately authorized the sender of the message via some mechanism; we propose
198     // these standardized APIs for approval:
199     function transferFrom( address _from, address _to, uint256 _amount ) public returns (bool success) {
200         require( _to != 0x0);
201         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
202         balances[_from] = (balances[_from]).sub(_amount);
203         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
204         balances[_to] = (balances[_to]).add(_amount);
205         Transfer(_from, _to, _amount);
206         return true;
207     }
208     
209     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
210     // If this function is called again it overwrites the current allowance with _value.
211     function approve(address _spender, uint256 _amount) public returns (bool success) {
212         require( _spender != 0x0);
213         allowed[msg.sender][_spender] = _amount;
214         Approval(msg.sender, _spender, _amount);
215         return true;
216     }
217   
218     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
219         require( _owner != 0x0 && _spender !=0x0);
220         return allowed[_owner][_spender];
221     }
222 
223     // Transfer the balance from owner's account to another account
224     function transfer(address _to, uint256 _amount) public returns (bool success) {
225         require( _to != 0x0);
226         require(balances[msg.sender] >= _amount && _amount >= 0);
227         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
228         balances[_to] = (balances[_to]).add(_amount);
229         Transfer(msg.sender, _to, _amount);
230         return true;
231     }
232     
233     // Transfer the balance from owner's account to another account
234     function transferTokens(address _to, uint256 _amount) private returns (bool success) {
235         require( _to != 0x0);       
236         require(balances[address(this)] >= _amount && _amount > 0);
237         balances[address(this)] = (balances[address(this)]).sub(_amount);
238         balances[_to] = (balances[_to]).add(_amount);
239         Transfer(address(this), _to, _amount);
240         return true;
241     }
242  
243     function drain() external onlyOwner {
244         owner.transfer(this.balance);
245     }
246 }