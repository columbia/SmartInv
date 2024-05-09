1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20 {
5 	//Sets events and functions for ERC20 token
6 	event Approval(address indexed _owner, address indexed _spender, uint _value);
7 	event Transfer(address indexed _from, address indexed _to, uint _value);
8 	
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	function approve(address _spender, uint _value) returns (bool success);
11     function balanceOf(address _owner) constant returns (uint balance);
12     function transfer(address _to, uint _value) returns (bool success);
13     function transferFrom(address _from, address _to, uint _value) returns (bool success);
14 }
15 
16 
17 contract Owned {
18 	//Public variable
19     address public owner;
20 
21 	//Sets contract creator as the owner
22     function Owned() {
23         owner = msg.sender;
24     }
25 	
26 	//Sets onlyOwner modifier for specified functions
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 	//Allows for transfer of contract ownership
33     function transferOwnership(address newOwner) onlyOwner {
34         owner = newOwner;
35     }
36 }
37 
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }  
45 
46     function div(uint256 a, uint256 b) internal returns (uint256) {
47         // assert(b > 0); // Solidity automatically throws when dividing by 0
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return c;
51     }
52   
53     function mul(uint256 a, uint256 b) internal returns (uint256) {
54         uint256 c = a * b;
55         assert(a == 0 || c / a == b);
56         return c;
57     }
58 
59     function sub(uint256 a, uint256 b) internal returns (uint256) {
60         assert(b <= a);
61         return a - b;
62     }
63 }
64 
65 
66 contract BaseToken is ERC20, Owned {
67     //Applies SafeMath library to uint256 operations 
68     using SafeMath for uint256;
69 
70 	//Public variables
71 	string public name; 
72 	string public symbol; 
73 	uint256 public decimals;  
74     uint256 public initialTokens; 
75 	uint256 public totalSupply; 
76 	string public version;
77 
78 	//Creates arrays for balances
79     mapping (address => uint256) balance;
80     mapping (address => mapping (address => uint256)) allowed;
81 
82 	//Constructor
83 	function BaseToken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 initialAmount, string tokenVersion) {
84 		name = tokenName; 
85 		symbol = tokenSymbol; 
86 		decimals = decimalUnits; 
87         initialTokens = initialAmount; 
88 		version = tokenVersion;
89 	}
90 	
91 	//Provides the remaining balance of approved tokens from function approve 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93       return allowed[_owner][_spender];
94     }
95 
96 	//Allows for a certain amount of tokens to be spent on behalf of the account owner
97     function approve(address _spender, uint256 _value) returns (bool success) { 
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103 	//Returns the account balance 
104     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
105         return balance[_owner];
106     }
107 
108 	//Sends tokens from sender's account
109     function transfer(address _to, uint256 _value) returns (bool success) {
110         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
111             balance[msg.sender] -= _value;
112             balance[_to] += _value;
113             Transfer(msg.sender, _to, _value);
114             return true;
115         } else { 
116 			return false; 
117 		}
118     }
119 	
120 	//Transfers tokens from an approved account 
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
122         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
123             balance[_to] += _value;
124             balance[_from] -= _value;
125             allowed[_from][msg.sender] -= _value;
126             Transfer(_from, _to, _value);
127             return true;
128         } else { 
129 			return false; 
130 		}
131     }
132     
133 }
134 
135 contract AsspaceToken is Owned, BaseToken {
136     using SafeMath for uint256;
137 
138     uint256 public amountRaised; 
139     uint256 public deadline; 
140     uint256 public price;        
141     uint256 public maxPreIcoAmount = 8000000;  
142 	bool preIco = true;
143     
144 	function AsspaceToken() 
145 		BaseToken("ASSPACE Token Dev", "ASPD", 0, 100000000000, "1.0") {
146             balance[msg.sender] = initialTokens;    
147             setPrice(2500000);
148             deadline = now - 1 days;
149     }
150 
151     function () payable {
152         require((now < deadline) && 
153                  (msg.value.div(1 finney) >= 100) &&
154                 ((preIco && amountRaised.add(msg.value.div(1 finney)) <= maxPreIcoAmount) || !preIco)); 
155 
156         address recipient = msg.sender; 
157         amountRaised = amountRaised.add(msg.value.div(1 finney)); 
158         uint256 tokens = msg.value.mul(getPrice()).div(1 ether);
159         totalSupply = totalSupply.add(tokens);
160         balance[recipient] = balance[recipient].add(tokens);
161 		balance[owner] = balance[owner].sub(tokens);
162 		
163         require(owner.send(msg.value)); 
164 		
165         Transfer(0, recipient, tokens);
166     }   
167 
168     function setPrice(uint256 newPriceper) onlyOwner {
169         require(newPriceper > 0); 
170         
171         price = newPriceper; 
172     }
173 	
174 	function getPrice() constant returns (uint256) {
175 		return price;
176 	}
177 		
178     function startSale(uint256 lengthOfSale, bool isPreIco) onlyOwner {
179         require(lengthOfSale > 0); 
180         
181         preIco = isPreIco;
182         deadline = now + lengthOfSale * 1 days; 
183     }
184 
185     function stopSale() onlyOwner {
186         deadline = now;
187     }
188     
189 }