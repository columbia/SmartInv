1 pragma solidity ^0.4.23;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
117 
118 /**
119  * @title RefundVault
120  * @dev This contract is used for storing funds while a crowdsale
121  * is in progress. Supports refunding the money if crowdsale fails,
122  * and forwarding it if crowdsale is successful.
123  */
124 contract RefundVault is Ownable {
125   using SafeMath for uint256;
126 
127   enum State { Active, Refunding, Closed }
128 
129   mapping (address => uint256) public deposited;
130   address public wallet;
131   State public state;
132 
133   event Closed();
134   event RefundsEnabled();
135   event Refunded(address indexed beneficiary, uint256 weiAmount);
136 
137   /**
138    * @param _wallet Vault address
139    */
140   constructor(address _wallet) public {
141     require(_wallet != address(0));
142     wallet = _wallet;
143     state = State.Active;
144   }
145 
146   /**
147    * @param investor Investor address
148    */
149   function deposit(address investor) onlyOwner public payable {
150     require(state == State.Active);
151     deposited[investor] = deposited[investor].add(msg.value);
152   }
153 
154   function close() onlyOwner public {
155     require(state == State.Active);
156     state = State.Closed;
157     emit Closed();
158     wallet.transfer(address(this).balance);
159   }
160 
161   function enableRefunds() onlyOwner public {
162     require(state == State.Active);
163     state = State.Refunding;
164     emit RefundsEnabled();
165   }
166 
167   /**
168    * @param investor Investor address
169    */
170   function refund(address investor) public {
171     require(state == State.Refunding);
172     uint256 depositedValue = deposited[investor];
173     deposited[investor] = 0;
174     investor.transfer(depositedValue);
175     emit Refunded(investor, depositedValue);
176   }
177 }