1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract ALT1Token is Ownable, ERC20Basic {
91   using SafeMath for uint256;
92 
93   string public constant name     = "Altair VR presale token";
94   string public constant symbol   = "ALT1";
95   uint8  public constant decimals = 18;
96 
97   bool public mintingFinished = false;
98 
99   mapping(address => uint256) public balances;
100   address[] public holders;
101 
102   event Mint(address indexed to, uint256 amount);
103   event MintFinished();
104 
105   /**
106   * @dev Function to mint tokens
107   * @param _to The address that will receive the minted tokens.
108   * @param _amount The amount of tokens to mint.
109   * @return A boolean that indicates if the operation was successful.
110   */
111   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
112     totalSupply = totalSupply.add(_amount);
113     if (balances[_to] == 0) { 
114       holders.push(_to);
115     }
116     balances[_to] = balances[_to].add(_amount);
117 
118     Mint(_to, _amount);
119     Transfer(address(0), _to, _amount);
120     return true;
121   }
122 
123   /**
124   * @dev Function to stop minting new tokens.
125   * @return True if the operation was successful.
126   */
127   function finishMinting() onlyOwner canMint public returns (bool) {
128     mintingFinished = true;
129     MintFinished();
130     return true;
131   }
132 
133   /**
134   * @dev Current token is not transferred.
135   * After start official token sale ALT, you can exchange your ALT1 to ALT
136   */
137   function transfer(address, uint256) public returns (bool) {
138     revert();
139     return false;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151   modifier canMint() {
152     require(!mintingFinished);
153     _;
154   }
155 }