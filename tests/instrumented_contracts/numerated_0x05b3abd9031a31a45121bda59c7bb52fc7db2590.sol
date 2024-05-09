1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function div(uint256 a, uint256 b) internal constant returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   function add(uint256 a, uint256 b) internal constant returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 contract RefundVault is Ownable {
67   using SafeMath for uint256;
68 
69   enum State { Active, Refunding, Closed }
70 
71   mapping (address => uint256) public deposited;
72   address public wallet;
73   State public state;
74 
75   event Closed();
76   event RefundsEnabled();
77   event Refunded(address indexed beneficiary, uint256 weiAmount);
78 
79   function RefundVault(address _wallet) {
80     require(_wallet != 0x0);
81     wallet = _wallet;
82     state = State.Active;
83   }
84 
85   function deposit(address investor) onlyOwner public payable {
86     require(state == State.Active);
87     deposited[investor] = deposited[investor].add(msg.value);
88   }
89 
90   function close() onlyOwner public {
91     require(state == State.Active);
92     state = State.Closed;
93     Closed();
94     wallet.transfer(this.balance);
95   }
96 
97   function enableRefunds() onlyOwner public {
98     require(state == State.Active);
99     state = State.Refunding;
100     RefundsEnabled();
101   }
102 
103   function refund(address investor) public {
104     require(state == State.Refunding);
105     uint256 depositedValue = deposited[investor];
106     deposited[investor] = 0;
107     investor.transfer(depositedValue);
108     Refunded(investor, depositedValue);
109   }
110 }