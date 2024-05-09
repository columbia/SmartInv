1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39 
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 
72 }
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79     event Pause();
80     event Unpause();
81 
82     bool public paused = false;
83 
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is not paused.
87      */
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     /**
94      * @dev Modifier to make a function callable only when the contract is paused.
95      */
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100 
101     /**
102      * @dev called by the owner to pause, triggers stopped state
103      */
104     function pause() onlyOwner whenNotPaused public {
105         paused = true;
106         Pause();
107     }
108 
109     /**
110      * @dev called by the owner to unpause, returns to normal state
111      */
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         Unpause();
115     }
116 }
117 
118 contract ERC20Basic {
119     uint256 public totalSupply;
120 
121     function balanceOf(address who) public view returns (uint256);
122 
123     function transfer(address to, uint256 value) public returns (bool);
124 
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 
129 contract ERC20 is ERC20Basic {
130     function allowance(address owner, address spender) public view returns (uint256);
131 
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133 
134     function approve(address spender, uint256 value) public returns (bool);
135 
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 contract BasicToken is ERC20Basic {
140     using SafeMath for uint256;
141 
142     mapping(address => uint256) balances;
143 
144     /**
145     * @dev transfer token for a specified address
146     * @param _to The address to transfer to.
147     * @param _value The amount to be transferred.
148     */
149     function transfer(address _to, uint256 _value) public returns (bool) {
150         require(_to != address(0));
151         require(_value <= balances[msg.sender]);
152 
153         // SafeMath.sub will throw if there is not enough balance.
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         Transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Gets the balance of the specified address.
162     * @param _owner The address to query the the balance of.
163     * @return An uint256 representing the amount owned by the passed address.
164     */
165     function balanceOf(address _owner) public view returns (uint256 balance) {
166         return balances[_owner];
167     }
168 
169 }
170 
171 contract StandardToken is ERC20, BasicToken {
172 
173     mapping(address => mapping(address => uint256)) internal allowed;
174 
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amount of tokens to be transferred
181      */
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183         require(_to != address(0));
184         require(_value <= balances[_from]);
185         require(_value <= allowed[_from][msg.sender]);
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190         Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196      *
197      * Beware that changing an allowance with this method brings the risk that someone may use both the old
198      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      * @param _spender The address which will spend the funds.
202      * @param _value The amount of tokens to be spent.
203      */
204     function approve(address _spender, uint256 _value) public returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206         Approval(msg.sender, _spender, _value);
207         return true;
208     }
209 
210     /**
211      * @dev Function to check the amount of tokens that an owner allowed to a spender.
212      * @param _owner address The address which owns the funds.
213      * @param _spender address The address which will spend the funds.
214      * @return A uint256 specifying the amount of tokens still available for the spender.
215      */
216     function allowance(address _owner, address _spender) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     /**
221      * approve should be called when allowed[_spender] == 0. To increment
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      */
226     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233         uint oldValue = allowed[msg.sender][_spender];
234         if (_subtractedValue > oldValue) {
235             allowed[msg.sender][_spender] = 0;
236         } else {
237             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238         }
239         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243 }
244 
245 contract PausableToken is StandardToken, Pausable {
246 
247     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
248         return super.transfer(_to, _value);
249     }
250 
251     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
252         return super.transferFrom(_from, _to, _value);
253     }
254 
255     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
256         return super.approve(_spender, _value);
257     }
258 
259     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
260         return super.increaseApproval(_spender, _addedValue);
261     }
262 
263     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
264         return super.decreaseApproval(_spender, _subtractedValue);
265     }
266 }
267 
268 contract TokenImpl is PausableToken {
269     string public name;
270     string public symbol;
271 
272     uint8 public decimals = 5;
273     uint256 private decimal_num = 100000;
274 
275     // cap of money in eth * decimal_num
276     uint256 public cap;
277 
278     bool public canBuy = true;
279 
280     event NewProject(string name, string symbol, uint256 cap);
281     event Mint(address indexed to, uint256 amount);
282     event IncreaseCap(uint256 cap, int256 cap_inc);
283     event PauseBuy();
284     event UnPauseBuy();
285 
286 
287     function TokenImpl(string _name, string _symbol, uint256 _cap) public {
288         require(_cap > 0);
289         name = _name;
290         symbol = _symbol;
291         cap = _cap.mul(decimal_num);
292     }
293 
294     function newProject(string _name, string _symbol, uint256 _cap) public onlyOwner {
295         require(_cap > 0);
296         name = _name;
297         symbol = _symbol;
298         cap = _cap.mul(decimal_num);
299         NewProject(name, symbol, cap);
300     }
301 
302     // fallback function can be used to buy tokens
303     function() external payable {
304         buyTokens(msg.sender);
305     }
306 
307     // low level token purchase function
308     function buyTokens(address beneficiary) public payable {
309         require(canBuy && msg.value >= (0.00001 ether));
310         require(beneficiary != address(0));
311 
312         uint256 _amount = msg.value.mul(decimal_num).div(1 ether);
313         totalSupply = totalSupply.add(_amount);
314         require(totalSupply <= cap);
315         balances[beneficiary] = balances[beneficiary].add(_amount);
316         Mint(beneficiary, _amount);
317         Transfer(address(0), beneficiary, _amount);
318 
319         // send ether to the fund collection wallet
320         owner.transfer(msg.value);
321     }
322 
323     function saleRatio() public view returns (uint256 ratio) {
324         if (cap == 0) {
325             return 0;
326         } else {
327             return totalSupply.mul(10000).div(cap);
328         }
329     }
330 
331     function pauseBuy() onlyOwner public {
332         canBuy = false;
333         PauseBuy();
334     }
335 
336     function unPauseBuy() onlyOwner public {
337         canBuy = true;
338         UnPauseBuy();
339     }
340 
341     // increase the amount of eth
342     function increaseCap(int256 _cap_inc) onlyOwner public {
343         require(_cap_inc != 0);
344         if (_cap_inc > 0) {
345             cap = cap.add(decimal_num.mul(uint256(_cap_inc)));
346         } else {
347             uint256 _dec = uint256(- 1 * _cap_inc);
348             uint256 cap_dec = decimal_num.mul(_dec);
349             if (cap_dec >= cap - totalSupply) {
350                 cap = totalSupply;
351             } else {
352                 cap = cap.sub(cap_dec);
353             }
354         }
355         IncreaseCap(cap, _cap_inc);
356     }
357 
358     function destroy() onlyOwner public {
359         selfdestruct(owner);
360     }
361 
362 }