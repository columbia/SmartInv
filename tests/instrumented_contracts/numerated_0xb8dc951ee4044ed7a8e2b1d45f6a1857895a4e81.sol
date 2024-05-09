1 /**
2  *  Crowdsale for Fast Invest Tokens.
3  *  Raised Ether will be stored safely at the wallet.
4  *
5  *  Based on OpenZeppelin framework.
6  *  https://openzeppelin.org
7  *
8  *  Author: Paulius Tumosa
9  **/
10 
11 pragma solidity ^0.4.18;
12 
13 /**
14  * Safe Math library from OpenZeppelin framework
15  * https://openzeppelin.org
16  *
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         assert(c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract token {
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51 }
52 
53 /**
54  * @title FastInvestTokenCrowdsale
55  *
56  * Crowdsale have a start and end timestamps, where investors can make
57  * token purchases and the crowdsale will assign them tokens based
58  * on a token per ETH rate. Funds collected are forwarded to a wallet
59  * as they arrive.
60  */
61 contract FastInvestTokenCrowdsale {
62     using SafeMath for uint256;
63 
64     address public owner;
65 
66     // The token being sold
67     token public tokenReward;
68 
69     // Tokens will be transfered from this address
70     address internal tokenOwner;
71 
72     // Address where funds are collected
73     address internal wallet;
74 
75     // Start and end timestamps where investments are allowed
76     uint256 public startTime;
77     uint256 public endTime;
78 
79     // Amount of tokens sold
80     uint256 public tokensSold = 0;
81 
82     // Amount of raised money in wei
83     uint256 public weiRaised = 0;
84 
85     // Funding goal and soft cap
86     uint256 constant public SOFT_CAP        = 38850000000000000000000000;
87     uint256 constant public FUNDING_GOAL    = 388500000000000000000000000;
88 
89     // Tokens per ETH rates before and after the soft cap is reached
90     uint256 constant public RATE = 1000;
91     uint256 constant public RATE_SOFT = 1200;
92 
93     // The balances in ETH of all investors
94     mapping (address => uint256) public balanceOf;
95 
96     /**
97      * Event for token purchase logging
98      *
99      * @param purchaser who paid for the tokens
100      * @param beneficiary who got the tokens
101      * @param value weis paid for purchase
102      * @param amount amount of tokens purchased
103      */
104     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
105 
106     /**
107      * @dev Throws if called by any account other than the owner.
108      */
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     function FastInvestTokenCrowdsale(address _tokenAddress, address _wallet, uint256 _start, uint256 _end) public {
115         require(_tokenAddress != address(0));
116         require(_wallet != address(0));
117 
118         owner = msg.sender;
119         tokenOwner = msg.sender;
120         wallet = _wallet;
121 
122         tokenReward = token(_tokenAddress);
123 
124         require(_start < _end);
125         startTime = _start;
126         endTime = _end;
127 
128     }
129 
130     // Fallback function can be used to buy tokens
131     function () external payable {
132         buyTokens(msg.sender);
133     }
134 
135     // Low level token purchase function
136     function buyTokens(address beneficiary) public payable {
137         require(beneficiary != 0x0);
138         require(validPurchase());
139 
140         uint256 weiAmount = msg.value;
141         uint256 tokens = 0;
142 
143         // Calculate token amount
144         if (tokensSold < SOFT_CAP) {
145             tokens = weiAmount.mul(RATE_SOFT);
146 
147             if (tokensSold.add(tokens) > SOFT_CAP) {
148                 uint256 softTokens = SOFT_CAP.sub(tokensSold);
149                 uint256 amountLeft = weiAmount.sub(softTokens.div(RATE_SOFT));
150 
151                 tokens = softTokens.add(amountLeft.mul(RATE));
152             }
153 
154         } else  {
155             tokens = weiAmount.mul(RATE);
156         }
157 
158         require(tokens > 0);
159         require(tokensSold.add(tokens) <= FUNDING_GOAL);
160 
161         forwardFunds();
162         assert(tokenReward.transferFrom(tokenOwner, beneficiary, tokens));
163 
164         balanceOf[beneficiary] = balanceOf[beneficiary].add(weiAmount);
165 
166         // Update totals
167         weiRaised  = weiRaised.add(weiAmount);
168         tokensSold = tokensSold.add(tokens);
169 
170         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
171     }
172 
173     // Send ether to the fund collection wallet
174     function forwardFunds() internal {
175         wallet.transfer(msg.value);
176     }
177 
178     // @return true if the transaction can buy tokens
179     function validPurchase() internal view returns (bool) {
180         bool withinPeriod = now >= startTime && now <= endTime;
181         bool nonZeroPurchase = msg.value != 0;
182         bool hasTokens = tokensSold < FUNDING_GOAL;
183 
184         return withinPeriod && nonZeroPurchase && hasTokens;
185     }
186 
187     function setStart(uint256 _start) public onlyOwner {
188         startTime = _start;
189     }
190 
191     function setEnd(uint256 _end) public onlyOwner {
192         require(startTime < _end);
193         endTime = _end;
194     }
195 
196     // @return true if crowdsale event has ended
197     function hasEnded() public view returns (bool) {
198         return now > endTime;
199     }
200 
201 }