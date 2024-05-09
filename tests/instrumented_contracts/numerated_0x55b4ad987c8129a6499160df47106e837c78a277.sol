1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73   uint256 public totalSupply;
74   function balanceOf(address who) public view returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address private _owner;
86 
87   event OwnershipRenounced(address indexed previousOwner);
88   event OwnershipTransferred(
89     address indexed previousOwner,
90     address indexed newOwner
91   );
92 
93   /**
94    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
95    * account.
96    */
97   constructor() public {
98     _owner = msg.sender;
99   }
100 
101   /**
102    * @return the address of the owner.
103    */
104   function owner() public view returns(address) {
105     return _owner;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(isOwner());
113     _;
114   }
115 
116   /**
117    * @return true if `msg.sender` is the owner of the contract.
118    */
119   function isOwner() public view returns(bool) {
120     return msg.sender == _owner;
121   }
122 
123   /**
124    * @dev Allows the current owner to relinquish control of the contract.
125    * @notice Renouncing to ownership will leave the contract without an owner.
126    * It will not be possible to call the functions with the `onlyOwner`
127    * modifier anymore.
128    */
129   function renounceOwnership() public onlyOwner {
130     emit OwnershipRenounced(_owner);
131     _owner = address(0);
132   }
133 
134   /**
135    * @dev Allows the current owner to transfer control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function transferOwnership(address newOwner) public onlyOwner {
139     _transferOwnership(newOwner);
140   }
141 
142   /**
143    * @dev Transfers control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function _transferOwnership(address newOwner) internal {
147     require(newOwner != address(0));
148     emit OwnershipTransferred(_owner, newOwner);
149     _owner = newOwner;
150   }
151 }
152 
153 contract GAMA1Token is Ownable, ERC20Basic {
154   using SafeMath for uint256;
155 
156   string public constant name     = "Gamayun round 1 token";
157   string public constant symbol   = "GAMA1";
158   uint8  public constant decimals = 18;
159 
160   bool public mintingFinished = false;
161 
162   mapping(address => uint256) public balances;
163   address[] public holders;
164 
165   event Mint(address indexed to, uint256 amount);
166   event MintFinished();
167 
168   /**
169   * @dev Function to mint tokens
170   * @param _to The address that will receive the minted tokens.
171   * @param _amount The amount of tokens to mint.
172   * @return A boolean that indicates if the operation was successful.
173   */
174   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
175     totalSupply = totalSupply.add(_amount);
176     if (balances[_to] == 0) { 
177       holders.push(_to);
178     }
179     balances[_to] = balances[_to].add(_amount);
180 
181     Mint(_to, _amount);
182     Transfer(address(0), _to, _amount);
183     return true;
184   }
185 
186   /**
187   * @dev Function to stop minting new tokens.
188   * @return True if the operation was successful.
189   */
190   function finishMinting() onlyOwner canMint public returns (bool) {
191     mintingFinished = true;
192     MintFinished();
193     return true;
194   }
195 
196   /**
197   * @dev Current token is not transferred.
198   * After start official token sale GAMA, you can exchange your tokens
199   */
200   function transfer(address, uint256) public returns (bool) {
201     revert();
202     return false;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param _owner The address to query the the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address _owner) public view returns (uint256 balance) {
211     return balances[_owner];
212   }
213 
214   modifier canMint() {
215     require(!mintingFinished);
216     _;
217   }
218 }