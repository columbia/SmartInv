1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4 
5     // Events
6     event Transfer(address indexed from, address indexed to, uint256 value);
7     event Approval( address indexed owner, address indexed spender, uint256 value);
8 
9     // Stateless functions
10     function totalSupply() constant public returns (uint256 supply);
11     function balanceOf( address who ) constant public returns (uint256 value);
12     function allowance(address owner, address spender) constant public returns (uint value);
13 
14     // Stateful functions
15     function transfer( address to, uint256 value) public returns (bool success);
16     function transferFrom( address from, address to, uint256 value) public returns (bool success);
17     function approve(address spender, uint256 value) public returns (bool success);
18 
19 }
20 
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   function Ownable() public {
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
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 
63 /**
64  * @title Pausable
65  * @dev Base contract which allows children to implement an emergency stop mechanism.
66  */
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is not paused.
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is paused.
84    */
85   modifier whenPaused() {
86     require(paused);
87     _;
88   }
89 
90   /**
91    * @dev called by the owner to pause, triggers stopped state
92    */
93   function pause() onlyOwner whenNotPaused public {
94     paused = true;
95     Pause();
96   }
97 
98   /**
99    * @dev called by the owner to unpause, returns to normal state
100    */
101   function unpause() onlyOwner whenPaused public {
102     paused = false;
103     Unpause();
104   }
105 }
106 
107 
108 
109 /**
110  * @title SafeMath
111  */
112 library SafeMath {
113 
114 
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     if (a == 0) {
117       return 0;
118     }
119     uint256 c = a * b;
120     assert(c / a == b);
121     return c;
122   }
123 
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a / b;
126     return c;
127   }
128 
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     assert(c >= a);
137     return c;
138   }
139   
140 }
141 
142 
143 
144 /**
145  * @title Whitelist
146  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
147  * @dev This simplifies the implementation of "user permissions".
148  */
149 contract Whitelist is Ownable {
150   mapping(address => bool) public whitelist;
151   
152   event WhitelistedAddressAdded(address addr);
153   event WhitelistedAddressRemoved(address addr);
154 
155   /**
156    * @dev Throws if called by any account that's not whitelisted.
157    */
158   modifier onlyWhitelisted() {
159     require(whitelist[msg.sender]);
160     _;
161   }
162 
163   /**
164    * @dev add an address to the whitelist
165    * @param addr address
166    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
167    */
168   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
169     if (!whitelist[addr]) {
170       whitelist[addr] = true;
171       WhitelistedAddressAdded(addr);
172       success = true; 
173     }
174   }
175 
176   /**
177    * @dev add addresses to the whitelist
178    * @param addrs addresses
179    * @return true if at least one address was added to the whitelist, 
180    * false if all addresses were already in the whitelist  
181    */
182   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
183     for (uint256 i = 0; i < addrs.length; i++) {
184       if (addAddressToWhitelist(addrs[i])) {
185         success = true;
186       }
187     }
188   }
189 
190   /**
191    * @dev remove an address from the whitelist
192    * @param addr address
193    * @return true if the address was removed from the whitelist, 
194    * false if the address wasn't in the whitelist in the first place 
195    */
196   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
197     if (whitelist[addr]) {
198       whitelist[addr] = false;
199       WhitelistedAddressRemoved(addr);
200       success = true;
201     }
202   }
203 
204   /**
205    * @dev remove addresses from the whitelist
206    * @param addrs addresses
207    * @return true if at least one address was removed from the whitelist, 
208    * false if all addresses weren't in the whitelist in the first place
209    */
210   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
211     for (uint256 i = 0; i < addrs.length; i++) {
212       if (removeAddressFromWhitelist(addrs[i])) {
213         success = true;
214       }
215     }
216   }
217 
218 }
219 
220 contract TalentCoin is ERC20, Ownable, Whitelist, Pausable{
221   
222   using SafeMath for uint256;
223 
224   mapping (address => bool) admins;  // Mapping of who is an admin
225   mapping( address => uint256 ) balances;
226   mapping( address => mapping( address => uint256 ) ) approvals;
227   mapping( address => uint256 ) ratemapping;
228   //How much ETH each address has invested
229   mapping (address => uint) public investedAmountOf;
230   address public owner;
231   address public walletAddress;
232   uint256 public supply;
233   string public name;
234   uint256 public decimals;
235   string public symbol;
236   uint256 public rate;
237   uint public weiRaised;
238   uint public soldTokens;
239   uint public investorCount;
240   
241 
242   function TalentCoin(address _walletAddress, uint256 _supply, string _name, uint256 _decimals, string _symbol, uint256 _rate ) public {
243     require(_walletAddress != 0x0);
244     balances[msg.sender] = _supply;
245     ratemapping[msg.sender] = _rate;
246     supply = _supply;
247     name = _name;
248     decimals = _decimals;
249     symbol = _symbol;
250     rate = _rate;
251     owner = msg.sender;
252     admins[msg.sender] = true;
253     walletAddress = _walletAddress;
254   }
255   
256     function () external payable {
257         createTokens();
258     }
259     
260     function createTokens() public payable onlyWhitelisted() whenNotPaused(){
261     require(msg.value >0);
262     if (investedAmountOf[msg.sender] == 0) {
263             investorCount++;
264         }
265     uint256 tokens = msg.value.mul(rate);  
266     require(supply >= tokens && balances[owner] >= tokens);
267     balances[msg.sender] = balances[msg.sender].add(tokens);
268     balances[owner] = balances[owner].sub(tokens); 
269     walletAddress.transfer(msg.value); 
270     Transfer(owner, msg.sender, tokens);
271     investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);
272     weiRaised = weiRaised.add(msg.value);
273     soldTokens = soldTokens.add(tokens);
274     }
275     
276   function totalSupply() constant public returns (uint) {
277     return supply;
278   }
279 
280   function balanceOf( address _who ) constant public returns (uint) {
281     return balances[_who];
282   }
283 
284   function transfer( address _to, uint256 _value) onlyWhitelisted() public returns (bool success) {
285     if (investedAmountOf[_to] == 0) {
286         investorCount++;
287     }
288     require(_to != 0x0);
289     require(balances[msg.sender] >= _value && _value > 0 && supply >= _value);
290     balances[msg.sender] = balances[msg.sender].sub(_value);
291     balances[_to] = balances[_to].add(_value);
292     Transfer( msg.sender, _to, _value );
293     soldTokens = soldTokens.add(_value);
294     return true;
295   }
296 
297   function transferFrom( address _from, address _to, uint256 _value) onlyWhitelisted() public returns (bool success) {
298     require(_from != 0x0 && _to != 0x0);
299     require(approvals[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
300     approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
301     balances[_from] = balances[_from].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     Transfer( _from, _to, _value );
304     soldTokens = soldTokens.add(_value);
305     return true;
306   }
307 
308   function approve(address _spender, uint256 _value) public returns (bool ok) {
309     require(_spender != 0x0);
310     approvals[msg.sender][_spender] = _value;
311     Approval( msg.sender, _spender, _value );
312     return true;
313   }
314 
315   function allowance(address _owner, address _spender) constant public returns (uint) {
316     return approvals[_owner][_spender];
317   }
318 
319   function increaseSupply(uint256 _value, address _to) onlyOwner() public returns(bool success) {
320     require(_to != 0x0);
321     supply = supply.add(_value);
322     balances[_to] = balances[_to].add(_value);
323     Transfer(0, _to, _value);
324     return true;
325   }
326 
327   function decreaseSupply(uint256 _value, address _from) onlyOwner() public returns(bool success) {
328     require(_from != 0x0);
329     balances[_from] = balances[_from].sub(_value);
330     supply = supply.sub(_value);
331     Transfer(_from, 0, _value);
332     return true;
333   }
334 
335   function increaseRate(uint256 _value, address _to) onlyOwner() public returns(bool success) {
336     require(_to != 0x0);
337     rate = rate.add(_value);
338     ratemapping[_to] = ratemapping[_to].add(_value);
339     Transfer(0, _to, _value);
340     return true;
341   }
342 
343   function decreaseRate(uint256 _value, address _from) onlyOwner() public returns(bool success) {
344     require(_from != 0x0);
345     ratemapping[_from] = ratemapping[_from].sub(_value);
346     rate = rate.sub(_value);
347     Transfer(_from, 0, _value);
348     return true;
349   }
350   
351   function increaseApproval (address _spender, uint _addedValue) onlyOwner() public returns (bool success) {
352     approvals[msg.sender][_spender] = approvals[msg.sender][_spender].add(_addedValue);
353     Approval(msg.sender, _spender, approvals[msg.sender][_spender]);
354     return true;
355   }
356 
357   function decreaseApproval (address _spender, uint _subtractedValue) onlyOwner() public returns (bool success) {
358     uint oldValue = approvals[msg.sender][_spender];
359     if (_subtractedValue > oldValue) {
360       approvals[msg.sender][_spender] = 0;
361     } else {
362       approvals[msg.sender][_spender] = oldValue.sub(_subtractedValue);
363     }
364     Approval(msg.sender, _spender, approvals[msg.sender][_spender]);
365     return true;
366   }
367 
368 }