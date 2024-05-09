1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title SplitPayment
71  * @dev Base contract that supports multiple payees claiming funds sent to this contract
72  * according to the proportion they own.
73  */
74 contract SplitPayment {
75   using SafeMath for uint256;
76 
77   uint256 public totalShares = 0;
78   uint256 public totalReleased = 0;
79 
80   mapping(address => uint256) public shares;
81   mapping(address => uint256) public released;
82   address[] public payees;
83 
84   /**
85    * @dev Constructor
86    */
87   constructor(address[] _payees, uint256[] _shares) public payable {
88     require(_payees.length == _shares.length);
89     require(_payees.length > 0);
90 
91     for (uint256 i = 0; i < _payees.length; i++) {
92       addPayee(_payees[i], _shares[i]);
93     }
94   }
95 
96   /**
97    * @dev payable fallback
98    */
99   function () external payable {}
100 
101   /**
102    * @dev Claim your share of the balance.
103    */
104   function claim() public {
105     address payee = msg.sender;
106 
107     require(shares[payee] > 0);
108 
109     uint256 totalReceived = address(this).balance.add(totalReleased);
110     uint256 payment = totalReceived.mul(
111       shares[payee]).div(
112         totalShares).sub(
113           released[payee]
114     );
115 
116     require(payment != 0);
117     assert(address(this).balance >= payment);
118 
119     released[payee] = released[payee].add(payment);
120     totalReleased = totalReleased.add(payment);
121 
122     payee.transfer(payment);
123   }
124 
125   /**
126    * @dev Add a new payee to the contract.
127    * @param _payee The address of the payee to add.
128    * @param _shares The number of shares owned by the payee.
129    */
130   function addPayee(address _payee, uint256 _shares) internal {
131     require(_payee != address(0));
132     require(_shares > 0);
133     require(shares[_payee] == 0);
134 
135     payees.push(_payee);
136     shares[_payee] = _shares;
137     totalShares = totalShares.add(_shares);
138   }
139 }