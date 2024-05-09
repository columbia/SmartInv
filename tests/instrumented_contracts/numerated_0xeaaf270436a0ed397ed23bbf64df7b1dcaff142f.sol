1 pragma solidity ^0.4.11;
2 
3 //------------------------------------------------------------------------------------------------
4 // LICENSE
5 //
6 // This file is part of BattleDrome.
7 // 
8 // BattleDrome is free software: you can redistribute it and/or modify
9 // it under the terms of the GNU General Public License as published by
10 // the Free Software Foundation, either version 3 of the License, or
11 // (at your option) any later version.
12 // 
13 // BattleDrome is distributed in the hope that it will be useful,
14 // but WITHOUT ANY WARRANTY; without even the implied warranty of
15 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16 // GNU General Public License for more details.
17 // 
18 // You should have received a copy of the GNU General Public License
19 // along with BattleDrome.  If not, see <http://www.gnu.org/licenses/>.
20 //------------------------------------------------------------------------------------------------
21 
22 //------------------------------------------------------------------------------------------------
23 // ERC20 Standard Token Implementation, based on ERC Standard:
24 // https://github.com/ethereum/EIPs/issues/20
25 // With some inspiration from ConsenSys HumanStandardToken as well
26 // Copyright 2017 BattleDrome
27 //------------------------------------------------------------------------------------------------
28 
29 contract ERC20Standard {
30 	uint public totalSupply;
31 	
32 	string public name;
33 	uint8 public decimals;
34 	string public symbol;
35 	string public version;
36 	
37 	mapping (address => uint256) balances;
38 	mapping (address => mapping (address => uint)) allowed;
39 
40 	//Fix for short address attack against ERC20
41 	modifier onlyPayloadSize(uint size) {
42 		assert(msg.data.length == size + 4);
43 		_;
44 	} 
45 
46 	function balanceOf(address _owner) constant returns (uint balance) {
47 		return balances[_owner];
48 	}
49 
50 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
51 		require(balances[msg.sender] >= _value && _value > 0);
52 	    balances[msg.sender] -= _value;
53 	    balances[_recipient] += _value;
54 	    Transfer(msg.sender, _recipient, _value);        
55     }
56 
57 	function transferFrom(address _from, address _to, uint _value) {
58 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
59         balances[_to] += _value;
60         balances[_from] -= _value;
61         allowed[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63     }
64 
65 	function approve(address _spender, uint _value) {
66 		allowed[msg.sender][_spender] = _value;
67 		Approval(msg.sender, _spender, _value);
68 	}
69 
70 	function allowance(address _spender, address _owner) constant returns (uint balance) {
71 		return allowed[_owner][_spender];
72 	}
73 
74 	//Event which is triggered to log all transfers to this contract's event log
75 	event Transfer(
76 		address indexed _from,
77 		address indexed _to,
78 		uint _value
79 		);
80 		
81 	//Event which is triggered whenever an owner approves a new allowance for a spender.
82 	event Approval(
83 		address indexed _owner,
84 		address indexed _spender,
85 		uint _value
86 		);
87 
88 }
89 
90 //------------------------------------------------------------------------------------------------
91 // FAME ERC20 Token, based on ERC20Standard interface
92 // Copyright 2017 BattleDrome
93 //------------------------------------------------------------------------------------------------
94 
95 contract FAMEToken is ERC20Standard {
96 
97 	function FAMEToken() {
98 		totalSupply = 2100000 szabo;			//Total Supply (including all decimal places!)
99 		name = "Fame";							//Pretty Name
100 		decimals = 12;							//Decimal places (with 12 decimal places 1 szabo = 1 token in uint256)
101 		symbol = "FAM";							//Ticker Symbol (3 characters, upper case)
102 		version = "FAME1.0";					//Version Code
103 		balances[msg.sender] = totalSupply;		//Assign all balance to creator initially for distribution from there.
104 	}
105 
106 	//Burn _value of tokens from your balance.
107 	//Will destroy the tokens, removing them from your balance, and reduce totalSupply accordingly.
108 	function burn(uint _value) {
109 		require(balances[msg.sender] >= _value && _value > 0);
110         balances[msg.sender] -= _value;
111         totalSupply -= _value;
112         Burn(msg.sender, _value);
113 	}
114 
115 	//Event to log any time someone burns tokens to the contract's event log:
116 	event Burn(
117 		address indexed _owner,
118 		uint _value
119 		);
120 
121 }
122 
123 //------------------------------------------------------------------------------------------------
124 // ICO Crowd Sale Contract
125 // Works like a kickstarter. Minimum goal required, or everyone gets their money back
126 // Contract holds all tokens, upon success (passing goal on time) sends out all bought tokens
127 // It then burns the rest.
128 // In the event of failure, it sends tokens back to creator, and all payments back to senders.
129 // Each time tokens are bought, a percentage is also issued to the "Developer" account.
130 // Pay-out of collected Ether to creators is managed through an Escrow address.
131 // Copyright 2017 BattleDrome
132 //------------------------------------------------------------------------------------------------
133 
134 contract BattleDromeICO {
135 	uint public constant ratio = 100 szabo;				//Ratio of how many tokens (in absolute uint256 form) are issued per ETH
136 	uint public constant minimumPurchase = 1 finney;	//Minimum purchase size (of incoming ETH)
137 	uint public constant startBlock = 3960000;			//Starting Block Number of Crowsd Sale
138 	uint public constant duration = 190000;				//16s block times 190k is about 35 days, from July 1st, to approx first Friday of August.
139 	uint public constant fundingGoal = 500 ether;		//Minimum Goal in Ether Raised
140 	uint public constant fundingMax = 20000 ether;		//Maximum Funds in Ether that we will accept before stopping the crowdsale
141 	uint public constant devRatio = 20;					//Ratio of Sold Tokens to Dev Tokens (ie 20 = 20:1 or 5%)
142 	address public constant tokenAddress 	= 0x190e569bE071F40c704e15825F285481CB74B6cC;	//Address of ERC20 Token Contract
143 	address public constant escrow 			= 0x50115D25322B638A5B8896178F7C107CFfc08144;	//Address of Escrow Provider Wallet
144 
145 	FAMEToken public Token;
146 	address public creator;
147 	uint public savedBalance;
148 	bool public creatorPaid = false;			//Has the creator been paid? 
149 
150 	mapping(address => uint) balances;			//Balances in incoming Ether
151 	mapping(address => uint) savedBalances;		//Saved Balances in incoming Ether (for after withdrawl validation)
152 
153 	//Constructor, initiate the crowd sale
154 	function BattleDromeICO() {
155 		Token = FAMEToken(tokenAddress);				//Establish the Token Contract to handle token transfers					
156 		creator = msg.sender;							//Establish the Creator address for receiving payout if/when appropriate.
157 	}
158 
159 	//Default Function, delegates to contribute function (for ease of use)
160 	//WARNING: Not compatible with smart contract invocation, will exceed gas stipend!
161 	//Only use from full wallets.
162 	function () payable {
163 		contribute();
164 	}
165 
166 	//Contribute Function, accepts incoming payments and tracks balances
167 	function contribute() payable {
168 		require(isStarted());								//Has the crowdsale even started yet?
169 		require(this.balance<=fundingMax); 					//Does this payment send us over the max?
170 		require(msg.value >= minimumPurchase);              //Require that the incoming amount is at least the minimum purchase size.
171 		require(!isComplete()); 							//Has the crowdsale completed? We only want to accept payments if we're still active.
172 		balances[msg.sender] += msg.value;					//If all checks good, then accept contribution and record new balance.
173 		savedBalances[msg.sender] += msg.value;		    	//Save contributors balance for later	
174 		savedBalance += msg.value;							//Save the balance for later when we're doing pay-outs so we know what it was.
175 		Contribution(msg.sender,msg.value,now);             //Woohoo! Log the new contribution!
176 	}
177 
178 	//Function to view current token balance of the crowdsale contract
179 	function tokenBalance() constant returns(uint balance) {
180 		return Token.balanceOf(address(this));
181 	}
182 
183 	//Function to check if crowdsale has started yet, have we passed the start block?
184 	function isStarted() constant returns(bool) {
185 		return block.number >= startBlock;
186 	}
187 
188 	//Function to check if crowdsale is complete (have we eigher hit our max, or passed the crowdsale completion block?)
189 	function isComplete() constant returns(bool) {
190 		return (savedBalance >= fundingMax) || (block.number > (startBlock + duration));
191 	}
192 
193 	//Function to check if crowdsale has been successful (has incoming contribution balance met, or exceeded the minimum goal?)
194 	function isSuccessful() constant returns(bool) {
195 		return (savedBalance >= fundingGoal);
196 	}
197 
198 	//Function to check the Ether balance of a contributor
199 	function checkEthBalance(address _contributor) constant returns(uint balance) {
200 		return balances[_contributor];
201 	}
202 
203 	//Function to check the Saved Ether balance of a contributor
204 	function checkSavedEthBalance(address _contributor) constant returns(uint balance) {
205 		return savedBalances[_contributor];
206 	}
207 
208 	//Function to check the Token balance of a contributor
209 	function checkTokBalance(address _contributor) constant returns(uint balance) {
210 		return (balances[_contributor] * ratio) / 1 ether;
211 	}
212 
213 	//Function to check the current Tokens Sold in the ICO
214 	function checkTokSold() constant returns(uint total) {
215 		return (savedBalance * ratio) / 1 ether;
216 	}
217 
218 	//Function to get Dev Tokens issued during ICO
219 	function checkTokDev() constant returns(uint total) {
220 		return checkTokSold() / devRatio;
221 	}
222 
223 	//Function to get Total Tokens Issued during ICO (Dev + Sold)
224 	function checkTokTotal() constant returns(uint total) {
225 		return checkTokSold() + checkTokDev();
226 	}
227 
228 	//function to check percentage of goal achieved
229 	function percentOfGoal() constant returns(uint16 goalPercent) {
230 		return uint16((savedBalance*100)/fundingGoal);
231 	}
232 
233 	//function to initiate payout of either Tokens or Ether payback.
234 	function payMe() {
235 		require(isComplete()); //No matter what must be complete
236 		if(isSuccessful()) {
237 			payTokens();
238 		}else{
239 			payBack();
240 		}
241 	}
242 
243 	//Function to pay back Ether
244 	function payBack() internal {
245 		require(balances[msg.sender]>0);						//Does the requester have a balance?
246 		balances[msg.sender] = 0;								//Ok, zero balance first to avoid re-entrance
247 		msg.sender.transfer(savedBalances[msg.sender]);			//Send them their saved balance
248 		PayEther(msg.sender,savedBalances[msg.sender],now); 	//Log payback of ether
249 	}
250 
251 	//Function to pay out Tokens
252 	function payTokens() internal {
253 		require(balances[msg.sender]>0);					//Does the requester have a balance?
254 		uint tokenAmount = checkTokBalance(msg.sender);		//If so, then let's calculate how many Tokens we owe them
255 		balances[msg.sender] = 0;							//Zero their balance ahead of transfer to avoid re-entrance (even though re-entrance here should be zero risk)
256 		Token.transfer(msg.sender,tokenAmount);				//And transfer the tokens to them
257 		PayTokens(msg.sender,tokenAmount,now);          	//Log payout of tokens to contributor
258 	}
259 
260 	//Function to pay the creator upon success
261 	function payCreator() {
262 		require(isComplete());										//Creator can only request payout once ICO is complete
263 		require(!creatorPaid);										//Require that the creator hasn't already been paid
264 		creatorPaid = true;											//Set flag to show creator has been paid.
265 		if(isSuccessful()){
266 			uint tokensToBurn = tokenBalance() - checkTokTotal();	//How many left-over tokens after sold, and dev tokens are accounted for? (calculated before we muck with balance)
267 			PayEther(escrow,this.balance,now);      				//Log the payout to escrow
268 			escrow.transfer(this.balance);							//We were successful, so transfer the balance to the escrow address
269 			PayTokens(creator,checkTokDev(),now);       			//Log payout of tokens to creator
270 			Token.transfer(creator,checkTokDev());					//And since successful, send DevRatio tokens to devs directly			
271 			Token.burn(tokensToBurn);								//Burn any excess tokens;
272 			BurnTokens(tokensToBurn,now);        					//Log the burning of the tokens.
273 		}else{
274 			PayTokens(creator,tokenBalance(),now);       			//Log payout of tokens to creator
275 			Token.transfer(creator,tokenBalance());					//We were not successful, so send ALL tokens back to creator.
276 		}
277 	}
278 	
279 	//Event to record new contributions
280 	event Contribution(
281 	    address indexed _contributor,
282 	    uint indexed _value,
283 	    uint indexed _timestamp
284 	    );
285 	    
286 	//Event to record each time tokens are paid out
287 	event PayTokens(
288 	    address indexed _receiver,
289 	    uint indexed _value,
290 	    uint indexed _timestamp
291 	    );
292 
293 	//Event to record each time Ether is paid out
294 	event PayEther(
295 	    address indexed _receiver,
296 	    uint indexed _value,
297 	    uint indexed _timestamp
298 	    );
299 	    
300 	//Event to record when tokens are burned.
301 	event BurnTokens(
302 	    uint indexed _value,
303 	    uint indexed _timestamp
304 	    );
305 
306 }