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
48 contract AussieCoin is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "AussieCoin";
52 
53     // Symbol of token
54     string public constant symbol = "AUS";
55     uint8 public constant decimals = 18;
56     uint public _totalsupply = 24000000 * 10 ** 18; // 24 Million inculding decimal precesion
57     address public owner;                    // Owner of this contract
58     uint256 public _price_tokn = 5000; // 1 Ether = 5000 token
59     uint256 no_of_tokens;
60      uint256 public startdate;
61     bool stopped = false;
62     mapping(address => uint) balances;
63     mapping(address => mapping(address => uint)) allowed;
64 
65     
66      enum Stages {
67         NOTSTARTED,
68         ICO,
69         PAUSED,
70         ENDED
71     }
72     Stages public stage;
73     
74     modifier atStage(Stages _stage) {
75         if (stage != _stage)
76             // Contract not in expected state
77             revert();
78         _;
79     }
80     
81      modifier onlyOwner() {
82         if (msg.sender != owner) {
83             revert();
84         }
85         _;
86     }
87 
88     function AussieCoin() public
89     {
90          owner = msg.sender;
91         balances[owner] = 14000000 * 10 **18;
92         stage = Stages.NOTSTARTED;
93         Transfer(0, owner, balances[owner]);
94        
95     }
96     
97     function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED)
98       {
99           stage = Stages.ICO;
100           balances[address(this)] = 10000000 *10**18;
101           stopped = false;
102           startdate = now;
103           Transfer(0, address(this), balances[address(this)]);
104           
105       }
106   
107   
108     function () public payable atStage(Stages.ICO)
109     {
110       
111         require(!stopped && msg.sender != owner);
112         no_of_tokens =((msg.value).mul(_price_tokn));
113         transferTokens(msg.sender,no_of_tokens);
114     }
115      
116       
117     
118     // called by the owner, pause ICO
119     function StopICO() external onlyOwner atStage(Stages.ICO)
120     {
121         stage = Stages.PAUSED;
122         stopped = true;
123        }
124 
125     // called by the owner , resumes ICO
126     function releaseICO() external onlyOwner atStage(Stages.PAUSED)
127     {
128         stage = Stages.ICO;
129         stopped = false;
130       }
131       
132       
133        function end_ICO() external onlyOwner atStage(Stages.ICO)
134      {
135           stage = Stages.ENDED;
136          balances[owner] = (balances[owner]).add(balances[address(this)]);
137          balances[address(this)] = 0;
138          Transfer(address(this), owner , balances[address(this)]);
139          
140          
141      }
142 
143 
144     // what is the total supply of the ech tokens
145      function totalSupply() public view returns (uint256 total_Supply) {
146          total_Supply = _totalsupply;
147      }
148     
149     // What is the balance of a particular account?
150      function balanceOf(address _owner)public view returns (uint256 balance) {
151          return balances[_owner];
152      }
153     
154     // Send _value amount of tokens from address _from to address _to
155      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
156      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
157      // fees in sub-currencies; the command should fail unless the _from account has
158      // deliberately authorized the sender of the message via some mechanism; we propose
159      // these standardized APIs for approval:
160      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
161      require( _to != 0x0);
162      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
163      balances[_from] = (balances[_from]).sub(_amount);
164      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
165      balances[_to] = (balances[_to]).add(_amount);
166      Transfer(_from, _to, _amount);
167      return true;
168          }
169     
170    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
171      // If this function is called again it overwrites the current allowance with _value.
172      function approve(address _spender, uint256 _amount)public returns (bool success) {
173          require( _spender != 0x0);
174          allowed[msg.sender][_spender] = _amount;
175          Approval(msg.sender, _spender, _amount);
176          return true;
177      }
178   
179      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
180          require( _owner != 0x0 && _spender !=0x0);
181          return allowed[_owner][_spender];
182    }
183 
184      // Transfer the balance from owner's account to another account
185      function transfer(address _to, uint256 _amount)public returns (bool success) {
186         require( _to != 0x0);
187         require(balances[msg.sender] >= _amount && _amount >= 0);
188         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
189         balances[_to] = (balances[_to]).add(_amount);
190         Transfer(msg.sender, _to, _amount);
191              return true;
192          }
193     
194           // Transfer the balance from owner's account to another account
195     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
196         require( _to != 0x0);       
197         require(balances[address(this)] >= _amount && _amount > 0);
198         balances[address(this)] = (balances[address(this)]).sub(_amount);
199         balances[_to] = (balances[_to]).add(_amount);
200         Transfer(address(this), _to, _amount);
201         return true;
202         }
203     
204     
205     function drain() external onlyOwner {
206         owner.transfer(this.balance);
207     }
208     
209 }