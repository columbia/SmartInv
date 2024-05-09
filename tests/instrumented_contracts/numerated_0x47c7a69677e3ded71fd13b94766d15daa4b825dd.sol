1 pragma solidity ^0.4.18;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   /**
10    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11    * account.
12    */
13   function Ownable() {
14     owner = msg.sender;
15   }
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23   /**
24    * @dev Allows the current owner to transfer control of the contract to a newOwner.
25    * @param newOwner The address to transfer ownership to.
26    */
27   function transferOwnership(address newOwner) onlyOwner {
28     require(newOwner != address(0));
29     owner = newOwner;
30   }
31 }
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 contract SafeMath {
37   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
38     uint256 c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42   function div(uint256 a, uint256 b) internal constant returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52   function add(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
58     return a >= b ? a : b;
59   }
60   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
61     return a < b ? a : b;
62   }
63   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
64     return a >= b ? a : b;
65   }
66   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
67     return a < b ? a : b;
68   }
69 }
70 /**
71  * @title RefundVault
72  * @dev This contract is used for storing funds while a crowdsale
73  * is in progress. Supports refunding the money if crowdsale fails,
74  * and forwarding it if crowdsale is successful.
75  */
76 contract RefundVault is Ownable, SafeMath{
77   enum State { Active, Refunding, Closed }
78   mapping (address => uint256) public deposited;
79   mapping (address => uint256) public refunded;
80   State public state;
81   address[] public reserveWallet;
82   event Closed();
83   event RefundsEnabled();
84   event Refunded(address indexed beneficiary, uint256 weiAmount);
85   /**
86    * @dev This constructor sets the addresses of
87    * 10 reserve wallets.
88    * and forwarding it if crowdsale is successful.
89    * @param _reserveWallet address[5] The addresses of reserve wallet.
90    */
91   function RefundVault(address[] _reserveWallet) {
92     state = State.Active;
93     reserveWallet = _reserveWallet;
94   }
95   /**
96    * @dev This function is called when user buy tokens. Only RefundVault
97    * contract stores the Ether user sent which forwarded from crowdsale
98    * contract.
99    * @param investor address The address who buy the token from crowdsale.
100    */
101   function deposit(address investor) onlyOwner payable {
102     require(state == State.Active);
103     deposited[investor] = add(deposited[investor], msg.value);
104   }
105   event Transferred(address _to, uint _value);
106   /**
107    * @dev This function is called when crowdsale is successfully finalized.
108    */
109   function close() onlyOwner {
110     require(state == State.Active);
111     state = State.Closed;
112     uint256 balance = this.balance;
113     uint256 reserveAmountForEach = div(balance, reserveWallet.length);
114     for(uint8 i = 0; i < reserveWallet.length; i++){
115       reserveWallet[i].transfer(reserveAmountForEach);
116       Transferred(reserveWallet[i], reserveAmountForEach);
117     }
118     Closed();
119   }
120   /**
121    * @dev This function is called when crowdsale is unsuccessfully finalized
122    * and refund is required.
123    */
124   function enableRefunds() onlyOwner {
125     require(state == State.Active);
126     state = State.Refunding;
127     RefundsEnabled();
128   }
129   /**
130    * @dev This function allows for user to refund Ether.
131    */
132   function refund(address investor) returns (bool) {
133     require(state == State.Refunding);
134     if (refunded[investor] > 0) {
135       return false;
136     }
137     uint256 depositedValue = deposited[investor];
138     deposited[investor] = 0;
139     refunded[investor] = depositedValue;
140     investor.transfer(depositedValue);
141     Refunded(investor, depositedValue);
142     return true;
143   }
144 }