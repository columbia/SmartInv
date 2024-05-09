1 pragma solidity ^0.4.11;
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
28         if (msg.sender != owner) throw;
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
39 contract TokenWithMint is ERC20, Owned {
40 	//Public variables
41 	string public name; 
42 	string public symbol; 
43 	uint256 public decimals;  
44     uint256 multiplier; 
45 	uint256 public totalSupply; 
46 	
47 	//Creates arrays for balances
48     mapping (address => uint256) balance;
49     mapping (address => mapping (address => uint256)) allowed;
50 
51     //Creates modifier to prevent short address attack
52     modifier onlyPayloadSize(uint size) {
53         if(msg.data.length < size + 4) throw;
54         _;
55     }
56 
57 	//Constructor
58 	function TokenWithMint(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier) {
59 		name = tokenName; 
60 		symbol = tokenSymbol; 
61 		decimals = decimalUnits; 
62         multiplier = decimalMultiplier; 
63 		totalSupply = 0;  
64 	}
65 	
66 	//Provides the remaining balance of approved tokens from function approve 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
68       return allowed[_owner][_spender];
69     }
70 
71 	//Allows for a certain amount of tokens to be spent on behalf of the account owner
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78 	//Returns the account balance 
79     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
80         return balance[_owner];
81     }
82 
83     //Allows contract owner to mint new tokens, prevents numerical overflow
84 	function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
85 		if ((totalSupply + mintedAmount) < totalSupply) {
86 			throw; 
87 		} else {
88             uint256 addTokens = mintedAmount * multiplier; 
89 			balance[target] += addTokens;
90 			totalSupply += addTokens;
91 			Transfer(0, target, addTokens);
92 			return true; 
93 		}
94 	}
95 
96 	//Sends tokens from sender's account
97     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
98         if (balance[msg.sender] >= _value && balance[_to] + _value > balance[_to]) {
99             balance[msg.sender] -= _value;
100             balance[_to] += _value;
101             Transfer(msg.sender, _to, _value);
102             return true;
103         } else { 
104 			return false; 
105 		}
106     }
107 	
108 	//Transfers tokens from an approved account 
109     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
110         if (balance[_from] >= _value && allowed[_from][msg.sender] >= _value && balance[_to] + _value > balance[_to]) {
111             balance[_to] += _value;
112             balance[_from] -= _value;
113             allowed[_from][msg.sender] -= _value;
114             Transfer(_from, _to, _value);
115             return true;
116         } else { 
117 			return false; 
118 		}
119     }
120 }
121 
122 
123 library SafeMath {
124     function add(uint256 a, uint256 b) internal returns (uint256) {
125         uint256 c = a + b;
126         assert(c >= a);
127         return c;
128     }  
129 
130     function div(uint256 a, uint256 b) internal returns (uint256) {
131         // assert(b > 0); // Solidity automatically throws when dividing by 0
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134         return c;
135     }
136 
137     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
138         return a >= b ? a : b;
139     }
140 
141     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
142         return a >= b ? a : b;
143     }
144 
145     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
146         return a < b ? a : b;
147     }
148 
149     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
150         return a < b ? a : b;
151     }
152   
153     function mul(uint256 a, uint256 b) internal returns (uint256) {
154         uint256 c = a * b;
155         assert(a == 0 || c / a == b);
156         return c;
157     }
158 
159     function sub(uint256 a, uint256 b) internal returns (uint256) {
160         assert(b <= a);
161         return a - b;
162     }
163 }
164 
165 
166 contract PretherICO is Owned, TokenWithMint {
167     //Applies SafeMath library to uint256 operations 
168     using SafeMath for uint256;
169 
170     //Public Variables
171     address public multiSigWallet;                  
172     bool crowdsaleClosed = true;                    //initializes as true, requires owner to turn on crowdsale
173     string tokenName = "Prether"; 
174     string tokenSymbol = "PTH"; 
175     uint256 public amountRaised; 
176     uint256 public deadline; 
177     uint256 multiplier = 1; 
178     uint256 public price;                           
179     uint8 decimalUnits = 0;   
180     
181 
182    	//Initializes the token
183 	function PretherICO() 
184     	TokenWithMint(tokenName, tokenSymbol, decimalUnits, multiplier) {  
185             multiSigWallet = msg.sender;          
186     }
187 
188     //Fallback function creates tokens and sends to investor when crowdsale is open
189     function () payable {
190         require(!crowdsaleClosed && (now < deadline)); 
191         address recipient = msg.sender; 
192         amountRaised = amountRaised + msg.value; 
193         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
194         totalSupply = totalSupply.add(tokens);
195         balance[recipient] = balance[recipient].add(tokens);
196         require(multiSigWallet.send(msg.value)); 
197         Transfer(0, recipient, tokens);
198     }   
199 
200     //Returns the current price of the token for the crowdsale
201     function getPrice() returns (uint256 result) {
202         return price;
203     }
204 
205     //Returns time remaining on crowdsale
206     function getRemainingTime() constant returns (uint256) {
207         return deadline; 
208     }
209 
210     //Returns the current status of the crowdsale
211     function getSaleStatus() constant returns (bool) {
212         bool status = false; 
213         if (crowdsaleClosed == false) {
214             status = true; 
215         }
216         return status; 
217     }
218 
219     //Sets the multisig wallet for a crowdsale
220     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
221         multiSigWallet = wallet; 
222         return true; 
223     }
224 
225     //Sets the token price 
226     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
227         if (newPriceperEther <= 0) throw;  //checks for valid inputs
228         price = newPriceperEther; 
229         return price; 
230     }
231 
232     //Allows owner to start the crowdsale from the time of execution until a specified deadline
233     function startSale(uint256 price, uint256 hoursToEnd) onlyOwner returns (bool success) {
234         if ((hoursToEnd < 1 )) throw;     //checks for valid inputs 
235         price = setPrice(price); 
236         deadline = now + hoursToEnd * 1 hours; 
237         crowdsaleClosed = false; 
238         return true; 
239     }
240 
241     //Allows owner to start an unlimited crowdsale with no deadline or funding goal
242     function startUnlimitedSale(uint256 price) onlyOwner returns (bool success) {
243         price = setPrice(price); 
244         deadline = 9999999999;
245         crowdsaleClosed = false; 
246         return true; 
247     }
248 
249     //Allows owner to stop the crowdsale immediately
250     function stopSale() onlyOwner returns (bool success) {
251         deadline = now; 
252         crowdsaleClosed = true;
253         return true; 
254     }
255 
256 }