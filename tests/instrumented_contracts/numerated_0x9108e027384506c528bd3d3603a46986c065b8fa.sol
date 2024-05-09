1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         emit OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // assert(b > 0); // Solidity automatically throws when dividing by 0
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66         return c;
67     }
68 
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78     }
79 }
80 
81 
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89     uint256 public totalSupply;
90 
91     function balanceOf(address who) public view returns (uint256);
92 
93     function transfer(address to, uint256 value) public returns (bool);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 
99 
100 /**
101  * @title Basic token
102  * @dev Basic version of StandardToken, with no allowances.
103  */
104 contract BasicToken is ERC20Basic {
105     using SafeMath for uint256;
106 
107     mapping(address => uint256) balances;
108 
109     /**
110     * @dev transfer token for a specified address
111     * @param _to The address to transfer to.
112     * @param _value The amount to be transferred.
113     */
114     function transfer(address _to, uint256 _value) public returns (bool) {
115         require(_to != address(0));
116         require(_value <= balances[msg.sender]);
117 
118         // SafeMath.sub will throw if there is not enough balance.
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         emit Transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     /**
126     * @dev Gets the balance of the specified address.
127     * @param _owner The address to query the the balance of.
128     * @return An uint256 representing the amount owned by the passed address.
129     */
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134 }
135 
136 
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143     function allowance(address owner, address spender) public view returns (uint256);
144 
145     function transferFrom(address from, address to, uint256 value) public returns (bool);
146 
147     function approve(address spender, uint256 value) public returns (bool);
148 
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163     mapping(address => mapping(address => uint256)) internal allowed;
164 
165 
166     /**
167      * @dev Transfer tokens from one address to another
168      * @param _from address The address which you want to send tokens from
169      * @param _to address The address which you want to transfer to
170      * @param _value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173         require(_to != address(0));
174         require(_value <= balances[_from]);
175         require(_value <= allowed[_from][msg.sender]);
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180         emit Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     /**
185      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186      *
187      * Beware that changing an allowance with this method brings the risk that someone may use both the old
188      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      * @param _spender The address which will spend the funds.
192      * @param _value The amount of tokens to be spent.
193      */
194     function approve(address _spender, uint256 _value) public returns (bool) {
195         allowed[msg.sender][_spender] = _value;
196         emit Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     /**
201      * @dev Function to check the amount of tokens that an owner allowed to a spender.
202      * @param _owner address The address which owns the funds.
203      * @param _spender address The address which will spend the funds.
204      * @return A uint256 specifying the amount of tokens still available for the spender.
205      */
206     function allowance(address _owner, address _spender) public view returns (uint256) {
207         return allowed[_owner][_spender];
208     }
209 
210     /**
211      * @dev Increase the amount of tokens that an owner allowed to a spender.
212      *
213      * approve should be called when allowed[_spender] == 0. To increment
214      * allowed value is better to use this function to avoid 2 calls (and wait until
215      * the first transaction is mined)
216      * From MonolithDAO Token.sol
217      * @param _spender The address which will spend the funds.
218      * @param _addedValue The amount of tokens to increase the allowance by.
219      */
220     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     /**
227      * @dev Decrease the amount of tokens that an owner allowed to a spender.
228      *
229      * approve should be called when allowed[_spender] == 0. To decrement
230      * allowed value is better to use this function to avoid 2 calls (and wait until
231      * the first transaction is mined)
232      * From MonolithDAO Token.sol
233      * @param _spender The address which will spend the funds.
234      * @param _subtractedValue The amount of tokens to decrease the allowance by.
235      */
236     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
237         uint oldValue = allowed[msg.sender][_spender];
238         if (_subtractedValue > oldValue) {
239             allowed[msg.sender][_spender] = 0;
240         } else {
241             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242         }
243         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246 
247 }
248 
249 
250 
251 contract Pausable is Ownable {
252     event Pause();
253     event Unpause();
254 
255     bool public paused = false;
256 
257 
258     /**
259      * @dev Modifier to make a function callable only when the contract is not paused.
260      */
261     modifier whenNotPaused() {
262         require(!paused);
263         _;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is paused.
268      */
269     modifier whenPaused() {
270         require(paused);
271         _;
272     }
273 
274     /**
275      * @dev called by the owner to pause, triggers stopped state
276      */
277     function pause() onlyOwner whenNotPaused public {
278         paused = true;
279         emit Pause();
280     }
281 
282     /**
283      * @dev called by the owner to unpause, returns to normal state
284      */
285     function unpause() onlyOwner whenPaused public {
286         paused = false;
287         emit Unpause();
288     }
289 }
290 
291 
292 contract PausableToken is StandardToken, Pausable {
293 
294     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
295         return super.transfer(_to, _value);
296     }
297 
298     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
299         return super.transferFrom(_from, _to, _value);
300     }
301 
302     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
303         return super.approve(_spender, _value);
304     }
305 
306     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
307         return super.increaseApproval(_spender, _addedValue);
308     }
309 
310     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
311         return super.decreaseApproval(_spender, _subtractedValue);
312     }
313 }
314 
315 
316 contract EcoSystem is PausableToken {
317 
318     string public constant name = "Ecosystem Health Chain";
319     string public constant symbol = "EHC";
320     uint8 public constant decimals = 18;
321 
322     constructor() public{
323         totalSupply = 2 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
324         balances[owner] = totalSupply;
325     }
326 
327     function claimTokens(address _token) public onlyOwner {
328         if (_token == 0x0) {
329             owner.transfer(address(this).balance);
330             return;
331         }
332 
333         ERC20 token = ERC20(_token);
334         uint balance = token.balanceOf(this);
335         token.transfer(owner, balance);
336         emit ClaimedTokens(_token, owner, balance);
337     }
338 
339     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
340 
341 
342     function multiTransfer(address[] recipients, uint256[] amounts) public {
343         require(recipients.length == amounts.length);
344         for (uint i = 0; i < recipients.length; i++) {
345             transfer(recipients[i], amounts[i]);
346         }
347     }
348 
349     function airDrop(address _to, uint256 _value) public returns (bool) {
350         require(_to != address(0));
351         if (_value <= balances[owner] && _value <= allowed[owner][msg.sender])
352         {
353             super.transferFrom(owner, _to, _value);
354         }
355         return true;
356     }
357 
358 
359 }