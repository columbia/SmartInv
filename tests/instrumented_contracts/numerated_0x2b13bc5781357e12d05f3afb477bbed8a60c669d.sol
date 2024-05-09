1 // this code is basic token with pausable
2     pragma solidity ^0.5.0;
3     
4     /**
5      * @title ERC20Basic
6      * @dev Simpler version of ERC20 interface
7      * @dev see https://github.com/ethereum/EIPs/issues/179
8      */
9     contract ERC20Basic {
10       function totalSupply() public view returns (uint256);
11       function balanceOf(address who) public view returns (uint256);
12       function transfer(address to, uint256 value) public returns (bool);
13       event Transfer(address indexed from, address indexed to, uint256 value);
14     }
15     
16     /**
17      * @title ERC20 interface
18      * @dev see https://github.com/ethereum/EIPs/issues/20
19      */
20     contract ERC20 is ERC20Basic {
21       function allowance(address owner, address spender) public view returns (uint256);
22       function transferFrom(address from, address to, uint256 value) public returns (bool);
23       function approve(address spender, uint256 value) public returns (bool);
24       event Approval(address indexed owner, address indexed spender, uint256 value);
25     }
26     
27     /**
28      * @title SafeMath
29      * @dev Math operations with safety checks that throw on error
30      * @notice https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
31      */
32     library SafeMath {
33     	/**
34     	 * SafeMath mul function
35     	 * @dev function for safe multiply, throws on overflow.
36     	 **/
37     	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     		uint256 c = a * b;
39     		assert(a == 0 || c / a == b);
40     		return c;
41     	}
42     
43     	/**
44     	 * SafeMath div funciotn
45     	 * @dev function for safe devide, throws on overflow.
46     	 **/
47     	function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     		uint256 c = a / b;
49     		return c;
50     	}
51     
52     	/**
53     	 * SafeMath sub function
54     	 * @dev function for safe subtraction, throws on overflow.
55     	 **/
56     	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     		assert(b <= a);
58     		return a - b;
59     	}
60     	
61     	/**
62     	 * SafeMath add function
63     	 * @dev Adds two numbers, throws on overflow.
64     	 */
65     	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     		c = a + b;
67     		assert(c >= a);
68     		return c;
69     	}
70     }
71     
72     /**
73      * @title Basic token
74      * @dev Basic version of StandardToken, with no allowances.
75      */
76     contract BasicToken is ERC20Basic {
77       using SafeMath for uint256;
78     
79       mapping(address => uint256) balances;
80     
81       uint256 totalSupply_;
82     
83       /**
84       * @dev total number of tokens in existence
85       */
86       function totalSupply() public view returns (uint256) {
87         return totalSupply_;
88       }
89     
90       /**
91       * @dev transfer token for a specified address
92       * @param _to The address to transfer to.
93       * @param _value The amount to be transferred.
94       */
95       function transfer(address _to, uint256 _value) public returns (bool) {
96         require(_to != address(0));
97         require(_value <= balances[msg.sender]);
98     
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         emit Transfer(msg.sender, _to, _value);
102         return true;
103       }
104     
105       /**
106       * @dev Gets the balance of the specified address.
107       * @param _owner The address to query the the balance of.
108       * @return An uint256 representing the amount owned by the passed address.
109       */
110       function balanceOf(address _owner) public view returns (uint256) {
111         return balances[_owner];
112       }
113     
114     }
115     
116     /**
117      * @title Standard ERC20 token
118      *
119      * @dev Implementation of the basic standard token.
120      * @dev https://github.com/ethereum/EIPs/issues/20
121      * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122      */
123     contract StandardToken is ERC20, BasicToken {
124     
125       mapping (address => mapping (address => uint256)) internal allowed;
126     
127       /**
128        * @dev Transfer tokens from one address to another
129        * @param _from address The address which you want to send tokens from
130        * @param _to address The address which you want to transfer to
131        * @param _value uint256 the amount of tokens to be transferred
132        */
133       function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[_from]);
136         require(_value <= allowed[_from][msg.sender]);
137     
138         balances[_from] = balances[_from].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141         emit Transfer(_from, _to, _value);
142         return true;
143       }
144     
145       /**
146        * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147        *
148        * Beware that changing an allowance with this method brings the risk that someone may use both the old
149        * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150        * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151        * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152        * @param _spender The address which will spend the funds.
153        * @param _value The amount of tokens to be spent.
154        */
155       function approve(address _spender, uint256 _value) public returns (bool) {
156         allowed[msg.sender][_spender] = _value;
157         emit Approval(msg.sender, _spender, _value);
158         return true;
159       }
160     
161       /**
162        * @dev Function to check the amount of tokens that an owner allowed to a spender.
163        * @param _owner address The address which owns the funds.
164        * @param _spender address The address which will spend the funds.
165        * @return A uint256 specifying the amount of tokens still available for the spender.
166        */
167       function allowance(address _owner, address _spender) public view returns (uint256) {
168         return allowed[_owner][_spender];
169       }
170     
171       /**
172        * @dev Increase the amount of tokens that an owner allowed to a spender.
173        *
174        * approve should be called when allowed[_spender] == 0. To increment
175        * allowed value is better to use this function to avoid 2 calls (and wait until
176        * the first transaction is mined)
177        * From MonolithDAO Token.sol
178        * @param _spender The address which will spend the funds.
179        * @param _addedValue The amount of tokens to increase the allowance by.
180        */
181       function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182         allowed[msg.sender][_spender] = (
183           allowed[msg.sender][_spender].add(_addedValue));
184         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186       }
187     
188       /**
189        * @dev Decrease the amount of tokens that an owner allowed to a spender.
190        *
191        * approve should be called when allowed[_spender] == 0. To decrement
192        * allowed value is better to use this function to avoid 2 calls (and wait until
193        * the first transaction is mined)
194        * From MonolithDAO Token.sol
195        * @param _spender The address which will spend the funds.
196        * @param _subtractedValue The amount of tokens to decrease the allowance by.
197        */
198       function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199         uint oldValue = allowed[msg.sender][_spender];
200         
201         if (_subtractedValue > oldValue) {
202           allowed[msg.sender][_spender] = 0;
203         } else {
204           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205         }
206         
207         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209       }
210     
211     }
212     
213     /**
214      * @title Ownable
215      * @dev The Ownable contract has an owner address, and provides basic authorization control
216      * functions, this simplifies the implementation of "user permissions".
217      */
218     contract Ownable {
219       address public owner;
220     
221     
222       event OwnershipRenounced(address indexed previousOwner);
223       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224     
225     
226       /**
227        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228        * account.
229        */
230       constructor() public {
231         owner = msg.sender;
232       }
233     
234       /**
235        * @dev Throws if called by any account other than the owner.
236        */
237       modifier onlyOwner() {
238         require(msg.sender == owner);
239         _;
240       }
241     
242       /**
243        * @dev Allows the current owner to transfer control of the contract to a newOwner.
244        * @param newOwner The address to transfer ownership to.
245        */
246       function transferOwnership(address newOwner) public onlyOwner {
247         require(newOwner != address(0));
248         emit OwnershipTransferred(owner, newOwner);
249         owner = newOwner;
250       }
251     
252       /**
253        * @dev Allows the current owner to relinquish control of the contract.
254        */
255       function renounceOwnership() public onlyOwner {
256         emit OwnershipRenounced(owner);
257         owner = address(0);
258       }
259     }
260     
261     /**
262      * @title Pausable
263      * @dev Base contract which allows children to implement an emergency stop mechanism.
264      */
265     contract Pausable is Ownable {
266       event Pause();
267       event Unpause();
268       event NotPausable();
269     
270       bool public paused = false;
271       bool public canPause = true;
272     
273       /**
274        * @dev Modifier to make a function callable only when the contract is not paused.
275        */
276       modifier whenNotPaused() {
277         require(!paused || msg.sender == owner);
278         _;
279       }
280     
281       /**
282        * @dev Modifier to make a function callable only when the contract is paused.
283        */
284       modifier whenPaused() {
285         require(paused);
286         _;
287       }
288     
289       /**
290          * @dev called by the owner to pause, triggers stopped state
291          **/
292         function pause() onlyOwner whenNotPaused public {
293             require(canPause == true);
294             paused = true;
295             emit Pause();
296         }
297     
298       /**
299        * @dev called by the owner to unpause, returns to normal state
300        */
301       function unpause() onlyOwner whenPaused public {
302         require(paused == true);
303         paused = false;
304         emit Unpause();
305       }
306       
307       /**
308          * @dev Prevent the token from ever being paused again
309          **/
310         function notPausable() onlyOwner public{
311             paused = false;
312             canPause = false;
313             emit NotPausable();
314         }
315     }
316     
317     /**
318      * @title Pausable token
319      * @dev StandardToken modified with pausable transfers.
320      **/
321     contract PausableToken is StandardToken, Pausable {
322         string public constant NAME = "KAKI TOKEN";
323         string public constant SYMBOL = "KAKI";
324         uint256 public constant DECIMALS = 18;
325         uint256 public constant INITIAL_SUPPLY = 2000000000 * 10**18;
326     
327         /**
328          * @dev Transfer tokens when not paused
329          **/
330         function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
331             return super.transfer(_to, _value);
332         }
333         
334         /**
335          * @dev transferFrom function to tansfer tokens when token is not paused
336          **/
337         function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
338             return super.transferFrom(_from, _to, _value);
339         }
340         
341         /**
342          * @dev approve spender when not paused
343          **/
344         function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
345             return super.approve(_spender, _value);
346         }
347         
348         /**
349          * @dev increaseApproval of spender when not paused
350          **/
351         function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
352             return super.increaseApproval(_spender, _addedValue);
353         }
354         
355         /**
356          * @dev decreaseApproval of spender when not paused
357          **/
358         function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
359             return super.decreaseApproval(_spender, _subtractedValue);
360         }
361         
362         /**
363        * Pausable Token Constructor
364        * @dev Create and issue tokens to msg.sender.
365        */
366       constructor() public {
367         totalSupply_ = INITIAL_SUPPLY;
368         balances[msg.sender] = INITIAL_SUPPLY;
369       } 
370     }