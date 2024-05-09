1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 
22 
23 /**
24  * @title ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/20
26  */
27 contract ERC20 is ERC20Basic {
28   function allowance(address owner, address spender)
29     public view returns (uint256);
30 
31   function transferFrom(address from, address to, uint256 value)
32     public returns (bool);
33 
34   function approve(address spender, uint256 value) public returns (bool);
35   event Approval(
36     address indexed owner,
37     address indexed spender,
38     uint256 value
39   );
40 }
41 
42 
43 
44 /**
45  * @title SafeERC20
46  * @dev Wrappers around ERC20 operations that throw on failure.
47  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
48  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
49  */
50 library SafeERC20 {
51   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
52     require(token.transfer(to, value));
53   }
54 
55   function safeTransferFrom(
56     ERC20 token,
57     address from,
58     address to,
59     uint256 value
60   )
61     internal
62   {
63     require(token.transferFrom(from, to, value));
64   }
65 
66   function safeApprove(ERC20 token, address spender, uint256 value) internal {
67     require(token.approve(spender, value));
68   }
69 }
70 
71 
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipRenounced(address indexed previousOwner);
83   event OwnershipTransferred(
84     address indexed previousOwner,
85     address indexed newOwner
86   );
87 
88 
89   /**
90    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91    * account.
92    */
93   constructor() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * @dev Throws if called by any account other than the owner.
99    */
100   modifier onlyOwner() {
101     require(msg.sender == owner);
102     _;
103   }
104 
105   /**
106    * @dev Allows the current owner to relinquish control of the contract.
107    * @notice Renouncing to ownership will leave the contract without an owner.
108    * It will not be possible to call the functions with the `onlyOwner`
109    * modifier anymore.
110    */
111   function renounceOwnership() public onlyOwner {
112     emit OwnershipRenounced(owner);
113     owner = address(0);
114   }
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param _newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address _newOwner) public onlyOwner {
121     _transferOwnership(_newOwner);
122   }
123 
124   /**
125    * @dev Transfers control of the contract to a newOwner.
126    * @param _newOwner The address to transfer ownership to.
127    */
128   function _transferOwnership(address _newOwner) internal {
129     require(_newOwner != address(0));
130     emit OwnershipTransferred(owner, _newOwner);
131     owner = _newOwner;
132   }
133 }
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 /**
145  * @title SafeMath
146  * @dev Math operations with safety checks that throw on error
147  */
148 library SafeMath {
149 
150   /**
151   * @dev Multiplies two numbers, throws on overflow.
152   */
153   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
154     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
155     // benefit is lost if 'b' is also tested.
156     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
157     if (a == 0) {
158       return 0;
159     }
160 
161     c = a * b;
162     assert(c / a == b);
163     return c;
164   }
165 
166   /**
167   * @dev Integer division of two numbers, truncating the quotient.
168   */
169   function div(uint256 a, uint256 b) internal pure returns (uint256) {
170     // assert(b > 0); // Solidity automatically throws when dividing by 0
171     // uint256 c = a / b;
172     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173     return a / b;
174   }
175 
176   /**
177   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
178   */
179   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180     assert(b <= a);
181     return a - b;
182   }
183 
184   /**
185   * @dev Adds two numbers, throws on overflow.
186   */
187   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
188     c = a + b;
189     assert(c >= a);
190     return c;
191   }
192 }
193 
194 
195 contract Lockable is Ownable {
196 
197     bool public isLocked = false;
198 
199     event Locked();
200 
201     /**
202      * @dev Must be called after crowdsale ends, to do some extra finalization
203      * work. Calls the contract's finalization function.
204      */
205     function lock() onlyOwner public {
206         require(!isLocked);
207 
208         emit Locked();
209 
210         isLocked = true;
211     }
212 
213     modifier notLocked() {
214         require(!isLocked);
215         _;
216     }
217 }
218 
219 contract TokenTimelockVault is Ownable, Lockable {
220     using SafeMath for uint256;
221     using SafeERC20 for ERC20Basic;
222 
223     event Invested(address owner, uint balance);
224     event Released(uint256 amount);
225 
226     mapping(address => TimeEnvoy) internal owners;
227 
228     struct TimeEnvoy {
229         address owner;
230         uint releaseTime;
231         uint balance;
232         bool released;
233     }
234 
235     function addOwners(address[] _owners, uint[] _releaseTimes, uint[] _balances) public onlyOwner notLocked {
236         require(_owners.length > 0);
237         require(_owners.length == _releaseTimes.length);
238         require(_owners.length == _balances.length);
239         for (uint i = 0; i < _owners.length; i++) {
240             owners[_owners[i]] = TimeEnvoy({
241                 owner : _owners[i],
242                 releaseTime : _releaseTimes[i],
243                 balance : _balances[i],
244                 released : false});
245             emit Invested(_owners[i], _balances[i]);
246         }
247     }
248 
249     function addOwner(address _owner, uint _releaseTime, uint _balance) public onlyOwner notLocked {
250         owners[owner] = TimeEnvoy({
251             owner : _owner,
252             releaseTime : _releaseTime,
253             balance : _balance,
254             released : false});
255 
256         emit Invested(_owner, _balance);
257     }
258 
259     function release(ERC20Basic token, address _owner) public {
260         TimeEnvoy storage owner = owners[_owner];
261         require(!owner.released);
262 
263         uint256 unreleased = releasableAmount(_owner);
264 
265         require(unreleased > 0);
266 
267         owner.released = true;
268         token.safeTransfer(owner.owner, owner.balance);
269 
270         emit Released(unreleased);
271     }
272 
273     function releasableAmount(address _owner) public view returns (uint256){
274         if (_owner == address(0)) {
275             return 0;
276         }
277         TimeEnvoy storage owner = owners[_owner];
278         if (owner.released) {
279             return 0;
280         } else if (block.timestamp >= owner.releaseTime) {
281             return owner.balance;
282         } else {
283             return 0;
284         }
285     }
286 
287     function ownedBalance(address _owner) public view returns (uint256){
288         TimeEnvoy storage owner = owners[_owner];
289         return owner.balance;
290     }
291 }