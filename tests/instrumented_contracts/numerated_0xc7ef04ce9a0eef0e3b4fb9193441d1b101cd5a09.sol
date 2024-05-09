1 pragma solidity ^0.4.18;
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
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) balances;
67 
68     /**
69     * @dev transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_to != address(this));
76         require(_value <= balances[msg.sender]);
77 
78         // SafeMath.sub will throw if there is not enough balance.
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86     * @dev Gets the balance of the specified address.
87     * @param _owner The address to query the the balance of.
88     * @return An uint256 representing the amount owned by the passed address.
89     */
90     function balanceOf(address _owner) public view returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105     mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108     /**
109      * @dev Transfer tokens from one address to another
110      * @param _from address The address which you want to send tokens from
111      * @param _to address The address which you want to transfer to
112      * @param _value uint256 the amount of tokens to be transferred
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115         require(_to != address(0));
116         require(_to != address(this));
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129      *
130      * Beware that changing an allowance with this method brings the risk that someone may use both the old
131      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      * @param _spender The address which will spend the funds.
135      * @param _value The amount of tokens to be spent.
136      */
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param _owner address The address which owns the funds.
146      * @param _spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149     function allowance(address _owner, address _spender) public view returns (uint256) {
150         return allowed[_owner][_spender];
151     }
152 
153     /**
154      * approve should be called when allowed[_spender] == 0. To increment
155      * allowed value is better to use this function to avoid 2 calls (and wait until
156      * the first transaction is mined)
157      * From MonolithDAO Token.sol
158      */
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166         uint oldValue = allowed[msg.sender][_spender];
167         if (_subtractedValue > oldValue) {
168             allowed[msg.sender][_spender] = 0;
169         } else {
170             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171         }
172         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175 
176 }
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184     address public owner;
185 
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189 
190     /**
191      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192      * account.
193      */
194     function Ownable() public {
195         owner = msg.sender;
196     }
197 
198 
199     /**
200      * @dev Throws if called by any account other than the owner.
201      */
202     modifier onlyOwner() {
203         require(msg.sender == owner);
204         _;
205     }
206 
207 
208     /**
209      * @dev Allows the current owner to transfer control of the contract to a newOwner.
210      * @param newOwner The address to transfer ownership to.
211      */
212     function transferOwnership(address newOwner) public onlyOwner {
213         require(newOwner != address(0));
214         OwnershipTransferred(owner, newOwner);
215         owner = newOwner;
216     }
217 
218 }
219 
220 /**
221  * @title Pausable
222  * @dev Base contract which allows children to implement an emergency stop mechanism.
223  */
224 contract Pausable is Ownable {
225     event Pause();
226     event Unpause();
227 
228     bool public paused = false;
229 
230 
231     /**
232      * @dev Modifier to make a function callable only when the contract is not paused.
233      */
234     modifier whenNotPaused() {
235         require(!paused);
236         _;
237     }
238 
239     /**
240      * @dev Modifier to make a function callable only when the contract is paused.
241      */
242     modifier whenPaused() {
243         require(paused);
244         _;
245     }
246 
247     /**
248      * @dev called by the owner to pause, triggers stopped state
249      */
250     function pause() onlyOwner whenNotPaused public {
251         paused = true;
252         Pause();
253     }
254 
255     /**
256      * @dev called by the owner to unpause, returns to normal state
257      */
258     function unpause() onlyOwner whenPaused public {
259         paused = false;
260         Unpause();
261     }
262 }
263 
264 /**
265  * @title Pausable token
266  *
267  * @dev StandardToken modified with pausable transfers.
268  **/
269 contract PausableToken is StandardToken, Pausable {
270 
271     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
272         return super.transfer(_to, _value);
273     }
274 
275     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
276         return super.transferFrom(_from, _to, _value);
277     }
278 
279     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
280         return super.approve(_spender, _value);
281     }
282 
283     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
284         return super.increaseApproval(_spender, _addedValue);
285     }
286 
287     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
288         return super.decreaseApproval(_spender, _subtractedValue);
289     }
290 }
291 
292 
293 contract MoneyCoin is PausableToken {
294     string public constant name = "Money Coin";
295     string public constant symbol = "MONC";
296     uint8 public constant decimals = 18;
297 
298     uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
299 
300     uint256 public constant totalSupply = 200000000 * TOKEN_UNIT;
301 	
302     function MoneyCoinCoin() public {
303         balances[owner] = totalSupply;
304         Transfer(address(0), owner, balances[owner]);
305     }
306 }