1 pragma solidity 0.4.23;
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
60     uint256 bonus_token;
61     uint256 total_token;
62     bool stopped = false;
63    
64     mapping(address => uint) balances;
65     mapping(address => mapping(address => uint)) allowed;
66     address ethFundMain = 0x85B442dBD198104F5D43Fbe44F9F8047D9D3705F; 
67 
68     
69      enum Stages {
70         NOTSTARTED,
71         ICO,
72         ENDED
73     }
74     Stages public stage;
75     
76     modifier atStage(Stages _stage) {
77         require(stage == _stage);
78         _;
79     }
80     
81      modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     constructor() public
87     {
88         
89         owner = msg.sender;
90         balances[owner] = 600000000 * 10 **18;  //600 Million given to Owner
91         balances[address(this)]=  400000000 * 10 **18;  //400 Million given to Smart COntract
92         stage = Stages.NOTSTARTED;
93         emit Transfer(0, owner, balances[owner]);
94         emit  Transfer(0, address(this), balances[address(this)]);
95        
96     }
97    
98     function start_ICO() public onlyOwner
99       {
100           stage = Stages.ICO;
101           stopped = false;
102          _price_tokn = 12000;    // 1 Ether = 12000 coin
103      
104       }
105   
106   
107     function () public payable 
108     {
109       require(msg.value >= .1 ether);
110         require(!stopped && msg.sender != owner);
111              if(stage == Stages.ICO)
112             {
113              
114                no_of_tokens =((msg.value).mul(_price_tokn));
115                bonus_token = ((no_of_tokens).mul(75)).div(100);  //75% bonus
116                total_token = no_of_tokens + bonus_token;
117                drain(msg.value);
118                transferTokens(msg.sender,total_token);
119             }
120         
121         else
122         {
123             revert();
124         }
125        
126     }
127      
128       
129     
130     // called by the owner, pause ICO
131     function StopICO() external onlyOwner 
132     {
133         stopped = true;
134        }
135 
136     // called by the owner , resumes ICO
137     function releaseICO() external onlyOwner 
138     {
139         
140         stopped = false;
141       }
142       
143       
144        function end_ICO() external onlyOwner
145      {
146         stage = Stages.ENDED;
147         uint256 x = balances[address(this)];
148         balances[owner] = (balances[owner]).add(balances[address(this)]);
149         balances[address(this)] = 0;
150         emit  Transfer(address(this), owner , x);
151          
152          
153      }
154 
155 
156     // what is the total supply of the ech tokens
157      function totalSupply() public view returns (uint256 total_Supply) {
158          total_Supply = _totalsupply;
159      }
160     
161     // What is the balance of a particular account?
162      function balanceOf(address _owner)public view returns (uint256 balance) {
163          return balances[_owner];
164      }
165     
166     // Send _value amount of tokens from address _from to address _to
167      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
168      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
169      // fees in sub-currencies; the command should fail unless the _from account has
170      // deliberately authorized the sender of the message via some mechanism; we propose
171      // these standardized APIs for approval:
172      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
173      require( _to != 0x0);
174      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
175      balances[_from] = (balances[_from]).sub(_amount);
176      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
177      balances[_to] = (balances[_to]).add(_amount);
178     emit Transfer(_from, _to, _amount);
179      return true;
180          }
181     
182    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
183      // If this function is called again it overwrites the current allowance with _value.
184      function approve(address _spender, uint256 _amount)public returns (bool success) {
185          require( _spender != 0x0);
186          allowed[msg.sender][_spender] = _amount;
187        emit  Approval(msg.sender, _spender, _amount);
188          return true;
189      }
190   
191      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
192          require( _owner != 0x0 && _spender !=0x0);
193          return allowed[_owner][_spender];
194    }
195 
196      // Transfer the balance from owner's account to another account
197      function transfer(address _to, uint256 _amount)public returns (bool success) {
198         require( _to != 0x0);
199         require(balances[msg.sender] >= _amount && _amount >= 0);
200         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
201         balances[_to] = (balances[_to]).add(_amount);
202        emit Transfer(msg.sender, _to, _amount);
203              return true;
204          }
205     
206           // Transfer the balance from owner's account to another account
207     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
208         require( _to != 0x0);       
209         require(balances[address(this)] >= _amount && _amount > 0);
210         balances[address(this)] = (balances[address(this)]).sub(_amount);
211         balances[_to] = (balances[_to]).add(_amount);
212        emit Transfer(address(this), _to, _amount);
213         return true;
214         }
215     
216     
217     function drain(uint256 value) private {
218          
219         ethFundMain.transfer(value);
220     }
221     
222 }