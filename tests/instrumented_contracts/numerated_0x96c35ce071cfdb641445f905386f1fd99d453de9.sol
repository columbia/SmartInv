1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 pragma solidity ^0.4.23;
51 
52 /**
53  * @title SplitPayment
54  * @dev Base contract that supports multiple payees claiming funds sent to this contract
55  * according to the proportion they own.
56  */
57 contract SplitPayment {
58   using SafeMath for uint256;
59 
60   uint256 public totalShares = 0;
61   uint256 public totalReleased = 0;
62 
63   mapping(address => uint256) public shares;
64   mapping(address => uint256) public released;
65   address[] public payees;
66 
67   /**
68    * @dev Constructor
69    */
70   constructor(address[] _payees, uint256[] _shares) public payable {
71     require(_payees.length == _shares.length);
72 
73     for (uint256 i = 0; i < _payees.length; i++) {
74       addPayee(_payees[i], _shares[i]);
75     }
76   }
77 
78   /**
79    * @dev payable fallback
80    */
81   function () public payable {}
82 
83   /**
84    * @dev Claim your share of the balance.
85    */
86   function claim() public {
87     address payee = msg.sender;
88 
89     require(shares[payee] > 0);
90 
91     uint256 totalReceived = address(this).balance.add(totalReleased);
92     uint256 payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]);
93 
94     require(payment != 0);
95     require(address(this).balance >= payment);
96 
97     released[payee] = released[payee].add(payment);
98     totalReleased = totalReleased.add(payment);
99 
100     payee.transfer(payment);
101   }
102 
103   /**
104    * @dev Check your share of the balance.
105    */
106   function checkMyBalance() public view returns(uint256) {
107     uint256 totalReceived = address(this).balance.add(totalReleased);
108     uint256 payment = totalReceived.mul(shares[msg.sender]).div(totalShares).sub(released[msg.sender]);
109 
110     return payment;
111   }
112 
113   /**
114    * @dev Add a new payee to the contract.
115    * @param _payee The address of the payee to add.
116    * @param _shares The number of shares owned by the payee.
117    */
118   function addPayee(address _payee, uint256 _shares) internal {
119     require(_payee != address(0));
120     require(_shares > 0);
121     require(shares[_payee] == 0);
122 
123     payees.push(_payee);
124     shares[_payee] = _shares;
125     totalShares = totalShares.add(_shares);
126   }
127 }