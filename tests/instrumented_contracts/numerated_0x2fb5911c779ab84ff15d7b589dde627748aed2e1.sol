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
71   	modifier underMaxAmount {
72     	require(max_amount == 0 || this.balance <= max_amount);
73     	_;
74   	}
75 
76 	address constant public DEVELOPER1 = 0x8C006d807EBAe91F341a4308132Fd756808e0126;
77 	address constant public DEVELOPER2 = 0x63F7547Ac277ea0B52A0B060Be6af8C5904953aa;
78 	uint256 constant public FEE_DEV = 670;
79 
80 	uint256 public FEE_OWNER;
81 	uint256 public max_amount;
82 	uint256 public individual_cap;
83 	uint256 public gas_price_max;
84 	uint8 public rounds;
85 	bool public whitelist_enabled;
86 
87 	mapping (address => Contributor) public contributors;
88 	Snapshot[] public snapshots;
89 
90 	uint256 public const_contract_eth_value;
91 	uint256 public percent_reduction;
92 
93 	address public sale;
94 	ERC20 public token;
95 	bool public bought_tokens;
96 	bool public owner_supplied_eth;
97 	bool public allow_contributions = true;
98 	bool public allow_refunds;
99   //============================
100 
101 	constructor(
102 		uint256 _max_amount,
103 		bool _whitelist,
104 		uint256 _owner_fee_divisor
105 		) {
106 			FEE_OWNER = _owner_fee_divisor;
107 			max_amount = calculate_with_fees(_max_amount);
108 		  	whitelist_enabled = _whitelist;
109 		  	Contributor storage contributor = contributors[msg.sender];
110 		  	contributor.whitelisted = true;
111   		}
112 
113 
114 	function buy_the_tokens(bytes _data) onlyOwner {
115 		require(!bought_tokens && sale != 0x0);
116 		bought_tokens = true;
117 		const_contract_eth_value = this.balance;
118 		take_fees_eth_dev();
119 		take_fees_eth_owner();
120 		const_contract_eth_value = this.balance;
121 		require(sale.call.gas(msg.gas).value(this.balance)(_data));
122 	}
123 
124 	function whitelist_addys(address[] _addys, bool _state) onlyOwner {
125 		for (uint256 i = 0; i < _addys.length; i++) {
126 			Contributor storage contributor = contributors[_addys[i]];
127 			contributor.whitelisted = _state;
128 		}
129 	}
130 
131 	function force_refund(address _addy) onlyOwner {
132 		refund(_addy);
133 	}
134 
135 	function force_partial_refund(address _addy) onlyOwner {
136 		partial_refund(_addy);
137 	}
138 
139 	function set_gas_price_max(uint256 _gas_price) onlyOwner {
140 		gas_price_max = _gas_price;
141 	}
142 
143 	function set_sale_address(address _sale) onlyOwner {
144 		require(_sale != 0x0);
145 		sale = _sale;
146 	}
147 
148 	function set_token_address(address _token) onlyOwner {
149 		require(_token != 0x0);
150 		token = ERC20(_token);
151 	}
152 
153 	function set_allow_contributions(bool _boolean) onlyOwner {
154 		allow_contributions = _boolean;
155 	}
156 
157 	function set_allow_refunds(bool _boolean) onlyOwner {
158 		allow_refunds = _boolean;
159 	}
160 
161 	function set_tokens_received() onlyOwner {
162 		tokens_received();
163 	}
164 
165 	function set_percent_reduction(uint256 _reduction) onlyOwner payable {
166 		require(bought_tokens && rounds == 0 && _reduction <= 100);
167 		percent_reduction = _reduction;
168 		if (msg.value > 0) {
169 			owner_supplied_eth = true;
170 		}
171 		const_contract_eth_value = const_contract_eth_value.sub((const_contract_eth_value.mul(_reduction)).div(100));
172 	}
173 
174 	function set_whitelist_enabled(bool _boolean) onlyOwner {
175 		whitelist_enabled = _boolean;
176 	}
177 
178 	function change_individual_cap(uint256 _cap) onlyOwner {
179 		individual_cap = _cap;
180 	}
181 
182 	function change_max_amount(uint256 _amount) onlyOwner {
183 		//ATTENTION! The new amount should be in wei
184 		//Use https://etherconverter.online/
185 		max_amount = calculate_with_fees(_amount);
186 	}
187 
188 	function change_fee(uint256 _fee) onlyOwner {
189 		FEE_OWNER = _fee;
190 	}
191 
192 	function emergency_token_withdraw(address _address) onlyOwner {
193 	 	ERC20 temp_token = ERC20(_address);
194 		require(temp_token.transfer(msg.sender, temp_token.balanceOf(this)));
195 	}
196 
197 	function emergency_eth_withdraw() onlyOwner {
198 		msg.sender.transfer(this.balance);
199 	}
200 
201 	function withdraw(address _user) internal {
202 		require(bought_tokens);
203 		uint256 contract_token_balance = token.balanceOf(address(this));
204 		require(contract_token_balance != 0);
205 		Contributor storage contributor = contributors[_user];
206 		if (contributor.rounds < rounds) {
207 			Snapshot storage snapshot = snapshots[contributor.rounds];
208             uint256 tokens_to_withdraw = contributor.balance.mul(snapshot.tokens_balance).div(snapshot.eth_balance);
209 			snapshot.tokens_balance = snapshot.tokens_balance.sub(tokens_to_withdraw);
210 			snapshot.eth_balance = snapshot.eth_balance.sub(contributor.balance);
211             contributor.rounds++;
212             require(token.transfer(_user, tokens_to_withdraw));
213         }
214 	}
215 
216 	function refund(address _user) internal {
217 		require(!bought_tokens && allow_refunds && percent_reduction == 0);
218 		Contributor storage contributor = contributors[_user];
219 		uint256 eth_to_withdraw = contributor.balance.add(contributor.fee);
220 		contributor.balance = 0;
221 		contributor.fee = 0;
222 		_user.transfer(eth_to_withdraw);
223 	}
224 
225 	function partial_refund(address _user) internal {
226 		require(bought_tokens && allow_refunds && rounds == 0 && percent_reduction > 0);
227 		Contributor storage contributor = contributors[_user];
228 		require(contributor.rounds == 0);
229 		uint256 eth_to_withdraw = contributor.balance.mul(percent_reduction).div(100);
230 		contributor.balance = contributor.balance.sub(eth_to_withdraw);
231 		if (owner_supplied_eth) {
232 			uint256 fee = contributor.fee.mul(percent_reduction).div(100);
233 			eth_to_withdraw = eth_to_withdraw.add(fee);
234 		}
235 		_user.transfer(eth_to_withdraw);
236 	}
237 
238 	function take_fees_eth_dev() internal {
239 		if (FEE_DEV != 0) {
240 			DEVELOPER1.transfer(const_contract_eth_value.div(FEE_DEV));
241 			DEVELOPER2.transfer(const_contract_eth_value.div(FEE_DEV));
242 		}
243 	}
244 
245 	function take_fees_eth_owner() internal {
246 		if (FEE_OWNER != 0) {
247 			owner.transfer(const_contract_eth_value.div(FEE_OWNER));
248 		}
249 	}
250 
251 	function calculate_with_fees(uint256 _amount) internal returns (uint256) {
252 		uint256 temp = _amount;
253 		if (FEE_DEV != 0) {
254 			temp = temp.add(_amount.div(FEE_DEV/2));
255 		}
256 		if (FEE_OWNER != 0) {
257 			temp = temp.add(_amount.div(FEE_OWNER));
258 		}
259 		return temp;
260 	}
261 
262 	function tokens_received() internal {
263 		uint256 previous_balance;
264 		for (uint8 i = 0; i < snapshots.length; i++) {
265 			previous_balance = previous_balance.add(snapshots[i].tokens_balance);
266 		}
267 		snapshots.push(Snapshot(token.balanceOf(address(this)).sub(previous_balance), const_contract_eth_value));
268 		rounds++;
269 	}
270 
271 
272   function tokenFallback(address _from, uint _value, bytes _data) {
273 		if (ERC20(msg.sender) == token) {
274 			tokens_received();
275 		}
276 	}
277 
278 	function withdraw_my_tokens() {
279 		for (uint8 i = contributors[msg.sender].rounds; i < rounds; i++) {
280 			withdraw(msg.sender);
281 		}
282 	}
283 
284 	function withdraw_tokens_for(address _addy) {
285 		for (uint8 i = contributors[_addy].rounds; i < rounds; i++) {
286 			withdraw(_addy);
287 		}
288 	}
289 
290 	function refund_my_ether() {
291 		refund(msg.sender);
292 	}
293 
294 	function partial_refund_my_ether() {
295 		partial_refund(msg.sender);
296 	}
297 
298 	function provide_eth() payable {}
299 
300 	function () payable underMaxAmount {
301 		require(!bought_tokens && allow_contributions && (gas_price_max == 0 || tx.gasprice <= gas_price_max));
302 		Contributor storage contributor = contributors[msg.sender];
303 		if (whitelist_enabled) {
304 			require(contributor.whitelisted);
305 		}
306 		uint256 fee = 0;
307 		if (FEE_OWNER != 0) {
308 			fee = SafeMath.div(msg.value, FEE_OWNER);
309 		}
310 		uint256 fees = fee;
311 		if (FEE_DEV != 0) {
312 			fee = msg.value.div(FEE_DEV/2);
313 			fees = fees.add(fee);
314 		}
315 		contributor.balance = contributor.balance.add(msg.value).sub(fees);
316 		contributor.fee = contributor.fee.add(fees);
317 
318 		require(individual_cap == 0 || contributor.balance <= individual_cap);
319 	}
320 }