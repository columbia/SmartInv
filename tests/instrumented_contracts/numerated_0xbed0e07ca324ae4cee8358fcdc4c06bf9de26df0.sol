1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns(uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns(uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   function transfer(address to, uint256 value) public returns(bool);
34 }
35 
36 contract Ownable {
37   address public owner;
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 }
56 
57 contract EthWebATM is Ownable {
58   event EtherPay(uint256 _eth, address[] receivers, uint256[] shares);
59   event TokenTransfer(address token, address owner, uint256 amount);
60 
61   using SafeMath for uint256;
62 
63   address public feeWallet;
64   uint256 public adminFee = 1 * (10 ** 15);
65 
66   constructor(address _adminWallet) public{
67     require(_adminWallet != address(0));
68     feeWallet = _adminWallet;
69   }
70 
71   function() public payable {
72 
73   }
74 
75   function payEther(address[] receivers, uint256[] shares) external payable{
76     require(receivers.length == shares.length);
77     require(msg.value > adminFee.mul(shares.length));
78     uint256 _eth = msg.value;
79     uint256 totalshares = 0;
80     
81     for (uint256 i = 0; i < receivers.length; i++){
82       require(shares[i] > 0);
83       totalshares = totalshares.add(shares[i]);
84     }
85 
86     for (uint256 j = 0; j < receivers.length; j++){
87       uint256 eth_ = _eth.mul(shares[j]).div(totalshares).sub(adminFee);
88       receivers[j].transfer(eth_);
89     }
90 
91     emit EtherPay(_eth, receivers, shares);
92     feeWallet.transfer(adminFee.mul(receivers.length));
93   }
94 
95   function transferToken(address token, uint256 amount) external onlyOwner{
96     require(amount > 0);
97     require(ERC20Basic(token).transfer(msg.sender, amount));
98     emit TokenTransfer(token, msg.sender, amount);
99   }
100 
101   function updatefee(uint256 _eth) external onlyOwner{
102     adminFee = _eth;
103   }
104   
105   function updateWallet(address _address) external onlyOwner{
106     feeWallet = _address;
107   }
108 }