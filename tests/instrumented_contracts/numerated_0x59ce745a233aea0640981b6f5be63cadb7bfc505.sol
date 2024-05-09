1 pragma solidity ^0.4.13;
2 
3 /**
4  * EthercraftFarm Front-end:
5  * https://mryellow.github.io/ethercraft_farm_ui/
6  */
7 
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, throws on overflow.
47   */
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     if (a == 0) {
50       return 0;
51     }
52     uint256 c = a * b;
53     assert(c / a == b);
54     return c;
55   }
56 
57   /**
58   * @dev Integer division of two numbers, truncating the quotient.
59   */
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   /**
68   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   /**
76   * @dev Adds two numbers, throws on overflow.
77   */
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 contract ShopInterface
86 {
87     ObjectInterface public object;
88     function buyObject(address _beneficiary) public payable;
89 }
90 
91 contract ReentrancyGuard {
92 
93   /**
94    * @dev We use a single lock for the whole contract.
95    */
96   bool private reentrancy_lock = false;
97 
98   /**
99    * @dev Prevents a contract from calling itself, directly or indirectly.
100    * @notice If you mark a function `nonReentrant`, you should also
101    * mark it `external`. Calling one nonReentrant function from
102    * another is not supported. Instead, you can implement a
103    * `private` function doing the actual work, and a `external`
104    * wrapper marked as `nonReentrant`.
105    */
106   modifier nonReentrant() {
107     require(!reentrancy_lock);
108     reentrancy_lock = true;
109     _;
110     reentrancy_lock = false;
111   }
112 
113 }
114 
115 contract EthercraftFarm is Ownable, ReentrancyGuard {
116     using SafeMath for uint256;
117 
118     // TODO: Could be private with getter only allowing senders balance lookup.
119     mapping (address => mapping (address => uint256)) public tokenBalanceOf;
120 
121     function() payable public {
122         //owner.transfer(msg.value);
123     }
124 
125     function prep(address _shop, uint8 _iterations) nonReentrant external {
126         require(_shop != address(0));
127 
128         uint8 _len = 1;
129         if (_iterations > 1)
130             _len = _iterations;
131 
132         ShopInterface shop = ShopInterface(_shop);
133         for (uint8 i = 0; i < _len * 100; i++) {
134             shop.buyObject(this);
135         }
136 
137         ObjectInterface object = ObjectInterface(shop.object());
138         tokenBalanceOf[msg.sender][object] = tokenBalanceOf[msg.sender][object].add(uint256(_len * 99 ether));
139         tokenBalanceOf[owner][object] = tokenBalanceOf[owner][object].add(uint256(_len * 1 ether));
140     }
141 
142     function reap(address _object) nonReentrant external {
143         require(_object != address(0));
144         require(tokenBalanceOf[msg.sender][_object] > 0);
145 
146         // Retrieve any accumulated ETH.
147         if (msg.sender == owner)
148             owner.transfer(this.balance);
149 
150         ObjectInterface(_object).transfer(msg.sender, tokenBalanceOf[msg.sender][_object]);
151         tokenBalanceOf[msg.sender][_object] = 0;
152     }
153 
154 }
155 
156 contract ObjectInterface
157 {
158     function transfer(address to, uint256 value) public returns (bool);
159 }