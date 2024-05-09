1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender)
67     public view returns (uint256);
68 
69     function transferFrom(address from, address to, uint256 value)
70     public returns (bool);
71 
72     function approve(address spender, uint256 value) public returns (bool);
73     event Approval(
74         address indexed owner,
75         address indexed spender,
76         uint256 value
77     );
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
121 
122 }
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133     mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136     /**
137      * @dev Transfer tokens from one address to another
138      * @param _from address The address which you want to send tokens from
139      * @param _to address The address which you want to transfer to
140      * @param _value uint256 the amount of tokens to be transferred
141      */
142     function transferFrom(
143         address _from,
144         address _to,
145         uint256 _value
146     )
147     public
148     returns (bool)
149     {
150         require(_to != address(0));
151         require(_value <= balances[_from]);
152         require(_value <= allowed[_from][msg.sender]);
153 
154         balances[_from] = balances[_from].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     /**
162      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      *
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param _spender The address which will spend the funds.
169      * @param _value The amount of tokens to be spent.
170      */
171     function approve(address _spender, uint256 _value) public returns (bool) {
172         allowed[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178      * @dev Function to check the amount of tokens that an owner allowed to a spender.
179      * @param _owner address The address which owns the funds.
180      * @param _spender address The address which will spend the funds.
181      * @return A uint256 specifying the amount of tokens still available for the spender.
182      */
183     function allowance(
184         address _owner,
185         address _spender
186     )
187     public
188     view
189     returns (uint256)
190     {
191         return allowed[_owner][_spender];
192     }
193 
194     /**
195      * @dev Increase the amount of tokens that an owner allowed to a spender.
196      *
197      * approve should be called when allowed[_spender] == 0. To increment
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * @param _spender The address which will spend the funds.
202      * @param _addedValue The amount of tokens to increase the allowance by.
203      */
204     function increaseApproval(
205         address _spender,
206         uint _addedValue
207     )
208     public
209     returns (bool)
210     {
211         allowed[msg.sender][_spender] = (
212         allowed[msg.sender][_spender].add(_addedValue));
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217     /**
218      * @dev Decrease the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To decrement
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _subtractedValue The amount of tokens to decrease the allowance by.
226      */
227     function decreaseApproval(
228         address _spender,
229         uint _subtractedValue
230     )
231     public
232     returns (bool)
233     {
234         uint oldValue = allowed[msg.sender][_spender];
235         if (_subtractedValue > oldValue) {
236             allowed[msg.sender][_spender] = 0;
237         } else {
238             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239         }
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243 
244 }
245 
246 /**
247  * @title Ownable
248  * @dev The Ownable contract has an owner address, and provides basic authorization control
249  * functions, this simplifies the implementation of "user permissions".
250  */
251 contract Ownable {
252     address public owner;
253 
254 
255     event OwnershipRenounced(address indexed previousOwner);
256     event OwnershipTransferred(
257         address indexed previousOwner,
258         address indexed newOwner
259     );
260 
261 
262     /**
263      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
264      * account.
265      */
266     constructor() public {
267         owner = msg.sender;
268     }
269 
270     /**
271      * @dev Throws if called by any account other than the owner.
272      */
273     modifier onlyOwner() {
274         require(msg.sender == owner);
275         _;
276     }
277 
278     /**
279      * @dev Allows the current owner to transfer control of the contract to a newOwner.
280      * @param newOwner The address to transfer ownership to.
281      */
282     function transferOwnership(address newOwner) public onlyOwner {
283         require(newOwner != address(0));
284         emit OwnershipTransferred(owner, newOwner);
285         owner = newOwner;
286     }
287 
288     /**
289      * @dev Allows the current owner to relinquish control of the contract.
290      */
291     function renounceOwnership() public onlyOwner {
292         emit OwnershipRenounced(owner);
293         owner = address(0);
294     }
295 }
296 
297 /**
298  * @title Antiderivative Pre Token
299  */
300 contract PADVT is StandardToken, Ownable {
301 
302     string public constant name = "Antiderivative Pre Token"; // solium-disable-line uppercase
303     string public constant symbol = "PADVT"; // solium-disable-line uppercase
304     uint8 public constant decimals = 0; // solium-disable-line uppercase
305 
306     uint256 public constant INITIAL_SUPPLY = 10000000000;
307 
308     uint256 public swapTime;
309     address public swapAddr;
310 
311     /**
312      * @dev Constructor that gives msg.sender all of existing tokens.
313      */
314     constructor() public {
315         totalSupply_ = INITIAL_SUPPLY;
316         balances[msg.sender] = INITIAL_SUPPLY;
317         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
318     }
319 
320     /**
321      * @dev Reverts if swap must be enforced and `_to` is not the swap address.
322      */
323     modifier onlyBeforeSwap(address _to) {
324         // solium-disable-next-line security/no-block-members
325         if(swapTime != 0 && block.timestamp >= swapTime) require(_to == swapAddr);
326         _;
327     }
328     
329     /**
330      * @dev Set the enforced swap time and address
331      * @param _addr address The address to send tokens for the swap with main token
332      * @param _tstamp uint256 The time when the swap will be enforced
333      */
334     function setSwap(address _addr, uint256 _tstamp) public onlyOwner {
335         swapAddr = _addr;
336         swapTime = _tstamp;
337     }
338 
339     /**
340      * @dev Transfer tokens from one address to another before swap
341      * @param _from address The address which you want to send tokens from
342      * @param _to address The address which you want to transfer to
343      * @param _value uint256 the amount of tokens to be transferred
344      */
345     function transferFrom(
346         address _from,
347         address _to,
348         uint256 _value
349     )
350     public onlyBeforeSwap(_to)
351     returns (bool)
352     {
353         return super.transferFrom(_from, _to, _value);
354     }
355 
356     /**
357      * @dev transfer token for a specified address before swap
358      * @param _to The address to transfer to.
359      * @param _value The amount to be transferred.
360      */
361     function transfer(address _to, uint256 _value)
362     public onlyBeforeSwap(_to)
363     returns (bool) {
364        return super.transfer(_to,_value);
365     }
366 }