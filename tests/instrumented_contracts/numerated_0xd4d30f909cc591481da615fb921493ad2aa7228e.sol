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
40     uint256 constant public startAirdropTime = 1514073600;
41     uint256 public startTransferTime;
42     uint256 public tokensSold;
43     bool public burned;
44 
45     mapping(address => uint256) public balanceOf;
46     mapping(address => mapping(address => uint256)) public allowance;
47     
48     uint256 constant public start = 1513728000;
49     uint256 constant public end = 1514678399;
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
71 		require(numTokens >= 10 * 1 ether);
72 		require(!crowdsaleClosed && now >= start && now <= end && tokensSold.add(numTokens) <= tokensForIco);
73 		ethFundWallet.transfer(amount);
74 		balanceOf[santaFundWallet] = balanceOf[santaFundWallet].sub(numTokens); 
75 		balanceOf[msg.sender] = balanceOf[msg.sender].add(numTokens);
76 		Transfer(santaFundWallet, msg.sender, numTokens);
77 		amountRaised = amountRaised.add(amount);
78 		tokensSold += numTokens;
79 		FundTransfer(msg.sender, amount, true, amountRaised);
80     }
81 
82     function transfer(address _to, uint256 _value) returns(bool success) {
83 		require(now >= startTransferTime); 
84 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
85 		balanceOf[_to] = balanceOf[_to].add(_value); 
86 		Transfer(msg.sender, _to, _value); 
87 		return true;
88     }
89 
90     function approve(address _spender, uint256 _value) returns(bool success) {
91 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
92 		allowance[msg.sender][_spender] = _value;
93 		Approval(msg.sender, _spender, _value);
94 		return true;
95     }
96 
97     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
98 		if (now < startTransferTime) {
99 		    require(_from == santaFundWallet);
100 		}
101 		var _allowance = allowance[_from][msg.sender];
102 		require(_value <= _allowance);
103 		balanceOf[_from] = balanceOf[_from].sub(_value); 
104 		balanceOf[_to] = balanceOf[_to].add(_value); 
105 		allowance[_from][msg.sender] = _allowance.sub(_value);
106 		Transfer(_from, _to, _value);
107 		return true;
108     }
109 
110     function burn() internal {
111 		require(now > startTransferTime);
112 		require(burned == false);
113 		uint256 difference = balanceOf[santaFundWallet].sub(tokensForBonus);
114 		tokensSold = tokensForIco.sub(difference);
115 		balanceOf[santaFundWallet] = tokensForBonus;
116 		burned = true;
117 		Burn(difference);
118     }
119 
120     function markCrowdsaleEnding() {
121 		require(now > end);
122 		burn(); 
123 		crowdsaleClosed = true;
124     }
125 
126     function sendGifts(address[] santaGiftList) returns(bool success)  {
127 		require(msg.sender == santaFundWallet);
128 		require(now >= startAirdropTime);
129 	    
130 	    uint256 bonusRate = tokensForBonus.div(tokensSold); 
131 		for(uint i = 0; i < santaGiftList.length; i++) {
132 		    if (balanceOf[santaGiftList[i]] > 0) { 
133 				uint256 bonus = balanceOf[santaGiftList[i]].mul(bonusRate);
134 				transferFrom(santaFundWallet, santaGiftList[i], bonus);
135 		    }
136 		}
137 		return true;
138     }
139 }