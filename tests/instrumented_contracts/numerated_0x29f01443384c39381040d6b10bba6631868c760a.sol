1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
6 		uint256 c = a + b;
7 		assert(a <= c);
8 		return c;
9 	}
10 
11 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12 		assert(a >= b);
13 		return a - b;
14 	}
15 
16 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17 		uint256 c = a * b;
18 		assert(a == 0 || c / a == b);
19 		return c;
20 	}
21 
22 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
23 		return a / b;
24 	}
25 }
26 
27 
28 contract ContractReceiver {
29 	function tokenFallback(address from, uint256 value, bytes data) public;
30 }
31 
32 
33 contract AuctusToken {
34 	function transfer(address to, uint256 value) public returns (bool);
35 	function transfer(address to, uint256 value, bytes data) public returns (bool);
36 	function burn(uint256 value) public returns (bool);
37 	function setTokenSaleFinished() public;
38 }
39 
40 
41 contract AuctusWhitelist {
42 	function getAllowedAmountToContribute(address addr) view public returns(uint256);
43 }
44 
45 
46 contract AuctusTokenSale is ContractReceiver {
47 	using SafeMath for uint256;
48 
49 	address public auctusTokenAddress = 0xfD89de68b246eB3e21B06e9B65450AC28D222488;
50 	address public auctusWhiteListAddress = 0xA6e728E524c1D7A65fE5193cA1636265DE9Bc982;
51 
52 	uint256 public startTime = 1522159200; //2018-03-27 2 PM UTC
53 	uint256 public endTime; 
54 
55 	uint256 public basicPricePerEth = 2000;
56 
57 	address public owner;
58 	uint256 public softCap;
59 	uint256 public remainingTokens;
60 	uint256 public weiRaised;
61 	mapping(address => uint256) public invested;
62 
63 	bool public saleWasSet;
64 	bool public tokenSaleHalted;
65 
66 	event Buy(address indexed buyer, uint256 tokenAmount);
67 	event Revoke(address indexed buyer, uint256 investedAmount);
68 
69 	function AuctusTokenSale(uint256 minimumCap, uint256 endSaleTime) public {
70 		owner = msg.sender;
71 		softCap = minimumCap;
72 		endTime = endSaleTime;
73 		saleWasSet = false;
74 		tokenSaleHalted = false;
75 	}
76 
77 	modifier onlyOwner() {
78 		require(owner == msg.sender);
79 		_;
80 	}
81 
82 	modifier openSale() {
83 		require(saleWasSet && !tokenSaleHalted && now >= startTime && now <= endTime && remainingTokens > 0);
84 		_;
85 	}
86 
87 	modifier saleCompletedSuccessfully() {
88 		require(weiRaised >= softCap && (now > endTime || remainingTokens == 0));
89 		_;
90 	}
91 
92 	modifier saleFailed() {
93 		require(weiRaised < softCap && now > endTime);
94 		_;
95 	}
96 
97 	function transferOwnership(address newOwner) onlyOwner public {
98 		require(newOwner != address(0));
99 		owner = newOwner;
100 	}
101 
102 	function setTokenSaleHalt(bool halted) onlyOwner public {
103 		tokenSaleHalted = halted;
104 	}
105 
106 	function setSoftCap(uint256 minimumCap) onlyOwner public {
107 		require(now < startTime);
108 		softCap = minimumCap;
109 	}
110 
111 	function setEndSaleTime(uint256 endSaleTime) onlyOwner public {
112 		require(now < endTime);
113 		endTime = endSaleTime;
114 	}
115 
116 	function tokenFallback(address, uint256 value, bytes) public {
117 		require(msg.sender == auctusTokenAddress);
118 		require(!saleWasSet);
119 		setTokenSaleDistribution(value);
120 	}
121 
122 	function()
123 		payable
124 		openSale
125 		public
126 	{
127 		uint256 weiToInvest;
128 		uint256 weiRemaining;
129 		(weiToInvest, weiRemaining) = getValueToInvest();
130 
131 		require(weiToInvest > 0);
132 
133 		uint256 tokensToReceive = weiToInvest.mul(basicPricePerEth);
134 		remainingTokens = remainingTokens.sub(tokensToReceive);
135 		weiRaised = weiRaised.add(weiToInvest);
136 		invested[msg.sender] = invested[msg.sender].add(weiToInvest);
137 
138 		if (weiRemaining > 0) {
139 			msg.sender.transfer(weiRemaining);
140 		}
141 		assert(AuctusToken(auctusTokenAddress).transfer(msg.sender, tokensToReceive));
142 
143 		emit Buy(msg.sender, tokensToReceive);
144 	}
145 
146 	function revoke() saleFailed public {
147 		uint256 investedValue = invested[msg.sender];
148 		require(investedValue > 0);
149 
150 		invested[msg.sender] = 0;
151 		msg.sender.transfer(investedValue);
152 
153 		emit Revoke(msg.sender, investedValue);
154 	}
155 
156 	function finish() 
157 		onlyOwner
158 		saleCompletedSuccessfully 
159 		public 
160 	{
161 		//40% of the ethers are unvested
162 		uint256 freeEthers = address(this).balance * 40 / 100;
163 		uint256 vestedEthers = address(this).balance - freeEthers;
164 
165 		address(0xd1B10607921C78D9a00529294C4b99f1bd250E1c).transfer(freeEthers); //Owner
166 		assert(address(0x0285d35508e1A1f833142EB5211adb858Bd3323A).call.value(vestedEthers)()); //AuctusEtherVesting SC
167 
168 		AuctusToken token = AuctusToken(auctusTokenAddress);
169 		token.setTokenSaleFinished();
170 		if (remainingTokens > 0) {
171 			token.burn(remainingTokens);
172 			remainingTokens = 0;
173 		}
174 	}
175 
176 	function getValueToInvest() view private returns (uint256, uint256) {
177 		uint256 allowedValue = AuctusWhitelist(auctusWhiteListAddress).getAllowedAmountToContribute(msg.sender);
178 
179 		uint256 weiToInvest;
180 		if (allowedValue == 0) {
181 			weiToInvest = 0;
182 		} else if (allowedValue >= invested[msg.sender].add(msg.value)) {
183 			weiToInvest = getAllowedAmount(msg.value);
184 		} else {
185 			weiToInvest = getAllowedAmount(allowedValue.sub(invested[msg.sender]));
186 		}
187 		return (weiToInvest, msg.value.sub(weiToInvest));
188 	}
189 
190 	function getAllowedAmount(uint256 value) view private returns (uint256) {
191 		uint256 maximumValue = remainingTokens / basicPricePerEth;
192 		if (value > maximumValue) {
193 			return maximumValue;
194 		} else {
195 			return value;
196 		}
197 	}
198 
199 	function setTokenSaleDistribution(uint256 totalAmount) private {
200 		//Auctus core team 20%
201 		uint256 auctusCoreTeam = totalAmount * 20 / 100;
202 		//Bounty 2%
203 		uint256 bounty = totalAmount * 2 / 100;
204 		//Reserve for Future 18%
205 		uint256 reserveForFuture = totalAmount * 18 / 100;
206 		//Partnerships and Advisory free amount 1.8%
207 		uint256 partnershipsAdvisoryFree = totalAmount * 18 / 1000;
208 		//Partnerships and Advisory vested amount 7.2%
209 		uint256 partnershipsAdvisoryVested = totalAmount * 72 / 1000;
210 
211 		uint256 privateSales = 2970000000000000000000000;
212 		uint256 preSale = 2397307557007329968290000;
213 
214 		transferTokens(auctusCoreTeam, bounty, reserveForFuture, preSale, partnershipsAdvisoryVested, partnershipsAdvisoryFree, privateSales);
215 		
216 		remainingTokens = totalAmount - auctusCoreTeam - bounty - reserveForFuture - preSale - partnershipsAdvisoryVested - partnershipsAdvisoryFree - privateSales;
217 		saleWasSet = true;
218 	}
219 	
220 	function transferTokens(
221 		uint256 auctusCoreTeam,
222 		uint256 bounty,
223 		uint256 reserveForFuture,
224 		uint256 preSale,
225 		uint256 partnershipsAdvisoryVested,
226 		uint256 partnershipsAdvisoryFree,
227 		uint256 privateSales
228 	) private {
229 		AuctusToken token = AuctusToken(auctusTokenAddress);
230 		bytes memory empty;
231 		assert(token.transfer(0x6bc58c572d0973cF0EfA1Fe1D7D6c9d7Eea2cd23, auctusCoreTeam, empty)); //AuctusTokenVesting SC
232 		assert(token.transfer(0x936Cf3e904B83B1D939C41475DC5F7c470419A3E, bounty, empty)); //AuctusBountyDistribution SC
233 		assert(token.transfer(0xF5ad5fF703D0AD0df3bAb3A1194FbCC5c152bf3b, reserveForFuture, empty)); //AuctusTokenVesting SC
234 		assert(token.transfer(0x2cE4FAb9F313F1df0978869C5d302768F1bB471d, preSale, empty)); //AuctusPreSaleDistribution SC
235 		assert(token.transfer(0x03f6278E5c359a5E8947a62E87D85AC394580d13, partnershipsAdvisoryVested, empty)); //AuctusTokenVesting SC
236 		assert(token.transfer(0x6c89Cc03036193d52e9b8386413b545184BDAb99, partnershipsAdvisoryFree));
237 		assert(token.transfer(0xd1B10607921C78D9a00529294C4b99f1bd250E1c, privateSales));
238 	}
239 }