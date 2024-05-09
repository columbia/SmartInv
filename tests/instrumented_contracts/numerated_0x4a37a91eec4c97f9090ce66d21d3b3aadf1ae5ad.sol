1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13 
14     event OwnershipRenounced(address indexed previousOwner);
15     event OwnershipTransferred(
16         address indexed previousOwner,
17         address indexed newOwner
18     );
19 
20 
21     /**
22     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23     * account.
24     */
25     constructor() public {
26         owner = msg.sender;
27     }
28 
29     /**
30     * @dev Throws if called by any account other than the owner.
31     */
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     /**
38     * @dev Allows the current owner to relinquish control of the contract.
39     */
40     function renounceOwnership() public onlyOwner {
41         emit OwnershipRenounced(owner);
42         owner = address(0);
43     }
44 
45     /**
46     * @dev Allows the current owner to transfer control of the contract to a newOwner.
47     * @param _newOwner The address to transfer ownership to.
48     */
49     function transferOwnership(address _newOwner) public onlyOwner {
50         _transferOwnership(_newOwner);
51     }
52 
53     /**
54     * @dev Transfers control of the contract to a newOwner.
55     * @param _newOwner The address to transfer ownership to.
56     */
57     function _transferOwnership(address _newOwner) internal {
58         require(_newOwner != address(0));
59         emit OwnershipTransferred(owner, _newOwner);
60         owner = _newOwner;
61     }
62 }
63 
64 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         c = a * b;
84         assert(c / a == b);
85         return c;
86     }
87 
88     /**
89     * @dev Integer division of two numbers, truncating the quotient.
90     */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // assert(b > 0); // Solidity automatically throws when dividing by 0
93         // uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95         return a / b;
96     }
97 
98     /**
99     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100     */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         assert(b <= a);
103         return a - b;
104     }
105 
106     /**
107     * @dev Adds two numbers, throws on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110         c = a + b;
111         assert(c >= a);
112         return c;
113     }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124     function totalSupply() public view returns (uint256);
125     function balanceOf(address who) public view returns (uint256);
126     function transfer(address to, uint256 value) public returns (bool);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137     using SafeMath for uint256;
138 
139     mapping(address => uint256) balances;
140 
141     uint256 totalSupply_;
142 
143     /**
144     * @dev total number of tokens in existence
145     */
146     function totalSupply() public view returns (uint256) {
147         return totalSupply_;
148     }
149 
150     /**
151     * @dev transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[msg.sender]);
158 
159         balances[msg.sender] = balances[msg.sender].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         emit Transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Gets the balance of the specified address.
167     * @param _owner The address to query the the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function balanceOf(address _owner) public view returns (uint256) {
171         return balances[_owner];
172     }
173 
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183     function allowance(address owner, address spender)
184         public view returns (uint256);
185 
186     function transferFrom(address from, address to, uint256 value)
187         public returns (bool);
188 
189     function approve(address spender, uint256 value) public returns (bool);
190     event Approval(
191         address indexed owner,
192         address indexed spender,
193         uint256 value
194     );
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208     mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211     /**
212     * @dev Transfer tokens from one address to another
213     * @param _from address The address which you want to send tokens from
214     * @param _to address The address which you want to transfer to
215     * @param _value uint256 the amount of tokens to be transferred
216     */
217     function transferFrom(
218         address _from,
219         address _to,
220         uint256 _value
221     )
222         public
223         returns (bool)
224     {
225         require(_to != address(0));
226         require(_value <= balances[_from]);
227         require(_value <= allowed[_from][msg.sender]);
228 
229         balances[_from] = balances[_from].sub(_value);
230         balances[_to] = balances[_to].add(_value);
231         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232         emit Transfer(_from, _to, _value);
233         return true;
234     }
235 
236     /**
237     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238     *
239     * Beware that changing an allowance with this method brings the risk that someone may use both the old
240     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243     * @param _spender The address which will spend the funds.
244     * @param _value The amount of tokens to be spent.
245     */
246     function approve(address _spender, uint256 _value) public returns (bool) {
247         allowed[msg.sender][_spender] = _value;
248         emit Approval(msg.sender, _spender, _value);
249         return true;
250     }
251 
252     /**
253     * @dev Function to check the amount of tokens that an owner allowed to a spender.
254     * @param _owner address The address which owns the funds.
255     * @param _spender address The address which will spend the funds.
256     * @return A uint256 specifying the amount of tokens still available for the spender.
257     */
258     function allowance(
259         address _owner,
260         address _spender
261     )
262         public
263         view
264         returns (uint256)
265     {
266         return allowed[_owner][_spender];
267     }
268 }
269 
270 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
271 
272 /**
273  * @title Mintable token
274  * @dev Simple ERC20 Token example, with mintable token creation
275  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
276  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
277  */
278 contract MintableToken is StandardToken, Ownable {
279     event Mint(address indexed to, uint256 amount);
280     event MintFinished();
281 
282     bool public mintingFinished = false;
283 
284 
285     modifier canMint() {
286         require(!mintingFinished);
287         _;
288     }
289 
290     modifier hasMintPermission() {
291         require(msg.sender == owner);
292         _;
293     }
294 
295     /**
296     * @dev Function to mint tokens
297     * @param _to The address that will receive the minted tokens.
298     * @param _amount The amount of tokens to mint.
299     * @return A boolean that indicates if the operation was successful.
300     */
301     function mint(
302         address _to,
303         uint256 _amount
304     )
305         hasMintPermission
306         canMint
307         public
308         returns (bool)
309     {
310         totalSupply_ = totalSupply_.add(_amount);
311         balances[_to] = balances[_to].add(_amount);
312         emit Mint(_to, _amount);
313         emit Transfer(address(0), _to, _amount);
314         return true;
315     }
316 
317     /**
318     * @dev Function to stop minting new tokens.
319     * @return True if the operation was successful.
320     */
321     function finishMinting() onlyOwner canMint public returns (bool) {
322         mintingFinished = true;
323         emit MintFinished();
324         return true;
325     }
326 }
327 
328 // File: contracts/LiquorChainToken.part.sol
329 
330 contract TokenTimelock is Ownable {
331     
332     mapping (address => uint) public releaseTime;
333     
334     modifier timeLocked(address _from) {
335         require(block.timestamp > releaseTime[_from]);
336         _;
337     }
338     
339     function setTimeLock(address _beneficiary, uint _timestamp) onlyOwner public returns (bool) {
340         releaseTime[_beneficiary] = _timestamp;
341         return true;
342     }
343 }
344 
345 contract LiquorChainToken is MintableToken, TokenTimelock {
346 
347     string public name = "LiquorChain Token";
348     string public symbol = "LCT";
349     string public version = "1.1.0";
350     uint8 public decimals = 18;
351 
352     constructor() public {
353         uint256 unit = (10**(uint256(decimals)));
354         mint(0xa26B90E17167a857baF99e768302348335FCee29, 30000000 * unit);
355         mint(0xe6Bc6483b8DBa035eE5f04905CdDA62C0e6d6c31, 30000000 * unit);
356         mint(0xBcDB7820604d4089f517f5A769c972c138F7e45A, 40000000 * unit);
357         mint(0x1011c745234dE02767e78a22134764D61526eb89, 100000000 * unit);
358         mint(0xf47fe22aC5bbA4017177e4940FC48c1E6FF70524, 100000000 * unit);
359     }
360     
361     function transfer(address _to, uint256 _value) timeLocked(msg.sender) public returns (bool) {
362         return super.transfer(_to, _value);
363     }
364     
365     function transferFrom(
366         address _from,
367         address _to,
368         uint256 _value
369     )
370         timeLocked(_from)
371         public
372         returns (bool)
373     {
374         return super.transferFrom(_from, _to, _value);
375     }
376 }