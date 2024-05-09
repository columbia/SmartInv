1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
83 
84 /**
85  * @title Claimable
86  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
87  * This allows the new owner to accept the transfer.
88  */
89 contract Claimable is Ownable {
90   address public pendingOwner;
91 
92   /**
93    * @dev Modifier throws if called by any account other than the pendingOwner.
94    */
95   modifier onlyPendingOwner() {
96     require(msg.sender == pendingOwner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to set the pendingOwner address.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) onlyOwner public {
105     pendingOwner = newOwner;
106   }
107 
108   /**
109    * @dev Allows the pendingOwner address to finalize the transfer.
110    */
111   function claimOwnership() onlyPendingOwner public {
112     OwnershipTransferred(owner, pendingOwner);
113     owner = pendingOwner;
114     pendingOwner = address(0);
115   }
116 }
117 
118 // File: contracts/SeeToken.sol
119 
120 /**
121  * @title SEE Token
122  * Not a full ERC20 token - prohibits transferring. Serves as a record of
123  * account, to redeem for real tokens after launch.
124  */
125 contract SeeToken is Claimable {
126   using SafeMath for uint256;
127 
128   string public constant name = "See Presale Token";
129   string public constant symbol = "SEE";
130   uint8 public constant decimals = 18;
131 
132   uint256 public totalSupply;
133   mapping (address => uint256) balances;
134 
135   event Issue(address to, uint256 amount);
136 
137   /**
138    * @dev Issue new tokens
139    * @param _to The address that will receive the minted tokens
140    * @param _amount the amount of new tokens to issue
141    */
142   function issue(address _to, uint256 _amount) onlyOwner public {
143     totalSupply = totalSupply.add(_amount);
144     balances[_to] = balances[_to].add(_amount);
145 
146     Issue(_to, _amount);
147   }
148 
149   /**
150    * @dev Get the balance for a particular token holder
151    * @param _holder The token holder's address
152    * @return The holder's balance
153    */
154   function balanceOf(address _holder) public view returns (uint256 balance) {
155     balance = balances[_holder];
156   }
157 }