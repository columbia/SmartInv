1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract PullPayment {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) public payments;
93   uint256 public totalPayments;
94 
95   /**
96   * @dev withdraw accumulated balance, called by payee.
97   */
98   function withdrawPayments() public {
99     address payee = msg.sender;
100     uint256 payment = payments[payee];
101 
102     require(payment != 0);
103     require(this.balance >= payment);
104 
105     totalPayments = totalPayments.sub(payment);
106     payments[payee] = 0;
107 
108     assert(payee.send(payment));
109   }
110 
111   /**
112   * @dev Called by the payer to store the sent amount as credit to be pulled.
113   * @param dest The destination address of the funds.
114   * @param amount The amount to transfer.
115   */
116   function asyncSend(address dest, uint256 amount) internal {
117     payments[dest] = payments[dest].add(amount);
118     totalPayments = totalPayments.add(amount);
119   }
120 }
121 
122 contract EtherPizza is Ownable, PullPayment {
123 
124     address public pizzaHolder;
125     uint256 public pizzaPrice;
126 
127     function EtherPizza() public {
128         pizzaHolder = msg.sender;
129         pizzaPrice = 100000000000000000; // 0.1 ETH initial price
130     }
131 
132     function gimmePizza() external payable {
133         require(msg.value >= pizzaPrice);
134         require(msg.sender != pizzaHolder);
135         uint taxesAreSick = msg.value.div(100);
136         uint hodlerPrize = msg.value.sub(taxesAreSick);
137         asyncSend(pizzaHolder, hodlerPrize);
138         asyncSend(owner, taxesAreSick);
139         pizzaHolder = msg.sender;
140         pizzaPrice = pizzaPrice.mul(2);
141     }
142 
143 
144 }