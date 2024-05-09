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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
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
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
120 
121 /**
122  * @title Claimable
123  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
124  * This allows the new owner to accept the transfer.
125  */
126 contract Claimable is Ownable {
127   address public pendingOwner;
128 
129   /**
130    * @dev Modifier throws if called by any account other than the pendingOwner.
131    */
132   modifier onlyPendingOwner() {
133     require(msg.sender == pendingOwner);
134     _;
135   }
136 
137   /**
138    * @dev Allows the current owner to set the pendingOwner address.
139    * @param newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address newOwner) public onlyOwner {
142     pendingOwner = newOwner;
143   }
144 
145   /**
146    * @dev Allows the pendingOwner address to finalize the transfer.
147    */
148   function claimOwnership() public onlyPendingOwner {
149     emit OwnershipTransferred(owner, pendingOwner);
150     owner = pendingOwner;
151     pendingOwner = address(0);
152   }
153 }
154 
155 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
156 
157 /**
158  * @title ERC20Basic
159  * @dev Simpler version of ERC20 interface
160  * See https://github.com/ethereum/EIPs/issues/179
161  */
162 contract ERC20Basic {
163   function totalSupply() public view returns (uint256);
164   function balanceOf(address _who) public view returns (uint256);
165   function transfer(address _to, uint256 _value) public returns (bool);
166   event Transfer(address indexed from, address indexed to, uint256 value);
167 }
168 
169 // File: contracts/ZCDistribution.sol
170 
171 /**
172  * @title ZCDistribution
173  * 
174  * Used to distribute rewards to consumers
175  *
176  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
177  */
178 contract ZCDistribution is Claimable {
179 
180     // Total amount of airdrops that happend
181     uint256 public numDrops;
182     // Total amount of tokens dropped
183     uint256 public dropAmount;
184     // Address of the Token
185     address public tokenAddress;
186 
187     /**
188      * @param _tokenAddr The Address of the Token
189      */
190     constructor(address _tokenAddr) public {
191         assert(_tokenAddr != address(0));
192         tokenAddress = _tokenAddr;
193     }
194 
195     /**
196     * @dev Event when reward is distributed to consumer
197     * @param receiver Consumer address
198     * @param amount Amount of tokens distributed
199     */
200     event RewardDistributed(address receiver, uint amount);
201 
202     /**
203     * @dev Distributes the rewards to the consumers. Returns the amount of customers that received tokens. Can only be called by Owner
204     * @param dests Array of cosumer addresses
205     * @param values Array of token amounts to distribute to each client
206     */
207     function multisend(address[] dests, uint256[] values) public onlyOwner returns (uint256) {
208         assert(dests.length == values.length);
209         uint256 i = 0;
210         while (i < dests.length) {
211             assert(ERC20Basic(tokenAddress).transfer(dests[i], values[i]));
212             emit RewardDistributed(dests[i], values[i]);
213             dropAmount += values[i];
214             i += 1;
215         }
216         numDrops += dests.length;
217         return i;
218     }
219 
220     /**
221      * @dev Returns the Amount of tokens issued to consumers 
222      */
223     function getSentAmount() external view returns (uint256) {
224         return dropAmount;
225     }
226 }