1 //author : dm & w
2 pragma solidity ^0.4.23;
3 
4 library SafeMath {
5   	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 		if (a == 0) {
7 		return 0;
8 		}
9 		uint256 c = a * b;
10 		assert(c / a == b);
11 		return c;
12 	}
13 
14   	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     	uint256 c = a / b;
16     	return c;
17   	}
18 
19   	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     	assert(b <= a);
21     	return a - b;
22   	}
23 
24   	function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     	uint256 c = a + b;
26     	assert(c >= a);
27     	return c;
28   	}
29 }
30 
31 contract ERC20 {
32   	function transfer(address _to, uint256 _value) public returns (bool success);
33   	function balanceOf(address _owner) public constant returns (uint256 balance);
34 }
35 
36 contract Controller {
37 
38 	address public owner;
39 
40 	modifier onlyOwner {
41     	require(msg.sender == owner);
42     	_;
43   	}
44 
45   	function change_owner(address new_owner) onlyOwner {
46     	require(new_owner != 0x0);
47     	owner = new_owner;
48   	}
49 
50   	function Controller() {
51     	owner = msg.sender;
52   	}
53 }
54 
55 contract Contract is Controller {
56 
57 	using SafeMath for uint256;
58 
59   	struct Contributor {
60 		uint256 balance;
61 	    uint256 fee_owner;
62 		uint256 fee_devs;
63 	    uint8 rounds;
64 	    bool whitelisted;
65   	}
66 
67 	struct Snapshot {
68 		uint256 tokens_balance;
69 		uint256 eth_balance;
70 	}
71 
72   	modifier underMaxAmount {
73     	require(max_amount == 0 || this.balance <= max_amount);
74     	_;
75   	}
76 
77 	address constant public DEVELOPER1 = 0x8C006d807EBAe91F341a4308132Fd756808e0126;
78 	address constant public DEVELOPER2 = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;
79 	uint256 constant public FEE_DEV = 670;
80 
81 	uint256 public FEE_OWNER;
82 	uint256 public max_amount;
83 	uint256 public individual_cap;
84 	uint256 public gas_price_max;
85 	uint8 public rounds;
86 	bool public whitelist_enabled;
87 
88 	mapping (address => Contributor) public contributors;
89 	Snapshot[] public snapshots;
90 	uint256[] public total_fees;
91 
92 	uint256 public const_contract_eth_value;
93 	uint256 public percent_reduction;
94 
95 	address public sale;
96 	ERC20 public token;
97 	bool public bought_tokens;
98 	bool public owner_supplied_eth;
99 	bool public allow_contributions = true;
100 	bool public allow_refunds;
101   //============================
102 
103 	constructor(
104 		uint256 _max_amount,
105 		bool _whitelist,
106 		uint256 _owner_fee_divisor
107 		) {
108 			FEE_OWNER = _owner_fee_divisor;
109 			max_amount = calculate_with_fees(_max_amount);
110 		  	whitelist_enabled = _whitelist;
111 		  	Contributor storage contributor = contributors[msg.sender];
112 		  	contributor.whitelisted = true;
113 			total_fees.length = 2;
114   		}
115 
116 
117 	function buy_the_tokens(bytes _data) onlyOwner {
118 		require(!bought_tokens && sale != 0x0);
119 		bought_tokens = true;
120 		const_contract_eth_value = this.balance;
121 		take_fees_eth_dev();
122 		take_fees_eth_owner();
123 		const_contract_eth_value = this.balance;
124 		require(sale.call.gas(msg.gas).value(this.balance)(_data));
125 	}
126 
127 	function whitelist_addys(address[] _addys, bool _state) onlyOwner {
128 		for (uint256 i = 0; i < _addys.length; i++) {
129 			Contributor storage contributor = contributors[_addys[i]];
130 			contributor.whitelisted = _state;
131 		}
132 	}
133 
134 	function force_refund(address _addy) onlyOwner {
135 		refund(_addy);
136 	}
137 
138 	function force_partial_refund(address _addy) onlyOwner {
139 		partial_refund(_addy);
140 	}
141 
142 	function set_gas_price_max(uint256 _gas_price) onlyOwner {
143 		gas_price_max = _gas_price;
144 	}
145 
146 	function set_sale_address(address _sale) onlyOwner {
147 		require(_sale != 0x0);
148 		sale = _sale;
149 	}
150 
151 	function set_token_address(address _token) onlyOwner {
152 		require(_token != 0x0);
153 		token = ERC20(_token);
154 	}
155 
156 	function set_allow_contributions(bool _boolean) onlyOwner {
157 		allow_contributions = _boolean;
158 	}
159 
160 	function set_allow_refunds(bool _boolean) onlyOwner {
161 		allow_refunds = _boolean;
162 	}
163 
164 	function set_tokens_received() onlyOwner {
165 		tokens_received();
166 	}
167 
168 	function set_percent_reduction(uint256 _reduction) onlyOwner payable {
169 		require(bought_tokens && rounds == 0 && _reduction <= 100);
170 		percent_reduction = _reduction;
171 		if (msg.value > 0) {
172 			owner_supplied_eth = true;
173 		}
174 		const_contract_eth_value = const_contract_eth_value.sub((const_contract_eth_value.mul(_reduction)).div(100));
175 	}
176 
177 	function set_whitelist_enabled(bool _boolean) onlyOwner {
178 		whitelist_enabled = _boolean;
179 	}
180 
181 	function change_individual_cap(uint256 _cap) onlyOwner {
182 		individual_cap = _cap;
183 	}
184 
185 	function change_max_amount(uint256 _amount) onlyOwner {
186 		//ATTENTION! The new amount should be in wei
187 		//Use https://etherconverter.online/
188 		max_amount = calculate_with_fees(_amount);
189 	}
190 
191 	function change_fee(uint256 _fee) onlyOwner {
192 		FEE_OWNER = _fee;
193 	}
194 
195 	function emergency_token_withdraw(address _address) onlyOwner {
196 	 	ERC20 temp_token = ERC20(_address);
197 		require(temp_token.transfer(msg.sender, temp_token.balanceOf(this)));
198 	}
199 
200 	function emergency_eth_withdraw() onlyOwner {
201 		msg.sender.transfer(this.balance);
202 	}
203 
204 	function withdraw(address _user) internal {
205 		require(bought_tokens);
206 		uint256 contract_token_balance = token.balanceOf(address(this));
207 		require(contract_token_balance != 0);
208 		Contributor storage contributor = contributors[_user];
209 		if (contributor.rounds < rounds) {
210 			Snapshot storage snapshot = snapshots[contributor.rounds];
211             uint256 tokens_to_withdraw = contributor.balance.mul(snapshot.tokens_balance).div(snapshot.eth_balance);
212 			snapshot.tokens_balance = snapshot.tokens_balance.sub(tokens_to_withdraw);
213 			snapshot.eth_balance = snapshot.eth_balance.sub(contributor.balance);
214             contributor.rounds++;
215             require(token.transfer(_user, tokens_to_withdraw));
216         }
217 	}
218 
219 	function refund(address _user) internal {
220 		require(!bought_tokens && allow_refunds && percent_reduction == 0);
221 		Contributor storage contributor = contributors[_user];
222 		total_fees[0] -= contributor.fee_owner;
223 		total_fees[1] -= contributor.fee_devs;
224 		uint256 eth_to_withdraw = contributor.balance.add(contributor.fee_owner).add(contributor.fee_devs);
225 		contributor.balance = 0;
226 		contributor.fee_owner = 0;
227 		contributor.fee_devs = 0;
228 		_user.transfer(eth_to_withdraw);
229 	}
230 
231 	function partial_refund(address _user) internal {
232 		require(bought_tokens && allow_refunds && rounds == 0 && percent_reduction > 0);
233 		Contributor storage contributor = contributors[_user];
234 		require(contributor.rounds == 0);
235 		uint256 eth_to_withdraw = contributor.balance.mul(percent_reduction).div(100);
236 		contributor.balance = contributor.balance.sub(eth_to_withdraw);
237 		if (owner_supplied_eth) {
238 			uint256 fee = contributor.fee_owner.mul(percent_reduction).div(100);
239 			eth_to_withdraw = eth_to_withdraw.add(fee);
240 		}
241 		_user.transfer(eth_to_withdraw);
242 	}
243 
244 	function take_fees_eth_dev() internal {
245 		if (FEE_DEV != 0) {
246 			DEVELOPER1.transfer(total_fees[1]);
247 			DEVELOPER2.transfer(total_fees[1]);
248 		}
249 	}
250 
251 	function take_fees_eth_owner() internal {
252 		if (FEE_OWNER != 0) {
253 			owner.transfer(total_fees[0]);
254 		}
255 	}
256 
257 	function calculate_with_fees(uint256 _amount) internal returns (uint256) {
258 		uint256 temp = _amount;
259 		if (FEE_DEV != 0) {
260 			temp = temp.add(_amount.div(FEE_DEV/2));
261 		}
262 		if (FEE_OWNER != 0) {
263 			temp = temp.add(_amount.div(FEE_OWNER));
264 		}
265 		return temp;
266 	}
267 
268 	function tokens_received() internal {
269 		uint256 previous_balance;
270 		for (uint8 i = 0; i < snapshots.length; i++) {
271 			previous_balance = previous_balance.add(snapshots[i].tokens_balance);
272 		}
273 		snapshots.push(Snapshot(token.balanceOf(address(this)).sub(previous_balance), const_contract_eth_value));
274 		rounds++;
275 	}
276 
277 
278   function tokenFallback(address _from, uint _value, bytes _data) {
279 		if (ERC20(msg.sender) == token) {
280 			tokens_received();
281 		}
282 	}
283 
284 	function withdraw_my_tokens() {
285 		for (uint8 i = contributors[msg.sender].rounds; i < rounds; i++) {
286 			withdraw(msg.sender);
287 		}
288 	}
289 
290 	function withdraw_tokens_for(address _addy) {
291 		for (uint8 i = contributors[_addy].rounds; i < rounds; i++) {
292 			withdraw(_addy);
293 		}
294 	}
295 
296 	function refund_my_ether() {
297 		refund(msg.sender);
298 	}
299 
300 	function partial_refund_my_ether() {
301 		partial_refund(msg.sender);
302 	}
303 
304 	function provide_eth() payable {}
305 
306 	function () payable underMaxAmount {
307 		require(!bought_tokens && allow_contributions && (gas_price_max == 0 || tx.gasprice <= gas_price_max));
308 		Contributor storage contributor = contributors[msg.sender];
309 		if (whitelist_enabled) {
310 			require(contributor.whitelisted);
311 		}
312 		uint256 fee = 0;
313 		if (FEE_OWNER != 0) {
314 			fee = SafeMath.div(msg.value, FEE_OWNER);
315 			contributor.fee_owner += fee;
316 			total_fees[0] += fee;
317 		}
318 		uint256 fees = fee;
319 		if (FEE_DEV != 0) {
320 			fee = msg.value.div(FEE_DEV);
321 			total_fees[1] += fee;
322 			contributor.fee_devs += fee*2;
323 			fees = fees.add(fee*2);
324 		}
325 		contributor.balance = contributor.balance.add(msg.value.sub(fees));
326 
327 		require(individual_cap == 0 || contributor.balance <= individual_cap);
328 	}
329 }