1 /**
2  * The Xmas Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
3  * Santa Claus doesn't kepp any shares and all tokens not being sold during the crowdsale (but the 
4  * reserved gift shares) are burned by the elves.
5  * 
6  * Author: Christmas Elf
7  * Audit: Rudolf the red nose Reindear
8  */
9 
10 pragma solidity ^0.4.15;
11 
12 /**
13  * Defines functions that provide safe mathematical operations.
14  */
15 library SafeMath {
16 	function mul(uint256 a, uint256 b) internal returns(uint256) {
17 		uint256 c = a * b;
18 		assert(a == 0 || c / a == b);
19 		return c;
20 	}
21 	
22 	function div(uint256 a, uint256 b) internal returns(uint256) {
23 		uint256 c = a / b;
24 		return c;
25 	}
26 
27 	function sub(uint256 a, uint256 b) internal returns(uint256) {
28 		assert(b <= a);
29 		return a - b;
30 	}
31 
32 	function add(uint256 a, uint256 b) internal returns(uint256) {
33 		uint256 c = a + b;
34 		assert(c >= a && c >= b);
35 		return c;
36 	}
37 }
38 
39 /**
40  * Implementation of Xmas Token contract.
41  */
42 contract XmasToken {
43     
44     using SafeMath for uint256; 
45 	
46 	// Xmas token basic data
47 	string constant public standard = "ERC20";
48 	string constant public symbol = "xmas";
49 	string constant public name = "XmasToken";
50 	uint8 constant public decimals = 18;
51 	
52 	// Xmas token distribution
53 	uint256 constant public initialSupply = 4000000 * 1 ether;
54 	uint256 constant public tokensForIco = 3000000 * 1 ether;
55 	uint256 constant public tokensForBonus = 1000000 * 1 ether;
56 	
57 	/** 
58 	 * Starting with this time tokens may be transfered.
59 	 */
60 	uint256 constant public startAirdropTime = 1514073600;
61 	
62 	/** 
63 	 * Starting with this time tokens may be transfered.
64 	 */
65 	uint256 public startTransferTime;
66 	
67 	/**
68 	 * Number of tokens sold in crowdsale
69 	 */
70 	uint256 public tokensSold;
71 
72 	/**
73 	 * true if tokens have been burned
74 	 */
75 	bool public burned;
76 
77 	mapping(address => uint256) public balanceOf;
78 	mapping(address => mapping(address => uint256)) public allowance;
79 	
80 	// -------------------- Crowdsale parameters --------------------
81 	
82 	/**
83 	 * the start date of the crowdsale 
84 	 */
85 	uint256 constant public start = 1510401600;
86 	
87 	/**
88 	 * the end date of the crowdsale 
89 	 */
90 	uint256 constant public end = 1512863999;
91 
92 	/**
93 	 * the exchange rate: 1 eth = 1000 xmas tokens
94 	 */
95 	uint256 constant public tokenExchangeRate = 1000;
96 	
97 	/**
98 	 * how much has been raised by crowdale (in ETH) 
99 	 */
100 	uint256 public amountRaised;
101 
102 	/**
103 	 * indicates if the crowdsale has been closed already 
104 	 */
105 	bool public crowdsaleClosed = false;
106 
107 	/**
108 	 * tokens will be transfered from this address 
109 	 */
110 	address public xmasFundWallet;
111 	
112 	/**
113 	 * the wallet on which the eth funds will be stored 
114 	 */
115 	address ethFundWallet;
116 	
117 	// -------------------- Events --------------------
118 	
119 	// public events on the blockchain that will notify listeners
120 	event Transfer(address indexed from, address indexed to, uint256 value);
121 	event Approval(address indexed _owner, address indexed spender, uint256 value);
122 	event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
123 	event Burn(uint256 amount);
124 
125 	/** 
126 	 * Initializes contract with initial supply tokens to the creator of the contract 
127 	 */
128 	function XmasToken(address _ethFundWallet) {
129 		ethFundWallet = _ethFundWallet;
130 		xmasFundWallet = msg.sender;
131 		balanceOf[xmasFundWallet] = initialSupply;
132 		startTransferTime = end;
133 	}
134 		
135 	/**
136 	 * Default function called whenever anyone sends funds to this contract.
137 	 * Only callable if the crowdsale started and hasn't been closed already and the tokens for icos haven't been sold yet.
138 	 * The current token exchange rate is looked up and the corresponding number of tokens is transfered to the receiver.
139 	 * The sent value is directly forwarded to a safe wallet.
140 	 * This method allows to purchase tokens in behalf of another address.
141 	 */
142 	function() payable {
143 		uint256 amount = msg.value;
144 		uint256 numTokens = amount.mul(tokenExchangeRate); 
145 		require(numTokens >= 100 * 1 ether);
146 		require(!crowdsaleClosed && now >= start && now <= end && tokensSold.add(numTokens) <= tokensForIco);
147 
148 		ethFundWallet.transfer(amount);
149 		
150 		balanceOf[xmasFundWallet] = balanceOf[xmasFundWallet].sub(numTokens); 
151 		balanceOf[msg.sender] = balanceOf[msg.sender].add(numTokens);
152 
153 		Transfer(xmasFundWallet, msg.sender, numTokens);
154 
155 		// update status
156 		amountRaised = amountRaised.add(amount);
157 		tokensSold += numTokens;
158 
159 		FundTransfer(msg.sender, amount, true, amountRaised);
160 	}
161 	
162 	/** 
163 	 * Sends the specified amount of tokens from msg.sender to a given address.
164 	 * @param _to the address to transfer to.
165 	 * @param _value the amount of tokens to be trasferred.
166 	 * @return true if the trasnfer is successful, false otherwise.
167 	 */
168 	function transfer(address _to, uint256 _value) returns(bool success) {
169 		require(now >= startTransferTime); 
170 
171 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
172 		balanceOf[_to] = balanceOf[_to].add(_value); 
173 
174 		Transfer(msg.sender, _to, _value); 
175 
176 		return true;
177 	}
178 
179 	/** 
180 	 * Allows another contract or person to spend the specified amount of tokens on behalf of msg.sender.
181 	 * @param _spender the address which will spend the funds.
182 	 * @param _value the amount of tokens to be spent.
183 	 * @return true if the approval is successful, false otherwise.
184 	 */
185 	function approve(address _spender, uint256 _value) returns(bool success) {
186 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
187 
188 		allowance[msg.sender][_spender] = _value;
189 
190 		Approval(msg.sender, _spender, _value);
191 
192 		return true;
193 	}
194 
195 	/** 
196 	 * Transfers tokens from one address to another address.
197 	 * This is only allowed if the token holder approves. 
198 	 * @param _from the address from which the given _value will be transfer.
199 	 * @param _to the address to which the given _value will be transfered.
200 	 * @param _value the amount of tokens which will be transfered from one address to another.
201 	 * @return true if the transfer was successful, false otherwise. 
202 	 */
203 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
204 		if (now < startTransferTime) 
205 			require(_from == xmasFundWallet);
206 		var _allowance = allowance[_from][msg.sender];
207 		require(_value <= _allowance);
208 		
209 		balanceOf[_from] = balanceOf[_from].sub(_value); 
210 		balanceOf[_to] = balanceOf[_to].add(_value); 
211 		allowance[_from][msg.sender] = _allowance.sub(_value);
212 
213 		Transfer(_from, _to, _value);
214 
215 		return true;
216 	}
217 	
218 	/** 
219 	 * Burns the remaining tokens except the gift share.
220 	 * To be called when ICO is closed. Anybody may burn the tokens after ICO ended, but only once.
221 	 */
222 	function burn() internal {
223 		require(now > startTransferTime);
224 		require(burned == false);
225 			
226 		uint256 difference = balanceOf[xmasFundWallet].sub(tokensForBonus);
227 		tokensSold = tokensForIco.sub(difference);
228 		balanceOf[xmasFundWallet] = tokensForBonus;
229 			
230 		burned = true;
231 
232 		Burn(difference);
233 	}
234 
235 	/**
236 	 * Marks the crowdsale as closed.
237 	 * Burns the unsold tokens, if any.
238 	 */
239 	function markCrowdsaleEnding() {
240 		require(now > end);
241 
242 		burn(); 
243 		crowdsaleClosed = true;
244 	}
245 	
246 	/**
247 	 * Sends the bonus tokens to addresses from Santa's list gift.
248 	 * @return true if the airdrop is successful, false otherwise.
249 	 */
250 	function sendGifts(address[] santaGiftList) returns(bool success)  {
251 		require(msg.sender == xmasFundWallet);
252 		require(now >= startAirdropTime);
253 	
254 		for(uint i = 0; i < santaGiftList.length; i++) {
255 		    uint256 tokensHold = balanceOf[santaGiftList[i]];
256 			if (tokensHold >= 100 * 1 ether) { 
257 				uint256 bonus = tokensForBonus.div(1 ether);
258 				uint256 giftTokens = ((tokensHold.mul(bonus)).div(tokensSold)) * 1 ether;
259 				transferFrom(xmasFundWallet, santaGiftList[i], giftTokens);
260 			}
261 		}
262 		
263 		return true;
264 	}
265 }