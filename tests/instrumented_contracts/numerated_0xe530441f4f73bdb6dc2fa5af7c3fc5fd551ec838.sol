1 pragma solidity ^0.4.21;
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
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0));
70         owner = newOwner;
71         emit OwnershipTransferred(owner, newOwner);
72     }
73 }
74 
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81     event Pause();
82     event Unpause();
83 
84     bool public paused = false;
85 
86 
87     /**
88      * @dev Modifier to make a function callable only when the contract is not paused.
89      */
90     modifier whenNotPaused() {
91         require(!paused);
92         _;
93     }
94 
95     /**
96      * @dev Modifier to make a function callable only when the contract is paused.
97      */
98     modifier whenPaused() {
99         require(paused);
100         _;
101     }
102 
103     /**
104      * @dev called by the owner to pause, triggers stopped state
105      */
106     function pause() onlyOwner whenNotPaused public {
107         paused = true;
108         emit Pause();
109     }
110 
111     /**
112      * @dev called by the owner to unpause, returns to normal state
113      */
114     function unpause() onlyOwner whenPaused public {
115         paused = false;
116         emit Unpause();
117     }
118 }
119 
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127     uint256 public totalSupply;
128 
129     function balanceOf(address who) public view returns (uint256);
130 
131     function transfer(address to, uint256 value) public returns (bool);
132 
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142     function allowance(address owner, address spender) public view returns (uint256);
143 
144     function transferFrom(address from, address to, uint256 value) public returns (bool);
145 
146     function approve(address spender, uint256 value) public returns (bool);
147 
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 /**
153  * @title Basic token
154  * @dev Basic version of StandardToken, with no allowances.
155  */
156 contract BasicToken is ERC20Basic, Pausable {
157     using SafeMath for uint256;
158 
159     mapping(address => uint256) balances;
160 
161     /**
162     * @dev transfer token for a specified address
163     * @param _to The address to transfer to.
164     * @param _value The amount to be transferred.
165     */
166     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[msg.sender]);
169         require(_value > 0);
170         require(balances[_to] + _value > balances[_to]);
171 
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         emit Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     /**
179     * @dev Gets the balance of the specified address.
180     * @param _owner The address to query the the balance of.
181     * @return An uint256 representing the amount owned by the passed address.
182     */
183     function balanceOf(address _owner) public view returns (uint256) {
184         return balances[_owner];
185     }
186 }
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198     mapping(address => mapping(address => uint256)) internal allowed;
199 
200     /**
201      * @dev Transfer tokens from one address to another
202      * @param _from address The address which you want to send tokens from
203      * @param _to address The address which you want to transfer to
204      * @param _value uint256 the amount of tokens to be transferred
205      */
206     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
207         require(_to != address(0));
208         require(_value <= balances[_from]);
209         require(_value <= allowed[_from][msg.sender]);
210         require(_value > 0);
211         require(balances[_to] + _value > balances[_to]);
212 
213         balances[_from] = balances[_from].sub(_value);
214         balances[_to] = balances[_to].add(_value);
215         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216         emit Transfer(_from, _to, _value);
217         return true;
218     }
219 
220     /**
221      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222      *
223      * Beware that changing an allowance with this method brings the risk that someone may use both the old
224      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      * @param _spender The address which will spend the funds.
228      * @param _value The amount of tokens to be spent.
229      */
230     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
231         allowed[msg.sender][_spender] = _value;
232         emit Approval(msg.sender, _spender, _value);
233         return true;
234     }
235 
236     /**
237      * @dev Function to check the amount of tokens that an owner allowed to a spender.
238      * @param _owner address The address which owns the funds.
239      * @param _spender address The address which will spend the funds.
240      * @return A uint256 specifying the amount of tokens still available for the spender.
241      */
242     function allowance(address _owner, address _spender) public view returns (uint256) {
243         return allowed[_owner][_spender];
244     }
245 
246     /**
247      * @dev Increase the amount of tokens that an owner allowed to a spender.
248      *
249      * approve should be called when allowed[_spender] == 0. To increment
250      * allowed value is better to use this function to avoid 2 calls (and wait until
251      * the first transaction is mined)
252      * From MonolithDAO Token.sol
253      * @param _spender The address which will spend the funds.
254      * @param _addedValue The amount of tokens to increase the allowance by.
255      */
256     function increaseApproval(address _spender, uint256 _addedValue) whenNotPaused public returns (bool) {
257         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259         return true;
260     }
261 
262     /**
263      * @dev Decrease the amount of tokens that an owner allowed to a spender.
264      *
265      * approve should be called when allowed[_spender] == 0. To decrement
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * @param _spender The address which will spend the funds.
270      * @param _subtractedValue The amount of tokens to decrease the allowance by.
271      */
272     function decreaseApproval(address _spender, uint256 _subtractedValue) whenNotPaused public returns (bool) {
273         uint256 oldValue = allowed[msg.sender][_spender];
274         if (_subtractedValue > oldValue) {
275             allowed[msg.sender][_spender] = 0;
276         } else {
277             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278         }
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 }
283 
284 
285 /**
286  * @title Grantable
287  * @dev the pre-grant is token to addr, and can be viewed in contract
288  * when grant, give token to addr in the real authorization
289  */
290 contract Grantable is BasicToken {
291     using SafeMath for uint256;
292 
293     mapping(address => uint256) grants;
294 
295     event PreGrant(address indexed from, address indexed to, uint256 value);
296     event Grant(address indexed from, address indexed to, uint256 value);
297 
298     function preGrant(address _to, uint256 _value) onlyOwner whenNotPaused public returns (bool success) {
299         require(_to != address(0));
300         require(_value <= balances[msg.sender]);
301         require(_value > 0);
302 
303         balances[msg.sender] = balances[msg.sender].sub(_value);
304         // Subtract from the sender
305         grants[_to] = grants[_to].add(_value);
306         emit PreGrant(msg.sender, _to, _value);
307         return true;
308     }
309 
310     function grant(address _to, uint256 _value) onlyOwner whenNotPaused public returns (bool success) {
311         require(_to != address(0));
312         require(_value <= grants[_to]);
313         require(_value > 0);
314 
315         grants[_to] = grants[_to].sub(_value);
316         // Subtract from the sender
317         balances[_to] = balances[_to].add(_value);
318         emit Grant(msg.sender, _to, _value);
319         emit Transfer(msg.sender, _to, _value);
320         return true;
321     }
322 
323     function grantOf(address _owner) public view returns (uint256) {
324         return grants[_owner];
325     }
326 }
327 
328 //GSENetwork
329 contract GSENetwork is StandardToken, Grantable {
330     using SafeMath for uint256;
331     string public constant name = "GSENetwork"; // Token Full Name
332     string public constant symbol = "GSE"; // Token Simplied Name
333     uint256 public constant decimals = 4;
334     uint256 constant totalToken = 1000 * (10**12); // Total Token
335 
336     function GSENetwork() public {
337         totalSupply = totalToken;
338         balances[msg.sender] = totalToken;
339         emit Transfer(address(0), msg.sender, totalSupply);
340     }
341 }