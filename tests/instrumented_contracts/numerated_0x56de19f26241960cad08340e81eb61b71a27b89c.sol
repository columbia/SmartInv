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
43   function transferToAdvisors(address to, uint value)public returns (bool ok);
44   event Transfer(address indexed from, address indexed to, uint value);
45   event Approval(address indexed owner, address indexed spender, uint value);
46 }
47 
48 
49 contract FricaCoin is ERC20
50 { using SafeMath for uint256;
51     // Name of the token
52     string public constant name = "FricaCoin";
53 
54     // Symbol of token
55     string public constant symbol = "FRI";
56     uint8 public constant decimals = 8;
57     uint public _totalsupply = 1000000000000 * 10 ** 8; // 1 trillion total supply // muliplies dues to decimal precision
58     address public owner;                    // Owner of this contract
59 
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
73     uint256 maxCap_public = 250000000000 * 10 **8;  //  25% - 250 billion in Public Sale
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76     /** Who are our advisors (iterable) */
77     mapping (address => bool) private Advisors;
78     
79      /** How many advisors we have now */
80     uint256 public advisorCount;
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
105     function FricaCoin() public
106     {
107         owner = msg.sender;
108         balances[owner] = 50000000000 * 10 **8; // 5% - 50 billion to owner
109         stage = Stages.NOTSTARTED;
110         Transfer(0, owner, balances[owner]);
111         
112         uint256 _transfertoemployees = 140000000000 * 10 **8; // 14% - 140 billion to Employees Advisors Consultants & Partners
113         balances[0xa36eEa22131881BB0a8902A6b8bF4a2cbb9782BC] = _transfertoemployees;
114         Transfer(address(0), 0xa36eEa22131881BB0a8902A6b8bF4a2cbb9782BC, _transfertoemployees);
115         
116         uint256 _transfertofirstround = 260000000000 * 10 **8; // 26% - 260 billion to First Round & Bonus
117         balances[0x553015bc932FaCc0C60159b7503a58ef5806CA48] = _transfertofirstround;
118         Transfer(address(0), 0x553015bc932FaCc0C60159b7503a58ef5806CA48, _transfertofirstround);
119         
120         uint256 _transfertocharity = 50000000000 * 10 **8; // 5% - 50 billion to Charity and non-profit
121         balances[0x11Bfb0B5a901cbc5015EF924c39ac33e91Eb015a] = _transfertocharity;
122         Transfer(address(0), 0x11Bfb0B5a901cbc5015EF924c39ac33e91Eb015a, _transfertocharity);
123 
124         uint256 _transfertosecondround = 250000000000 * 10 **8; // 25% - 250 billion to Second Round & Bonus
125         balances[0xaAA258C8dbf31De53Aa679F6b492569556e1c306] = _transfertosecondround;
126         Transfer(address(0), 0xaAA258C8dbf31De53Aa679F6b492569556e1c306, _transfertosecondround);
127         
128     }
129   
130 
131      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
132       {
133           stage = Stages.PREICO;
134           stopped = false;
135            balances[address(this)] =  maxCap_public;
136           pre_startdate = now;
137           pre_enddate = now + 16 days;
138           Transfer(0, address(this), balances[address(this)]);
139           }
140       
141       function start_ICO() public onlyOwner atStage(Stages.PREICO)
142       {
143           require(now > pre_enddate || eth_received >= 1500 ether);
144           stage = Stages.ICO;
145           stopped = false;
146           ico1_startdate = now;
147            ico_first = now + 15 days;
148           ico_second = ico_first + 15 days;
149           ico_third = ico_second + 15 days;
150           ico_fourth = ico_third + 15 days;
151           Transfer(0, address(this), balances[address(this)]);
152       }
153     
154     // called by the owner, pause ICO
155     function PauseICO() external onlyOwner
156     {
157         stopped = true;
158        }
159 
160     // called by the owner , resumes ICO
161     function ResumeICO() external onlyOwner
162     {
163         stopped = false;
164       }
165    
166      
167      
168      function end_ICO() external onlyOwner atStage(Stages.ICO)
169      {
170          require(now > ico_fourth);
171          stage = Stages.ENDED;
172          _totalsupply = (_totalsupply).sub(balances[address(this)]);
173          balances[address(this)] = 0;
174          Transfer(address(this), 0 , balances[address(this)]);
175          
176      }
177 
178     // what is the total supply of the ech tokens
179      function totalSupply() public view returns (uint256 total_Supply) {
180          total_Supply = _totalsupply;
181      }
182     
183     // What is the balance of a particular account?
184      function balanceOf(address _owner)public view returns (uint256 balance) {
185          return balances[_owner];
186      }
187     
188     // Send _value amount of tokens from address _from to address _to
189      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
190      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
191      // fees in sub-currencies; the command should fail unless the _from account has
192      // deliberately authorized the sender of the message via some mechanism; we propose
193      // these standardized APIs for approval:
194      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
195      require( _to != 0x0);
196      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
197      balances[_from] = (balances[_from]).sub(_amount);
198      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
199      balances[_to] = (balances[_to]).add(_amount);
200      Transfer(_from, _to, _amount);
201      return true;
202          }
203     
204     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
205      // If this function is called again it overwrites the current allowance with _value.
206      function approve(address _spender, uint256 _amount)public returns (bool success) {
207          require( _spender != 0x0);
208          allowed[msg.sender][_spender] = _amount;
209          Approval(msg.sender, _spender, _amount);
210          return true;
211      }
212   
213      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
214          require( _owner != 0x0 && _spender !=0x0);
215          return allowed[_owner][_spender];
216     }
217 
218      // Transfer the balance from owner's account to another account
219      function transfer(address _to, uint256 _amount)public returns (bool success) {
220         require( _to != 0x0);
221         require(balances[msg.sender] >= _amount && _amount >= 0);
222         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
223         balances[_to] = (balances[_to]).add(_amount);
224         Transfer(msg.sender, _to, _amount);
225              return true;
226          }
227     
228     // Transfer the balance from owner's account to another account
229     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
230         require( _to != 0x0);       
231         require(balances[address(this)] >= _amount && _amount > 0);
232         balances[address(this)] = (balances[address(this)]).sub(_amount);
233         balances[_to] = (balances[_to]).add(_amount);
234         Transfer(address(this), _to, _amount);
235         return true;
236     }
237  
238     // Transfer the balance from owner's account to advisor's account
239     function transferToAdvisors(address _to, uint256 _amount) public returns(bool success) {
240          require( _to != 0x0);
241         require(balances[msg.sender] >= _amount && _amount >= 0);
242         // if this is a new advisor
243         if(!isAdvisor(_to)) {
244           addAdvisor(_to);
245           advisorCount++ ;
246         }
247         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
248         balances[_to] = (balances[_to]).add(_amount);
249         Transfer(msg.sender, _to, _amount);
250              return true;
251     }
252  
253     function addAdvisor(address _advisor) public {
254         Advisors[_advisor]=true;
255     }
256 
257     function isAdvisor(address _advisor) public returns(bool success){
258         return Advisors[_advisor];
259              return true;
260     }
261     
262     function drain() external onlyOwner {
263         owner.transfer(this.balance);
264     }
265     
266 }