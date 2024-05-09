1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, reverts on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b);
19 
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b > 0); // Solidity only automatically asserts when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30 
31     return c;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b <= a);
39     uint256 c = a - b;
40 
41     return c;
42   }
43 
44   /**
45   * @dev Adds two numbers, reverts on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     require(c >= a);
50 
51     return c;
52   }
53 
54   /**
55   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56   * reverts when dividing by zero.
57   */
58   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b != 0);
60     return a % b;
61   }
62 }
63 
64 contract ERC20Basic {
65   function transfer(address to, uint256 value) public returns(bool);
66 }
67 
68 contract Ownable {
69   address public owner;
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 }
88 
89 contract EthWebATM is Ownable {
90   event EtherPay(uint256 _eth, address[] receivers, uint256[] shares);
91   event TokenTransfer(address token, address owner, uint256 amount);
92 
93   using SafeMath for uint256;
94 
95   address public feeWallet;
96   uint256 public adminFee = 1 * (10 ** 15);
97 
98   constructor(address _adminWallet) public{
99     require(_adminWallet != address(0));
100     feeWallet = _adminWallet;
101   }
102 
103   function payEther(address[] receivers, uint256[] shares) external payable{
104     require(receivers.length == shares.length);
105     require(msg.value > adminFee.mul(shares.length));
106     uint256 _eth = msg.value;
107     uint256 totalshares = 0;
108     
109     for (uint256 i = 0; i < receivers.length; i++){
110       require(shares[i] > 0);
111       totalshares = totalshares.add(shares[i]);
112     }
113 
114     for (uint256 j = 0; j < receivers.length; j++){
115       uint256 eth_ = _eth.mul(shares[j]).div(totalshares).sub(adminFee);
116       receivers[j].transfer(eth_);
117     }
118 
119     emit EtherPay(_eth, receivers, shares);
120     feeWallet.transfer(adminFee.mul(receivers.length));
121   }
122 
123   function transferToken(address token, uint256 amount) external onlyOwner{
124     require(amount > 0);
125     require(ERC20Basic(token).transfer(msg.sender, amount));
126     emit TokenTransfer(token, msg.sender, amount);
127   }
128 
129   function updatefee(uint256 _eth) external onlyOwner{
130     adminFee = _eth;
131   }
132   
133   function updateWallet(address _address) external onlyOwner{
134     feeWallet = _address;
135   }
136 }