1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    * @notice Renouncing to ownership will leave the contract without an owner.
90    * It will not be possible to call the functions with the `onlyOwner`
91    * modifier anymore.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param _newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   /**
107    * @dev Transfers control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function _transferOwnership(address _newOwner) internal {
111     require(_newOwner != address(0));
112     emit OwnershipTransferred(owner, _newOwner);
113     owner = _newOwner;
114   }
115 }
116 
117 
118 /**
119  * @title Contactable token
120  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
121  * contact information.
122  */
123 contract Contactable is Ownable {
124 
125   string public contactInformation;
126 
127   /**
128     * @dev Allows the owner to set a string with their contact information.
129     * @param _info The contact information to attach to the contract.
130     */
131   function setContactInformation(string _info) public onlyOwner {
132     contactInformation = _info;
133   }
134 }
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 interface IERC20 {
141   function totalSupply() external view returns (uint256);
142 
143   function balanceOf(address who) external view returns (uint256);
144 
145   function allowance(address owner, address spender)
146     external view returns (uint256);
147 
148   function transfer(address to, uint256 value) external returns (bool);
149 
150   function approve(address spender, uint256 value)
151     external returns (bool);
152 
153   function transferFrom(address from, address to, uint256 value)
154     external returns (bool);
155 
156   event Transfer(
157     address indexed from,
158     address indexed to,
159     uint256 value
160   );
161 
162   event Approval(
163     address indexed owner,
164     address indexed spender,
165     uint256 value
166   );
167 }
168 
169 /**
170  * @title SafeERC20
171  * @dev Wrappers around ERC20 operations that throw on failure.
172  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
173  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
174  */
175 library SafeERC20 {
176   function safeTransfer(
177     IERC20 token,
178     address to,
179     uint256 value
180   )
181     internal
182   {
183     require(token.transfer(to, value));
184   }
185 
186   function safeTransferFrom(
187     IERC20 token,
188     address from,
189     address to,
190     uint256 value
191   )
192     internal
193   {
194     require(token.transferFrom(from, to, value));
195   }
196 
197   function safeApprove(
198     IERC20 token,
199     address spender,
200     uint256 value
201   )
202     internal
203   {
204     require(token.approve(spender, value));
205   }
206 }
207 
208 /** Function to receive approval and execute in one call
209 */
210 contract ApproveAndCallFallBack {
211     function receiveApproval(address _from, uint256 _tokens, address _token, bytes _data) public;
212 }
213 
214 /**
215  * @title HEdpAY Token Contract that can hold and transfer ERC-20 tokens
216  */
217 contract HedpayToken is  IERC20, Contactable {
218 
219    using SafeMath for uint;
220 
221    string public  name;
222    string public symbol;
223    uint8 public decimals;
224    uint public _totalSupply;
225 
226    mapping(address => uint) balances;
227    mapping(address => mapping(address => uint)) allowed;
228 
229     /**
230     * @dev Constructor that sets the initial contract parameters
231     */
232     constructor() public {
233         name = "HEdpAY";
234         symbol = "Hdp.ф";
235         decimals = 4;
236         _totalSupply = 10000000000000; //1 billion * 10000 (decimals)
237         balances[owner] = _totalSupply;
238     }
239 
240     /**
241     * @dev Return actual totalSupply value
242     */
243     function totalSupply() public constant returns (uint) {
244         return _totalSupply  - balances[address(0)];
245     }
246 
247     /**
248     * @dev Get the token balance for account of token owner
249     */
250     function balanceOf(address _owner) public constant returns (uint balance) {
251         require(_owner != address(0));
252 		return balances[_owner];
253     }
254 
255     /**
256     * @dev Gets the specified accounts approval value
257     * @param _owner address the tokens owner
258     * @param _spender address the tokens spender
259     * @return uint the specified accounts spending tokens amount
260     */
261     function allowance(address _owner, address _spender)
262     public view returns (uint) {
263         require(_owner != address(0));
264         require(_spender != address(0));
265         return allowed[_owner][_spender];
266     }
267 
268     /**
269     * @dev Function to transfer tokens
270     * @param _to address the tokens recepient
271     * @param _value uint amount of the tokens to be transferred
272     */
273     function transfer(address _to, uint _value) public returns (bool success) {
274         balances[msg.sender] = balances[msg.sender].sub(_value);
275         balances[_to] = balances[_to].add(_value);
276         emit Transfer(msg.sender, _to, _value);
277         return true;
278     }
279 
280     /**
281     * @dev Function to transfer tokens from the approved `msg.sender` account
282     * @param _from address the tokens owner
283     * @param _to address the tokens recepient
284     * @param _value uint amount of the tokens to be transferred
285     */
286     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
287 		require(_from != address(0));
288         require(_to != address(0));
289         require(_value <= allowance(_from, msg.sender));
290         balances[_from] = balances[_from].sub(_value);
291         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293         emit Transfer(_from, _to, _value);
294 		emit Approval(_from, msg.sender, allowance(_from, msg.sender));
295         return true;
296     }
297 
298     /**
299     * @dev Function to approve account to spend owned tokens
300     * @param _spender address the tokens spender
301     * @param _value uint amount of the tokens to be approved
302     */
303    function approve(address _spender, uint _value) public  returns (bool success) {
304         allowed[msg.sender][_spender] = _value;
305         emit Approval(msg.sender, _spender, _value);
306         return true;
307     }
308 
309     /**
310     *@dev Function to approve for spender to transferFrom tokens
311     *@param _spender address of the spender
312     *@param _tokens the value of tokens for transferring
313     *@param _data is used for metadata
314     */
315     function approveAndCall(address _spender, uint _tokens, bytes _data) public returns (bool success) {
316         allowed[msg.sender][_spender] = _tokens;
317         emit Approval(msg.sender, _spender, _tokens);
318         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _tokens, this, _data);
319         return true;
320     }
321 
322     /**
323     *@dev Function allows owner to transfer out
324     *any accidentally sent tokens
325     *@param _tokenAddress the address of tokens holder
326     *@param _tokens the amount of tokens for transferring
327     */
328     function transferAnyERC20Token(address _tokenAddress, uint _tokens) public onlyOwner returns (bool success) {
329         return IERC20(_tokenAddress).transfer(owner, _tokens);
330     }
331 
332 }