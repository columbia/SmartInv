1 pragma solidity ^0.4.24;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a / b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Adds two numbers, throws on overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public view returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73     using SafeMath for uint256;
74     mapping(address => uint256) balances;
75     uint256 totalSupply_;
76     
77     /**
78      * @dev total number of tokens in existence
79      */
80     function totalSupply() public view returns (uint256) {
81         return totalSupply_;
82     }
83 
84     /**
85      * @dev transfer token for a specified address
86      * @param _to The address to transfer to.
87      * @param _value The amount to be transferred.
88      */
89     function transfer(address _to, uint256 _value) public returns (bool) {
90         require(_to != address(0));
91         require(_value <= balances[msg.sender]);
92 
93         balances[msg.sender] = balances[msg.sender].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         emit Transfer(msg.sender, _to, _value);
96         return true;
97     }
98 
99     /**
100      * @dev Gets the balance of the specified address.
101      * @param _owner The address to query the the balance of.
102      * @return An uint256 representing the amount owned by the passed address.
103      */
104     function balanceOf(address _owner) public view returns (uint256) {
105         return balances[_owner];
106     }
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * @dev https://github.com/ethereum/EIPs/issues/20
114  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20, BasicToken {
117     mapping (address => mapping (address => uint256)) internal allowed;
118     
119     event Burn(address _address, uint256 _value);
120     
121     /**
122      * @dev Transfer tokens from one address to another
123      * @param _from address The address which you want to send tokens from
124      * @param _to address The address which you want to transfer to
125      * @param _value uint256 the amount of tokens to be transferred
126      */
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129         require(_value <= balances[_from]);
130         require(_value <= allowed[_from][msg.sender]);
131 
132         balances[_from] = balances[_from].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135         emit Transfer(_from, _to, _value);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      *
142      * Beware that changing an allowance with this method brings the risk that someone may use both the old
143      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
144      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      * @param _spender The address which will spend the funds.
147      * @param _value The amount of tokens to be spent.
148      */
149     function approve(address _spender, uint256 _value) public returns (bool) {
150         allowed[msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Function to check the amount of tokens that an owner allowed to a spender.
157      * @param _owner address The address which owns the funds.
158      * @param _spender address The address which will spend the funds.
159      * @return A uint256 specifying the amount of tokens still available for the spender.
160      */
161     function allowance(address _owner, address _spender) public view returns (uint256) {
162         return allowed[_owner][_spender];
163     }
164 
165     /**
166      * @dev Increase the amount of tokens that an owner allowed to a spender.
167      * approve should be called when allowed[_spender] == 0. To increment
168      * allowed value is better to use this function to avoid 2 calls (and wait until
169      * the first transaction is mined)
170      * From MonolithDAO Token.sol
171      * @param _spender The address which will spend the funds.
172      * @param _addedValue The amount of tokens to increase the allowance by.
173      */
174     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179 
180     /**
181      * @dev Decrease the amount of tokens that an owner allowed to a spender.
182      * approve should be called when allowed[_spender] == 0. To decrement
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * @param _spender The address which will spend the funds.
187      * @param _subtractedValue The amount of tokens to decrease the allowance by.
188      */
189     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190         uint oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192             allowed[msg.sender][_spender] = 0;
193         } else {
194             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195         }
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199   
200     /**
201      * Destroy tokens
202      * Remove `_value` tokens from the system irreversibly
203      * @param _value the amount of money to burn
204      */
205     function burn(uint256 _value) public returns (bool success) {
206         require(balances[msg.sender] >= _value);                 // Check if the sender has enough
207         balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
208         totalSupply_ = totalSupply_.sub(_value);                 // Updates totalSupply
209         emit Burn(msg.sender, _value);
210         return true;
211     }
212 
213     /**
214      * Destroy tokens from other account
215      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216      * @param _from the address of the sender
217      * @param _value the amount of money to burn
218      */
219     function burnFrom(address _from, uint256 _value) public returns (bool success) {
220         require(balances[_from] >= _value);                // Check if the targeted balance is enough
221         require(_value <= allowed[_from][msg.sender]);    // Check allowance
222         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
223         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
224         totalSupply_ = totalSupply_.sub(_value);                              // Update totalSupply
225         emit Burn(_from, _value);
226         return true;
227     }
228 }
229 
230 /**
231  * @title Ownable
232  * @dev The Ownable contract has an owner address, and provides basic authorization control
233  * functions, this simplifies the implementation of "user permissions".
234  */
235 contract Ownable {
236     address public owner;
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238   
239     constructor() public {
240         owner = msg.sender;
241     }
242     
243     /**
244      * @dev Throws if called by any account other than the owner.
245      */
246     modifier onlyOwner() {
247         require(msg.sender == owner);
248         _;
249     }
250 
251     /**
252      * @dev Allows the current owner to transfer control of the contract to a newOwner.
253      * @param newOwner The address to transfer ownership to.
254      */
255     function transferOwnership(address newOwner) public onlyOwner {
256         require(newOwner != address(0)); 
257         owner = newOwner;
258         emit OwnershipTransferred(owner, newOwner);
259     }
260 }
261 
262 
263 /**
264  * @title VTest
265  * @dev Token that implements the erc20 interface
266  */
267 contract VTest is StandardToken, Ownable {
268     address public icoAccount       = address(0x8Df21F9e41Dd7Bd681fcB6d49248f897595a5304);  // ICO Token holder
269 	address public marketingAccount = address(0x83313B9c27668b41151509a46C1e2a8140187362);  // Marketing Token holder
270 	address public advisorAccount   = address(0xB6763FeC658338A7574a796Aeda45eb6D81E69B9);  // Advisor Token holder
271 	mapping(address => bool) public owners;
272 	
273 	string public name   = "VTest";  // set Token name
274 	string public symbol = "VT";       // set Token symbol
275 	uint public decimals = 18;
276 	uint public INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));  // set Token total supply
277 	
278 	mapping(address => bool) public icoProceeding; // ico manage
279 	
280 	bool public released      = false;   // all lock
281     uint8 public transferStep = 0;       // avail step
282 	bool public stepLockCheck = true;    // step lock
283     mapping(uint8 => mapping(address => bool)) public holderStep; // holder step
284 	
285 	event ReleaseToken(address _owner, bool released);
286 	event ChangeTransferStep(address _owner, uint8 newStep);
287 	
288 	/**
289      * Constructor function
290      * Initializes contract with initial supply tokens to the creator of the contract
291      */ 
292 	constructor() public {
293 	    require(msg.sender != address(0));
294 		totalSupply_ = INITIAL_SUPPLY;      // Set total supply
295 		balances[msg.sender] = INITIAL_SUPPLY;
296 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
297 		
298 		super.transfer(icoAccount, INITIAL_SUPPLY.mul(45).div(100));       // 45% allocation to ICO account
299 		super.transfer(marketingAccount, INITIAL_SUPPLY.mul(15).div(100)); // 15% allocation to Marketing account
300 		super.transfer(advisorAccount, INITIAL_SUPPLY.mul(10).div(100));   // 10% allocation to Advisor account
301 		
302 		
303 		// set owners
304 		owners[msg.sender] = true;
305 		owners[icoAccount] = true;
306 		owners[marketingAccount] = true;
307 		owners[advisorAccount] = true;
308 		
309 		holderStep[0][msg.sender] = true;
310 		holderStep[0][icoAccount] = true;
311 		holderStep[0][marketingAccount] = true;
312 		holderStep[0][advisorAccount] = true;
313     }	
314 	/**
315      * ICO list management
316      */
317 	function registIcoAddress(address _icoAddress) onlyOwner public {
318 	    require(_icoAddress != address(0));
319 	    require(!icoProceeding[_icoAddress]);
320 	    icoProceeding[_icoAddress] = true;
321 	}
322 	function unregisttIcoAddress(address _icoAddress) onlyOwner public {
323 	    require(_icoAddress != address(0));
324 	    require(icoProceeding[_icoAddress]);
325 	    icoProceeding[_icoAddress] = false;
326 	}
327 	/**
328      * Token lock management
329      */
330 	function releaseToken() onlyOwner public {
331 	    require(!released);
332 	    released = true;
333 	    emit ReleaseToken(msg.sender, released);
334 	}
335 	function lockToken() onlyOwner public {
336 		require(released);
337 		released = false;
338 		emit ReleaseToken(msg.sender, released); 
339 	}	
340 	function changeTransferStep(uint8 _changeStep) onlyOwner public {
341 	    require(transferStep != _changeStep);
342 	    require(_changeStep >= 0 && _changeStep < 10);
343         transferStep = _changeStep;
344         emit ChangeTransferStep(msg.sender, _changeStep);
345 	}
346 	function changeTransferStepLock(bool _stepLock) onlyOwner public {
347 	    require(stepLockCheck != _stepLock);
348 	    stepLockCheck = _stepLock;
349 	}
350 	
351 	/**
352      * Check the token and step lock
353      */
354 	modifier onlyReleased() {
355 	    require(released);
356 	    _;
357 	}
358 	modifier onlyStepUnlock(address _funderAddr) {
359 	    if (!owners[_funderAddr]) {
360 	        if (stepLockCheck) {
361     		    require(checkHolderStep(_funderAddr));
362 	        }    
363 	    }
364 	    _;
365 	}
366 	
367 	/**
368      * Regist holder step
369      */
370     function registHolderStep(address _contractAddr, uint8 _icoStep, address _funderAddr) public returns (bool) {
371 		require(icoProceeding[_contractAddr]);
372 		require(_icoStep > 0);
373         holderStep[_icoStep][_funderAddr] = true;
374         
375         return true;
376     }
377 	/**
378      * Check the funder step lock
379      */
380 	function checkHolderStep(address _funderAddr) public view returns (bool) {
381 		bool returnBool = false;        
382         for (uint8 i = transferStep; i >= 1; i--) {
383             if (holderStep[i][_funderAddr]) {
384                 returnBool = true;
385                 break;
386             }
387         }
388 		return returnBool;
389 	}
390 	
391 	
392 	/**
393 	 * Override ERC20 interface funtion, To verify token release
394 	 */
395 	function transfer(address to, uint256 value) public onlyReleased onlyStepUnlock(msg.sender) returns (bool) {
396 	    return super.transfer(to, value);
397     }
398     function allowance(address owner, address spender) public onlyReleased view returns (uint256) {
399         return super.allowance(owner,spender);
400     }
401     function transferFrom(address from, address to, uint256 value) public onlyReleased onlyStepUnlock(msg.sender) returns (bool) {
402         
403         return super.transferFrom(from, to, value);
404     }
405     function approve(address spender, uint256 value) public onlyReleased returns (bool) {
406         return super.approve(spender,value);
407     }
408 	// Only the owner can manage burn function
409 	function burn(uint256 _value) public onlyOwner returns (bool success) {
410 		return super.burn(_value);
411 	}
412 	function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
413 		return super.burnFrom(_from, _value);
414 	}
415 	
416     function transferSoldToken(address _contractAddr, address _to, uint256 _value) public returns(bool) {
417 	    require(icoProceeding[_contractAddr]);
418 	    require(balances[icoAccount] >= _value);
419 	    balances[icoAccount] = balances[icoAccount].sub(_value);
420         balances[_to] = balances[_to].add(_value);
421         emit Transfer(icoAccount, _to, _value);
422         return true;
423 	}
424 	function transferBonusToken(address _to, uint256 _value) public onlyOwner returns(bool) {
425 	    require(balances[icoAccount] >= _value);
426 	    balances[icoAccount] = balances[icoAccount].sub(_value);
427         balances[_to] = balances[_to].add(_value);
428         emit Transfer(icoAccount, _to, _value);
429 		return true;
430 	}
431 	function transferAdvisorToken(address _to, uint256 _value)  public onlyOwner returns (bool) {
432 	    require(balances[advisorAccount] >= _value);
433 	    balances[advisorAccount] = balances[advisorAccount].sub(_value);
434 		balances[_to] = balances[_to].add(_value);
435 		emit Transfer(advisorAccount, _to, _value);
436 		return true;
437 	}
438 }