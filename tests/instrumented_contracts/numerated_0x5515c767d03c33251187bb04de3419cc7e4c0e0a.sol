1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two numbers, reverts on overflow.
11      */
12     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (_a == 0) {
17             return 0;
18         }
19 
20         uint256 c = _a * _b;
21         require(c / _a == _b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30         require(_b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = _a / _b;
32         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41         require(_b <= _a);
42         uint256 c = _a - _b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two numbers, reverts on overflow.
49      */
50     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51         uint256 c = _a + _b;
52         require(c >= _a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 {
73     function totalSupply() public view returns (uint256);
74 
75     function balanceOf(address _who) public view returns (uint256);
76 
77     function allowance(address _owner, address _spender)
78         public view returns (uint256);
79 
80     function transfer(address _to, uint256 _value) public returns (bool);
81 
82     function approve(address _spender, uint256 _value)
83         public returns (bool);
84 
85     function transferFrom(address _from, address _to, uint256 _value)
86         public returns (bool);
87 
88     event Transfer(
89         address indexed from,
90         address indexed to,
91         uint256 value
92     );
93 
94     event Approval(
95         address indexed owner,
96         address indexed spender,
97         uint256 value
98     );
99 }
100 
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108     address public owner;
109 
110     event OwnershipRenounced(address indexed previousOwner);
111     event OwnershipTransferred(
112         address indexed previousOwner,
113         address indexed newOwner
114     );
115 
116 
117     /**
118      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
119      * account.
120      */
121     constructor() public {
122         owner = msg.sender;
123     }
124 
125     /**
126      * @dev Throws if called by any account other than the owner.
127      */
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     /**
134      * @dev Allows the current owner to relinquish control of the contract.
135      * @notice Renouncing to ownership will leave the contract without an owner.
136      * It will not be possible to call the functions with the `onlyOwner`
137      * modifier anymore.
138      */
139     function renounceOwnership() public onlyOwner {
140         emit OwnershipRenounced(owner);
141         owner = address(0);
142     }
143 
144     /**
145      * @dev Allows the current owner to transfer control of the contract to a newOwner.
146      * @param _newOwner The address to transfer ownership to.
147      */
148     function transferOwnership(address _newOwner) public onlyOwner {
149         _transferOwnership(_newOwner);
150     }
151 
152     /**
153      * @dev Transfers control of the contract to a newOwner.
154      * @param _newOwner The address to transfer ownership to.
155      */
156     function _transferOwnership(address _newOwner) internal {
157         require(_newOwner != address(0));
158         emit OwnershipTransferred(owner, _newOwner);
159         owner = _newOwner;
160     }
161 }
162 
163 /**
164  * @title Standard ERC20 token
165  *
166  * @dev Implementation of the basic standard token.
167  * https://github.com/ethereum/EIPs/issues/20
168  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  */
170 contract StandardToken is ERC20, Ownable {
171     using SafeMath for uint256;
172 
173     mapping(address => uint256) balances;
174 
175     mapping (address => mapping (address => uint256)) internal allowed;
176 
177     uint256 totalSupply_;
178 
179     address public firstMile;
180 
181     modifier onlyFirstMile() {
182         require(firstMile == msg.sender);
183         _;
184     }
185 
186     function setFirstMile(address _address) external onlyOwner  {
187         firstMile = _address;
188     }
189 
190     /**
191      * @dev Total number of tokens in existence
192      */
193     function totalSupply() public view returns (uint256) {
194         return totalSupply_;
195     }
196 
197     /**
198      * @dev Gets the balance of the specified address.
199      * @param _owner The address to query the the balance of.
200      * @return An uint256 representing the amount owned by the passed address.
201      */
202     function balanceOf(address _owner) public view returns (uint256) {
203         return balances[_owner];
204     }
205 
206     /**
207     * @dev Function to check the amount of tokens that an owner allowed to a spender.
208     * @param _owner address The address which owns the funds.
209     * @param _spender address The address which will spend the funds.
210     * @return A uint256 specifying the amount of tokens still available for the spender.
211     */
212     function allowance(
213         address _owner,
214         address _spender
215     )
216         public
217         view
218         returns (uint256)
219     {
220         return allowed[_owner][_spender];
221     }
222 
223     /**
224      * @dev Transfer token for a specified address
225      * @param _to The address to transfer to.
226      * @param _value The amount to be transferred.
227      */
228     function transfer(address _to, uint256 _value) public onlyFirstMile returns (bool) {
229         require(_value <= balances[msg.sender]);
230         require(_to != address(0));
231 
232         balances[msg.sender] = balances[msg.sender].sub(_value);
233         balances[_to] = balances[_to].add(_value);
234         emit Transfer(msg.sender, _to, _value);
235         return true;
236     }
237 
238     /**
239      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240      * Beware that changing an allowance with this method brings the risk that someone may use both the old
241      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      * @param _spender The address which will spend the funds.
245      * @param _value The amount of tokens to be spent.
246      */
247     function approve(address _spender, uint256 _value) public onlyFirstMile returns (bool) {
248         allowed[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252 
253     /**
254      * @dev Transfer tokens from one address to another
255      * @param _from address The address which you want to send tokens from
256      * @param _to address The address which you want to transfer to
257      * @param _value uint256 the amount of tokens to be transferred
258      */
259     function transferFrom(
260         address _from,
261         address _to,
262         uint256 _value
263     )
264         public
265         onlyFirstMile
266         returns (bool)
267     {
268         require(_value <= balances[_from]);
269         require(_value <= allowed[_from][msg.sender]);
270         require(_to != address(0));
271 
272         balances[_from] = balances[_from].sub(_value);
273         balances[_to] = balances[_to].add(_value);
274         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
275         emit Transfer(_from, _to, _value);
276         return true;
277     }
278 
279     /**
280      * @dev Increase the amount of tokens that an owner allowed to a spender.
281      * approve should be called when allowed[_spender] == 0. To increment
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * @param _spender The address which will spend the funds.
286      * @param _addedValue The amount of tokens to increase the allowance by.
287      */
288     function increaseApproval(
289         address _spender,
290         uint256 _addedValue
291     )
292         public
293         onlyFirstMile
294         returns (bool)
295     {
296         allowed[msg.sender][_spender] = (
297           allowed[msg.sender][_spender].add(_addedValue)
298         );
299         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300         return true;
301     }
302 
303     /**
304      * @dev Decrease the amount of tokens that an owner allowed to a spender.
305      * approve should be called when allowed[_spender] == 0. To decrement
306      * allowed value is better to use this function to avoid 2 calls (and wait until
307      * the first transaction is mined)
308      * From MonolithDAO Token.sol
309      * @param _spender The address which will spend the funds.
310      * @param _subtractedValue The amount of tokens to decrease the allowance by.
311      */
312     function decreaseApproval(
313         address _spender,
314         uint256 _subtractedValue
315     )
316         public
317         onlyFirstMile
318         returns (bool)
319     {
320         uint256 oldValue = allowed[msg.sender][_spender];
321         if (_subtractedValue >= oldValue) {
322             allowed[msg.sender][_spender] = 0;
323         } else {
324             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
325         }
326         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327         return true;
328     }
329 
330 }
331 
332 
333 /**
334  * @title Mintable token
335  * @dev Simple ERC20 Token example, with mintable token creation
336  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
337  */
338 contract MintableToken is StandardToken {
339     event Mint(address indexed to, uint256 amount);
340     event MintFinished();
341 
342     bool public mintingFinished = false;    
343 
344     modifier canMint() {
345         require(!mintingFinished);
346         _;
347     }
348 
349     modifier hasMintPermission() {
350         require(msg.sender == owner);
351         _;
352     }
353 
354     /**
355      * @dev Function to mint tokens
356      * @param _to The address that will receive the minted tokens.
357      * @param _amount The amount of tokens to mint.
358      * @return A boolean that indicates if the operation was successful.
359      */
360     function mint(
361         address _to,
362         uint256 _amount
363     )
364         public
365         hasMintPermission
366         canMint
367         returns (bool)
368     {
369         totalSupply_ = totalSupply_.add(_amount);
370         balances[_to] = balances[_to].add(_amount);
371         emit Mint(_to, _amount);
372         emit Transfer(address(0), _to, _amount);
373         return true;
374     }
375 
376     /**
377      * @dev Function to stop minting new tokens.
378      * @return True if the operation was successful.
379      */
380     function finishMinting() public onlyOwner canMint returns (bool) {
381         mintingFinished = true;
382         emit MintFinished();
383         return true;
384     }
385 }
386 
387 
388 contract ConvertibleToken is MintableToken {
389     string public name = "Convertible Token for KEYO";
390     string public symbol = "CT-KEYO";
391     uint8 public decimals = 18;
392 }