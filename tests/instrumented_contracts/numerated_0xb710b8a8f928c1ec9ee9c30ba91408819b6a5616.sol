1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address _who) public view returns (uint256);
77   function transfer(address _to, uint256 _value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address _owner, address _spender)
89     public view returns (uint256);
90 
91   function transferFrom(address _from, address _to, uint256 _value)
92     public returns (bool);
93 
94   function approve(address _spender, uint256 _value) public returns (bool);
95   event Approval(
96     address indexed owner,
97     address indexed spender,
98     uint256 value
99   );
100 }
101 
102 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109 
110   /**
111   * @dev Multiplies two numbers, throws on overflow.
112   */
113   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
114     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (_a == 0) {
118       return 0;
119     }
120 
121     c = _a * _b;
122     assert(c / _a == _b);
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers, truncating the quotient.
128   */
129   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
130     // assert(_b > 0); // Solidity automatically throws when dividing by 0
131     // uint256 c = _a / _b;
132     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
133     return _a / _b;
134   }
135 
136   /**
137   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138   */
139   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
140     assert(_b <= _a);
141     return _a - _b;
142   }
143 
144   /**
145   * @dev Adds two numbers, throws on overflow.
146   */
147   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
148     c = _a + _b;
149     assert(c >= _a);
150     return c;
151   }
152 }
153 
154 // File: contracts/LuckboxAirdrop.sol
155 
156 contract LuckboxAirdrop is Ownable {
157   // good to have an event different from Transfer, since tracking will be easier
158   event Airdrop(address indexed to, uint256 value);
159 
160   using SafeMath for uint;
161 
162   ERC20 LCK;
163   address public lckTokenAddress;
164 
165   constructor(address tokenAddress)
166   public {
167     lckTokenAddress = tokenAddress;
168     LCK = ERC20(lckTokenAddress);
169   }
170 
171   function distribute(address[] recipients, uint amount)
172   public onlyOwner
173   returns(uint) {
174     // want to have enough tokens, so that we don't die mid-way
175     require(LCK.balanceOf(this) >= amount.mul(recipients.length));
176 
177     uint i = 0;
178     while (i < recipients.length) {
179       LCK.transfer(recipients[i], amount);
180       emit Airdrop(recipients[i], amount);
181       i += 1;
182     }
183 
184     return(i);
185   }
186 
187   function returnTokens()
188   public onlyOwner {
189     // return remaining tokens to owner
190     LCK.transfer(owner, LCK.balanceOf(this));
191   }
192 }