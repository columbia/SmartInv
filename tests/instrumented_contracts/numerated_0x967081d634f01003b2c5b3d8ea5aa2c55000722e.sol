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
76 
77     
78      enum Stages {
79         NOTSTARTED,
80         PREICO,
81         ICO,
82         PAUSED,
83         ENDED
84     }
85     Stages public stage;
86     
87     modifier atStage(Stages _stage) {
88         if (stage != _stage)
89             // Contract not in expected state
90             revert();
91         _;
92     }
93     
94      modifier onlyOwner() {
95         if (msg.sender != owner) {
96             revert();
97         }
98         _;
99     }
100 
101     function ZEROCoin() public
102     {
103         owner = msg.sender;
104         balances[owner] = 518000000 * 10 **18; // 518 million to owner
105         stage = Stages.NOTSTARTED;
106         Transfer(0, owner, balances[owner]);
107     }
108   
109     function () public payable 
110     {
111         require(stage != Stages.ENDED);
112         require(!stopped && msg.sender != owner);
113             if( stage == Stages.PREICO && now <= pre_enddate )
114             { 
115                 require (eth_received <= 1500 ether);
116               eth_received = (eth_received).add(msg.value);
117                 no_of_tokens =((msg.value).mul(_price_tokn_PRE));
118                 bonus_token = ((no_of_tokens).mul(58)).div(100); // 58 percent bonus token
119                 total_token = no_of_tokens + bonus_token;
120                 transferTokens(msg.sender,total_token);
121                }
122                
123              else if(stage == Stages.ICO && now <= ico_fourth ){
124                     
125                 if( now < ico_first )
126             {
127               no_of_tokens =(msg.value).mul(_price_tokn_ICO);
128                 bonus_token = ((no_of_tokens).mul(15)).div(100); // 15% bonus
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
139                   no_of_tokens =(msg.value).mul(_price_tokn_ICO);
140                 bonus_token = ((no_of_tokens).mul(10)).div(100); // 10% bonus
141                 total_token = no_of_tokens + bonus_token;
142                 transferTokens(msg.sender,total_token);
143                 
144                 
145             }
146              else if(now >= ico_second && now < ico_third)
147             {
148                 
149                    no_of_tokens =(msg.value).mul(_price_tokn_ICO);
150                 bonus_token = ((no_of_tokens).mul(5)).div(100); // 5% bonus
151                 total_token = no_of_tokens + bonus_token;
152                 transferTokens(msg.sender,total_token);
153                 
154                 
155             }
156             
157              else if(now >= ico_third && now < ico_fourth)
158             {
159                 
160                    
161              no_of_tokens =(msg.value).mul(_price_tokn_ICO);      // 0% Bonus
162                 total_token = no_of_tokens;
163                 transferTokens(msg.sender,total_token);
164                 
165                 
166             }
167              }
168         else
169         {
170             revert();
171         }
172     
173     }
174      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
175       {
176           stage = Stages.PREICO;
177           stopped = false;
178            balances[address(this)] =  maxCap_public;
179           pre_startdate = now;
180           pre_enddate = now + 16 days;
181           Transfer(0, address(this), balances[address(this)]);
182           }
183       
184       function start_ICO() public onlyOwner atStage(Stages.PREICO)
185       {
186           require(now > pre_enddate || eth_received >= 1500 ether);
187           stage = Stages.ICO;
188           stopped = false;
189           ico1_startdate = now;
190            ico_first = now + 15 days;
191           ico_second = ico_first + 15 days;
192           ico_third = ico_second + 15 days;
193           ico_fourth = ico_third + 15 days;
194           Transfer(0, address(this), balances[address(this)]);
195       }
196     
197     // called by the owner, pause ICO
198     function PauseICO() external onlyOwner
199     {
200         stopped = true;
201        }
202 
203     // called by the owner , resumes ICO
204     function ResumeICO() external onlyOwner
205     {
206         stopped = false;
207       }
208    
209      
210      
211      function end_ICO() external onlyOwner atStage(Stages.ICO)
212      {
213          require(now > ico_fourth);
214          stage = Stages.ENDED;
215          _totalsupply = (_totalsupply).sub(balances[address(this)]);
216          balances[address(this)] = 0;
217          Transfer(address(this), 0 , balances[address(this)]);
218          
219      }
220 
221     // what is the total supply of the ech tokens
222      function totalSupply() public view returns (uint256 total_Supply) {
223          total_Supply = _totalsupply;
224      }
225     
226     // What is the balance of a particular account?
227      function balanceOf(address _owner)public view returns (uint256 balance) {
228          return balances[_owner];
229      }
230     
231     // Send _value amount of tokens from address _from to address _to
232      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
233      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
234      // fees in sub-currencies; the command should fail unless the _from account has
235      // deliberately authorized the sender of the message via some mechanism; we propose
236      // these standardized APIs for approval:
237      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
238      require( _to != 0x0);
239      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
240      balances[_from] = (balances[_from]).sub(_amount);
241      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
242      balances[_to] = (balances[_to]).add(_amount);
243      Transfer(_from, _to, _amount);
244      return true;
245          }
246     
247    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
248      // If this function is called again it overwrites the current allowance with _value.
249      function approve(address _spender, uint256 _amount)public returns (bool success) {
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
260 
261      // Transfer the balance from owner's account to another account
262      function transfer(address _to, uint256 _amount)public returns (bool success) {
263         require( _to != 0x0);
264         require(balances[msg.sender] >= _amount && _amount >= 0);
265         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
266         balances[_to] = (balances[_to]).add(_amount);
267         Transfer(msg.sender, _to, _amount);
268              return true;
269          }
270     
271           // Transfer the balance from owner's account to another account
272     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
273         require( _to != 0x0);       
274         require(balances[address(this)] >= _amount && _amount > 0);
275         balances[address(this)] = (balances[address(this)]).sub(_amount);
276         balances[_to] = (balances[_to]).add(_amount);
277         Transfer(address(this), _to, _amount);
278         return true;
279         }
280  
281     
282     function drain() external onlyOwner {
283         owner.transfer(this.balance);
284     }
285     
286 }