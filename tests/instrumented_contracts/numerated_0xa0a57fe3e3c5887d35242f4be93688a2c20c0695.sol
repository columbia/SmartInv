1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Token {
34     uint256 public totalSupply;
35 
36     function balanceOf(address who) public constant returns (uint256);
37 
38     function transfer(address to, uint256 value) public returns (bool);
39 
40     function allowance(address owner, address spender) public constant returns (uint256);
41 
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43 
44     function approve(address spender, uint256 value) public returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 contract StandardToken is Token {
52     using SafeMath for uint256;
53     mapping (address => mapping (address => uint256)) internal allowed;
54 
55     mapping (address => uint256) balances;
56 
57     /**
58     * @dev transfer token for a specified address
59     * @param _to The address to transfer to.
60     * @param _value The amount to be transferred.
61     */
62     function transfer(address _to, uint256 _value) public returns (bool) {
63         require(_to != address(0));
64         require(_value <= balances[msg.sender]);
65 
66         // SafeMath.sub will throw if there is not enough balance.
67         balances[msg.sender] = balances[msg.sender].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     /**
74     * @dev Gets the balance of the specified address.
75     * @param _owner The address to query the the balance of.
76     * @return An uint256 representing the amount owned by the passed address.
77     */
78     function balanceOf(address _owner) public constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82 
83     /**
84      * @dev Transfer tokens from one address to another
85      * @param _from address The address which you want to send tokens from
86      * @param _to address The address which you want to transfer to
87      * @param _value uint256 the amount of tokens to be transferred
88      */
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90         require(_to != address(0));
91         require(_value <= balances[_from]);
92         require(_value <= allowed[_from][msg.sender]);
93 
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /**
102      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103      *
104      * Beware that changing an allowance with this method brings the risk that someone may use both the old
105      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108      * @param _spender The address which will spend the funds.
109      * @param _value The amount of tokens to be spent.
110      */
111     function approve(address _spender, uint256 _value) public returns (bool) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /**
118      * @dev Function to check the amount of tokens that an owner allowed to a spender.
119      * @param _owner address The address which owns the funds.
120      * @param _spender address The address which will spend the funds.
121      * @return A uint256 specifying the amount of tokens still available for the spender.
122      */
123     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
124         return allowed[_owner][_spender];
125     }
126 
127     /**
128      * approve should be called when allowed[_spender] == 0. To increment
129      * allowed value is better to use this function to avoid 2 calls (and wait until
130      * the first transaction is mined)
131      * From MonolithDAO Token.sol
132      */
133     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
134         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136         return true;
137     }
138 
139     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
140         uint oldValue = allowed[msg.sender][_spender];
141         if (_subtractedValue > oldValue) {
142             allowed[msg.sender][_spender] = 0;
143         }
144         else {
145             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146         }
147         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 
151 }
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159     address public owner;
160 
161 
162     /**
163      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164      * account.
165      */
166     function Ownable() {
167         owner = msg.sender;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(msg.sender == owner);
175         _;
176     }
177 
178     /**
179      * @dev Allows the current owner to transfer control of the contract to a newOwner.
180      * @param newOwner The address to transfer ownership to.
181      */
182     function transferOwnership(address newOwner) onlyOwner {
183         require(newOwner != address(0));
184         owner = newOwner;
185     }
186 
187 }
188 
189 /**
190  * @title Pausable
191  * @dev Base contract which allows children to implement an emergency stop mechanism.
192  */
193 contract Pausable is Ownable {
194     event Pause();
195 
196     event Unpause();
197 
198     bool public paused = false;
199 
200 
201     /**
202      * @dev modifier to allow actions only when the contract IS paused
203      */
204     modifier whenNotPaused() {
205         require(!paused);
206         _;
207     }
208 
209     /**
210      * @dev modifier to allow actions only when the contract IS NOT paused
211      */
212     modifier whenPaused() {
213         require(paused);
214         _;
215     }
216 
217     /**
218      * @dev called by the owner to pause, triggers stopped state
219      */
220     function pause() onlyOwner whenNotPaused {
221         paused = true;
222         Pause();
223     }
224 
225     /**
226      * @dev called by the owner to unpause, returns to normal state
227      */
228     function unpause() onlyOwner whenPaused {
229         paused = false;
230         Unpause();
231     }
232 }
233 
234 contract Razoom is StandardToken, Pausable {
235     using SafeMath for uint256;
236 
237     string public constant name = "RAZOOM PreToken";
238 
239     string public constant symbol = "RZMP";
240 
241     uint256 public constant decimals = 18;
242 
243     uint256 public constant tokenCreationCap = 10000000 * 10 ** decimals;
244 
245     address public multiSigWallet;
246 
247     // PRICE 0.00035 ETH
248     uint public oneTokenInWei = 350000000000000;
249 
250     event CreateRZM(address indexed _to, uint256 _value);
251 
252     function Razoom(address multisig) {
253         owner = msg.sender;
254         multiSigWallet = multisig;
255         balances[0x4E68FA0ca21cf33Db77edCdb7B0da15F26Bd6722] = 5000000 * 10 ** decimals;
256         totalSupply = 5000000 * 10 ** decimals;
257     }
258 
259     function() payable {
260         createTokens();
261     }
262 
263     function createTokens() internal whenNotPaused {
264         if (msg.value <= 0) revert();
265 
266         uint multiplier = 10 ** decimals;
267         uint256 tokens = msg.value.mul(multiplier) / oneTokenInWei;
268 
269         uint256 checkedSupply = totalSupply.add(tokens);
270         if (tokenCreationCap < checkedSupply) revert();
271 
272         balances[msg.sender] += tokens;
273         totalSupply = totalSupply.add(tokens);
274     }
275 
276     function withdraw() external onlyOwner {
277         multiSigWallet.transfer(this.balance);
278     }
279 
280     function setEthPrice(uint _tokenPrice) onlyOwner {
281         oneTokenInWei = _tokenPrice;
282     }
283 
284     function replaceMultisig(address newMultisig) onlyOwner {
285         multiSigWallet = newMultisig;
286     }
287 
288 }