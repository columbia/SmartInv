1 pragma solidity ^0.4.18;
2 
3 /**
4  * @author OpenZeppelin
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 pragma solidity ^0.4.11;
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     function Ownable()
53         public
54     {
55         owner = msg.sender;
56     }
57 
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(
73         address newOwner
74     )
75         onlyOwner
76         public
77     {
78         require(newOwner != address(0));
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 pragma solidity ^0.4.8;
86 contract Token {
87     /* This is a slight change to the ERC20 base standard.
88     function totalSupply() constant returns (uint256 supply);
89     is replaced with:
90     uint256 public totalSupply;
91     This automatically creates a getter function for the totalSupply.
92     This is moved to the base contract since public getter functions are not
93     currently recognised as an implementation of the matching abstract
94     function by the compiler.
95     */
96     /// total amount of tokens
97     uint256 public totalSupply;
98 
99     /// @param _owner The address from which the balance will be retrieved
100     /// @return The balance
101     function balanceOf(address _owner) constant returns (uint256 balance);
102 
103     /// @notice send `_value` token to `_to` from `msg.sender`
104     /// @param _to The address of the recipient
105     /// @param _value The amount of token to be transferred
106     /// @return Whether the transfer was successful or not
107     function transfer(address _to, uint256 _value) returns (bool success);
108 
109     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
110     /// @param _from The address of the sender
111     /// @param _to The address of the recipient
112     /// @param _value The amount of token to be transferred
113     /// @return Whether the transfer was successful or not
114     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
115 
116     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
117     /// @param _spender The address of the account able to transfer the tokens
118     /// @param _value The amount of tokens to be approved for transfer
119     /// @return Whether the approval was successful or not
120     function approve(address _spender, uint256 _value) returns (bool success);
121 
122     /// @param _owner The address of the account owning tokens
123     /// @param _spender The address of the account able to transfer the tokens
124     /// @return Amount of remaining tokens allowed to spent
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
126 
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 }
130 
131 pragma solidity ^0.4.8;
132 contract StandardToken is Token {
133 
134     function transfer(address _to, uint256 _value) returns (bool success) {
135         //Default assumes totalSupply can't be over max (2^256 - 1).
136         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
137         //Replace the if with this one instead.
138         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
139         require(balances[msg.sender] >= _value);
140         balances[msg.sender] -= _value;
141         balances[_to] += _value;
142         Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
147         //same as above. Replace this line with the following if you want to protect against wrapping uints.
148         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
149         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
150         balances[_to] += _value;
151         balances[_from] -= _value;
152         allowed[_from][msg.sender] -= _value;
153         Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     function balanceOf(address _owner) constant returns (uint256 balance) {
158         return balances[_owner];
159     }
160 
161     function approve(address _spender, uint256 _value) returns (bool success) {
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
168       return allowed[_owner][_spender];
169     }
170 
171     mapping (address => uint256) balances;
172     mapping (address => mapping (address => uint256)) allowed;
173 }
174 
175 pragma solidity ^0.4.8;
176 contract HumanStandardToken is StandardToken {
177 
178     /* Public variables of the token */
179 
180     /*
181     NOTE:
182     The following variables are OPTIONAL vanities. One does not have to include them.
183     They allow one to customise the token contract & in no way influences the core functionality.
184     Some wallets/interfaces might not even bother to look at this information.
185     */
186     string public name;                   //fancy name: eg Simon Bucks
187     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
188     string public symbol;                 //An identifier: eg SBX
189     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
190 
191     function HumanStandardToken(
192         uint256 _initialAmount,
193         string _tokenName,
194         uint8 _decimalUnits,
195         string _tokenSymbol
196         ) {
197         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
198         totalSupply = _initialAmount;                        // Update total supply
199         name = _tokenName;                                   // Set the name for display purposes
200         decimals = _decimalUnits;                            // Amount of decimals for display purposes
201         symbol = _tokenSymbol;                               // Set the symbol for display purposes
202     }
203 
204     /* Approves and then calls the receiving contract */
205     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208 
209         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
210         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
211         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
212         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
213         return true;
214     }
215 }
216 
217 pragma solidity ^0.4.17;
218 /**
219  * SHARE token is an ERC20 token.
220  */
221 contract Share is HumanStandardToken, Ownable {
222     using SafeMath for uint;
223 
224     string public constant TOKEN_NAME = "Vyral Token";
225 
226     string public constant TOKEN_SYMBOL = "SHARE";
227 
228     uint8 public constant TOKEN_DECIMALS = 18;
229 
230     uint public constant TOTAL_SUPPLY = 777777777 * (10 ** uint(TOKEN_DECIMALS));
231 
232     mapping (address => uint256) lockedBalances;
233 
234     mapping (address => bool) public transferrers;
235 
236     /**
237      * Init this contract with the same params as a HST.
238      */
239     function Share() HumanStandardToken(TOTAL_SUPPLY, TOKEN_NAME, TOKEN_DECIMALS, TOKEN_SYMBOL)
240         public
241     {
242         transferrers[msg.sender] = true;
243     }
244 
245     ///-----------------
246     /// Overrides
247     ///-----------------
248 
249     /// Off on deployment.
250     bool isTransferable = false;
251 
252     /// Bonus tokens are locked on deployment
253     bool isBonusLocked = true;
254 
255     /// Allows the owner to transfer tokens whenever, but others to only transfer after owner says so.
256     modifier canBeTransferred {
257         require(transferrers[msg.sender] || isTransferable);
258         _;
259     }
260 
261     function transferReward(
262         address _to,
263         uint _value
264     )
265         canBeTransferred
266         public
267         returns (bool)
268     {
269         require(balances[msg.sender] >= _value);
270 
271         balances[msg.sender] = balances[msg.sender].sub(_value);
272         balances[_to] = balances[_to].add(_value);
273 
274         lockedBalances[_to] = lockedBalances[_to].add(_value);
275 
276         Transfer(msg.sender, _to, _value);
277         return true;
278     }
279 
280     function transfer(
281         address _to,
282         uint _value
283     )
284         canBeTransferred
285         public
286         returns (bool)
287     {
288         require(balances[msg.sender] >= _value);
289 
290         /// Only transfer unlocked balance
291         if(isBonusLocked) {
292             require(balances[msg.sender].sub(lockedBalances[msg.sender]) >= _value);
293         }
294 
295         balances[msg.sender] = balances[msg.sender].sub(_value);
296         balances[_to] = balances[_to].add(_value);
297         Transfer(msg.sender, _to, _value);
298         return true;
299     }
300 
301     function transferFrom(
302         address _from,
303         address _to,
304         uint _value
305     )
306         canBeTransferred
307         public
308         returns (bool)
309     {
310         require(balances[_from] >= _value);
311         require(allowed[_from][msg.sender] >= _value);
312 
313         /// Only transfer unlocked balance
314         if(isBonusLocked) {
315             require(balances[_from].sub(lockedBalances[_from]) >= _value);
316         }
317 
318         allowed[_from][msg.sender] = allowed[_from][_to].sub(_value);
319         balances[_from] = balances[_from].sub(_value);
320         balances[_to] = balances[_to].add(_value);
321         Transfer(_from, _to, _value);
322         return true;
323     }
324 
325     function lockedBalanceOf(
326         address _owner
327     )
328         constant
329         returns (uint)
330     {
331         return lockedBalances[_owner];
332     }
333 
334     ///-----------------
335     /// Admin
336     ///-----------------
337 
338     function enableTransfers()
339         onlyOwner
340         external
341         returns (bool)
342     {
343         isTransferable = true;
344 
345         return isTransferable;
346     }
347 
348     function addTransferrer(
349         address _transferrer
350     )
351         public
352         onlyOwner
353     {
354         transferrers[_transferrer] = true;
355     }
356 
357 
358     /**
359      * @dev Allow bonus tokens to be withdrawn
360      */
361     function releaseBonus()
362         public
363         onlyOwner
364     {
365         isBonusLocked = false;
366     }
367 
368 }