1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract token {
31 
32   function balanceOf(address _owner) public constant returns (uint256 balance);
33   function transfer(address _to, uint256 _value) public returns (bool success);
34 
35 }
36 
37 contract Ownable {
38   address public owner;
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   constructor() public{
45     owner = msg.sender;
46   }
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 }
64 
65 contract LockToken is Ownable {
66 	using SafeMath for uint256;
67 
68   token token_reward;
69   address public beneficiary;
70   bool public isLocked = false;
71   bool public isReleased = false;
72   uint256 public start_time;
73   uint256 public end_time;
74   
75   event TokenReleased(address beneficiary, uint256 token_amount);
76 
77   constructor(address tokenContractAddress, address _beneficiary) public{
78     token_reward = token(tokenContractAddress);
79     beneficiary = _beneficiary;
80   }
81 
82   function tokenBalance() constant public returns (uint256){
83     return token_reward.balanceOf(this);
84   }
85 
86   function lock(uint256 lockTime) public onlyOwner returns (bool){
87   	require(!isLocked);
88   	require(tokenBalance() > 0);
89   	start_time = now;
90   	end_time = lockTime;
91   	isLocked = true;
92   }
93 
94   function lockOver() constant public returns (bool){
95   	uint256 current_time = now;
96 	return current_time > end_time;
97   }
98 
99 	function release() onlyOwner public{
100     require(isLocked);
101     require(!isReleased);
102     require(lockOver());
103     uint256 token_amount = tokenBalance();
104     token_reward.transfer( beneficiary, token_amount);
105     emit TokenReleased(beneficiary, token_amount);
106     isReleased = true;
107   }
108 }