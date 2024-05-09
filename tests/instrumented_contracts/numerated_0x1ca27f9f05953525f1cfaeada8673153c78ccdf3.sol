1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Helps contracts guard agains reentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>
6  * @notice If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10 
11   /**
12    * @dev We use a single lock for the whole contract.
13    */
14   bool private reentrancyLock = false;
15 
16   /**
17    * @dev Prevents a contract from calling itself, directly or indirectly.
18    * @notice If you mark a function `nonReentrant`, you should also
19    * mark it `external`. Calling one nonReentrant function from
20    * another is not supported. Instead, you can implement a
21    * `private` function doing the actual work, and a `external`
22    * wrapper marked as `nonReentrant`.
23    */
24   modifier nonReentrant() {
25     require(!reentrancyLock);
26     reentrancyLock = true;
27     _;
28     reentrancyLock = false;
29   }
30 
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
44     // benefit is lost if 'b' is also tested.
45     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46     if (a == 0) {
47       return 0;
48     }
49 
50     c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return a / b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * @title Ownable
85  * @dev The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91   event OwnershipRenounced(address indexed previousOwner);
92   event OwnershipTransferred(
93     address indexed previousOwner,
94     address indexed newOwner
95   );
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   constructor() public {
102     owner = msg.sender;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to relinquish control of the contract.
115    * @notice Renouncing to ownership will leave the contract without an owner.
116    * It will not be possible to call the functions with the `onlyOwner`
117    * modifier anymore.
118    */
119   function renounceOwnership() public onlyOwner {
120     emit OwnershipRenounced(owner);
121     owner = address(0);
122   }
123 
124   /**
125    * @dev Allows the current owner to transfer control of the contract to a newOwner.
126    * @param _newOwner The address to transfer ownership to.
127    */
128   function transferOwnership(address _newOwner) public onlyOwner {
129     _transferOwnership(_newOwner);
130   }
131 
132   /**
133    * @dev Transfers control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function _transferOwnership(address _newOwner) internal {
137     require(_newOwner != address(0));
138     emit OwnershipTransferred(owner, _newOwner);
139     owner = _newOwner;
140   }
141 }
142 
143 interface ERC20 {
144     function totalSupply() external view returns (uint supply);
145     function balanceOf(address _owner) external view returns (uint balance);
146     function transfer(address _to, uint _value) external returns (bool success);
147     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
148     function approve(address _spender, uint _value) external returns (bool success);
149     function allowance(address _owner, address _spender) external view returns (uint remaining);
150     function decimals() external view returns(uint digits);
151     event Approval(address indexed _owner, address indexed _spender, uint _value);
152 }
153 
154 contract Rainmaker is Ownable, ReentrancyGuard {
155     function letItRain(address[] _to, uint[] _value) nonReentrant onlyOwner public payable returns (bool _success) {
156         for (uint8 i = 0; i < _to.length; i++){
157             uint amount = _value[i] * 1 finney;
158             _to[i].transfer(amount);
159         }
160         return true;
161     }
162     
163     //If accidentally tokens are transferred to this
164     //contract. They can be withdrawn by the following interface.
165     function withdrawERC20Token(ERC20 anyToken) public onlyOwner nonReentrant returns(bool){
166         if( anyToken != address(0x0) ) {
167             assert(anyToken.transfer(owner, anyToken.balanceOf(this)));
168         }
169         return true;
170     }
171 
172     //ETH cannot get locked in this contract. If it does, this can be used to withdraw
173     //the locked ether.
174     function withdrawEther() public onlyOwner nonReentrant returns(bool){
175         if(address(this).balance > 0){
176             owner.transfer(address(this).balance);
177         }        
178         return true;
179     }
180 }