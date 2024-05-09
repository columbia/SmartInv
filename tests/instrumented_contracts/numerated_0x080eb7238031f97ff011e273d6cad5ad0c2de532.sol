1 //Smart Contract code of KitToken
2 //KitToken.INC - All rights reserved
3 //https://kittoken.net
4 pragma solidity 0.4.21;
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract ERC20 {
40   function totalSupply()public view returns (uint total_Supply);
41   function balanceOf(address who)public view returns (uint256);
42   function allowance(address owner, address spender)public view returns (uint);
43   function transferFrom(address from, address to, uint value)public returns (bool ok);
44   function approve(address spender, uint value)public returns (bool ok);
45   function transfer(address to, uint value)public returns (bool ok);
46   event Transfer(address indexed from, address indexed to, uint value);
47   event Approval(address indexed owner, address indexed spender, uint value);
48 }
49 
50 
51 contract KITTOKEN is ERC20
52 { using SafeMath for uint256;
53     // Name of the token
54     string public constant name = "KitToken";
55 
56     // Symbol of token
57     string public constant symbol = "KIT";
58     uint8 public constant decimals = 18;
59     uint public _totalsupply = 8000000000 * 10 ** 18; // 8000 Millon inculding decimal precesion
60     address public owner;                    // Owner of this contract
61     uint256 public _price_tokn; 
62     uint256 no_of_tokens;
63     uint256 public pre_startdate;
64     uint256 public ico_startdate;
65     uint256 public pre_enddate;
66     uint256 public ico_enddate;
67     bool stopped = false;
68    
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71      address ethFundMain = 0xA2CB0448692571B6b933e41Fc3C5F89c1fF97055; 
72 
73     
74      enum Stages {
75         NOTSTARTED,
76         PRESALE,
77         ICO,
78         ENDED
79     }
80     Stages public stage;
81     
82     modifier atStage(Stages _stage) {
83         require(stage == _stage);
84         _;
85     }
86     
87      modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function KITTOKEN() public
93     {
94         
95          owner = msg.sender;
96         balances[owner] =6500000000 * 10 **18;  //6500 Million given to Owner
97         balances[address(this)]= 2500000000 * 10 **18;  //2500 Million given to Smart COntract
98         stage = Stages.NOTSTARTED;
99         emit Transfer(0, owner, balances[owner]);
100         emit  Transfer(0, address(this), balances[address(this)]);
101        
102     }
103     
104      function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
105       {
106           stage = Stages.PRESALE;
107           stopped = false;
108          _price_tokn = 6000;     // 1 Ether = 6000 coins
109           pre_startdate = now;
110           pre_enddate = now + 31 days;
111        
112           }
113     
114     function start_ICO() public onlyOwner atStage(Stages.PRESALE)
115       {
116         //  require(now > pre_enddate);
117           stage = Stages.ICO;
118           stopped = false;
119          _price_tokn = 3000;    // 1 Ether = 3000 coins
120           ico_startdate = now;
121           ico_enddate = now + 200 days;
122      
123       }
124   
125   
126     function () public payable 
127     {
128       require(msg.value >= .25 ether);
129         require(!stopped && msg.sender != owner);
130         
131           if( stage == Stages.PRESALE && now <= pre_enddate )
132             { 
133                 no_of_tokens =((msg.value).mul(_price_tokn));
134                 drain(msg.value);
135                 transferTokens(msg.sender,no_of_tokens);
136                }
137                
138                 else if(stage == Stages.ICO && now <= ico_enddate )
139             {
140              
141                no_of_tokens =((msg.value).mul(_price_tokn));
142                drain(msg.value);
143                transferTokens(msg.sender,no_of_tokens);
144             }
145         
146         else
147         {
148             revert();
149         }
150        
151     }
152      
153       
154     
155     // called by the owner, pause ICO
156     function StopICO() external onlyOwner 
157     {
158         stopped = true;
159        }
160 
161     // called by the owner , resumes ICO
162     function releaseICO() external onlyOwner 
163     {
164         
165         stopped = false;
166       }
167       
168       
169        function end_ICO() external onlyOwner
170      {
171           stage = Stages.ENDED;
172           uint256 x = balances[address(this)];
173          balances[owner] = (balances[owner]).add(balances[address(this)]);
174          balances[address(this)] = 0;
175        emit  Transfer(address(this), owner , x);
176          
177          
178      }
179 
180 
181     // what is the total supply of the xlmgold tokens
182      function totalSupply() public view returns (uint256 total_Supply) {
183          total_Supply = _totalsupply;
184      }
185     
186     // What is the balance of a particular account?
187      function balanceOf(address _owner)public view returns (uint256 balance) {
188          return balances[_owner];
189      }
190     
191     // Send _value amount of tokens from address _from to address _to
192      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
193      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
194      // fees in sub-currencies; the command should fail unless the _from account has
195      // deliberately authorized the sender of the message via some mechanism; we propose
196      // these standardized APIs for approval:
197      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
198      require( _to != 0x0);
199      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
200      balances[_from] = (balances[_from]).sub(_amount);
201      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
202      balances[_to] = (balances[_to]).add(_amount);
203     emit Transfer(_from, _to, _amount);
204      return true;
205          }
206     
207    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
208      // If this function is called again it overwrites the current allowance with _value.
209      function approve(address _spender, uint256 _amount)public returns (bool success) {
210          require( _spender != 0x0);
211          allowed[msg.sender][_spender] = _amount;
212        emit  Approval(msg.sender, _spender, _amount);
213          return true;
214      }
215   
216      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
217          require( _owner != 0x0 && _spender !=0x0);
218          return allowed[_owner][_spender];
219    }
220 
221      // Transfer the balance from owner's account to another account
222      function transfer(address _to, uint256 _amount)public returns (bool success) {
223         require( _to != 0x0);
224         require(balances[msg.sender] >= _amount && _amount >= 0);
225         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
226         balances[_to] = (balances[_to]).add(_amount);
227        emit Transfer(msg.sender, _to, _amount);
228              return true;
229          }
230     
231           // Transfer the balance from owner's account to another account
232     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
233         require( _to != 0x0);       
234         require(balances[address(this)] >= _amount && _amount > 0);
235         balances[address(this)] = (balances[address(this)]).sub(_amount);
236         balances[_to] = (balances[_to]).add(_amount);
237        emit Transfer(address(this), _to, _amount);
238         return true;
239         }
240     
241     
242     function drain(uint256 value) private {
243          
244         ethFundMain.transfer(value);
245     }
246     
247 }