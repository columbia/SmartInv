1 pragma solidity ^0.4.18;
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
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   uint256 public totalSupply;
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipRenounced(address indexed previousOwner);
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   constructor() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     emit OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101   /**
102    * @dev Allows the current owner to relinquish control of the contract.
103    */
104   function renounceOwnership() public onlyOwner {
105     emit OwnershipRenounced(owner);
106     owner = address(0);
107   }
108 }
109 
110 contract VIDI1Token is Ownable, ERC20Basic {
111   using SafeMath for uint256;
112 
113   string public constant name     = "Vidion private-round token";
114   string public constant symbol   = "VIDI1";
115   uint8  public constant decimals = 18;
116 
117   bool public mintingFinished = false;
118 
119   mapping(address => uint256) public balances;
120   address[] public holders;
121 
122   event Mint(address indexed to, uint256 amount);
123   event MintFinished();
124 
125   /**
126   * @dev Function to mint tokens
127   * @param _to The address that will receive the minted tokens.
128   * @param _amount The amount of tokens to mint.
129   * @return A boolean that indicates if the operation was successful.
130   */
131   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
132     totalSupply = totalSupply.add(_amount);
133     if (balances[_to] == 0) { 
134       holders.push(_to);
135     }
136     balances[_to] = balances[_to].add(_amount);
137 
138     Mint(_to, _amount);
139     Transfer(address(0), _to, _amount);
140     return true;
141   }
142 
143   /**
144   * @dev Function to stop minting new tokens.
145   * @return True if the operation was successful.
146   */
147   function finishMinting() onlyOwner canMint public returns (bool) {
148     mintingFinished = true;
149     MintFinished();
150     return true;
151   }
152 
153   /**
154   * @dev Current token is not transferred.
155   * After start official token sale VIDI, you can exchange your tokens
156   */
157   function transfer(address, uint256) public returns (bool) {
158     revert();
159     return false;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256 balance) {
168     return balances[_owner];
169   }
170 
171   modifier canMint() {
172     require(!mintingFinished);
173     _;
174   }
175 }