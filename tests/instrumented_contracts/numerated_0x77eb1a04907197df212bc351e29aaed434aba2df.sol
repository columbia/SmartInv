1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title SafeERC20
12  * @dev Wrappers around ERC20 operations that throw on failure.
13  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
14  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
15  */
16 library SafeERC20 {
17   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
18     assert(token.transfer(to, value));
19   }
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipRenounced(address indexed previousOwner);
46   event OwnershipTransferred(
47     address indexed previousOwner,
48     address indexed newOwner
49   );
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   constructor() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to relinquish control of the contract.
70    */
71   function renounceOwnership() public onlyOwner {
72     emit OwnershipRenounced(owner);
73     owner = address(0);
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address _newOwner) public onlyOwner {
81     _transferOwnership(_newOwner);
82   }
83 
84   /**
85    * @dev Transfers control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function _transferOwnership(address _newOwner) internal {
89     require(_newOwner != address(0));
90     emit OwnershipTransferred(owner, _newOwner);
91     owner = _newOwner;
92   }
93 }
94 
95 /**
96  * @title DragonAdvisors
97  * @dev DragonAdvisors works like a tap and release tokens periodically
98  * to advisors on the owners permission 
99  */
100 contract DragonAdvisors is Ownable{
101   using SafeERC20 for ERC20Basic;
102   using SafeMath for uint256;
103 
104   // ERC20 basic token contract being held
105   ERC20Basic public token;
106 
107   // advisor address
108   address public advisor;
109 
110   // amount of tokens available for release
111   uint256 public releasedTokens;
112   
113   event TokenTapAdjusted(uint256 released);
114 
115   constructor() public {
116     token = ERC20Basic(0x814F67fA286f7572B041D041b1D99b432c9155Ee);
117     owner = address(0xA5101498679Fa973c5cF4c391BfF991249934E73);      // overriding owner
118 
119     advisor = address(0xd95350D60Bbc601bdfdD8904c336F4faCb9d524c);
120     
121     releasedTokens = 0;
122   }
123 
124   /**
125    * @notice release tokens held by the contract to advisor.
126    */
127   function release(uint256 _amount) public {
128     require(_amount > 0);
129     require(releasedTokens >= _amount);
130     releasedTokens = releasedTokens.sub(_amount);
131     
132     uint256 balance = token.balanceOf(this);
133     require(balance >= _amount);
134     
135 
136     token.safeTransfer(advisor, _amount);
137   }
138   
139   /**
140    * @notice Owner can move tokens to any address
141    */
142   function transferTokens(address _to, uint256 _amount) external {
143     require(_to != address(0x00));
144     require(_amount > 0);
145 
146     uint256 balance = token.balanceOf(this);
147     require(balance >= _amount);
148 
149     token.safeTransfer(_to, _amount);
150   }
151   
152   function adjustTap(uint256 _amount) external onlyOwner{
153       require(_amount > 0);
154       uint256 balance = token.balanceOf(this);
155       require(_amount <= balance);
156       releasedTokens = _amount;
157       emit TokenTapAdjusted(_amount);
158   }
159   
160   function () public payable {
161       revert();
162   }
163 }