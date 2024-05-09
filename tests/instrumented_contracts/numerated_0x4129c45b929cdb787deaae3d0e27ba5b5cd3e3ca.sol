1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * Changes by https://www.docademic.com/
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 		if (a == 0) {
15 			return 0;
16 		}
17 		uint256 c = a * b;
18 		assert(c / a == b);
19 		return c;
20 	}
21 	
22 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 		// assert(b > 0); // Solidity automatically throws when dividing by 0
24 		uint256 c = a / b;
25 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
26 		return c;
27 	}
28 	
29 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30 		assert(b <= a);
31 		return a - b;
32 	}
33 	
34 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
35 		uint256 c = a + b;
36 		assert(c >= a);
37 		return c;
38 	}
39 }
40 
41 /**
42  * Changes by https://www.docademic.com/
43  */
44 
45 /**
46  * @title MultiOwnable
47  * @dev The MultiOwnable contract has multiple owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract MultiOwnable {
51 	
52 	address[] public owners;
53 	mapping(address => bool) public isOwner;
54 	
55 	event OwnerAddition(address indexed owner);
56 	event OwnerRemoval(address indexed owner);
57 	
58 	/**
59 	 * @dev The MultiOwnable constructor sets the original `owner` of the contract to the sender
60 	 * account.
61 	 */
62 	function MultiOwnable() public {
63 		isOwner[msg.sender] = true;
64 		owners.push(msg.sender);
65 	}
66 	
67 	/**
68    * @dev Throws if called by any account other than the owner.
69    */
70 	modifier onlyOwner() {
71 		require(isOwner[msg.sender]);
72 		_;
73 	}
74 	
75 	/**
76 	 * @dev Throws if called by an owner.
77 	 */
78 	modifier ownerDoesNotExist(address _owner) {
79 		require(!isOwner[_owner]);
80 		_;
81 	}
82 	
83 	/**
84 	 * @dev Throws if called by any account other than the owner.
85 	 */
86 	modifier ownerExists(address _owner) {
87 		require(isOwner[_owner]);
88 		_;
89 	}
90 	
91 	/**
92 	 * @dev Throws if called with a null address.
93 	 */
94 	modifier notNull(address _address) {
95 		require(_address != 0);
96 		_;
97 	}
98 	
99 	/**
100 	 * @dev Allows to add a new owner. Transaction has to be sent by an owner.
101 	 * @param _owner Address of new owner.
102 	 */
103 	function addOwner(address _owner)
104 	public
105 	onlyOwner
106 	ownerDoesNotExist(_owner)
107 	notNull(_owner)
108 	{
109 		isOwner[_owner] = true;
110 		owners.push(_owner);
111 		emit OwnerAddition(_owner);
112 	}
113 	
114 	/**
115 	 * @dev Allows to remove an owner. Transaction has to be sent by wallet.
116 	 * @param _owner Address of owner.
117 	 */
118 	function removeOwner(address _owner)
119 	public
120 	onlyOwner
121 	ownerExists(_owner)
122 	{
123 		isOwner[_owner] = false;
124 		for (uint i = 0; i < owners.length - 1; i++)
125 			if (owners[i] == _owner) {
126 				owners[i] = owners[owners.length - 1];
127 				break;
128 			}
129 		owners.length -= 1;
130 		emit OwnerRemoval(_owner);
131 	}
132 	
133 }
134 
135 contract DestroyableMultiOwner is MultiOwnable {
136 	/**
137 	 * @notice Allows to destroy the contract and return the tokens to the owner.
138 	 */
139 	function destroy() public onlyOwner {
140 		selfdestruct(owners[0]);
141 	}
142 }
143 
144 interface Token {
145 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
146 }
147 
148 contract BrokerImp is MultiOwnable, DestroyableMultiOwner {
149 	using SafeMath for uint256;
150 	
151 	Token public token;
152 	uint256 public commission;
153 	address public broker;
154 	address public pool;
155 	
156 	event CommissionChanged(uint256 _previousCommission, uint256 _commision);
157 	event BrokerChanged(address _previousBroker, address _broker);
158 	event PoolChanged(address _previousPool, address _pool);
159 	
160 	/**
161 	 * @dev Constructor.
162 	 * @param _token The token address
163 	 * @param _pool The pool of tokens address
164 	 * @param _commission The percentage of the commission 0-100
165 	 * @param _broker The broker address
166 	 */
167 	function BrokerImp(address _token, address _pool, uint256 _commission, address _broker) public {
168 		require(_token != address(0));
169 		token = Token(_token);
170 		pool = _pool;
171 		commission = _commission;
172 		broker = _broker;
173 	}
174 	
175 	/**
176 	 * @dev Allows the owner make a reward.
177 	 * @param _beneficiary the beneficiary address
178 	 * @param _value the tokens reward in wei
179 	 */
180 	function reward(address _beneficiary, uint256 _value) public onlyOwner returns (bool) {
181 		uint256 hundred = uint256(100);
182 		uint256 beneficiaryPart = hundred.sub(commission);
183 		uint256 total = (_value.div(beneficiaryPart)).mul(hundred);
184 		uint256 brokerCommission = total.sub(_value);
185 		return (
186 		token.transferFrom(pool, _beneficiary, _value) &&
187 		token.transferFrom(pool, broker, brokerCommission)
188 		);
189 	}
190 	
191 	/**
192 	 * @dev Allows the owner to withdraw the balance of the tokens.
193 	 * @param _commission The percentage of the commission 0-100
194 	 */
195 	function changeCommission(uint256 _commission) public onlyOwner {
196 		emit CommissionChanged(commission, _commission);
197 		commission = _commission;
198 	}
199 	
200 	/**
201 	 * @dev Allows the owner to change the broker.
202 	 * @param _broker The broker address
203 	 */
204 	function changeBroker(address _broker) public onlyOwner {
205 		emit BrokerChanged(broker, _broker);
206 		broker = _broker;
207 	}
208 	
209 	/**
210 	 * @dev Allows the owner to change the pool of tokens.
211 	 * @param _pool The pool address
212 	 */
213 	function changePool(address _pool) public onlyOwner {
214 		emit PoolChanged(pool, _pool);
215 		pool = _pool;
216 	}
217 }