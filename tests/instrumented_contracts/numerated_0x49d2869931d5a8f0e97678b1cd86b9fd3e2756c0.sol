1 pragma solidity ^0.4.23;
2 
3 /*
4 
5   BASIC ERC20 Sale Contract
6 
7   Create this Sale contract first!
8 
9      Sale(address ethwallet)   // this will send the received ETH funds to this address
10 
11 
12   @author Hunter Long
13   @repo https://github.com/hunterlong/ethereum-ico-contract
14 
15 */
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     if (a == 0) {
27       return 0;
28     }
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 contract ERC20 {
64   function sale(address to, uint256 value);
65 }
66 
67 
68 contract Sale {
69     uint public preSaleEnd = 1527120000; //05/24/2018 @ 12:00am (UTC)
70     uint public saleEnd1 = 1528588800; //06/10/2018 @ 12:00am (UTC)
71     uint public saleEnd2 = 1529971200; //06/26/2018 @ 12:00am (UTC)
72     uint public saleEnd3 = 1531267200; //07/11/2018 @ 12:00am (UTC)
73     uint public saleEnd4 = 1532476800; //07/25/2018 @ 12:00am (UTC)
74 
75     uint256 public saleExchangeRate1 = 17500;
76     uint256 public saleExchangeRate2 = 10000;
77     uint256 public saleExchangeRate3 = 8750;
78     uint256 public saleExchangeRate4 = 7778;
79     uint256 public saleExchangeRate5 = 7368;
80     
81     uint256 public volumeType1 = 1429 * 10 ** 16; //14.29 eth
82     uint256 public volumeType2 = 7143 * 10 ** 16;
83     uint256 public volumeType3 = 14286 * 10 ** 16;
84     uint256 public volumeType4 = 42857 * 10 ** 16;
85     uint256 public volumeType5 = 71429 * 10 ** 16;
86     uint256 public volumeType6 = 142857 * 10 ** 16;
87     uint256 public volumeType7 = 428571 * 10 ** 16;
88     
89     uint256 public minEthValue = 10 ** 17; // 0.1 eth
90     
91     using SafeMath for uint256;
92     uint256 public maxSale;
93     uint256 public totalSaled;
94     ERC20 public Token;
95     address public ETHWallet;
96 
97     address public creator;
98 
99     mapping (address => uint256) public heldTokens;
100     mapping (address => uint) public heldTimeline;
101 
102     event Contribution(address from, uint256 amount);
103 
104     function Sale(address _wallet, address _token_address) {
105         maxSale = 316906850 * 10 ** 8; 
106         ETHWallet = _wallet;
107         creator = msg.sender;
108         Token = ERC20(_token_address);
109     }
110 
111     
112 
113     function () payable {
114         buy();
115     }
116 
117     // CONTRIBUTE FUNCTION
118     // converts ETH to TOKEN and sends new TOKEN to the sender
119     function contribute() external payable {
120         buy();
121     }
122     
123     
124     function buy() internal {
125         require(msg.value>=minEthValue);
126         require(now < saleEnd4);
127         
128         uint256 amount;
129         uint256 exchangeRate;
130         if(now < preSaleEnd) {
131             exchangeRate = saleExchangeRate1;
132         } else if(now < saleEnd1) {
133             exchangeRate = saleExchangeRate2;
134         } else if(now < saleEnd2) {
135             exchangeRate = saleExchangeRate3;
136         } else if(now < saleEnd3) {
137             exchangeRate = saleExchangeRate4;
138         } else if(now < saleEnd4) {
139             exchangeRate = saleExchangeRate5;
140         }
141         
142         amount = msg.value.mul(exchangeRate).div(10 ** 10);
143         
144         if(msg.value >= volumeType7) {
145             amount = amount * 180 / 100;
146         } else if(msg.value >= volumeType6) {
147             amount = amount * 160 / 100;
148         } else if(msg.value >= volumeType5) {
149             amount = amount * 140 / 100;
150         } else if(msg.value >= volumeType4) {
151             amount = amount * 130 / 100;
152         } else if(msg.value >= volumeType3) {
153             amount = amount * 120 / 100;
154         } else if(msg.value >= volumeType2) {
155             amount = amount * 110 / 100;
156         } else if(msg.value >= volumeType1) {
157             amount = amount * 105 / 100;
158         }
159         
160         uint256 total = totalSaled + amount;
161         
162         require(total<=maxSale);
163         
164         totalSaled = total;
165         
166         ETHWallet.transfer(msg.value);
167         Token.sale(msg.sender, amount);
168         Contribution(msg.sender, amount);
169     }
170     
171     
172     
173 
174 
175     // change creator address
176     function changeCreator(address _creator) external {
177         require(msg.sender==creator);
178         creator = _creator;
179     }
180 
181 
182 
183 }