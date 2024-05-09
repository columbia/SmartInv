1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, reverts on overflow.
8     */
9     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (_a == 0) {
14             return 0;
15         }
16 
17         uint256 c = _a * _b;
18         require(c / _a == _b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         require(_b > 0); // Solidity only automatically asserts when dividing by 0
28         uint256 c = _a / _b;
29         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30 
31         return c;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38         require(_b <= _a);
39         uint256 c = _a - _b;
40 
41         return c;
42     }
43 
44     /**
45     * @dev Adds two numbers, reverts on overflow.
46     */
47     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
48         uint256 c = _a + _b;
49         require(c >= _a);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
56     * reverts when dividing by zero.
57     */
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b != 0);
60         return a % b;
61     }
62 }
63 
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address public owner;
72 
73 
74     event OwnershipRenounced(address indexed previousOwner);
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     /**
98      * @dev Allows the current owner to relinquish control of the contract.
99      * @notice Renouncing to ownership will leave the contract without an owner.
100      * It will not be possible to call the functions with the `onlyOwner`
101      * modifier anymore.
102      */
103     function renounceOwnership() public onlyOwner {
104         emit OwnershipRenounced(owner);
105         owner = address(0);
106     }
107 
108     /**
109      * @dev Allows the current owner to transfer control of the contract to a newOwner.
110      * @param _newOwner The address to transfer ownership to.
111      */
112     function transferOwnership(address _newOwner) public onlyOwner {
113     _transferOwnership(_newOwner);
114 }
115 
116     /**
117      * @dev Transfers control of the contract to a newOwner.
118      * @param _newOwner The address to transfer ownership to.
119      */
120     function _transferOwnership(address _newOwner) internal {
121         require(_newOwner != address(0));
122         emit OwnershipTransferred(owner, _newOwner);
123         owner = _newOwner;
124     }
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 {
132     function totalSupply() public view returns (uint256);
133 
134     function balanceOf(address _who) public view returns (uint256);
135 
136     function allowance(address _owner, address _spender)
137     public view returns (uint256);
138 
139     function transfer(address _to, uint256 _value) public returns (bool);
140 
141     function approve(address _spender, uint256 _value)
142     public returns (bool);
143 
144     function transferFrom(address _from, address _to, uint256 _value)
145     public returns (bool);
146 
147     event Transfer(
148         address indexed from,
149         address indexed to,
150         uint256 value
151     );
152 
153     event Approval(
154         address indexed owner,
155         address indexed spender,
156         uint256 value
157     );
158 }
159 
160 
161 
162 contract Dagnet is ERC20, Ownable {
163     using SafeMath for uint256;
164 
165     mapping (address => uint256) public balances;
166 
167     mapping (address => mapping (address => uint256)) private allowed;
168 
169     uint256 private totalSupply_ = 30000000;
170 
171     string public constant name = "Dagnet";
172     string public constant symbol = "DNT";
173     uint8 public constant decimals = 0;
174 
175     constructor() public {
176         balances[msg.sender] = totalSupply_;
177         emit Transfer(address(0), msg.sender, totalSupply_);
178     }
179 
180     /**
181     * @dev Total number of tokens in existence
182     */
183     function totalSupply() public view returns (uint256) {
184         return totalSupply_;
185     }
186 
187     /**
188     * @dev Gets the balance of the specified address.
189     * @param _owner The address to query the the balance of.
190     * @return An uint256 representing the amount owned by the passed address.
191     */
192     function balanceOf(address _owner) public view returns (uint256) {
193         return balances[_owner];
194     }
195 
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param _owner address The address which owns the funds.
199      * @param _spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(
203         address _owner,
204         address _spender
205     )
206     public
207     view
208     returns (uint256)
209     {
210         return allowed[_owner][_spender];
211     }
212 
213     /**
214     * @dev Transfer token for a specified address
215     * @param _to The address to transfer to.
216     * @param _value The amount to be transferred.
217     */
218     function transfer(address _to, uint256 _value) public returns (bool) {
219         require(_value <= balances[msg.sender]);
220         require(_to != address(0));
221         balances[msg.sender] = balances[msg.sender].sub(_value);
222         balances[_to] = balances[_to].add(_value);
223         emit Transfer(msg.sender, _to, _value);
224         return true;
225     }
226 
227     /**
228      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229      * Beware that changing an allowance with this method brings the risk that someone may use both the old
230      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      * @param _spender The address which will spend the funds.
234      * @param _value The amount of tokens to be spent.
235      */
236     function approve(address _spender, uint256 _value) public returns (bool) {
237         allowed[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241 
242     /**
243      * @dev Transfer tokens from one address to another
244      * @param _from address The address which you want to send tokens from
245      * @param _to address The address which you want to transfer to
246      * @param _value uint256 the amount of tokens to be transferred
247      */
248     function transferFrom(
249         address _from,
250         address _to,
251         uint256 _value
252     )
253     public
254     returns (bool)
255     {
256         require(_value <= balances[_from]);
257         require(_value <= allowed[_from][msg.sender]);
258         require(_to != address(0));
259 
260         balances[_from] = balances[_from].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
263         emit Transfer(_from, _to, _value);
264         return true;
265     }
266 
267     /**
268      * @dev Increase the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed[_spender] == 0. To increment
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * @param _spender The address which will spend the funds.
274      * @param _addedValue The amount of tokens to increase the allowance by.
275      */
276     function increaseApproval(
277         address _spender,
278         uint256 _addedValue
279     )
280     public
281     returns (bool)
282     {
283         allowed[msg.sender][_spender] = (
284         allowed[msg.sender][_spender].add(_addedValue));
285         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286         return true;
287     }
288 
289     /**
290      * @dev Decrease the amount of tokens that an owner allowed to a spender.
291      * approve should be called when allowed[_spender] == 0. To decrement
292      * allowed value is better to use this function to avoid 2 calls (and wait until
293      * the first transaction is mined)
294      * From MonolithDAO Token.sol
295      * @param _spender The address which will spend the funds.
296      * @param _subtractedValue The amount of tokens to decrease the allowance by.
297      */
298     function decreaseApproval(
299         address _spender,
300         uint256 _subtractedValue
301     )
302     public
303     returns (bool)
304     {
305         uint256 oldValue = allowed[msg.sender][_spender];
306         if (_subtractedValue >= oldValue) {
307             allowed[msg.sender][_spender] = 0;
308         } else {
309             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310         }
311         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312         return true;
313     }
314 
315 
316 
317     /**
318      * @dev Public function that burns an amount of the token of a sender.
319      * @param _amount The amount that will be burnt.
320      */
321     function _burn(uint256 _amount) public {
322         require(_amount <= balances[msg.sender]);
323 
324         totalSupply_ = totalSupply_.sub(_amount);
325         balances[msg.sender] = balances[msg.sender].sub(_amount);
326         emit Transfer(msg.sender, address(0), _amount);
327     }
328 }