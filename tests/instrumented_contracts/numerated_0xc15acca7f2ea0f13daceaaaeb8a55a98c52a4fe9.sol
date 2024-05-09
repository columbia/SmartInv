1 /**
2 * @title SafeMath
3 * @dev Math operations with safety checks that throw on error
4 */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract token {
29 
30   function balanceOf(address _owner) public constant returns (uint256 balance);
31   function transfer(address _to, uint256 _value) public returns (bool success);
32 
33 }
34 
35 contract Ownable {
36   address public owner;
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38   /**
39    * @dev The Ownable constructor sets the original owner of the contract to the sender
40    * account.
41    */
42   constructor() public{
43     owner = msg.sender;
44   }
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     emit OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 }
62 
63 contract lockEtherPay is Ownable {
64     using SafeMath for uint256;
65 
66   token token_reward;
67   address public beneficiary;
68   bool public isLocked = false;
69   bool public isReleased = false;
70   uint256 public start_time;
71   uint256 public end_time;
72   uint256 public fifty_two_weeks = 28857600;
73 
74   event TokenReleased(address beneficiary, uint256 token_amount);
75 
76   constructor() public{
77     token_reward = token(0xAa1ae5e57dc05981D83eC7FcA0b3c7ee2565B7D6);
78     beneficiary = 0xF7225b495293c6503961ac943076Caa63A8f7e04;
79   }
80 
81   function tokenBalance() constant public returns (uint256){
82     return token_reward.balanceOf(this);
83   }
84 
85   function lock() public onlyOwner returns (bool){
86       require(!isLocked);
87       require(tokenBalance() > 0);
88       start_time = now;
89       end_time = start_time.add(fifty_two_weeks);
90       isLocked = true;
91   }
92 
93   function lockOver() constant public returns (bool){
94       uint256 current_time = now;
95     return current_time > end_time;
96   }
97 
98     function release() onlyOwner public{
99     require(isLocked);
100     require(!isReleased);
101     require(lockOver());
102     uint256 token_amount = tokenBalance();
103     token_reward.transfer( beneficiary, token_amount);
104     emit TokenReleased(beneficiary, token_amount);
105     isReleased = true;
106   }
107 }