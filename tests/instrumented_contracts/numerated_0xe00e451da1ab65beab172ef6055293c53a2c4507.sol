1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 contract Owned {
36   event OwnerAddition(address indexed owner);
37 
38   event OwnerRemoval(address indexed owner);
39 
40   // owner address to enable admin functions
41   mapping (address => bool) public isOwner;
42 
43   address[] public owners;
44 
45   address public operator;
46 
47   modifier onlyOwner {
48 
49     require(isOwner[msg.sender]);
50     _;
51   }
52 
53   modifier onlyOperator {
54     require(msg.sender == operator);
55     _;
56   }
57 
58   function setOperator(address _operator) external onlyOwner {
59     require(_operator != address(0));
60     operator = _operator;
61   }
62 
63   function removeOwner(address _owner) public onlyOwner {
64     require(owners.length > 1);
65     isOwner[_owner] = false;
66     for (uint i = 0; i < owners.length - 1; i++) {
67       if (owners[i] == _owner) {
68         owners[i] = owners[SafeMath.sub(owners.length, 1)];
69         break;
70       }
71     }
72     owners.length = SafeMath.sub(owners.length, 1);
73     OwnerRemoval(_owner);
74   }
75 
76   function addOwner(address _owner) external onlyOwner {
77     require(_owner != address(0));
78     if(isOwner[_owner]) return;
79     isOwner[_owner] = true;
80     owners.push(_owner);
81     OwnerAddition(_owner);
82   }
83 
84   function setOwners(address[] _owners) internal {
85     for (uint i = 0; i < _owners.length; i++) {
86       require(_owners[i] != address(0));
87       isOwner[_owners[i]] = true;
88       OwnerAddition(_owners[i]);
89     }
90     owners = _owners;
91   }
92 
93   function getOwners() public constant returns (address[])  {
94     return owners;
95   }
96 
97 }
98 
99 contract Validating {
100 
101   modifier validAddress(address _address) {
102     require(_address != address(0x0));
103     _;
104   }
105 
106   modifier notZero(uint _number) {
107     require(_number != 0);
108     _;
109   }
110 
111   modifier notEmpty(string _string) {
112     require(bytes(_string).length != 0);
113     _;
114   }
115 
116 }
117 
118 
119 contract Token {
120     /* This is a slight change to the ERC20 base standard.
121     function totalSupply() constant returns (uint256 supply);
122     is replaced with:
123     uint256 public totalSupply;
124     This automatically creates a getter function for the totalSupply.
125     This is moved to the base contract since public getter functions are not
126     currently recognised as an implementation of the matching abstract
127     function by the compiler.
128     */
129     /// total amount of tokens
130     uint256 public totalSupply;
131 
132     /// @param _owner The address from which the balance will be retrieved
133     /// @return The balance
134     function balanceOf(address _owner) public constant returns (uint256 balance);
135 
136     /// @notice send `_value` token to `_to` from `msg.sender`
137     /// @param _to The address of the recipient
138     /// @param _value The amount of token to be transferred
139     /// @return Whether the transfer was successful or not
140     function transfer(address _to, uint256 _value) public returns (bool success);
141 
142     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
143     /// @param _from The address of the sender
144     /// @param _to The address of the recipient
145     /// @param _value The amount of token to be transferred
146     /// @return Whether the transfer was successful or not
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
148 
149     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
150     /// @param _spender The address of the account able to transfer the tokens
151     /// @param _value The amount of tokens to be approved for transfer
152     /// @return Whether the approval was successful or not
153     function approve(address _spender, uint256 _value) public returns (bool success);
154 
155     /// @param _owner The address of the account owning tokens
156     /// @param _spender The address of the account able to transfer the tokens
157     /// @return Amount of remaining tokens allowed to spent
158     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
159 
160     event Transfer(address indexed _from, address indexed _to, uint256 _value);
161     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
162 }
163 
164 contract StandardToken is Token {
165 
166     function transfer(address _to, uint256 _value) public returns (bool success) {
167         //Default assumes totalSupply can't be over max (2^256 - 1).
168         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
169         //Replace the if with this one instead.
170         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
171         require(balances[msg.sender] >= _value);
172         balances[msg.sender] -= _value;
173         balances[_to] += _value;
174         Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
179         //same as above. Replace this line with the following if you want to protect against wrapping uints.
180         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
181         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
182         balances[_to] += _value;
183         balances[_from] -= _value;
184         allowed[_from][msg.sender] -= _value;
185         Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     function balanceOf(address _owner) public constant returns (uint256 balance) {
190         return balances[_owner];
191     }
192 
193     function approve(address _spender, uint256 _value) public returns (bool success) {
194         allowed[msg.sender][_spender] = _value;
195         Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
200       return allowed[_owner][_spender];
201     }
202 
203     mapping (address => uint256) balances;
204     mapping (address => mapping (address => uint256)) allowed;
205 }
206 
207 
208 
209 /**
210   * @title FEE is an ERC20 token used to pay for trading on the exchange.
211   * For deeper rational read https://leverj.io/whitepaper.pdf.
212   * FEE tokens do not have limit. A new token can be generated by owner.
213   */
214 contract Fee is Owned, Validating, StandardToken {
215 
216   /* This notifies clients about the amount burnt */
217   event Burn(address indexed from, uint256 value);
218 
219   string public name;                   //fancy name: eg Simon Bucks
220   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
221   string public symbol;                 //An identifier: eg SBX
222   uint256 public feeInCirculation;      //total fee in circulation
223   string public version = 'F0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
224   address public minter;
225 
226   modifier onlyMinter {
227     require(msg.sender == minter);
228     _;
229   }
230 
231   /// @notice Constructor to set the owner, tokenName, decimals and symbol
232   function Fee(
233   address[] _owners,
234   string _tokenName,
235   uint8 _decimalUnits,
236   string _tokenSymbol
237   )
238   public
239   notEmpty(_tokenName)
240   notEmpty(_tokenSymbol)
241   {
242     setOwners(_owners);
243     name = _tokenName;
244     decimals = _decimalUnits;
245     symbol = _tokenSymbol;
246   }
247 
248   /// @notice To set a new minter address
249   /// @param _minter The address of the minter
250   function setMinter(address _minter) external onlyOwner validAddress(_minter) {
251     minter = _minter;
252   }
253 
254   /// @notice To eliminate tokens and adjust the price of the FEE tokens
255   /// @param _value Amount of tokens to delete
256   function burnTokens(uint _value) public notZero(_value) {
257     require(balances[msg.sender] >= _value);
258 
259     balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
260     feeInCirculation = SafeMath.sub(feeInCirculation, _value);
261     Burn(msg.sender, _value);
262   }
263 
264   /// @notice To send tokens to another user. New FEE tokens are generated when
265   /// doing this process by the minter
266   /// @param _to The receiver of the tokens
267   /// @param _value The amount o
268   function sendTokens(address _to, uint _value) public onlyMinter validAddress(_to) notZero(_value) {
269     balances[_to] = SafeMath.add(balances[_to], _value);
270     feeInCirculation = SafeMath.add(feeInCirculation, _value);
271     Transfer(msg.sender, _to, _value);
272   }
273 }