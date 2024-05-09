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
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/ALT0Token.sol
97 
98 contract ALT0Token is Ownable, ERC20Basic {
99   using SafeMath for uint256;
100 
101   string public constant name     = "Altair VR presale token";
102   string public constant symbol   = "ALT0";
103   uint8  public constant decimals = 18;
104 
105   bool public mintingFinished = false;
106 
107   mapping(address => uint256) public balances;
108 
109   event Mint(address indexed to, uint256 amount);
110   event MintFinished();
111 
112   /**
113   * @dev Function to mint tokens
114   * @param _to The address that will receive the minted tokens.
115   * @param _amount The amount of tokens to mint.
116   * @return A boolean that indicates if the operation was successful.
117   */
118   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
119     totalSupply = totalSupply.add(_amount);
120     balances[_to] = balances[_to].add(_amount);
121     Mint(_to, _amount);
122     Transfer(address(0), _to, _amount);
123     return true;
124   }
125 
126   /**
127   * @dev Function to stop minting new tokens.
128   * @return True if the operation was successful.
129   */
130   function finishMinting() onlyOwner canMint public returns (bool) {
131     mintingFinished = true;
132     MintFinished();
133     return true;
134   }
135 
136   /**
137   * @dev Current token is not transferred.
138   * After start official token sale ALT, you can exchange your ALT0 to ALT
139   */
140   function transfer(address, uint256) public returns (bool) {
141     revert();
142     return false;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256 balance) {
151     return balances[_owner];
152   }
153 
154   modifier canMint() {
155     require(!mintingFinished);
156     _;
157   }
158 }