1 pragma solidity ^0.4.25;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
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
67 // File: contracts\GPAAirDrop.sol
68 
69 /**
70  * @title GPA Token AirDrop
71  * @dev The main GPA AirDrop contract
72  */
73 contract GPAAirDrop is Ownable {
74   using SafeMath for uint256;
75 
76   uint8 public decimals;
77 
78   event AirdropTransferCompleted(uint256 _value);
79   event ChangeDecimals(uint8 _decimals);
80   event Fallback(address indexed _from, uint256 _value);
81 
82   constructor() public {
83     decimals = 18;
84   }
85 
86   function () public payable {
87     emit Fallback(msg.sender, msg.value);
88     //revert();
89   }
90 
91   /*
92   * @dev Fix for the ERC20 short address attack
93   */
94   modifier onlyPayloadSize(uint size) {
95    assert(msg.data.length >= size + 4);
96    _;
97   }
98 
99   function setDecimals(uint8 _decimals) public onlyOwner {
100     decimals = _decimals;
101     emit ChangeDecimals(decimals);
102   }
103 
104   function _allowanceRemain(ERC20Interface _targetToken) internal view returns (uint256) {
105     return _targetToken.allowance(owner, this).div(10 ** uint256(decimals)) ;
106   }
107 
108   function execAirDrop(address _tokenAddr, address[] addrList, uint256[] valList) public onlyOwner onlyPayloadSize(2 * 32) returns (uint256) {
109     uint256 i = 0;
110     uint256 allowanceValue = _allowanceRemain(ERC20Interface(_tokenAddr));
111 
112     while (i < addrList.length) {
113       require(allowanceValue >= valList[i]);
114 
115       require(ERC20Interface(_tokenAddr).transferFrom(msg.sender, addrList[i], valList[i].mul(10 ** uint256(decimals))));
116 
117       allowanceValue.sub(valList[i]);
118       i++;
119     }
120 
121     emit AirdropTransferCompleted(addrList.length);
122     return i;
123   }
124 
125 }
126 
127 contract ERC20Interface {
128     function totalSupply() public constant returns (uint256);
129     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
130     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
131     function transfer(address to, uint256 tokens) public returns (bool success);
132     function approve(address spender, uint256 tokens) public returns (bool success);
133     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
134 
135     event Transfer(address indexed from, address indexed to, uint256 tokens);
136     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
137 }
138 
139 /**
140  * @title SafeMath
141  * @dev Math operations with safety checks that throw on error
142  */
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
150     // benefit is lost if 'b' is also tested.
151     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152     if (a == 0) {
153       return 0;
154     }
155 
156     c = a * b;
157     assert(c / a == b);
158     return c;
159   }
160 
161   /**
162   * @dev Integer division of two numbers, truncating the quotient.
163   */
164   function div(uint256 a, uint256 b) internal pure returns (uint256) {
165     // assert(b > 0); // Solidity automatically throws when dividing by 0
166     // uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168     return a / b;
169   }
170 
171   /**
172   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
173   */
174   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175     assert(b <= a);
176     return a - b;
177   }
178 
179   /**
180   * @dev Adds two numbers, throws on overflow.
181   */
182   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
183     c = a + b;
184     assert(c >= a);
185     return c;
186   }
187 
188 }