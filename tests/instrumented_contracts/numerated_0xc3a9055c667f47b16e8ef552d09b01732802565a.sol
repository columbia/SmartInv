1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
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
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract DetailedERC20 is ERC20 {
27   string public name;
28   string public symbol;
29   uint8 public decimals;
30 
31   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
32     name = _name;
33     symbol = _symbol;
34     decimals = _decimals;
35   }
36 }
37 
38 /**
39  * Crowdsale has a life span during which investors can make
40  * token purchases and the crowdsale will assign them tokens based
41  * on a token per ETH rate. Funds collected are forwarded to beneficiary
42  * as they arrive.
43  *
44  * A crowdsale is defined by:
45  *	offset (required) - crowdsale start, unix timestamp
46  *	length (required) - crowdsale length in seconds
47  *  price (required) - token price in wei
48  *	soft cap (optional) - minimum amount of funds required for crowdsale success, can be zero (if not used)
49  *	hard cap (optional) - maximum amount of funds crowdsale can accept, can be zero (unlimited)
50  *  quantum (optional) - enables value accumulation effect to reduce value transfer costs, usually is not used (set to zero)
51  *    if non-zero value passed specifies minimum amount of wei to transfer to beneficiary
52  *
53  * This crowdsale doesn't own tokens and doesn't perform any token emission.
54  * It expects enough tokens to be available on its address:
55  * these tokens are used for issuing them to investors.
56  * Token redemption is done in opposite way: tokens accumulate back on contract's address
57  * Beneficiary is specified by its address.
58  * This implementation can be used to make several crowdsales with the same token being sold.
59  */
60 contract Crowdsale {
61 	/**
62 	* Descriptive name of this Crowdsale. There could be multiple crowdsales for same Token.
63 	*/
64 	string public name;
65 
66 	// contract creator, owner of the contract
67 	// creator is also supplier of tokens
68 	address private creator;
69 
70 	// crowdsale start (unix timestamp)
71 	uint public offset;
72 
73 	// crowdsale length in seconds
74 	uint public length;
75 
76 	// one token price in wei
77 	uint public price;
78 
79 	// crowdsale minimum goal in wei
80 	uint public softCap;
81 
82 	// crowdsale maximum goal in wei
83 	uint public hardCap;
84 
85 	// minimum amount of value to transfer to beneficiary in automatic mode
86 	uint private quantum;
87 
88 	// how much value collected (funds raised)
89 	uint public collected;
90 
91 	// how many different addresses made an investment
92 	uint public investorsCount;
93 
94 	// how much value refunded (if crowdsale failed)
95 	uint public refunded;
96 
97 	// how much tokens issued to investors
98 	uint public tokensIssued;
99 
100 	// how much tokens redeemed and refunded (if crowdsale failed)
101 	uint public tokensRedeemed;
102 
103 	// how many successful transactions (with tokens being send back) do we have
104 	uint public transactions;
105 
106 	// how many refund transactions (in exchange for tokens) made (if crowdsale failed)
107 	uint public refunds;
108 
109 	// The token being sold
110 	DetailedERC20 private token;
111 
112 	// decimal coefficient (k) enables support for tokens with non-zero decimals
113 	uint k;
114 
115 	// address where funds are collected
116 	address public beneficiary;
117 
118 	// investor's mapping, required for token redemption in a failed crowdsale
119 	// making this field public allows to extend investor-related functionality in the future
120 	mapping(address => uint) public balances;
121 
122 	// events to log
123 	event InvestmentAccepted(address indexed holder, uint tokens, uint value);
124 	event RefundIssued(address indexed holder, uint tokens, uint value);
125 
126 	// a crowdsale is defined by a set of parameters passed here
127 	// make sure _end timestamp is in the future in order for crowdsale to be operational
128 	// _price must be positive, this is a price of one token in wei
129 	// _hardCap must be greater then _softCap or zero, zero _hardCap means unlimited crowdsale
130 	// _quantum may be zero, in this case there will be no value accumulation on the contract
131 	function Crowdsale(
132 		string _name,
133 		uint _offset,
134 		uint _length,
135 		uint _price,
136 		uint _softCap,
137 		uint _hardCap,
138 		uint _quantum,
139 		address _beneficiary,
140 		address _token
141 	) public {
142 
143 		// validate crowdsale settings (inputs)
144 		// require(_offset > 0); // we don't really care
145 		require(_length > 0);
146 		require(now < _offset + _length); // crowdsale must not be already finished
147 		// softCap can be anything, zero means crowdsale doesn't fail
148 		require(_hardCap > _softCap || _hardCap == 0);
149 		// hardCap must be greater then softCap
150 		// quantum can be anything, zero means no accumulation
151 		require(_price > 0);
152 		require(_beneficiary != address(0));
153 		require(_token != address(0));
154 
155 		name = _name;
156 
157 		// setup crowdsale settings
158 		offset = _offset;
159 		length = _length;
160 		softCap = _softCap;
161 		hardCap = _hardCap;
162 		quantum = _quantum;
163 		price = _price;
164 		creator = msg.sender;
165 
166 		// define beneficiary
167 		beneficiary = _beneficiary;
168 
169 		// allocate tokens: link and init coefficient
170 		__allocateTokens(_token);
171 	}
172 
173 	// accepts crowdsale investment, requires
174 	// crowdsale to be running and not reached its goal
175 	function invest() public payable {
176 		// perform validations
177 		assert(now >= offset && now < offset + length); // crowdsale is active
178 		assert(collected + price <= hardCap || hardCap == 0); // its still possible to buy at least 1 token
179 		require(msg.value >= price); // value sent is enough to buy at least one token
180 
181 		// call 'sender' nicely - investor
182 		address investor = msg.sender;
183 
184 		// how much tokens we must send to investor
185 		uint tokens = msg.value / price;
186 
187 		// how much value we must send to beneficiary
188 		uint value = tokens * price;
189 
190 		// ensure we are not crossing the hardCap
191 		if (value + collected > hardCap || hardCap == 0) {
192 			value = hardCap - collected;
193 			tokens = value / price;
194 			value = tokens * price;
195 		}
196 
197 		// update crowdsale status
198 		collected += value;
199 		tokensIssued += tokens;
200 
201 		// transfer tokens to investor
202 		__issueTokens(investor, tokens);
203 
204 		// transfer the change to investor
205 		investor.transfer(msg.value - value);
206 
207 		// accumulate the value or transfer it to beneficiary
208 		if (collected >= softCap && this.balance >= quantum) {
209 			// transfer all the value to beneficiary
210 			__beneficiaryTransfer(this.balance);
211 		}
212 
213 		// log an event
214 		InvestmentAccepted(investor, tokens, value);
215 	}
216 
217 	// refunds an investor of failed crowdsale,
218 	// requires investor to allow token transfer back
219 	function refund() public payable {
220 		// perform validations
221 		assert(now >= offset + length); // crowdsale ended
222 		assert(collected < softCap); // crowdsale failed
223 
224 		// call 'sender' nicely - investor
225 		address investor = msg.sender;
226 
227 		// find out how much tokens should be refunded
228 		uint tokens = __redeemAmount(investor);
229 
230 		// calculate refund amount
231 		uint refundValue = tokens * price;
232 
233 		// additional validations
234 		require(tokens > 0);
235 
236 		// update crowdsale status
237 		refunded += refundValue;
238 		tokensRedeemed += tokens;
239 		refunds++;
240 
241 		// transfer the tokens back
242 		__redeemTokens(investor, tokens);
243 
244 		// make a refund
245 		investor.transfer(refundValue + msg.value);
246 
247 		// log an event
248 		RefundIssued(investor, tokens, refundValue);
249 	}
250 
251 	// sends all the value to the beneficiary
252 	function withdraw() public {
253 		// perform validations
254 		assert(creator == msg.sender || beneficiary == msg.sender); // only creator or beneficiary can initiate this call
255 		assert(collected >= softCap); // crowdsale must be successful
256 		assert(this.balance > 0); // there should be something to transfer
257 
258 		// how much to withdraw (entire balance obviously)
259 		uint value = this.balance;
260 
261 		// perform the transfer
262 		__beneficiaryTransfer(value);
263 	}
264 
265 	// performs an investment, refund or withdrawal,
266 	// depending on the crowdsale status
267 	function() public payable {
268 		// started or finished
269 		require(now >= offset);
270 
271 		if(now < offset + length) {
272 			// crowdsale is running, invest
273 			invest();
274 		}
275 		else if(collected < softCap) {
276 			// crowdsale failed, try to refund
277 			refund();
278 		}
279 		else {
280 			// crowdsale is successful, investments are not accepted anymore
281 			// but maybe poor beneficiary is begging for change...
282 			withdraw();
283 		}
284 	}
285 
286 	// ----------------------- internal section -----------------------
287 
288 	// allocates token source (basically links token)
289 	function __allocateTokens(address _token) internal {
290 		// link tokens, tokens are not owned by a crowdsale
291 		// should be transferred to crowdsale after the deployment
292 		token = DetailedERC20(_token);
293 
294 		// obtain decimals and calculate coefficient k
295 		k = 10 ** uint(token.decimals());
296 	}
297 
298 	// transfers tokens to investor, validations are not required
299 	function __issueTokens(address investor, uint tokens) internal {
300 		// if this is a new investor update investor count
301 		if (balances[investor] == 0) {
302 			investorsCount++;
303 		}
304 
305 		// for open crowdsales we track investors balances
306 		balances[investor] += tokens;
307 
308 		// issue tokens, taking into account decimals
309 		token.transferFrom(creator, investor, tokens * k);
310 	}
311 
312 	// calculates amount of tokens available to redeem from investor, validations are not required
313 	function __redeemAmount(address investor) internal view returns (uint amount) {
314 		// round down allowance taking into account token decimals
315 		uint allowance = token.allowance(investor, this) / k;
316 
317 		// for open crowdsales we check previously tracked investor balance
318 		uint balance = balances[investor];
319 
320 		// return allowance safely by checking also the balance
321 		return balance < allowance ? balance : allowance;
322 	}
323 
324 	// transfers tokens from investor, validations are not required
325 	function __redeemTokens(address investor, uint tokens) internal {
326 		// for open crowdsales we track investors balances
327 		balances[investor] -= tokens;
328 
329 		// redeem tokens, taking into account decimals coefficient
330 		token.transferFrom(investor, creator, tokens * k);
331 	}
332 
333 	// transfers a value to beneficiary, validations are not required
334 	function __beneficiaryTransfer(uint value) internal {
335 		beneficiary.transfer(value);
336 	}
337 
338 	// !---------------------- internal section ----------------------!
339 }