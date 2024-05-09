1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-29
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender) public view returns (uint256);
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18   function approve(address spender, uint256 value) public returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 contract Context {
24     constructor () internal { }
25 
26     function _msgSender() internal view returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 library SafeMath {
37 	
38 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39 		uint256 c = a * b;
40 		assert(a == 0 || c / a == b);
41 		return c;
42 	}
43 
44 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
45 		uint256 c = a / b;
46 		return c;
47 	}
48 
49 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50 		assert(b <= a);
51 		return a - b;
52 	}
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57         return c;
58     }
59 	
60 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61 		c = a + b;
62 		assert(c >= a);
63 		return c;
64 	}
65 }
66 
67 
68 contract BasicToken is Context, ERC20{
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   uint256 totalSupply_;
75 
76  
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     emit Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _owner) public view returns (uint256) {
92     return balances[_owner];
93   }
94 
95   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[_from]);
98     require(_value <= allowed[_from][msg.sender]);
99 
100     balances[_from] = balances[_from].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103     emit Transfer(_from, _to, _value);
104     return true;
105   }
106 
107   function approve(address _spender, uint256 _value) public returns (bool) {
108     allowed[msg.sender][_spender] = _value;
109     emit Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   function allowance(address _owner, address _spender) public view returns (uint256) {
114     return allowed[_owner][_spender];
115   }
116 
117   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
118     allowed[msg.sender][_spender] = (
119       allowed[msg.sender][_spender].add(_addedValue));
120     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
125     uint oldValue = allowed[msg.sender][_spender];
126     
127     if (_subtractedValue > oldValue) {
128       allowed[msg.sender][_spender] = 0;
129     } else {
130       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131     }
132     
133     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134     return true;
135   }
136 
137    
138  function _mint(address account, uint256 amount) internal {
139     require(account != address(0), "ERC20: mint to the zero address");
140 
141     totalSupply_ = totalSupply_.add(amount);
142     balances[account] = balances[account].add(amount);
143     emit Transfer(address(0), account, amount);
144   }
145   
146   function _burn(address account, uint256 amount) internal {
147     require(account != address(0), "ERC20: burn from the zero address");
148 
149     balances[account] = balances[account].sub(amount, "ERC20: burn amount exceeds balance");
150     totalSupply_ = totalSupply_.sub(amount);
151     emit Transfer(account, address(0), amount);
152   }
153 
154   
155   function _approve(address owner, address _spender, uint256 amount) internal {
156         require(owner != address(0), "ERC20: approve from the zero address");
157         require(_spender != address(0), "ERC20: approve to the zero address");
158 
159         allowed[owner][_spender] = amount;
160         emit Approval(owner, _spender, amount);
161   }
162 
163    
164   function _burnFrom(address account, uint256 amount) internal {
165         _burn(account, amount);
166         _approve(account, msg.sender, allowed[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
167   }
168 
169 }
170 
171 contract Ownable {
172   address public owner;
173 
174 
175   event OwnershipRenounced(address indexed previousOwner);
176   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178   constructor() public {
179     owner = msg.sender;
180   }
181 
182   modifier onlyOwner() {
183     require(msg.sender == owner);
184     _;
185   }
186 
187   function transferOwnership(address newOwner) public onlyOwner {
188     require(newOwner != address(0));
189     emit OwnershipTransferred(owner, newOwner);
190     owner = newOwner;
191   }
192 
193   function renounceOwnership() public onlyOwner {
194     emit OwnershipRenounced(owner);
195     owner = address(0);
196   }
197 }
198 
199 
200 
201 contract Pausable is Ownable {
202   event Pause();
203   event Unpause();
204   event NotPausable();
205 
206   bool public paused = false;
207   bool public canPause = true;
208 
209   /**
210    * @dev Modifier to make a function callable only when the contract is not paused.
211    */
212   modifier whenNotPaused() {
213     require(!paused || msg.sender == owner);
214     _;
215   }
216 
217   /**
218    * @dev Modifier to make a function callable only when the contract is paused.
219    */
220   modifier whenPaused() {
221     require(paused);
222     _;
223   }
224 
225   /**
226      * @dev called by the owner to pause, triggers stopped state
227      **/
228     function pause() onlyOwner whenNotPaused public {
229         require(canPause == true);
230         paused = true;
231         emit Pause();
232     }
233 
234   /**
235    * @dev called by the owner to unpause, returns to normal state
236    */
237   function unpause() onlyOwner whenPaused public {
238     require(paused == true);
239     paused = false;
240     emit Unpause();
241   }
242   
243   /**
244      * @dev Prevent the token from ever being paused again
245      **/
246     function notPausable() onlyOwner public{
247         paused = false;
248         canPause = false;
249         emit NotPausable();
250     }
251 }
252 
253 
254 
255 contract Mintable is BasicToken, Ownable {
256   event Mint(address indexed to, uint256 amount);
257   event MintFinished();
258 
259   bool public mintingFinished = false;
260 
261 
262   modifier canMint() {
263     require(!mintingFinished);
264     _;
265   }
266 
267   /**
268    * @dev Function to mint tokens
269    * @param _to The address that will receive the minted tokens.
270    * @param _amount The amount of tokens to mint.
271    * @return A boolean that indicates if the operation was successful.
272    */
273   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
274     totalSupply_ = totalSupply_.add(_amount);
275     balances[_to] = balances[_to].add(_amount);
276     emit Mint(_to, _amount);
277     emit Transfer(address(0), _to, _amount);
278     return true;
279   }
280 
281   /**
282    * @dev Function to stop minting new tokens.
283    * @return True if the operation was successful.
284    */
285   function finishMinting() onlyOwner canMint public returns (bool) {
286     mintingFinished = true;
287     emit MintFinished();
288     return true;
289   }
290 }
291 
292 
293 
294 contract ERC20Burnable is Context, BasicToken {
295    
296     function burn(uint256 amount) public {
297         _burn(_msgSender(), amount);
298     }
299 
300     function burnFrom(address account, uint256 amount) public {
301         _burnFrom(account, amount);
302     }
303 }
304 
305 
306 contract ERC20Detailed is ERC20 {
307     string private _name;
308     string private _symbol;
309     uint8 private _decimals;
310 
311     constructor (string memory name, string memory symbol, uint8 decimals) public {
312         _name = name;
313         _symbol = symbol;
314         _decimals = decimals;
315     }
316 
317     function name() public view returns (string memory) {
318         return _name;
319     }
320 
321     function symbol() public view returns (string memory) {
322         return _symbol;
323     }
324 
325     function decimals() public view returns (uint8) {
326         return _decimals;
327     }
328 }
329 
330 
331 contract PausableToken is BasicToken, ERC20Detailed, Pausable, ERC20Burnable, Mintable {
332     string public constant NAME = "Mobile Blockchain Mining";
333     string public constant SYMBOL = "MBM";
334     uint256 public constant DECIMALS = 8;
335     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**8;
336 
337     /**
338      * @dev Transfer tokens when not paused
339      **/
340     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
341         return super.transfer(_to, _value);
342     }
343     
344     /**
345      * @dev transferFrom function to tansfer tokens when token is not paused
346      **/
347     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
348         return super.transferFrom(_from, _to, _value);
349     }
350     
351     /**
352      * @dev approve spender when not paused
353      **/
354     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
355         return super.approve(_spender, _value);
356     }
357     
358     /**
359      * @dev increaseApproval of spender when not paused
360      **/
361     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
362         return super.increaseApproval(_spender, _addedValue);
363     }
364     
365     /**
366      * @dev decreaseApproval of spender when not paused
367      **/
368     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
369         return super.decreaseApproval(_spender, _subtractedValue);
370     }
371     
372     /**
373    * Pausable Token Constructor
374    * @dev Create and issue tokens to msg.sender.
375    */
376    /*
377    constructor() public {
378      totalSupply_ = INITIAL_SUPPLY;
379      balances[msg.sender] = INITIAL_SUPPLY;
380    } 
381   */
382 
383     constructor () public ERC20Detailed("Mobile Blockchain Mining", "MBM", 8) {
384       
385          _mint(0xB0B95B74EdfeFC7260799E90a046Fd17e1FbF918, 1000000000 * (10 ** uint256(decimals())));
386     } 
387 }