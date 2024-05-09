1 pragma solidity 0.4.24;
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
42     address public owner;
43 
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48     /**
49     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50     * account.
51     */
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     /**
57     * @dev Throws if called by any account other than the owner.
58     */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65     * @dev Allows the current owner to transfer control of the contract to a newOwner.
66     * @param newOwner The address to transfer ownership to.
67     */
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title ERC20Basic
77  */
78 contract ERC20Basic {
79     uint256 public totalSupply;
80     function balanceOf(address who) public view returns (uint256);
81     function transfer(address to, uint256 value) public returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90     function allowance(address owner, address spender) public view returns (uint256);
91     function transferFrom(address from, address to, uint256 value) public returns (bool);
92     function approve(address spender, uint256 value) public returns (bool);
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances. 
99  */
100 contract BasicToken is ERC20Basic, Ownable {
101 
102     using SafeMath for uint256;
103 
104     mapping(address => uint256) balances;
105 
106     /**
107     * @dev transfer token for a specified address
108     * @param _to The address to transfer to.
109     * @param _value The amount to be transferred.
110     */
111     function transfer(address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[msg.sender]);
114 
115         // SafeMath.sub will throw if there is not enough balance.
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         emit Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param _owner The address to query the the balance of. 
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address _owner) public view returns (uint256 balance) {
128         return balances[_owner];
129     }
130     
131 }
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143     mapping (address => mapping (address => uint256)) allowed;
144 
145     /**
146     * @dev Transfer tokens from one address to another
147     * @param _from address The address which you want to send tokens from
148     * @param _to address The address which you want to transfer to
149     * @param _value uint256 the amount of tokens to be transferred
150     */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(allowed[_from][msg.sender] >= _value);
154         require(balances[_from] >= _value);
155         require(balances[_to].add(_value) > balances[_to]); // Check for overflows
156         balances[_from] = balances[_from].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159         emit Transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165     * @param _spender The address which will spend the funds.
166     * @param _value The amount of tokens to be spent.
167     */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         // To change the approve amount you first have to reduce the addresses`
170         //  allowance to zero by calling `approve(_spender, 0)` if it is not
171         //  already 0 to mitigate the race condition described here:
172         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     /**
180     * @dev Function to check the amount of tokens that an owner allowed to a spender.
181     * @param _owner address The address which owns the funds.
182     * @param _spender address The address which will spend the funds.
183     * @return A uint256 specifying the amount of tokens still available for the spender.
184     */
185     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190     * approve should be called when allowed[_spender] == 0. To increment
191     * allowed value is better to use this function to avoid 2 calls (and wait until 
192     * the first transaction is mined)
193     * From MonolithDAO Token.sol
194     */
195     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
196         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198         return true;
199     }
200 
201     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
202         uint oldValue = allowed[msg.sender][_spender];
203         if (_subtractedValue > oldValue) {
204             allowed[msg.sender][_spender] = 0;
205         } else {
206             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207         }
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 }
212 
213 
214 /**
215  * @title Pausable
216  * @dev Base contract which allows children to implement an emergency stop mechanism.
217  */
218 contract Pausable is StandardToken {
219     event Pause();
220     event Unpause();
221 
222     bool public paused = false;
223 
224     address public founder;
225     
226     /**
227     * @dev modifier to allow actions only when the contract IS paused
228     */
229     modifier whenNotPaused() {
230         require(!paused || msg.sender == founder);
231         _;
232     }
233 
234     /**
235     * @dev modifier to allow actions only when the contract IS NOT paused
236     */
237     modifier whenPaused() {
238         require(paused);
239         _;
240     }
241 
242     /**
243     * @dev called by the owner to pause, triggers stopped state
244     */
245     function pause() public onlyOwner whenNotPaused {
246         paused = true;
247         emit Pause();
248     }
249 
250     /**
251     * @dev called by the owner to unpause, returns to normal state
252     */
253     function unpause() public onlyOwner whenPaused {
254         paused = false;
255         emit Unpause();
256     }
257 }
258 
259 
260 contract PausableToken is Pausable {
261 
262     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
263         return super.transfer(_to, _value);
264     }
265 
266     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
267         return super.transferFrom(_from, _to, _value);
268     }
269 
270     //The functions below surve no real purpose. Even if one were to approve another to spend
271     //tokens on their behalf, those tokens will still only be transferable when the token contract
272     //is not paused.
273 
274     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
275         return super.approve(_spender, _value);
276     }
277 
278     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
279         return super.increaseApproval(_spender, _addedValue);
280     }
281 
282     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
283         return super.decreaseApproval(_spender, _subtractedValue);
284     }
285 }
286 
287 contract MyAdvancedToken is PausableToken {
288 
289     string public name;
290     string public symbol;
291     uint8 public decimals;
292 
293     /**
294     * @dev Constructor that gives the founder all of the existing tokens.
295     */
296     constructor() public {
297         name = "Electronic Energy Coin";
298         symbol = "E2C";
299         decimals = 18;
300         totalSupply = 131636363e18;
301 
302         founder = 0x6784520Ac7fbfad578ABb5575d333A3f8739A5af;
303 
304         balances[msg.sender] = totalSupply;
305         emit Transfer(0x0, msg.sender, totalSupply);
306     }
307 }