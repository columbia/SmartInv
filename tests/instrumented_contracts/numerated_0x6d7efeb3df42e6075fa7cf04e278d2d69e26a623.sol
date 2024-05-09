1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     constructor() public {
22         owner = msg.sender;
23     }
24 
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         assert(c / a == b);
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // assert(b > 0); // Solidity automatically throws when dividing by 0
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         assert(b <= a);
72         return a - b;
73     }
74 
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90     uint256 public totalSupply;
91 
92     function balanceOf(address who) public view returns (uint256);
93 
94     function transfer(address to, uint256 value) public returns (bool);
95 
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 // File: zeppelin-solidity/contracts/token/BasicToken.sol
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106     using SafeMath for uint256;
107 
108     mapping(address => uint256) balances;
109 
110     /**
111     * @dev transfer token for a specified address
112     * @param _to The address to transfer to.
113     * @param _value The amount to be transferred.
114     */
115     function transfer(address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(_value <= balances[msg.sender]);
118 
119         // SafeMath.sub will throw if there is not enough balance.
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param _owner The address to query the the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address _owner) public view returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135 }
136 
137 // File: zeppelin-solidity/contracts/token/ERC20.sol
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144     function allowance(address owner, address spender) public view returns (uint256);
145 
146     function transferFrom(address from, address to, uint256 value) public returns (bool);
147 
148     function approve(address spender, uint256 value) public returns (bool);
149 
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 // File: zeppelin-solidity/contracts/token/StandardToken.sol
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164     mapping(address => mapping(address => uint256)) internal allowed;
165 
166 
167     /**
168      * @dev Transfer tokens from one address to another
169      * @param _from address The address which you want to send tokens from
170      * @param _to address The address which you want to transfer to
171      * @param _value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174         require(_to != address(0));
175         require(_value <= balances[_from]);
176         require(_value <= allowed[_from][msg.sender]);
177 
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181         emit Transfer(_from, _to, _value);
182         return true;
183     }
184 
185     /**
186      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187      *
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param _spender The address which will spend the funds.
193      * @param _value The amount of tokens to be spent.
194      */
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         allowed[msg.sender][_spender] = _value;
197         emit Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     /**
202      * @dev Function to check the amount of tokens that an owner allowed to a spender.
203      * @param _owner address The address which owns the funds.
204      * @param _spender address The address which will spend the funds.
205      * @return A uint256 specifying the amount of tokens still available for the spender.
206      */
207     function allowance(address _owner, address _spender) public view returns (uint256) {
208         return allowed[_owner][_spender];
209     }
210 
211     /**
212      * @dev Increase the amount of tokens that an owner allowed to a spender.
213      *
214      * approve should be called when allowed[_spender] == 0. To increment
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * @param _spender The address which will spend the funds.
219      * @param _addedValue The amount of tokens to increase the allowance by.
220      */
221     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
222         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227     /**
228      * @dev Decrease the amount of tokens that an owner allowed to a spender.
229      *
230      * approve should be called when allowed[_spender] == 0. To decrement
231      * allowed value is better to use this function to avoid 2 calls (and wait until
232      * the first transaction is mined)
233      * From MonolithDAO Token.sol
234      * @param _spender The address which will spend the funds.
235      * @param _subtractedValue The amount of tokens to decrease the allowance by.
236      */
237     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
238         uint oldValue = allowed[msg.sender][_spender];
239         if (_subtractedValue > oldValue) {
240             allowed[msg.sender][_spender] = 0;
241         } else {
242             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243         }
244         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245         return true;
246     }
247 
248 }
249 
250 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
251 
252 /**
253  * @title Pausable
254  * @dev Base contract which allows children to implement an emergency stop mechanism.
255  */
256 contract Pausable is Ownable {
257     event Pause();
258     event Unpause();
259 
260     bool public paused = false;
261 
262 
263     /**
264      * @dev Modifier to make a function callable only when the contract is not paused.
265      */
266     modifier whenNotPaused() {
267         require(!paused);
268         _;
269     }
270 
271     /**
272      * @dev Modifier to make a function callable only when the contract is paused.
273      */
274     modifier whenPaused() {
275         require(paused);
276         _;
277     }
278 
279     /**
280      * @dev called by the owner to pause, triggers stopped state
281      */
282     function pause() onlyOwner whenNotPaused public {
283         paused = true;
284         emit Pause();
285     }
286 
287     /**
288      * @dev called by the owner to unpause, returns to normal state
289      */
290     function unpause() onlyOwner whenPaused public {
291         paused = false;
292         emit Unpause();
293     }
294 }
295 
296 // File: zeppelin-solidity/contracts/token/PausableToken.sol
297 
298 /**
299  * @title Pausable token
300  *
301  * @dev StandardToken modified with pausable transfers.
302  **/
303 
304 contract PausableToken is StandardToken, Pausable {
305 
306     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
307         return super.transfer(_to, _value);
308     }
309 
310     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
311         return super.transferFrom(_from, _to, _value);
312     }
313 
314     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
315         return super.approve(_spender, _value);
316     }
317 
318     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
319         return super.increaseApproval(_spender, _addedValue);
320     }
321 
322     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
323         return super.decreaseApproval(_spender, _subtractedValue);
324     }
325 }
326 
327 // File: contracts/Luckyyou.sol
328 
329 /**
330  * @title WePower Contribution Token
331  */
332 contract LuckyYouToken is PausableToken {
333 
334     string public constant name = "Lucky You";
335     string public constant symbol = "LKY";
336     uint8 public constant decimals = 18;
337 
338     constructor() public{
339         totalSupply = 1 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
340         balances[owner] = totalSupply;
341     }
342 
343     function claimTokens(address _token) public onlyOwner {
344         if (_token == 0x0) {
345             owner.transfer(address(this).balance);
346             return;
347         }
348 
349         ERC20 token = ERC20(_token);
350         uint balance = token.balanceOf(this);
351         token.transfer(owner, balance);
352         emit ClaimedTokens(_token, owner, balance);
353     }
354 
355     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
356 
357 
358     function multiTransfer(address[] recipients, uint256[] amounts) public {
359         require(recipients.length == amounts.length);
360         for (uint i = 0; i < recipients.length; i++) {
361             transfer(recipients[i], amounts[i]);
362         }
363     }
364 
365     function airDrop(address _to, uint256 _value) public returns (bool) {
366         require(_to != address(0));
367         if(_value <= balances[owner] && _value <= allowed[owner][msg.sender])
368         {
369             super.transferFrom(owner,_to,_value);
370         }
371         return true;
372     }
373 }