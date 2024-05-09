1 pragma solidity 0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, reverts on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     require(c / a == b);
19     return c;
20   }
21   /**
22   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b > 0); // Solidity only automatically asserts when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30   /**
31   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b <= a);
35     uint256 c = a - b;
36     return c;
37   }
38   /**
39   * @dev Adds two numbers, reverts on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     require(c >= a);
44     return c;
45   }
46   /**
47   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
48   * reverts when dividing by zero.
49   */
50   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51     require(b != 0);
52     return a % b;
53   }
54 }
55 contract Token {
56   /// @return total amount of tokens
57   function totalSupply() pure public returns (uint256 supply);
58   /// @param _owner The address from which the balance will be retrieved
59   /// @return The balance
60   function balanceOf(address _owner) pure public returns (uint256 balance);
61   /// @notice send `_value` token to `_to` from `msg.sender`
62   /// @param _to The address of the recipient
63   /// @param _value The amount of token to be transferred
64   /// @return Whether the transfer was successful or not
65   function transfer(address _to, uint256 _value) public returns (bool success);
66   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
67   /// @param _from The address of the sender
68   /// @param _to The address of the recipient
69   /// @param _value The amount of token to be transferred
70   /// @return Whether the transfer was successful or not
71   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
72   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
73   /// @param _spender The address of the account able to transfer the tokens
74   /// @param _value The amount of wei to be approved for transfer
75   /// @return Whether the approval was successful or not
76   function approve(address _spender, uint256 _value) public returns (bool success);
77   /// @param _owner The address of the account owning tokens
78   /// @param _spender The address of the account able to transfer the tokens
79   /// @return Amount of remaining tokens allowed to spent
80   function allowance(address _owner, address _spender) pure public returns (uint256 remaining);
81   event Transfer(address indexed _from, address indexed _to, uint256 _value);
82   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83   uint public decimals;
84   string public name;
85 }
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92   address private _owner;
93   event OwnershipTransferred(
94     address indexed previousOwner,
95     address indexed newOwner
96   );
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   constructor() internal {
102     _owner = msg.sender;
103     emit OwnershipTransferred(address(0), _owner);
104   }
105   /**
106    * @return the address of the owner.
107    */
108   function owner() public view returns(address) {
109     return _owner;
110   }
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(isOwner());
116     _;
117   }
118   /**
119    * @return true if `msg.sender` is the owner of the contract.
120    */
121   function isOwner() public view returns(bool) {
122     return msg.sender == _owner;
123   }
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    * @notice Renouncing to ownership will leave the contract without an owner.
127    * It will not be possible to call the functions with the `onlyOwner`
128    * modifier anymore.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipTransferred(_owner, address(0));
132     _owner = address(0);
133   }
134   /**
135    * @dev Allows the current owner to transfer control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function transferOwnership(address newOwner) public onlyOwner {
139     _transferOwnership(newOwner);
140   }
141   /**
142    * @dev Transfers control of the contract to a newOwner.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function _transferOwnership(address newOwner) internal {
146     require(newOwner != address(0));
147     emit OwnershipTransferred(_owner, newOwner);
148     _owner = newOwner;
149   }
150 }
151 contract AirDrop is Ownable {
152   address public tokenAddress;
153   Token public token;
154   uint256 public valueAirDrop;
155   mapping (address => uint8) public payedAddress; 
156   constructor() public{
157     valueAirDrop = 1 * 1 ether;
158   } 
159   function setValueAirDrop(uint256 _valueAirDrop) public onlyOwner{
160     valueAirDrop = _valueAirDrop;
161   } 
162   function setTokenAddress(address _address) onlyOwner public{
163     tokenAddress = _address;
164     token = Token(tokenAddress);  
165   }
166   function refund() onlyOwner public{
167     token.transfer(owner(), token.balanceOf(this));  
168   }
169   function () external payable {
170     require(msg.value == 0);
171     require(payedAddress[msg.sender] == 0);  
172     payedAddress[msg.sender] = 1;  
173     token.transfer(msg.sender, valueAirDrop);
174   }
175   function multisend(address[] _addressDestination)
176     onlyOwner
177     public {
178         uint256 i = 0;
179         while (i < _addressDestination.length) {
180            token.transfer(_addressDestination[i], valueAirDrop);
181            i += 1;
182         }
183     }  
184 }