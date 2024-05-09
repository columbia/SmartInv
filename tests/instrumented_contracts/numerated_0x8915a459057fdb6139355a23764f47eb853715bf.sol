1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
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
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 
78 
79 
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers, truncating the quotient.
105   */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     // uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return a / b;
111   }
112 
113   /**
114   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115   */
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   /**
122   * @dev Adds two numbers, throws on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
125     c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }
130 
131 
132 
133 
134 
135 
136 
137 
138 /**
139  * @title Pausable
140  * @dev Base contract which allows children to implement an emergency stop mechanism.
141  */
142 contract Pausable is Ownable {
143   event Pause();
144   event Unpause();
145 
146   bool public paused = false;
147 
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is not paused.
151    */
152   modifier whenNotPaused() {
153     require(!paused);
154     _;
155   }
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is paused.
159    */
160   modifier whenPaused() {
161     require(paused);
162     _;
163   }
164 
165   /**
166    * @dev called by the owner to pause, triggers stopped state
167    */
168   function pause() onlyOwner whenNotPaused public {
169     paused = true;
170     emit Pause();
171   }
172 
173   /**
174    * @dev called by the owner to unpause, returns to normal state
175    */
176   function unpause() onlyOwner whenPaused public {
177     paused = false;
178     emit Unpause();
179   }
180 }
181 
182 
183 
184 
185 
186 
187 /**
188  * @title ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/20
190  */
191 contract ERC20 is ERC20Basic {
192   function allowance(address owner, address spender)
193     public view returns (uint256);
194 
195   function transferFrom(address from, address to, uint256 value)
196     public returns (bool);
197 
198   function approve(address spender, uint256 value) public returns (bool);
199   event Approval(
200     address indexed owner,
201     address indexed spender,
202     uint256 value
203   );
204 }
205 
206 
207 
208 contract BntyControllerInterface {
209     function destroyTokensInBntyTokenContract(address _owner, uint _amount) public returns (bool);
210 }
211 
212 
213 
214 
215 contract Bounty0xStaking is Ownable, Pausable {
216 
217     using SafeMath for uint256;
218 
219     address public Bounty0xToken;
220 
221     mapping (address => uint) public balances;
222     mapping (uint => mapping (address => uint)) public stakes; // mapping of submission ids to mapping of addresses that staked an amount of bounty token 
223 
224 
225     event Deposit(address indexed depositor, uint amount, uint balance);
226     event Withdraw(address indexed depositor, uint amount, uint balance);
227 
228     event Stake(uint indexed submissionId, address hunter, uint amount);
229     event StakeReleased(uint indexed submissionId, address from, address to, uint amount);
230 
231 
232     constructor(address _bounty0xToken) public {
233         Bounty0xToken = _bounty0xToken;
234     }
235 
236 
237     function deposit(uint _amount) public whenNotPaused {
238         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
239         require(ERC20(Bounty0xToken).transferFrom(msg.sender, this, _amount));
240         balances[msg.sender] = SafeMath.add(balances[msg.sender], _amount);
241 
242         emit Deposit(msg.sender, _amount, balances[msg.sender]);
243     }
244 
245     function withdraw(uint _amount) public whenNotPaused {
246         require(balances[msg.sender] >= _amount);
247         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
248         require(ERC20(Bounty0xToken).transfer(msg.sender, _amount));
249         
250         emit Withdraw(msg.sender, _amount, balances[msg.sender]);
251     }
252 
253 
254     function stake(uint _submissionId, uint _amount) public whenNotPaused {
255         require(balances[msg.sender] >= _amount);
256         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
257         stakes[_submissionId][msg.sender] = SafeMath.add(stakes[_submissionId][msg.sender], _amount);
258 
259         emit Stake(_submissionId, msg.sender, _amount);
260     }
261 
262     function stakeToMany(uint[] _submissionIds, uint[] _amounts) public whenNotPaused {
263         uint totalAmount = 0;
264         for (uint j = 0; j < _amounts.length; j++) {
265             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
266         }
267         require(balances[msg.sender] >= totalAmount);
268         balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
269 
270         for (uint i = 0; i < _submissionIds.length; i++) {
271             stakes[_submissionIds[i]][msg.sender] = SafeMath.add(stakes[_submissionIds[i]][msg.sender], _amounts[i]);
272 
273             emit Stake(_submissionIds[i], msg.sender, _amounts[i]);
274         }
275     }
276     
277 
278     function releaseStake(uint _submissionId, address _from, address _to, uint _amount) public onlyOwner {
279         require(stakes[_submissionId][_from] >= _amount);
280 
281         stakes[_submissionId][_from] = SafeMath.sub(stakes[_submissionId][_from], _amount);
282         balances[_to] = SafeMath.add(balances[_to], _amount);
283 
284         emit StakeReleased(_submissionId, _from, _to, _amount);
285     }
286 
287     function releaseManyStakes(uint[] _submissionIds, address[] _from, address[] _to, uint[] _amounts) public onlyOwner {
288         require(_submissionIds.length == _from.length &&
289                 _submissionIds.length == _to.length &&
290                 _submissionIds.length == _amounts.length);
291 
292         for (uint i = 0; i < _submissionIds.length; i++) {
293             require(stakes[_submissionIds[i]][_from[i]] >= _amounts[i]);
294             stakes[_submissionIds[i]][_from[i]] = SafeMath.sub(stakes[_submissionIds[i]][_from[i]], _amounts[i]);
295             balances[_to[i]] = SafeMath.add(balances[_to[i]], _amounts[i]);
296 
297             emit StakeReleased(_submissionIds[i], _from[i], _to[i], _amounts[i]);
298         }
299     }
300 
301 
302     // Burnable mechanism
303     
304     address public bntyController;
305     
306     event Burn(uint indexed submissionId, address from, uint amount);
307     
308     function changeBntyController(address _bntyController) onlyOwner public {
309         bntyController = _bntyController;
310     }
311     
312     
313     function burnStake(uint _submissionId, address _from) public onlyOwner {
314         require(stakes[_submissionId][_from] > 0);
315         
316         uint amountToBurn = stakes[_submissionId][_from];
317         stakes[_submissionId][_from] = 0;
318         
319         require(BntyControllerInterface(bntyController).destroyTokensInBntyTokenContract(this, amountToBurn));
320         emit Burn(_submissionId, _from, amountToBurn);
321     }
322     
323 }