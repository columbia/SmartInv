1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal returns(uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8     }
9     
10     function div(uint256 a, uint256 b) internal returns(uint256) {
11 		uint256 c = a / b;
12 		return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal returns(uint256) {
16 		assert(b <= a);
17 		return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal returns(uint256) {
21 		uint256 c = a + b;
22 		assert(c >= a && c >= b);
23 		return c;
24     }
25 }
26 
27 contract Santa {
28     
29     using SafeMath for uint256; 
30 
31     string constant public standard = "ERC20";
32     string constant public symbol = "SANTA";
33     string constant public name = "Santa";
34     uint8 constant public decimals = 18;
35 
36     uint256 constant public initialSupply = 1000000 * 1 ether;
37     uint256 constant public tokensForIco = 600000 * 1 ether;
38     uint256 constant public tokensForBonus = 200000 * 1 ether;
39 
40     uint256 constant public startAirdropTime = 1514116800;
41     uint256 public startTransferTime;
42     uint256 public tokensSold;
43     bool public burned;
44 
45     mapping(address => uint256) public balanceOf;
46     mapping(address => mapping(address => uint256)) public allowance;
47     
48     uint256 constant public start = 1511136000;
49     uint256 constant public end = 1512086399;
50     uint256 constant public tokenExchangeRate = 310;
51     uint256 public amountRaised;
52     bool public crowdsaleClosed = false;
53     address public santaFundWallet;
54     address ethFundWallet;
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed _owner, address indexed spender, uint256 value);
58     event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
59     event Burn(uint256 amount);
60 
61     function Santa(address _ethFundWallet) {
62 		ethFundWallet = _ethFundWallet;
63 		santaFundWallet = msg.sender;
64 		balanceOf[santaFundWallet] = initialSupply;
65 		startTransferTime = end;
66     }
67 
68     function() payable {
69 		uint256 amount = msg.value;
70 		uint256 numTokens = amount.mul(tokenExchangeRate); 
71 		require(!crowdsaleClosed && now >= start && now <= end && tokensSold.add(numTokens) <= tokensForIco);
72 		ethFundWallet.transfer(amount);
73 		balanceOf[santaFundWallet] = balanceOf[santaFundWallet].sub(numTokens); 
74 		balanceOf[msg.sender] = balanceOf[msg.sender].add(numTokens);
75 		Transfer(santaFundWallet, msg.sender, numTokens);
76 		amountRaised = amountRaised.add(amount);
77 		tokensSold += numTokens;
78 		FundTransfer(msg.sender, amount, true, amountRaised);
79     }
80 
81     function transfer(address _to, uint256 _value) returns(bool success) {
82 		require(now >= startTransferTime); 
83 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
84 		balanceOf[_to] = balanceOf[_to].add(_value); 
85 		Transfer(msg.sender, _to, _value); 
86 		return true;
87     }
88 
89     function approve(address _spender, uint256 _value) returns(bool success) {
90 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
91 		allowance[msg.sender][_spender] = _value;
92 		Approval(msg.sender, _spender, _value);
93 		return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
97 		if (now < startTransferTime) {
98 		    require(_from == santaFundWallet);
99 		}
100 		var _allowance = allowance[_from][msg.sender];
101 		require(_value <= _allowance);
102 		balanceOf[_from] = balanceOf[_from].sub(_value); 
103 		balanceOf[_to] = balanceOf[_to].add(_value); 
104 		allowance[_from][msg.sender] = _allowance.sub(_value);
105 		Transfer(_from, _to, _value);
106 		return true;
107     }
108 
109     function burn() internal {
110 		require(now > startTransferTime);
111 		require(burned == false);
112 		uint256 difference = balanceOf[santaFundWallet].sub(tokensForBonus);
113 		tokensSold = tokensForIco.sub(difference);
114 		balanceOf[santaFundWallet] = tokensForBonus;
115 		burned = true;
116 		Burn(difference);
117     }
118 
119     function markCrowdsaleEnding() {
120 		require(now > end);
121 		burn(); 
122 		crowdsaleClosed = true;
123     }
124 
125     function sendGifts(address[] santaGiftList) returns(bool success)  {
126 		require(msg.sender == santaFundWallet);
127 		require(now >= startAirdropTime);
128 	    
129 	    uint256 bonusRate = tokensForBonus.div(tokensSold); 
130 		for(uint i = 0; i < santaGiftList.length; i++) {
131 		    if (balanceOf[santaGiftList[i]] > 0) { 
132 				uint256 bonus = balanceOf[santaGiftList[i]].mul(bonusRate);
133 				transferFrom(santaFundWallet, santaGiftList[i], bonus);
134 		    }
135 		}
136 		return true;
137     }
138 }