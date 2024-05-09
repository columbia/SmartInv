1 pragma solidity ^0.4.18;
2 
3 contract QuickFlip {
4   using SafeMath for uint256;
5 
6   address public owner;
7   address private cardOwner;
8   uint256 public cardPrice;
9   uint256 public startTime = 1520899200;
10   uint256 public purchaseRound;
11 
12   uint256 public constant STARTING_PRICE = 0.025 ether;
13 
14   function QuickFlip() public {
15     owner = msg.sender;
16     cardOwner = msg.sender;
17     cardPrice = STARTING_PRICE;
18   }
19 
20   function buy() public payable {
21     uint256 price;
22     address oldOwner;
23 
24     (price, oldOwner) = getCard();
25 
26     require(msg.value >= price);
27 
28     address newOwner = msg.sender;
29     uint256 purchaseExcess = msg.value - price;
30 
31     cardOwner = msg.sender;
32     cardPrice = price.mul(12).div(10); // increase by 20%
33     purchaseRound = currentRound();
34 
35     oldOwner.transfer(price);
36     newOwner.transfer(purchaseExcess);
37   }
38 
39   function currentRound() public view returns (uint256) {
40     return now.sub(startTime).div(1 days);
41   }
42 
43   function getCard() public view returns (uint256 _price, address _owner) {
44     if (currentRound() > purchaseRound) {
45       _price = STARTING_PRICE;
46       _owner = owner;
47     } else {
48       _price = cardPrice;
49       _owner = cardOwner;
50     }
51   }
52 }
53 
54 
55 library SafeMath {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     if (a == 0) {
62       return 0;
63     }
64     uint256 c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   /**
80   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }