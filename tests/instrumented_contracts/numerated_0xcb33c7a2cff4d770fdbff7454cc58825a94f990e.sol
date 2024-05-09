1 pragma solidity 0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54 * @title Owned
55 * @dev The owned contract has an owner address, and provides basic authorization control
56 * functions, this simplifies the implementation of "user permissions".
57 */
58 contract Owned {
59     address public owner;
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address newOwner) onlyOwner public {
71         owner = newOwner;
72     }
73 }
74 
75 /**
76 * @title Pausable
77 * @dev Base contract which allows children to implement an emergency stop mechanism.
78 */
79 contract Pausable is Owned {
80     bool public paused = false;
81 
82     event Pause();
83     event Unpause();
84 
85     /**
86     * @dev Modifier to make a function callable only when the contract is not paused.
87     */
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     /**
94     * @dev Modifier to make a function callable only when the contract is paused.
95     */
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100 
101     /**
102     * @dev called by the owner to pause, triggers stopped state
103     */
104     function pause() onlyOwner whenNotPaused public {
105         paused = true;
106         emit Pause();
107     }
108 
109     /**
110     * @dev called by the owner to unpause, returns to normal state
111     */
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         emit Unpause();
115     }
116 }
117 
118 interface tokenRecipient {
119     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
120 }
121 
122 /******************************************/
123 /*       CSCToken STARTS HERE       */
124 /******************************************/
125 
126 contract CXToken is Pausable {
127     using SafeMath for uint; // use the library for uint type
128 
129     string public symbol;
130     string public  name;
131     uint8 public decimals = 18;
132     // 18 decimals is the strongly suggested default, avoid changing it
133     uint public totalSupply;
134 
135     mapping (address => uint256) public balanceOf;
136     mapping (address => mapping (address => uint256)) public allowance;
137     mapping (address => bool) public frozenAccount;
138     mapping (address => uint256) public frozenAmount;
139 
140     event Transfer(address indexed from, address indexed to, uint tokens);
141     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
142     event Burn(address indexed from, uint256 value);
143 
144     event FrozenFunds(address target, bool frozen);
145     event FrozenAmt(address target, uint256 value);
146     event UnfrozenAmt(address target);
147 
148     constructor(
149     uint256 initialSupply,
150     string tokenName,
151     string tokenSymbol
152     ) public {
153         // Update total supply with the decimal amount
154         totalSupply = initialSupply * 10 ** uint256(decimals);
155         // Give the creator all initial tokens
156         balanceOf[msg.sender] = totalSupply;
157         // Set the name for display purposes
158         name = tokenName;
159         // Set the symbol for display purposes
160         symbol = tokenSymbol;
161     }
162 
163     /* Internal transfer, only can be called by this contract */
164     function _transfer(address _from, address _to, uint _value) whenNotPaused internal {
165         require (_to != 0x0);
166         require(!frozenAccount[_from]);
167         require(!frozenAccount[_to]);
168         uint256 amount = balanceOf[_from].sub(_value);
169         require(frozenAmount[_from] == 0 || amount >= frozenAmount[_from]);
170         balanceOf[_from] = amount;
171         balanceOf[_to] = balanceOf[_to].add(_value);
172         emit Transfer(_from, _to, _value);
173     }
174 
175     /**
176     * Transfer tokens
177     *
178     * Send `_value` tokens to `_to` from your account
179     *
180     * @param _to The address of the recipient
181     * @param _value the amount to send
182     */
183     function transfer(address _to, uint256 _value)
184     public
185     returns (bool success) {
186         _transfer(msg.sender, _to, _value);
187         return true;
188     }
189 
190     /**
191     * Transfer tokens from other address
192     *
193     * Send `_value` tokens to `_to` in behalf of `_from`
194     *
195     * @param _from The address of the sender
196     * @param _to The address of the recipient
197     * @param _value the amount to send
198     */
199     function transferFrom(address _from, address _to, uint256 _value)
200     public
201     returns (bool success) {
202         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
203         _transfer(_from, _to, _value);
204         return true;
205     }
206 
207     /**
208     * Set allowance for other address
209     *
210     * Allows `_spender` to spend no more than `_value` tokens in your behalf
211     * Limited usage in case of front running attack, see: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
212     *
213     * @param _spender The address authorized to spend
214     * @param _value the max amount they can spend
215     */
216     function approve(address _spender, uint256 _value) onlyOwner
217     public
218     returns (bool success) {
219         allowance[msg.sender][_spender] = _value;
220         emit Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     /**
225     * Set allowance for other address and notify
226     *
227     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
228     *
229     * @param _spender The address authorized to spend
230     * @param _value the max amount they can spend
231     * @param _extraData some extra information to send to the approved contract
232     */
233     function approveAndCall(address _spender, uint256 _value, bytes _extraData) onlyOwner
234     public
235     returns (bool success) {
236         tokenRecipient spender = tokenRecipient(_spender);
237         if (approve(_spender, _value)) {
238             spender.receiveApproval(msg.sender, _value, this, _extraData);
239             return true;
240         }
241     }
242 
243     /**
244     * Destroy tokens
245     *
246     * Remove `_value` tokens from the system irreversibly
247     *
248     * @param _value the amount of money to burn
249     */
250     function burn(uint256 _value)
251     public
252     returns (bool success) {
253         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
254         totalSupply = totalSupply.sub(_value);
255         emit Burn(msg.sender, _value);
256         return true;
257     }
258 
259 
260     /**
261     * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
262     *
263     * @param target Address to be frozen
264     * @param freeze either to freeze it or not
265     */
266     function freezeAccount(address target, bool freeze) onlyOwner public {
267         frozenAccount[target] = freeze;
268         emit FrozenFunds(target, freeze);
269     }
270 
271     /**
272     * @notice Freeze `_value` of `target` balance
273     *
274     * @param target Address to be frozen amount
275     * @param _value freeze amount
276     */
277     function freezeAmount(address target, uint256 _value) onlyOwner public {
278         require(_value > 0);
279         frozenAmount[target] = _value;
280         emit FrozenAmt(target, _value);
281     }
282 
283     /**
284     * @notice Unfreeze `target` balance.
285     *
286     * @param target Address to be unfrozen
287     */
288     function unfreezeAmount(address target) onlyOwner public {
289         frozenAmount[target] = 0;
290         emit UnfrozenAmt(target);
291     }
292 }