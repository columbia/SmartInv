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
48 contract TRIPAGO is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "TRIPAGO";
52 
53     // Symbol of token
54     string public constant symbol = "TPG";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 1000000000 * 10 ** 18; // 1 Billion inculding decimal precesion
57     address public owner;                    // Owner of this contract
58     uint256 public _price_tokn; 
59     uint256 no_of_tokens;
60     uint256 public pre_startdate;
61     uint256 public ico_startdate;
62     uint256 public pre_enddate;
63     uint256 public ico_enddate;
64     bool stopped = false;
65    
66     mapping(address => uint) balances;
67     mapping(address => mapping(address => uint)) allowed;
68      address ethFundMain = 0x85B442dBD198104F5D43Fbe44F9F8047D9D3705F; 
69 
70     
71      enum Stages {
72         NOTSTARTED,
73         PRESALE,
74         ICO,
75         ENDED
76     }
77     Stages public stage;
78     
79     modifier atStage(Stages _stage) {
80         require(stage == _stage);
81         _;
82     }
83     
84      modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function TRIPAGO() public
90     {
91         
92          owner = msg.sender;
93         balances[owner] = 600000000 * 10 **18;  //600 Million given to Owner
94         balances[address(this)]=  400000000 * 10 **18;  //400 Million given to Smart COntract
95         stage = Stages.NOTSTARTED;
96         emit Transfer(0, owner, balances[owner]);
97         emit  Transfer(0, address(this), balances[address(this)]);
98        
99     }
100     
101      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
102       {
103           stage = Stages.PRESALE;
104           stopped = false;
105          _price_tokn = 16000;     // 1 Ether = 16000 coins
106           pre_startdate = now;
107           pre_enddate = now + 19 days;
108        
109           }
110     
111     function start_ICO() public onlyOwner atStage(Stages.PRESALE)
112       {
113         //  require(now > pre_enddate);
114           stage = Stages.ICO;
115           stopped = false;
116          _price_tokn = 12000;    // 1 Ether = 12000 coins
117           ico_startdate = now;
118           ico_enddate = now + 31 days;
119      
120       }
121   
122   
123     function () public payable 
124     {
125       require(msg.value >= .25 ether);
126         require(!stopped && msg.sender != owner);
127         
128           if( stage == Stages.PRESALE && now <= pre_enddate )
129             { 
130                 no_of_tokens =((msg.value).mul(_price_tokn));
131                 drain(msg.value);
132                 transferTokens(msg.sender,no_of_tokens);
133                }
134                
135                 else if(stage == Stages.ICO && now <= ico_enddate )
136             {
137              
138                no_of_tokens =((msg.value).mul(_price_tokn));
139                drain(msg.value);
140                transferTokens(msg.sender,no_of_tokens);
141             }
142         
143         else
144         {
145             revert();
146         }
147        
148     }
149      
150       
151     
152     // called by the owner, pause ICO
153     function StopICO() external onlyOwner 
154     {
155         stopped = true;
156        }
157 
158     // called by the owner , resumes ICO
159     function releaseICO() external onlyOwner 
160     {
161         
162         stopped = false;
163       }
164       
165       
166        function end_ICO() external onlyOwner
167      {
168           stage = Stages.ENDED;
169           uint256 x = balances[address(this)];
170          balances[owner] = (balances[owner]).add(balances[address(this)]);
171          balances[address(this)] = 0;
172        emit  Transfer(address(this), owner , x);
173          
174          
175      }
176 
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
200     emit Transfer(_from, _to, _amount);
201      return true;
202          }
203     
204    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
205      // If this function is called again it overwrites the current allowance with _value.
206      function approve(address _spender, uint256 _amount)public returns (bool success) {
207          require( _spender != 0x0);
208          allowed[msg.sender][_spender] = _amount;
209        emit  Approval(msg.sender, _spender, _amount);
210          return true;
211      }
212   
213      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
214          require( _owner != 0x0 && _spender !=0x0);
215          return allowed[_owner][_spender];
216    }
217 
218      // Transfer the balance from owner's account to another account
219      function transfer(address _to, uint256 _amount)public returns (bool success) {
220         require( _to != 0x0);
221         require(balances[msg.sender] >= _amount && _amount >= 0);
222         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
223         balances[_to] = (balances[_to]).add(_amount);
224        emit Transfer(msg.sender, _to, _amount);
225              return true;
226          }
227     
228           // Transfer the balance from owner's account to another account
229     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
230         require( _to != 0x0);       
231         require(balances[address(this)] >= _amount && _amount > 0);
232         balances[address(this)] = (balances[address(this)]).sub(_amount);
233         balances[_to] = (balances[_to]).add(_amount);
234        emit Transfer(address(this), _to, _amount);
235         return true;
236         }
237     
238     
239     function drain(uint256 value) private {
240          
241         ethFundMain.transfer(value);
242     }
243     
244 }