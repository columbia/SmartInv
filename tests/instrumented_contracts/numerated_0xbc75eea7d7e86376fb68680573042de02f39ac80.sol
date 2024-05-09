1 pragma solidity 0.4.24;
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
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
142 // File: contracts/VestTokenAllocation.sol
143 
144 /**
145  * @title VestTokenAllocation contract
146  * @author Gustavo Guimaraes - <gustavoguimaraes@gmail.com>
147  */
148 contract VestTokenAllocation is Ownable {
149     using SafeMath for uint256;
150     using SafeERC20 for ERC20;
151 
152     uint256 public cliff;
153     uint256 public start;
154     uint256 public duration;
155     uint256 public allocatedTokens;
156     uint256 public canSelfDestruct;
157 
158     mapping (address => uint256) public totalTokensLocked;
159     mapping (address => uint256) public releasedTokens;
160 
161     ERC20 public golix;
162     address public tokenDistribution;
163 
164     event Released(address beneficiary, uint256 amount);
165 
166     /**
167      * @dev creates the locking contract with vesting mechanism
168      * as well as ability to set tokens for addresses and time contract can self-destruct
169      * @param _token GolixToken address
170      * @param _tokenDistribution GolixTokenDistribution contract address
171      * @param _start timestamp representing the beginning of the token vesting process
172      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest. ie 1 year in secs
173      * @param _duration time in seconds of the period in which the tokens completely vest. ie 4 years in secs
174      * @param _canSelfDestruct timestamp of when contract is able to selfdestruct
175      */
176     function VestTokenAllocation
177         (
178             ERC20 _token,
179             address _tokenDistribution,
180             uint256 _start,
181             uint256 _cliff,
182             uint256 _duration,
183             uint256 _canSelfDestruct
184         )
185         public
186     {
187         require(_token != address(0) && _cliff != 0);
188         require(_cliff <= _duration);
189         require(_start > now);
190         require(_canSelfDestruct > _duration.add(_start));
191 
192         duration = _duration;
193         cliff = _start.add(_cliff);
194         start = _start;
195 
196         golix = ERC20(_token);
197         tokenDistribution = _tokenDistribution;
198         canSelfDestruct = _canSelfDestruct;
199     }
200 
201     modifier onlyOwnerOrTokenDistributionContract() {
202         require(msg.sender == address(owner) || msg.sender == address(tokenDistribution));
203         _;
204     }
205     /**
206      * @dev Adds vested token allocation
207      * @param beneficiary Ethereum address of a person
208      * @param allocationValue Number of tokens allocated to person
209      */
210     function addVestTokenAllocation(address beneficiary, uint256 allocationValue)
211         external
212         onlyOwnerOrTokenDistributionContract
213     {
214         require(totalTokensLocked[beneficiary] == 0 && beneficiary != address(0)); // can only add once.
215 
216         allocatedTokens = allocatedTokens.add(allocationValue);
217         require(allocatedTokens <= golix.balanceOf(this));
218 
219         totalTokensLocked[beneficiary] = allocationValue;
220     }
221 
222     /**
223      * @notice Transfers vested tokens to beneficiary.
224      */
225     function release() public {
226         uint256 unreleased = releasableAmount();
227 
228         require(unreleased > 0);
229 
230         releasedTokens[msg.sender] = releasedTokens[msg.sender].add(unreleased);
231 
232         golix.safeTransfer(msg.sender, unreleased);
233 
234         emit Released(msg.sender, unreleased);
235     }
236 
237     /**
238      * @dev Calculates the amount that has already vested but hasn't been released yet.
239      */
240     function releasableAmount() public view returns (uint256) {
241         return vestedAmount().sub(releasedTokens[msg.sender]);
242     }
243 
244     /**
245      * @dev Calculates the amount that has already vested.
246      */
247     function vestedAmount() public view returns (uint256) {
248         uint256 totalBalance = totalTokensLocked[msg.sender];
249 
250         if (now < cliff) {
251             return 0;
252         } else if (now >= start.add(duration)) {
253             return totalBalance;
254         } else {
255             return totalBalance.mul(now.sub(start)).div(duration);
256         }
257     }
258 
259     /**
260      * @dev allow for selfdestruct possibility and sending funds to owner
261      */
262     function kill() public onlyOwner {
263         require(now >= canSelfDestruct);
264         uint256 balance = golix.balanceOf(this);
265 
266         if (balance > 0) {
267             golix.transfer(msg.sender, balance);
268         }
269 
270         selfdestruct(owner);
271     }
272 }