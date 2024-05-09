1 pragma solidity ^0.4.24;
2 /**
3  * The Vediohead Token Contract
4  * by Vediohead dev team (June 2018)
5  * adapted from OpenZeppelin @ 1.10.0
6  */
7 
8 
9 /**
10  * -------- SafeMath start --------
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15   /**
16    * @dev Multiplies two numbers, throws on overflow.
17    */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
20     // benefit is lost if 'b' is also tested.
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31    * @dev Integer division of two numbers, truncating the quotient.
32    */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42    */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49    * @dev Adds two numbers, throws on overflow.
50    */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 /**
58  * -------- SafeMath end --------
59  */
60 
61 
62 /**
63  * -------- ERC20Basic start --------
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/179
67  */
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 /**
75  * -------- ERC20Basic end --------
76  */
77 
78 
79 /**
80  * -------- BasicToken start --------
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92    * @dev total number of tokens in existence
93    */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99    * @dev transfer token for a specified address
100    * @param _to The address to transfer to.
101    * @param _value The amount to be transferred.
102    */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Gets the balance of the specified address.
115    * @param _owner The address to query the the balance of.
116    * @return An uint256 representing the amount owned by the passed address.
117    */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 }
122 /**
123  * -------- BasicToken end --------
124  */
125 
126 
127 /**
128  * -------- Ownable start --------
129  * @title Ownable
130  * @dev The Ownable contract has an owner address, and provides basic authorization control
131  * functions, this simplifies the implementation of "user permissions".
132  */
133 contract Ownable {
134   address public owner;
135 
136   event OwnershipRenounced(address indexed previousOwner);
137   event OwnershipTransferred(
138     address indexed previousOwner,
139     address indexed newOwner
140   );
141 
142   /**
143    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
144    * account.
145    */
146   constructor() public {
147     owner = msg.sender;
148   }
149 
150   /**
151    * @dev Throws if called by any account other than the owner.
152    */
153   modifier onlyOwner() {
154     require(msg.sender == owner);
155     _;
156   }
157 
158   /**
159    * @dev Allows the current owner to relinquish control of the contract.
160    */
161   function renounceOwnership() public onlyOwner {
162     emit OwnershipRenounced(owner);
163     owner = address(0);
164   }
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param _newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address _newOwner) public onlyOwner {
171     _transferOwnership(_newOwner);
172   }
173 
174   /**
175    * @dev Transfers control of the contract to a newOwner.
176    * @param _newOwner The address to transfer ownership to.
177    */
178   function _transferOwnership(address _newOwner) internal {
179     require(_newOwner != address(0));
180     emit OwnershipTransferred(owner, _newOwner);
181     owner = _newOwner;
182   }
183 }
184 /**
185  * -------- Ownable end --------
186  */
187 
188 
189 /**
190  * -------- Pausable start --------
191  * @title Pausable
192  * @dev Base contract which allows children to implement an emergency stop mechanism.
193  */
194 contract Pausable is Ownable {
195   event Pause();
196   event Unpause();
197 
198   bool public paused = false;
199 
200   /**
201    * @dev Modifier to make a function callable only when the contract is not paused.
202    */
203   modifier whenNotPaused() {
204     require(!paused);
205     _;
206   }
207 
208   /**
209    * @dev Modifier to make a function callable only when the contract is paused.
210    */
211   modifier whenPaused() {
212     require(paused);
213     _;
214   }
215 
216   /**
217    * @dev called by the owner to pause, triggers stopped state
218    */
219   function pause() onlyOwner whenNotPaused public {
220     paused = true;
221     emit Pause();
222   }
223 
224   /**
225    * @dev called by the owner to unpause, returns to normal state
226    */
227   function unpause() onlyOwner whenPaused public {
228     paused = false;
229     emit Unpause();
230   }
231 }
232 /**
233  * -------- Pausable end --------
234  */
235 
236 
237 /**
238  * -------- Vediohead start --------
239  * @title Vediohead Token Contract
240  * @dev Base contract with a simple transfer function.
241  */
242 contract VedioheadToken is BasicToken, Pausable {
243   using SafeMath for uint256;
244 
245   string public constant name = "Vediohead Token";
246   string public constant symbol = "VED";
247   uint8 public constant decimals = 8;
248   string public version = "0.0.3";
249   uint256 public totalSupply_;
250 
251   /**
252    * Constructor
253    */
254   constructor() public {
255     totalSupply_ = 50000000000000000;
256 
257     balances[0x8aD676e9C6b62e64fe9FAA8e9aaa553F630E91d4] = totalSupply_;
258 
259     emit Transfer(address(0), 0x8aD676e9C6b62e64fe9FAA8e9aaa553F630E91d4, totalSupply_);
260   }
261 
262   /**
263    * @notice Total supply
264    */
265   function totalSupply() public constant returns (uint256) {
266     return totalSupply_ - balances[address(0)];
267   }
268 
269   /**
270    * @notice The transfer function
271    */
272   function transfer(address _to, uint256 tokens) whenNotPaused public returns (bool success) {
273     return super.transfer(_to, tokens);
274   }
275 }
276 /**
277  * -------- Vediohead end --------
278  */