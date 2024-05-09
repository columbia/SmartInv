1 pragma solidity ^0.4.10;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 //SkrillaToken interface containing functions used by the syndicate contract.
30 contract SkrillaTokenInterface {
31     function transfer(address _to, uint256 _value) public returns (bool);
32 
33     function buyTokens() payable public;
34 
35     function getCurrentPrice(address _buyer) public constant returns (uint256);
36 
37     function tokenSaleBalanceOf(address _owner) public constant returns (uint256 balance);
38 
39     function withdraw() public returns (bool);
40 }
41 
42 contract TokenSyndicate {
43     
44     SkrillaTokenInterface private tokenContract;
45     /*
46     * The address to call to purchase tokens.
47     */
48     address public tokenContractAddress;
49     uint256 public tokenExchangeRate;
50  
51     /**
52     * Timestamp after which a purchaser can get a refund of their investment. As long as the tokens have not been purchased.
53     */
54     uint256 public refundStart;
55     /**
56     * The owner can set refundEnabled to allow purchasers to refund their funds before refundStart.
57     */
58     bool public refundsEnabled;
59     bool public tokensPurchased;
60     /**
61     * Has the withdraw function been called on the token contract.
62     * This makes the syndicate's tokens available for distribution.
63     */
64     bool public syndicateTokensWithdrawn;
65 
66     /**
67     * The amount of wei collected by the syndicate.
68     */
69     uint256 public totalPresale;
70     address public owner;
71 
72     mapping(address => uint256) public presaleBalances;
73 
74     event LogInvest(address indexed _to,  uint256 presale);
75     event LogRefund(address indexed _to, uint256 presale);
76     event LogTokenPurchase(uint256 eth, uint256 tokens);
77     event LogWithdrawTokens(address indexed _to, uint256 tokens);
78     
79     modifier onlyOwner() { 
80         assert(msg.sender == owner);  _; 
81     }
82 
83     modifier onlyWhenTokensNotPurchased() { 
84         assert(!tokensPurchased);  _; 
85     }
86     modifier onlyWhenTokensPurchased() { 
87         assert(tokensPurchased); _; 
88     }
89     modifier onlyWhenSyndicateTokensWithdrawn() {
90         assert(syndicateTokensWithdrawn); _; 
91     }
92     modifier whenRefundIsPermitted() {
93         require(now >= refundStart || refundsEnabled);
94         _;
95     }
96     modifier onlyWhenRefundsNotEnabled() {
97         require(!refundsEnabled);
98         _;
99     }
100     function TokenSyndicate(address _tokenContractAddress,
101                             address _owner,
102                             uint256 _refundStart) {
103         tokenContractAddress = _tokenContractAddress;
104         owner = _owner;
105 
106         assert(tokenContractAddress != address(0));   // the token contract may not be at the zero address.
107         assert(owner != address(0));   // the token contract may not be at the zero address.
108 
109         tokenContract = SkrillaTokenInterface(_tokenContractAddress);
110         refundStart = _refundStart;
111 
112         totalPresale = 0;
113         
114         tokensPurchased = false;
115         syndicateTokensWithdrawn = false;
116         refundsEnabled = false;
117     }
118 
119     // Fallback function can be used to invest in syndicate
120     function() external payable {
121         invest();
122     }
123     /*
124         Invest in this contract in order to have tokens purchased on your behalf when the buyTokens() contract
125         is called without a `throw`.
126     */
127     function invest() payable public onlyWhenTokensNotPurchased {
128         assert(msg.value > 0);
129 
130         presaleBalances[msg.sender] = SafeMath.add(presaleBalances[msg.sender], msg.value);
131         totalPresale = SafeMath.add(totalPresale, msg.value);        
132         LogInvest(msg.sender, msg.value);       // create an event
133     }
134 
135     /*
136         Get the presaleBalance (ETH) for an address.
137     */
138     function balanceOf(address _purchaser) external constant returns (uint256 presaleBalance) {
139         return presaleBalances[_purchaser];
140     }
141 
142     /**
143     * An 'escape hatch' function to allow purchasers to get a refund of their eth before refundStart.
144     */
145     function enableRefunds() external onlyWhenTokensNotPurchased onlyOwner {
146         refundsEnabled = true;
147     }
148     /*
149        Attempt to purchase the tokens from the token contract.
150        This must be done before the sale ends
151 
152     */
153     function buyTokens() external onlyWhenRefundsNotEnabled onlyWhenTokensNotPurchased onlyOwner {
154         require(this.balance >= totalPresale);
155 
156         tokenContract.buyTokens.value(this.balance)();
157         //Get the exchange rate the contract will got for the purchase. Used to distribute tokens
158         //The number of token subunits per eth
159         tokenExchangeRate = tokenContract.getCurrentPrice(this);
160         
161         tokensPurchased = true;
162 
163         LogTokenPurchase(totalPresale, tokenContract.tokenSaleBalanceOf(this));
164     }
165 
166     /*
167         Call 'withdraw' on the skrilla contract as this contract. So that the tokens are available for distribution with the 'transfer' function.
168         This can only be called 14 days after sale close.
169     */
170     function withdrawSyndicateTokens() external onlyWhenTokensPurchased onlyOwner {
171         assert(tokenContract.withdraw());
172         syndicateTokensWithdrawn = true;
173     }
174 
175     /*
176         Transfer an accounts token entitlement to itself.
177         This can only be called if the tokens have been purchased by the contract and have been withdrawn by the contract.
178     */
179 
180     function withdrawTokens() external onlyWhenSyndicateTokensWithdrawn {
181         uint256 tokens = SafeMath.div(SafeMath.mul(presaleBalances[msg.sender], tokenExchangeRate), 1 ether);
182         assert(tokens > 0);
183 
184         totalPresale = SafeMath.sub(totalPresale, presaleBalances[msg.sender]);
185         presaleBalances[msg.sender] = 0;
186 
187         /*
188            Attempt to transfer tokens to msg.sender.
189            Note: we are relying on the token contract to return a success bool (true for success). If this
190            bool is not implemented as expected it may be possible for an account to withdraw more tokens than
191            it is entitled to.
192         */
193         assert(tokenContract.transfer( msg.sender, tokens));
194         LogWithdrawTokens(msg.sender, tokens);
195     }
196 
197     /*
198         Refund an accounts investment.
199         This is only possible if tokens have not been purchased.
200     */
201     function refund() external whenRefundIsPermitted onlyWhenTokensNotPurchased {
202         uint256 totalValue = presaleBalances[msg.sender];
203         assert(totalValue > 0);
204 
205         presaleBalances[msg.sender] = 0;
206         totalPresale = SafeMath.sub(totalPresale, totalValue);
207         
208         msg.sender.transfer(totalValue);
209         LogRefund(msg.sender, totalValue);
210     }
211 }