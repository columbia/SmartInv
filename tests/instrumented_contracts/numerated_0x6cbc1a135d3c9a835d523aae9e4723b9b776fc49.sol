1 pragma solidity ^0.4.11;
2 
3 /**
4 * @author Jefferson Davis
5 * StakePool_ICO.sol creates the client's token for crowdsale and allows for subsequent token sales and minting of tokens
6 *   In addition, there is a quarterly dividend payout triggered by the owner, plus creates a transaction record prior to payout
7 *   Crowdsale contracts edited from original contract code at https://www.ethereum.org/crowdsale#crowdfund-your-idea
8 *   Additional crowdsale contracts, functions, libraries from OpenZeppelin
9 *       at https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
10 *   Token contract edited from original contract code at https://www.ethereum.org/token
11 *   ERC20 interface and certain token functions adapted from https://github.com/ConsenSys/Tokens
12 **/
13 
14 contract ERC20 {
15 	//Sets events and functions for ERC20 token
16 	event Approval(address indexed _owner, address indexed _spender, uint _value);
17 	event Transfer(address indexed _from, address indexed _to, uint _value);
18 	
19     function allowance(address _owner, address _spender) constant returns (uint remaining);
20 	function approve(address _spender, uint _value) returns (bool success);
21     function balanceOf(address _owner) constant returns (uint balance);
22     function transfer(address _to, uint _value) returns (bool success);
23     function transferFrom(address _from, address _to, uint _value) returns (bool success);
24 }
25 
26 
27 contract Owned {
28 	//Public variable
29     address public owner;
30 
31 	//Sets contract creator as the owner
32     function Owned() {
33         owner = msg.sender;
34     }
35 	
36 	//Sets onlyOwner modifier for specified functions
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42 	//Allows for transfer of contract ownership
43     function transferOwnership(address newOwner) onlyOwner {
44         owner = newOwner;
45     }
46 }
47 
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }  
55 
56     function div(uint256 a, uint256 b) internal returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
64         return a >= b ? a : b;
65     }
66 
67     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
68         return a >= b ? a : b;
69     }
70 
71     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
72         return a < b ? a : b;
73     }
74 
75     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
76         return a < b ? a : b;
77     }
78   
79     function mul(uint256 a, uint256 b) internal returns (uint256) {
80         uint256 c = a * b;
81         assert(a == 0 || c / a == b);
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal returns (uint256) {
86         assert(b <= a);
87         return a - b;
88     }
89 }
90 
91 
92 contract StakePool is ERC20, Owned {
93      //Applies SafeMath library to uint256 operations 
94     using SafeMath for uint256;
95 
96 	//Public variables
97 	string public name; 
98 	string public symbol; 
99 	uint256 public decimals;  
100     uint256 public initialSupply; 
101 	uint256 public totalSupply; 
102 
103     //Variables
104     uint256 multiplier; 
105 	
106 	//Creates arrays for balances
107     mapping (address => uint256) balance;
108     mapping (address => mapping (address => uint256)) allowed;
109 
110     //Creates modifier to prevent short address attack
111     modifier onlyPayloadSize(uint size) {
112         if(msg.data.length < size + 4) revert();
113         _;
114     }
115 
116 	//Constructor
117 	function StakePool(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 decimalMultiplier, uint256 initialAmount) {
118 		name = tokenName; 
119 		symbol = tokenSymbol; 
120 		decimals = decimalUnits; 
121         multiplier = decimalMultiplier; 
122         initialSupply = initialAmount; 
123 		totalSupply = initialSupply;  
124 	}
125 	
126 	//Provides the remaining balance of approved tokens from function approve 
127     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128       return allowed[_owner][_spender];
129     }
130 
131 	//Allows for a certain amount of tokens to be spent on behalf of the account owner
132     function approve(address _spender, uint256 _value) returns (bool success) {
133         uint256 amount = _value.mul(multiplier); 
134         allowed[msg.sender][_spender] = amount;
135         Approval(msg.sender, _spender, amount);
136         return true;
137     }
138 
139 	//Returns the account balance 
140     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
141         return balance[_owner];
142     }
143 
144     //Allows contract owner to mint new tokens, prevents numerical overflow
145 	function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
146         uint256 addTokens = mintedAmount.mul(multiplier); 
147 		if ((totalSupply + addTokens) < totalSupply) {
148 			revert(); 
149 		} else {
150 			balance[target] += addTokens;
151 			totalSupply += addTokens;
152 			Transfer(0, target, addTokens);
153 			return true; 
154 		}
155 	}
156 
157 	//Sends tokens from sender's account
158     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
159         uint256 amount = _value.mul(multiplier); 
160         if (balance[msg.sender] >= amount && balance[_to] + amount > balance[_to]) {
161             balance[msg.sender] -= amount;
162             balance[_to] += amount;
163             Transfer(msg.sender, _to, amount);
164             return true;
165         } else { 
166 			return false; 
167 		}
168     }
169 	
170 	//Transfers tokens from an approved account 
171     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
172         uint256 amount = _value.mul(multiplier); 
173         if (balance[_from] >= amount && allowed[_from][msg.sender] >= amount && balance[_to] + amount > balance[_to]) {
174             balance[_to] += amount;
175             balance[_from] -= amount;
176             allowed[_from][msg.sender] -= amount;
177             Transfer(_from, _to, amount);
178             return true;
179         } else { 
180 			return false; 
181 		}
182     }
183 }
184 
185 
186 contract StakePoolICO is Owned, StakePool {
187     //Applies SafeMath library to uint256 operations 
188     using SafeMath for uint256;
189 
190     //Public Variables
191     address public multiSigWallet;                  
192     uint256 public amountRaised; 
193     uint256 public dividendPayment;
194     uint256 public numberOfRecordEntries; 
195     uint256 public numberOfTokenHolders; 
196     uint256 public startTime; 
197     uint256 public stopTime; 
198     uint256 public hardcap; 
199     uint256 public price;                            
200 
201     //Variables
202     address[] recordTokenHolders; 
203     address[] tokenHolders; 
204     bool crowdsaleClosed = true; 
205     mapping (address => uint256) recordBalance; 
206     mapping (address => uint256) recordTokenHolderID;      
207     mapping (address => uint256) tokenHolderID;               
208     string tokenName = "StakePool"; 
209     string tokenSymbol = "POOL"; 
210     uint256 initialTokens = 20000000000000000; 
211     uint256 multiplier = 10000000000; 
212     uint8 decimalUnits = 8;  
213 
214    	//Initializes the token
215 	function StakePoolICO() 
216     	StakePool(tokenName, tokenSymbol, decimalUnits, multiplier, initialTokens) {
217             balance[msg.sender] = initialTokens;     
218             Transfer(0, msg.sender, initialTokens);    
219             multiSigWallet = msg.sender;        
220             hardcap = 20100000000000000;    
221             setPrice(20); 
222             dividendPayment = 50000000000000; 
223             recordTokenHolders.length = 2; 
224             tokenHolders.length = 2; 
225             tokenHolders[1] = msg.sender; 
226             numberOfTokenHolders++; 
227     }
228 
229     //Fallback function creates tokens and sends to investor when crowdsale is open
230     function () payable {
231         require((!crowdsaleClosed) 
232             && (now < stopTime) 
233             && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap)); 
234         address recipient = msg.sender; 
235         amountRaised = amountRaised.add(msg.value.div(1 ether)); 
236         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
237         totalSupply = totalSupply.add(tokens);
238         balance[recipient] = balance[recipient].add(tokens);
239         require(multiSigWallet.send(msg.value)); 
240         Transfer(0, recipient, tokens);
241         if (tokenHolderID[recipient] == 0) {
242             addTokenHolder(recipient); 
243         }
244     }   
245 
246     //Adds an address to the recorrdEntry list
247     function addRecordEntry(address account) internal {
248         if (recordTokenHolderID[account] == 0) {
249             recordTokenHolderID[account] = recordTokenHolders.length; 
250             recordTokenHolders.length++; 
251             recordTokenHolders[recordTokenHolders.length.sub(1)] = account; 
252             numberOfRecordEntries++;
253         }
254     }
255 
256     //Adds an address to the tokenHolders list 
257     function addTokenHolder(address account) returns (bool success) {
258         bool status = false; 
259         if (balance[account] != 0) {
260             tokenHolderID[account] = tokenHolders.length;
261             tokenHolders.length++;
262             tokenHolders[tokenHolders.length.sub(1)] = account; 
263             numberOfTokenHolders++;
264             status = true; 
265         }
266         return status; 
267     }  
268 
269     //Allows the owner to create an record of token owners and their balances
270     function createRecord() internal {
271         for (uint i = 0; i < (tokenHolders.length.sub(1)); i++ ) {
272             address holder = getTokenHolder(i);
273             uint256 holderBal = balanceOf(holder); 
274             addRecordEntry(holder); 
275             recordBalance[holder] = holderBal; 
276         }
277     }
278 
279     //Returns the current price of the token for the crowdsale
280     function getPrice() returns (uint256 result) {
281         return price;
282     }
283 
284     //Returns record contents
285     function getRecordBalance(address record) constant returns (uint256) {
286         return recordBalance[record]; 
287     }
288 
289     //Returns the address of a specific index value
290     function getRecordHolder(uint256 index) constant returns (address) {
291         return address(recordTokenHolders[index.add(1)]); 
292     }
293 
294     //Returns time remaining on crowdsale
295     function getRemainingTime() constant returns (uint256) {
296         return stopTime; 
297     }
298 
299     //Returns the address of a specific index value
300 	function getTokenHolder(uint256 index) constant returns (address) {
301 		return address(tokenHolders[index.add(1)]);
302 	}
303 
304     //Pays out dividends to tokens holders of record, based on 500,000 token payment
305     function payOutDividend() onlyOwner returns (bool success) { 
306         createRecord(); 
307         uint256 volume = totalSupply; 
308         for (uint i = 0; i < (tokenHolders.length.sub(1)); i++) {
309             address payee = getTokenHolder(i); 
310             uint256 stake = volume.div(dividendPayment.div(multiplier));    
311             uint256 dividendPayout = balanceOf(payee).div(stake).mul(multiplier); 
312             balance[payee] = balance[payee].add(dividendPayout);
313             totalSupply = totalSupply.add(dividendPayout); 
314             Transfer(0, payee, dividendPayout);
315         }
316         return true; 
317     }
318 
319     //Sets the multisig wallet for a crowdsale
320     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
321         multiSigWallet = wallet; 
322         return true; 
323     }
324 
325     //Sets the token price 
326     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
327         require(newPriceperEther > 0); 
328         price = newPriceperEther; 
329         return price; 
330     }
331 
332     //Allows owner to start the crowdsale from the time of execution until a specified stopTime
333     function startSale(uint256 saleStart, uint256 saleStop) onlyOwner returns (bool success) {
334         require(saleStop > now);     
335         startTime = saleStart; 
336         stopTime = saleStop; 
337         crowdsaleClosed = false; 
338         return true; 
339     }
340 
341     //Allows owner to stop the crowdsale immediately
342     function stopSale() onlyOwner returns (bool success) {
343         stopTime = now; 
344         crowdsaleClosed = true;
345         return true; 
346     }
347 
348 }