1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5 	function times(uint256 x, uint256 y) internal returns (uint256) {
6 		uint256 z = x * y;
7 		assert(x == 0 || (z / x == y));
8 		return z;
9 	}
10 
11 	function minus(uint256 x, uint256 y) internal returns (uint256) {
12 		assert(y <= x);
13 		return x - y;
14 	}
15 
16 	function plus(uint256 x, uint256 y) internal returns (uint256) {
17 		uint256 z = x + y;
18 		assert(z >= x && z >= y);
19 		return z;
20 	}
21 }
22 
23 
24 contract ERC20Simplified {
25   function balanceOf(address who) constant returns (uint256);
26   function transfer(address to, uint256 value) returns (bool);
27 }
28 
29 
30 contract AuctusPreSale {
31 	using SafeMath for uint256;
32 	
33 	struct TokenInfo {
34 		uint256 tokenAmount; 
35 		uint256 weiInvested;
36 	}
37 	
38 	address public owner;
39 	address public multiSigWallet = 0xed62dbc89f22dae81013e48928ef4395fa19e51b;
40 	
41 	uint256 public startTime = 1507039200; 
42 	uint256 public endTime = 1507298400; 
43 	
44 	uint256 public minimumCap = 400 ether;
45 	uint256 public maximumCap = 90000 ether;
46 	uint256 public maximumIndividualCap = 10 ether;
47 	
48 	uint256 public basicPricePerEth = 2500;
49 	
50 	uint256 public tokenSold;
51 	uint256 public weiRaised;
52 	
53 	bool public preSaleHalted;
54 	
55 	mapping(address => TokenInfo) public balances;
56 	mapping(address => uint256) public whitelist;
57 	
58 	event Buy(address indexed recipient, uint256 tokenAmount);
59 	event Revoke(address indexed recipient, uint256 weiAmount);
60 	event ListAddress(address indexed who, uint256 individualCap);
61 	event Drain(uint256 weiAmount);
62 	
63 	modifier onlyOwner() {
64 		require(msg.sender == owner);
65 		_;
66 	}
67 	
68 	modifier validPayload(uint256 size) { 
69 		require(msg.data.length >= (size + 4));
70 		_;
71 	}
72 	
73 	modifier preSalePeriod() {
74 		require(now >= startTime && now <= endTime && weiRaised < maximumCap);
75 		_;
76 	}
77 	
78 	modifier preSaleCompletedSuccessfully() {
79 		require(weiRaised >= minimumCap && (now > endTime || weiRaised >= maximumCap));
80 		_;
81 	}
82 	
83 	modifier preSaleFailed() {
84 		require(weiRaised < minimumCap && now > endTime);
85 		_;
86 	}
87 	
88 	modifier isPreSaleNotHalted() {
89 		require(!preSaleHalted);
90 		_;
91 	}
92 	
93 	function AuctusPreSale() {
94 		owner = msg.sender;
95 	}
96 	
97 	function getTokenAmount(address who) constant returns (uint256) {
98 		return balances[who].tokenAmount;
99 	}
100 	
101 	function getWeiInvested(address who) constant returns (uint256) {
102 		return balances[who].weiInvested;
103 	}
104 	
105 	function() 
106 		payable 
107 		preSalePeriod 
108 		isPreSaleNotHalted 
109 	{
110 		require(balances[msg.sender].weiInvested < whitelist[msg.sender]);
111 		
112 		var (weiToInvest, weiRemaining) = getValueToInvest();
113 		
114 		uint256 amountToReceive = weiToInvest.times(basicPricePerEth);
115 		balances[msg.sender].tokenAmount = balances[msg.sender].tokenAmount.plus(amountToReceive);
116 		balances[msg.sender].weiInvested = balances[msg.sender].weiInvested.plus(weiToInvest);
117 		
118 		tokenSold = tokenSold.plus(amountToReceive);
119 		weiRaised = weiRaised.plus(weiToInvest);
120 		
121 		if (weiRemaining > 0) {
122 			msg.sender.transfer(weiRemaining);
123 		}
124 		
125 		Buy(msg.sender, amountToReceive);
126 	}
127 	
128 	function revoke() preSaleFailed {
129 		uint256 weiAmount = balances[msg.sender].weiInvested;
130 		assert(weiAmount > 0);
131 		
132 		balances[msg.sender].weiInvested = 0;
133 		msg.sender.transfer(weiAmount);
134 		
135 		Revoke(msg.sender, weiAmount);
136 	}
137 	
138 	function setPreSaleHalt(bool halted) onlyOwner {
139 		preSaleHalted = halted;
140 	}
141 	
142 	function transferOwnership(address newOwner) 
143 		onlyOwner
144 		validPayload(32)
145 	{
146         owner = newOwner;
147     }
148 	
149 	function listAddress(address who, uint256 individualCap) 
150 		onlyOwner 
151 		validPayload(32 * 2)
152 	{
153         whitelist[who] = individualCap;
154         ListAddress(who, individualCap);
155     }
156 
157     function listAddresses(address[] addresses) onlyOwner {
158         for (uint256 i = 0; i < addresses.length; i++) {
159             listAddress(addresses[i], maximumIndividualCap);
160         }
161     }
162 	
163 	function drain() 
164 		onlyOwner 
165 		preSaleCompletedSuccessfully
166 	{
167 		uint256 weiAmount = this.balance;
168 		multiSigWallet.transfer(weiAmount);
169 		
170 		Drain(weiAmount);
171 	}
172 	
173 	function drainERC20(ERC20Simplified erc20Token) 
174 		onlyOwner 
175 		validPayload(32)
176 	{
177 		require(erc20Token.transfer(multiSigWallet, erc20Token.balanceOf(this)));
178     }
179 	
180 	function getValueToInvest() internal returns (uint256, uint256) {
181 		uint256 newWeiInvested = balances[msg.sender].weiInvested.plus(msg.value);
182 		
183 		uint256 weiToInvest;
184 		uint256 weiRemaining;
185 		if (newWeiInvested <= whitelist[msg.sender]) {
186 			weiToInvest = msg.value;
187 			weiRemaining = 0;
188 		} else {
189 			weiToInvest = whitelist[msg.sender].minus(balances[msg.sender].weiInvested);
190 			weiRemaining = msg.value.minus(weiToInvest);
191 		}
192 		
193 		return (weiToInvest, weiRemaining);
194 	}
195 }