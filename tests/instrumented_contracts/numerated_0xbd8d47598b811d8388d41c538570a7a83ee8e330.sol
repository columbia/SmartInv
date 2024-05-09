1 pragma solidity ^0.4.18;
2 
3 
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract Ownable {
35     address public owner;
36 
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     function Ownable() public {
46         owner = msg.sender;
47     }
48 
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         require(newOwner != address(0));
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 
69 }
70 
71 contract ClickableTVToken {
72     function balanceOf(address _owner) public view returns (uint256 balance);
73 
74     function transfer(address _to, uint256 _value) public returns (bool);
75 }
76 
77 contract ClickableTV is Ownable {
78     using SafeMath for uint256;
79 
80     // The token being sold
81     ClickableTVToken public token;
82 
83     // start and end timestamps where investments are allowed (both inclusive)
84     //  uint256 public startTime = block.timestamp; // for test. Time of deploy smart-contract
85     //    uint256 public startTime = 1522540800; // for production. Timestamp 01 Apr 2018 00:00:00 UTC
86     uint256 public presaleStart = 1516492800; // Sunday, 21-Jan-18 00:00:00 UTC
87     uint256 public presaleEnd = 1519862399; // Wednesday, 28-Feb-18 23:59:59 UTC
88     uint256 public saleStart = 1519862400; // Thursday, 01-Mar-18 00:00:00 UTC
89     uint256 public saleEnd = 1527811199; // Thursday, 31-May-18 23:59:59 UTC
90 
91     // address where funds are collected
92     address public wallet;
93 
94     // ICO Token Price – 1 CKTV = .001 ETH
95     uint256 public rate = 1000;
96 
97     // amount of raised money in wei
98     uint256 public weiRaised;
99 
100     function ClickableTV() public {
101         wallet = msg.sender;
102     }
103 
104     function setToken(ClickableTVToken _token) public onlyOwner {
105         token = _token;
106     }
107 
108     // By default wallet == owner
109     function setWallet(address _wallet) public onlyOwner {
110         wallet = _wallet;
111     }
112 
113     function tokenWeiToSale() public view returns (uint256) {
114         return token.balanceOf(this);
115     }
116 
117     function transfer(address _to, uint256 _value) public onlyOwner returns (bool){
118         assert(tokenWeiToSale() >= _value);
119         token.transfer(_to, _value);
120     }
121 
122 
123     // fallback function can be used to buy tokens
124     function() external payable {
125         buyTokens(msg.sender);
126     }
127 
128     /**
129   * event for token purchase logging
130   * @param purchaser who paid for the tokens
131   * @param beneficiary who got the tokens
132   * @param value weis paid for purchase
133   * @param amount amount of tokens purchased
134   */
135     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
136 
137     // low level token purchase function
138     function buyTokens(address beneficiary) public payable {
139         require(beneficiary != address(0));
140         require(validPurchase());
141 
142         uint256 weiAmount = msg.value;
143 
144         // calculate token amount to be created
145         uint256 tokens = weiAmount.mul(rate);
146         // 25% discount of token price for the first six weeks during pre-sale
147         if (block.timestamp < presaleEnd) tokens = tokens.mul(100).div(75);
148 
149         // update state
150         weiRaised = weiRaised.add(weiAmount);
151 
152         token.transfer(beneficiary, tokens);
153         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
154 
155         forwardFunds();
156     }
157 
158     // send ether to the fund collection wallet
159     // override to create custom fund forwarding mechanisms
160     function forwardFunds() internal {
161         wallet.transfer(msg.value);
162     }
163 
164     // @return true if the transaction can buy tokens
165     function validPurchase() internal view returns (bool) {
166         bool presalePeriod = now >= presaleStart && now <= presaleEnd;
167         bool salePeriod = now >= saleStart && now <= saleEnd;
168         bool nonZeroPurchase = msg.value != 0;
169         return (presalePeriod || salePeriod) && nonZeroPurchase;
170     }
171 }