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
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
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
88   function allowance(address owner, address spender)
89     public view returns (uint256);
90 
91   function transferFrom(address from, address to, uint256 value)
92     public returns (bool);
93 
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(
96     address indexed owner,
97     address indexed spender,
98     uint256 value
99   );
100 }
101 
102 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
103 
104 /**
105  * @title SafeERC20
106  * @dev Wrappers around ERC20 operations that throw on failure.
107  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
108  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
109  */
110 library SafeERC20 {
111   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
112     require(token.transfer(to, value));
113   }
114 
115   function safeTransferFrom(
116     ERC20 token,
117     address from,
118     address to,
119     uint256 value
120   )
121     internal
122   {
123     require(token.transferFrom(from, to, value));
124   }
125 
126   function safeApprove(ERC20 token, address spender, uint256 value) internal {
127     require(token.approve(spender, value));
128   }
129 }
130 
131 // File: contracts/TokenRecoverable.sol
132 
133 contract TokenRecoverable is Ownable {
134     using SafeERC20 for ERC20Basic;
135 
136     function recoverTokens(ERC20Basic token, address to, uint256 amount) public onlyOwner {
137         uint256 balance = token.balanceOf(address(this));
138         require(balance >= amount);
139         token.safeTransfer(to, amount);
140     }
141 }
142 
143 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
144 
145 /**
146  * @title SafeMath
147  * @dev Math operations with safety checks that throw on error
148  */
149 library SafeMath {
150 
151   /**
152   * @dev Multiplies two numbers, throws on overflow.
153   */
154   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
155     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
156     // benefit is lost if 'b' is also tested.
157     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
158     if (a == 0) {
159       return 0;
160     }
161 
162     c = a * b;
163     assert(c / a == b);
164     return c;
165   }
166 
167   /**
168   * @dev Integer division of two numbers, truncating the quotient.
169   */
170   function div(uint256 a, uint256 b) internal pure returns (uint256) {
171     // assert(b > 0); // Solidity automatically throws when dividing by 0
172     // uint256 c = a / b;
173     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174     return a / b;
175   }
176 
177   /**
178   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
179   */
180   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
181     assert(b <= a);
182     return a - b;
183   }
184 
185   /**
186   * @dev Adds two numbers, throws on overflow.
187   */
188   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
189     c = a + b;
190     assert(c >= a);
191     return c;
192   }
193 }
194 
195 
196 contract OrcaCrowdsale {
197     using SafeMath for uint256;
198 
199     mapping(address => uint256) public bountyBalances;
200 
201     function claimBounty(address beneficiary) public;
202 }
203 
204 // File: contracts/OrcaBounties.sol
205 
206 contract OrcaBounties is TokenRecoverable {
207 
208     OrcaCrowdsale public crowdsale;
209 
210     constructor(address _crowdsale) public {
211         require(_crowdsale != address(0));
212         crowdsale = OrcaCrowdsale(_crowdsale);
213     }
214 
215     function () public payable {
216         crowdsale.claimBounty(msg.sender);
217 
218         if (msg.value > 0) {
219             msg.sender.transfer(msg.value);
220         }
221     }
222 
223     function bountyOf(address beneficiary) public view returns (uint256) {
224         return crowdsale.bountyBalances(beneficiary);
225     }
226 }