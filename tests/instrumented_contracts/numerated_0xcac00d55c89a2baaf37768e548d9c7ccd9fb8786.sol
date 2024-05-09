1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   uint8 public decimals;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) onlyOwner public {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 contract BatchUtils is Ownable {
89   using SafeMath for uint256;
90   mapping (address => bool) public operational;
91   uint256 public sendlimit = 10;
92   
93   function BatchUtils() {
94       operational[msg.sender] = true;
95   }
96   
97   function setLimit(uint256 _limit) onlyOwner public {
98       sendlimit = _limit;
99   }
100   
101   function setOperational(address[] addresses, bool op) onlyOwner public {
102     for (uint i = 0; i < addresses.length; i++) {
103         operational[addresses[i]] = op;
104     }
105   }
106   
107   function batchTransfer(address[] _tokens, address[] _receivers, uint256 _value) {
108     require(operational[msg.sender]); 
109     require(_value <= sendlimit);
110     
111     uint cnt = _receivers.length;
112     require(cnt > 0 && cnt <= 121);
113     
114     for (uint j = 0; j < _tokens.length; j++) {
115         ERC20Basic token = ERC20Basic(_tokens[j]);
116         
117         uint256 value = _value.mul(10**uint256(token.decimals()));
118         uint256 amount = uint256(cnt).mul(value);
119         
120         require(value > 0 && token.balanceOf(this) >= amount);
121         
122         for (uint i = 0; i < cnt; i++) {
123             token.transfer(_receivers[i], value);
124         }
125     }
126   }
127 }