1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal returns(uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 	
10 	function div(uint256 a, uint256 b) internal returns(uint256) {
11 		uint256 c = a / b;
12 		return c;
13 	}
14 
15 	function sub(uint256 a, uint256 b) internal returns(uint256) {
16 		assert(b <= a);
17 		return a - b;
18 	}
19 
20 	function add(uint256 a, uint256 b) internal returns(uint256) {
21 		uint256 c = a + b;
22 		assert(c >= a && c >= b);
23 		return c;
24 	}
25 }
26 
27 contract SantaToken {
28     
29     using SafeMath for uint256; 
30 
31 	string constant public standard = "ERC20";
32 	string constant public symbol = "SANTA";
33 	string constant public name = "Santa";
34 	uint8 constant public decimals = 18;
35 
36 	uint256 constant public initialSupply = 1000000 * 1 ether;
37 	uint256 constant public tokensForIco = 600000 * 1 ether;
38 	uint256 constant public tokensForBonus = 200000 * 1 ether;
39 
40 	uint256 constant public startAirdropTime = 1514073600;
41 	uint256 public startTransferTime;
42 	uint256 public tokensSold;
43 	bool public burned;
44 
45 	mapping(address => uint256) public balanceOf;
46 	mapping(address => mapping(address => uint256)) public allowance;
47 	
48 	uint256 constant public start = 1513728000;
49 	uint256 constant public end = 1514678399;
50 	uint256 constant public tokenExchangeRate = 310;
51 	uint256 public amountRaised;
52 	bool public crowdsaleClosed = false;
53 	address public santaFundWallet;
54 	address ethFundWallet;
55 
56 	event Transfer(address indexed from, address indexed to, uint256 value);
57 	event Approval(address indexed _owner, address indexed spender, uint256 value);
58 	event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
59 	event Burn(uint256 amount);
60 
61 	function SantaToken(address _ethFundWallet) {
62 		ethFundWallet = _ethFundWallet;
63 		santaFundWallet = msg.sender;
64 		balanceOf[santaFundWallet] = initialSupply;
65 		startTransferTime = end;
66 	}
67 
68 	function() payable {
69 		uint256 amount = msg.value;
70 		uint256 numTokens = amount.mul(tokenExchangeRate); 
71 		require(numTokens >= 100 * 1 ether);
72 		require(!crowdsaleClosed && now >= start && now <= end && tokensSold.add(numTokens) <= tokensForIco);
73 
74 		ethFundWallet.transfer(amount);
75 		
76 		balanceOf[santaFundWallet] = balanceOf[santaFundWallet].sub(numTokens); 
77 		balanceOf[msg.sender] = balanceOf[msg.sender].add(numTokens);
78 
79 		Transfer(santaFundWallet, msg.sender, numTokens);
80 
81 		amountRaised = amountRaised.add(amount);
82 		tokensSold += numTokens;
83 
84 		FundTransfer(msg.sender, amount, true, amountRaised);
85 	}
86 
87 	function transfer(address _to, uint256 _value) returns(bool success) {
88 		require(now >= startTransferTime); 
89 
90 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
91 		balanceOf[_to] = balanceOf[_to].add(_value); 
92 
93 		Transfer(msg.sender, _to, _value); 
94 
95 		return true;
96 	}
97 
98 	function approve(address _spender, uint256 _value) returns(bool success) {
99 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
100 
101 		allowance[msg.sender][_spender] = _value;
102 
103 		Approval(msg.sender, _spender, _value);
104 
105 		return true;
106 	}
107 
108 	function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
109 		if (now < startTransferTime) 
110 			require(_from == santaFundWallet);
111 		var _allowance = allowance[_from][msg.sender];
112 		require(_value <= _allowance);
113 		
114 		balanceOf[_from] = balanceOf[_from].sub(_value); 
115 		balanceOf[_to] = balanceOf[_to].add(_value); 
116 		allowance[_from][msg.sender] = _allowance.sub(_value);
117 
118 		Transfer(_from, _to, _value);
119 
120 		return true;
121 	}
122 
123 	function burn() internal {
124 		require(now > startTransferTime);
125 		require(burned == false);
126 			
127 		uint256 difference = balanceOf[santaFundWallet].sub(tokensForBonus);
128 		tokensSold = tokensForIco.sub(difference);
129 		balanceOf[santaFundWallet] = tokensForBonus;
130 			
131 		burned = true;
132 
133 		Burn(difference);
134 	}
135 
136 	function markCrowdsaleEnding() {
137 		require(now > end);
138 
139 		burn(); 
140 		crowdsaleClosed = true;
141 	}
142 
143 	function sendGifts(address[] santaGiftList) returns(bool success)  {
144 		require(msg.sender == santaFundWallet);
145 		require(now >= startAirdropTime);
146 	
147 		for(uint i = 0; i < santaGiftList.length; i++) {
148 		    uint256 tokensHold = balanceOf[santaGiftList[i]];
149 			if (tokensHold >= 100 * 1 ether) { 
150 				uint256 bonus = tokensForBonus.div(1 ether);
151 				uint256 giftTokens = ((tokensHold.mul(bonus)).div(tokensSold)) * 1 ether;
152 				transferFrom(santaFundWallet, santaGiftList[i], giftTokens);
153 			}
154 		}
155 		
156 		return true;
157 	}
158 }