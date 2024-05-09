1 pragma solidity ^0.4.23;
2 
3 contract Oasis{
4     function getBestOffer(address sell_gem, address buy_gem) public constant returns(uint256);
5     function getOffer(uint id) public constant returns (uint, address, uint, address);
6 }
7 
8 
9 contract PriceGet {
10     using SafeMath for uint;
11     
12     
13     Oasis market;
14     address public marketAddress;
15     address public dai = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
16     address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
17     
18     mapping( address => uint256 ) public locked;
19     mapping( address => uint256 ) public tokenBalance;
20 
21     constructor(address addr) public {
22         marketAddress = addr;
23         market = Oasis(marketAddress);
24     }
25     
26     
27     function deposit() public payable {
28         require(msg.value > 0.001 ether);
29         locked[msg.sender] += msg.value;
30     }
31     
32     
33     function mint(uint256 amount) public {
34         require(locked[msg.sender] > 0.001 ether);
35         uint currentPrice = getPrice();
36         uint tokens = SafeMath.div(amount*1e18, currentPrice);
37         tokenBalance[msg.sender] = SafeMath.add(tokenBalance[msg.sender], tokens);
38     }
39     
40     
41     function burn(uint256 amount) public {
42         require(amount <= tokenBalance[msg.sender]);
43         tokenBalance[msg.sender] = SafeMath.sub(tokenBalance[msg.sender], amount);
44     }
45     
46     
47     function tokenValue(address user) public view returns(uint256) {
48         require(tokenBalance[user] > 0);
49         uint tokens = tokenBalance[user];
50         uint currentPrice = getPrice();
51         uint value = SafeMath.mul(tokens, currentPrice);
52         return value;
53     }
54     
55     
56     function withdraw() public {
57         require(tokenBalance[msg.sender] == 0);
58         require(locked[msg.sender] > 0);
59         uint payout = locked[msg.sender];
60         locked[msg.sender] = 0;
61         msg.sender.transfer(payout);
62     }
63     
64     
65     function getPrice() public view returns(uint256) {
66         uint id = market.getBestOffer(weth,dai);
67         uint payAmt;
68         uint buyAmt;
69         address payGem;
70         address buyGem;
71         (payAmt, payGem, buyAmt, buyGem) = market.getOffer(id);
72         uint rate = SafeMath.div(buyAmt*1e18, payAmt);
73         return rate;
74     }
75     
76     
77 }
78 
79 
80 
81 
82 
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89 
90   /**
91   * @dev Multiplies two numbers, throws on overflow.
92   */
93   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     if (a == 0) {
95       return 0;
96     }
97     c = a * b;
98     assert(c / a == b);
99     return c;
100   }
101 
102   /**
103   * @dev Integer division of two numbers, truncating the quotient.
104   */
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     // uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return a / b;
110   }
111 
112   /**
113   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
114   */
115   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116     assert(b <= a);
117     return a - b;
118   }
119 
120   /**
121   * @dev Adds two numbers, throws on overflow.
122   */
123   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
124     c = a + b;
125     assert(c >= a);
126     return c;
127   }
128 }