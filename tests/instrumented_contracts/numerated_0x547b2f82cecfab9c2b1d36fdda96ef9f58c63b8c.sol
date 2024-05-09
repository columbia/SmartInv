1 pragma solidity ^0.5.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         require(c / a == b, "SafeMath: multiplication overflow");
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0, "SafeMath: division by zero");
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a, "SafeMath: subtraction overflow");
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     function balanceOf(address who) external view returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) external view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68 
69     /**
70     * @dev transfer token for a specified address
71     * @param to The address to transfer to.
72     * @param value The amount to be transferred.
73     */
74     function transfer(address to, uint256 value) public returns (bool) {
75         require(to != address(0));
76         require(to != address(this));
77         require(value <= balances[msg.sender]);
78 
79         // SafeMath.sub will throw if there is not enough balance.
80         balances[msg.sender] = balances[msg.sender].sub(value);
81         balances[to] = balances[to].add(value);
82         emit Transfer(msg.sender, to, value);
83         return true;
84     }
85 
86     /**
87     * @dev Gets the balance of the specified address.
88     * @param owner The address to query the the balance of.
89     * @return An uint256 representing the amount owned by the passed address.
90     */
91     function balanceOf(address owner) external view returns (uint256 balance) {
92         return balances[owner];
93     }
94 
95 }
96 
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107     mapping (address => mapping (address => uint256)) internal allowed;
108 
109     /**
110      * @dev Transfer tokens from one address to another
111      * @param from address The address which you want to send tokens from
112      * @param to address The address which you want to transfer to
113      * @param value uint256 the amount of tokens to be transferred
114      */
115     function transferFrom(address from, address to, uint256 value) public returns (bool) {
116         require(to != address(0));
117         require(to != address(this));
118         require(value <= balances[from]);
119         require(value <= allowed[from][msg.sender]);
120 
121         balances[from] = balances[from].sub(value);
122         balances[to] = balances[to].add(value);
123         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
124         emit Transfer(from, to, value);
125         return true;
126     }
127 
128     /**
129      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130      *
131      * Beware that changing an allowance with this method brings the risk that someone may use both the old
132      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      * @param spender The address which will spend the funds.
136      * @param value The amount of tokens to be spent.
137      */
138     function approve(address spender, uint256 value) public returns (bool) {
139         allowed[msg.sender][spender] = value;
140         emit Approval(msg.sender, spender, value);
141         return true;
142     }
143 
144     /**
145      * @dev Function to check the amount of tokens that an owner allowed to a spender.
146      * @param owner address The address which owns the funds.
147      * @param spender address The address which will spend the funds.
148      * @return An uint256 specifying the amount of tokens still available for the spender.
149      */
150     function allowance(address owner, address spender) external view returns (uint256) {
151         return allowed[owner][spender];
152     }
153 
154     /**
155      * @dev Increase the amount of tokens that an owner allowed to a spender.
156      *
157      * approve should be called when allowed[spender] == 0. To increment
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      * @param spender The address which will spend the funds.
162      * @param addedValue The amount of tokens to increase the allowance by.
163      */
164     function increaseApproval(address spender, uint256 addedValue) public returns (bool){
165         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
166         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
167         return true;
168     }
169 
170     /**
171      * @dev Decrease the amount of tokens that an owner allowed to a spender.
172      *
173      * approve should be called when allowed[spender] == 0. To decrement
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      * @param spender The address which will spend the funds.
178      * @param subtractedValue The amount of tokens to decrease the allowance by.
179      */
180     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool){
181         uint256 oldValue = allowed[msg.sender][spender];
182         if (subtractedValue > oldValue) {
183             allowed[msg.sender][spender] = 0;
184         } else {
185             allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
186         }
187 
188         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
189         return true;
190     }
191 }
192 
193 
194 /**
195  * @title ERC677 interface
196  *
197  * @dev Simple ERC677, adding transferAndCall functionality
198  * @dev https://github.com/ethereum/EIPs/issues/677
199  */
200 contract ERC677 is ERC20 {
201   function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool success);
202 
203   event Transfer(address indexed from, address indexed to, uint value, bytes data);
204 }
205 
206 
207 /**
208  * @title ERC677Receiver interface
209  *
210  * @dev Interface for token receivers (contracts) for transferAndCall
211  * @dev https://github.com/ethereum/EIPs/issues/677
212  */
213 contract ERC677Receiver {
214   function onTokenTransfer(address sender, uint value, bytes calldata data) external;
215 }
216 
217 
218 /**
219  * @title ERC677Token
220  *
221  * @dev Implementation of ERC677 Token
222  * @dev https://github.com/ethereum/EIPs/issues/677
223  */
224 contract ERC677Token is ERC677, StandardToken {
225     
226   /**
227    * @dev Transfers token to address with additional data if the recipient is a contract
228    * @param to The address to transfer token to
229    * @param value The amount of tokens to be transferred
230    * @param data The data to be passed to the receiving contract
231    */
232   function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool success) {
233     super.transfer(to, value);
234     emit Transfer(msg.sender, to, value, data);
235     if (isContract(to)) {
236       contractFallback(to, value, data);
237     }
238     return true;
239   }
240 
241 
242   /**
243    * @dev Call receiving contract callback, when to address in transferAndCall is contract
244    * @param to The address of receiving contract
245    * @param value The amount of tokens to be transferred
246    * @param data The data to be passed to the receiving contract onTokenTransfer
247    */
248   function contractFallback(address to, uint value, bytes memory data) private {
249     ERC677Receiver receiver = ERC677Receiver(to);
250     receiver.onTokenTransfer(msg.sender, value, data);
251   }
252   
253 
254   /**
255    * @dev Checks of address is contract
256    * @param addr Address to check
257    */
258   function isContract(address addr) private view returns (bool hasCode) {
259     uint length;
260     assembly { length := extcodesize(addr) }
261     return length > 0;
262   }
263 }
264 
265 
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of "user permissions".
270  */
271 contract Ownable {
272     address public owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
278      * account.
279      */
280     constructor() public {
281         owner = msg.sender;
282     }
283 
284     /**
285      * @dev Throws if called by any account other than the owner.
286      */
287     modifier onlyOwner() {
288         require(msg.sender == owner);
289         _;
290     }
291 
292     /**
293      * @dev Allows the current owner to transfer control of the contract to a newOwner.
294      * @param newOwner The address to transfer ownership to.
295      */
296     function transferOwnership(address newOwner) external onlyOwner {
297         require(newOwner != address(0));
298         emit OwnershipTransferred(owner, newOwner);
299         owner = newOwner;
300     }
301 
302 }
303 
304 
305 /**
306  * @title Pausable
307  * @dev Base contract which allows children to implement an emergency stop mechanism.
308  */
309 contract Pausable is Ownable {
310     event Pause();
311     event Unpause();
312 
313     bool public paused = false;
314 
315 
316     /**
317      * @dev Modifier to make a function callable only when the contract is not paused.
318      */
319     modifier whenNotPaused() {
320         require(!paused);
321         _;
322     }
323 
324     /**
325      * @dev Modifier to make a function callable only when the contract is paused.
326      */
327     modifier whenPaused() {
328         require(paused);
329         _;
330     }
331 
332     /**
333      * @dev called by the owner to pause, triggers stopped state
334      */
335     function pause() onlyOwner whenNotPaused external {
336         paused = true;
337         emit Pause();
338     }
339 
340     /**
341      * @dev called by the owner to unpause, returns to normal state
342      */
343     function unpause() onlyOwner whenPaused external {
344         paused = false;
345         emit Unpause();
346     }
347 }
348 
349 
350 /**
351  * @title Pausable token
352  *
353  * @dev StandardToken modified with pausable transfers.
354  **/
355 contract PausableToken is ERC677Token, Pausable {
356 
357     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
358         return super.transfer(to, value);
359     }
360     
361     function transferAndCall(address to, uint256 value, bytes memory data) public whenNotPaused returns (bool) {
362         return super.transferAndCall(to, value, data);
363     }
364 
365     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
366         return super.transferFrom(from, to, value);
367     }
368 
369     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
370         return super.approve(spender, value);
371     }
372 
373     function increaseApproval(address spender, uint256 addedValue) public whenNotPaused returns (bool){
374         return super.increaseApproval(spender, addedValue);
375     }
376 
377     function decreaseApproval(address spender, uint256 subtractedValue) public whenNotPaused returns (bool){
378         return super.decreaseApproval(spender, subtractedValue);
379     }
380 }
381 
382 
383 /**
384  * @title TaxaToken token
385  *
386  * @dev PausableToken modified with coin specific setting.
387  **/
388 
389 contract TaxaToken is PausableToken {
390     string public constant name = "Taxa Token";
391     string public constant symbol = "TXT";
392     uint8 public constant decimals = 18;
393 
394     uint256 public constant totalSupply = 10 ** 10 * 10 ** uint256(decimals);
395 
396     constructor() public {
397         balances[owner] = totalSupply;
398         emit Transfer(address(0), owner, balances[owner]);
399     }
400 }