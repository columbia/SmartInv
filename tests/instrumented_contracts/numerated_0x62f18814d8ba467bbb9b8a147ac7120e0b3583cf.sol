1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (_a == 0) {
18             return 0;
19         }
20 
21         uint256 c = _a * _b;
22         require(c / _a == _b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31         require(_b > 0);
32         // Solidity only automatically asserts when dividing by 0
33         uint256 c = _a / _b;
34         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43         require(_b <= _a);
44         uint256 c = _a - _b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         uint256 c = _a + _b;
54         require(c >= _a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 {
75     function totalSupply() public view returns (uint256);
76 
77     function balanceOf(address _who) public view returns (uint256);
78 
79     function allowance(address _owner, address _spender)
80     public view returns (uint256);
81 
82     function transfer(address _to, uint256 _value) public returns (bool);
83 
84     function approve(address _spender, uint256 _value)
85     public returns (bool);
86 
87     function transferFrom(address _from, address _to, uint256 _value)
88     public returns (bool);
89 
90     event Transfer(
91         address indexed from,
92         address indexed to,
93         uint256 value
94     );
95 
96     event Approval(
97         address indexed owner,
98         address indexed spender,
99         uint256 value
100     );
101 }
102 
103 contract StandardToken is ERC20 {
104     using SafeMath for uint256;
105 
106     mapping(address => uint256) public balances;
107 
108     mapping(address => mapping(address => uint256)) private allowed;
109 
110     uint256 public totalSupply_;
111 
112     /**
113     * @dev Total number of tokens in existence
114     */
115     function totalSupply() public view returns (uint256) {
116         return totalSupply_;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param _owner The address to query the the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124     function balanceOf(address _owner) public view returns (uint256) {
125         return balances[_owner];
126     }
127 
128     /**
129      * @dev Function to check the amount of tokens that an owner allowed to a spender.
130      * @param _owner address The address which owns the funds.
131      * @param _spender address The address which will spend the funds.
132      * @return A uint256 specifying the amount of tokens still available for the spender.
133      */
134     function allowance(
135         address _owner,
136         address _spender
137     )
138     public
139     view
140     returns (uint256)
141     {
142         return allowed[_owner][_spender];
143     }
144 
145     /**
146     * @dev Transfer token for a specified address
147     * @param _to The address to transfer to.
148     * @param _value The amount to be transferred.
149     */
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         require(_value <= balances[msg.sender]);
152         require(_to != address(0));
153 
154         balances[msg.sender] = balances[msg.sender].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         emit Transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162      * Beware that changing an allowance with this method brings the risk that someone may use both the old
163      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      * @param _spender The address which will spend the funds.
167      * @param _value The amount of tokens to be spent.
168      */
169     function approve(address _spender, uint256 _value) public returns (bool) {
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another
177      * @param _from address The address which you want to send tokens from
178      * @param _to address The address which you want to transfer to
179      * @param _value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(
182         address _from,
183         address _to,
184         uint256 _value
185     )
186     public
187     returns (bool)
188     {
189         require(_value <= balances[_from]);
190         require(_value <= allowed[_from][msg.sender]);
191         require(_to != address(0));
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         emit Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     /**
201      * @dev Increase the amount of tokens that an owner allowed to a spender.
202      * approve should be called when allowed[_spender] == 0. To increment
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * @param _spender The address which will spend the funds.
207      * @param _addedValue The amount of tokens to increase the allowance by.
208      */
209     function increaseApproval(
210         address _spender,
211         uint256 _addedValue
212     )
213     public
214     returns (bool)
215     {
216         allowed[msg.sender][_spender] = (
217         allowed[msg.sender][_spender].add(_addedValue));
218         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219         return true;
220     }
221 
222     /**
223      * @dev Decrease the amount of tokens that an owner allowed to a spender.
224      * approve should be called when allowed[_spender] == 0. To decrement
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      * @param _spender The address which will spend the funds.
229      * @param _subtractedValue The amount of tokens to decrease the allowance by.
230      */
231     function decreaseApproval(
232         address _spender,
233         uint256 _subtractedValue
234     )
235     public
236     returns (bool)
237     {
238         uint256 oldValue = allowed[msg.sender][_spender];
239         if (_subtractedValue >= oldValue) {
240             allowed[msg.sender][_spender] = 0;
241         } else {
242             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243         }
244         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245         return true;
246     }
247 
248     /**
249      * @dev Internal function that mints an amount of the token and assigns it to
250      * an account. This encapsulates the modification of balances such that the
251      * proper events are emitted.
252      * @param _account The account that will receive the created tokens.
253      * @param _amount The amount that will be created.
254      */
255     function _mint(address _account, uint256 _amount) internal {
256         require(_account != 0);
257         totalSupply_ = totalSupply_.add(_amount);
258         balances[_account] = balances[_account].add(_amount);
259         emit Transfer(address(0), _account, _amount);
260     }
261 
262     /**
263      * @dev Internal function that burns an amount of the token of a given
264      * account.
265      * @param _account The account whose tokens will be burnt.
266      * @param _amount The amount that will be burnt.
267      */
268     function _burn(address _account, uint256 _amount) internal {
269         require(_account != 0);
270         require(_amount <= balances[_account]);
271 
272         totalSupply_ = totalSupply_.sub(_amount);
273         balances[_account] = balances[_account].sub(_amount);
274         emit Transfer(_account, address(0), _amount);
275     }
276 
277     /**
278      * @dev Internal function that burns an amount of the token of a given
279      * account, deducting from the sender's allowance for said account. Uses the
280      * internal _burn function.
281      * @param _account The account whose tokens will be burnt.
282      * @param _amount The amount that will be burnt.
283      */
284     function _burnFrom(address _account, uint256 _amount) internal {
285         require(_amount <= allowed[_account][msg.sender]);
286 
287         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
288         // this function needs to emit an event with the updated approval.
289         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
290         _burn(_account, _amount);
291     }
292 }
293 
294 
295 contract CocoToken is StandardToken {
296     string public name = "COCO";
297     string public symbol = "CCT";
298     uint8 public decimals = 18;
299     uint public INITIAL_SUPPLY = 10*10**26;
300 
301     constructor() public {
302         totalSupply_ = INITIAL_SUPPLY;
303         balances[msg.sender] = INITIAL_SUPPLY;
304     }
305 }