1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 	
5 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 		if (a == 0) {
7 			return 0;
8 		}
9 		uint256 c = a * b;
10 		assert(c / a == b);
11 		return c;
12 	}
13 	
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15 		uint256 c = a / b;
16 		return c;
17 	}
18 	
19 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20 		assert(b <= a);
21 		return a - b;
22 	}
23 	
24 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
25 		uint256 c = a + b;
26 		assert(c >= a);
27 		return c;
28 	}
29 }
30 
31 interface ERC20 {
32 	function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
33 	function transferFromICO(address _to, uint256 _value) external returns(bool);
34 	function balanceOf(address who) external view returns (uint256);
35 }
36 
37 contract Ownable {
38 	address public owner;
39 	
40 	constructor() public {
41 		owner = msg.sender;
42 	}
43 	
44 	modifier onlyOwner() {
45 		require(msg.sender == owner);
46 		_;
47 	}
48 }
49 
50 /*********************************************************************************************************************
51 * @dev see https://github.com/ethereum/EIPs/issues/20 */
52 /*************************************************************************************************************/
53 contract WhalesburgCrowdsale is Ownable {
54 	using SafeMath for uint256;
55 	
56 	ERC20 public token;
57 	
58 	address public constant multisig = 0x5dc5c66eb90dd8c4be285164ca9ea442faa1c2e8;
59 	address constant bounty = 0x96abf0420cffe408ba6bb16699f6748bef01b02b;
60 	address constant privateInvestors = 0x44eedeecc2a6f5f763a18e8876576b29a856d03a;
61 	address developers = 0x8e23cd7ce780e55ace7309b398336443b408c9d4;
62 	address constant founders = 0xd7dadf6149FF75f76f36423CAD1E24c81847E85d;
63 	
64 	uint256 public startICO = 1528041600; // Sunday, 03-Jun-18 16:00:00 UTC
65 	uint256 public endICO = 1530633600;  // Tuesday, 03-Jul-18 16:00:00 UTC
66 
67 	uint256 constant privateSaleTokens = 46988857;
68 	uint256 constant foundersReserve = 10000000;
69 	uint256 constant developmentReserve = 20500000;
70 	uint256 constant bountyReserve = 3500000;
71 
72 	uint256 public individualRoundCap = 1250000000000000000;
73 
74 	uint256 public constant hardCap = 1365000067400000000000; // 1365.0000674 ether
75 	
76 	uint256 public investors;
77 	
78 	uint256 public constant buyPrice = 71800000000000; // 0.0000718 Ether
79 	
80 	bool public isFinalized = false;
81 	bool public distribute = false;
82 	
83 	uint256 public weisRaised;
84 	
85 	mapping (address => bool) public onChain;
86 	mapping (address => bool) whitelist;
87 	mapping (address => uint256) public moneySpent;
88 	
89 	address[] tokenHolders;
90 	
91 	event Finalized();
92 	event Authorized(address wlCandidate, uint256 timestamp);
93 	event Revoked(address wlCandidate, uint256 timestamp);
94 	
95 	constructor(ERC20 _token) public {
96 		require(_token != address(0));
97 		token = _token;
98 	}
99 	
100 	function setVestingAddress(address _newDevPool) public onlyOwner {
101 		developers = _newDevPool;
102 	}
103 	
104 	function distributionTokens() public onlyOwner {
105 		require(!distribute);
106 		token.transferFromICO(bounty, bountyReserve*1e18);
107 		token.transferFromICO(privateInvestors, privateSaleTokens*1e18);
108 		token.transferFromICO(developers, developmentReserve*1e18);
109 		token.transferFromICO(founders, foundersReserve*1e18);
110 		distribute = true;
111 	}
112 	
113 	/******************-- WhiteList --***************************/
114 	function authorize(address _beneficiary) public onlyOwner  {
115 		require(_beneficiary != address(0x0));
116 		require(!isWhitelisted(_beneficiary));
117 		whitelist[_beneficiary] = true;
118 		emit Authorized(_beneficiary, now);
119 	}
120 	
121 	function addManyAuthorizeToWhitelist(address[] _beneficiaries) public onlyOwner {
122 		for (uint256 i = 0; i < _beneficiaries.length; i++) {
123 			authorize(_beneficiaries[i]);
124 		}
125 	}
126 	
127 	function revoke(address _beneficiary) public  onlyOwner {
128 		whitelist[_beneficiary] = false;
129 		emit Revoked(_beneficiary, now);
130 	}
131 	
132 	function isWhitelisted(address who) public view returns(bool) {
133 		return whitelist[who];
134 	}
135 	
136 	function finalize() onlyOwner public {
137 		require(!isFinalized);
138 		require(now >= endICO || weisRaised >= hardCap);
139 		emit Finalized();
140 		isFinalized = true;
141 		token.transferFromICO(owner, token.balanceOf(this));
142 	}
143 	
144 	/***************************--Payable --*********************************************/
145 	
146 	function () public payable {
147 		if(isWhitelisted(msg.sender)) {
148 			require(now >= startICO && now < endICO);
149 			currentSaleLimit();
150 			moneySpent[msg.sender] = moneySpent[msg.sender].add(msg.value);
151 			require(moneySpent[msg.sender] <= individualRoundCap);
152 			sell(msg.sender, msg.value);
153 			weisRaised = weisRaised.add(msg.value);
154 			require(weisRaised <= hardCap);
155 			multisig.transfer(msg.value);
156 		} else {
157 			revert();
158 		}
159 	}
160 	
161 	function currentSaleLimit() private {
162 		if(now >= startICO && now < startICO+7200) {
163 			
164 			individualRoundCap = 1250000000000000000; // 1.25 ETH
165 		}
166 		else if(now >= startICO+7200 && now < startICO+14400) {
167 			
168 			individualRoundCap = 3750000000000000000; // 3.75 ETH
169 		}
170 		else if(now >= startICO+14400 && now < endICO) {
171 			
172 			individualRoundCap = hardCap; // 1365 ether
173 		}
174 		else {
175 			revert();
176 		}
177 	}
178 	
179 	function sell(address _investor, uint256 amount) private {
180 		uint256 _amount = amount.mul(1e18).div(buyPrice);
181 		token.transferFromICO(_investor, _amount);
182 		if (!onChain[msg.sender]) {
183 			tokenHolders.push(msg.sender);
184 			onChain[msg.sender] = true;
185 		}
186 		investors = tokenHolders.length;
187 	}
188 }