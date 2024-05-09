1 pragma solidity 0.4.24;
2 
3 /*
4 * @author Ivan Borisov (2622610@gmail.com) (Github.com/pillardevelopment)
5 */
6 library SafeMath {
7 	
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 		if (a == 0) {
10 			return 0;
11 		}
12 		uint256 c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	}
16 	
17 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
18 		uint256 c = a / b;
19 		return c;
20 	}
21 	
22 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23 		assert(b <= a);
24 		return a - b;
25 	}
26 	
27 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 		uint256 c = a + b;
29 		assert(c >= a);
30 		return c;
31 	}
32 }
33 
34 interface ERC20 {
35 	function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
36 	function transferFromICO(address _to, uint256 _value) external returns(bool);
37 	function balanceOf(address who) external view returns (uint256);
38 }
39 
40 contract Ownable {
41 	address public owner;
42 	
43 	constructor() public {
44 		owner = msg.sender;
45 	}
46 	
47 	modifier onlyOwner() {
48 		require(msg.sender == owner);
49 		_;
50 	}
51 }
52 
53 /*********************************************************************************************************************
54 * @dev see https://github.com/ethereum/EIPs/issues/20 */
55 /*************************************************************************************************************/
56 contract WhalesburgCrowdsale is Ownable {
57 	using SafeMath for uint256;
58 	
59 	ERC20 public token;
60 	
61 	address public constant multisig = 0x5ac618ca87b61c1434325b6d60141c90f32590df;
62 	address constant bounty = 0x5ac618ca87b61c1434325b6d60141c90f32590df;
63 	address constant privateInvestors = 0x5ac618ca87b61c1434325b6d60141c90f32590df;
64 	address developers = 0xd7dadf6149FF75f76f36423CAD1E24c81847E85d;
65 	address constant founders = 0xd7dadf6149FF75f76f36423CAD1E24c81847E85d;
66 	
67 	uint256 public startICO = 1527989629; // Sunday, 03-Jun-18 16:00:00 UTC
68 	uint256 public endICO = 1530633600;  // Tuesday, 03-Jul-18 16:00:00 UTC
69 
70 	uint256 constant privateSaleTokens = 46988857;
71 	uint256 constant foundersReserve = 10000000;
72 	uint256 constant developmentReserve = 20500000;
73 	uint256 constant bountyReserve = 3500000;
74 
75 	uint256 public individualRoundCap = 1250000000000000000;
76 
77 	uint256 public constant hardCap = 1365000067400000000000; // 1365.0000674 ether
78 	
79 	uint256 public investors;
80 	
81 	uint256 public membersWhiteList;
82 	
83 	uint256 public constant buyPrice = 71800000000000; // 0.0000718 Ether
84 	
85 	bool public isFinalized = false;
86 	bool public distribute = false;
87 	
88 	uint256 public weisRaised;
89 	
90 	mapping (address => bool) public onChain;
91 	mapping (address => bool) whitelist;
92 	mapping (address => uint256) public moneySpent;
93 	
94 	address[] tokenHolders;
95 	
96 	event Finalized();
97 	event Authorized(address wlCandidate, uint256 timestamp);
98 	event Revoked(address wlCandidate, uint256 timestamp);
99 	
100 	constructor(ERC20 _token) public {
101 		require(_token != address(0));
102 		token = _token;
103 	}
104 	
105 	function setVestingAddress(address _newDevPool) public onlyOwner {
106 		developers = _newDevPool;
107 	}
108 	
109 	function distributionTokens() public onlyOwner {
110 		require(!distribute);
111 		token.transferFromICO(bounty, bountyReserve*1e18);
112 		token.transferFromICO(privateInvestors, privateSaleTokens*1e18);
113 		token.transferFromICO(developers, developmentReserve*1e18);
114 		token.transferFromICO(founders, foundersReserve*1e18);
115 		distribute = true;
116 	}
117 	
118 	/******************-- WhiteList --***************************/
119 	function authorize(address _beneficiary) public onlyOwner  {
120 		require(_beneficiary != address(0x0));
121 		require(!isWhitelisted(_beneficiary));
122 		whitelist[_beneficiary] = true;
123 		membersWhiteList++;
124 		emit Authorized(_beneficiary, now);
125 	}
126 	
127 	function addManyAuthorizeToWhitelist(address[] _beneficiaries) public onlyOwner {
128 		for (uint256 i = 0; i < _beneficiaries.length; i++) {
129 			authorize(_beneficiaries[i]);
130 		}
131 	}
132 	
133 	function revoke(address _beneficiary) public  onlyOwner {
134 		whitelist[_beneficiary] = false;
135 		emit Revoked(_beneficiary, now);
136 	}
137 	
138 	function isWhitelisted(address who) public view returns(bool) {
139 		return whitelist[who];
140 	}
141 	
142 	function finalize() onlyOwner public {
143 		require(!isFinalized);
144 		require(now >= endICO || weisRaised >= hardCap);
145 		emit Finalized();
146 		isFinalized = true;
147 		token.transferFromICO(owner, token.balanceOf(this));
148 	}
149 	
150 	/***************************--Payable --*********************************************/
151 	
152 	function () public payable {
153 		if(isWhitelisted(msg.sender)) {
154 			require(now >= startICO && now < endICO);
155 			currentSaleLimit();
156 			moneySpent[msg.sender] = moneySpent[msg.sender].add(msg.value);
157 			require(moneySpent[msg.sender] <= individualRoundCap);
158 			sell(msg.sender, msg.value);
159 			weisRaised = weisRaised.add(msg.value);
160 			require(weisRaised <= hardCap);
161 			multisig.transfer(msg.value);
162 		} else {
163 			revert();
164 		}
165 	}
166 	
167 	function currentSaleLimit() private {
168 		if(now >= startICO && now < startICO+7200) {
169 			
170 			individualRoundCap = 1250000000000000000; // 1.25 ETH
171 		}
172 		else if(now >= startICO+7200 && now < startICO+14400) {
173 			
174 			individualRoundCap = 3750000000000000000; // 3.75 ETH
175 		}
176 		else if(now >= startICO+14400 && now < endICO) {
177 			
178 			individualRoundCap = hardCap; // 1365 ether
179 		}
180 		else {
181 			revert();
182 		}
183 	}
184 	
185 	function sell(address _investor, uint256 amount) private {
186 		uint256 _amount = amount.mul(1e18).div(buyPrice);
187 		token.transferFromICO(_investor, _amount);
188 		if (!onChain[msg.sender]) {
189 			tokenHolders.push(msg.sender);
190 			onChain[msg.sender] = true;
191 		}
192 		investors = tokenHolders.length;
193 	}
194 }