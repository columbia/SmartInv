1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8   function add(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a + b;
10     assert(c >= a);
11     return c;
12   }
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14 		if (a == 0) {
15 			return 0;
16 		}
17     c = a * b;
18     assert(c / a == b);
19     return c;
20 	}
21 }
22 
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32 
33   mapping(address => uint256) balances;
34 
35   uint256 totalSupply_;
36 
37   function totalSupply() public view returns (uint256) {
38     return totalSupply_;
39   }
40 
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_to != address(0));
43     require(_value <= balances[msg.sender]);
44 
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     emit Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function balanceOf(address _owner) public view returns (uint256 balance) {
52     return balances[_owner];
53   }
54 
55 }
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 contract BurnableToken is BasicToken {
63   event Burn(address indexed burner, uint256 value);
64   function burn(uint256 _value) public {
65     _burn(msg.sender, _value);
66   }
67   function _burn(address _who, uint256 _value) internal {
68     require(_value <= balances[_who]);
69     balances[_who] = balances[_who].sub(_value);
70     totalSupply_ = totalSupply_.sub(_value);
71     emit Burn(_who, _value);
72     emit Transfer(_who, address(0), _value);
73   }
74 }
75 contract StandardToken is ERC20, BurnableToken {
76   mapping (address => mapping (address => uint256)) internal allowed;
77   function transferFrom(
78     address _from,
79     address _to,
80     uint256 _value
81   )
82     public
83     returns (bool)
84   {
85     require(_to != address(0));
86     require(_value <= balances[_from]);
87     require(_value <= allowed[_from][msg.sender]);
88 
89     balances[_from] = balances[_from].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92     emit Transfer(_from, _to, _value);
93     return true;
94   }
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100   function allowance(
101     address _owner,
102     address _spender
103    )
104     public
105     view
106     returns (uint256)
107   {
108     return allowed[_owner][_spender];
109   }
110   function increaseApproval(
111     address _spender,
112     uint _addedValue
113   )
114     public
115     returns (bool)
116   {
117     allowed[msg.sender][_spender] = (
118       allowed[msg.sender][_spender].add(_addedValue));
119     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122   function decreaseApproval(
123     address _spender,
124     uint _subtractedValue
125   )
126     public
127     returns (bool)
128   {
129     uint oldValue = allowed[msg.sender][_spender];
130     if (_subtractedValue > oldValue) {
131       allowed[msg.sender][_spender] = 0;
132     } else {
133       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134     }
135     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 }
139 
140 contract UniDAG is StandardToken{
141 
142   string public constant name = "UniDAG";
143   string public constant symbol = "UDAG";
144   uint8 public constant decimals = 18;
145   address public owner;
146   address public CrowdsaleContract;
147 
148   constructor () public {
149    	//Token Distribution
150      totalSupply_ = 60600000e18;
151 	owner = 0x653859383f60741880f377085Ec44Cf75702C373;
152 	CrowdsaleContract = msg.sender;
153     balances[msg.sender] = 30300000e18;
154 	
155 	//Airdrop
156 	balances[0x1b3481e6c425baD0C8C44e563553BADF8Aca9415] = 6060000e18;
157 
158 	//Partnership
159 	balances[0x174cc6965Dd694f3BCE8B51434b7972ed8497374] = 7575000e18;
160 
161 	//Marketing 
162 	balances[0xF4A966739FF81B09CDb075Bf896B5Bd943C50f52] = 7575000e18;
163 
164 	//Bounty 
165 	balances[0x42373a7cE8dBF539e0b39D25C3F5064CFabBE227] = 9090000e18;
166   }
167   modifier onlyOwner() {
168         require(msg.sender == owner);
169         _;
170 	}
171 
172   function burnCrowdsale() public onlyOwner {
173     _burn(CrowdsaleContract, balances[CrowdsaleContract]);
174   }
175 }
176 
177 contract UniDAGCrowdsale {
178     using SafeMath for uint256;	
179     UniDAG public token;
180     address public owner;	
181     uint256 public rateFirstRound = 4000;
182     uint256 public rateSecondRound = 3500;
183     uint256 public rateThirdRound = 3000;
184 
185 	uint256 public openingTime = 1530403200;             
186    	//1.07.2018 0:00:00 GMT+0
187 
188 	uint256 public secondRoundTime = 1539129600;      
189  	//10.10.2018 0:00:00 GMT+0
190 
191 	uint256 public thirdRoundTime = 1547856000;        
192   	//19.01.2019 0:00:00 GMT+0
193 
194 	uint256 public closingTime = 1556582399;               
195  	 //29.04.2019 23:59:59 GMT +0
196 	
197 	uint256 public weiRaised;
198     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 timestamp);
199 	
200 	modifier onlyWhileOpen {
201 		require(block.timestamp >= openingTime && block.timestamp <= closingTime);
202 		_;
203 	}
204     constructor () public {	
205         token = new UniDAG();
206         owner = msg.sender;
207     }
208     function () external payable {
209         buyTokens(msg.sender);
210     }
211     function buyTokens(address _beneficiary) public payable {
212         uint256 weiAmount = msg.value;
213         _preValidatePurchase(_beneficiary, weiAmount);
214         uint256 tokens = _getTokenAmount(weiAmount);
215         weiRaised = weiRaised.add(weiAmount);
216         _processPurchase(_beneficiary, tokens);
217         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens, block.timestamp);
218         _forwardFunds();
219     }
220     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) view internal onlyWhileOpen {
221         require(_beneficiary != address(0));
222    
223  //Minimum 0.01 ETH
224 
225         require(_weiAmount >= 10e15);
226     }
227     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
228         token.transfer(_beneficiary, _tokenAmount);
229     }
230     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
231         _deliverTokens(_beneficiary, _tokenAmount);
232     }
233     function _getTokenAmount(uint256 _weiAmount) view internal returns (uint256) {
234         if(block.timestamp < secondRoundTime) return _weiAmount.mul(rateFirstRound);
235         if(block.timestamp < thirdRoundTime) return _weiAmount.mul(rateSecondRound);
236 		return _weiAmount.mul(rateThirdRound);
237     }
238     function _forwardFunds() internal {
239         owner.transfer(msg.value);
240     }
241 }