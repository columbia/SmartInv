1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.18;
7 
8 /*************************************************************************
9  * import "../math/SafeMath.sol" : start
10  *************************************************************************/
11 
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 /*************************************************************************
46  * import "../math/SafeMath.sol" : end
47  *************************************************************************/
48 /*************************************************************************
49  * import "../ownership/Ownable.sol" : start
50  *************************************************************************/
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0));
89     OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 
93 }
94 /*************************************************************************
95  * import "../ownership/Ownable.sol" : end
96  *************************************************************************/
97 
98 /**
99  * @title RefundVault
100  * @dev This contract is used for storing funds while a crowdsale
101  * is in progress. Supports refunding the money if crowdsale fails,
102  * and forwarding it if crowdsale is successful.
103  */
104 contract RefundVault is Ownable {
105   using SafeMath for uint256;
106 
107   enum State { Active, Refunding, Closed }
108 
109   mapping (address => uint256) public deposited;
110   address public wallet;
111   State public state;
112 
113   event Closed();
114   event RefundsEnabled();
115   event Refunded(address indexed beneficiary, uint256 weiAmount);
116 
117   function RefundVault(address _wallet) public {
118     require(_wallet != address(0));
119     wallet = _wallet;
120     state = State.Active;
121   }
122 
123   function deposit(address investor) onlyOwner public payable {
124     require(state == State.Active);
125     deposited[investor] = deposited[investor].add(msg.value);
126   }
127 
128   function close() onlyOwner public {
129     require(state == State.Active);
130     state = State.Closed;
131     Closed();
132     wallet.transfer(this.balance);
133   }
134 
135   function enableRefunds() onlyOwner public {
136     require(state == State.Active);
137     state = State.Refunding;
138     RefundsEnabled();
139   }
140 
141   function refund(address investor) public {
142     require(state == State.Refunding);
143     uint256 depositedValue = deposited[investor];
144     deposited[investor] = 0;
145     investor.transfer(depositedValue);
146     Refunded(investor, depositedValue);
147   }
148 }