1 pragma solidity ^0.4.19;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: contracts/Owned.sol
36 
37 contract Owned {
38   event OwnerAddition(address indexed owner);
39 
40   event OwnerRemoval(address indexed owner);
41 
42   // owner address to enable admin functions
43   mapping (address => bool) public isOwner;
44 
45   address[] public owners;
46 
47   address public operator;
48 
49   modifier onlyOwner {
50 
51     require(isOwner[msg.sender]);
52     _;
53   }
54 
55   modifier onlyOperator {
56     require(msg.sender == operator);
57     _;
58   }
59 
60   function setOperator(address _operator) external onlyOwner {
61     require(_operator != address(0));
62     operator = _operator;
63   }
64 
65   function removeOwner(address _owner) public onlyOwner {
66     require(owners.length > 1);
67     isOwner[_owner] = false;
68     for (uint i = 0; i < owners.length - 1; i++) {
69       if (owners[i] == _owner) {
70         owners[i] = owners[SafeMath.sub(owners.length, 1)];
71         break;
72       }
73     }
74     owners.length = SafeMath.sub(owners.length, 1);
75     OwnerRemoval(_owner);
76   }
77 
78   function addOwner(address _owner) external onlyOwner {
79     require(_owner != address(0));
80     if(isOwner[_owner]) return;
81     isOwner[_owner] = true;
82     owners.push(_owner);
83     OwnerAddition(_owner);
84   }
85 
86   function setOwners(address[] _owners) internal {
87     for (uint i = 0; i < _owners.length; i++) {
88       require(_owners[i] != address(0));
89       isOwner[_owners[i]] = true;
90       OwnerAddition(_owners[i]);
91     }
92     owners = _owners;
93   }
94 
95   function getOwners() public constant returns (address[])  {
96     return owners;
97   }
98 
99 }
100 
101 // File: contracts/Token.sol
102 
103 // Abstract contract for the full ERC 20 Token standard
104 // https://github.com/ethereum/EIPs/issues/20
105 pragma solidity ^0.4.19;
106 
107 contract Token {
108     /* This is a slight change to the ERC20 base standard.
109     function totalSupply() constant returns (uint256 supply);
110     is replaced with:
111     uint256 public totalSupply;
112     This automatically creates a getter function for the totalSupply.
113     This is moved to the base contract since public getter functions are not
114     currently recognised as an implementation of the matching abstract
115     function by the compiler.
116     */
117     /// total amount of tokens
118     uint256 public totalSupply;
119 
120     /// @param _owner The address from which the balance will be retrieved
121     /// @return The balance
122     function balanceOf(address _owner) public constant returns (uint256 balance);
123 
124     /// @notice send `_value` token to `_to` from `msg.sender`
125     /// @param _to The address of the recipient
126     /// @param _value The amount of token to be transferred
127     /// @return Whether the transfer was successful or not
128     function transfer(address _to, uint256 _value) public returns (bool success);
129 
130     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
131     /// @param _from The address of the sender
132     /// @param _to The address of the recipient
133     /// @param _value The amount of token to be transferred
134     /// @return Whether the transfer was successful or not
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
136 
137     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
138     /// @param _spender The address of the account able to transfer the tokens
139     /// @param _value The amount of tokens to be approved for transfer
140     /// @return Whether the approval was successful or not
141     function approve(address _spender, uint256 _value) public returns (bool success);
142 
143     /// @param _owner The address of the account owning tokens
144     /// @param _spender The address of the account able to transfer the tokens
145     /// @return Amount of remaining tokens allowed to spent
146     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
147 
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 }
151 
152 // File: contracts/StandardToken.sol
153 
154 /*
155 You should inherit from StandardToken or, for a token like you would want to
156 deploy in something like Mist, see HumanStandardToken.sol.
157 (This implements ONLY the standard functions and NOTHING else.
158 If you deploy this, you won't have anything useful.)
159 
160 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
161 .*/
162 pragma solidity ^0.4.19;
163 
164 
165 contract StandardToken is Token {
166 
167     function transfer(address _to, uint256 _value) public returns (bool success) {
168         //Default assumes totalSupply can't be over max (2^256 - 1).
169         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
170         //Replace the if with this one instead.
171         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
172         require(balances[msg.sender] >= _value);
173         balances[msg.sender] -= _value;
174         balances[_to] += _value;
175         Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180         //same as above. Replace this line with the following if you want to protect against wrapping uints.
181         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
182         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
183         balances[_to] += _value;
184         balances[_from] -= _value;
185         allowed[_from][msg.sender] -= _value;
186         Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     function balanceOf(address _owner) public constant returns (uint256 balance) {
191         return balances[_owner];
192     }
193 
194     function approve(address _spender, uint256 _value) public returns (bool success) {
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201       return allowed[_owner][_spender];
202     }
203 
204     mapping (address => uint256) balances;
205     mapping (address => mapping (address => uint256)) allowed;
206 }
207 
208 // File: contracts/Validating.sol
209 
210 contract Validating {
211 
212   modifier validAddress(address _address) {
213     require(_address != address(0x0));
214     _;
215   }
216 
217   modifier notZero(uint _number) {
218     require(_number != 0);
219     _;
220   }
221 
222   modifier notEmpty(string _string) {
223     require(bytes(_string).length != 0);
224     _;
225   }
226 
227 }
228 
229 // File: contracts/Fee.sol
230 
231 /**
232   * @title FEE is an ERC20 token used to pay for trading on the exchange.
233   * For deeper rational read https://leverj.io/whitepaper.pdf.
234   * FEE tokens do not have limit. A new token can be generated by owner.
235   */
236 contract Fee is Owned, Validating, StandardToken {
237 
238   /* This notifies clients about the amount burnt */
239   event Burn(address indexed from, uint256 value);
240 
241   string public name;                   //fancy name: eg Simon Bucks
242   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
243   string public symbol;                 //An identifier: eg SBX
244   string public version = 'F0.2';       //human 0.1 standard. Just an arbitrary versioning scheme.
245   address public minter;
246 
247   modifier onlyMinter {
248     require(msg.sender == minter);
249     _;
250   }
251 
252   /// @notice Constructor to set the owner, tokenName, decimals and symbol
253   function Fee(
254   address[] _owners,
255   string _tokenName,
256   uint8 _decimalUnits,
257   string _tokenSymbol
258   )
259   public
260   notEmpty(_tokenName)
261   notEmpty(_tokenSymbol)
262   {
263     setOwners(_owners);
264     name = _tokenName;
265     decimals = _decimalUnits;
266     symbol = _tokenSymbol;
267   }
268 
269   /// @notice To set a new minter address
270   /// @param _minter The address of the minter
271   function setMinter(address _minter) external onlyOwner validAddress(_minter) {
272     minter = _minter;
273   }
274 
275   /// @notice To eliminate tokens and adjust the price of the FEE tokens
276   /// @param _value Amount of tokens to delete
277   function burnTokens(uint _value) public notZero(_value) {
278     require(balances[msg.sender] >= _value);
279     balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
280     totalSupply = SafeMath.sub(totalSupply, _value);
281     Burn(msg.sender, _value);
282   }
283 
284   /// @notice To send tokens to another user. New FEE tokens are generated when
285   /// doing this process by the minter
286   /// @param _to The receiver of the tokens
287   /// @param _value The amount o
288   function sendTokens(address _to, uint _value) public onlyMinter validAddress(_to) notZero(_value) {
289     balances[_to] = SafeMath.add(balances[_to], _value);
290     totalSupply = SafeMath.add(totalSupply, _value);
291     Transfer(0x0, _to, _value);
292   }
293 }