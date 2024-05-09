1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract Claimable is Ownable {
85   address public pendingOwner;
86 
87   /**
88    * @dev Modifier throws if called by any account other than the pendingOwner.
89    */
90   modifier onlyPendingOwner() {
91     require(msg.sender == pendingOwner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to set the pendingOwner address.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) onlyOwner public {
100     pendingOwner = newOwner;
101   }
102 
103   /**
104    * @dev Allows the pendingOwner address to finalize the transfer.
105    */
106   function claimOwnership() onlyPendingOwner public {
107     OwnershipTransferred(owner, pendingOwner);
108     owner = pendingOwner;
109     pendingOwner = address(0);
110   }
111 }
112 
113 contract AllowanceSheet is Claimable {
114     using SafeMath for uint256;
115 
116     mapping (address => mapping (address => uint256)) public allowanceOf;
117 
118     function addAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
119         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].add(value);
120     }
121 
122     function subAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
123         allowanceOf[tokenHolder][spender] = allowanceOf[tokenHolder][spender].sub(value);
124     }
125 
126     function setAllowance(address tokenHolder, address spender, uint256 value) public onlyOwner {
127         allowanceOf[tokenHolder][spender] = value;
128     }
129 }