1 pragma solidity ^0.4.11;
2 
3 interface ERC20Interface {
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   function allowance(address owner, address spender) public view returns (uint256);
7   function transferFrom(address from, address to, uint256 value) public returns (bool);
8   function approve(address spender, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 interface ERC223Interface {
14     function transfer(address to, uint value, bytes data) public  returns (bool);
15     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
16 }
17 
18 contract ERC223ReceivingContract { 
19 /**
20  * @dev Standard ERC223 function that will handle incoming token transfers.
21  *
22  * @param _from  Token sender address.
23  * @param _value Amount of tokens.
24  * @param _data  Transaction metadata.
25  */
26     function tokenFallback(address _from, uint _value, bytes _data) public;
27 }
28 
29 contract owned {
30     address public owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         owner = newOwner;
43     }
44 }
45 
46 
47 library SafeMath {
48     function mul(uint a, uint b) internal pure returns (uint) {
49         uint c = a * b;
50         assert(a == 0 || c / a == b);
51         return c;
52     }
53 
54     function div(uint a, uint b) internal pure returns (uint) {
55         // assert(b > 0); // Solidity automatically throws when dividing by 0
56         uint c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58         return c;
59     }
60 
61     function sub(uint a, uint b) internal pure returns (uint) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     function add(uint a, uint b) internal pure returns (uint) {
67         uint c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 
72     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
73         return a >= b ? a : b;
74     }
75 
76     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
77         return a < b ? a : b;
78     }
79 
80     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a >= b ? a : b;
82     }
83 
84     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a < b ? a : b;
86     }
87 }
88 
89 
90 contract Rockets is ERC20Interface, owned, ERC223Interface {
91     using SafeMath for uint;
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93     mapping (address => bool) public frozenAccount;
94 
95     /* This generates a public event on the blockchain that will notify clients */
96     event FrozenFunds(address target, bool frozen);
97     event Burn(address indexed from, uint256 value);
98      
99     string internal _name;
100     string internal _symbol;
101     uint8 internal _decimals;
102     uint256 internal _totalSupply;
103 
104     mapping (address => uint256) internal balances;
105     mapping (address => mapping (address => uint256)) internal allowed;
106 
107     constructor() public {
108         _symbol = "ROK";
109         _name = "Rockets";
110         _decimals = 18;
111         _totalSupply = 10000000000 * (10 ** uint256(_decimals));
112         balances[msg.sender] = _totalSupply;
113     }
114 
115     function updateSymbol(string newSymbol) onlyOwner public {
116         _symbol = newSymbol;
117     }
118     
119     function updateName(string newName) onlyOwner public {
120         _name = newName;
121     }
122 
123 
124     
125     /**
126      * @dev Transfer the specified amount of tokens to the specified address.
127      *      Invokes the `tokenFallback` function if the recipient is a contract.
128      *      The token transfer fails if the recipient is a contract
129      *      but does not implement the `tokenFallback` function
130      *      or the fallback function to receive funds.
131      *
132      * @param _to    Receiver address.
133      * @param _value Amount of tokens that will be transferred.
134      * @param _data  Transaction metadata.
135      */
136     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
137         // Standard function transfer similar to ERC20 transfer with no _data .
138         //require(_to != address(0));
139         // Added due to backwards compatibility reasons .
140         require(_value > 0 );
141         require(_value <= balances[msg.sender]);
142         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
143         require(!frozenAccount[_to]);                       // Check if recipient is frozen
144         uint codeLength;
145 
146         assembly {
147             // Retrieve the size of the code on target address, this needs assembly .
148             codeLength := extcodesize(_to)
149         }
150         if(codeLength>0) {
151             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
152             receiver.tokenFallback(msg.sender, _value, _data);
153         }
154 
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value, _data);
158         return true;
159     }
160     
161     /**
162      * @dev Transfer the specified amount of tokens to the specified address.
163      *      This function works the same with the previous one
164      *      but doesn't contain `_data` param.
165      *      Added due to backwards compatibility reasons.
166      *
167      * @param _to    Receiver address.
168      * @param _value Amount of tokens that will be transferred.
169      */
170     function transfer(address _to, uint256 _value) public returns (bool) {
171         require(_to != address(0));
172         require(_value > 0 );
173         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
174         require(!frozenAccount[_to]);                       // Check if recipient is frozen
175         require(_value <= balances[msg.sender]);
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         emit Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     
183     /**
184      * @dev Returns balance of the `_owner`.
185      *
186      * @param _owner   The address whose balance will be returned.
187      * @return balance Balance of the `_owner`.
188      */
189     function balanceOf(address _owner) public view returns (uint256 balance) {
190         return balances[_owner];
191     }
192 
193     function name()
194         public
195         view
196         returns (string) {
197         return _name;
198     }
199     
200     function symbol()
201         public
202         view
203         returns (string) {
204         return _symbol;
205     }
206 
207     function decimals()
208         public
209         view
210         returns (uint8) {
211         return _decimals;
212     }
213 
214     function totalSupply()
215         public
216         view
217         returns (uint256) {
218         return _totalSupply;
219     }
220 
221 
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223         require(_to != address(0));
224         require(_value <= balances[_from]);
225         require(_value <= allowed[_from][msg.sender]);
226         require(!frozenAccount[_from]);                     // Check if sender is frozen
227         require(!frozenAccount[_to]);                       // Check if recipient is frozen
228         
229         balances[_from] = SafeMath.sub(balances[_from], _value);
230         balances[_to] = SafeMath.add(balances[_to], _value);
231         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
232         emit Transfer(_from, _to, _value);
233         return true;
234     }
235 
236     function approve(address _spender, uint256 _value) public returns (bool) {
237         allowed[msg.sender][_spender] = _value;
238         emit Approval(msg.sender, _spender, _value);
239         return true;
240     }
241     
242     function allowance(address _owner, address _spender) public view returns (uint256) {
243         return allowed[_owner][_spender];
244     }
245     
246     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
247         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
248         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249         return true;
250     }
251     
252     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253         uint oldValue = allowed[msg.sender][_spender];
254         if (_subtractedValue > oldValue) {
255             allowed[msg.sender][_spender] = 0;
256         } else {
257             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
258         }
259         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262 
263     /// @notice Create `mintedAmount` tokens and send it to `target`
264     /// @param target Address to receive the tokens
265     /// @param mintedAmount the amount of tokens it will receive
266     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
267         balances[target] = balances[target].add(mintedAmount);
268         _totalSupply = _totalSupply.add(mintedAmount);
269         emit Transfer(0, this, mintedAmount);
270         emit Transfer(this, target, mintedAmount);
271     }
272 
273     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
274     /// @param target Address to be frozen
275     /// @param freeze either to freeze it or not
276     function freezeAccount(address target, bool freeze) onlyOwner public {
277         frozenAccount[target] = freeze;
278         emit FrozenFunds(target, freeze);
279     }
280 
281     /**
282      * Destroy tokens
283      *
284      * Remove `_value` tokens from the system irreversibly
285      *
286      * @param _value the amount of money to burn
287      */
288     function burn(uint256 _value) public returns (bool success) {
289         require(balances[msg.sender] >= _value);   // Check if the sender has enough
290         balances[msg.sender] = balances[msg.sender].sub(_value);// Subtract from the sender
291         _totalSupply = _totalSupply.sub(_value);// Updates totalSupply
292         emit Burn(msg.sender, _value);
293         return true;
294     }
295 
296     /**
297      * Destroy tokens from other account
298      *
299      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
300      *
301      * @param _from the address of the sender
302      * @param _value the amount of money to burn
303      */
304     function burnFrom(address _from, uint256 _value) public returns (bool success) {
305         require(balances[_from] >= _value);                // Check if the targeted balance is enough
306         require(_value <= allowed[_from][msg.sender]);    // Check allowance
307         balances[_from] = balances[_from].sub(_value);// Subtract from the targeted balance
308         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);// Subtract from the sender's allowance
309         _totalSupply = _totalSupply.sub(_value);// Updates totalSupply
310         emit Burn(_from, _value);
311         return true;
312     }
313 	// transfer balance to owner
314     function withdrawEther(uint256 amount) onlyOwner public {
315         owner.transfer(amount);
316     }
317     // can accept ether
318     function() payable {
319     }
320 }