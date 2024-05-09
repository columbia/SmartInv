1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
121 
122 /**
123  * @title SafeERC20
124  * @dev Wrappers around ERC20 operations that throw on failure.
125  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
126  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
127  */
128 library SafeERC20 {
129   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
130     assert(token.transfer(to, value));
131   }
132 
133   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
134     assert(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(ERC20 token, address spender, uint256 value) internal {
138     assert(token.approve(spender, value));
139   }
140 }
141 
142 // File: zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
143 
144 /**
145  * @title TokenVesting
146  * @dev A token holder contract that can release its token balance gradually like a
147  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
148  * owner.
149  */
150 contract TokenVesting is Ownable {
151   using SafeMath for uint256;
152   using SafeERC20 for ERC20Basic;
153 
154   event Released(uint256 amount);
155   event Revoked();
156 
157   // beneficiary of tokens after they are released
158   address public beneficiary;
159 
160   uint256 public cliff;
161   uint256 public start;
162   uint256 public duration;
163 
164   bool public revocable;
165 
166   mapping (address => uint256) public released;
167   mapping (address => bool) public revoked;
168 
169   /**
170    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
171    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
172    * of the balance will have vested.
173    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
174    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
175    * @param _duration duration in seconds of the period in which the tokens will vest
176    * @param _revocable whether the vesting is revocable or not
177    */
178   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
179     require(_beneficiary != address(0));
180     require(_cliff <= _duration);
181 
182     beneficiary = _beneficiary;
183     revocable = _revocable;
184     duration = _duration;
185     cliff = _start.add(_cliff);
186     start = _start;
187   }
188 
189   /**
190    * @notice Transfers vested tokens to beneficiary.
191    * @param token ERC20 token which is being vested
192    */
193   function release(ERC20Basic token) public {
194     uint256 unreleased = releasableAmount(token);
195 
196     require(unreleased > 0);
197 
198     released[token] = released[token].add(unreleased);
199 
200     token.safeTransfer(beneficiary, unreleased);
201 
202     Released(unreleased);
203   }
204 
205   /**
206    * @notice Allows the owner to revoke the vesting. Tokens already vested
207    * remain in the contract, the rest are returned to the owner.
208    * @param token ERC20 token which is being vested
209    */
210   function revoke(ERC20Basic token) public onlyOwner {
211     require(revocable);
212     require(!revoked[token]);
213 
214     uint256 balance = token.balanceOf(this);
215 
216     uint256 unreleased = releasableAmount(token);
217     uint256 refund = balance.sub(unreleased);
218 
219     revoked[token] = true;
220 
221     token.safeTransfer(owner, refund);
222 
223     Revoked();
224   }
225 
226   /**
227    * @dev Calculates the amount that has already vested but hasn't been released yet.
228    * @param token ERC20 token which is being vested
229    */
230   function releasableAmount(ERC20Basic token) public view returns (uint256) {
231     return vestedAmount(token).sub(released[token]);
232   }
233 
234   /**
235    * @dev Calculates the amount that has already vested.
236    * @param token ERC20 token which is being vested
237    */
238   function vestedAmount(ERC20Basic token) public view returns (uint256) {
239     uint256 currentBalance = token.balanceOf(this);
240     uint256 totalBalance = currentBalance.add(released[token]);
241 
242     if (now < cliff) {
243       return 0;
244     } else if (now >= start.add(duration) || revoked[token]) {
245       return totalBalance;
246     } else {
247       return totalBalance.mul(now.sub(start)).div(duration);
248     }
249   }
250 }