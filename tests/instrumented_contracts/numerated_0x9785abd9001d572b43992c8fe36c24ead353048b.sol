1 pragma solidity 0.4.24;
2 
3 
4 
5 /**
6  * @title ERC20Token Interface
7  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8  */
9 contract ERC20Token {
10   function name() public view returns (string);
11   function symbol() public view returns (string);
12   function decimals() public view returns (uint);
13   function totalSupply() public view returns (uint);
14   function balanceOf(address account) public view returns (uint);
15   function transfer(address to, uint amount) public returns (bool);
16   function transferFrom(address from, address to, uint amount) public returns (bool);
17   function approve(address spender, uint amount) public returns (bool);
18   function allowance(address owner, address spender) public view returns (uint);
19 }
20 
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipRenounced(address indexed previousOwner);
32   event OwnershipTransferred(
33     address indexed previousOwner,
34     address indexed newOwner
35   );
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to relinquish control of the contract.
56    * @notice Renouncing to ownership will leave the contract without an owner.
57    * It will not be possible to call the functions with the `onlyOwner`
58    * modifier anymore.
59    */
60   function renounceOwnership() public onlyOwner {
61     emit OwnershipRenounced(owner);
62     owner = address(0);
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param _newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address _newOwner) public onlyOwner {
70     _transferOwnership(_newOwner);
71   }
72 
73   /**
74    * @dev Transfers control of the contract to a newOwner.
75    * @param _newOwner The address to transfer ownership to.
76    */
77   function _transferOwnership(address _newOwner) internal {
78     require(_newOwner != address(0));
79     emit OwnershipTransferred(owner, _newOwner);
80     owner = _newOwner;
81   }
82 }
83 
84 
85 /**
86  * @title SafeMath
87  * @dev Math operations with safety checks that throw on error
88  */
89 library SafeMath {
90 
91   /**
92   * @dev Multiplies two numbers, throws on overflow.
93   */
94   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
95     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
96     // benefit is lost if 'b' is also tested.
97     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
98     if (_a == 0) {
99       return 0;
100     }
101 
102     c = _a * _b;
103     assert(c / _a == _b);
104     return c;
105   }
106 
107   /**
108   * @dev Integer division of two numbers, truncating the quotient.
109   */
110   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
111     // assert(_b > 0); // Solidity automatically throws when dividing by 0
112     // uint256 c = _a / _b;
113     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
114     return _a / _b;
115   }
116 
117   /**
118   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119   */
120   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
121     assert(_b <= _a);
122     return _a - _b;
123   }
124 
125   /**
126   * @dev Adds two numbers, throws on overflow.
127   */
128   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
129     c = _a + _b;
130     assert(c >= _a);
131     return c;
132   }
133 }
134 
135 
136 /**
137  * @title This contract handles the airdrop distribution
138  */
139 contract INNBCAirdropDistribution is Ownable {
140   address public tokenINNBCAddress;
141 
142   /**
143    * @dev Sets the address of the INNBC token
144    * @param tokenAddress The address of the INNBC token contract
145    */
146   function setINNBCTokenAddress(address tokenAddress) external onlyOwner() {
147     require(tokenAddress != address(0), "Token address cannot be null");
148 
149     tokenINNBCAddress = tokenAddress;
150   }
151 
152   /**
153    * @dev Batch transfers tokens from the owner account to the recipients
154    * @param recipients An array of the addresses of the recipients
155    * @param amountPerRecipient An array of amounts of tokens to give to each recipient
156    */
157   function airdropTokens(address[] recipients, uint[] amountPerRecipient) external onlyOwner() {
158     /* 100 recipients is the limit, otherwise we may reach the gas limit */
159     require(recipients.length <= 100, "Recipients list is too long");
160 
161     /* Both arrays need to have the same length */
162     require(recipients.length == amountPerRecipient.length, "Arrays do not have the same length");
163 
164     /* We check if the address of the token contract is set */
165     require(tokenINNBCAddress != address(0), "INNBC token contract address cannot be null");
166 
167     ERC20Token tokenINNBC = ERC20Token(tokenINNBCAddress);
168 
169     /* We check if the owner has enough tokens for everyone */
170     require(
171       calculateSum(amountPerRecipient) <= tokenINNBC.balanceOf(msg.sender),
172       "Sender does not have enough tokens"
173     );
174 
175     /* We check if the contract is allowed to handle this amount */
176     require(
177       calculateSum(amountPerRecipient) <= tokenINNBC.allowance(msg.sender, address(this)),
178       "This contract is not allowed to handle this amount"
179     );
180 
181     /* If everything is okay, we can transfer the tokens */
182     for (uint i = 0; i < recipients.length; i += 1) {
183       tokenINNBC.transferFrom(msg.sender, recipients[i], amountPerRecipient[i]);
184     }
185   }
186 
187   /**
188    * @dev Calculates the sum of an array of uints
189    * @param a An array of uints
190    * @return The sum as an uint
191    */
192   function calculateSum(uint[] a) private pure returns (uint) {
193     uint sum;
194 
195     for (uint i = 0; i < a.length; i = SafeMath.add(i, 1)) {
196       sum = SafeMath.add(sum, a[i]);
197     }
198 
199     return sum;
200   }
201 }