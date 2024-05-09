1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31 
32     // SafeMath.sub will throw if there is not enough balance.
33     balances[msg.sender] = balances[msg.sender].sub(_value);
34     balances[_to] = balances[_to].add(_value);
35     Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public constant returns (uint256 balance) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 
51 
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 /**
65  * @title Standard ERC20 token
66  *
67  * @dev Implementation of the basic standard token.
68  * @dev https://github.com/ethereum/EIPs/issues/20
69  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
70  */
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amount of tokens to be transferred
81    */
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84 
85     uint256 _allowance = allowed[_from][msg.sender];
86 
87     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
88     // require (_value <= _allowance);
89 
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = _allowance.sub(_value);
93     Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    *
100    * Beware that changing an allowance with this method brings the risk that someone may use both the old
101    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
102    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
103    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104    * @param _spender The address which will spend the funds.
105    * @param _value The amount of tokens to be spent.
106    */
107   function approve(address _spender, uint256 _value) public returns (bool) {
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123   /**
124    * approve should be called when allowed[_spender] == 0. To increment
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    */
129   function increaseApproval (address _spender, uint _addedValue)
130     returns (bool success) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval (address _spender, uint _subtractedValue)
137     returns (bool success) {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148 }
149 
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162 
163   /**
164    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
165    * account.
166    */
167   function Ownable() {
168     owner = msg.sender;
169   }
170 
171 
172   /**
173    * @dev Throws if called by any account other than the owner.
174    */
175   modifier onlyOwner() {
176     require(msg.sender == owner);
177     _;
178   }
179 
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) onlyOwner public {
186     require(newOwner != address(0));
187     OwnershipTransferred(owner, newOwner);
188     owner = newOwner;
189   }
190 
191 }
192 
193 
194 /**
195  * @title Contactable token
196  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
197  * contact information.
198  */
199 contract Contactable is Ownable{
200 
201     string public contactInformation;
202 
203     /**
204      * @dev Allows the owner to set a string with their contact information.
205      * @param info The contact information to attach to the contract.
206      */
207     function setContactInformation(string info) onlyOwner public {
208          contactInformation = info;
209      }
210 }
211 
212 
213 /**
214  * @title SafeMath
215  * @dev Math operations with safety checks that throw on error
216  */
217 library SafeMath {
218   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
219     uint256 c = a * b;
220     assert(a == 0 || c / a == b);
221     return c;
222   }
223 
224   function div(uint256 a, uint256 b) internal constant returns (uint256) {
225     // assert(b > 0); // Solidity automatically throws when dividing by 0
226     uint256 c = a / b;
227     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228     return c;
229   }
230 
231   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
232     assert(b <= a);
233     return a - b;
234   }
235 
236   function add(uint256 a, uint256 b) internal constant returns (uint256) {
237     uint256 c = a + b;
238     assert(c >= a);
239     return c;
240   }
241 }
242 
243 contract IRefundHandler {
244     function handleRefundRequest(address _contributor) external;
245 }
246 
247 
248 contract LOCIcoin is StandardToken, Ownable, Contactable {
249     string public name = "";
250     string public symbol = "";
251     uint256 public constant decimals = 18;
252 
253     mapping (address => bool) internal allowedOverrideAddresses;
254 
255     bool public tokenActive = false;
256 
257     modifier onlyIfTokenActiveOrOverride() {
258         // owner or any addresses listed in the overrides
259         // can perform token transfers while inactive
260         require(tokenActive || msg.sender == owner || allowedOverrideAddresses[msg.sender]);
261         _;
262     }
263 
264     modifier onlyIfTokenInactive() {
265         require(!tokenActive);
266         _;
267     }
268 
269     modifier onlyIfValidAddress(address _to) {
270         // prevent 'invalid' addresses for transfer destinations
271         require(_to != 0x0);
272         // don't allow transferring to this contract's address
273         require(_to != address(this));
274         _;
275     }
276 
277     event TokenActivated();
278 
279     function LOCIcoin(uint256 _totalSupply, string _contactInformation ) public {
280         totalSupply = _totalSupply;
281         contactInformation = _contactInformation;
282 
283         // msg.sender == owner of the contract
284         balances[msg.sender] = _totalSupply;
285     }
286 
287     /// @dev Same ERC20 behavior, but reverts if not yet active.
288     /// @param _spender address The address which will spend the funds.
289     /// @param _value uint256 The amount of tokens to be spent.
290     function approve(address _spender, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_spender) returns (bool) {
291         return super.approve(_spender, _value);
292     }
293 
294     /// @dev Same ERC20 behavior, but reverts if not yet active.
295     /// @param _to address The address to transfer to.
296     /// @param _value uint256 The amount to be transferred.
297     function transfer(address _to, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_to) returns (bool) {
298         return super.transfer(_to, _value);
299     }
300 
301     function ownerSetOverride(address _address, bool enable) external onlyOwner {
302         allowedOverrideAddresses[_address] = enable;
303     }
304 
305     function ownerSetVisible(string _name, string _symbol) external onlyOwner onlyIfTokenInactive {        
306 
307         // By holding back on setting these, it prevents the token
308         // from being a duplicate in ERC token searches if the need to
309         // redeploy arises prior to the crowdsale starts.
310         // Mainly useful during testnet deployment/testing.
311         name = _name;
312         symbol = _symbol;
313     }
314 
315     function ownerActivateToken() external onlyOwner onlyIfTokenInactive {
316         require(bytes(symbol).length > 0);
317 
318         tokenActive = true;
319         TokenActivated();
320     }
321 
322     function claimRefund(IRefundHandler _refundHandler) external {
323         uint256 _balance = balances[msg.sender];
324 
325         // Positive token balance required to perform a refund
326         require(_balance > 0);
327 
328         // this mitigates re-entrancy concerns
329         balances[msg.sender] = 0;
330 
331         // Attempt to transfer wei back to msg.sender from the
332         // crowdsale contract
333         // Note: re-entrancy concerns are also addressed within
334         // `handleRefundRequest`
335         // this will throw an exception if any
336         // problems or if refunding isn't enabled
337         _refundHandler.handleRefundRequest(msg.sender);
338 
339         // If we've gotten here, then the wei transfer above
340         // worked (didn't throw an exception) and it confirmed
341         // that `msg.sender` had an ether balance on the contract.
342         // Now do token transfer from `msg.sender` back to
343         // `owner` completes the refund.
344         balances[owner] = balances[owner].add(_balance);
345         Transfer(msg.sender, owner, _balance);
346     }
347 }