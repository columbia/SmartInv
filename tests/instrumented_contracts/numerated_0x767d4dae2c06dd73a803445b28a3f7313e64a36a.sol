1 pragma solidity 0.4.16;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41     function totalSupply() public view returns (uint256);
42     function balanceOf(address who) public view returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
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
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     address public owner;
66 
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71     /**
72      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73      * account.
74      */
75     function Ownable() public {
76         owner = msg.sender;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     /**
88      * @dev Allows the current owner to transfer control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address newOwner) public onlyOwner {
92         require(newOwner != address(0));
93         OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95     }
96 
97 }
98 
99 /**
100  * @title Pausable
101  * @dev Base contract which allows children to implement an emergency stop mechanism.
102  */
103 contract Pausable is Ownable {
104     event Pause();
105     event Unpause();
106 
107     bool public paused = false;
108 
109 
110     /**
111      * @dev Modifier to make a function callable only when the contract is not paused.
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
131         Pause();
132     }
133 
134     /**
135      * @dev called by the owner to unpause, returns to normal state
136      */
137     function unpause() onlyOwner whenPaused public {
138         paused = false;
139         Unpause();
140     }
141 }
142 
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic, Pausable {
149     using SafeMath for uint256;
150 
151     mapping(address => uint256) balances;
152 
153     uint256 totalSupply_;
154 
155     /**
156     * @dev total number of tokens in existence
157     */
158     function totalSupply() public view returns (uint256) {
159         return totalSupply_;
160     }
161 
162     /**
163     * @dev transfer token for a specified address
164     * @param _to The address to transfer to.
165     * @param _value The amount to be transferred.
166     */
167     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
168         require(_to != address(0));      // Prevent transfer to 0x0 address. Use burn() instead
169         require(_value <= balances[msg.sender]);   // Check if the sender has enough tokens
170 
171         // SafeMath.sub will throw if there is not enough balance.
172         balances[msg.sender] = balances[msg.sender].sub(_value);
173         balances[_to] = balances[_to].add(_value);
174         Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     /**
179     * @dev Gets the balance of the specified address.
180     * @param _owner The address to query the the balance of.
181     * @return An uint256 representing the amount owned by the passed address.
182     */
183     function balanceOf(address _owner) public view returns (uint256 balance) {
184         return balances[_owner];
185     }
186 
187 }
188 
189 
190 contract BurnableToken is BasicToken {
191 
192     event Burn(address indexed burner, uint256 value);
193 
194     /**
195      * @dev Burns a specific amount of tokens.
196      * @param _value The amount of token to be burned.
197      */
198     function burn(uint256 _value) onlyOwner public {
199         require(_value <= balances[msg.sender]);
200         // no need to require value <= totalSupply, since that would imply the
201         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
202 
203         address burner = msg.sender;
204         balances[burner] = balances[burner].sub(_value);
205         totalSupply_ = totalSupply_.sub(_value);
206         Burn(burner, _value);
207         Transfer(burner, address(0), _value);
208     }
209 }
210 
211 
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BurnableToken {
221 
222     mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225     /**
226      * @dev Transfer tokens from one address to another
227      * @param _from address The address which you want to send tokens from
228      * @param _to address The address which you want to transfer to
229      * @param _value uint256 the amount of tokens to be transferred
230      */
231     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
232         require(_to != address(0));
233         require(_value <= balances[_from]);
234         require(_value <= allowed[_from][msg.sender]);
235 
236         balances[_from] = balances[_from].sub(_value);
237         balances[_to] = balances[_to].add(_value);
238         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239         Transfer(_from, _to, _value);
240         return true;
241     }
242 
243     /**
244      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245      *
246      * Beware that changing an allowance with this method brings the risk that someone may use both the old
247      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      * @param _spender The address which will spend the funds.
251      * @param _value The amount of tokens to be spent.
252      */
253     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool)  {
254         allowed[msg.sender][_spender] = _value;
255         Approval(msg.sender, _spender, _value);
256         return true;
257     }
258 
259     /**
260      * @dev Function to check the amount of tokens that an owner allowed to a spender.
261      * @param _owner address The address which owns the funds.
262      * @param _spender address The address which will spend the funds.
263      * @return A uint256 specifying the amount of tokens still available for the spender.
264      */
265     function allowance(address _owner, address _spender) public view returns (uint256) {
266         return allowed[_owner][_spender];
267     }
268 
269     /**
270      * @dev Increase the amount of tokens that an owner allowed to a spender.
271      *
272      * approve should be called when allowed[_spender] == 0. To increment
273      * allowed value is better to use this function to avoid 2 calls (and wait until
274      * the first transaction is mined)
275      * From MonolithDAO Token.sol
276      * @param _spender The address which will spend the funds.
277      * @param _addedValue The amount of tokens to increase the allowance by.
278      */
279     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool)  {
280         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282         return true;
283     }
284 
285     /**
286      * @dev Decrease the amount of tokens that an owner allowed to a spender.
287      *
288      * approve should be called when allowed[_spender] == 0. To decrement
289      * allowed value is better to use this function to avoid 2 calls (and wait until
290      * the first transaction is mined)
291      * From MonolithDAO Token.sol
292      * @param _spender The address which will spend the funds.
293      * @param _subtractedValue The amount of tokens to decrease the allowance by.
294      */
295     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool)  {
296         uint oldValue = allowed[msg.sender][_spender];
297         if (_subtractedValue > oldValue) {
298             allowed[msg.sender][_spender] = 0;
299         } else {
300             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301         }
302         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303         return true;
304     }
305 
306 }
307 
308 
309 contract PrandexBountyToken is StandardToken {
310 
311     using SafeMath for uint256;
312 
313     string public name = 'Prandex Bounty Token';
314     string public symbol = 'PRAB';
315     uint8 public decimals = 8;
316     uint256 public totalTokenSupply = 200000000 * (10 ** uint256(decimals));
317 
318     function PrandexBountyToken() public {
319         totalSupply_ = totalTokenSupply;
320         balances[msg.sender] = totalTokenSupply;
321     }
322 
323 }