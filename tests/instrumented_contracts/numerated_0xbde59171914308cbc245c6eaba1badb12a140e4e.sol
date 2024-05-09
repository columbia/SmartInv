1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
78     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (_a == 0) {
82       return 0;
83     }
84 
85     c = _a * _b;
86     assert(c / _a == _b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
94     // assert(_b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = _a / _b;
96     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
97     return _a / _b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
104     assert(_b <= _a);
105     return _a - _b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
112     c = _a + _b;
113     assert(c >= _a);
114     return c;
115   }
116 }
117 
118 
119 /**
120  * @title HtczExchange
121  * @dev Eth <-> HTCZ Exchange supporting contract
122  */
123 contract HtczExchange is Ownable {
124 
125     using SafeMath for uint256;
126 
127     // ** Events **
128 
129     // Deposit received -> sent to exchange to HTCZ token
130     event Deposit(address indexed sender, uint eth_amount, uint htcz_amount);
131 
132     // HTCZ token was sent in exchange for Ether
133     event Exchanged(address indexed receiver, uint indexed htcz_tx, uint htcz_amount, uint eth_amount);
134 
135     // HTCZ Reserve amount changed
136     event ReserveChanged(uint indexed htcz_tx, uint old_htcz_amount, uint new_htcz_amount);
137 
138     // Operator changed
139     event OperatorChanged(address indexed new_operator);
140 
141 
142     // ** Contract state **
143 
144     // HTCZ token (address is in ETZ network)
145     address public htcz_token;
146 
147     // Source of wallet for reserve (address is in ETZ network)
148     address public htcz_cold_wallet;
149 
150     // HTCZ wallet used to exchange (address is in ETZ network)
151     address public htcz_exchange_wallet;
152 
153     // Operator account of the exchange
154     address public operator;
155 
156     // HTCZ amount used for exchange, should not exceed htcz_reserve
157     uint public htcz_exchanged_amount;
158 
159     // HTCZ reserve for exchange
160     uint public htcz_reserve;
161 
162     // ETH -> HTCZ exchange rate
163     uint public exchange_rate;
164 
165     // gas spending on transfer function
166     uint constant GAS_FOR_TRANSFER = 49483;
167 
168     // ** Modifiers **
169 
170     // Throws if called by any account other than the operator.
171     modifier onlyOperator() {
172         require(msg.sender == operator);
173         _;
174     }
175 
176     constructor(    address _htcz_token,
177                     address _htcz_cold_wallet,
178                     address _htcz_exchange_wallet,
179                     address _operator,
180                     uint _exchange_rate ) public {
181 
182 	    require(_htcz_token != address(0));
183 	    require(_htcz_cold_wallet != address(0));
184 	    require(_htcz_exchange_wallet != address(0));
185 	    require(_operator != address(0));
186 	    require(_exchange_rate>0);
187 
188 	    htcz_token = _htcz_token;
189 	    htcz_cold_wallet = _htcz_cold_wallet;
190 	    htcz_exchange_wallet = _htcz_exchange_wallet;
191 	    exchange_rate = _exchange_rate;
192 	    operator = _operator;
193 
194     }
195 
196     /**
197     * @dev Accepts Ether.
198     * Throws is token balance is not available to issue HTCZ tokens
199     */
200     function() external payable {
201 
202         require( msg.value > 0 );
203 
204         uint eth_amount = msg.value;
205         uint htcz_amount = eth_amount.mul(exchange_rate);
206 
207         htcz_exchanged_amount = htcz_exchanged_amount.add(htcz_amount);
208 
209         require( htcz_reserve >= htcz_exchanged_amount );
210 
211         emit Deposit(msg.sender, eth_amount, htcz_amount);
212     }
213 
214     /**
215     * @dev Transfers ether by operator command in exchange to HTCZ tokens
216     * Calculates gas amount, gasprice and substracts that from the transfered amount.
217     * Note, that smart contracts are not allowed as the receiver.
218     */
219     function change(address _receiver, uint _htcz_tx, uint _htcz_amount) external onlyOperator {
220 
221         require(_receiver != address(0));
222 
223         uint gas_value = GAS_FOR_TRANSFER.mul(tx.gasprice);
224         uint eth_amount = _htcz_amount / exchange_rate;
225 
226         require(eth_amount > gas_value);
227 
228         eth_amount = eth_amount.sub(gas_value);
229 
230         require(htcz_exchanged_amount >= _htcz_amount );
231 
232         htcz_exchanged_amount = htcz_exchanged_amount.sub(_htcz_amount);
233 
234         msg.sender.transfer(gas_value);
235         _receiver.transfer(eth_amount);
236 
237         emit Exchanged(_receiver, _htcz_tx, _htcz_amount, eth_amount);
238 
239     }
240 
241     /**
242     * @dev Increase HTCZ reserve
243     */
244     function increaseReserve(uint _htcz_tx, uint _amount) external onlyOperator {
245 
246         uint old_htcz_reserve = htcz_reserve;
247         uint new_htcz_reserve = old_htcz_reserve.add(_amount);
248 
249         require( new_htcz_reserve > old_htcz_reserve);
250 
251         htcz_reserve = new_htcz_reserve;
252 
253         emit ReserveChanged(_htcz_tx, old_htcz_reserve, new_htcz_reserve);
254 
255     }
256 
257     /**
258     * @dev Decrease HTCZ reserve
259     */
260     function decreaseReserve(uint _htcz_tx, uint _amount) external onlyOperator {
261 
262         uint old_htcz_reserve = htcz_reserve;
263         uint new_htcz_reserve = old_htcz_reserve.sub(_amount);
264 
265         require( new_htcz_reserve < old_htcz_reserve);
266         require( new_htcz_reserve >= htcz_exchanged_amount );
267 
268         htcz_reserve = new_htcz_reserve;
269 
270         emit ReserveChanged(_htcz_tx, old_htcz_reserve, new_htcz_reserve);
271 
272     }
273 
274 
275     /**
276     * @dev Set other operator ( 0 allowed )
277     */
278     function changeOperator(address _operator) external onlyOwner {
279         require(_operator != operator);
280         operator = _operator;
281         emit OperatorChanged(_operator);
282     }
283 
284 
285 }