1 pragma solidity ^0.4.17;
2 
3 
4 /// @title SafeMath
5 /// @dev Math operations with safety checks that throw on error.
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
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
35 
36 /// @title ERC20 interface
37 /// @dev Full ERC20 interface described at https://github.com/ethereum/EIPs/issues/20.
38 contract ERC20 {
39 
40   // EVENTS
41 
42   event Transfer(address indexed from, address indexed to, uint256 value);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 
45   // PUBLIC FUNCTIONS
46 
47   function transfer(address _to, uint256 _value) public returns (bool);
48   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
49   function approve(address _spender, uint256 _value) public returns (bool);
50   function balanceOf(address _owner) public constant returns (uint256);
51   function allowance(address _owner, address _spender) public constant returns (uint256);
52 
53   // FIELDS
54 
55   uint256 public totalSupply;
56 }
57 
58 
59 /// @title Standard ERC20 token
60 /// @dev Implementation of the basic standard token.
61 contract StandardToken is ERC20 {
62   using SafeMath for uint256;
63 
64   // PUBLIC FUNCTIONS
65 
66   /// @dev Transfers tokens to a specified address.
67   /// @param _to The address which you want to transfer to.
68   /// @param _value The amount of tokens to be transferred.
69   /// @return A boolean that indicates if the operation was successful.
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78   
79   /// @dev Transfers tokens from one address to another.
80   /// @param _from The address which you want to send tokens from.
81   /// @param _to The address which you want to transfer to.
82   /// @param _value The amount of tokens to be transferred.
83   /// @return A boolean that indicates if the operation was successful.
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[_from]);
87     require(_value <= allowances[_from][msg.sender]);
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /// @dev Approves the specified address to spend the specified amount of tokens on behalf of msg.sender.
96   /// Beware that changing an allowance with this method brings the risk that someone may use both the old
97   /// and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
98   /// race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
99   /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100   /// @param _spender The address which will spend tokens.
101   /// @param _value The amount of tokens to be spent.
102   /// @return A boolean that indicates if the operation was successful.
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowances[msg.sender][_spender] = _value;
105     Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   /// @dev Gets the balance of the specified address.
110   /// @param _owner The address to query the balance of.
111   /// @return An uint256 representing the amount owned by the specified address.
112   function balanceOf(address _owner) public constant returns (uint256) {
113     return balances[_owner];
114   }
115 
116   /// @dev Function to check the amount of tokens that an owner allowances to a spender.
117   /// @param _owner The address which owns tokens.
118   /// @param _spender The address which will spend tokens.
119   /// @return A uint256 specifying the amount of tokens still available for the spender.
120   function allowance(address _owner, address _spender) public constant returns (uint256) {
121     return allowances[_owner][_spender];
122   }
123 
124   // FIELDS
125 
126   mapping (address => uint256) balances;
127   mapping (address => mapping (address => uint256)) allowances;
128 }
129 
130 
131 /// @title Ownable
132 /// @dev The Ownable contract has an owner address, and provides basic authorization control
133 /// functions, this simplifies the implementation of "user permissions".
134 contract Ownable {
135 
136   // EVENTS
137 
138   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140   // PUBLIC FUNCTIONS
141 
142   /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
143   function Ownable() public {
144     owner = msg.sender;
145   }
146 
147   /// @dev Allows the current owner to transfer control of the contract to a newOwner.
148   /// @param newOwner The address to transfer ownership to.
149   function transferOwnership(address newOwner) onlyOwner public {
150     require(newOwner != address(0));
151     OwnershipTransferred(owner, newOwner);
152     owner = newOwner;
153   }
154 
155   // MODIFIERS
156 
157   /// @dev Throws if called by any account other than the owner.
158   modifier onlyOwner() {
159     require(msg.sender == owner);
160     _;
161   }
162 
163   // FIELDS
164 
165   address public owner;
166 }
167 
168 
169 /// @title Papyrus Prototype Token (PRP) smart contract.
170 contract PapyrusPrototypeToken is StandardToken, Ownable {
171 
172   // EVENTS
173 
174   event Mint(address indexed to, uint256 amount, uint256 priceUsd);
175   event MintFinished();
176   event Burn(address indexed burner, uint256 amount);
177   event TransferableChanged(bool transferable);
178 
179   // PUBLIC FUNCTIONS
180 
181   // If ether is sent to this address, send it back
182   function() public { revert(); }
183 
184   // Check transfer ability and sender address before transfer
185   function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
186     return super.transfer(_to, _value);
187   }
188 
189   // Check transfer ability and sender address before transfer
190   function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
191     return super.transferFrom(_from, _to, _value);
192   }
193 
194   /// @dev Function to mint tokens.
195   /// @param _to The address that will receive the minted tokens.
196   /// @param _amount The amount of tokens to mint.
197   /// @param _priceUsd The price of minted token at moment of purchase in USD with 18 decimals.
198   /// @return A boolean that indicates if the operation was successful.
199   function mint(address _to, uint256 _amount, uint256 _priceUsd) onlyOwner canMint public returns (bool) {
200     totalSupply = totalSupply.add(_amount);
201     balances[_to] = balances[_to].add(_amount);
202     if (_priceUsd != 0) {
203       uint256 amountUsd = _amount.mul(_priceUsd).div(10**18);
204       totalCollected = totalCollected.add(amountUsd);
205     }
206     Mint(_to, _amount, _priceUsd);
207     Transfer(0x0, _to, _amount);
208     return true;
209   }
210 
211   /// @dev Function to stop minting new tokens.
212   /// @return A boolean that indicates if the operation was successful.
213   function finishMinting() onlyOwner canMint public returns (bool) {
214     mintingFinished = true;
215     MintFinished();
216     return true;
217   }
218 
219   /// @dev Burns a specific amount of tokens.
220   /// @param _value The amount of token to be burned.
221   function burn(uint256 _value) public {
222     require(_value > 0);
223     require(_value <= balances[msg.sender]);
224     address burner = msg.sender;
225     balances[burner] = balances[burner].sub(_value);
226     totalSupply = totalSupply.sub(_value);
227     totalBurned = totalBurned.add(_value);
228     Burn(burner, _value);
229   }
230 
231   /// @dev Change ability to transfer tokens by users.
232   /// @return A boolean that indicates if the operation was successful.
233   function setTransferable(bool _transferable) onlyOwner public returns (bool) {
234     require(transferable != _transferable);
235     transferable = _transferable;
236     TransferableChanged(transferable);
237     return true;
238   }
239 
240   // MODIFIERS
241 
242   modifier canMint() {
243     require(!mintingFinished);
244     _;
245   }
246 
247   modifier canTransfer() {
248     require(transferable || msg.sender == owner);
249     _;
250   }
251 
252   // FIELDS
253 
254   // Standard fields used to describe the token
255   string public name = "Papyrus Prototype Token";
256   string public symbol = "PRP";
257   string public version = "H0.1";
258   uint8 public decimals = 18;
259 
260   // At the start of the token existence token is not transferable
261   bool public transferable = false;
262 
263   // Will be set to true when minting tokens will be finished
264   bool public mintingFinished = false;
265 
266   // Amount of burned tokens
267   uint256 public totalBurned;
268 
269   // Amount of USD (with 18 decimals) collected during sale phase
270   uint256 public totalCollected;
271 }