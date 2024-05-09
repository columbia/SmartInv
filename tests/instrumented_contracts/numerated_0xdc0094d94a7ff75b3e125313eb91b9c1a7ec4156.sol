1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal pure returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal pure returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract Ownable {
29   address public owner;
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant public returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) tokenBalances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(tokenBalances[msg.sender]>=_value);
87     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
88     tokenBalances[_to] = tokenBalances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) constant public returns (uint256 balance) {
99     return tokenBalances[_owner];
100   }
101 
102 }
103 contract ERP is BasicToken,Ownable {
104 
105    using SafeMath for uint256;
106    
107    string public constant name = "ERP";
108    string public constant symbol = "ERP";
109    uint256 public constant decimals = 18;  
110    address public ethStore = 0xDcbFE8d41D4559b3EAD3179fa7Bb3ad77EaDa564;
111    uint256 public REMAINING_SUPPLY = 100000000000  * (10 ** uint256(decimals));
112    event Debug(string message, address addr, uint256 number);
113    event Message(string message);
114     string buyMessage;
115   
116   address wallet;
117    /**
118    * @dev Contructor that gives msg.sender all of existing tokens.
119    */
120     function ERP(address _wallet) public {
121         owner = msg.sender;
122         totalSupply = REMAINING_SUPPLY;
123         wallet = _wallet;
124         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
125     }
126     
127      function mint(address from, address to, uint256 tokenAmount) public onlyOwner {
128       require(tokenBalances[from] >= tokenAmount);               // checks if it has enough to sell
129       tokenBalances[to] = tokenBalances[to].add(tokenAmount);                  // adds the amount to buyer's balance
130       tokenBalances[from] = tokenBalances[from].sub(tokenAmount);                        // subtracts amount from seller's balance
131       REMAINING_SUPPLY = tokenBalances[wallet];
132       Transfer(from, to, tokenAmount); 
133     }
134     
135     function getTokenBalance(address user) public view returns (uint256 balance) {
136         balance = tokenBalances[user]; // show token balance in full tokens not part
137         return balance;
138     }
139 }