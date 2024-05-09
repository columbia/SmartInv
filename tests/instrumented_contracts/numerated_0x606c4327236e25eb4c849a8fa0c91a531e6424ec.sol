1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23     function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26     function approve(address spender, uint256 value) public returns (bool);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         if (a == 0) {
45             return 0;
46         }
47         c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         // uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return a / b;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74         c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85     using SafeMath for uint256;
86 
87     mapping(address => uint256) balances;
88 
89     uint256 totalSupply_;
90 
91     /**
92     * @dev total number of tokens in existence
93     */
94     function totalSupply() public view returns (uint256) {
95         return totalSupply_;
96     }
97 
98     /**
99     * @dev transfer token for a specified address
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     */
103     function transfer(address _to, uint256 _value) public returns (bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106 
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         emit Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param _owner The address to query the the balance of.
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address _owner) public view returns (uint256) {
119         return balances[_owner];
120     }
121 }
122 
123 
124 /**
125  * @title Burnable Token
126  * @dev Token that can be irreversibly burned (destroyed).
127  */
128 contract BurnableToken is BasicToken {
129 
130     event Burn(address indexed burner, uint256 value);
131 
132     /**
133      * @dev Burns a specific amount of tokens.
134      * @param _value The amount of token to be burned.
135      */
136     function burn(uint256 _value) public {
137         _burn(msg.sender, _value);
138     }
139 
140     function _burn(address _who, uint256 _value) internal {
141         require(_value <= balances[_who]);
142         // no need to require value <= totalSupply, since that would imply the
143         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
144 
145         balances[_who] = balances[_who].sub(_value);
146         totalSupply_ = totalSupply_.sub(_value);
147         emit Burn(_who, _value);
148         emit Transfer(_who, address(0), _value);
149     }
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     address public owner;
159 
160 
161     event OwnershipRenounced(address indexed previousOwner);
162     event OwnershipTransferred(
163         address indexed previousOwner,
164         address indexed newOwner
165     );
166 
167 
168     /**
169      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170      * account.
171      */
172     constructor() public {
173         owner = msg.sender;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(msg.sender == owner);
181         _;
182     }
183 
184     /**
185      * @dev Allows the current owner to transfer control of the contract to a newOwner.
186      * @param newOwner The address to transfer ownership to.
187      */
188     function transferOwnership(address newOwner) public onlyOwner {
189         require(newOwner != address(0));
190         emit OwnershipTransferred(owner, newOwner);
191         owner = newOwner;
192     }
193 
194     /**
195      * @dev Allows the current owner to relinquish control of the contract.
196      */
197     function renounceOwnership() public onlyOwner {
198         emit OwnershipRenounced(owner);
199         owner = address(0);
200     }
201 }
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, BasicToken, Ownable {
211 
212     mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215     /**
216      * @dev Transfer tokens from one address to another
217      * @param _from address The address which you want to send tokens from
218      * @param _to address The address which you want to transfer to
219      * @param _value uint256 the amount of tokens to be transferred
220      */
221     function transferFrom (
222         address _from,
223         address _to,
224         uint256 _value
225     )
226     public
227     returns (bool)
228     {
229         require(_to != address(0));
230         require(_value <= balances[_from]);
231         require(_value <= allowed[_from][msg.sender]);
232 
233         balances[_from] = balances[_from].sub(_value);
234         balances[_to] = balances[_to].add(_value);
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         emit Transfer(_from, _to, _value);
237         return true;
238     }
239 
240     /**
241      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242      *
243      * Beware that changing an allowance with this method brings the risk that someone may use both the old
244      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247      * @param _spender The address which will spend the funds.
248      * @param _value The amount of tokens to be spent.
249      */
250     function approve(address _spender, uint256 _value) public onlyOwner returns (bool) {
251         allowed[msg.sender][_spender] = _value;
252         emit Approval(msg.sender, _spender, _value);
253         return true;
254     }
255 
256     /**
257      * @dev Function to check the amount of tokens that an owner allowed to a spender.
258      * @param _owner address The address which owns the funds.
259      * @param _spender address The address which will spend the funds.
260      * @return A uint256 specifying the amount of tokens still available for the spender.
261      */
262     function allowance(
263         address _owner,
264         address _spender
265     )
266     public
267     view
268     returns (uint256)
269     {
270         return allowed[_owner][_spender];
271     }
272 
273     /**
274      * @dev Increase the amount of tokens that an owner allowed to a spender.
275      *
276      * approve should be called when allowed[_spender] == 0. To increment
277      * allowed value is better to use this function to avoid 2 calls (and wait until
278      * the first transaction is mined)
279      * From MonolithDAO Token.sol
280      * @param _spender The address which will spend the funds.
281      * @param _addedValue The amount of tokens to increase the allowance by.
282      */
283     function increaseApproval(
284         address _spender,
285         uint _addedValue
286     )
287     public
288     returns (bool)
289     {
290         allowed[msg.sender][_spender] = (
291         allowed[msg.sender][_spender].add(_addedValue));
292         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293         return true;
294     }
295 
296     /**
297      * @dev Decrease the amount of tokens that an owner allowed to a spender.
298      *
299      * approve should be called when allowed[_spender] == 0. To decrement
300      * allowed value is better to use this function to avoid 2 calls (and wait until
301      * the first transaction is mined)
302      * From MonolithDAO Token.sol
303      * @param _spender The address which will spend the funds.
304      * @param _subtractedValue The amount of tokens to decrease the allowance by.
305      */
306     function decreaseApproval(
307         address _spender,
308         uint _subtractedValue
309     )
310     public
311     returns (bool)
312     {
313         uint oldValue = allowed[msg.sender][_spender];
314         if (_subtractedValue > oldValue) {
315             allowed[msg.sender][_spender] = 0;
316         } else {
317             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318         }
319         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320         return true;
321     }
322 }
323 
324 /**
325  * @title Standard Burnable Token
326  * @dev Adds burnFrom method to ERC20 implementations
327  */
328 contract StandardBurnableToken is BurnableToken, StandardToken {
329 
330     /**
331      * @dev Burns a specific amount of tokens from the target address and decrements allowance
332      * @param _from address The address which you want to send tokens from
333      * @param _value uint256 The amount of token to be burned
334      */
335     function burnFrom(address _from, uint256 _value) public onlyOwner {
336         require(_value <= allowed[_from][msg.sender]);
337         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
338         // this function needs to emit an event with the updated approval.
339         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
340         _burn(_from, _value);
341     }
342 }
343 
344 
345 contract Molecule is StandardBurnableToken {
346 
347     string  public constant name     = "Molecule Token";
348     string  public constant symbol   = "MLC";
349     uint32  public constant decimals = 18;
350 
351     uint256 public constant INITIAL_SUPPLY = 20000000 * (10 ** uint256(decimals));
352 
353     /**
354     * @dev Constructor that gives msg.sender all of existing tokens.
355     */
356     constructor() public {
357 
358         totalSupply_         = INITIAL_SUPPLY;
359         balances[msg.sender] = INITIAL_SUPPLY;
360 
361         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
362     }
363 }