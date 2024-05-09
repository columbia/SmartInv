1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
117 
118 /**
119  * @title Contracts that should not own Ether
120  * @author Remco Bloemen <remco@2π.com>
121  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
122  * in the contract, it will allow the owner to reclaim this ether.
123  * @notice Ether can still be sent to this contract by:
124  * calling functions labeled `payable`
125  * `selfdestruct(contract_address)`
126  * mining directly to the contract address
127  */
128 contract HasNoEther is Ownable {
129 
130   /**
131   * @dev Constructor that rejects incoming Ether
132   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
133   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
134   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
135   * we could use assembly to access msg.value.
136   */
137   constructor() public payable {
138     require(msg.value == 0);
139   }
140 
141   /**
142    * @dev Disallows direct send by settings a default function without the `payable` flag.
143    */
144   function() external {
145   }
146 
147   /**
148    * @dev Transfer all Ether held by the contract to the owner.
149    */
150   function reclaimEther() external onlyOwner {
151     owner.transfer(address(this).balance);
152   }
153 }
154 
155 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
156 
157 /**
158  * @title ERC20Basic
159  * @dev Simpler version of ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/179
161  */
162 contract ERC20Basic {
163   function totalSupply() public view returns (uint256);
164   function balanceOf(address who) public view returns (uint256);
165   function transfer(address to, uint256 value) public returns (bool);
166   event Transfer(address indexed from, address indexed to, uint256 value);
167 }
168 
169 // File: contracts/pixie/PixieTokenAirdropper.sol
170 
171 contract PixieTokenAirdropper is Ownable, HasNoEther {
172 
173   // The token which is already deployed to the network
174   ERC20Basic public token;
175 
176   event AirDroppedTokens(uint256 addressCount);
177   event AirDrop(address indexed receiver, uint256 total);
178 
179   // After this contract is deployed, we will grant access to this contract
180   // by calling methods on the token since we are using the same owner
181   // and granting the distribution of tokens to this contract
182   constructor(address _token) public payable {
183     require(_token != address(0), "Must be a non-zero address");
184 
185     token = ERC20Basic(_token);
186   }
187 
188   function transfer(address[] _address, uint256[] _values) onlyOwner public {
189     require(_address.length == _values.length, "Address array and values array must be same length");
190 
191     for (uint i = 0; i < _address.length; i += 1) {
192       _transfer(_address[i], _values[i]);
193     }
194 
195     emit AirDroppedTokens(_address.length);
196   }
197 
198   function transferSingle(address _address, uint256 _value) onlyOwner public {
199     _transfer(_address, _value);
200 
201     emit AirDroppedTokens(1);
202   }
203 
204   function _transfer(address _address, uint256 _value) internal {
205     require(_address != address(0), "Address invalid");
206     require(_value > 0, "Value invalid");
207 
208     token.transfer(_address, _value);
209 
210     emit AirDrop(_address, _value);
211   }
212 
213   function remainingBalance() public view returns (uint256) {
214     return token.balanceOf(address(this));
215   }
216 
217   // after we distribute the bonus tokens, we will send them back to the coin itself
218   function ownerRecoverTokens(address _beneficiary) external onlyOwner {
219     require(_beneficiary != address(0));
220     require(_beneficiary != address(token));
221 
222     uint256 _tokensRemaining = token.balanceOf(address(this));
223     if (_tokensRemaining > 0) {
224       token.transfer(_beneficiary, _tokensRemaining);
225     }
226   }
227 
228 }