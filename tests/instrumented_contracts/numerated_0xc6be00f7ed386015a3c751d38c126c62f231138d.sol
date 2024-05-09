1 /*
2 *
3 * Universal Mobile Token smart contract
4 * Developed by Phenom.team <info@phenom.team>   
5 *
6 */
7 
8 pragma solidity ^0.4.24;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     emit OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint a, uint b) internal pure returns (uint) {
61     if (a == 0) {
62       return 0;
63     }
64     uint c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint a, uint b) internal pure returns (uint) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   /**
80   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint a, uint b) internal pure returns (uint) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint a, uint b) internal pure returns (uint) {
91     uint c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 contract UniversalMobileToken is Ownable {
98     
99     using SafeMath for uint;
100 
101     /*
102         Standard ERC20 token
103     */
104     
105     event Transfer(address indexed from, address indexed to, uint tokens);
106     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
107 
108     // Name of token
109     string public name;
110     // Short symbol for token
111     string public symbol;
112 
113     // Nubmer of decimal places
114     uint public decimals;
115 
116     // Token's total supply
117     uint public totalSupply;
118 
119     // Is minting active
120     bool public mintingIsFinished;
121 
122     // Is transfer possible
123     bool public transferIsPossible;
124 
125     modifier onlyEmitter() {
126         require(emitters[msg.sender] == true);
127         _;
128     }
129     
130     mapping (address => uint) public balances;
131     mapping (address => bool) public emitters;
132     mapping (address => mapping (address => uint)) internal allowed;
133     
134     constructor() Ownable() public {
135         name = "Universal Mobile Token";
136         symbol = "UMT";
137         decimals = 18;   
138         // Make the Owner also an emitter
139         emitters[msg.sender] = true;
140     }
141 
142     /**
143     *   @dev Finish minting process
144     */
145     function finishMinting() public onlyOwner {
146         mintingIsFinished = true;
147         transferIsPossible = true;
148     }
149 
150     /**
151     *   @dev Send coins
152     *   throws on any error rather then return a false flag to minimize
153     *   user errors
154     *   @param _to           target address
155     *   @param _value       transfer amount
156     *
157     *   @return true if the transfer was successful
158     */
159     function transfer(address _to, uint _value) public returns (bool success) {
160         // Make transfer only if transfer is possible
161         require(transferIsPossible);
162         require(_to != address(0) && _to != address(this));
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         emit Transfer(msg.sender, _to, _value);
166         return true;
167     }
168 
169     /**
170     *   @dev Allows another account/contract to spend some tokens on its behalf
171     *   throws on any error rather then return a false flag to minimize user errors
172     *
173     *   also, to minimize the risk of the approve/transferFrom attack vector
174     *   approve has to be called twice in 2 separate transactions - once to
175     *   change the allowance to 0 and secondly to change it to the new allowance
176     *   value
177     *
178     *   @param _spender      approved address
179     *   @param _value       allowance amount
180     *
181     *   @return true if the approval was successful
182     */
183     function approve(address _spender, uint _value) public returns (bool success) {
184         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
185         allowed[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     /**
191     *   @dev An account/contract attempts to get the coins
192     *   throws on any error rather then return a false flag to minimize user errors
193     *
194     *   @param _from         source address
195     *   @param _to           target address
196     *   @param _value        amount
197     *
198     *   @return true if the transfer was successful
199     */
200     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
201         // Make transfer only if transfer is possible
202         require(transferIsPossible);
203 
204         require(_to != address(0) && _to != address(this));
205 
206         balances[_from] = balances[_from].sub(_value);
207         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         emit Transfer(_from, _to, _value);
210         return true;
211     }
212 
213     /**
214     *   @dev Add an emitter account
215     *   
216     *   @param _emitter     emitter's address
217     */
218     function addEmitter(address _emitter) public onlyOwner {
219         emitters[_emitter] = true;
220     }
221     
222     /**
223     *   @dev Remove an emitter account
224     *   
225     *   @param _emitter     emitter's address
226     */
227     function removeEmitter(address _emitter) public onlyOwner {
228         emitters[_emitter] = false;
229     }
230     
231     /**
232     *   @dev Mint token in batches
233     *   
234     *   @param _adresses     token holders' adresses
235     *   @param _values       token holders' values
236     */
237     function batchMint(address[] _adresses, uint[] _values) public onlyEmitter {
238         require(_adresses.length == _values.length);
239         for (uint i = 0; i < _adresses.length; i++) {
240             require(minted(_adresses[i], _values[i]));
241         }
242     }
243 
244     /**
245     *   @dev Transfer token in batches
246     *   
247     *   @param _adresses     token holders' adresses
248     *   @param _values       token holders' values
249     */
250     function batchTransfer(address[] _adresses, uint[] _values) public {
251         require(_adresses.length == _values.length);
252         for (uint i = 0; i < _adresses.length; i++) {
253             require(transfer(_adresses[i], _values[i]));
254         }
255     }
256 
257     /**
258     *   @dev Burn Tokens
259     *   @param _from       token holder address which the tokens will be burnt
260     *   @param _value      number of tokens to burn
261     */
262     function burn(address _from, uint _value) public onlyEmitter {
263         // Burn tokens only if minting stage is not finished
264         require(!mintingIsFinished);
265 
266         require(_value <= balances[_from]);
267         balances[_from] = balances[_from].sub(_value);
268         totalSupply = totalSupply.sub(_value);
269     }
270 
271     /**
272     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
273     *
274     *   @param _tokenOwner        the address which owns the funds
275     *   @param _spender      the address which will spend the funds
276     *
277     *   @return              the amount of tokens still avaible for the spender
278     */
279     function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) {
280         return allowed[_tokenOwner][_spender];
281     }
282 
283     /**
284     *   @dev Function to check the amount of tokens that _tokenOwner has.
285     *
286     *   @param _tokenOwner        the address which owns the funds
287     *
288     *   @return              the amount of tokens _tokenOwner has
289     */
290     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
291         return balances[_tokenOwner];
292     }
293 
294     function minted(address _to, uint _value) internal returns (bool) {
295         // Mint tokens only if minting stage is not finished
296         require(!mintingIsFinished);
297         balances[_to] = balances[_to].add(_value);
298         totalSupply = totalSupply.add(_value);
299         emit Transfer(address(0), _to, _value);
300         return true;
301     }
302 }