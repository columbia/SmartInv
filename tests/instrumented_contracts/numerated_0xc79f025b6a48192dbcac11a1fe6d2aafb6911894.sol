1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 /**
76  * @title RefundVault
77  * @dev This contract is used for storing funds while a crowdsale
78  * is in progress. Supports refunding the money if crowdsale fails,
79  * and forwarding it if crowdsale is successful.
80  */
81 contract RefundVault is Ownable {
82     using SafeMath for uint256;
83 
84     enum State { Active, Refunding, Closed }
85 
86     mapping (address => uint256) public deposited;
87     address public wallet;
88     State public state;
89 
90     event Closed();
91     event RefundsEnabled();
92     event Refunded(address indexed beneficiary, uint256 weiAmount);
93 
94     function RefundVault(address _wallet) {
95         require(_wallet != 0x0);
96         wallet = _wallet;
97         state = State.Active;
98     }
99 
100     function deposit(address investor) onlyOwner public payable {
101         require(state == State.Active);
102         deposited[investor] = deposited[investor].add(msg.value);
103     }
104 
105     function close() onlyOwner public {
106         require(state == State.Active);
107         state = State.Closed;
108         Closed();
109         wallet.transfer(this.balance);
110     }
111 
112     function enableRefunds() onlyOwner public {
113         require(state == State.Active);
114         state = State.Refunding;
115         RefundsEnabled();
116     }
117 
118     function refund(address investor) public {
119         require(state == State.Refunding);
120         uint256 depositedValue = deposited[investor];
121         deposited[investor] = 0;
122         investor.transfer(depositedValue);
123         Refunded(investor, depositedValue);
124     }
125 }
126 
127 
128 /**
129  * @title ERC20Basic
130  * @dev Simpler version of ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/179
132  */
133 contract ERC20Basic {
134     uint256 public totalSupply;
135     function balanceOf(address who) constant returns (uint256);
136     function transfer(address to, uint256 value) returns (bool);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146     function allowance(address owner, address spender) constant returns (uint256);
147     function transferFrom(address from, address to, uint256 value) returns (bool);
148     function approve(address spender, uint256 value) returns (bool);
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158     using SafeMath for uint256;
159 
160     mapping(address => uint256) balances;
161 
162     /**
163     * @dev transfer token for a specified address
164     * @param _to The address to transfer to.
165     * @param _value The amount to be transferred.
166     */
167     function transfer(address _to, uint256 _value) returns (bool) {
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         Transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     /**
175     * @dev Gets the balance of the specified address.
176     * @param _owner The address to query the the balance of.
177     * @return An uint256 representing the amount owned by the passed address.
178     */
179     function balanceOf(address _owner) constant returns (uint256 balance) {
180         return balances[_owner];
181     }
182 
183 }
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194     mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207 
208         balances[_from] = balances[_from].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211         Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      *
218      * Beware that changing an allowance with this method brings the risk that someone may use both the old
219      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      * @param _spender The address which will spend the funds.
223      * @param _value The amount of tokens to be spent.
224      */
225     function approve(address _spender, uint256 _value) public returns (bool) {
226         allowed[msg.sender][_spender] = _value;
227         Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238         return allowed[_owner][_spender];
239     }
240 
241     /**
242      * approve should be called when allowed[_spender] == 0. To increment
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      */
247     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
248         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
254         uint oldValue = allowed[msg.sender][_spender];
255         if (_subtractedValue > oldValue) {
256             allowed[msg.sender][_spender] = 0;
257         } else {
258             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259         }
260         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264 }
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 
273 contract MintableToken is StandardToken, Ownable {
274     event Mint(address indexed to, uint256 amount);
275     event MintFinished();
276 
277     bool public mintingFinished = false;
278 
279 
280     modifier canMint() {
281         require(!mintingFinished);
282         _;
283     }
284 
285     /**
286      * @dev Function to mint tokens
287      * @param _to The address that will receive the minted tokens.
288      * @param _amount The amount of tokens to mint.
289      * @return A boolean that indicates if the operation was successful.
290      */
291     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
292         totalSupply = totalSupply.add(_amount);
293         balances[_to] = balances[_to].add(_amount);
294         Mint(_to, _amount);
295         Transfer(0x0, _to, _amount);
296         return true;
297     }
298 
299     /**
300      * @dev Function to stop minting new tokens.
301      * @return True if the operation was successful.
302      */
303     function finishMinting() onlyOwner public returns (bool) {
304         mintingFinished = true;
305         MintFinished();
306         return true;
307     }
308 }
309 
310 // Standard token variables
311 contract TokenOfGratitude is MintableToken {
312     string constant public name = "Token Of Gratitude";
313     string constant public symbol = "ToG";
314     uint8 constant public decimals = 0;
315 
316     uint256 public expirationDate = 1672531199;
317     address public goldenTicketOwner;
318 
319     // Mappings for easier backchecking
320     mapping (address => uint) redeemed;
321 
322     // ToG redeem event with encrypted message (hopefully a contact info)
323     event tokenRedemption(address indexed supported, string message);
324 
325     // Golden ticket related events
326     event goldenTicketMoved(address indexed newOwner);
327     event goldenTicketUsed(address charlie, string message);
328 
329     function TokenOfGratitude() {
330         goldenTicketOwner = msg.sender;
331     }
332 
333     /**
334      * Function returning the current price of ToG
335      * @dev can be used prior to the donation as a constant function but it is mainly used in the noname function
336      * @param message should contain an encrypted contract info of the redeemer to setup a meeting
337      */
338     function redeem(string message) {
339 
340         // Check caller has a token
341         require (balances[msg.sender] >= 1);
342 
343         // Check tokens did not expire
344         require (now <= expirationDate);
345 
346         // Lock the token against further transfers
347         balances[msg.sender] -= 1;
348         redeemed[msg.sender] += 1;
349 
350         // Call out
351         tokenRedemption(msg.sender, message);
352     }
353 
354     /**
355      * Function using the Golden ticket - the current holder will be able to get the prize only based on the "goldenTicketUsed" event
356      * @dev First checks the GT owner, then fires the event and then changes the owner to null so GT can't be used again
357      * @param message should contain an encrypted contract info of the redeemer to claim the reward
358      */
359     function useGoldenTicket(string message){
360         require(msg.sender == goldenTicketOwner);
361         goldenTicketUsed(msg.sender, message);
362         goldenTicketOwner = 0x0;
363     }
364 
365     /**
366      * Function using the Golden ticket - the current holder will be able to get the prize only based on the "goldenTicketUsed" event
367      * @dev First checks the GT owner, then change the owner and fire an event about the ticket changing owner
368      * @dev The Golden ticket isn't a standard ERC20 token and therefore it needs special handling
369      * @param newOwner should be a valid address of the new owner
370      */
371     function giveGoldenTicket(address newOwner) {
372         require (msg.sender == goldenTicketOwner);
373         goldenTicketOwner = newOwner;
374         goldenTicketMoved(newOwner);
375     }
376 
377 }