1 pragma solidity 0.4.24;
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
48 contract INFLIV is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "INFLIV";
52 
53     // Symbol of token
54     string public constant symbol = "IFV";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 70000000 * 10 ** 18; // 70 million total supply // muliplies dues to decimal precision
57     address public owner;                    // Owner of this contract
58     uint256 public _price_tokn_PRE = 6000;  // 1 Ether = 6000 coins
59     uint256 public _price_tokn_ICO_first = 3800;   // 1 Ether = 3800 coins
60     uint256 public _price_tokn_ICO_second = 2600;   // 1 Ether = 2600 coins
61     uint256 no_of_tokens;
62     uint256 bonus_token;
63     uint256 total_token;
64     bool stopped = false;
65     uint256 public pre_startdate;
66     uint256 public ico1_startdate;
67     uint256 ico_first;
68     uint256 ico_second;
69     uint256 pre_enddate;
70   
71     uint256 public eth_received; // total ether received in the contract
72     uint256 maxCap_public =  42000000 * 10 **18;  //  42 million in Public Sale
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75 
76     
77      enum Stages {
78         NOTSTARTED,
79         PREICO,
80         ICO,
81         PAUSED,
82         ENDED
83     }
84     Stages public stage;
85     
86     modifier atStage(Stages _stage) {
87         if (stage != _stage)
88             // Contract not in expected state
89             revert();
90         _;
91     }
92     
93      modifier onlyOwner() {
94         if (msg.sender != owner) {
95             revert();
96         }
97         _;
98     }
99 
100     function INFLIV() public
101     {
102         owner = msg.sender;
103         balances[owner] = 28000000 * 10 **18; // 28 million to owner
104         stage = Stages.NOTSTARTED;
105         Transfer(0, owner, balances[owner]);
106     }
107      
108       function () public payable 
109     
110     {
111               require(stage != Stages.ENDED);
112         require(!stopped && msg.sender != owner);
113             if( stage == Stages.PREICO && now <= pre_enddate )
114             { 
115                 require (eth_received <= 100 ether);
116               eth_received = (eth_received).add(msg.value);
117               no_of_tokens =((msg.value).mul(_price_tokn_PRE));
118                 bonus_token = ((no_of_tokens).mul(50)).div(100); // 50% bonus token
119                 total_token = no_of_tokens + bonus_token;
120                 transferTokens(msg.sender,total_token);
121                }
122                
123              else if(stage == Stages.ICO && now <= ico_second){
124                     
125                 if( now < ico_first )
126             {
127               no_of_tokens =(msg.value).mul(_price_tokn_ICO_first);
128                 bonus_token = ((no_of_tokens).mul(25)).div(100); // 25% bonus token
129                 total_token = no_of_tokens + bonus_token;
130                 transferTokens(msg.sender,total_token);
131                 
132                 
133             }   
134             
135               else if(now >= ico_first && now < ico_second)
136             {
137                 
138                 
139                   no_of_tokens =(msg.value).mul(_price_tokn_ICO_first);
140                 bonus_token = ((no_of_tokens).mul(10)).div(100); // 10% bonus token
141                 total_token = no_of_tokens + bonus_token;
142                 transferTokens(msg.sender,total_token);
143                 
144         }
145              }
146         else
147         {
148             revert();
149         }
150     
151     }
152      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
153       {
154           stage = Stages.PREICO;
155           stopped = false;
156            balances[address(this)] =  maxCap_public;
157           pre_startdate = now;
158           pre_enddate = now + 20 days;
159           Transfer(0, address(this), balances[address(this)]);
160           }
161       
162       function start_ICO() public onlyOwner atStage(Stages.PREICO)
163       {
164           require(now > pre_enddate || eth_received >= 100 ether);
165           stage = Stages.ICO;
166           stopped = false;
167           ico1_startdate = now;
168            ico_first = now + 20 days;
169           ico_second = ico_first + 20 days;
170           Transfer(0, address(this), balances[address(this)]);
171       }
172     
173     // called by the owner, pause ICO
174     function PauseICO() external onlyOwner
175     {
176         stopped = true;
177        }
178 
179     // called by the owner , resumes ICO
180     function ResumeICO() external onlyOwner
181     {
182         stopped = false;
183       }
184    
185      
186      
187      function end_ICO() external onlyOwner atStage(Stages.ICO)
188      {
189          require(now > ico_second);
190          stage = Stages.ENDED;
191          _totalsupply = (_totalsupply).sub(balances[address(this)]);
192          balances[address(this)] = 0;
193          Transfer(address(this), 0 , balances[address(this)]);
194          
195      }
196 
197     // what is the total supply of the ech tokens
198      function totalSupply() public view returns (uint256 total_Supply) {
199          total_Supply = _totalsupply;
200      }
201     
202     // What is the balance of a particular account?
203      function balanceOf(address _owner)public view returns (uint256 balance) {
204          return balances[_owner];
205      }
206     
207     // Send _value amount of tokens from address _from to address _to
208      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
209      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
210      // fees in sub-currencies; the command should fail unless the _from account has
211      // deliberately authorized the sender of the message via some mechanism; we propose
212      // these standardized APIs for approval:
213      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
214      require( _to != 0x0);
215      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
216      balances[_from] = (balances[_from]).sub(_amount);
217      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
218      balances[_to] = (balances[_to]).add(_amount);
219      Transfer(_from, _to, _amount);
220      return true;
221          }
222     
223    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
224      // If this function is called again it overwrites the current allowance with _value.
225      function approve(address _spender, uint256 _amount)public returns (bool success) {
226          require( _spender != 0x0);
227          allowed[msg.sender][_spender] = _amount;
228          Approval(msg.sender, _spender, _amount);
229          return true;
230      }
231   
232      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
233          require( _owner != 0x0 && _spender !=0x0);
234          return allowed[_owner][_spender];
235    }
236 
237      // Transfer the balance from owner's account to another account
238      function transfer(address _to, uint256 _amount)public returns (bool success) {
239         require( _to != 0x0);
240         require(balances[msg.sender] >= _amount && _amount >= 0);
241         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
242         balances[_to] = (balances[_to]).add(_amount);
243         Transfer(msg.sender, _to, _amount);
244              return true;
245          }
246     
247           // Transfer the balance from owner's account to another account
248     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
249         require( _to != 0x0);       
250         require(balances[address(this)] >= _amount && _amount > 0);
251         balances[address(this)] = (balances[address(this)]).sub(_amount);
252         balances[_to] = (balances[_to]).add(_amount);
253         Transfer(address(this), _to, _amount);
254         return true;
255         }
256  
257     
258     function drain() external onlyOwner {
259         owner.transfer(this.balance);
260     }
261     
262 }