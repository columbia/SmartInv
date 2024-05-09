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
36   contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address _owner)public view returns (uint256 balance);
39   function allowance(address _owner, address _spender)public view returns (uint remaining);
40   function transferFrom(address _from, address _to, uint _amount)public returns (bool ok);
41   function approve(address _spender, uint _amount)public returns (bool ok);
42   function transfer(address _to, uint _amount)public returns (bool ok);
43   event Transfer(address indexed _from, address indexed _to, uint _amount);
44   event Approval(address indexed _owner, address indexed _spender, uint _amount);
45 }
46 
47 
48 contract AdBank is ERC20
49 { using SafeMath for uint256;
50 
51    string public constant symbol = "ADB";
52    string public constant name = "AdBank";
53    uint8 public constant decimals = 18;
54    uint256 _totalSupply = (1000000000) * (10 **18); //1 billion total supply
55       
56      // Owner of this contract
57     address public owner;
58     bool stopped = true;
59     // total ether received in the contract
60     uint256 public eth_received;
61     // ico startdate
62     uint256 startdate;
63     //ico enddate;
64     uint256 enddate;
65   
66      // Balances for each account
67      mapping(address => uint256) balances;
68   
69      // Owner of account approves the transfer of an amount to another account
70      mapping(address => mapping (address => uint256)) allowed;
71  
72       enum Stages {
73         NOTSTARTED,
74         ICO,
75         PAUSED,
76         ENDED
77     }
78     
79     Stages public stage;
80     uint256 received;
81     uint256 refund;
82     bool ico_ended = false;
83 
84 // Functions with this modifier can only be executed by the owner
85      modifier onlyOwner() {
86          require (msg.sender == owner);
87           _;
88      }
89      
90     modifier atStage(Stages _stage) {
91         require(stage == _stage);
92         _;
93     }
94   
95      // Constructor
96      function AdBank() public {
97          owner = msg.sender;
98          balances[owner] = _totalSupply;
99          stage = Stages.NOTSTARTED;
100          Transfer(0, owner, balances[owner]);
101      }
102      
103      
104      function () public payable atStage(Stages.ICO)
105     {
106        
107         require(received < 44000 ether);
108         require(!ico_ended && !stopped && now <= enddate);
109         received = (eth_received).add(msg.value);
110         if (received > 44000 ether){
111         refund = received.sub(44000 ether);
112         msg.sender.transfer(refund);
113         eth_received = 44000 ether;
114         }
115         else {
116             eth_received = (eth_received).add(msg.value);
117         }
118         
119     }
120    
121     function StartICO() external onlyOwner atStage(Stages.NOTSTARTED) 
122     {
123         stage = Stages.ICO;
124         stopped = false;
125         startdate = now;
126         enddate = now.add(39 days);
127     }
128     
129     function EmergencyStop() external onlyOwner atStage(Stages.ICO)
130     {
131         stopped = true;
132         stage = Stages.PAUSED;
133     }
134     
135     function ResumeEmergencyStop() external onlyOwner atStage(Stages.PAUSED)
136     {
137         stopped = false;
138         stage = Stages.ICO;
139     }
140     
141      function end_ICO() external onlyOwner atStage(Stages.ICO)
142      {
143          require(now > enddate);
144          ico_ended = true;
145          stage = Stages.ENDED;
146      }
147   
148    function drain() external onlyOwner {
149         owner.transfer(this.balance);
150     }
151 
152     // what is the total supply of the ech tokens
153      function totalSupply() public view returns (uint256 total_Supply) {
154          total_Supply = _totalSupply;
155      }
156   
157      // What is the balance of a particular account?
158      function balanceOf(address _owner)public view returns (uint256 balance) {
159          return balances[_owner];
160      }
161   
162      // Transfer the balance from owner's account to another account
163      function transfer(address _to, uint256 _amount)public returns (bool ok) {
164         require( _to != 0x0);
165         require(balances[msg.sender] >= _amount && _amount >= 0);
166         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
167         balances[_to] = (balances[_to]).add(_amount);
168         Transfer(msg.sender, _to, _amount);
169              return true;
170          }
171   
172      // Send _value amount of tokens from address _from to address _to
173      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
174      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
175      // fees in sub-currencies; the command should fail unless the _from account has
176      // deliberately authorized the sender of the message via some mechanism; we propose
177      // these standardized APIs for approval:
178      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool ok) {
179      require( _to != 0x0);
180      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
181      balances[_from] = (balances[_from]).sub(_amount);
182      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
183      balances[_to] = (balances[_to]).add(_amount);
184      Transfer(_from, _to, _amount);
185      return true;
186          }
187  
188      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
189      // If this function is called again it overwrites the current allowance with _value.
190      function approve(address _spender, uint256 _amount)public returns (bool ok) {
191          require( _spender != 0x0);
192          allowed[msg.sender][_spender] = _amount;
193          Approval(msg.sender, _spender, _amount);
194          return true;
195      }
196   
197      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
198          require( _owner != 0x0 && _spender !=0x0);
199          return allowed[_owner][_spender];
200    }
201    
202    //In case the ownership needs to be transferred
203 	function transferOwnership(address newOwner)public onlyOwner
204 	{
205 	    require( newOwner != 0x0);
206 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
207 	    balances[owner] = 0;
208 	    owner = newOwner;
209 	}
210 
211 }