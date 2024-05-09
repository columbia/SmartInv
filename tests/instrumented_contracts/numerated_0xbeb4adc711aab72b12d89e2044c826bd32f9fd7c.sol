1 pragma solidity 0.4.15;
2 
3 /// @title ERC20 interface
4 /// @dev Full ERC20 interface described at https://github.com/ethereum/EIPs/issues/20.
5 contract ERC20 {
6 
7   // EVENTS
8 
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 
12   // PUBLIC FUNCTIONS
13 
14   function transfer(address _to, uint256 _value) public returns (bool);
15   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
16   function approve(address _spender, uint256 _value) public returns (bool);
17   function balanceOf(address _owner) public constant returns (uint256);
18   function allowance(address _owner, address _spender) public constant returns (uint256);
19 
20   // FIELDS
21 
22   uint256 public totalSupply;
23 }
24 
25 /// @title Ownable
26 /// @dev The Ownable contract has an owner address, and provides basic authorization control
27 /// functions, this simplifies the implementation of "user permissions".
28 contract Ownable {
29 
30   // EVENTS
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   // PUBLIC FUNCTIONS
35 
36   /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41   /// @dev Allows the current owner to transfer control of the contract to a newOwner.
42   /// @param newOwner The address to transfer ownership to.
43   function transferOwnership(address newOwner) onlyOwner public {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49   // MODIFIERS
50 
51   /// @dev Throws if called by any account other than the owner.
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57   // FIELDS
58 
59   address public owner;
60 }
61 
62 /// @title SafeMath
63 /// @dev Math operations with safety checks that throw on error.
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal constant returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal constant returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 /// @title Standard ERC20 token
91 /// @dev Implementation of the basic standard token.
92 contract StandardToken is ERC20 {
93   using SafeMath for uint256;
94 
95   // PUBLIC FUNCTIONS
96 
97   /// @dev Transfers tokens to a specified address.
98   /// @param _to The address which you want to transfer to.
99   /// @param _value The amount of tokens to be transferred.
100   /// @return A boolean that indicates if the operation was successful.
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /// @dev Transfers tokens from one address to another.
111   /// @param _from The address which you want to send tokens from.
112   /// @param _to The address which you want to transfer to.
113   /// @param _value The amount of tokens to be transferred.
114   /// @return A boolean that indicates if the operation was successful.
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowances[_from][msg.sender]);
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /// @dev Approves the specified address to spend the specified amount of tokens on behalf of msg.sender.
127   /// Beware that changing an allowance with this method brings the risk that someone may use both the old
128   /// and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129   /// race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130   /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131   /// @param _spender The address which will spend tokens.
132   /// @param _value The amount of tokens to be spent.
133   /// @return A boolean that indicates if the operation was successful.
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowances[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /// @dev Gets the balance of the specified address.
141   /// @param _owner The address to query the balance of.
142   /// @return An uint256 representing the amount owned by the specified address.
143   function balanceOf(address _owner) public constant returns (uint256) {
144     return balances[_owner];
145   }
146 
147   /// @dev Function to check the amount of tokens that an owner allowances to a spender.
148   /// @param _owner The address which owns tokens.
149   /// @param _spender The address which will spend tokens.
150   /// @return A uint256 specifying the amount of tokens still available for the spender.
151   function allowance(address _owner, address _spender) public constant returns (uint256) {
152     return allowances[_owner][_spender];
153   }
154 
155   // FIELDS
156 
157   mapping (address => uint256) balances;
158   mapping (address => mapping (address => uint256)) allowances;
159 }
160 
161 /// @title Papyrus Prototype Token (PRP) smart contract.
162 contract PapyrusPrototypeToken is StandardToken, Ownable {
163 
164   // EVENTS
165 
166   event Mint(address indexed to, uint256 amount, uint256 priceUsd);
167   event MintFinished();
168   event TransferableChanged(bool transferable);
169 
170   // PUBLIC FUNCTIONS
171 
172   // If ether is sent to this address, send it back
173   function() { revert(); }
174 
175   // Check transfer ability and sender address before transfer
176   function transfer(address _to, uint _value) canTransfer public returns (bool) {
177     return super.transfer(_to, _value);
178   }
179 
180   // Check transfer ability and sender address before transfer
181   function transferFrom(address _from, address _to, uint _value) canTransfer public returns (bool) {
182     return super.transferFrom(_from, _to, _value);
183   }
184 
185   /// @dev Function to mint tokens.
186   /// @param _to The address that will receive the minted tokens.
187   /// @param _amount The amount of tokens to mint.
188   /// @param _priceUsd The price of minted token at moment of purchase in USD with 18 decimals.
189   /// @return A boolean that indicates if the operation was successful.
190   function mint(address _to, uint256 _amount, uint256 _priceUsd) onlyOwner canMint public returns (bool) {
191     totalSupply = totalSupply.add(_amount);
192     balances[_to] = balances[_to].add(_amount);
193     if (_priceUsd != 0) {
194       uint256 amountUsd = _amount.mul(_priceUsd).div(10**18);
195       totalCollected = totalCollected.add(amountUsd);
196     }
197     Mint(_to, _amount, _priceUsd);
198     Transfer(0x0, _to, _amount);
199     return true;
200   }
201 
202   /// @dev Function to stop minting new tokens.
203   /// @return A boolean that indicates if the operation was successful.
204   function finishMinting() onlyOwner canMint public returns (bool) {
205     mintingFinished = true;
206     MintFinished();
207     return true;
208   }
209 
210   /// @dev Change ability to transfer tokens by users.
211   /// @return A boolean that indicates if the operation was successful.
212   function setTransferable(bool _transferable) onlyOwner public returns (bool) {
213     require(transferable != _transferable);
214     transferable = _transferable;
215     TransferableChanged(transferable);
216     return true;
217   }
218 
219   // MODIFIERS
220 
221   modifier canMint() {
222     require(!mintingFinished);
223     _;
224   }
225 
226   modifier canTransfer() {
227     require(transferable || msg.sender == owner);
228     _;
229   }
230 
231   // FIELDS
232 
233   // Standard fields used to describe the token
234   string public name = "Papyrus Prototype Token";
235   string public symbol = "PRP";
236   string public version = "H0.1";
237   uint8 public decimals = 18;
238 
239   // At the start of the token existence token is not transferable
240   bool public transferable = false;
241 
242   // Will be set to true when minting tokens will be finished
243   bool public mintingFinished = false;
244 
245   // Amount of USD (with 18 decimals) collected during sale phase
246   uint public totalCollected;
247 }