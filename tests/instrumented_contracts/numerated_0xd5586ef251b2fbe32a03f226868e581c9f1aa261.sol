1 pragma solidity ^0.4.21;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12 		if (a == 0) {
13 			return 0;
14 		}
15 		uint256 c = a * b;
16 		assert(c / a == b);
17 		return c;
18 	}
19 	
20 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
21 		// assert(b > 0); // Solidity automatically throws when dividing by 0
22 		uint256 c = a / b;
23 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 		return c;
25 	}
26 	
27 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28 		assert(b <= a);
29 		return a - b;
30 	}
31 	
32 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
33 		uint256 c = a + b;
34 		assert(c >= a);
35 		return c;
36 	}
37 }
38 
39 /**
40  * Changes by https://www.docademic.com/
41  */
42 
43 /**
44  * @title MultiOwnable
45  * @dev The MultiOwnable contract has multiple owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract MultiOwnable {
49 	
50 	address[] public owners;
51 	mapping(address => bool) public isOwner;
52 	
53 	event OwnerAddition(address indexed owner);
54 	event OwnerRemoval(address indexed owner);
55 	
56 	/**
57 	 * @dev The MultiOwnable constructor sets the original `owner` of the contract to the sender
58 	 * account.
59 	 */
60 	function MultiOwnable() public {
61 		isOwner[msg.sender] = true;
62 		owners.push(msg.sender);
63 	}
64 	
65 	/**
66    * @dev Throws if called by any account other than the owner.
67    */
68 	modifier onlyOwner() {
69 		require(isOwner[msg.sender]);
70 		_;
71 	}
72 	
73 	/**
74 	 * @dev Throws if called by an owner.
75 	 */
76 	modifier ownerDoesNotExist(address _owner) {
77 		require(!isOwner[_owner]);
78 		_;
79 	}
80 	
81 	/**
82 	 * @dev Throws if called by any account other than the owner.
83 	 */
84 	modifier ownerExists(address _owner) {
85 		require(isOwner[_owner]);
86 		_;
87 	}
88 	
89 	/**
90 	 * @dev Throws if called with a null address.
91 	 */
92 	modifier notNull(address _address) {
93 		require(_address != 0);
94 		_;
95 	}
96 	
97 	/**
98 	 * @dev Allows to add a new owner. Transaction has to be sent by an owner.
99 	 * @param _owner Address of new owner.
100 	 */
101 	function addOwner(address _owner)
102 	public
103 	onlyOwner
104 	ownerDoesNotExist(_owner)
105 	notNull(_owner)
106 	{
107 		isOwner[_owner] = true;
108 		owners.push(_owner);
109 		emit OwnerAddition(_owner);
110 	}
111 	
112 	/**
113 	 * @dev Allows to remove an owner. Transaction has to be sent by wallet.
114 	 * @param _owner Address of owner.
115 	 */
116 	function removeOwner(address _owner)
117 	public
118 	onlyOwner
119 	ownerExists(_owner)
120 	{
121 		isOwner[_owner] = false;
122 		for (uint i = 0; i < owners.length - 1; i++)
123 			if (owners[i] == _owner) {
124 				owners[i] = owners[owners.length - 1];
125 				break;
126 			}
127 		owners.length -= 1;
128 		emit OwnerRemoval(_owner);
129 	}
130 	
131 }
132 
133 contract DestroyableMultiOwner is MultiOwnable {
134 	/**
135 	 * @notice Allows to destroy the contract and return the tokens to the owner.
136 	 */
137 	function destroy() public onlyOwner {
138 		selfdestruct(owners[0]);
139 	}
140 }
141 
142 interface Token {
143 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
144 }
145 
146 contract BrokerImp is DestroyableMultiOwner {
147 	using SafeMath for uint256;
148 	
149 	Token public token;
150 	uint256 public commission;
151 	address public broker;
152 	address public pool;
153 	uint256 public ethReward;
154 	mapping(address => bool) public ethSent;
155 	
156 	event CommissionChanged(uint256 _previousCommission, uint256 _commision);
157 	event EthRewardChanged(uint256 _previousEthReward, uint256 _ethReward);
158 	event BrokerChanged(address _previousBroker, address _broker);
159 	event PoolChanged(address _previousPool, address _pool);
160 	
161 	/**
162 	 * @dev Constructor.
163 	 * @param _token The token address
164 	 * @param _pool The pool of tokens address
165 	 * @param _commission The percentage of the commission 0-100
166 	 * @param _broker The broker address
167 	 * @param _ethReward The eth to send to the beneficiary of the reward only once in wei
168 	 */
169 	function BrokerImp(address _token, address _pool, uint256 _commission, address _broker, uint256 _ethReward) public {
170 		require(_token != address(0));
171 		token = Token(_token);
172 		pool = _pool;
173 		commission = _commission;
174 		broker = _broker;
175 		ethReward = _ethReward;
176 	}
177 	
178 	/**
179 	 * @dev Allows to fund the contract with ETH.
180 	 */
181 	function fund(uint256 amount) payable public {
182 		require(msg.value == amount);
183 	}
184 	
185 	/**
186 	 * @dev Allows the owner make a reward.
187 	 * @param _beneficiary the beneficiary address
188 	 * @param _value the tokens reward in wei
189 	 */
190 	function reward(address _beneficiary, uint256 _value) public onlyOwner returns (bool) {
191 		uint256 hundred = uint256(100);
192 		uint256 beneficiaryPart = hundred.sub(commission);
193 		uint256 total = (_value.div(beneficiaryPart)).mul(hundred);
194 		uint256 brokerCommission = total.sub(_value);
195 		if (!ethSent[_beneficiary]) {
196 			_beneficiary.transfer(ethReward);
197 			ethSent[_beneficiary] = true;
198 		}
199 		return (
200 		token.transferFrom(pool, broker, brokerCommission) &&
201 		token.transferFrom(pool, _beneficiary, _value)
202 		);
203 	}
204 	
205 	/**
206 	 * @dev Allows the owner to change the commission of the reward.
207 	 * @param _commission The percentage of the commission 0-100
208 	 */
209 	function changeCommission(uint256 _commission) public onlyOwner {
210 		emit CommissionChanged(commission, _commission);
211 		commission = _commission;
212 	}
213 	
214 	/**
215 	 * @dev Allows the owner to withdraw the balance of the tokens.
216 	 * @param _ethReward The eth reward to send to the beneficiary in wei
217 	 */
218 	function changeEthReward(uint256 _ethReward) public onlyOwner {
219 		emit EthRewardChanged(ethReward, _ethReward);
220 		ethReward = _ethReward;
221 	}
222 	
223 	/**
224 	 * @dev Allows the owner to change the broker.
225 	 * @param _broker The broker address
226 	 */
227 	function changeBroker(address _broker) public onlyOwner {
228 		emit BrokerChanged(broker, _broker);
229 		broker = _broker;
230 	}
231 	
232 	/**
233 	 * @dev Allows the owner to change the pool of tokens.
234 	 * @param _pool The pool address
235 	 */
236 	function changePool(address _pool) public onlyOwner {
237 		emit PoolChanged(pool, _pool);
238 		pool = _pool;
239 	}
240 }