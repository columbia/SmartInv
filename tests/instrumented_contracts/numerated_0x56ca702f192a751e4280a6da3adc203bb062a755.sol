1 pragma solidity ^0.4.18;
2 
3 
4  
5  
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13  function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) onlyOwner public {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   uint256 public totalSupply;
76   function balanceOf(address who) constant public returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) tokenBalances;
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(tokenBalances[msg.sender]>=_value);
97     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
98     tokenBalances[_to] = tokenBalances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) constant public returns (uint256 balance) {
109     return tokenBalances[_owner];
110   }
111 
112 }
113 //TODO: Change the name of the token
114 contract Visus is BasicToken,Ownable {
115 
116    using SafeMath for uint256;
117    
118    //TODO: Change the name and the symbol
119    string public constant name = "Visus";
120    string public constant symbol = "VIS";
121    uint256 public constant decimals = 18;
122 
123    uint256 public constant INITIAL_SUPPLY = 100000000 * 10 ** 18;
124    event Debug(string message, address addr, uint256 number);
125   /**
126    * @dev Contructor that gives msg.sender all of existing tokens.
127    */
128    //TODO: Change the name of the constructor
129     function Visus(address wallet) public {
130         owner = msg.sender;
131         totalSupply = INITIAL_SUPPLY;
132         tokenBalances[wallet] = INITIAL_SUPPLY;   
133     }
134 
135   
136   function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {
137         tokenBalance = tokenBalances[addr];
138     }
139 }