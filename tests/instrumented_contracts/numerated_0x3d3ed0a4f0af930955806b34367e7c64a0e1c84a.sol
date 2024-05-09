1 pragma solidity ^0.4.11;
2 
3 /**
4 * @author Jefferson Davis
5 * ASStoken_ICO.sol creates the client's token for crowdsale and allocates an equity portion to the owner
6 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
7 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
8 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
9 *   Token contract edited from original contract code at https://www.ethereum.org/token
10 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
11 **/
12 
13 contract ERC20 {
14 	//Sets events and functions for ERC20 token
15 	event Approval(address indexed _owner, address indexed _spender, uint _value);
16 	event Transfer(address indexed _from, address indexed _to, uint _value);
17 	
18     function allowance(address _owner, address _spender) constant returns (uint remaining);
19 	function approve(address _spender, uint _value) returns (bool success);
20     function balanceOf(address _owner) constant returns (uint balance);
21     function transfer(address _to, uint _value) returns (bool success);
22     function transferFrom(address _from, address _to, uint _value) returns (bool success);
23 }
24 
25 
26 contract Owned {
27 	//Public variable
28     address public owner;
29 
30 	//Sets contract creator as the owner
31     function Owned() {
32         owner = msg.sender;
33     }
34 	
35 	//Sets onlyOwner modifier for specified functions
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41 	//Allows for transfer of contract ownership
42     function transferOwnership(address newOwner) onlyOwner {
43         owner = newOwner;
44     }
45 }
46 
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal returns (uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }  
54 
55     function div(uint256 a, uint256 b) internal returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60     }
61 
62     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
63         return a >= b ? a : b;
64     }
65 
66     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
67         return a >= b ? a : b;
68     }
69 
70     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
71         return a < b ? a : b;
72     }
73 
74     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
75         return a < b ? a : b;
76     }
77   
78     function mul(uint256 a, uint256 b) internal returns (uint256) {
79         uint256 c = a * b;
80         assert(a == 0 || c / a == b);
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal returns (uint256) {
85         assert(b <= a);
86         return a - b;
87     }
88 }
89 
90 
91 contract ASStoken is ERC20, Owned {
92     //Applies SafeMath library to uint256 operations 
93     using SafeMath for uint256;
94 
95 	//Public variables
96 	string public name; 
97 	string public symbol; 
98 	uint256 public decimals;  
99     uint256 public initialSupply; 
100 	uint256 public totalSupply; 
101 
102     //Variables
103     uint256 multiplier; 
104 	
105 	//Creates arrays for balances
106     mapping (address => uint256) balance;
107     mapping (address => mapping (address => uint256)) allowed;
108 
109     //Creates modifier to prevent short address attack
110     modifier onlyPayloadSize(uint size) {
111         if(msg.data.length < size + 4) revert();
112         _;
113     }
114 
115 	//Constructor
116 	function ASStoken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier, uint256 initialAmount) {
117 		name = tokenName; 
118 		symbol = tokenSymbol; 
119 		decimals = decimalUnits; 
120         multiplier = decimalMultiplier; 
121         initialSupply = initialAmount; 
122 		totalSupply = initialSupply;  
123 	}
124 	
125 	//Provides the remaining balance of approved tokens from function approve 
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127       return allowed[_owner][_spender];
128     }
129 
130 	//Allows for a certain amount of tokens to be spent on behalf of the account owner
131     function approve(address _spender, uint256 _value) returns (bool success) { 
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137 	//Returns the account balance 
138     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
139         return balance[_owner];
140     }
141 
142     //Allows contract owner to mint new tokens, prevents numerical overflow
143 	function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
144 		require(mintedAmount > 0); 
145         uint256 addTokens = mintedAmount; 
146 		balance[target] += addTokens;
147 		totalSupply += addTokens;
148 		Transfer(0, target, addTokens);
149 		return true; 
150 	}
151 
152 	//Sends tokens from sender's account
153     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
154         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
155             balance[msg.sender] -= _value;
156             balance[_to] += _value;
157             Transfer(msg.sender, _to, _value);
158             return true;
159         } else { 
160 			return false; 
161 		}
162     }
163 	
164 	//Transfers tokens from an approved account 
165     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
166         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
167             balance[_to] += _value;
168             balance[_from] -= _value;
169             allowed[_from][msg.sender] -= _value;
170             Transfer(_from, _to, _value);
171             return true;
172         } else { 
173 			return false; 
174 		}
175     }
176 }
177 
178 
179 contract ASStokenICO is Owned, ASStoken {
180     //Applies SafeMath library to uint256 operations 
181     using SafeMath for uint256;
182 
183     //Public Variables
184     address public multiSigWallet;                  
185     uint256 public amountRaised; 
186     uint256 public deadline; 
187     uint256 public hardcap; 
188     uint256 public price;                            
189 
190     //Variables
191     bool crowdsaleClosed = true;                    
192     string tokenName = "ASStoken"; 
193     string tokenSymbol = "ASS"; 
194     uint256 initialTokens = 150000000000; 
195     uint256 multiplier = 10000; 
196     uint8 decimalUnits = 4;  
197 
198     
199 
200    	//Initializes the token
201 	function ASStokenICO(address beneficiaryAccount) 
202     	ASStoken(tokenName, tokenSymbol, decimalUnits, multiplier, initialTokens) {
203             balance[msg.sender] = initialTokens;     
204             Transfer(0, msg.sender, initialTokens);    
205             multiSigWallet = beneficiaryAccount;        
206             hardcap = 55000000;    
207             hardcap = hardcap.mul(multiplier); 
208             setPrice(40000); 
209     }
210 
211     //Fallback function creates tokens and sends to investor when crowdsale is open
212     function () payable {
213         require(!crowdsaleClosed 
214             && (now < deadline) 
215             && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap)); 
216         address recipient = msg.sender; 
217         amountRaised = amountRaised.add(msg.value.div(1 ether)); 
218         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
219         totalSupply = totalSupply.add(tokens);
220         balance[recipient] = balance[recipient].add(tokens);
221         require(multiSigWallet.send(msg.value)); 
222         Transfer(0, recipient, tokens);
223     }   
224 
225     //Returns the current price of the token for the crowdsale
226     function getPrice() returns (uint256 result) {
227         return price;
228     }
229 
230     //Sets the multisig wallet for a crowdsale
231     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
232         multiSigWallet = wallet; 
233         return true; 
234     }
235 
236     //Sets the token price 
237     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
238         require(newPriceperEther > 0); 
239         price = newPriceperEther; 
240         return price; 
241     }
242 
243     //Allows owner to start the crowdsale from the time of execution until a specified deadline
244     function startSale(uint256 lengthOfSale) onlyOwner returns (bool success) {
245         deadline = now + lengthOfSale * 1 days; 
246         crowdsaleClosed = false; 
247         return true; 
248     }
249 
250     //Allows owner to stop the crowdsale immediately
251     function stopSale() onlyOwner returns (bool success) {
252         deadline = now; 
253         crowdsaleClosed = true;
254         return true; 
255     }
256 }