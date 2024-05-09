1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Helps contracts guard against reentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
6  * @dev If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10 
11   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
12   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
13   uint private constant REENTRANCY_GUARD_FREE = 1;
14 
15   /// @dev Constant for locked guard state
16   uint private constant REENTRANCY_GUARD_LOCKED = 2;
17 
18   /**
19    * @dev We use a single lock for the whole contract.
20    */
21   uint private reentrancyLock = REENTRANCY_GUARD_FREE;
22 
23   /**
24    * @dev Prevents a contract from calling itself, directly or indirectly.
25    * If you mark a function `nonReentrant`, you should also
26    * mark it `external`. Calling one `nonReentrant` function from
27    * another is not supported. Instead, you can implement a
28    * `private` function doing the actual work, and an `external`
29    * wrapper marked as `nonReentrant`.
30    */
31   modifier nonReentrant() {
32     require(reentrancyLock == REENTRANCY_GUARD_FREE);
33     reentrancyLock = REENTRANCY_GUARD_LOCKED;
34     _;
35     reentrancyLock = REENTRANCY_GUARD_FREE;
36   }
37 
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96   address public owner;
97 
98   event OwnershipRenounced(address indexed previousOwner);
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104   /**
105    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106    * account.
107    */
108   constructor() public {
109     owner = msg.sender;
110   }
111 
112   /**
113    * @dev Throws if called by any account other than the owner.
114    */
115   modifier onlyOwner() {
116     require(msg.sender == owner);
117     _;
118   }
119 
120   /**
121    * @dev Allows the current owner to relinquish control of the contract.
122    * @notice Renouncing to ownership will leave the contract without an owner.
123    * It will not be possible to call the functions with the `onlyOwner`
124    * modifier anymore.
125    */
126   function renounceOwnership() public onlyOwner {
127     emit OwnershipRenounced(owner);
128     owner = address(0);
129   }
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param _newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address _newOwner) public onlyOwner {
136     _transferOwnership(_newOwner);
137   }
138 
139   /**
140    * @dev Transfers control of the contract to a newOwner.
141    * @param _newOwner The address to transfer ownership to.
142    */
143   function _transferOwnership(address _newOwner) internal {
144     require(_newOwner != address(0));
145     emit OwnershipTransferred(owner, _newOwner);
146     owner = _newOwner;
147   }
148 }
149 
150 interface ERC20 {
151     function totalSupply() external view returns (uint supply);
152     function balanceOf(address _owner) external view returns (uint balance);
153     function transfer(address _to, uint _value) external returns (bool success);
154     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
155     function approve(address _spender, uint _value) external returns (bool success);
156     function allowance(address _owner, address _spender) external view returns (uint remaining);
157     function decimals() external view returns(uint digits);
158     event Approval(address indexed _owner, address indexed _spender, uint _value);
159 }
160 
161 contract Indorser is Ownable, ReentrancyGuard {
162 
163     function multisend(address _tokenAddr, address[] _to, uint256[] _value) onlyOwner returns (bool _success) {
164         assert(_to.length == _value.length);
165 		assert(_to.length <= 150);
166         // loop through to addresses and send value
167 		for (uint8 i = 0; i < _to.length; i++) {
168             assert((ERC20(_tokenAddr).transfer(_to[i], _value[i])) == true);
169         }
170         return true;
171     }
172 }