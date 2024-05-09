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
48 contract Bitron is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "Bitron coin";
52 
53     // Symbol of token
54     string public constant symbol = "BTO";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 50000000 * 10 ** 18; // 50 Million total supply // muliplies dues to decimal precision
57     address public owner;                    // Owner of this contract
58     uint256 public _price_tokn; 
59     uint256 no_of_tokens;
60     uint256 bonus_token;
61     uint256 total_token;
62     bool stopped = false;
63     address ethFundMain = 0x1e6d1Fc2d934D2E4e2aE5e4882409C3fECD769dF; 
64     uint256 public postico_startdate;
65     uint256 postico_enddate;
66     uint256 maxCap_POSTICO;
67     
68     uint public priceFactor;
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71     uint bon;
72     uint public bonus;
73     
74      enum Stages {
75         NOTSTARTED,
76         POSTICO,
77         PAUSED,
78         ENDED
79     }
80     Stages public stage;
81     
82     modifier atStage(Stages _stage) {
83         require (stage == _stage);
84         _;
85     }
86 
87     modifier onlyOwner(){
88         require (msg.sender == owner);
89      _;
90     }
91     
92   constructor(uint256 EtherPriceFactor) public
93     {
94          require(EtherPriceFactor != 0);
95         owner = msg.sender;
96         balances[owner] = 30000000 * 10 **18; // 30 million to owner
97         stage = Stages.NOTSTARTED;
98         priceFactor = EtherPriceFactor;
99       emit  Transfer(0, owner, balances[owner]);
100     }
101   
102    function setpricefactor(uint256 newPricefactor) external onlyOwner
103     {
104         priceFactor = newPricefactor;
105     }
106     function () public payable 
107     {
108         require(stage != Stages.ENDED);
109         require(!stopped && msg.sender != owner);
110         no_of_tokens = ((msg.value).mul(priceFactor.mul(100))).div(_price_tokn);
111         transferTokens(msg.sender,no_of_tokens);
112        
113     }
114    
115     
116   
117      function start_POSTICO() public onlyOwner atStage(Stages.NOTSTARTED)
118       {
119           stage = Stages.POSTICO;
120           stopped = false;
121           maxCap_POSTICO = 20000000 * 10 **18;  // 20 million
122            balances[address(this)] = maxCap_POSTICO;
123           postico_startdate = now;
124           postico_enddate = now + 90 days; //3 months
125           _price_tokn = 5; // Price in Cents
126           emit Transfer(0, address(this), maxCap_POSTICO);
127       }
128       
129      
130      
131     // called by the owner, pause ICO
132     function PauseICO() external onlyOwner
133     {
134         stopped = true;
135        }
136 
137     // called by the owner , resumes ICO
138     function ResumeICO() external onlyOwner
139     {
140         stopped = false;
141       }
142    
143      
144       function end_ICO() external onlyOwner
145      {
146         stage = Stages.ENDED;
147         uint256 x = balances[address(this)];
148         balances[owner] = (balances[owner]).add(balances[address(this)]);
149         balances[address(this)] = 0;
150         emit  Transfer(address(this), owner , x);
151          
152          
153      }
154  // what is the total supply of the ech tokens
155      function totalSupply() public view returns (uint256 total_Supply) {
156          total_Supply = _totalsupply;
157      }
158     
159     // What is the balance of a particular account?
160      function balanceOf(address _owner)public view returns (uint256 balance) {
161          return balances[_owner];
162      }
163     
164     // Send _value amount of tokens from address _from to address _to
165      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
166      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
167      // fees in sub-currencies; the command should fail unless the _from account has
168      // deliberately authorized the sender of the message via some mechanism; we propose
169      // these standardized APIs for approval:
170      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
171      require( _to != 0x0);
172      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
173      balances[_from] = (balances[_from]).sub(_amount);
174      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
175      balances[_to] = (balances[_to]).add(_amount);
176     emit Transfer(_from, _to, _amount);
177      return true;
178          }
179     
180    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
181      // If this function is called again it overwrites the current allowance with _value.
182      function approve(address _spender, uint256 _amount)public returns (bool success) {
183          require( _spender != 0x0);
184          allowed[msg.sender][_spender] = _amount;
185         emit Approval(msg.sender, _spender, _amount);
186          return true;
187      }
188   
189      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
190          require( _owner != 0x0 && _spender !=0x0);
191          return allowed[_owner][_spender];
192    }
193 
194      // Transfer the balance from owner's account to another account
195      function transfer(address _to, uint256 _amount)public returns (bool success) {
196         require( _to != 0x0);
197         require(balances[msg.sender] >= _amount && _amount >= 0);
198         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
199         balances[_to] = (balances[_to]).add(_amount);
200        emit Transfer(msg.sender, _to, _amount);
201              return true;
202          }
203     
204           // Transfer the balance from owner's account to another account
205     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
206         require( _to != 0x0);       
207         require(balances[address(this)] >= _amount && _amount > 0);
208         balances[address(this)] = (balances[address(this)]).sub(_amount);
209         balances[_to] = (balances[_to]).add(_amount);
210        emit Transfer(address(this), _to, _amount);
211         return true;
212         }
213         
214          //In case the ownership needs to be transferred
215 	function transferOwnership(address newOwner) external onlyOwner
216 	{
217 	    require( newOwner != 0x0);
218 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
219 	    balances[owner] = 0;
220 	    owner = newOwner;
221 	   emit Transfer(msg.sender, newOwner, balances[newOwner]);
222 	}
223 
224     
225     function drain() external onlyOwner {
226         address myAddress = this;
227         ethFundMain.transfer(myAddress.balance);
228        
229     }
230     
231 }