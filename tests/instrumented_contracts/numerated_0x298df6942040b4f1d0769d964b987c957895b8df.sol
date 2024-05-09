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
113         _transferOwnership(_newOwner);
114     }
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
162 contract TimberCoin is ERC20, Ownable {
163     using SafeMath for uint256;
164 
165     mapping (address => uint256) public balances;
166 
167     mapping (address => mapping (address => uint256)) private allowed;
168 
169     uint256 private totalSupply_ = 1750000 * 10**2;
170 
171     string public constant name = "TimberCoin";
172     string public constant symbol = "TMB";
173     uint8 public constant decimals = 2;
174 
175 
176     constructor() public {
177         balances[msg.sender] = totalSupply_;
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
221 
222 
223         balances[msg.sender] = balances[msg.sender].sub(_value);
224         balances[_to] = balances[_to].add(_value);
225         emit Transfer(msg.sender, _to, _value);
226         return true;
227     }
228 
229     /**
230      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231      * Beware that changing an allowance with this method brings the risk that someone may use both the old
232      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      * @param _spender The address which will spend the funds.
236      * @param _value The amount of tokens to be spent.
237      */
238     function approve(address _spender, uint256 _value) public returns (bool) {
239         allowed[msg.sender][_spender] = _value;
240         emit Approval(msg.sender, _spender, _value);
241         return true;
242     }
243 
244     /**
245      * @dev Transfer tokens from one address to another
246      * @param _from address The address which you want to send tokens from
247      * @param _to address The address which you want to transfer to
248      * @param _value uint256 the amount of tokens to be transferred
249      */
250     function transferFrom(
251         address _from,
252         address _to,
253         uint256 _value
254     )
255     public
256     returns (bool)
257     {
258         require(_value <= balances[_from]);
259         require(_value <= allowed[_from][msg.sender]);
260         require(_to != address(0));
261 
262         balances[_from] = balances[_from].sub(_value);
263         balances[_to] = balances[_to].add(_value);
264         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265         emit Transfer(_from, _to, _value);
266         return true;
267     }
268 
269     /**
270      * @dev Increase the amount of tokens that an owner allowed to a spender.
271      * approve should be called when allowed[_spender] == 0. To increment
272      * allowed value is better to use this function to avoid 2 calls (and wait until
273      * the first transaction is mined)
274      * From MonolithDAO Token.sol
275      * @param _spender The address which will spend the funds.
276      * @param _addedValue The amount of tokens to increase the allowance by.
277      */
278     function increaseApproval(
279         address _spender,
280         uint256 _addedValue
281     )
282     public
283     returns (bool)
284     {
285         allowed[msg.sender][_spender] = (
286         allowed[msg.sender][_spender].add(_addedValue));
287         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288         return true;
289     }
290 
291     /**
292      * @dev Decrease the amount of tokens that an owner allowed to a spender.
293      * approve should be called when allowed[_spender] == 0. To decrement
294      * allowed value is better to use this function to avoid 2 calls (and wait until
295      * the first transaction is mined)
296      * From MonolithDAO Token.sol
297      * @param _spender The address which will spend the funds.
298      * @param _subtractedValue The amount of tokens to decrease the allowance by.
299      */
300     function decreaseApproval(
301         address _spender,
302         uint256 _subtractedValue
303     )
304     public
305     returns (bool)
306     {
307         uint256 oldValue = allowed[msg.sender][_spender];
308         if (_subtractedValue >= oldValue) {
309             allowed[msg.sender][_spender] = 0;
310         } else {
311             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
312         }
313         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314         return true;
315     }
316 
317 
318 
319     /**
320      * @dev Internal function that burns an amount of the token of a given
321      * account.
322      * @param _account The account whose tokens will be burnt.
323      * @param _amount The amount that will be burnt.
324      */
325     function _burn(address _account, uint256 _amount) internal {
326         require(_account != 0);
327         require(_amount <= balances[_account]);
328 
329         totalSupply_ = totalSupply_.sub(_amount);
330         balances[_account] = balances[_account].sub(_amount);
331         emit Transfer(_account, address(0), _amount);
332     }
333 
334     /**
335      * @dev Internal function that burns an amount of the token of a given
336      * account, deducting from the sender's allowance for said account. Uses the
337      * internal _burn function.
338      * @param _account The account whose tokens will be burnt.
339      * @param _amount The amount that will be burnt.
340      */
341     function _burnFrom(address _account, uint256 _amount) internal {
342         require(_amount <= allowed[_account][msg.sender]);
343 
344         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
345         // this function needs to emit an event with the updated approval.
346         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
347         _burn(_account, _amount);
348     }
349 }