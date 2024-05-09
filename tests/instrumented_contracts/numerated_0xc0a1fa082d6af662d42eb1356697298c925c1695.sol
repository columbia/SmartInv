1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   	/**
10   	 * @dev Multiplies two numbers, throws on overflow.
11   	*/
12   	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     	// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     	// benefit is lost if 'b' is also tested.
15     	// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     	if (_a == 0) {
17       		return 0;
18     	}
19 
20     	uint256 c = _a * _b;
21     	assert(c / _a == _b);
22 
23     	return c;
24   	}
25 
26   	/**
27   	 * @dev Integer division of two numbers, truncating the quotient.
28   	 */
29   	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     	// assert(_b > 0); // Solidity automatically throws when dividing by 0
31     	uint256 c = _a / _b;
32     	// assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     	return c;
35   	}
36 
37   	/**
38   	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   	 */
40   	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     	assert(_b <= _a);
42     	uint256 c = _a - _b;
43 
44     	return c;
45   	}
46 
47   	/**
48   	 * @dev Adds two numbers, throws on overflow.
49   	 */
50   	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     	uint256 c = _a + _b;
52     	assert(c >= _a);
53 
54     	return c;
55   	}
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of ""user permissions"".
62  */
63 contract Ownable {
64 
65     address public owner;
66 
67     address internal newOwner;
68 
69     event OwnerUpdate(address _prevOwner, address _newOwner);
70 
71   	/**
72    	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    	 * account.
74    	 */
75     constructor() public {
76         owner = msg.sender;
77         newOwner = address(0);
78     }
79 
80   	/**
81    	 * @dev Throws if called by any account other than the owner.
82    	 */
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     /*
89      * @dev Change the owner.
90      * @param _newOwner The new owner.
91      */
92     function changeOwner(address _newOwner) public onlyOwner {
93         require(_newOwner != owner);
94         newOwner = _newOwner;
95     }
96 
97     /*
98      * @dev Accept the ownership.
99      */
100     function acceptOwnership() public {
101         require(msg.sender == newOwner);
102         
103         emit OwnerUpdate(owner, newOwner);
104         owner = newOwner;
105         newOwner = address(0);
106     }
107 }
108 
109 /**
110  * @title Pausable
111  * @dev Base contract which allows children to implement an emergency stop mechanism.
112  */
113 contract Pausable is Ownable {
114   	event Pause();
115   	event Unpause();
116 
117   	bool public paused = false;
118 
119 
120   	/**
121    	 * @dev Modifier to make a function callable only when the contract is not paused.
122    	 */
123   	modifier whenNotPaused() {
124     	require(!paused);
125     	_;
126   	}
127 
128   	/**
129    	 * @dev Modifier to make a function callable only when the contract is paused.
130    	 */
131   	modifier whenPaused() {
132     	require(paused);
133     	_;
134   	}
135 
136   	/**
137    	 * @dev called by the owner to pause, triggers stopped state
138    	 */
139   	function pause() public onlyOwner whenNotPaused {
140     	paused = true;
141     	emit Pause();
142   	}
143 
144   	/**
145    	 * @dev called by the owner to unpause, returns to normal state
146    	 */
147   	function unpause() public onlyOwner whenPaused {
148     	paused = false;
149     	emit Unpause();
150   	}
151 }
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 {
158   	function totalSupply() public view returns (uint256);
159 
160   	function balanceOf(address _who) public view returns (uint256);
161 
162   	function allowance(address _owner, address _spender) public view returns (uint256);
163 
164   	function transfer(address _to, uint256 _value) public returns (bool);
165 
166   	function approve(address _spender, uint256 _value) public returns (bool);
167 
168   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
169 
170   	event Transfer(address indexed from, address indexed to, uint256 value);
171 
172   	event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * https://github.com/ethereum/EIPs/issues/20
180  */
181 contract StandardToken is ERC20, Pausable {
182 	
183     using SafeMath for uint256;
184     
185     mapping(address => uint256) balances;
186     
187     mapping(address => mapping(address => uint256)) internal allowed;
188     
189     uint256 totalSupply_;
190     
191   	/**
192      * @dev Total number of tokens in existence
193      */
194   	function totalSupply() public view returns (uint256) {
195     	return totalSupply_;
196   	}    
197     
198   	/**
199   	 * @dev Gets the balance of the specified address.
200   	 * @param _owner The address to query the the balance of.
201   	 * @return An uint256 representing the amount owned by the passed address.
202   	 */    
203     function balanceOf(address _owner) public view returns (uint256) {
204         return balances[_owner];
205     }
206     
207   	/**
208    	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    	 * @param _owner address The address which owns the funds.
210    	 * @param _spender address The address which will spend the funds.
211    	 * @return A uint256 specifying the amount of tokens still available for the spender.
212    	 */    
213     function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216     
217   	/**
218   	 * @dev Transfer token for a specified address
219   	 * @param _to The address to transfer to.
220   	 * @param _value The amount to be transferred.
221   	 */    
222     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
223     	require(_value <= balances[msg.sender]);
224     	require(_to != address(0));
225     
226         balances[msg.sender] = balances[msg.sender].sub(_value);
227         balances[_to] = balances[_to].add(_value);
228         emit Transfer(msg.sender, _to, _value);
229         return true;
230     }
231 
232   	/**
233    	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    	 * @param _spender The address which will spend the funds.
239    	 * @param _value The amount of tokens to be spent.
240    	 */
241     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
242         allowed[msg.sender][_spender] = _value;
243         emit Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 
247   	/**
248    	 * @dev Transfer tokens from one address to another
249    	 * @param _from address The address which you want to send tokens from
250    	 * @param _to address The address which you want to transfer to
251    	 * @param _value uint256 the amount of tokens to be transferred
252    	 */
253     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
254 	    require(_value <= balances[_from]);
255 	    require(_value <= allowed[_from][msg.sender]);
256 	    require(_to != address(0));    	
257 
258         balances[_from] = balances[_from].sub(_value);
259         balances[_to] = balances[_to].add(_value);
260         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261         emit Transfer(_from, _to, _value);
262         return true;
263     }
264 
265 	/**
266    	 * @dev Increase the amount of tokens that an owner allowed to a spender.
267    	 * approve should be called when allowed[_spender] == 0. To increment
268    	 * allowed value is better to use this function to avoid 2 calls (and wait until
269    	 * the first transaction is mined)
270    	 * From MonolithDAO Token.sol
271    	 * @param _spender The address which will spend the funds.
272    	 * @param _addedValue The amount of tokens to increase the allowance by.
273    	 */
274     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
275         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
276         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277         return true;
278     }
279 
280   	/**
281    	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    	 * approve should be called when allowed[_spender] == 0. To decrement
283    	 * allowed value is better to use this function to avoid 2 calls (and wait until
284    	 * the first transaction is mined)
285    	 * From MonolithDAO Token.sol
286    	 * @param _spender The address which will spend the funds.
287    	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    	 */
289     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
290     	uint256 oldValue = allowed[msg.sender][_spender];
291         if (_subtractedValue >= oldValue) {
292             allowed[msg.sender][_spender] = 0;
293         } else {
294             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295         }
296 
297         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298         return true;
299     }
300 
301   	/**
302    	 * @dev Decrease the amount of tokens that an owner allowed to a spender by spender self.
303    	 * approve should be called when allowed[msg.sender] == 0. To decrement
304    	 * allowed value is better to use this function to avoid 2 calls (and wait until
305    	 * the first transaction is mined)
306    	 * From MonolithDAO Token.sol
307    	 * @param _from The address which will transfer the funds from.
308    	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
309    	 */
310     function spenderDecreaseApproval(address _from, uint256 _subtractedValue) public whenNotPaused returns (bool) {
311     	uint256 oldValue = allowed[_from][msg.sender];
312         if (_subtractedValue >= oldValue) {
313             allowed[_from][msg.sender] = 0;
314         } else {
315             allowed[_from][msg.sender] = oldValue.sub(_subtractedValue);
316         }
317 
318         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
319         return true;
320     }
321 }
322 
323 /**
324  * @title BCL token.
325  * @dev Issued by blockchainlock.io
326  */
327 contract BCLToken is StandardToken {
328     string public name = "Blockchainlock Token";
329     string public symbol = "BCL";
330     uint8 public decimals = 18;
331 
332   	/**
333    	 * @dev The BCLToken constructor
334    	 */
335     constructor() public {
336         totalSupply_ = 360 * (10**26);			// 36 billions
337         balances[msg.sender] = totalSupply_; 	// Give the creator all initial tokens
338     }
339 }