1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66     if (newOwner != address(0)) {
67       owner = newOwner;
68     }
69   }
70 
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant returns (uint256);
81   function transfer(address to, uint256 value) returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) returns (bool);
92   function approve(address spender, uint256 value) returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances. 
99  */
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) returns (bool) {
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of. 
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) constant returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amout of tokens to be transfered
145    */
146   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
147     var _allowance = allowed[_from][msg.sender];
148 
149     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
150     // require (_value <= _allowance);
151 
152     balances[_to] = balances[_to].add(_value);
153     balances[_from] = balances[_from].sub(_value);
154     allowed[_from][msg.sender] = _allowance.sub(_value);
155     Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) returns (bool) {
165 
166     // To change the approve amount you first have to reduce the addresses`
167     //  allowance to zero by calling `approve(_spender, 0)` if it is not
168     //  already 0 to mitigate the race condition described here:
169     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
171 
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifing the amount of tokens still avaible for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
184     return allowed[_owner][_spender];
185   }
186 
187 }
188 
189 contract Auction is Ownable {
190   using SafeMath for uint256;
191   enum States { Setup, AcceptingBids, Paused, Ended }
192   
193   // Current state of the auction which starts at Setup.
194   States public currentState = States.Setup;
195 
196   // Current highest bid data
197   address public highestBidder;
198   uint256 public highestBid;
199 
200   // Allowed withdrawals of previous bids
201   mapping(address => uint256) pendingReturns;
202 
203   // Events that will be fired on changes
204   event HighestBidIncreased(address bidder, uint256 amount);
205   event AuctionStarted();
206   event AuctionPaused();
207   event AuctionResumed();
208   event AuctionEnded(address winner, uint256 amount);
209 
210   modifier atState(States state) {
211     require(currentState == state);
212     _;
213   }
214 
215   modifier notAtState(States state) {
216     require(currentState != state);
217     _;
218   }
219 
220   /// Bid on the auction with the value sent with this transaction.
221   /// The value will only be refunded if the auction is not won.
222   function bid() payable atState(States.AcceptingBids) {
223     require(msg.value > highestBid);
224 
225     if (highestBid != 0) {
226       pendingReturns[highestBidder] = pendingReturns[highestBidder].add(highestBid);
227     }
228 
229     highestBidder = msg.sender;
230     highestBid = msg.value;
231     HighestBidIncreased(msg.sender, msg.value);
232   }
233 
234   /// Withdraw a bid that was overbid.
235   function withdraw() notAtState(States.Setup) returns (bool) {
236     uint256 amount = pendingReturns[msg.sender];
237     if (amount > 0) {
238       pendingReturns[msg.sender] = 0;
239       if (!msg.sender.send(amount)) {
240         pendingReturns[msg.sender] = amount;
241         return false;
242       }
243     }
244     return true;
245   }
246 
247   /// Start the auction and allow bidding.
248   function startAuction() onlyOwner atState(States.Setup) {
249     currentState = States.AcceptingBids;
250     AuctionStarted();
251   }
252 
253   /// Pause the auction and temporarily disable bidding.
254   function pauseAuction() onlyOwner atState(States.AcceptingBids) {
255     currentState = States.Paused;
256     AuctionPaused();
257   }
258 
259   /// Resume the auction and allow bidding once again.
260   function resumeAuction() onlyOwner atState(States.Paused) {
261     currentState = States.AcceptingBids;
262     AuctionResumed();
263   }
264 
265   /// End the auction and send the highest bid to the owner
266   function endAuction() onlyOwner notAtState(States.Ended) {
267     currentState = States.Ended;
268     AuctionEnded(highestBidder, highestBid);
269     owner.transfer(highestBid);
270   }
271 }
272 
273 contract TulipToken is Auction, StandardToken {
274     string public constant name = "TulipToken";
275     string public constant symbol = "TLP";
276     uint8 public constant decimals = 0;
277 
278     uint256 public constant INITIAL_SUPPLY = 1;
279 
280     function TulipToken() {
281       totalSupply = INITIAL_SUPPLY;
282       balances[owner] = INITIAL_SUPPLY;
283     }
284 
285     /// Override Auction.endAuction to transfer
286     /// The Tulip Token in the same transaction. 
287     function endAuction() {
288       transfer(highestBidder, 1);
289       Auction.endAuction();
290     }
291 }