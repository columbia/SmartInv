1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract SplitPayment {
33   using SafeMath for uint256;
34 
35   uint256 public totalShares = 0;
36   uint256 public totalReleased = 0;
37 
38   mapping(address => uint256) public shares;
39   mapping(address => uint256) public released;
40   address[] public payees;
41 
42   /**
43    * @dev Constructor
44    */
45   function SplitPayment(address[] _payees, uint256[] _shares) public {
46     require(_payees.length == _shares.length);
47 
48     for (uint256 i = 0; i < _payees.length; i++) {
49       addPayee(_payees[i], _shares[i]);
50     }
51   }
52 
53   /**
54    * @dev Add a new payee to the contract.
55    * @param _payee The address of the payee to add.
56    * @param _shares The number of shares owned by the payee.
57    */
58   function addPayee(address _payee, uint256 _shares) internal {
59     require(_payee != address(0));
60     require(_shares > 0);
61     require(shares[_payee] == 0);
62 
63     payees.push(_payee);
64     shares[_payee] = _shares;
65     totalShares = totalShares.add(_shares);
66   }
67 
68   /**
69    * @dev Claim your share of the balance.
70    */
71   function claim() public {
72     address payee = msg.sender;
73 
74     require(shares[payee] > 0);
75 
76     uint256 totalReceived = this.balance.add(totalReleased);
77     uint256 payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]);
78 
79     require(payment != 0);
80     require(this.balance >= payment);
81 
82     released[payee] = released[payee].add(payment);
83     totalReleased = totalReleased.add(payment);
84 
85     payee.transfer(payment);
86   }
87 }
88 
89 contract DonationSplitter is SplitPayment {
90     function DonationSplitter (address[] _payees, uint256[] _shares)
91         SplitPayment(_payees, _shares)
92         public
93     {
94 
95     }
96 
97     // accept ether
98     function () public payable {}
99 }