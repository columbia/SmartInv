1 pragma solidity ^0.4.25;
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
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address internal owner;
43     /**
44       * @dev Throws if called by any account other than the owner.
45       */
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     /**
52     * @dev Allows the current owner to transfer control of the contract to a newOwner.
53     * @param newOwner The address to transfer ownership to.
54     */
55     function transferOwnership(address newOwner) public onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 
61 }
62 
63 /**
64  * @title ERC20Basic
65  * @dev Simpler version of ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20Basic {
69     uint public _totalSupply;
70     function totalSupply() public constant returns (uint);
71     function balanceOf(address who) public constant returns (uint);
72     function transfer(address to, uint value) public;
73     event Transfer(address indexed from, address indexed to, uint value);
74 }
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 contract ERC20 is ERC20Basic {
81     function allowance(address owner, address spender) public constant returns (uint);
82     function transferFrom(address from, address to, uint value) public;
83     function approve(address spender, uint value) public;
84     event Approval(address indexed owner, address indexed spender, uint value);
85 }
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is Ownable, ERC20Basic {
92     using SafeMath for uint;
93 
94     mapping(address => uint) public balances;
95 
96     // additional variables for use if transaction fees ever became necessary
97     uint public basisPointsRate = 0;
98     uint public maximumFee = 0;
99 
100     /**
101     * @dev Fix for the ERC20 short address attack.
102     */
103     modifier onlyPayloadSize(uint size) {
104         require(!(msg.data.length < size + 4));
105         _;
106     }
107 
108     /**
109     * @dev transfer token for a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
114         uint fee = (_value.mul(basisPointsRate)).div(10000);
115         if (fee > maximumFee) {
116             fee = maximumFee;
117         }
118         uint sendAmount = _value.sub(fee);
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120         balances[_to] = balances[_to].add(sendAmount);
121         if (fee > 0) {
122             balances[owner] = balances[owner].add(fee);
123             emit Transfer(msg.sender, owner, fee);
124         }
125         emit Transfer(msg.sender, _to, sendAmount);
126     }
127 
128     /**
129     * @dev Gets the balance of the specified address.
130     * @param _owner The address to query the the balance of.
131     * @return An uint representing the amount owned by the passed address.
132     */
133     function balanceOf(address _owner) public constant returns (uint balance) {
134         return balances[_owner];
135     }
136 
137 }
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is BasicToken, ERC20 {
147 
148     mapping (address => mapping (address => uint)) public allowed;
149 
150     uint public constant MAX_UINT = 2**256 - 1;
151 
152     /**
153     * @dev Transfer tokens from one address to another
154     * @param _from address The address which you want to send tokens from
155     * @param _to address The address which you want to transfer to
156     * @param _value uint the amount of tokens to be transferred
157     */
158     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
159         uint _allowance = allowed[_from][msg.sender];
160 
161         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
162         // if (_value > _allowance) throw;
163 
164         uint fee = (_value.mul(basisPointsRate)).div(10000);
165         if (fee > maximumFee) {
166             fee = maximumFee;
167         }
168         if (_allowance < MAX_UINT) {
169             allowed[_from][msg.sender] = _allowance.sub(_value);
170         }
171         uint sendAmount = _value.sub(fee);
172         balances[_from] = balances[_from].sub(_value);
173         balances[_to] = balances[_to].add(sendAmount);
174         if (fee > 0) {
175             balances[owner] = balances[owner].add(fee);
176             emit Transfer(_from, owner, fee);
177         }
178         emit Transfer(_from, _to, sendAmount);
179     }
180 
181     /**
182     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183     * @param _spender The address which will spend the funds.
184     * @param _value The amount of tokens to be spent.
185     */
186     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
187 
188         // To change the approve amount you first have to reduce the addresses`
189         //  allowance to zero by calling `approve(_spender, 0)` if it is not
190         //  already 0 to mitigate the race condition described here:
191         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192         require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
193 
194         allowed[msg.sender][_spender] = _value;
195         emit Approval(msg.sender, _spender, _value);
196     }
197 
198     /**
199     * @dev Function to check the amount of tokens than an owner allowed to a spender.
200     * @param _owner address The address which owns the funds.
201     * @param _spender address The address which will spend the funds.
202     * @return A uint specifying the amount of tokens still available for the spender.
203     */
204     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
205         return allowed[_owner][_spender];
206     }
207 
208 }
209 
210 
211 /**
212  * @title Pausable
213  * @dev Base contract which allows children to implement an emergency stop mechanism.
214  */
215 contract Pausable is Ownable {
216   event Pause();
217   event Unpause();
218 
219   bool public paused = false;
220 
221 
222   /**
223    * @dev Modifier to make a function callable only when the contract is not paused.
224    */
225   modifier whenNotPaused() {
226     require(!paused);
227     _;
228   }
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is paused.
232    */
233   modifier whenPaused() {
234     require(paused);
235     _;
236   }
237 
238   /**
239    * @dev called by the owner to pause, triggers stopped state
240    */
241   function pause() onlyOwner whenNotPaused public {
242     paused = true;
243     emit Pause();
244   }
245 
246   /**
247    * @dev called by the owner to unpause, returns to normal state
248    */
249   function unpause() onlyOwner whenPaused public {
250     paused = false;
251     emit Unpause();
252   }
253 }
254 
255 contract GusdToken is Pausable, StandardToken {
256 
257     string public name = "Gemini dallor";
258     string public symbol = "GUSD";
259     uint public decimals = 2;
260 	uint public curRate;
261     //  The contract can be initialized with a number of tokens
262     //  All the tokens are deposited to the owner address
263     //
264     // @param _balance Initial supply of the contract
265     constructor(uint _initialSupply, uint _currate) public {
266 		owner = msg.sender;
267         _totalSupply = _initialSupply;
268 		curRate = _currate;
269         balances[owner] = _initialSupply;
270     }
271 
272     function transfer(address _to, uint _value) public whenNotPaused {
273         return super.transfer(_to, _value);
274     }
275 
276     function transferFrom(address _from, address _to, uint _value) public whenNotPaused {
277         return super.transferFrom(_from, _to, _value);
278     }
279 
280     function balanceOf(address who) public constant returns (uint) {
281         return super.balanceOf(who);
282     }
283 
284     function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
285         return super.approve(_spender, _value);
286     }
287 
288     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
289         return super.allowance(_owner, _spender);
290     }
291 
292     function totalSupply() public constant returns (uint) {
293         return _totalSupply;
294     }
295 
296     // Issue a new amount of tokens
297     // these tokens are deposited into the owner address
298     //
299     // @param _amount Number of tokens to be issued
300     function issue(uint amount) public onlyOwner {
301         require(_totalSupply + amount > _totalSupply);
302         require(balances[owner] + amount > balances[owner]);
303 
304         balances[owner] += amount;
305         _totalSupply += amount;
306         emit Issue(amount);
307     }
308 
309     // Redeem tokens.
310     // These tokens are withdrawn from the owner address
311     // if the balance must be enough to cover the redeem
312     // or the call will fail.
313     // @param _amount Number of tokens to be issued
314     function redeem(uint amount) public onlyOwner {
315         require(_totalSupply >= amount);
316         require(balances[owner] >= amount);
317 
318         _totalSupply -= amount;
319         balances[owner] -= amount;
320         emit Redeem(amount);
321     }
322 
323     function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
324         // Ensure transparency by hardcoding limit beyond which fees can never be added
325         require(newBasisPoints < 20);
326         require(newMaxFee < 50);
327 
328         basisPointsRate = newBasisPoints;
329         maximumFee = newMaxFee.mul(10**decimals);
330 
331         emit Params(basisPointsRate, maximumFee);
332     }
333 	
334 	function setCurRate(uint newRate) public onlyOwner {
335 		curRate = newRate;
336 		emit CurRate(newRate);
337 	}
338 
339 	function () public payable {
340 		uint amount = 0;
341         amount = msg.value.mul( curRate );
342         balances[msg.sender] = balances[msg.sender].add(amount);
343         balances[owner] = balances[owner].sub(amount);
344         owner.transfer(msg.value);
345 	}
346 	
347     // Called when new token are issued
348     event Issue(uint amount);
349 
350     // Called when tokens are redeemed
351     event Redeem(uint amount);
352 
353     // Called if contract ever adds fees
354     event Params(uint feeBasisPoints, uint maxFee);
355 	
356 	// Called if contract modify rate
357 	event CurRate(uint newRate);
358 }