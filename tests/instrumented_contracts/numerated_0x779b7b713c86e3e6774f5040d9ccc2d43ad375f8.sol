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
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138 	//Returns the account balance 
139     function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
140         return balance[_owner];
141     }
142 
143     //Allows contract owner to mint new tokens, prevents numerical overflow
144 	function mintToken(address target, uint256 mintedAmount) onlyOwner returns (bool success) {
145 		require(mintedAmount > 0); 
146         uint256 addTokens = mintedAmount; 
147 		balance[target] += addTokens;
148 		totalSupply += addTokens;
149 		Transfer(0, target, addTokens);
150 		return true; 
151 	}
152 
153 	//Sends tokens from sender's account
154     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
155         if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
156             balance[msg.sender] -= _value;
157             balance[_to] += _value;
158             Transfer(msg.sender, _to, _value);
159             return true;
160         } else { 
161 			return false; 
162 		}
163     }
164 	
165 	//Transfers tokens from an approved account 
166     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
167         if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
168             balance[_to] += _value;
169             balance[_from] -= _value;
170             allowed[_from][msg.sender] -= _value;
171             Transfer(_from, _to, _value);
172             return true;
173         } else { 
174 			return false; 
175 		}
176     }
177 }
178 
179 
180 contract StakePoolICO is Owned, StakePool {
181     //Applies SafeMath library to uint256 operations 
182     using SafeMath for uint256;
183 
184     //Public Variables
185     address public multiSigWallet;                  
186     uint256 public amountRaised; 
187     uint256 public dividendPayment;
188     uint256 public numberOfRecordEntries; 
189     uint256 public numberOfTokenHolders; 
190     uint256 public startTime; 
191     uint256 public stopTime; 
192     uint256 public hardcap; 
193     uint256 public price;                            
194 
195     //Variables
196     address[] recordTokenHolders; 
197     address[] tokenHolders; 
198     bool crowdsaleClosed = true; 
199     mapping (address => uint256) recordBalance; 
200     mapping (address => uint256) recordTokenHolderID;      
201     mapping (address => uint256) tokenHolderID;               
202     string tokenName = "StakePool"; 
203     string tokenSymbol = "POOL"; 
204     uint256 initialTokens = 20000000000000000; 
205     uint256 multiplier = 100000000; 
206     uint8 decimalUnits = 8;  
207 
208    	//Initializes the token
209 	function StakePoolICO() 
210     	StakePool(tokenName, tokenSymbol, decimalUnits, multiplier, initialTokens) {
211             balance[msg.sender] = initialTokens;     
212             Transfer(0, msg.sender, initialTokens);    
213             multiSigWallet = msg.sender;        
214             hardcap = 30000000000000000;    
215             setPrice(3000); 
216             dividendPayment = 50000000000000; 
217             recordTokenHolders.length = 2; 
218             tokenHolders.length = 2; 
219             tokenHolders[1] = msg.sender; 
220             numberOfTokenHolders++; 
221     }
222 
223     //Fallback function creates tokens and sends to investor when crowdsale is open
224     function () payable {
225         require((!crowdsaleClosed) 
226             && (now < stopTime) 
227             && (totalSupply.add(msg.value.mul(getPrice()).mul(multiplier).div(1 ether)) <= hardcap)); 
228         address recipient = msg.sender; 
229         amountRaised = amountRaised.add(msg.value.div(1 ether)); 
230         uint256 tokens = msg.value.mul(getPrice()).mul(multiplier).div(1 ether);
231         totalSupply = totalSupply.add(tokens);
232         balance[recipient] = balance[recipient].add(tokens);
233         require(multiSigWallet.send(msg.value)); 
234         Transfer(0, recipient, tokens);
235         if (tokenHolderID[recipient] == 0) {
236             addTokenHolder(recipient); 
237         }
238     }   
239 
240     //Adds an address to the recorrdEntry list
241     function addRecordEntry(address account) internal {
242         if (recordTokenHolderID[account] == 0) {
243             recordTokenHolderID[account] = recordTokenHolders.length; 
244             recordTokenHolders.length++; 
245             recordTokenHolders[recordTokenHolders.length.sub(1)] = account; 
246             numberOfRecordEntries++;
247         }
248     }
249 
250     //Adds an address to the tokenHolders list 
251     function addTokenHolder(address account) returns (bool success) {
252         bool status = false; 
253         if (balance[account] != 0) {
254             tokenHolderID[account] = tokenHolders.length;
255             tokenHolders.length++;
256             tokenHolders[tokenHolders.length.sub(1)] = account; 
257             numberOfTokenHolders++;
258             status = true; 
259         }
260         return status; 
261     }  
262 
263     //Allows the owner to create an record of token owners and their balances
264     function createRecord() internal {
265         for (uint i = 0; i < (tokenHolders.length.sub(1)); i++ ) {
266             address holder = getTokenHolder(i);
267             uint256 holderBal = balanceOf(holder); 
268             addRecordEntry(holder); 
269             recordBalance[holder] = holderBal; 
270         }
271     }
272 
273     //Returns the current price of the token for the crowdsale
274     function getPrice() returns (uint256 result) {
275         return price;
276     }
277 
278     //Returns record contents
279     function getRecordBalance(address record) constant returns (uint256) {
280         return recordBalance[record]; 
281     }
282 
283     //Returns the address of a specific index value
284     function getRecordHolder(uint256 index) constant returns (address) {
285         return address(recordTokenHolders[index.add(1)]); 
286     }
287 
288     //Returns time remaining on crowdsale
289     function getRemainingTime() constant returns (uint256) {
290         return stopTime; 
291     }
292 
293     //Returns the address of a specific index value
294 	function getTokenHolder(uint256 index) constant returns (address) {
295 		return address(tokenHolders[index.add(1)]);
296 	}
297 
298     //Pays out dividends to tokens holders of record, based on 500,000 token payment
299     function payOutDividend() onlyOwner returns (bool success) { 
300         createRecord(); 
301         uint256 volume = totalSupply; 
302         for (uint i = 0; i < (tokenHolders.length.sub(1)); i++) {
303             address payee = getTokenHolder(i); 
304             uint256 stake = volume.div(dividendPayment.div(multiplier));    
305             uint256 dividendPayout = balanceOf(payee).div(stake).mul(multiplier); 
306             balance[payee] = balance[payee].add(dividendPayout);
307             totalSupply = totalSupply.add(dividendPayout); 
308             Transfer(0, payee, dividendPayout);
309         }
310         return true; 
311     }
312 
313     //Sets the multisig wallet for a crowdsale
314     function setMultiSigWallet(address wallet) onlyOwner returns (bool success) {
315         multiSigWallet = wallet; 
316         return true; 
317     }
318 
319     //Sets the token price 
320     function setPrice(uint256 newPriceperEther) onlyOwner returns (uint256) {
321         require(newPriceperEther > 0); 
322         price = newPriceperEther; 
323         return price; 
324     }
325 
326     //Allows owner to start the crowdsale from the time of execution until a specified stopTime
327     function startSale(uint256 saleStart, uint256 saleStop) onlyOwner returns (bool success) {
328         require(saleStop > now);     
329         startTime = saleStart; 
330         stopTime = saleStop; 
331         crowdsaleClosed = false; 
332         return true; 
333     }
334 
335     //Allows owner to stop the crowdsale immediately
336     function stopSale() onlyOwner returns (bool success) {
337         stopTime = now; 
338         crowdsaleClosed = true;
339         return true; 
340     }
341 
342 }