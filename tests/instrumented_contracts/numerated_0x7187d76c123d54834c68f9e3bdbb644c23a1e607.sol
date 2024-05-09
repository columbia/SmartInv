1 pragma solidity 0.4.21;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: contracts/RefundVault.sol
94 
95 /**
96  * @title RefundVault
97  * @dev This contract is used for storing funds while a crowdsale
98  * is in progress. Supports refunding the money if crowdsale fails,
99  * and forwarding it if crowdsale is successful.
100  */
101 contract RefundVault is Ownable {
102   using SafeMath for uint256;
103 
104   enum State { Active, Refunding, Closed }
105 
106   mapping (address => uint256) public deposited;
107   address public wallet;
108   State public state;
109 
110   event Closed();
111   event RefundsEnabled();
112   event Refunded(address indexed beneficiary, uint256 weiAmount);
113 
114   function RefundVault(address _wallet) public {
115     require(_wallet != address(0));
116     wallet = _wallet;
117     state = State.Active;
118   }
119 
120   function deposit(address investor) onlyOwner public payable {
121     require(state == State.Active);
122     deposited[investor] = deposited[investor].add(msg.value);
123   }
124 
125   function close() onlyOwner public {
126     require(state == State.Active);
127     state = State.Closed;
128     Closed();
129     wallet.transfer(this.balance);
130   }
131 
132   function enableRefunds() onlyOwner public {
133     require(state == State.Active);
134     state = State.Refunding;
135     RefundsEnabled();
136   }
137 
138   function refund(address investor) public {
139     require(state == State.Refunding);
140     uint256 depositedValue = deposited[investor];
141     deposited[investor] = 0;
142     investor.transfer(depositedValue);
143     Refunded(investor, depositedValue);
144   }
145 }