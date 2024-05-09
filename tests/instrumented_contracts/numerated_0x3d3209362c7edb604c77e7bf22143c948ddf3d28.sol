1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title DetailedERC20 token
36  * @dev The decimals are only for visualization purposes.
37  * All the operations are done using the smallest and indivisible token unit,
38  * just as on Ethereum all the operations are done in wei.
39  */
40 contract DetailedERC20 is ERC20 {
41   string public name;
42   string public symbol;
43   uint8 public decimals;
44 
45   constructor(string _name, string _symbol, uint8 _decimals) public {
46     name = _name;
47     symbol = _symbol;
48     decimals = _decimals;
49   }
50 }
51 
52 /**
53  * Crowdsale has a life span during which investors can make
54  * token purchases and the crowdsale will assign them tokens based
55  * on a token per ETH rate. Funds collected are forwarded to beneficiary
56  * as they arrive.
57  *
58  * A crowdsale is defined by:
59  *	offset (required) - crowdsale start, unix timestamp
60  *	length (required) - crowdsale length in seconds
61  *  price (required) - token price in wei
62  *	soft cap (optional) - minimum amount of funds required for crowdsale success, can be zero (if not used)
63  *	hard cap (optional) - maximum amount of funds crowdsale can accept, can be zero (unlimited)
64  *  quantum (optional) - enables value accumulation effect to reduce value transfer costs, usually is not used (set to zero)
65  *    if non-zero value passed specifies minimum amount of wei to transfer to beneficiary
66  *
67  * This crowdsale doesn't own tokens and doesn't perform any token emission.
68  * It expects enough tokens to be available on its address:
69  * these tokens are used for issuing them to investors.
70  * Token redemption is done in opposite way: tokens accumulate back on contract's address
71  * Beneficiary is specified by its address.
72  * This implementation can be used to make several crowdsales with the same token being sold.
73  */
74 contract Crowdsale {
75 	/**
76 	* Descriptive name of this Crowdsale. There could be multiple crowdsales for same Token.
77 	*/
78 	string public name;
79 
80 	// contract creator, owner of the contract
81 	// creator is also supplier of tokens
82 	address private creator;
83 
84 	// crowdsale start (unix timestamp)
85 	uint public offset;
86 
87 	// crowdsale length in seconds
88 	uint public length;
89 
90 	// one token price in wei
91 	uint public price;
92 
93 	// crowdsale minimum goal in wei
94 	uint public softCap;
95 
96 	// crowdsale maximum goal in wei
97 	uint public hardCap;
98 
99 	// minimum amount of value to transfer to beneficiary in automatic mode
100 	uint private quantum;
101 
102 	// how much value collected (funds raised)
103 	uint public collected;
104 
105 	// how many different addresses made an investment
106 	uint public investorsCount;
107 
108 	// how much value refunded (if crowdsale failed)
109 	uint public refunded;
110 
111 	// how much tokens issued to investors
112 	uint public tokensIssued;
113 
114 	// how much tokens redeemed and refunded (if crowdsale failed)
115 	uint public tokensRedeemed;
116 
117 	// how many successful transactions (with tokens being send back) do we have
118 	uint public transactions;
119 
120 	// how many refund transactions (in exchange for tokens) made (if crowdsale failed)
121 	uint public refunds;
122 
123 	// The token being sold
124 	DetailedERC20 private token;
125 
126 	// decimal coefficient (k) enables support for tokens with non-zero decimals
127 	uint k;
128 
129 	// address where funds are collected
130 	address public beneficiary;
131 
132 	// investor's mapping, required for token redemption in a failed crowdsale
133 	// making this field public allows to extend investor-related functionality in the future
134 	mapping(address => uint) public balances;
135 
136 	// events to log
137 	event InvestmentAccepted(address indexed holder, uint tokens, uint value);
138 	event RefundIssued(address indexed holder, uint tokens, uint value);
139 
140 	// a crowdsale is defined by a set of parameters passed here
141 	// make sure _end timestamp is in the future in order for crowdsale to be operational
142 	// _price must be positive, this is a price of one token in wei
143 	// _hardCap must be greater then _softCap or zero, zero _hardCap means unlimited crowdsale
144 	// _quantum may be zero, in this case there will be no value accumulation on the contract
145 	function Crowdsale(
146 		string _name,
147 		uint _offset,
148 		uint _length,
149 		uint _price,
150 		uint _softCap,
151 		uint _hardCap,
152 		uint _quantum,
153 		address _beneficiary,
154 		address _token
155 	) public {
156 
157 		// validate crowdsale settings (inputs)
158 		// require(_offset > 0); // we don't really care
159 		require(_length > 0);
160 		require(now < _offset + _length); // crowdsale must not be already finished
161 		// softCap can be anything, zero means crowdsale doesn't fail
162 		require(_hardCap > _softCap || _hardCap == 0);
163 		// hardCap must be greater then softCap
164 		// quantum can be anything, zero means no accumulation
165 		require(_price > 0);
166 		require(_beneficiary != address(0));
167 		require(_token != address(0));
168 
169 		name = _name;
170 
171 		// setup crowdsale settings
172 		offset = _offset;
173 		length = _length;
174 		softCap = _softCap;
175 		hardCap = _hardCap;
176 		quantum = _quantum;
177 		price = _price;
178 		creator = msg.sender;
179 
180 		// define beneficiary
181 		beneficiary = _beneficiary;
182 
183 		// allocate tokens: link and init coefficient
184 		__allocateTokens(_token);
185 	}
186 
187 	// accepts crowdsale investment, requires
188 	// crowdsale to be running and not reached its goal
189 	function invest() public payable {
190 		// perform validations
191 		assert(now >= offset && now < offset + length); // crowdsale is active
192 		assert(collected + price <= hardCap || hardCap == 0); // its still possible to buy at least 1 token
193 		require(msg.value >= price); // value sent is enough to buy at least one token
194 
195 		// call 'sender' nicely - investor
196 		address investor = msg.sender;
197 
198 		// how much tokens we must send to investor
199 		uint tokens = msg.value / price;
200 
201 		// how much value we must send to beneficiary
202 		uint value = tokens * price;
203 
204 		// ensure we are not crossing the hardCap
205 		if (value + collected > hardCap || hardCap == 0) {
206 			value = hardCap - collected;
207 			tokens = value / price;
208 			value = tokens * price;
209 		}
210 
211 		// update crowdsale status
212 		collected += value;
213 		tokensIssued += tokens;
214 
215 		// transfer tokens to investor
216 		__issueTokens(investor, tokens);
217 
218 		// transfer the change to investor
219 		investor.transfer(msg.value - value);
220 
221 		// accumulate the value or transfer it to beneficiary
222 		if (collected >= softCap && this.balance >= quantum) {
223 			// transfer all the value to beneficiary
224 			__beneficiaryTransfer(this.balance);
225 		}
226 
227 		// log an event
228 		InvestmentAccepted(investor, tokens, value);
229 	}
230 
231 	// refunds an investor of failed crowdsale,
232 	// requires investor to allow token transfer back
233 	function refund() public payable {
234 		// perform validations
235 		assert(now >= offset + length); // crowdsale ended
236 		assert(collected < softCap); // crowdsale failed
237 
238 		// call 'sender' nicely - investor
239 		address investor = msg.sender;
240 
241 		// find out how much tokens should be refunded
242 		uint tokens = __redeemAmount(investor);
243 
244 		// calculate refund amount
245 		uint refundValue = tokens * price;
246 
247 		// additional validations
248 		require(tokens > 0);
249 
250 		// update crowdsale status
251 		refunded += refundValue;
252 		tokensRedeemed += tokens;
253 		refunds++;
254 
255 		// transfer the tokens back
256 		__redeemTokens(investor, tokens);
257 
258 		// make a refund
259 		investor.transfer(refundValue + msg.value);
260 
261 		// log an event
262 		RefundIssued(investor, tokens, refundValue);
263 	}
264 
265 	// sends all the value to the beneficiary
266 	function withdraw() public {
267 		// perform validations
268 		assert(creator == msg.sender || beneficiary == msg.sender); // only creator or beneficiary can initiate this call
269 		assert(collected >= softCap); // crowdsale must be successful
270 		assert(this.balance > 0); // there should be something to transfer
271 
272 		// how much to withdraw (entire balance obviously)
273 		uint value = this.balance;
274 
275 		// perform the transfer
276 		__beneficiaryTransfer(value);
277 	}
278 
279 	// performs an investment, refund or withdrawal,
280 	// depending on the crowdsale status
281 	function() public payable {
282 		// started or finished
283 		require(now >= offset);
284 
285 		if(now < offset + length) {
286 			// crowdsale is running, invest
287 			invest();
288 		}
289 		else if(collected < softCap) {
290 			// crowdsale failed, try to refund
291 			refund();
292 		}
293 		else {
294 			// crowdsale is successful, investments are not accepted anymore
295 			// but maybe poor beneficiary is begging for change...
296 			withdraw();
297 		}
298 	}
299 
300 	// ----------------------- internal section -----------------------
301 
302 	// allocates token source (basically links token)
303 	function __allocateTokens(address _token) internal {
304 		// link tokens, tokens are not owned by a crowdsale
305 		// should be transferred to crowdsale after the deployment
306 		token = DetailedERC20(_token);
307 
308 		// obtain decimals and calculate coefficient k
309 		k = 10 ** uint(token.decimals());
310 	}
311 
312 	// transfers tokens to investor, validations are not required
313 	function __issueTokens(address investor, uint tokens) internal {
314 		// if this is a new investor update investor count
315 		if (balances[investor] == 0) {
316 			investorsCount++;
317 		}
318 
319 		// for open crowdsales we track investors balances
320 		balances[investor] += tokens;
321 
322 		// issue tokens, taking into account decimals
323 		token.transferFrom(creator, investor, tokens * k);
324 	}
325 
326 	// calculates amount of tokens available to redeem from investor, validations are not required
327 	function __redeemAmount(address investor) internal view returns (uint amount) {
328 		// round down allowance taking into account token decimals
329 		uint allowance = token.allowance(investor, this) / k;
330 
331 		// for open crowdsales we check previously tracked investor balance
332 		uint balance = balances[investor];
333 
334 		// return allowance safely by checking also the balance
335 		return balance < allowance ? balance : allowance;
336 	}
337 
338 	// transfers tokens from investor, validations are not required
339 	function __redeemTokens(address investor, uint tokens) internal {
340 		// for open crowdsales we track investors balances
341 		balances[investor] -= tokens;
342 
343 		// redeem tokens, taking into account decimals coefficient
344 		token.transferFrom(investor, creator, tokens * k);
345 	}
346 
347 	// transfers a value to beneficiary, validations are not required
348 	function __beneficiaryTransfer(uint value) internal {
349 		beneficiary.transfer(value);
350 	}
351 
352 	// !---------------------- internal section ----------------------!
353 }