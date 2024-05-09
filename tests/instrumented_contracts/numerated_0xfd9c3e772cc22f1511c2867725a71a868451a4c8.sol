1 pragma solidity ^0.4.21;
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
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Whitelist
46  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
47  * @dev This simplifies the implementation of "user permissions".
48  */
49 contract Whitelist is Ownable {
50   mapping(address => bool) public whitelist;
51 
52   event WhitelistedAddressAdded(address addr);
53   event WhitelistedAddressRemoved(address addr);
54 
55   /**
56    * @dev Throws if called by any account that's not whitelisted.
57    */
58   modifier onlyWhitelisted() {
59     require(whitelist[msg.sender]);
60     _;
61   }
62 
63   /**
64    * @dev add an address to the whitelist
65    * @param addr address
66    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
67    */
68   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
69     if (!whitelist[addr]) {
70       whitelist[addr] = true;
71       emit WhitelistedAddressAdded(addr);
72       success = true;
73     }
74   }
75 
76   /**
77    * @dev add addresses to the whitelist
78    * @param addrs addresses
79    * @return true if at least one address was added to the whitelist,
80    * false if all addresses were already in the whitelist
81    */
82   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
83     for (uint256 i = 0; i < addrs.length; i++) {
84       if (addAddressToWhitelist(addrs[i])) {
85         success = true;
86       }
87     }
88   }
89 
90   /**
91    * @dev remove an address from the whitelist
92    * @param addr address
93    * @return true if the address was removed from the whitelist,
94    * false if the address wasn't in the whitelist in the first place
95    */
96   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
97     if (whitelist[addr]) {
98       whitelist[addr] = false;
99       emit WhitelistedAddressRemoved(addr);
100       success = true;
101     }
102   }
103 
104   /**
105    * @dev remove addresses from the whitelist
106    * @param addrs addresses
107    * @return true if at least one address was removed from the whitelist,
108    * false if all addresses weren't in the whitelist in the first place
109    */
110   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
111     for (uint256 i = 0; i < addrs.length; i++) {
112       if (removeAddressFromWhitelist(addrs[i])) {
113         success = true;
114       }
115     }
116   }
117 
118 }
119 
120 
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126   event Pause();
127   event Unpause();
128 
129   bool public paused = false;
130 
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is not paused.
134    */
135   modifier whenNotPaused() {
136     require(!paused);
137     _;
138   }
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is paused.
142    */
143   modifier whenPaused() {
144     require(paused);
145     _;
146   }
147 
148   /**
149    * @dev called by the owner to pause, triggers stopped state
150    */
151   function pause() onlyOwner whenNotPaused public {
152     paused = true;
153     emit Pause();
154   }
155 
156   /**
157    * @dev called by the owner to unpause, returns to normal state
158    */
159   function unpause() onlyOwner whenPaused public {
160     paused = false;
161     emit Unpause();
162   }
163 }
164 
165 contract BuyLimits {
166     event LogLimitsChanged(uint _minBuy, uint _maxBuy);
167 
168     // Variables holding the min and max payment in wei
169     uint public minBuy; // min buy in wei
170     uint public maxBuy; // max buy in wei, 0 means no maximum
171 
172     /*
173     ** Modifier, reverting if not within limits.
174     */
175     modifier isWithinLimits(uint _amount) {
176         require(withinLimits(_amount));
177         _;
178     }
179 
180     /*
181     ** @dev Constructor, define variable:
182     */
183     function BuyLimits(uint _min, uint  _max) public {
184         _setLimits(_min, _max);
185     }
186 
187     /*
188     ** @dev Check TXs value is within limits:
189     */
190     function withinLimits(uint _value) public view returns(bool) {
191         if (maxBuy != 0) {
192             return (_value >= minBuy && _value <= maxBuy);
193         }
194         return (_value >= minBuy);
195     }
196 
197     /*
198     ** @dev set limits logic:
199     ** @param _min set the minimum buy in wei
200     ** @param _max set the maximum buy in wei, 0 indeicates no maximum
201     */
202     function _setLimits(uint _min, uint _max) internal {
203         if (_max != 0) {
204             require (_min <= _max); // Sanity Check
205         }
206         minBuy = _min;
207         maxBuy = _max;
208         emit LogLimitsChanged(_min, _max);
209     }
210 }
211 
212 
213 /**
214  * @title DAOstackPresale
215  * @dev A contract to allow only whitelisted followers to participate in presale.
216  */
217 contract DAOstackPreSale is Pausable,BuyLimits,Whitelist {
218     event LogFundsReceived(address indexed _sender, uint _amount);
219 
220     address public wallet;
221 
222     /**
223     * @dev Constructor.
224     * @param _wallet Address where the funds are transfered to
225     * @param _minBuy Address where the funds are transfered to
226     * @param _maxBuy Address where the funds are transfered to
227     */
228     function DAOstackPreSale(address _wallet, uint _minBuy, uint _maxBuy)
229     public
230     BuyLimits(_minBuy, _maxBuy)
231     {
232         // Set wallet:
233         require(_wallet != address(0));
234         wallet = _wallet;
235     }
236 
237     /**
238     * @dev Fallback, funds coming in are transfered to wallet
239     */
240     function () payable whenNotPaused onlyWhitelisted isWithinLimits(msg.value) external {
241         wallet.transfer(msg.value);
242         emit LogFundsReceived(msg.sender, msg.value);
243     }
244 
245     /*
246     ** @dev Drain function, in case of failure. Contract should not hold eth anyhow.
247     */
248     function drain() external {
249         wallet.transfer((address(this)).balance);
250     }
251 
252 }