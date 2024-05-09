1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
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
79   function RefundVault(address _wallet) public {
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