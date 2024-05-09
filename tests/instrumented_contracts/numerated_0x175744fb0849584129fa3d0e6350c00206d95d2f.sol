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
61 	    uint256 fee;
62 	    uint8 rounds;
63 	    bool whitelisted;
64   	}
65 
66 	struct Snapshot {
67 		uint256 tokens_balance;
68 		uint256 eth_balance;
69 	}
70 
71 	modifier minAmountReached {
72 		require(this.balance >= min_amount);
73 		_;
74 	}
75 
76   	modifier underMaxAmount {
77     	require(max_amount == 0 || this.balance <= max_amount);
78     	_;
79   	}
80 
81 	address constant public DEVELOPER1 = 0x8C006d807EBAe91F341a4308132Fd756808e0126;
82 	address constant public DEVELOPER2 = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;
83 	uint256 constant public FEE_DEV = 670;
84 
85 	uint256 public FEE_OWNER;
86 	uint256 public max_amount;
87 	uint256 public min_amount;
88 	uint256 public individual_cap;
89 	uint256 public gas_price_max;
90 	uint8 public rounds;
91 	bool public whitelist_enabled;
92 
93 	mapping (address => Contributor) public contributors;
94 	Snapshot[] public snapshots;
95 
96 	uint256 public const_contract_eth_value;
97 	uint256 public percent_reduction;
98 
99 	address public sale;
100 	ERC20 public token;
101 	bool public bought_tokens;
102 	bool public owner_supplied_eth;
103 	bool public allow_contributions = true;
104   //============================
105 
106 	constructor(
107 		uint256 _max_amount,
108 		uint256 _min_amount,
109 		bool _whitelist,
110 		uint256 _owner_fee_divisor
111 		) {
112 			max_amount = calculate_with_fees(_max_amount);
113 		  	min_amount = calculate_with_fees(_min_amount);
114 		  	whitelist_enabled = _whitelist;
115 		  	FEE_OWNER = _owner_fee_divisor;
116 		  	Contributor storage contributor = contributors[msg.sender];
117 		  	contributor.whitelisted = true;
118   		}
119 
120 
121 	function buy_the_tokens(bytes _data) onlyOwner minAmountReached {
122 		require(!bought_tokens && sale != 0x0);
123 		bought_tokens = true;
124 		const_contract_eth_value = this.balance;
125 		take_fees_eth_dev();
126 		take_fees_eth_owner();
127 		const_contract_eth_value = this.balance;
128 		require(sale.call.gas(msg.gas).value(this.balance)(_data));
129 	}
130 
131 	function whitelist_addys(address[] _addys, bool _state) onlyOwner {
132 		for (uint256 i = 0; i < _addys.length; i++) {
133 			Contributor storage contributor = contributors[_addys[i]];
134 			contributor.whitelisted = _state;
135 		}
136 	}
137 
138 	function set_gas_price_max(uint256 _gas_price) onlyOwner {
139 		gas_price_max = _gas_price;
140 	}
141 
142 	function set_sale_address(address _sale) onlyOwner {
143 		require(_sale != 0x0);
144 		sale = _sale;
145 	}
146 
147 	function set_token_address(address _token) onlyOwner {
148 		require(_token != 0x0);
149 		token = ERC20(_token);
150 	}
151 
152 	function set_allow_contributions(bool _boolean) onlyOwner {
153 		allow_contributions = _boolean;
154 	}
155 
156 	function set_tokens_received() onlyOwner {
157 		tokens_received();
158 	}
159 
160 	function set_percent_reduction(uint256 _reduction) onlyOwner payable {
161 		require(bought_tokens && rounds == 0 && _reduction <= 100);
162 		percent_reduction = _reduction;
163 		if (msg.value > 0) {
164 			owner_supplied_eth = true;
165 		}
166 		const_contract_eth_value = const_contract_eth_value.sub((const_contract_eth_value.mul(_reduction)).div(100));
167 	}
168 
169 	function set_whitelist_enabled(bool _boolean) onlyOwner {
170 		whitelist_enabled = _boolean;
171 	}
172 
173 	function change_individual_cap(uint256 _cap) onlyOwner {
174 		individual_cap = _cap;
175 	}
176 
177 	function change_max_amount(uint256 _amount) onlyOwner {
178 		//ATTENTION! The new amount should be in wei
179 		//Use https://etherconverter.online/
180 		max_amount = calculate_with_fees(_amount);
181 	}
182 
183 	function change_min_amount(uint256 _amount) onlyOwner {
184 		//ATTENTION! The new amount should be in wei
185 		//Use https://etherconverter.online/
186 		min_amount = calculate_with_fees(_amount);
187 	}
188 
189 	function change_fee(uint256 _fee) onlyOwner {
190 		FEE_OWNER = _fee;
191 	}
192 
193 	function emergency_token_withdraw(address _address) onlyOwner {
194 	 	ERC20 temp_token = ERC20(_address);
195 		require(temp_token.transfer(msg.sender, temp_token.balanceOf(this)));
196 	}
197 
198 	function emergency_eth_withdraw() onlyOwner {
199 		msg.sender.transfer(this.balance);
200 	}
201 
202 	function withdraw(address _user) internal {
203 		require(bought_tokens);
204 		uint256 contract_token_balance = token.balanceOf(address(this));
205 		require(contract_token_balance != 0);
206 		Contributor storage contributor = contributors[_user];
207 		if (contributor.rounds < rounds) {
208 			Snapshot storage snapshot = snapshots[contributor.rounds];
209             uint256 tokens_to_withdraw = contributor.balance.mul(snapshot.tokens_balance).div(snapshot.eth_balance);
210 			snapshot.tokens_balance = snapshot.tokens_balance.sub(tokens_to_withdraw);
211 			snapshot.eth_balance = snapshot.eth_balance.sub(contributor.balance);
212             contributor.rounds++;
213             require(token.transfer(_user, tokens_to_withdraw));
214         }
215 	}
216 
217 	function refund(address _user) internal {
218 		require(!bought_tokens && percent_reduction == 0);
219 		Contributor storage contributor = contributors[_user];
220 		uint256 eth_to_withdraw = contributor.balance.add(contributor.fee);
221 		contributor.balance = 0;
222 		contributor.fee = 0;
223 		_user.transfer(eth_to_withdraw);
224 	}
225 
226 	function partial_refund(address _user) internal {
227 		require(bought_tokens && rounds == 0 && percent_reduction > 0);
228 		Contributor storage contributor = contributors[_user];
229 		require(contributor.rounds == 0);
230 		uint256 eth_to_withdraw = contributor.balance.mul(percent_reduction).div(100);
231 		contributor.balance = contributor.balance.sub(eth_to_withdraw);
232 		if (owner_supplied_eth) {
233 			uint256 fee = contributor.fee.mul(percent_reduction).div(100);
234 			eth_to_withdraw = eth_to_withdraw.add(fee);
235 		}
236 		_user.transfer(eth_to_withdraw);
237 	}
238 
239 	function take_fees_eth_dev() internal {
240 		if (FEE_DEV != 0) {
241 			DEVELOPER1.transfer(const_contract_eth_value.div(FEE_DEV));
242 			DEVELOPER2.transfer(const_contract_eth_value.div(FEE_DEV));
243 		}
244 	}
245 
246 	function take_fees_eth_owner() internal {
247 		if (FEE_OWNER != 0) {
248 			owner.transfer(const_contract_eth_value.div(FEE_OWNER));
249 		}
250 	}
251 
252 	function calculate_with_fees(uint256 _amount) internal returns (uint256) {
253 		uint256 temp = _amount;
254 		if (FEE_DEV != 0) {
255 			temp = temp.add(_amount.div(FEE_DEV/2));
256 		}
257 		if (FEE_OWNER != 0) {
258 			temp = temp.add(_amount.div(FEE_OWNER));
259 		}
260 		return temp;
261 	}
262 
263 	function tokens_received() internal {
264 		uint256 previous_balance;
265 		for (uint8 i = 0; i < snapshots.length; i++) {
266 			previous_balance = previous_balance.add(snapshots[i].tokens_balance);
267 		}
268 		snapshots.push(Snapshot(token.balanceOf(address(this)).sub(previous_balance), const_contract_eth_value));
269 		rounds++;
270 	}
271 
272 
273   function tokenFallback(address _from, uint _value, bytes _data) {
274 		if (ERC20(msg.sender) == token) {
275 			tokens_received();
276 		}
277 	}
278 
279 	function withdraw_my_tokens() {
280 		for (uint8 i = contributors[msg.sender].rounds; i < rounds; i++) {
281 			withdraw(msg.sender);
282 		}
283 	}
284 
285 	function withdraw_tokens_for(address _addy) {
286 		for (uint8 i = contributors[_addy].rounds; i < rounds; i++) {
287 			withdraw(_addy);
288 		}
289 	}
290 
291 	function refund_my_ether() {
292 		refund(msg.sender);
293 	}
294 
295 	function partial_refund_my_ether() {
296 		partial_refund(msg.sender);
297 	}
298 
299 	function provide_eth() payable {}
300 
301 	function () payable underMaxAmount {
302 		require(!bought_tokens && allow_contributions && (gas_price_max == 0 || tx.gasprice <= gas_price_max));
303 		Contributor storage contributor = contributors[msg.sender];
304 		if (whitelist_enabled) {
305 			require(contributor.whitelisted);
306 		}
307 		uint256 fee = 0;
308 		if (FEE_OWNER != 0) {
309 			fee = SafeMath.div(msg.value, FEE_OWNER);
310 		}
311 		uint256 fees = fee;
312 		if (FEE_DEV != 0) {
313 			fee = msg.value.div(FEE_DEV/2);
314 			fees = fees.add(fee);
315 		}
316 		contributor.balance = contributor.balance.add(msg.value).sub(fees);
317 		contributor.fee = contributor.fee.add(fees);
318 
319 		require(individual_cap == 0 || contributor.balance <= individual_cap);
320 	}
321 }