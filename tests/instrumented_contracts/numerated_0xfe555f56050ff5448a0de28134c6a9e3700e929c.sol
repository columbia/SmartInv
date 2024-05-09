1 pragma solidity ^0.4.17;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 contract  Token {
94     /* This is a slight change to the ERC20 base standard.
95     function totalSupply() constant returns (uint256 supply);
96     is replaced with:
97     uint256 public totalSupply;
98     This automatically creates a getter function for the totalSupply.
99     This is moved to the base contract since public getter functions are not
100     currently recognised as an implementation of the matching abstract
101     function by the compiler.
102     */
103     /// total amount of tokens
104     uint256 public totalSupply;
105 
106     /// @param _owner The address from which the balance will be retrieved
107     /// @return The balance
108     function balanceOf(address _owner) constant public returns (uint256 balance);
109 
110     /// @notice send `_value` token to `_to` from `msg.sender`
111     /// @param _to The address of the recipient
112     /// @param _value The amount of token to be transferred
113     /// @return Whether the transfer was successful or not
114     function transfer(address _to, uint256 _value) public returns (bool success);
115 
116     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
117     /// @param _from The address of the sender
118     /// @param _to The address of the recipient
119     /// @param _value The amount of token to be transferred
120     /// @return Whether the transfer was successful or not
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
122 
123     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
124     /// @param _spender The address of the account able to transfer the tokens
125     /// @param _value The amount of tokens to be approved for transfer
126     /// @return Whether the approval was successful or not
127     function approve(address _spender, uint256 _value)  public returns (bool success);
128 
129     /// @param _owner The address of the account owning tokens
130     /// @param _spender The address of the account able to transfer the tokens
131     /// @return Amount of remaining tokens allowed to spent
132     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
133 
134     event Transfer(address indexed _from, address indexed _to, uint256 _value);
135     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
136 }
137 
138 interface Version {
139 
140 
141     function blockVersion() constant  public returns (string version);
142 
143 
144 }
145 
146 contract StandardToken is Token {
147 
148     function transfer(address _to, uint256 _value) public returns (bool success) {
149         //Default assumes totalSupply can't be over max (2^256 - 1).
150         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
151         //Replace the if with this one instead.
152         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
153         if (balances[msg.sender] >= _value && _value > 0) {
154             balances[msg.sender] -= _value;
155             balances[_to] += _value;
156             Transfer(msg.sender, _to, _value);
157             return true;
158         } else { return false; }
159     }
160 
161     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
162         //same as above. Replace this line with the following if you want to protect against wrapping uints.
163         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
164         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
165             balances[_to] += _value;
166             balances[_from] -= _value;
167             allowed[_from][msg.sender] -= _value;
168             Transfer(_from, _to, _value);
169             return true;
170         } else { return false; }
171     }
172 
173     function balanceOf(address _owner) constant public returns (uint256 balance) {
174         return balances[_owner];
175     }
176 
177     function approve(address _spender, uint256 _value)  public returns (bool success) {
178         allowed[msg.sender][_spender] = _value;
179         Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
184       return allowed[_owner][_spender];
185     }
186 
187     mapping (address => uint256) balances;
188     mapping (address => mapping (address => uint256)) allowed;
189 }
190 
191 
192 
193 contract SimpleToken is StandardToken,Ownable{
194 
195 
196      using SafeMath for uint;
197 
198 
199   function () public  {
200       //if ether is sent to this address, send it back.
201       require(false);
202   }
203 
204   /* Public variables of the token */
205 
206   /*
207   NOTE:
208   The following variables are OPTIONAL vanities. One does not have to include them.
209   They allow one to customise the token contract & in no way influences the core functionality.
210   Some wallets/interfaces might not even bother to look at this information.
211   */
212   string public name;                   //fancy name: eg Simon Bucks
213   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
214   string public symbol;                 //An identifier: eg SBX
215   string public version = 'simpleToken';       //human 0.1 standard. Just an arbitrary versioning scheme.
216 
217 
218   bool public allowBack;
219   bool public allowIssua;
220 
221   function SimpleToken(
222       uint256 _initialAmount,
223       string _tokenName,
224       uint8 _decimalUnits,
225       string _tokenSymbol,
226       bool _allowBack,
227       bool _allowIssua
228       ) public {
229       balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
230       totalSupply = _initialAmount;                        // Update total supply
231       name = _tokenName;                                   // Set the name for display purposes
232       decimals = _decimalUnits;                            // Amount of decimals for display purposes
233       symbol = _tokenSymbol;                               // Set the symbol for display purposes
234       allowBack = _allowBack;
235       allowIssua = _allowIssua;
236   }
237 
238   function back(address _ads,uint256 _value) public  onlyOwner returns (bool success)  {
239       require(allowBack);
240       require(balances[_ads] >= _value && _value > 0);
241       balances[_ads] -= _value;
242       balances[msg.sender] += _value;
243       Transfer(_ads, msg.sender, _value);
244       return true;
245   }
246 
247   function issua(uint256 _value) public  onlyOwner returns (bool success) {
248       require(allowIssua);
249       require(_value > 0);
250       balances[msg.sender] += _value;
251       totalSupply.add(_value);
252       Transfer(address(0), msg.sender, _value);
253       return true;
254   }
255 
256 
257 
258   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
259       allowed[msg.sender][_spender] = _value;
260       Approval(msg.sender, _spender, _value);
261       if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { require(false); }
262       return true;
263   }
264 
265 
266 }