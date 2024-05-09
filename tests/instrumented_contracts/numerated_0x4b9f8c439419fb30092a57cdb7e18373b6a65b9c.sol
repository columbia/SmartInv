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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address public owner;
72 
73 
74   event OwnershipRenounced(address indexed previousOwner);
75   event OwnershipTransferred(
76     address indexed previousOwner,
77     address indexed newOwner
78   );
79 
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() public {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to relinquish control of the contract.
99    * @notice Renouncing to ownership will leave the contract without an owner.
100    * It will not be possible to call the functions with the `onlyOwner`
101    * modifier anymore.
102    */
103   function renounceOwnership() public onlyOwner {
104     emit OwnershipRenounced(owner);
105     owner = address(0);
106   }
107 
108   /**
109    * @dev Allows the current owner to transfer control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114   }
115 
116   /**
117    * @dev Transfers control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function _transferOwnership(address _newOwner) internal {
121     require(_newOwner != address(0));
122     emit OwnershipTransferred(owner, _newOwner);
123     owner = _newOwner;
124   }
125 }
126 
127 contract CSCToken is Ownable, ERC20Basic {
128   using SafeMath for uint256;
129 
130   string public constant name     = "Crypto Service Capital Token";
131   string public constant symbol   = "CSCT";
132   uint8  public constant decimals = 18;
133 
134   bool public mintingFinished = false;
135 
136   mapping(address => uint256) public balances;
137   address[] public holders;
138 
139   event Mint(address indexed to, uint256 amount);
140   event MintFinished();
141 
142   /**
143   * @dev Function to mint tokens
144   * @param _to The address that will receive the minted tokens.
145   * @param _amount The amount of tokens to mint.
146   * @return A boolean that indicates if the operation was successful.
147   */
148   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
149     totalSupply = totalSupply.add(_amount);
150     if (balances[_to] == 0) { 
151       holders.push(_to);
152     }
153     balances[_to] = balances[_to].add(_amount);
154 
155     Mint(_to, _amount);
156     Transfer(address(0), _to, _amount);
157     return true;
158   }
159 
160   /**
161   * @dev Function to stop minting new tokens.
162   * @return True if the operation was successful.
163   */
164   function finishMinting() onlyOwner canMint public returns (bool) {
165     mintingFinished = true;
166     MintFinished();
167     return true;
168   }
169 
170   /**
171   * @dev Current token is not transferred.
172   * After start official token sale CSCT, you can exchange your tokens
173   */
174   function transfer(address, uint256) public returns (bool) {
175     revert();
176     return false;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256 balance) {
185     return balances[_owner];
186   }
187 
188   modifier canMint() {
189     require(!mintingFinished);
190     _;
191   }
192 }