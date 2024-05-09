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
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * See https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address _who) public view returns (uint256);
126   function transfer(address _to, uint256 _value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address _owner, address _spender)
137     public view returns (uint256);
138 
139   function transferFrom(address _from, address _to, uint256 _value)
140     public returns (bool);
141 
142   function approve(address _spender, uint256 _value) public returns (bool);
143   event Approval(
144     address indexed owner,
145     address indexed spender,
146     uint256 value
147   );
148 }
149 
150 
151 /**
152  * @title VeloxCrowdsale
153  * @dev VeloxToken ERC20 token crowdsale contract
154  */
155 contract VeloxCrowdsale is Ownable {
156     using SafeMath for uint256;
157 
158     // The token being sold
159     ERC20 public token;
160 
161     // Crowdsale start and end timestamps
162     uint256 public startTime;
163     uint256 public endTime;
164 
165     // Price per smallest token unit in wei
166     uint256 public rate;
167 
168     // Crowdsale cap in tokens
169     uint256 public cap;
170 
171     // Address where ETH and unsold tokens are collected
172     address public wallet;
173 
174     // Amount of tokens sold
175     uint256 public sold;
176 
177     /**
178      * @dev Constructor to set instance variables
179      */
180     constructor(
181         uint256 _startTime,
182         uint256 _endTime,
183         uint256 _rate,
184         uint256 _cap,
185         address _wallet,
186         ERC20 _token
187     ) public {
188         require(_startTime >= block.timestamp && _endTime >= _startTime);
189         require(_rate > 0);
190         require(_cap > 0);
191         require(_wallet != address(0));
192         require(_token != address(0));
193 
194         startTime = _startTime;
195         endTime = _endTime;
196         rate = _rate;
197         cap = _cap;
198         wallet = _wallet;
199         token = _token;
200     }
201 
202     /**
203      * @dev Event for token purchase logging
204      * @param purchaser who paid for the tokens
205      * @param beneficiary who got the tokens
206      * @param value weis paid for purchase
207      * @param amount amount of tokens purchased
208      */
209     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
210 
211     /**
212     * @dev Fallback token purchase function
213     */
214     function () external payable {
215         buyTokens(msg.sender);
216     }
217 
218     /**
219      * @dev Token purchase function
220      * @param _beneficiary Address receiving the purchased tokens
221      */
222     function buyTokens(address _beneficiary) public payable {
223         uint256 weiAmount = msg.value;
224         require(_beneficiary != address(0));
225         require(weiAmount != 0);
226         require(block.timestamp >= startTime && block.timestamp <= endTime);
227         uint256 tokens = weiAmount.div(rate);
228         require(tokens != 0 && sold.add(tokens) <= cap);
229         sold = sold.add(tokens);
230         require(token.transfer(_beneficiary, tokens));
231         emit TokenPurchase(
232             msg.sender,
233             _beneficiary,
234             weiAmount,
235             tokens
236         );
237     }
238 
239     /**
240     * @dev Checks whether the cap has been reached.
241     * @return Whether the cap was reached
242     */
243     function capReached() public view returns (bool) {
244         return sold >= cap;
245     }
246 
247     /**
248      * @dev Boolean to protect from replaying the finalization function
249      */
250     bool public isFinalized = false;
251 
252     /**
253      * @dev Event for crowdsale finalization (forwarding)
254      */
255     event Finalized();
256 
257     /**
258      * @dev Must be called after crowdsale ends to forward all funds
259      */
260     function finalize() external onlyOwner {
261         require(!isFinalized);
262         require(block.timestamp > endTime || sold >= cap);
263         token.transfer(wallet, token.balanceOf(this));
264         wallet.transfer(address(this).balance);
265         emit Finalized();
266         isFinalized = true;
267     }
268 
269     /**
270      * @dev Function for owner to forward ETH from contract
271      */
272     function forwardFunds() external onlyOwner {
273         require(!isFinalized);
274         require(block.timestamp > startTime);
275         uint256 balance = address(this).balance;
276         require(balance > 0);
277         wallet.transfer(balance);
278     }
279 }