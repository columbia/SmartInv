1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/ERC20Basic.sol
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11 
12     function balanceOf(address who) public view returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/math/SafeMath.sol
22  */
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b > 0);
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/BasicToken.sol
55  */
56 contract BasicToken is ERC20Basic {
57     using SafeMath for uint256;
58 
59     mapping(address => uint256) balances;
60 
61     /**
62     * @dev Transfer token for a specified address
63     * @param _to The address to transfer to.
64     * @param _value The amount to be transferred.
65     */
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[msg.sender]);
69 
70         balances[msg.sender] = balances[msg.sender].sub(_value);
71         balances[_to] = balances[_to].add(_value);
72         Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     /**
77     * @dev Gets the balance of the specified address.
78     * @param _owner The address to query the the balance of.
79     * @return An uint256 representing the amount owned by the passed address.
80     */
81     function balanceOf(address _owner) public view returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/ERC20.sol
91  */
92 contract ERC20 is ERC20Basic {
93     function allowance(address owner, address spender) public view returns (uint256);
94     function transferFrom(address from, address to, uint256 value) public returns (bool);
95     function approve(address spender, uint256 value) public returns (bool);
96     
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/StandardToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     /**
111      * @dev Transfer tokens from one address to another
112      * @param _from address The address which you want to send tokens from
113      * @param _to address The address which you want to transfer to
114      * @param _value uint256 the amount of tokens to be transferred
115      * @return A boolean that indicates if the operation was successful.
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[_from]);
120         require(_value <= allowed[_from][msg.sender]);
121 
122         uint256 _allowance = allowed[_from][msg.sender];
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = _allowance.sub(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      *
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param _spender The address which will spend the funds.
139      * @param _value The amount of tokens to be spent.
140      * @return A boolean that indicates if the operation was successful.
141      */
142     function approve(address _spender, uint256 _value) public returns (bool) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     /**
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param _owner address The address which owns the funds.
151      * @param _spender address The address which will spend the funds.
152      * @return A uint256 specifying the amount of tokens still available for the spender.
153      */
154     function allowance(address _owner, address _spender) public view returns (uint256) {
155         return allowed[_owner][_spender];
156     }
157 }
158 
159 /**
160  * @title Ownable
161  * @dev The Ownable contract has an owner address, and provides basic authorization control
162  * functions, this simplifies the implementation of "user permissions".
163  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/ownership/Ownable.sol
164  */
165 contract Ownable {
166     address public owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(msg.sender == owner);
175         _;
176     }
177 
178     /**
179      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
180      * account.
181      */
182     function Ownable() public {
183         owner = msg.sender;
184     }
185 
186     /**
187      * @dev Allows the current owner to transfer control of the contract to a newOwner.
188      * @param newOwner The address to transfer ownership to.
189      */
190     function transferOwnership(address newOwner) public onlyOwner {
191         require(newOwner != address(0));
192         OwnershipTransferred(owner, newOwner);
193         owner = newOwner;
194     }
195 
196 }
197 
198 /**
199  * @title Mintable token
200  * @dev Simple ERC20 Token example, with mintable token creation
201  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/MintableToken.sol
202  */
203 
204 contract MintableToken is StandardToken, Ownable {
205     event Mint(address indexed to, uint256 amount);
206     event MintFinished();
207 
208     bool public mintingFinished = false;
209 
210     address public mintAddress;
211 
212     modifier canMint() {
213         require(!mintingFinished);
214         _;
215     }
216 
217     modifier onlyMint() {
218         require(msg.sender == mintAddress);
219         _;
220     }
221 
222     /**
223      * @dev Function to change address that is allowed to do emission.
224      * @param _mintAddress Address of the emission contract.
225      */
226     function setMintAddress(address _mintAddress) public onlyOwner {
227         require(_mintAddress != address(0));
228         mintAddress = _mintAddress;
229     }
230 
231     /**
232      * @dev Function to mint tokens
233      * @param _to The address that will receive the minted tokens.
234      * @param _amount The amount of tokens to mint.
235      * @return A boolean that indicates if the operation was successful.
236      */
237     function mint(address _to, uint256 _amount) public onlyMint canMint returns (bool) {
238         totalSupply = totalSupply.add(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         Mint(_to, _amount);
241         Transfer(address(0), _to, _amount);
242         return true;
243     }
244 
245     /**
246      * @dev Function to stop minting new tokens.
247      * @return True if the operation was successful.
248      */
249     function finishMinting() public onlyMint canMint returns (bool) {
250         mintingFinished = true;
251         MintFinished();
252         return true;
253     }
254 }
255 
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/lifecycle/Pausable.sol
260  */
261 contract Pausable is Ownable {
262     event Pause();
263     event Unpause();
264 
265     bool public paused = false;
266 
267     /**
268      * @dev Modifier to make a function callable only when the contract is not paused.
269      */
270     modifier whenNotPaused() {
271         require(!paused);
272         _;
273     }
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is paused.
277      */
278     modifier whenPaused() {
279         require(paused);
280         _;
281     }
282 
283     /**
284      * @dev called by the owner to pause, triggers stopped state
285      */
286     function pause() public onlyOwner whenNotPaused {
287         paused = true;
288         Pause();
289     }
290 
291     /**
292      * @dev called by the owner to unpause, returns to normal state
293      */
294     function unpause() public onlyOwner whenPaused {
295         paused = false;
296         Unpause();
297     }
298 }
299 
300 /**
301  * @title Pausable token
302  * @dev StandardToken modified with pausable transfers.
303  * @dev Based on code by OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/token/PausableToken.sol
304  **/
305 contract PausableToken is StandardToken, Pausable {
306 	/**
307     * @dev Transfer token for a specified address
308     * @param _to The address to transfer to.
309     * @param _value The amount to be transferred.
310     * @return A boolean that indicates if the operation was successful.
311     */
312     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
313         return super.transfer(_to, _value);
314     }
315 
316     /**
317      * @dev Transfer tokens from one address to another
318      * @param _from address The address which you want to send tokens from
319      * @param _to address The address which you want to transfer to
320      * @param _value uint256 the amount of tokens to be transferred
321      * @return A boolean that indicates if the operation was successful.
322      */
323     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
324         return super.transferFrom(_from, _to, _value);
325     }
326 
327     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
328         return super.approve(_spender, _value);
329     }
330 }
331 
332 /**
333  * @title CraftyToken
334  * @dev CraftyToken is a token contract of Crafty.
335  */
336 contract CraftyToken is MintableToken, PausableToken {
337     string public constant name = 'Crafty Token';
338     string public constant symbol = 'CFTY';
339     uint8 public constant decimals = 8;
340 
341     /**
342      * @dev CraftyToken constructor
343      */
344     function CraftyToken() public {
345         pause();
346     }
347 
348 }