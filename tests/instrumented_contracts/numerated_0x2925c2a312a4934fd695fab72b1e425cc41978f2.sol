1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address _who) public view returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16     /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
20         if (_a == 0) {
21             return 0;
22         }
23 
24         c = _a * _b;
25         assert(c / _a == _b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
33         // assert(_b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = _a / _b;
35         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
36         return _a / _b;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43         assert(_b <= _a);
44         return _a - _b;
45     }
46 
47     /**
48     * @dev Adds two numbers, throws on overflow.
49     */
50     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
51         c = _a + _b;
52         assert(c >= _a);
53         return c;
54     }
55 }
56 
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63     using SafeMath for uint256;
64 
65     mapping(address => uint256) internal balances;
66 
67     uint256 internal totalSupply_;
68 
69     /**
70     * @dev Total number of tokens in existence
71     */
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76     /**
77     * @dev Transfer token for a specified address
78     * @param _to The address to transfer to.
79     * @param _value The amount to be transferred.
80     */
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         require(_value <= balances[msg.sender]);
83         require(_to != address(0));
84 
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92     * @dev Gets the balance of the specified address.
93     * @param _owner The address to query the the balance of.
94     * @return An uint256 representing the amount owned by the passed address.
95     */
96     function balanceOf(address _owner) public view returns (uint256) {
97         return balances[_owner];
98     }
99 
100 }
101 
102 
103 /**
104  * @title Burnable Token
105  * @dev Token that can be irreversibly burned (destroyed).
106  */
107 contract BurnableToken is BasicToken {
108 
109     event Burn(address indexed burner, uint256 value);
110 
111     /**
112      * @dev Burns a specific amount of tokens.
113      * @param _value The amount of token to be burned.
114      */
115     function burn(uint256 _value) public {
116         _burn(msg.sender, _value);
117     }
118 
119     function _burn(address _who, uint256 _value) internal {
120         require(_value <= balances[_who]);
121         // no need to require value <= totalSupply, since that would imply the
122         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
123 
124         balances[_who] = balances[_who].sub(_value);
125         totalSupply_ = totalSupply_.sub(_value);
126         emit Burn(_who, _value);
127         emit Transfer(_who, address(0), _value);
128     }
129 }
130 
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137     function allowance(address _owner, address _spender)
138     public view returns (uint256);
139 
140     function transferFrom(address _from, address _to, uint256 _value)
141     public returns (bool);
142 
143     function approve(address _spender, uint256 _value) public returns (bool);
144     event Approval(
145         address indexed owner,
146         address indexed spender,
147         uint256 value
148     );
149 }
150 
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * https://github.com/ethereum/EIPs/issues/20
157  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161     mapping (address => mapping (address => uint256)) internal allowed;
162 
163 
164     /**
165      * @dev Transfer tokens from one address to another
166      * @param _from address The address which you want to send tokens from
167      * @param _to address The address which you want to transfer to
168      * @param _value uint256 the amount of tokens to be transferred
169      */
170     function transferFrom(
171         address _from,
172         address _to,
173         uint256 _value
174     )
175     public
176     returns (bool)
177     {
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180         require(_to != address(0));
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(
211         address _owner,
212         address _spender
213     )
214     public
215     view
216     returns (uint256)
217     {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222      * @dev Increase the amount of tokens that an owner allowed to a spender.
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(
231         address _spender,
232         uint256 _addedValue
233     )
234     public
235     returns (bool)
236     {
237         allowed[msg.sender][_spender] = (
238         allowed[msg.sender][_spender].add(_addedValue));
239         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243     /**
244      * @dev Decrease the amount of tokens that an owner allowed to a spender.
245      * approve should be called when allowed[_spender] == 0. To decrement
246      * allowed value is better to use this function to avoid 2 calls (and wait until
247      * the first transaction is mined)
248      * From MonolithDAO Token.sol
249      * @param _spender The address which will spend the funds.
250      * @param _subtractedValue The amount of tokens to decrease the allowance by.
251      */
252     function decreaseApproval(
253         address _spender,
254         uint256 _subtractedValue
255     )
256     public
257     returns (bool)
258     {
259         uint256 oldValue = allowed[msg.sender][_spender];
260         if (_subtractedValue >= oldValue) {
261             allowed[msg.sender][_spender] = 0;
262         } else {
263             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264         }
265         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266         return true;
267     }
268 
269 }
270 
271 /**
272  * @title Ownable
273  * @dev The Ownable contract has an owner address, and provides basic authorization control
274  * functions, this simplifies the implementation of "user permissions".
275  */
276 contract Ownable {
277     address public owner;
278 
279 
280     event OwnershipRenounced(address indexed previousOwner);
281     event OwnershipTransferred(
282         address indexed previousOwner,
283         address indexed newOwner
284     );
285 
286 
287     /**
288      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289      * account.
290      */
291     constructor() public {
292         owner = msg.sender;
293     }
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(msg.sender == owner);
299         _;
300     }
301 
302     /**
303      * @dev Allows the current owner to transfer control of the contract to a newOwner.
304      * @param _newOwner The address to transfer ownership to.
305      */
306     function transferOwnership(address _newOwner) public onlyOwner {
307         _transferOwnership(_newOwner);
308     }
309 
310     /**
311      * @dev Transfers control of the contract to a newOwner.
312      * @param _newOwner The address to transfer ownership to.
313      */
314     function _transferOwnership(address _newOwner) internal {
315         require(_newOwner != address(0));
316         emit OwnershipTransferred(owner, _newOwner);
317         owner = _newOwner;
318     }
319 }
320 
321 
322 /**
323  * @title PRECHARGE
324  *
325  * Symbol      : PCPi
326  * Name        : Precharge
327  * Total supply: 10,000,000,000.000000000000000000
328  * Decimals    : 18
329  *
330  */
331 contract Precharge is StandardToken, BurnableToken, Ownable {
332     using SafeMath for uint256;
333 
334     string public constant name = "Precharge";
335     string public constant symbol = "PCPi";
336     uint8 public constant decimals = 18;
337 
338     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
339 
340     /**
341     * @dev Constructor that gives msg.sender all of existing tokens.
342     */
343     constructor () public {
344         totalSupply_ = INITIAL_SUPPLY;
345         balances[msg.sender] = INITIAL_SUPPLY;
346     }
347 
348     /**
349     * @dev Owner can transfer out any accidentally sent ERC20 tokens
350     */
351     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
352         return ERC20Basic(tokenAddress).transfer(owner, tokens);
353     }
354 }