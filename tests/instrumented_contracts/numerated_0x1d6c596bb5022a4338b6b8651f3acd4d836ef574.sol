1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22 
23   event OwnershipRenounced(address indexed previousOwner);
24   event OwnershipTransferred(
25     address indexed previousOwner,
26     address indexed newOwner
27   );
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to relinquish control of the contract.
48    * @notice Renouncing to ownership will leave the contract without an owner.
49    * It will not be possible to call the functions with the `onlyOwner`
50    * modifier anymore.
51    */
52   function renounceOwnership() public onlyOwner {
53     emit OwnershipRenounced(owner);
54     owner = address(0);
55   }
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address _newOwner) public onlyOwner {
62     _transferOwnership(_newOwner);
63   }
64 
65   /**
66    * @dev Transfers control of the contract to a newOwner.
67    * @param _newOwner The address to transfer ownership to.
68    */
69   function _transferOwnership(address _newOwner) internal {
70     require(_newOwner != address(0));
71     emit OwnershipTransferred(owner, _newOwner);
72     owner = _newOwner;
73   }
74 }
75 
76 contract BBODServiceRegistry is Ownable {
77 
78   //1. Manager
79   //2. CustodyStorage
80   mapping(uint => address) public registry;
81 
82     constructor(address _owner) {
83         owner = _owner;
84     }
85 
86   function setServiceRegistryEntry (uint key, address entry) external onlyOwner {
87     registry[key] = entry;
88   }
89 }
90 
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender)
98     public view returns (uint256);
99 
100   function transferFrom(address from, address to, uint256 value)
101     public returns (bool);
102 
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(
105     address indexed owner,
106     address indexed spender,
107     uint256 value
108   );
109 }
110 
111 
112 /**
113  * @title SafeMath
114  * @dev Math operations with safety checks that throw on error
115  */
116 library SafeMath {
117 
118   /**
119   * @dev Multiplies two numbers, throws on overflow.
120   */
121   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
122     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
123     // benefit is lost if 'b' is also tested.
124     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
125     if (a == 0) {
126       return 0;
127     }
128 
129     c = a * b;
130     assert(c / a == b);
131     return c;
132   }
133 
134   /**
135   * @dev Integer division of two numbers, truncating the quotient.
136   */
137   function div(uint256 a, uint256 b) internal pure returns (uint256) {
138     // assert(b > 0); // Solidity automatically throws when dividing by 0
139     // uint256 c = a / b;
140     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141     return a / b;
142   }
143 
144   /**
145   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
146   */
147   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148     assert(b <= a);
149     return a - b;
150   }
151 
152   /**
153   * @dev Adds two numbers, throws on overflow.
154   */
155   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
156     c = a + b;
157     assert(c >= a);
158     return c;
159   }
160 }
161 
162 
163 contract ManagerInterface {
164   function createCustody(address) external {}
165 
166   function isExchangeAlive() public pure returns (bool) {}
167 
168   function isDailySettlementOnGoing() public pure returns (bool) {}
169 }
170 
171 contract Custody {
172 
173   using SafeMath for uint;
174 
175   BBODServiceRegistry public bbodServiceRegistry;
176   address public owner;
177 
178   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179 
180   constructor(address _serviceRegistryAddress, address _owner) public {
181     bbodServiceRegistry = BBODServiceRegistry(_serviceRegistryAddress);
182     owner = _owner;
183   }
184 
185   function() public payable {}
186 
187   modifier liveExchangeOrOwner(address _recipient) {
188     var manager = ManagerInterface(bbodServiceRegistry.registry(1));
189 
190     if (manager.isExchangeAlive()) {
191 
192       require(msg.sender == address(manager));
193 
194       if (manager.isDailySettlementOnGoing()) {
195         require(_recipient == address(manager), "Only manager can do this when the settlement is ongoing");
196       } else {
197         require(_recipient == owner);
198       }
199 
200     } else {
201       require(msg.sender == owner, "Only owner can do this when exchange is dead");
202     }
203     _;
204   }
205 
206   function withdraw(uint _amount, address _recipient) external liveExchangeOrOwner(_recipient) {
207     _recipient.transfer(_amount);
208   }
209 
210   function transferToken(address _erc20Address, address _recipient, uint _amount)
211     external liveExchangeOrOwner(_recipient) {
212 
213     ERC20 token = ERC20(_erc20Address);
214 
215     token.transfer(_recipient, _amount);
216   }
217 
218   function transferOwnership(address newOwner) public {
219     require(msg.sender == owner, "Only the owner can transfer ownership");
220     require(newOwner != address(0));
221 
222     emit OwnershipTransferred(owner, newOwner);
223     owner = newOwner;
224   }
225 }
226 
227 
228 contract Insurance is Custody {
229 
230   constructor(address _serviceRegistryAddress, address _owner)
231   Custody(_serviceRegistryAddress, _owner) public {}
232 
233   function useInsurance (uint _amount) external {
234     var manager = ManagerInterface(bbodServiceRegistry.registry(1));
235     //Only usable for manager during settlement
236     require(manager.isDailySettlementOnGoing() && msg.sender == address(manager));
237 
238     address(manager).transfer(_amount);
239   }
240 }