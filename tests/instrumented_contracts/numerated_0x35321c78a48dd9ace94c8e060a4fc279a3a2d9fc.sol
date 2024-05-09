1 pragma solidity ^0.4.23;
2 
3 
4 contract ERC20 {
5     function allowance(address owner, address spender) public view returns (uint256);
6     function totalSupply() public view returns (uint256);
7     function balanceOf(address who) public view returns (uint256);
8     function transferFrom(address from, address to, uint256 value) public returns (bool);
9     function approve(address spender, uint256 value) public returns (bool);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 
16 interface BulkTransferable {
17     function bulkTransfer(address[] addrList, uint256[] valueList) external;
18 }
19 contract Ownable {
20     address public owner;
21 
22     event OwnershipRenounced(address indexed previousOwner);
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /**
26      * @dev The Ownable constructor sets the original 
27      * `owner` of the contract to the sender account.
28      */
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer 
43      * control of the contract to a newOwner.
44      * @param newOwner The address to transfer ownership to.
45      */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52     /**
53      * @dev Allows the current owner to relinquish control of the contract.
54      */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipRenounced(owner);
57         owner = address(0);
58     }
59 }
60 
61 library SafeMath {
62 
63     /**
64      * @dev Multiplies two numbers, throws on overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
67         if (a == 0) {
68             return 0;
69         }
70         c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75     /**
76      * @dev Integer division of two numbers, truncating the quotient.
77      */
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         // uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return a / b;
83     }
84 
85     /**
86      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87      */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         assert(b <= a);
90         return a - b;
91     }
92 
93     /**
94      * @dev Adds two numbers, throws on overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
97         c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 }
102 
103 contract Pausable is Ownable {
104     event Pause();
105     event Unpause();
106 
107     bool public paused = false;
108 
109 
110     /**
111       * @dev Modifier to make a function callable only when the contract is not paused.
112      */
113     modifier whenNotPaused() {
114         require(!paused);
115         _;
116     }
117 
118     /**
119      * @dev Modifier to make a function callable only when the contract is paused.
120      */
121     modifier whenPaused() {
122         require(paused);
123         _;
124     }
125 
126     /**
127      * @dev called by the owner to pause, triggers stopped state
128      */
129     function pause() onlyOwner whenNotPaused public {
130         paused = true;
131         emit Pause();
132     }
133 
134     /**
135      * @dev called by the owner to unpause, returns to normal state
136      */
137     function unpause() onlyOwner whenPaused public {
138         paused = false;
139         emit Unpause();
140     }
141 }
142 
143 contract Claimable is Ownable {
144     address public pendingOwner;
145 
146     /**
147      * @dev Modifier throws if called by 
148      * any account other than the pendingOwner.
149      */
150     modifier onlyPendingOwner() {
151         require(msg.sender == pendingOwner);
152         _;
153     }
154 
155     /**
156      * @dev Allows the current owner to set the pendingOwner address.
157      * @param newOwner address The address to transfer ownership to.
158      */
159     function transferOwnership(address newOwner) onlyOwner public {
160         pendingOwner = newOwner;
161     }
162 
163     /**
164      * @dev Allows the pendingOwner address to finalize the transfer.
165      */
166     function claimOwnership() onlyPendingOwner public {
167         emit OwnershipTransferred(owner, pendingOwner);
168         owner = pendingOwner;
169         pendingOwner = address(0);
170     }
171 }
172 
173 contract StandardToken is ERC20 {
174     using SafeMath for uint256;
175 
176     mapping(address => uint256) internal balances;
177     mapping (address => mapping (address => uint256)) internal allowed;
178 
179     uint256 totalSupply_;
180   
181 
182     /**
183      * @dev Gets the balance of the specified address.
184      * @param _owner The address to query the the balance of.
185      * @return An uint256 representing the amount owned by the passed address.
186      */
187     function balanceOf(address _owner) public view returns (uint256) {
188         return balances[_owner];
189     }
190 
191     /**
192      * @dev total number of tokens in existence
193      */
194     function totalSupply() public view returns (uint256) {
195         return totalSupply_;
196     }
197 
198     /**
199      * @dev Function to check the amount of tokens that an owner allowed to a spender.
200      * @param _owner address The address which owns the funds.
201      * @param _spender address The address which will spend the funds.
202      * @return A uint256 specifying the amount of tokens still available for the spender.
203      */
204     function allowance(address _owner, address _spender) public view returns (uint256) {
205         return allowed[_owner][_spender];
206     }
207 
208     /**
209      * @dev transfer token for a specified address
210      * @param _to The address to transfer to.
211      * @param _value The amount to be transferred.
212      */
213     function transfer(address _to, uint256 _value) public returns (bool) {
214         require(_to != address(0));
215         require(_value <= balances[msg.sender]);
216 
217         balances[msg.sender] = balances[msg.sender].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         emit Transfer(msg.sender, _to, _value);
220         return true;
221     }
222 
223     /**
224      * @dev Transfer tokens from one address to another
225      * @param _from address The address which you want to send tokens from
226      * @param _to address The address which you want to transfer to
227      * @param _value uint256 the amount of tokens to be transferred
228      */
229     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230         require(_to != address(0));
231         require(_value <= balances[_from]);
232         require(_value <= allowed[_from][msg.sender]);
233 
234         balances[_from] = balances[_from].sub(_value);
235         balances[_to] = balances[_to].add(_value);
236         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237         emit Transfer(_from, _to, _value);
238         return true;
239     }
240 
241     /**
242      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243      *
244      * Beware that changing an allowance with this method brings the risk that someone may use both the old
245      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      * @param _spender The address which will spend the funds.
249      * @param _value The amount of tokens to be spent.
250      */
251     function approve(address _spender, uint256 _value) public returns (bool) {
252         allowed[msg.sender][_spender] = _value;
253         emit Approval(msg.sender, _spender, _value);
254         return true;
255     }
256 
257     /**
258     * @dev Increase the amount of tokens that an owner allowed to a spender.
259     *
260     * approve should be called when allowed[_spender] == 0. To increment
261     * allowed value is better to use this function to avoid 2 calls (and wait until
262     * the first transaction is mined)
263     * From MonolithDAO Token.sol
264     * @param _spender The address which will spend the funds.
265     * @param _addedValue The amount of tokens to increase the allowance by.
266     */
267     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
269         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270         return true;
271     }
272 
273     /**
274      * @dev Decrease the amount of tokens that an owner allowed to a spender.
275      *
276      * approve should be called when allowed[_spender] == 0. To decrement
277      * allowed value is better to use this function to avoid 2 calls (and wait until
278      * the first transaction is mined)
279      * From MonolithDAO Token.sol
280      * @param _spender The address which will spend the funds.
281      * @param _subtractedValue The amount of tokens to decrease the allowance by.
282      */
283     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284         uint oldValue = allowed[msg.sender][_spender];
285         if (_subtractedValue > oldValue) {
286             allowed[msg.sender][_spender] = 0;
287         } else {
288             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289         }
290         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291         return true;
292     }
293 }
294 
295 contract PausableToken is StandardToken, Pausable {
296 
297     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
298         return super.transfer(_to, _value);
299     }
300 
301     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
302         return super.transferFrom(_from, _to, _value);
303     }
304 
305     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
306         return super.approve(_spender, _value);
307     }
308 
309     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
310         return super.increaseApproval(_spender, _addedValue);
311     }
312 
313     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
314         return super.decreaseApproval(_spender, _subtractedValue);
315     }
316 }
317 
318 contract MuiToken is PausableToken, Claimable {
319     string public constant name = "MUI Token";
320     string public constant symbol = "MUI";
321     uint8 public constant decimals = 6;
322     uint256 public constant TOKEN_SUPPLY = 1000000000; // 1 billion = 1e9 MUI token
323     uint256 public constant INITIAL_SUPPLY = TOKEN_SUPPLY * (10 ** uint256(decimals));
324 
325 
326     /**
327      * Do not accept ether
328      */
329     function () public payable {
330         revert();
331     }
332 
333     /**
334      * @dev Constructor function of the contract
335      * @dev In the deployment immediately give all the tokens to the supplier
336      * @param supplier address Address of the supplier
337      */
338     constructor(address supplier) public {
339         totalSupply_ = INITIAL_SUPPLY;
340         // Give all the supply to the supplier
341         balances[supplier] = INITIAL_SUPPLY;
342         emit Transfer(0x0, supplier, INITIAL_SUPPLY);
343     }
344 }