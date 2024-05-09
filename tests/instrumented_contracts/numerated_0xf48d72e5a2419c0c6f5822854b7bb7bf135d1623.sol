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
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 /**
77  * @title RefundVault
78  * @dev This contract is used for storing funds while a crowdsale
79  * is in progress. Supports refunding the money if crowdsale fails,
80  * and forwarding it if crowdsale is successful.
81  */
82 contract RefundVault is Ownable {
83   using SafeMath for uint256;
84 
85   enum State { Active, Refunding, Closed }
86 
87   mapping (address => uint256) public deposited;
88   address public wallet;
89   State public state;
90 
91   event Closed();
92   event RefundsEnabled();
93   event Refunded(address indexed beneficiary, uint256 weiAmount);
94 
95   function RefundVault(address _wallet) public {
96     require(_wallet != address(0));
97     wallet = _wallet;
98     state = State.Active;
99   }
100 
101   function deposit(address investor) onlyOwner public payable {
102     require(state == State.Active);
103     deposited[investor] = deposited[investor].add(msg.value);
104   }
105 
106   function close() onlyOwner public {
107     require(state == State.Active);
108     state = State.Closed;
109     Closed();
110     wallet.transfer(this.balance);
111   }
112 
113   function walletWithdraw(uint256 _value) onlyOwner public {
114     require(_value < this.balance);
115     wallet.transfer(_value);
116   }
117 
118   function enableRefunds() onlyOwner public {
119     require(state == State.Active);
120     state = State.Refunding;
121     RefundsEnabled();
122   }
123 
124   function refund(address investor) public {
125     require(state == State.Refunding);
126     uint256 depositedValue = deposited[investor];
127     deposited[investor] = 0;
128     investor.transfer(depositedValue);
129     Refunded(investor, depositedValue);
130   }
131 }