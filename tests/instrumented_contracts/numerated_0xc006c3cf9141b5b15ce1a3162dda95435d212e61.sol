1 pragma solidity ^0.4.18;
2 
3 contract QuickFlip {
4   using SafeMath for uint256;
5 
6   address public owner;
7   address private cardOwner;
8   uint256 public cardPrice;
9   uint256 public startTime = 1520899200;
10 
11   uint256 public constant PRIMARY_START_PRICE = 0.05 ether;
12   uint256 public constant STARTING_PRICE = 0.005 ether;
13 
14   Card[] public cards;
15 
16   struct Card {
17     address owner;
18     uint256 price;
19     uint256 purchaseRound;
20   }
21 
22   function QuickFlip() public {
23     owner = msg.sender;
24     cards.push(Card({ owner: owner, price: PRIMARY_START_PRICE, purchaseRound: 0 }));
25     cards.push(Card({ owner: owner, price: STARTING_PRICE, purchaseRound: 0 }));
26     cards.push(Card({ owner: owner, price: STARTING_PRICE, purchaseRound: 0 }));
27     cards.push(Card({ owner: owner, price: STARTING_PRICE, purchaseRound: 0 }));
28   }
29 
30   function buy(uint256 _cardId) public payable {
31     require(_cardId >= 0 && _cardId <= 3);
32 
33     uint256 price;
34     address oldOwner;
35 
36     (price, oldOwner) = getCard(_cardId);
37 
38     require(msg.value >= price);
39 
40     address newOwner = msg.sender;
41     uint256 purchaseExcess = msg.value - price;
42 
43     Card storage card = cards[_cardId];
44     card.owner = msg.sender;
45     card.price = price.mul(13).div(10); // increase by 30%
46     card.purchaseRound = currentRound();
47 
48     uint256 fee = price.mul(5).div(100);
49     uint256 profit = price.sub(fee);
50 
51     cards[0].owner.transfer(fee);
52     oldOwner.transfer(profit);
53     newOwner.transfer(purchaseExcess);
54   }
55 
56   function currentRound() public view returns (uint256) {
57     return now.sub(startTime).div(1 days);
58   }
59 
60   function getCard(uint256 _cardId) public view returns (uint256 _price, address _owner) {
61     Card memory card = cards[_cardId];
62 
63     if (currentRound() > card.purchaseRound) {
64       if (_cardId == 0) {
65         _price = PRIMARY_START_PRICE;
66         _owner = owner;
67       } else {
68         _price = STARTING_PRICE;
69         _owner = owner;
70       }
71     } else {
72       _price = card.price;
73       _owner = card.owner;
74     }
75   }
76 }
77 
78 
79 library SafeMath {
80 
81   /**
82   * @dev Multiplies two numbers, throws on overflow.
83   */
84   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85     if (a == 0) {
86       return 0;
87     }
88     uint256 c = a * b;
89     assert(c / a == b);
90     return c;
91   }
92 
93   /**
94   * @dev Integer division of two numbers, truncating the quotient.
95   */
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     // assert(b > 0); // Solidity automatically throws when dividing by 0
98     uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100     return c;
101   }
102 
103   /**
104   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   /**
112   * @dev Adds two numbers, throws on overflow.
113   */
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }