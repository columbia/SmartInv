1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13 
14  
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38  
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 
48 
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   uint256 totalSupply_;
55 
56  
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61  
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73  
74   function balanceOf(address _owner) public view returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public view returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 
89 
90 contract StandardToken is ERC20, BasicToken {
91 
92   mapping (address => mapping (address => uint256)) internal allowed;
93 
94 
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[_from]);
98     require(_value <= allowed[_from][msg.sender]);
99 
100     balances[_from] = balances[_from].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103     Transfer(_from, _to, _value);
104     return true;
105   }
106 
107 
108   function approve(address _spender, uint256 _value) public returns (bool) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114 
115   function allowance(address _owner, address _spender) public view returns (uint256) {
116     return allowed[_owner][_spender];
117   }
118 
119  
120   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
121     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
122     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123     return true;
124   }
125 
126  
127   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
128     uint oldValue = allowed[msg.sender][_spender];
129     if (_subtractedValue > oldValue) {
130       allowed[msg.sender][_spender] = 0;
131     } else {
132       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
133     }
134     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135     return true;
136   }
137 
138 }
139 
140 
141 contract IChain is StandardToken {
142   string public name = 'I Chain';
143   string public symbol = 'ISC';
144   uint8 public decimals = 18;
145   uint public totalSupply = 1000000000 ether;
146   
147    address public beneficiary;  
148    address public owner; 
149    
150     uint256 public fundingGoal ;   
151 	
152     uint256 public amountRaised ;   
153 	
154 	uint256 public amountRaisedIsc ;  
155   
156   
157   uint256 public price;
158   
159   uint256 public totalDistributed = 800000000 ether;
160   
161   uint256 public totalRemaining;
162 
163   
164   uint256 public tokenReward = totalSupply.sub(totalDistributed);
165 
166      bool public fundingGoalReached = false;  
167      bool public crowdsaleClosed = false;  
168   
169     
170     event GoalReached(address recipient, uint totalAmountRaised);
171     event FundTransfer(address backer, uint amounteth, bool isContribution);
172   
173   function IChain(address ifSuccessfulSendTo,
174         uint fundingGoalInEthers,
175 		uint _price
176          ) public {
177 		
178 			beneficiary = ifSuccessfulSendTo;
179             fundingGoal = fundingGoalInEthers * 1 ether;       
180             price = _price;          
181 			owner = msg.sender;
182 			balances[msg.sender] = totalDistributed;
183 			
184   }
185  
186     modifier canDistr() {
187         require(!crowdsaleClosed);
188         _;
189     }
190 	  modifier onlyOwner() {
191         require(msg.sender == owner);
192         _;
193     }
194    
195 	
196 	
197    function () external payable {
198 		
199 		require(!crowdsaleClosed);
200 		require(!fundingGoalReached);
201         getTokens();
202      }	 
203 	
204 	
205 	
206   function finishDistribution() onlyOwner canDistr  public returns (bool) {
207 		
208 		
209         crowdsaleClosed = true;
210 		
211 		uint256 amount = tokenReward.sub(amountRaisedIsc);
212 		
213 		balances[beneficiary] = balances[beneficiary].add(amount);	
214 		
215 		
216 		require(msg.sender.call.value(amountRaised)());	
217 				
218         return true;
219     }	
220  
221   function extractTokenEth(uint amount) onlyOwner  public returns (bool) {	 
222 		require(msg.sender.call.value(amount)());			
223         return true;
224     }		
225 
226 	
227   function getTokens() payable{
228 			
229 		if (amountRaised >= fundingGoal) {
230             fundingGoalReached = true;
231 			return;
232         } 			
233         address investor = msg.sender; 
234 		uint amount = msg.value;
235         distr(investor,amount);	
236     }
237 	
238 	 
239     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
240 		
241 		amountRaised += _amount;		
242 		
243 		_amount=_amount.mul(price);
244 	 	
245 		amountRaisedIsc += _amount;
246 		
247         balances[_to] = balances[_to].add(_amount);		
248         FundTransfer(msg.sender,_amount,true);
249 		  		
250         return true;           
251 		
252     }
253 
254   
255 }