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
14   function add(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 }
20 
21 contract Token {
22 
23     /// @return total amount of tokens
24     //function totalSupply() constant returns (uint256 supply);
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) constant returns (uint256 balance);
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value) returns (bool success);
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
42 
43     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of wei to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) returns (bool success);
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56     
57 }
58 
59 
60 
61 contract StandardToken is Token {
62 
63     function transfer(address _to, uint256 _value) returns (bool success) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
66         //Replace the if with this one instead.
67         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[msg.sender] >= _value && _value > 0) {
69             balances[msg.sender] -= _value;
70             balances[_to] += _value;
71             Transfer(msg.sender, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         //same as above. Replace this line with the following if you want to protect against wrapping uints.
78         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
80             balances[_to] += _value;
81             balances[_from] -= _value;
82             allowed[_from][msg.sender] -= _value;
83             Transfer(_from, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88     function balanceOf(address _owner) constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100     }
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104     uint256 public totalSupply;
105 }
106 
107 
108 //name this contract whatever you'd like
109 contract LUVTOKEN is StandardToken {
110 
111     function () {
112         //if ether is sent to this address, send it back.
113         revert();
114     }
115 
116     /* Public variables of the token */
117 
118     /*
119     NOTE:
120     The following variables are OPTIONAL vanities. One does not have to include them.
121     They allow one to customize the token contract & in no way influences the core functionality.
122     Some wallets/interfaces might not even bother to look at this information.
123     */
124     string public name;                   //fancy name: eg Simon Bucks
125     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
126     string public symbol;                 //An identifier: eg SBX
127     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
128 
129 //
130 // CHANGE THESE VALUES FOR YOUR TOKEN
131 //
132 
133 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
134 
135     function LUVTOKEN(
136         ) {
137         decimals = 18; 
138         totalSupply = 200000000 * (10 ** uint256(decimals));                        // Update total supply (100000 for example)
139         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens (100000 for example)
140         name = "LUVTOKEN";                                   // Set the name for display purposes
141         symbol = "LUV";                               // Set the symbol for display purposes
142     }
143 
144     /* Approves and then calls the receiving contract */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148 
149         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
150         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
151         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
152         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
153         return true;
154     }
155 }
156 
157 
158 /**
159  * @title Ownable
160  * @dev The Ownable contract has an owner address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Ownable {
164   address public owner;
165 
166 
167   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169 
170   /**
171    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172    * account.
173    */
174   function Ownable() {
175     owner = msg.sender;
176   }
177 
178 
179   /**
180    * @dev Throws if called by any account other than the owner.
181    */
182   modifier onlyOwner() {
183     require(msg.sender == owner);
184     _;
185   }
186 
187 
188   /**
189    * @dev Allows the current owner to transfer control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function transferOwnership(address newOwner) onlyOwner public {
193     require(newOwner != address(0));
194     OwnershipTransferred(owner, newOwner);
195     owner = newOwner;
196   }
197 
198 }
199 
200 /**
201  * @title Token 
202  * @dev API interface for interacting with the LUVTOKEN contract
203  * /
204  interface Token {
205  function transfer (address _to, uint256 _value) returns (bool);
206  function balanceOf (address_owner) constant returns (uint256 balance);
207 }
208 
209 /**
210  * @title LUV_Crowdsale
211  * @dev LUV_Crowdsale is a base contract for managing a token crowdsale.
212  * Crowdsales have a start and end timestamps, where investors can make
213  * token purchases and the crowdsale will assign them tokens based
214  * on a token per ETH rate. Funds collected are forwarded to a wallet
215  * as they arrive.
216  */
217 contract LUV_Crowdsale is Ownable {
218   using SafeMath for uint256;
219 
220   // The token being sold
221   LUVTOKEN public token;
222 
223   // start and end timestamps where investments are allowed (both inclusive)
224 
225 
226   uint256 public startTime = now;
227   uint256 public phase_1_Time = 1526342400 ;
228   uint256 public phase_2_Time = 1529020800;
229   uint256 public endTime = 1531612800;
230 
231   // Max amount of wei accepted in the crowdsale
232   uint256 public cap;
233   
234   // Min amount of wei an investor can send
235   uint256 public minInvest;
236   
237   
238   // address where funds are collected
239   address public wallet;
240 
241   // how many token units a buyer gets. 1 ETH = 10000 LUV
242   uint256 public phase_1_rate = 13000;
243   uint256 public phase_2_rate = 12000;
244   uint256 public phase_3_rate = 11000;
245   
246   
247   // amount of raised money in wei
248   uint256 public weiRaised;
249 
250   mapping (address => uint256) rates;
251 
252   function getRate() constant returns (uint256){
253     uint256 current_time = now;
254 
255     if(current_time > startTime && current_time < phase_1_Time){
256       return phase_1_rate;
257     }
258     else if(current_time > phase_1_Time && current_time < phase_2_Time){
259       return phase_2_rate;
260     }
261       else if(current_time > phase_2_Time && current_time < endTime){
262       return phase_3_rate;
263     }
264       
265   }
266 
267   /**
268    * event for token purchase logging
269    * @param purchaser who paid for the tokens
270    * @param beneficiary who got the tokens
271    * @param value weis paid for purchase
272    * @param amount amount of tokens purchased
273    */
274   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
275 
276 
277   function LUV_Crowdsale() {
278     wallet = msg.sender;
279     token = createTokenContract();
280     minInvest = 0.1 * 1 ether;
281     cap = 100000 * 1 ether;
282   }
283 
284   // creates the token to be sold.
285   // override this method to have crowdsale of a specific mintable token.
286   function createTokenContract() internal returns (LUVTOKEN) {
287     return new LUVTOKEN();
288   }
289 
290 
291   // fallback function can be used to buy tokens
292   function () payable {
293     buyTokens(msg.sender);
294   }
295 
296   // low level token purchase function
297   function buyTokens(address beneficiary) public payable {
298     require(beneficiary != 0x0);
299     require(validPurchase());
300 
301     uint256 weiAmount = msg.value;
302 
303     // calculate token amount to be created
304     uint256 tokens = weiAmount.mul(getRate());
305 
306     // update state
307     weiRaised = weiRaised.add(weiAmount);
308 
309     token.transfer(beneficiary, tokens);
310     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
311 
312     forwardFunds();
313   }
314 
315   // send ether to the fund collection wallet
316   // override to create custom fund forwarding mechanisms
317   function forwardFunds() internal {
318     wallet.transfer(msg.value);
319   }
320 
321   // @return true if the transaction can buy tokens
322   function validPurchase() internal constant returns (bool) {
323     bool withinPeriod = now >= startTime && now <= endTime;
324     bool nonZeroPurchase = msg.value != 0;
325     return withinPeriod && nonZeroPurchase;
326   }
327 
328   // @return true if crowdsale event has ended
329   function hasEnded() public constant returns (bool) {
330     return now > endTime;
331   }
332   
333 /**
334  * @notice Terminate contract and refund to owner
335  */
336  function destroy() onlyOwner {
337      // Transfer tokens back to owner
338      uint256 balance = token.balanceOf(this);
339      assert (balance > 0);
340      token.transfer(owner,balance);
341      
342      // There should be no ether in the contract but just in case
343      selfdestruct(owner);
344      
345  }
346 
347 }