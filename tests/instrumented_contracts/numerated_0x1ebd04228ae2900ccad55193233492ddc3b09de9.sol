1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Token {
34     /* This is a slight change to the ERC20 base standard.
35     function totalSupply() constant returns (uint256 supply);
36     is replaced with:
37     uint256 public totalSupply;
38     This automatically creates a getter function for the totalSupply.
39     This is moved to the base contract since public getter functions are not
40     currently recognised as an implementation of the matching abstract
41     function by the compiler.
42     */
43     /// total amount of tokens
44     uint256 public totalSupply;
45 
46     /// @param _owner The address from which the balance will be retrieved
47     /// @return The balance
48     function balanceOf(address _owner) constant returns (uint256 balance);
49 
50     /// @notice send `_value` token to `_to` from `msg.sender`
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transfer(address _to, uint256 _value) returns (bool success);
55 
56     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
57     /// @param _from The address of the sender
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
62 
63     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @param _value The amount of tokens to be approved for transfer
66     /// @return Whether the approval was successful or not
67     function approve(address _spender, uint256 _value) returns (bool success);
68 
69     /// @param _owner The address of the account owning tokens
70     /// @param _spender The address of the account able to transfer the tokens
71     /// @return Amount of remaining tokens allowed to spent
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 contract StandardToken is Token {
79 
80     function transfer(address _to, uint256 _value) returns (bool success) {
81         //Default assumes totalSupply can't be over max (2^256 - 1).
82         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
83         //Replace the if with this one instead.
84         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
85         if (balances[msg.sender] >= _value && _value > 0) {
86             balances[msg.sender] -= _value;
87             balances[_to] += _value;
88             Transfer(msg.sender, _to, _value);
89             return true;
90         } else { return false; }
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         //same as above. Replace this line with the following if you want to protect against wrapping uints.
95         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
96         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
97             balances[_to] += _value;
98             balances[_from] -= _value;
99             allowed[_from][msg.sender] -= _value;
100             Transfer(_from, _to, _value);
101             return true;
102         } else { return false; }
103     }
104 
105     function balanceOf(address _owner) constant returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     function approve(address _spender, uint256 _value) returns (bool success) {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
116       return allowed[_owner][_spender];
117     }
118 
119     mapping (address => uint256) balances;
120     mapping (address => mapping (address => uint256)) allowed;
121 }
122 
123 contract HumanStandardToken is StandardToken {
124 
125     function () {
126         //if ether is sent to this address, send it back.
127         throw;
128     }
129 
130     /* Public variables of the token */
131 
132     /*
133     NOTE:
134     The following variables are OPTIONAL vanities. One does not have to include them.
135     They allow one to customise the token contract & in no way influences the core functionality.
136     Some wallets/interfaces might not even bother to look at this information.
137     */
138     string public name;                   //fancy name: eg Simon Bucks
139     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
140     string public symbol;                 //An identifier: eg SBX
141     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
142 
143     function HumanStandardToken(
144         uint256 _initialAmount,
145         string _tokenName,
146         uint8 _decimalUnits,
147         string _tokenSymbol
148         ) {
149         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
150         totalSupply = _initialAmount;                        // Update total supply
151         name = _tokenName;                                   // Set the name for display purposes
152         decimals = _decimalUnits;                            // Amount of decimals for display purposes
153         symbol = _tokenSymbol;                               // Set the symbol for display purposes
154     }
155 
156     /* Approves and then calls the receiving contract */
157     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160 
161         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
162         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
163         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
164         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
165         return true;
166     }
167 }
168 
169 contract Locked {
170   uint public period;
171 
172   function Locked(uint _period) public {
173     period = _period;
174   }
175 }
176 
177 contract Owned {
178     function Owned() { owner = msg.sender; }
179     address owner;
180 
181     // This contract only defines a modifier but does not use
182     // it - it will be used in derived contracts.
183     // The function body is inserted where the special symbol
184     // "_;" in the definition of a modifier appears.
185     // This means that if the owner calls this function, the
186     // function is executed and otherwise, an exception is
187     // thrown.
188     modifier onlyOwner {
189         require(msg.sender == owner);
190         _;
191     }
192 }
193 
194 contract Sales is Owned {
195   address public wallet;
196   HumanStandardToken public token;
197   Locked public locked;
198   uint public price;
199   uint public startBlock;
200   uint public freezeBlock;
201   bool public frozen = false;
202   uint256 public cap = 0;
203   uint256 public sold = 0;
204   uint created;
205 
206   event PurchasedTokens(address indexed purchaser, uint amount);
207 
208   modifier saleHappening {
209     require(block.number >= startBlock);
210     require(block.number <= freezeBlock);
211     require(!frozen);
212     require(sold < cap);
213     _;
214   }
215 
216   function Sales(
217     address _wallet,
218     uint256 _tokenSupply,
219     string _tokenName,
220     uint8 _tokenDecimals,
221     string _tokenSymbol,
222     uint _price,
223     uint _startBlock,
224     uint _freezeBlock,
225     uint256 _cap,
226     uint _locked
227   ) {
228     wallet = _wallet;
229     token = new HumanStandardToken(_tokenSupply, _tokenName, _tokenDecimals, _tokenSymbol);
230     locked = new Locked(_locked);
231     price = _price;
232     startBlock = _startBlock;
233     freezeBlock = _freezeBlock;
234     cap = _cap;
235     created = now;
236 
237     uint256 ownersValue = SafeMath.div(SafeMath.mul(token.totalSupply(), 20), 100);
238     assert(token.transfer(wallet, ownersValue));
239 
240     uint256 saleValue = SafeMath.div(SafeMath.mul(token.totalSupply(), 60), 100);
241     assert(token.transfer(this, saleValue));
242 
243     uint256 lockedValue = SafeMath.sub(token.totalSupply(), SafeMath.add(ownersValue, saleValue));
244     assert(token.transfer(locked, lockedValue));
245   }
246 
247   function purchaseTokens()
248     payable
249     saleHappening {
250     uint excessAmount = msg.value % price;
251     uint purchaseAmount = SafeMath.sub(msg.value, excessAmount);
252     uint tokenPurchase = SafeMath.div(purchaseAmount, price);
253 
254     require(tokenPurchase <= token.balanceOf(this));
255 
256     if (excessAmount > 0) {
257       msg.sender.transfer(excessAmount);
258     }
259 
260     sold = SafeMath.add(sold, tokenPurchase);
261     assert(sold <= cap);
262     wallet.transfer(purchaseAmount);
263     assert(token.transfer(msg.sender, tokenPurchase));
264     PurchasedTokens(msg.sender, tokenPurchase);
265   }
266 
267   /* owner only functions */
268   function changeBlocks(uint _newStartBlock, uint _newFreezeBlock)
269     onlyOwner {
270     require(_newStartBlock != 0);
271     require(_newFreezeBlock >= _newStartBlock);
272     startBlock = _newStartBlock;
273     freezeBlock = _newFreezeBlock;
274   }
275 
276   function changePrice(uint _newPrice) 
277     onlyOwner {
278     require(_newPrice > 0);
279     price = _newPrice;
280   }
281 
282   function changeCap(uint256 _newCap)
283     onlyOwner {
284     require(_newCap > 0);
285     cap = _newCap;
286   }
287 
288   function unlockEscrow()
289     onlyOwner {
290     assert((now - created) > locked.period());
291     assert(token.transfer(wallet, token.balanceOf(locked)));
292   }
293 
294   function toggleFreeze()
295     onlyOwner {
296       frozen = !frozen;
297   }
298 }