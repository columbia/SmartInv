1 pragma solidity ^0.4.23;
2 
3 contract ERC20Interface {
4     //ERC20 with allowance
5     function allowance(address owner, address spender) public view returns (uint256);
6     function transferFrom(address from, address to, uint256 value) public returns (bool);
7     function approve(address spender, uint256 value) public returns (bool);
8     event Approval(
9         address indexed owner,
10         address indexed spender,
11         uint256 value
12     );
13 
14     // ERC20 Basic
15     function totalSupply() public view returns (uint256);
16     function balanceOf(address who) public view returns (uint256);
17     function transfer(address to, uint256 value) public returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 contract StandardERC20 is ERC20Interface {
22     using SafeMath for uint256;
23 
24     mapping(address => uint256) balances;
25     uint256 totalSupply_;
26 
27     /**
28     * @dev Total number of tokens in existence
29     */
30     function totalSupply() public view returns (uint256) {
31         return totalSupply_;
32     }
33 
34     /**
35     * @dev Transfer token for a specified address
36     * @param _to The address to transfer to.
37     * @param _value The amount to be transferred.
38     */
39     function transfer(address _to, uint256 _value) public returns (bool) {
40         require(_to != address(0));
41         require(_value <= balances[msg.sender]);
42 
43         balances[msg.sender] = balances[msg.sender].sub(_value);
44         balances[_to] = balances[_to].add(_value);
45         emit Transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49     /**
50     * @dev Gets the balance of the specified address.
51     * @param _owner The address to query the the balance of.
52     * @return An uint256 representing the amount owned by the passed address.
53     */
54     function balanceOf(address _owner) public view returns (uint256) {
55         return balances[_owner];
56     }
57 
58     /*
59         Allowance part
60     */
61 
62     mapping (address => mapping (address => uint256)) internal allowed;
63 
64 
65     /**
66     * @dev Transfer tokens from one address to another
67     * @param _from address The address which you want to send tokens from
68     * @param _to address The address which you want to transfer to
69     * @param _value uint256 the amount of tokens to be transferred
70     */
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[_from]);
74         require(_value <= allowed[_from][msg.sender]);
75 
76         balances[_from] = balances[_from].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79         emit Transfer(_from, _to, _value);
80         return true;
81     }
82 
83     /**
84     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
85     * Beware that changing an allowance with this method brings the risk that someone may use both the old
86     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
87     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
88     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89     * @param _spender The address which will spend the funds.
90     * @param _value The amount of tokens to be spent.
91     */
92     function approve(address _spender, uint256 _value) public returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     /**
99     * @dev Function to check the amount of tokens that an owner allowed to a spender.
100     * @param _owner address The address which owns the funds.
101     * @param _spender address The address which will spend the funds.
102     * @return A uint256 specifying the amount of tokens still available for the spender.
103     */
104     function allowance(address _owner, address _spender) public view returns (uint256) {
105         return allowed[_owner][_spender];
106     }
107 
108     /**
109     * @dev Increase the amount of tokens that an owner allowed to a spender.
110     * approve should be called when allowed[_spender] == 0. To increment
111     * allowed value is better to use this function to avoid 2 calls (and wait until
112     * the first transaction is mined)
113     * From MonolithDAO Token.sol
114     * @param _spender The address which will spend the funds.
115     * @param _addedValue The amount of tokens to increase the allowance by.
116     */
117     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
118         allowed[msg.sender][_spender] = (
119         allowed[msg.sender][_spender].add(_addedValue));
120         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121         return true;
122     }
123 
124     /**
125     * @dev Decrease the amount of tokens that an owner allowed to a spender.
126     * approve should be called when allowed[_spender] == 0. To decrement
127     * allowed value is better to use this function to avoid 2 calls (and wait until
128     * the first transaction is mined)
129     * From MonolithDAO Token.sol
130     * @param _spender The address which will spend the funds.
131     * @param _subtractedValue The amount of tokens to decrease the allowance by.
132     */
133     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
134         uint256 oldValue = allowed[msg.sender][_spender];
135         if (_subtractedValue > oldValue) {
136             allowed[msg.sender][_spender] = 0;
137         } else {
138             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
139         }
140         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141         return true;
142     }
143 }
144 
145 contract Token is StandardERC20 {
146     
147     string public name    = "Genuine Token";
148     string public symbol  = "GNU";
149     uint8  public decimals = 18;
150 
151     address owner;
152 
153     bool burnable;
154 
155     event Transfer(address indexed from, address indexed to, uint value, bytes data);
156 
157     event Burn(address indexed burner, uint256 value);
158 
159 
160     constructor() public {
161         balances[msg.sender] = 340000000 * (uint(10) ** decimals);
162         totalSupply_ = balances[msg.sender];
163         owner = msg.sender;
164         burnable = false;
165     }
166 
167     function transferOwnership(address tbo) public {
168         require(msg.sender == owner, 'Unauthorized');
169         owner = tbo;
170     }
171        
172     // Function to access name of token .
173     function name() public view returns (string _name) {
174         return name;
175     }
176     
177     // Function to access symbol of token .
178     function symbol() public view returns (string _symbol) {
179         return symbol;
180     }
181     
182     // Function to access decimals of token .
183     function decimals() public view returns (uint8 _decimals) {
184         return decimals;
185     }
186     
187     // Function to access total supply of tokens .
188     function totalSupply() public view returns (uint256 _totalSupply) {
189         return totalSupply_;
190     }
191     
192     // Function that is called when a user or another contract wants to transfer funds .
193     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
194         require(_to != address(0));
195 
196         if (isContract(_to)) {
197             if (balanceOf(msg.sender) < _value) revert();
198             balances[msg.sender] = balanceOf(msg.sender).sub(_value);
199             balances[_to] = balanceOf(_to).add(_value);
200             assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));
201             emit Transfer(msg.sender, _to, _value, _data);
202             // ERC20 compliant transfer
203             emit Transfer(msg.sender, _to, _value);
204             return true;
205         } else {
206             return transferToAddress(_to, _value, _data);
207         }
208     }
209   
210 
211     // Function that is called when a user or another contract wants to transfer funds .
212     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
213         require(_to != address(0));
214         
215         if (isContract(_to)) {
216             return transferToContract(_to, _value, _data);
217         }
218         else {
219             return transferToAddress(_to, _value, _data);
220         }
221     }
222     
223     // Standard function transfer similar to ERC20 transfer with no _data .
224     // Added due to backwards compatibility reasons .
225     // Overrides the base transfer function of the standard ERC20 token
226     function transfer(address _to, uint _value) public returns (bool success) {
227         require(_to != address(0));
228         
229         //standard function transfer similar to ERC20 transfer with no _data
230         //added due to backwards compatibility reasons
231         bytes memory empty;
232         if (isContract(_to)) {
233             return transferToContract(_to, _value, empty);
234         }
235         else {
236             return transferToAddress(_to, _value, empty);
237         }
238     }
239 
240     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
241     function isContract(address _addr) private view returns (bool is_contract) {
242         uint length;
243         assembly {
244                 //retrieve the size of the code on target address, this needs assembly
245                 length := extcodesize(_addr)
246         }
247         return (length > 0);
248     }
249 
250     //function that is called when transaction target is an address
251     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
252         if (balanceOf(msg.sender) < _value) revert("Insufficient balance");
253         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
254         balances[_to] = balanceOf(_to).add(_value);
255         emit Transfer(msg.sender, _to, _value, _data);
256         // ERC20 compliant transfer
257         emit Transfer(msg.sender, _to, _value);
258         return true;
259     }
260     
261     //function that is called when transaction target is a contract
262     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
263         if (balanceOf(msg.sender) < _value) revert("Insufficient balance");
264         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
265         balances[_to] = balanceOf(_to).add(_value);
266         ContractReceiver receiver = ContractReceiver(_to);
267         receiver.tokenFallback(msg.sender, _value, _data);
268         emit Transfer(msg.sender, _to, _value, _data);
269         // ERC20 compliant transfer
270         emit Transfer(msg.sender, _to, _value);
271         return true;
272     }
273 
274     function setBurnable(bool _burnable) public {
275         require (msg.sender == owner);
276         burnable = _burnable;
277     }
278 
279     /**
280      * @dev Burns a specific amount of tokens.
281      * @param _value The amount of token to be burned.
282      */
283     function burn(uint256 _value) public {
284         _burn(msg.sender, _value);
285     }
286 
287     function _burn(address _who, uint256 _value) internal {
288 
289         require(burnable == true || _who == owner);
290 
291         require(_value <= balances[_who]);
292         // no need to require value <= totalSupply, since that would imply the
293         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
294 
295         balances[_who] = balances[_who].sub(_value);
296         totalSupply_ = totalSupply_.sub(_value);
297         emit Burn(_who, _value);
298         emit Transfer(_who, address(0), _value);
299     }
300 }
301 pragma solidity ^0.4.23;
302 
303 // Source https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
304 
305 /**
306  * @title SafeMath
307  * @dev Math operations with safety checks that throw on error
308  */
309 library SafeMath {
310 
311     /**
312     * @dev Multiplies two numbers, throws on overflow.
313     */
314     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
315         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
316         // benefit is lost if 'b' is also tested.
317         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
318         if (a == 0) {
319             return 0;
320         }
321 
322         c = a * b;
323         assert(c / a == b);
324         return c;
325     }
326 
327     /**
328     * @dev Integer division of two numbers, truncating the quotient.
329     */
330     function div(uint256 a, uint256 b) internal pure returns (uint256) {
331         // assert(b > 0); // Solidity automatically throws when dividing by 0
332         // uint256 c = a / b;
333         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
334         return a / b;
335     }
336 
337     /**
338     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
339     */
340     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
341         assert(b <= a);
342         return a - b;
343     }
344 
345     /**
346     * @dev Adds two numbers, throws on overflow.
347     */
348     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
349         c = a + b;
350         assert(c >= a);
351         return c;
352     }
353 }
354 contract ContractReceiver {
355     function tokenFallback(address _from, uint _value, bytes _data) public;
356 }