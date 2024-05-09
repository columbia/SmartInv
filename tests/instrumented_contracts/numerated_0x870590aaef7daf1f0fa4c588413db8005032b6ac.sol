1 pragma solidity ^ 0.4 .21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two numbers, truncating the quotient.
23      */
24     function div(uint256 a, uint256 b) internal pure returns(uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33      */
34     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40      * @dev Adds two numbers, throws on overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94     event Pause();
95     event Unpause();
96 
97     bool public paused = false;
98 
99 
100     /**
101      * @dev Modifier to make a function callable only when the contract is not paused.
102      */
103     modifier whenNotPaused() {
104         require(!paused);
105         _;
106     }
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is paused.
110      */
111     modifier whenPaused() {
112         require(paused);
113         _;
114     }
115 
116     /**
117      * @dev called by the owner to pause, triggers stopped state
118      */
119     function pause() onlyOwner whenNotPaused public {
120         paused = true;
121         emit Pause();
122     }
123 
124     /**
125      * @dev called by the owner to unpause, returns to normal state
126      */
127     function unpause() onlyOwner whenPaused public {
128         paused = false;
129         emit Unpause();
130     }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139     function totalSupply() public view returns(uint256);
140 
141     function balanceOf(address who) public view returns(uint256);
142 
143     function transfer(address to, uint256 value) public returns(bool);
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 }
146 
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 contract ERC20 is ERC20Basic {
153     function allowance(address owner, address spender) public view returns(uint256);
154 
155     function transferFrom(address from, address to, uint256 value) public returns(bool);
156 
157     function approve(address spender, uint256 value) public returns(bool);
158     event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 /**
163  * @title Basic token
164  * @dev Basic version of StandardToken, with no allowances.
165  */
166 contract BasicToken is ERC20Basic {
167     using SafeMath
168     for uint256;
169 
170     mapping(address => uint256) balances;
171 
172     uint256 totalSupply_;
173 
174     /**
175      * @dev total number of tokens in existence
176      */
177     function totalSupply() public view returns(uint256) {
178         return totalSupply_;
179     }
180 
181     /**
182      * @dev transfer token for a specified address
183      * @param _to The address to transfer to.
184      * @param _value The amount to be transferred.
185      */
186     function transfer(address _to, uint256 _value) public returns(bool) {
187         require(_to != address(0));
188         require(_value <= balances[msg.sender]);
189 
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         emit Transfer(msg.sender, _to, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Gets the balance of the specified address.
198      * @param _owner The address to query the the balance of.
199      * @return An uint256 representing the amount owned by the passed address.
200      */
201     function balanceOf(address _owner) public view returns(uint256) {
202         return balances[_owner];
203     }
204 
205 }
206 
207 /**
208  * @title Standard ERC20 token
209  *
210  * @dev Implementation of the basic standard token.
211  * @dev https://github.com/ethereum/EIPs/issues/20
212  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
213  */
214 contract StandardToken is ERC20, BasicToken {
215 
216     mapping(address => mapping(address => uint256)) internal allowed;
217 
218 
219     /**
220      * @dev Transfer tokens from one address to another
221      * @param _from address The address which you want to send tokens from
222      * @param _to address The address which you want to transfer to
223      * @param _value uint256 the amount of tokens to be transferred
224      */
225     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
226         require(_to != address(0));
227         require(_value <= balances[_from]);
228         require(_value <= allowed[_from][msg.sender]);
229 
230         balances[_from] = balances[_from].sub(_value);
231         balances[_to] = balances[_to].add(_value);
232         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233         emit Transfer(_from, _to, _value);
234         return true;
235     }
236 
237     /**
238      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239      *
240      * Beware that changing an allowance with this method brings the risk that someone may use both the old
241      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      * @param _spender The address which will spend the funds.
245      * @param _value The amount of tokens to be spent.
246      */
247     function approve(address _spender, uint256 _value) public returns(bool) {
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252 
253     /**
254      * @dev Function to check the amount of tokens that an owner allowed to a spender.
255      * @param _owner address The address which owns the funds.
256      * @param _spender address The address which will spend the funds.
257      * @return A uint256 specifying the amount of tokens still available for the spender.
258      */
259     function allowance(address _owner, address _spender) public view returns(uint256) {
260         return allowed[_owner][_spender];
261     }
262 
263     /**
264      * @dev Increase the amount of tokens that an owner allowed to a spender.
265      *
266      * approve should be called when allowed[_spender] == 0. To increment
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * @param _spender The address which will spend the funds.
271      * @param _addedValue The amount of tokens to increase the allowance by.
272      */
273     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
274         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
275         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 
279     /**
280      * @dev Decrease the amount of tokens that an owner allowed to a spender.
281      *
282      * approve should be called when allowed[_spender] == 0. To decrement
283      * allowed value is better to use this function to avoid 2 calls (and wait until
284      * the first transaction is mined)
285      * From MonolithDAO Token.sol
286      * @param _spender The address which will spend the funds.
287      * @param _subtractedValue The amount of tokens to decrease the allowance by.
288      */
289     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
290         uint oldValue = allowed[msg.sender][_spender];
291         if (_subtractedValue > oldValue) {
292             allowed[msg.sender][_spender] = 0;
293         } else {
294             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295         }
296         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297         return true;
298     }
299 
300 }
301 
302 /**
303  * @title Pausable token
304  * @dev StandardToken modified with pausable transfers.
305  **/
306 contract PausableToken is StandardToken, Pausable {
307 
308     function transfer(address _to, uint256 _value) public whenNotPaused returns(bool) {
309         return super.transfer(_to, _value);
310     }
311 
312     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {
313         return super.transferFrom(_from, _to, _value);
314     }
315 
316     function approve(address _spender, uint256 _value) public whenNotPaused returns(bool) {
317         return super.approve(_spender, _value);
318     }
319 
320     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns(bool success) {
321         return super.increaseApproval(_spender, _addedValue);
322     }
323 
324     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns(bool success) {
325         return super.decreaseApproval(_spender, _subtractedValue);
326     }
327 }
328 
329 contract SimpleToken is PausableToken {
330     string public name;
331     string public symbol;
332 
333     uint8 public decimals = 18;
334 
335     /**
336      * @dev Fix for the ERC20 short address attack.
337      */
338     modifier onlyPayloadSize(uint size) {
339         require(!(msg.data.length < size + 4));
340         _;
341     }
342 
343     function SimpleToken(string tokenName, string tokenSymbol, uint256 initialSupply, address _owner) public {
344         name = tokenName;
345         symbol = tokenSymbol;
346         totalSupply_ = initialSupply * 10 ** uint256(decimals);
347         balances[_owner] = totalSupply_;
348         owner = _owner;
349     }
350 
351     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool) {
352         return super.transfer(_to, _value);
353     }
354 
355     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns(bool) {
356         return super.transferFrom(_from, _to, _value);
357     }
358 
359     function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool) {
360         return super.approve(_spender, _value);
361     }
362 
363     function increaseApproval(address _spender, uint _addedValue) public onlyPayloadSize(2 * 32) returns(bool) {
364         return super.increaseApproval(_spender, _addedValue);
365     }
366 
367     function decreaseApproval(address _spender, uint _subtractedValue) public onlyPayloadSize(2 * 32) returns(bool) {
368         return super.decreaseApproval(_spender, _subtractedValue);
369     }
370 }