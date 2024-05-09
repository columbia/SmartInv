1 pragma solidity  ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 
54 contract ERC20Interface {
55 
56     /* This is a slight change to the ERC20 base standard.
57     function totalSupply() constant returns (uint totalSupply);
58     is replaced with:
59     uint public totalSupply;
60     This automatically creates a getter function for the totalSupply.
61     This is moved to the base contract since public getter functions are not
62     currently recognised as an implementation of the matching abstract
63     function by the compiler.
64     */
65     /// Total amount of tokens
66     uint public totalSupply;
67 
68     /**
69      * @dev Get the account balance of another account with address _owner
70      * @param _owner address The address from which the balance will be retrieved
71      * @return uint The balance
72      */
73     function balanceOf(address _owner) public constant returns (uint balance);
74 
75     /**
76      * @dev Send _value amount of tokens to address _to from `msg.sender`
77      * @param _to The address of the recipient
78      * @param _value The amount of token to be transferred
79      * @return Whether the transfer was successful or not
80      */
81     function transfer(address _to, uint _value) public returns (bool success);
82 
83     /**
84      * @dev Send _value amount of tokens from address _from to address _to
85      * @param _from address The address which you want to send tokens from
86      * @param _to address The address which you want to transfer to
87      * @param _value uint the amount of tokens to be transferred
88      * @return Whether the transfer was successful or not
89      */
90     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
91 
92     /**
93      * @dev Allow _spender to withdraw from your account, multiple times, up to the _value amount
94      * If this function is called again it overwrites the current allowance with _value.
95      * this function is required for some DEX functionality
96      *
97      * @param _spender The address of the account able to transfer the tokens
98      * @param _value The amount of tokens to be approved for transfer
99      */
100     function approve(address _spender, uint _value) public returns (bool success);
101 
102     /**
103      * @dev Returns the amount which _spender is still allowed to withdraw from _owner
104      * @param _owner The address of the account owning tokens
105      * @param _spender The address of the account able to transfer the tokens
106      * @return A uint specifying the amount of tokens still available for the spender.
107      */
108     function allowance(address _owner, address _spender) public constant returns (uint remaining);
109 
110     /// Triggered when tokens are transferred.
111     event Transfer(address indexed _from, address indexed _to, uint _value);
112     /// Triggered whenever approve(address _spender, uint _value) is called.
113     event Approval(address indexed _owner, address indexed _spender, uint _value);
114     /// Triggered when _value of tokens are minted for _owner
115     event Mint(address _owner, uint _value);
116     /// Triggered when mint finished
117     event MintFinished();
118     /// This notifies clients about the amount burnt
119     event Burn(address indexed _from, uint _value);
120 }
121 
122 contract ERC20Token is ERC20Interface {
123 
124     using SafeMath for uint;
125 
126     mapping (address => uint) balances;
127     mapping (address => mapping (address => uint)) allowed;
128 
129     function balanceOf(address _owner) public constant returns (uint balance) {
130         return balances[_owner];
131     }
132 
133     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
134         return allowed[_owner][_spender];
135     }
136 
137     function approve(address _spender, uint _value) public returns (bool) {
138         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139         require(_value <= balances[msg.sender]);
140         allowed[msg.sender][_spender] = _value;
141         Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145     function transfer(address _to, uint _value) public returns (bool success) {
146         _transferFrom(msg.sender, _to, _value);
147         return true;
148     }
149 
150     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
151         // TODO: Revert _value if we have some problems with transfer
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         _transferFrom(_from, _to, _value);
154         return true;
155     }
156 
157     function _transferFrom(address _from, address _to, uint _value) internal {
158         require(_to != address(0)); // Use burnTokens for this case
159         require(_value > 0);
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         Transfer(_from, _to, _value);
163     }
164 }
165 
166 contract TokenReceiver {
167   function tokenFallback(address _sender, address _origin, uint _value) public returns (bool ok);
168 }
169 
170 contract Burnable is ERC20Interface {
171 
172   /**
173    * @dev Function to burns a specific amount of tokens.
174    * @param _value The amount of token to be burned.
175    * @return A boolean that indicates if the operation was successful
176    */
177   function burnTokens(uint _value) public returns (bool success);
178 
179   /**
180    * @dev Function to burns a specific amount of tokens from another account that `msg.sender`
181    * was approved to burn tokens for using `approve` earlier.
182    * @param _from The address to burn tokens from.
183    * @param _value The amount of token to be burned.
184    * @return A boolean that indicates if the operation was successful
185    */
186   function burnFrom(address _from, uint _value) public returns (bool success);
187 
188 }
189 
190 /**
191  * @title Ownable
192  * @dev The Ownable contract has an owner address, and provides basic authorization control
193  * functions, this simplifies the implementation of "user permissions".
194  */
195 contract Ownable {
196   address public owner;
197 
198 
199   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201 
202   /**
203    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
204    * account.
205    */
206   function Ownable() public {
207     owner = msg.sender;
208   }
209 
210   /**
211    * @dev Throws if called by any account other than the owner.
212    */
213   modifier onlyOwner() {
214     require(msg.sender == owner);
215     _;
216   }
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) public onlyOwner {
223     require(newOwner != address(0));
224     OwnershipTransferred(owner, newOwner);
225     owner = newOwner;
226   }
227 
228 }
229 
230 contract LEN is ERC20Token, Ownable {
231 
232     using SafeMath for uint;
233 
234     string public name = "LIQNET";         // Original name
235     string public symbol = "LEN";                   // Token identifier
236     uint8 public decimals = 8;                      // How many decimals to show
237     bool public mintingFinished;         // Status of minting
238 
239     event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
240 
241     /**
242      * @dev Function to mint tokens
243      * @param target The address that will receive the minted tokens
244      * @param mintedAmount The amount of tokens to mint
245      * @return A boolean that indicates if the operation was successful
246      */
247     function mintTokens(address target, uint mintedAmount) public onlyOwner returns (bool success) {
248         require(!mintingFinished); // Can minting
249         totalSupply = totalSupply.add(mintedAmount);
250         balances[target] = balances[target].add(mintedAmount);
251         Mint(target, mintedAmount);
252         return true;
253     }
254 
255     /**
256      * @dev Function to stop minting new tokens
257      * @return A boolean that indicates if the operation was successful
258      */
259     function finishMinting() public onlyOwner returns (bool success) {
260         mintingFinished = true;
261         MintFinished();
262         return true;
263     }
264 
265       /**
266        * @dev Function that is called when a user or another contract wants
267        *  to transfer funds .
268        * @return A boolean that indicates if the operation was successful
269        */
270     function transfer(address _to, uint _value) public returns (bool success) {
271         if (isContract(_to)) {
272             return _transferToContract(msg.sender, _to, _value);
273         } else {
274             _transferFrom(msg.sender, _to, _value);
275             return true;
276         }
277     }
278 
279     /**
280      * @dev Function to burns a specific amount of tokens.
281      * @param _value The amount of token to be burned.
282      * @return A boolean that indicates if the operation was successful
283      */
284     function burnTokens(uint _value) public returns (bool success) {
285         require(balances[msg.sender] >= _value);
286         totalSupply = totalSupply.sub(_value);
287         balances[msg.sender] = balances[msg.sender].sub(_value);
288         Burn(msg.sender, _value);
289         return true;
290     }
291 
292     /**
293      * @dev Function to burns a specific amount of tokens from another account that `msg.sender`
294      * was approved to burn tokens for using `approve` earlier.
295      * @param _from The address to burn tokens from.
296      * @param _value The amount of token to be burned.
297      * @return A boolean that indicates if the operation was successful
298      */
299     function burnFrom(address _from, uint _value) public returns (bool success) {
300         require(_value > 0);
301         require(_value <= balances[_from]);
302         require(_value <= allowed[_from][msg.sender]);
303 
304         balances[_from] = balances[_from].sub(_value);
305         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
306         totalSupply = totalSupply.sub(_value);
307 
308         Burn(_from, _value);
309     }
310 
311     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
312     function isContract(address _addr) private returns (bool is_contract) {
313         uint length;
314         assembly {
315              //retrieve the size of the code on target address, this needs assembly
316              length := extcodesize(_addr)
317         }
318         return (length > 0);
319      }
320 
321    /**
322     * @dev Function that is called when a user or another contract wants
323     *  to transfer funds to smart-contract
324     * @return A boolean that indicates if the operation was successful
325     */
326     function _transferToContract(address _from, address _to, uint _value) private returns (bool success) {
327         _transferFrom(msg.sender, _to, _value);
328         TokenReceiver receiver = TokenReceiver(_to);
329         receiver.tokenFallback(msg.sender, this, _value);
330         return true;
331     }
332 }