1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 
49 
50 
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 
86 
87 /**
88  * @title RefundVault
89  * @dev This contract is used for storing funds while a crowdsale
90  * is in progress. Supports refunding the money if crowdsale fails,
91  * and forwarding it if crowdsale is successful.
92  */
93 contract RefundVault is Ownable {
94   using SafeMath for uint256;
95 
96   enum State { Active, Refunding, Closed }
97 
98   mapping (address => uint256) public deposited;
99   address public wallet;
100   State public state;
101 
102   event Closed();
103   event RefundsEnabled();
104   event Refunded(address indexed beneficiary, uint256 weiAmount);
105 
106   function RefundVault(address _wallet) public {
107     require(_wallet != address(0));
108     wallet = _wallet;
109     state = State.Active;
110   }
111 
112   function deposit(address investor) onlyOwner public payable {
113     require(state == State.Active);
114     deposited[investor] = deposited[investor].add(msg.value);
115   }
116 
117   function close() onlyOwner public {
118     require(state == State.Active);
119     state = State.Closed;
120     Closed();
121     wallet.transfer(this.balance);
122   }
123 
124   function enableRefunds() onlyOwner public {
125     require(state == State.Active);
126     state = State.Refunding;
127     RefundsEnabled();
128   }
129 
130   function refund(address investor) public {
131     require(state == State.Refunding);
132     uint256 depositedValue = deposited[investor];
133     deposited[investor] = 0;
134     investor.transfer(depositedValue);
135     Refunded(investor, depositedValue);
136   }
137 }
138 
139 
140 /**
141  * @title PresaleVault
142  * @dev This contract is used for storing funds while a crowdsale
143  * is in progress. Supports refunding the money if crowdsale fails,
144  * and forwarding it if crowdsale is successful.
145  * PresaleVault.sol exists to handle deployed address.
146  */
147 contract PresaleVault is RefundVault {
148   bool public forPresale = true;
149   function PresaleVault(address _wallet) RefundVault(_wallet) public {}
150 }