1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract Owned {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 
60 contract Crowdsale is Owned{
61 
62   	using SafeMath for uint256;
63   	
64   	ERC20Interface private token;
65   	
66   	// Amount Raised
67   	uint256 public weiRaised;
68 	
69 	// Wallet where funds will be transfered
70 	address public wallet;
71 	
72 	// Is the crowdsale paused?
73 	bool isCrowdsalePaused = false;
74 	
75 	// the exchange rate
76 	uint256 public rate;
77 	
78 	// total ETH for sale
79 	uint256 public cap;
80 	
81 	uint8 public decimals;
82 	
83 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
84 
85 	constructor() public {
86 		wallet = 0x73b8D31A7FF02C3608FDaF3770D40c487CA9b11D;
87 		token = ERC20Interface(0x5D9f5D8d878Deb8DB5a4940fE7e86664E58c38FA);
88 		decimals = 18;
89 	 	cap = 20000 * 10**uint(decimals);
90     	rate = 1000;
91     	require(wallet != address(0));
92 		require(token != address(0));
93 		require(cap > 0);
94 		require(rate > 0);
95 	}
96 	
97 	function () external payable {
98     	buyTokens(msg.sender);
99  	}
100  	
101  	function buyTokens(address beneficiary) public payable {
102  	
103    		require(beneficiary != 0x0);
104 
105 	    uint256 amount = msg.value;
106 	    
107 	    require(isCrowdsalePaused == false);
108 	    
109 	    require(weiRaised.add(amount) <= cap);
110 
111     	uint256 tokens = getTokenAmount(amount);
112 
113     	weiRaised = weiRaised.add(amount);
114 
115     	processPurchase(beneficiary, tokens);
116     	
117 		emit TokenPurchase(msg.sender, beneficiary, amount, tokens);
118 
119     	forwardFunds();
120     	
121 	}
122 	
123 	function rate() public view returns(uint256){
124 		return rate;
125 	}
126 	
127 	function weiRaised() public view returns (uint256) {
128     	return weiRaised;
129 	}
130 	
131 	function deliverTokens(address beneficiary,uint256 tokenAmount) internal{
132 		token.transferFrom(wallet, beneficiary, tokenAmount);
133 	}
134 	
135 	function processPurchase(address beneficiary,uint256 tokenAmount) internal{
136 		deliverTokens(beneficiary, tokenAmount);
137 	}
138 
139 	function getTokenAmount(uint256 amount) internal view returns (uint256){
140     	return rate.mul(amount);
141   	}
142   	
143   	function forwardFunds() internal {
144 		wallet.transfer(msg.value);
145 	}
146 	
147 	function remainingTokens() public view returns (uint256) {
148 		return token.allowance(wallet, this);
149 	}
150 
151 	function capReached() public view returns (bool) {
152 		return weiRaised >= cap;
153 	}
154 	
155 	function pauseCrowdsale() public onlyOwner {
156         isCrowdsalePaused = true;
157     }
158     
159     function resumeCrowdsale() public onlyOwner {
160         isCrowdsalePaused = false;
161     }
162     
163     function takeTokensBack() public onlyOwner {
164          uint remainingTokensInTheContract = token.balanceOf(address(this));
165          token.transfer(owner,remainingTokensInTheContract);
166     }
167 }