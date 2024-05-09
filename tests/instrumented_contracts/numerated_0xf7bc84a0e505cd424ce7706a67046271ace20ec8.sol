1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Crowdsale
5  * @dev Crowdsale is a base contract for managing a token crowdsale.
6  * Crowdsales have a start and end timestamps, where investors can make
7  * token purchases and the crowdsale will assign them tokens based
8  * on a token per ETH rate. Funds collected are forwarded to a wallet
9  * as they arrive.
10  */
11  
12  
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20  function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) constant public returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) tokenBalances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(tokenBalances[msg.sender]>=_value);
103     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
104     tokenBalances[_to] = tokenBalances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) constant public returns (uint256 balance) {
115     return tokenBalances[_owner];
116   }
117 
118 }
119 contract EtheeraToken is BasicToken,Ownable {
120 
121    using SafeMath for uint256;
122    
123    string public constant name = "ETHEERA";
124    string public constant symbol = "ETA";
125    uint256 public constant decimals = 18;
126 
127    uint256 public constant INITIAL_SUPPLY = 300000000;
128    event Debug(string message, address addr, uint256 number);
129    /**
130    * @dev Contructor that gives msg.sender all of existing tokens.
131    */
132     function EtheeraToken(address wallet) public {
133         owner = msg.sender;
134         totalSupply = INITIAL_SUPPLY * 10 ** 18;
135         tokenBalances[wallet] = totalSupply;   //Since we divided the token into 10^18 parts
136     }
137 
138     function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {
139       require(tokenBalances[wallet] >= tokenAmount);               // checks if it has enough to sell
140       tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance
141       tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance
142       Transfer(wallet, buyer, tokenAmount);
143       totalSupply = totalSupply.sub(tokenAmount);
144     }
145     
146     function showMyTokenBalance(address addr) public view onlyOwner returns (uint tokenBalance) {
147         tokenBalance = tokenBalances[addr];
148         return tokenBalance;
149     }
150     
151 }