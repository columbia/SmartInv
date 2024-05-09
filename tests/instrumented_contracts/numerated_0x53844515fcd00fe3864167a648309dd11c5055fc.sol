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
142   string public name = 'IChain';
143   string public symbol = 'ISC';
144   uint8 public decimals = 18;
145   uint public INITIAL_SUPPLY = 1000000000 ether;
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
164   uint256 public tokenReward = INITIAL_SUPPLY.sub(totalDistributed);
165 
166      bool public fundingGoalReached = false;  
167      bool public crowdsaleClosed = false;  
168   
169     
170   //  event GoalReached(address recipient, uint totalAmountRaised);
171    // event FundTransfer(address backer, uint amounteth, bool isContribution);
172   
173      event Transfer(address indexed _from, address indexed _to, uint256 _value);
174     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
175    event Distr(address indexed to, uint256 amount);
176   
177   function IChain(address ifSuccessfulSendTo,
178         uint fundingGoalInEthers,
179 		uint _price
180          ) public {
181 			totalSupply_ = INITIAL_SUPPLY;
182 			beneficiary = ifSuccessfulSendTo;
183             fundingGoal = fundingGoalInEthers * 1 ether;       
184             price = _price;          
185 			owner = msg.sender;
186 			balances[msg.sender] = totalDistributed;
187 			
188   }
189  
190     modifier canDistr() {
191         require(!crowdsaleClosed);
192         _;
193     }
194 	  modifier onlyOwner() {
195         require(msg.sender == owner);
196         _;
197     }
198    
199 	
200 	
201    function () external payable {
202 		
203 		require(!crowdsaleClosed);
204 		require(!fundingGoalReached);
205         getTokens();
206      }	 
207 	
208 	
209 	
210   function finishDistribution() onlyOwner canDistr  public returns (bool) {
211 		
212 		
213         crowdsaleClosed = true;
214 		
215 		uint256 amount = tokenReward.sub(amountRaisedIsc);
216 		
217 		balances[beneficiary] = balances[beneficiary].add(amount);	
218 		
219 		
220 		require(msg.sender.call.value(amountRaised)());	
221 				
222         return true;
223     }	
224  
225   //function extractTokenEth(uint amount) onlyOwner  public returns (bool) {	 
226 	//	require(msg.sender.call.value(amount)());			
227    //     return true;
228     //}		
229 
230 	
231   function getTokens() payable {
232 			
233 		if (amountRaised >= fundingGoal) {
234             fundingGoalReached = true;
235 			return;
236         } 			
237         address investor = msg.sender; 
238 		uint amount = msg.value;
239         distr(investor,amount);	
240     }
241 	
242 	function withdraw() onlyOwner public {
243         uint256 etherBalance = address(this).balance;
244         owner.transfer(etherBalance);
245     }
246 	 
247     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
248 		
249 		amountRaised += _amount;		
250 		
251 		_amount=_amount.mul(price);
252 	 	
253 		amountRaisedIsc += _amount;
254 		
255         balances[_to] = balances[_to].add(_amount);		
256 		
257 		emit Distr(_to, _amount);
258         emit Transfer(address(0), _to, _amount);
259        // FundTransfer(msg.sender,_amount,true);
260 		  		
261         return true;           
262 		
263     }
264 
265   
266 }