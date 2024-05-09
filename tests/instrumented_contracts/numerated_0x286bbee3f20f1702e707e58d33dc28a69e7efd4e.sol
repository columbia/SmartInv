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
131 	function set_gas_price_max(uint256 _gas_price) onlyOwner {
132 		gas_price_max = _gas_price;
133 	}
134 
135 	function set_sale_address(address _sale) onlyOwner {
136 		require(_sale != 0x0);
137 		sale = _sale;
138 	}
139 
140 	function set_token_address(address _token) onlyOwner {
141 		require(_token != 0x0);
142 		token = ERC20(_token);
143 	}
144 
145 	function set_allow_contributions(bool _boolean) onlyOwner {
146 		allow_contributions = _boolean;
147 	}
148 
149 	function set_allow_refunds(bool _boolean) onlyOwner {
150 		allow_refunds = _boolean;
151 	}
152 
153 	function set_tokens_received() onlyOwner {
154 		tokens_received();
155 	}
156 
157 	function set_percent_reduction(uint256 _reduction) onlyOwner payable {
158 		require(bought_tokens && rounds == 0 && _reduction <= 100);
159 		percent_reduction = _reduction;
160 		if (msg.value > 0) {
161 			owner_supplied_eth = true;
162 		}
163 		const_contract_eth_value = const_contract_eth_value.sub((const_contract_eth_value.mul(_reduction)).div(100));
164 	}
165 
166 	function set_whitelist_enabled(bool _boolean) onlyOwner {
167 		whitelist_enabled = _boolean;
168 	}
169 
170 	function change_individual_cap(uint256 _cap) onlyOwner {
171 		individual_cap = _cap;
172 	}
173 
174 	function change_max_amount(uint256 _amount) onlyOwner {
175 		//ATTENTION! The new amount should be in wei
176 		//Use https://etherconverter.online/
177 		max_amount = calculate_with_fees(_amount);
178 	}
179 
180 	function change_fee(uint256 _fee) onlyOwner {
181 		FEE_OWNER = _fee;
182 	}
183 
184 	function emergency_token_withdraw(address _address) onlyOwner {
185 	 	ERC20 temp_token = ERC20(_address);
186 		require(temp_token.transfer(msg.sender, temp_token.balanceOf(this)));
187 	}
188 
189 	function emergency_eth_withdraw() onlyOwner {
190 		msg.sender.transfer(this.balance);
191 	}
192 
193 	function withdraw(address _user) internal {
194 		require(bought_tokens);
195 		uint256 contract_token_balance = token.balanceOf(address(this));
196 		require(contract_token_balance != 0);
197 		Contributor storage contributor = contributors[_user];
198 		if (contributor.rounds < rounds) {
199 			Snapshot storage snapshot = snapshots[contributor.rounds];
200             uint256 tokens_to_withdraw = contributor.balance.mul(snapshot.tokens_balance).div(snapshot.eth_balance);
201 			snapshot.tokens_balance = snapshot.tokens_balance.sub(tokens_to_withdraw);
202 			snapshot.eth_balance = snapshot.eth_balance.sub(contributor.balance);
203             contributor.rounds++;
204             require(token.transfer(_user, tokens_to_withdraw));
205         }
206 	}
207 
208 	function refund(address _user) internal {
209 		require(!bought_tokens && allow_refunds && percent_reduction == 0);
210 		Contributor storage contributor = contributors[_user];
211 		uint256 eth_to_withdraw = contributor.balance.add(contributor.fee);
212 		contributor.balance = 0;
213 		contributor.fee = 0;
214 		_user.transfer(eth_to_withdraw);
215 	}
216 
217 	function partial_refund(address _user) internal {
218 		require(bought_tokens && allow_refunds && rounds == 0 && percent_reduction > 0);
219 		Contributor storage contributor = contributors[_user];
220 		require(contributor.rounds == 0);
221 		uint256 eth_to_withdraw = contributor.balance.mul(percent_reduction).div(100);
222 		contributor.balance = contributor.balance.sub(eth_to_withdraw);
223 		if (owner_supplied_eth) {
224 			uint256 fee = contributor.fee.mul(percent_reduction).div(100);
225 			eth_to_withdraw = eth_to_withdraw.add(fee);
226 		}
227 		_user.transfer(eth_to_withdraw);
228 	}
229 
230 	function take_fees_eth_dev() internal {
231 		if (FEE_DEV != 0) {
232 			DEVELOPER1.transfer(const_contract_eth_value.div(FEE_DEV));
233 			DEVELOPER2.transfer(const_contract_eth_value.div(FEE_DEV));
234 		}
235 	}
236 
237 	function take_fees_eth_owner() internal {
238 		if (FEE_OWNER != 0) {
239 			owner.transfer(const_contract_eth_value.div(FEE_OWNER));
240 		}
241 	}
242 
243 	function calculate_with_fees(uint256 _amount) internal returns (uint256) {
244 		uint256 temp = _amount;
245 		if (FEE_DEV != 0) {
246 			temp = temp.add(_amount.div(FEE_DEV/2));
247 		}
248 		if (FEE_OWNER != 0) {
249 			temp = temp.add(_amount.div(FEE_OWNER));
250 		}
251 		return temp;
252 	}
253 
254 	function tokens_received() internal {
255 		uint256 previous_balance;
256 		for (uint8 i = 0; i < snapshots.length; i++) {
257 			previous_balance = previous_balance.add(snapshots[i].tokens_balance);
258 		}
259 		snapshots.push(Snapshot(token.balanceOf(address(this)).sub(previous_balance), const_contract_eth_value));
260 		rounds++;
261 	}
262 
263 
264   function tokenFallback(address _from, uint _value, bytes _data) {
265 		if (ERC20(msg.sender) == token) {
266 			tokens_received();
267 		}
268 	}
269 
270 	function withdraw_my_tokens() {
271 		for (uint8 i = contributors[msg.sender].rounds; i < rounds; i++) {
272 			withdraw(msg.sender);
273 		}
274 	}
275 
276 	function withdraw_tokens_for(address _addy) {
277 		for (uint8 i = contributors[_addy].rounds; i < rounds; i++) {
278 			withdraw(_addy);
279 		}
280 	}
281 
282 	function refund_my_ether() {
283 		refund(msg.sender);
284 	}
285 
286 	function partial_refund_my_ether() {
287 		partial_refund(msg.sender);
288 	}
289 
290 	function provide_eth() payable {}
291 
292 	function () payable underMaxAmount {
293 		require(!bought_tokens && allow_contributions && (gas_price_max == 0 || tx.gasprice <= gas_price_max));
294 		Contributor storage contributor = contributors[msg.sender];
295 		if (whitelist_enabled) {
296 			require(contributor.whitelisted);
297 		}
298 		uint256 fee = 0;
299 		if (FEE_OWNER != 0) {
300 			fee = SafeMath.div(msg.value, FEE_OWNER);
301 		}
302 		uint256 fees = fee;
303 		if (FEE_DEV != 0) {
304 			fee = msg.value.div(FEE_DEV/2);
305 			fees = fees.add(fee);
306 		}
307 		contributor.balance = contributor.balance.add(msg.value).sub(fees);
308 		contributor.fee = contributor.fee.add(fees);
309 
310 		require(individual_cap == 0 || contributor.balance <= individual_cap);
311 	}
312 }