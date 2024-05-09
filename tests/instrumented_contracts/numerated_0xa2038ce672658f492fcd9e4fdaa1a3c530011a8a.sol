1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 /**
106  * @title HolderBase
107  * @notice HolderBase handles data & funcitons for token or ether holders.
108  * HolderBase contract can distribute only one of ether or token.
109  */
110 contract HolderBase is Ownable {
111   using SafeMath for uint256;
112 
113   uint8 public constant MAX_HOLDERS = 64; // TODO: tokyo-input should verify # of holders
114   uint256 public coeff;
115   bool public distributed;
116   bool public initialized;
117 
118   struct Holder {
119     address addr;
120     uint96 ratio;
121   }
122 
123   Holder[] public holders;
124 
125   event Distributed();
126 
127   function HolderBase(uint256 _coeff) public {
128     require(_coeff != 0);
129     coeff = _coeff;
130   }
131 
132   function getHolderCount() public view returns (uint256) {
133     return holders.length;
134   }
135 
136   function initHolders(address[] _addrs, uint96[] _ratios) public onlyOwner {
137     require(!initialized);
138     require(holders.length == 0);
139     require(_addrs.length != 0);
140     require(_addrs.length <= MAX_HOLDERS);
141     require(_addrs.length == _ratios.length);
142 
143     uint256 accRatio;
144 
145     for(uint8 i = 0; i < _addrs.length; i++) {
146       if (_addrs[i] != address(0)) {
147         // address will be 0x00 in case of "crowdsale".
148         holders.push(Holder(_addrs[i], _ratios[i]));
149       }
150 
151       accRatio = accRatio.add(uint256(_ratios[i]));
152     }
153 
154     require(accRatio <= coeff);
155 
156     initialized = true;
157   }
158 
159   /**
160    * @dev Distribute ether to `holder`s according to ratio.
161    * Remaining ether is transfered to `wallet` from the close
162    * function of RefundVault contract.
163    */
164   function distribute() internal {
165     require(!distributed, "Already distributed");
166     uint256 balance = this.balance;
167 
168     require(balance > 0, "No ether to distribute");
169     distributed = true;
170 
171     for (uint8 i = 0; i < holders.length; i++) {
172       uint256 holderAmount = balance.mul(uint256(holders[i].ratio)).div(coeff);
173 
174       holders[i].addr.transfer(holderAmount);
175     }
176 
177     emit Distributed(); // A single log to reduce gas
178   }
179 
180   /**
181    * @dev Distribute ERC20 token to `holder`s according to ratio.
182    */
183   function distributeToken(ERC20Basic _token, uint256 _targetTotalSupply) internal {
184     require(!distributed, "Already distributed");
185     distributed = true;
186 
187     for (uint8 i = 0; i < holders.length; i++) {
188       uint256 holderAmount = _targetTotalSupply.mul(uint256(holders[i].ratio)).div(coeff);
189       deliverTokens(_token, holders[i].addr, holderAmount);
190     }
191 
192     emit Distributed(); // A single log to reduce gas
193   }
194 
195   // Override to distribute tokens
196   function deliverTokens(ERC20Basic _token, address _beneficiary, uint256 _tokens) internal {}
197 }
198 
199 
200 /**
201  * @title RefundVault
202  * @dev This contract is used for storing funds while a crowdsale
203  * is in progress. Supports refunding the money if crowdsale fails,
204  * and forwarding it if crowdsale is successful.
205  */
206 contract RefundVault is Ownable {
207   using SafeMath for uint256;
208 
209   enum State { Active, Refunding, Closed }
210 
211   mapping (address => uint256) public deposited;
212   address public wallet;
213   State public state;
214 
215   event Closed();
216   event RefundsEnabled();
217   event Refunded(address indexed beneficiary, uint256 weiAmount);
218 
219   /**
220    * @param _wallet Vault address
221    */
222   function RefundVault(address _wallet) public {
223     require(_wallet != address(0));
224     wallet = _wallet;
225     state = State.Active;
226   }
227 
228   /**
229    * @param investor Investor address
230    */
231   function deposit(address investor) onlyOwner public payable {
232     require(state == State.Active);
233     deposited[investor] = deposited[investor].add(msg.value);
234   }
235 
236   function close() onlyOwner public {
237     require(state == State.Active);
238     state = State.Closed;
239     emit Closed();
240     wallet.transfer(address(this).balance);
241   }
242 
243   function enableRefunds() onlyOwner public {
244     require(state == State.Active);
245     state = State.Refunding;
246     emit RefundsEnabled();
247   }
248 
249   /**
250    * @param investor Investor address
251    */
252   function refund(address investor) public {
253     require(state == State.Refunding);
254     uint256 depositedValue = deposited[investor];
255     deposited[investor] = 0;
256     investor.transfer(depositedValue);
257     emit Refunded(investor, depositedValue);
258   }
259 }
260 
261 
262 /**
263  * @title MultiHolderVault
264  * @dev This contract distribute ether to multiple address.
265  */
266 contract MultiHolderVault is HolderBase, RefundVault {
267   using SafeMath for uint256;
268 
269   function MultiHolderVault(address _wallet, uint256 _ratioCoeff)
270     public
271     HolderBase(_ratioCoeff)
272     RefundVault(_wallet)
273   {}
274 
275   function close() public onlyOwner {
276     require(state == State.Active);
277     require(initialized);
278 
279     super.distribute(); // distribute ether to holders
280     super.close(); // transfer remaining ether to wallet
281   }
282 }