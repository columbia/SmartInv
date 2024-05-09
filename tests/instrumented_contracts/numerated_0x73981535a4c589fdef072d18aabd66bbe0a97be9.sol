1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 
93 contract SKYFTokenInterface {
94     function balanceOf(address _owner) public view returns (uint256 balance);
95     function transfer(address _to, uint256 _value) public returns (bool);
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
97 }
98 
99 
100 contract SKYFNetworkDevelopmentFund is Ownable{
101     using SafeMath for uint256;
102 
103     uint256 public constant startTime = 1534334400;
104     uint256 public constant firstYearEnd = startTime + 365 days;
105     uint256 public constant secondYearEnd = firstYearEnd + 365 days;
106     
107     uint256 public initialSupply;
108     SKYFTokenInterface public token;
109 
110     function setToken(address _token) public onlyOwner returns (bool) {
111         require(_token != address(0));
112         if (token == address(0)) {
113             token = SKYFTokenInterface(_token);
114             return true;
115         }
116         return false;
117     }
118 
119     function transfer(address _to, uint256 _value) public onlyOwner returns (bool) {
120         uint256 balance = token.balanceOf(this);
121         if (initialSupply == 0) {
122             initialSupply = balance;
123         }
124         
125         if (now < firstYearEnd) {
126             require(balance.sub(_value).mul(2) >= initialSupply); //no less than 50%(1/2) should be left on account after first year
127         } else if (now < secondYearEnd) {
128             require(balance.sub(_value).mul(20) >= initialSupply.mul(3)); //no less than 15%(3/20) should be left on account after second year
129         }
130 
131         token.transfer(_to, _value);
132 
133     }
134 }