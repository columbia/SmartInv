1 pragma solidity ^0.4.20;
2 
3 // ETH in, tokens out to lottery winner.
4 
5 contract PoWMLottery {
6     using SafeMath for uint256;
7     
8     // Contract setup
9     bool public isLotteryOpen = false;
10     address POWM_address = address(0xA146240bF2C04005A743032DC0D241ec0bB2BA2B);
11     POWM maths = POWM(POWM_address);
12     address owner;
13     
14     // Datasets
15     mapping (uint256 => address) public gamblers;
16     mapping (address => uint256) public token_buyins;
17     mapping (address => uint256) public last_round_bought;
18     
19     uint256 public num_tickets_current_round = 0;
20     uint256 public current_round = 0;
21     uint256 public numTokensInLottery = 0;
22     
23     address masternode_referrer;
24     
25     // Can't buy more than 25 tokens.
26     uint256 public MAX_TOKEN_BUYIN = 25;
27     
28     function PoWMLottery() public {
29         current_round = 1;
30         owner = msg.sender;
31         masternode_referrer = msg.sender;
32     }
33     
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function donateToLottery() public payable returns(uint256) {
40         uint256 tokens_before = maths.myTokens();
41         maths.buy.value(msg.value)(masternode_referrer);
42         uint256 tokens_after = maths.myTokens();
43         numTokensInLottery = maths.myTokens();
44         return tokens_after - tokens_before;
45     }
46 
47     /**
48      * Buys tickets. Fails if > 25 tickets are attempted to buy.
49      */
50     function buyTickets() public payable {
51         require(isLotteryOpen == true);
52         require(last_round_bought[msg.sender] != current_round);
53         
54         // Buy the tokens.
55         // Should be between 0 and 25.
56         uint256 tokens_before = maths.myTokens();
57         maths.buy.value(msg.value)(masternode_referrer);
58         uint256 tokens_after = maths.myTokens();
59         uint256 tokens_bought = SafeMath.sub(tokens_after, tokens_before).div(1e18);
60         require(tokens_bought >= 1 && tokens_bought <= MAX_TOKEN_BUYIN);
61         numTokensInLottery = maths.myTokens();
62         
63         // Set last_round_bought = current round and token_buyins value
64         // Uses a for loop to put up to 25 tickets in.
65         uint8 i = 0;
66         while (i < tokens_bought) {
67             i++;
68             
69             gamblers[num_tickets_current_round] = msg.sender;
70             num_tickets_current_round++;
71         }
72 
73         token_buyins[msg.sender] = tokens_bought;
74         last_round_bought[msg.sender] = current_round;
75     }
76     
77     function setMaxTokenBuyin(uint256 tokens) public onlyOwner {
78         require(isLotteryOpen == false);
79         require(tokens > 0);
80         
81         MAX_TOKEN_BUYIN = tokens;
82     }
83     
84     function openLottery() onlyOwner public {
85         require(isLotteryOpen == false);
86         current_round++;
87         isLotteryOpen = true;
88         num_tickets_current_round = 0;
89     }
90     
91     // We need to be payable in order to receive dividends.
92     // And if not sent from the contract, let people buy in this way.
93     function () public payable {
94         if(msg.sender != address(0xA146240bF2C04005A743032DC0D241ec0bB2BA2B)) {
95             buyTickets();
96         }
97     }
98     
99     function closeLotteryAndPickWinner() onlyOwner public {
100         require(isLotteryOpen == true);
101         isLotteryOpen = false;
102         
103         // Pick winner as a pseudo-random hash of the timestamp among all the current winners
104         // YES we know this isn't /truly/ random but unless the prize is worth more than the block mining reward
105         //  it doesn't fucking matter.
106         uint256 winning_number = uint256(keccak256(block.blockhash(block.number - 1))) % num_tickets_current_round;
107         address winner = gamblers[winning_number];
108         masternode_referrer = winner;
109         
110         // ERC20 transfer & clear out our tokens.
111         uint256 exact_tokens = maths.myTokens();
112         maths.transfer(winner, exact_tokens);
113         numTokensInLottery = 0;
114         
115         // transfer any divs we got
116         winner.transfer(address(this).balance);
117     }
118 }
119 
120 // Function prototypes for PoWM
121 contract POWM {
122     function buy(address _referredBy) public payable returns(uint256) {}
123     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {}
124     function transfer(address _toAddress, uint256 _amountOfTokens) returns(bool) {}
125     function myTokens() public view returns(uint256) {}
126 }
127 
128 /**
129  * @title SafeMath
130  * @dev Math operations with safety checks that throw on error
131  */
132 library SafeMath {
133 
134     /**
135     * @dev Multiplies two numbers, throws on overflow.
136     */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         if (a == 0) {
139             return 0;
140         }
141         uint256 c = a * b;
142         assert(c / a == b);
143         return c;
144     }
145 
146     /**
147     * @dev Integer division of two numbers, truncating the quotient.
148     */
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         // assert(b > 0); // Solidity automatically throws when dividing by 0
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153         return c;
154     }
155 
156     /**
157     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
158     */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         assert(b <= a);
161         return a - b;
162     }
163 
164     /**
165     * @dev Adds two numbers, throws on overflow.
166     */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         assert(c >= a);
170         return c;
171     }
172 }