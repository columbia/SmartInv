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
90 contract BBB is ERC20Interface, owned, ERC223Interface {
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
108         _symbol = "BBB";
109         _name = "Bonbeu Bank";
110         _decimals = 6;
111         _totalSupply = 10000000000 * (10 ** uint256(_decimals));
112         balances[msg.sender] = _totalSupply;
113     }
114 
115 
116     
117     /**
118      * @dev Transfer the specified amount of tokens to the specified address.
119      *      Invokes the `tokenFallback` function if the recipient is a contract.
120      *      The token transfer fails if the recipient is a contract
121      *      but does not implement the `tokenFallback` function
122      *      or the fallback function to receive funds.
123      *
124      * @param _to    Receiver address.
125      * @param _value Amount of tokens that will be transferred.
126      * @param _data  Transaction metadata.
127      */
128     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
129         // Standard function transfer similar to ERC20 transfer with no _data .
130         //require(_to != address(0));
131         // Added due to backwards compatibility reasons .
132         require(_value > 0 );
133         require(_value <= balances[msg.sender]);
134         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
135         require(!frozenAccount[_to]);                       // Check if recipient is frozen
136         uint codeLength;
137 
138         assembly {
139             // Retrieve the size of the code on target address, this needs assembly .
140             codeLength := extcodesize(_to)
141         }
142         if(codeLength>0) {
143             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
144             receiver.tokenFallback(msg.sender, _value, _data);
145         }
146 
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value, _data);
150         return true;
151     }
152     
153     /**
154      * @dev Transfer the specified amount of tokens to the specified address.
155      *      This function works the same with the previous one
156      *      but doesn't contain `_data` param.
157      *      Added due to backwards compatibility reasons.
158      *
159      * @param _to    Receiver address.
160      * @param _value Amount of tokens that will be transferred.
161      */
162     function transfer(address _to, uint256 _value) public returns (bool) {
163         require(_to != address(0));
164         require(_value > 0 );
165         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
166         require(!frozenAccount[_to]);                       // Check if recipient is frozen
167         require(_value <= balances[msg.sender]);
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         emit Transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     
175     /**
176      * @dev Returns balance of the `_owner`.
177      *
178      * @param _owner   The address whose balance will be returned.
179      * @return balance Balance of the `_owner`.
180      */
181     function balanceOf(address _owner) public view returns (uint256 balance) {
182         return balances[_owner];
183     }
184 
185     function name()
186         public
187         view
188         returns (string) {
189         return _name;
190     }
191     
192     function symbol()
193         public
194         view
195         returns (string) {
196         return _symbol;
197     }
198 
199     function decimals()
200         public
201         view
202         returns (uint8) {
203         return _decimals;
204     }
205 
206     function totalSupply()
207         public
208         view
209         returns (uint256) {
210         return _totalSupply;
211     }
212 
213 
214     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215         require(_to != address(0));
216         require(_value <= balances[_from]);
217         require(_value <= allowed[_from][msg.sender]);
218         require(!frozenAccount[_from]);                     // Check if sender is frozen
219         require(!frozenAccount[_to]);                       // Check if recipient is frozen
220         
221         balances[_from] = SafeMath.sub(balances[_from], _value);
222         balances[_to] = SafeMath.add(balances[_to], _value);
223         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
224         emit Transfer(_from, _to, _value);
225         return true;
226     }
227 
228     function approve(address _spender, uint256 _value) public returns (bool) {
229         allowed[msg.sender][_spender] = _value;
230         emit Approval(msg.sender, _spender, _value);
231         return true;
232     }
233     
234     function allowance(address _owner, address _spender) public view returns (uint256) {
235         return allowed[_owner][_spender];
236     }
237     
238     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
239         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243     
244     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245         uint oldValue = allowed[msg.sender][_spender];
246         if (_subtractedValue > oldValue) {
247             allowed[msg.sender][_spender] = 0;
248         } else {
249             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
250         }
251         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252         return true;
253     }
254 
255     /// @notice Create `mintedAmount` tokens and send it to `target`
256     /// @param target Address to receive the tokens
257     /// @param mintedAmount the amount of tokens it will receive
258     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
259         balances[target] = balances[target].add(mintedAmount);
260         _totalSupply = _totalSupply.add(mintedAmount);
261         emit Transfer(0, this, mintedAmount);
262         emit Transfer(this, target, mintedAmount);
263     }
264 
265     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
266     /// @param target Address to be frozen
267     /// @param freeze either to freeze it or not
268     function freezeAccount(address target, bool freeze) onlyOwner public {
269         frozenAccount[target] = freeze;
270         emit FrozenFunds(target, freeze);
271     }
272 
273     /**
274      * Destroy tokens
275      *
276      * Remove `_value` tokens from the system irreversibly
277      *
278      * @param _value the amount of money to burn
279      */
280     function burn(uint256 _value) public returns (bool success) {
281         require(balances[msg.sender] >= _value);   // Check if the sender has enough
282         balances[msg.sender] = balances[msg.sender].sub(_value);// Subtract from the sender
283         _totalSupply = _totalSupply.sub(_value);// Updates totalSupply
284         emit Burn(msg.sender, _value);
285         return true;
286     }
287 
288     /**
289      * Destroy tokens from other account
290      *
291      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
292      *
293      * @param _from the address of the sender
294      * @param _value the amount of money to burn
295      */
296     function burnFrom(address _from, uint256 _value) public returns (bool success) {
297         require(balances[_from] >= _value);                // Check if the targeted balance is enough
298         require(_value <= allowed[_from][msg.sender]);    // Check allowance
299         balances[_from] = balances[_from].sub(_value);// Subtract from the targeted balance
300         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);// Subtract from the sender's allowance
301         _totalSupply = _totalSupply.sub(_value);// Updates totalSupply
302         emit Burn(_from, _value);
303         return true;
304     }
305 	// transfer balance to owner
306     function withdrawEther(uint256 amount) onlyOwner public {
307         owner.transfer(amount);
308     }
309     // can accept ether
310     function() payable {
311     }
312 }