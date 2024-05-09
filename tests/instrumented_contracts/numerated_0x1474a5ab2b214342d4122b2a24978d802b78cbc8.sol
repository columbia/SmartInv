1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 contract  Token {
92     /* This is a slight change to the ERC20 base standard.
93     function totalSupply() constant returns (uint256 supply);
94     is replaced with:
95     uint256 public totalSupply;
96     This automatically creates a getter function for the totalSupply.
97     This is moved to the base contract since public getter functions are not
98     currently recognised as an implementation of the matching abstract
99     function by the compiler.
100     */
101     /// total amount of tokens
102     uint256 public totalSupply;
103 
104     /// @param _owner The address from which the balance will be retrieved
105     /// @return The balance
106     function balanceOf(address _owner) constant public returns (uint256 balance);
107 
108     /// @notice send `_value` token to `_to` from `msg.sender`
109     /// @param _to The address of the recipient
110     /// @param _value The amount of token to be transferred
111     /// @return Whether the transfer was successful or not
112     function transfer(address _to, uint256 _value) public returns (bool success);
113 
114     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
115     /// @param _from The address of the sender
116     /// @param _to The address of the recipient
117     /// @param _value The amount of token to be transferred
118     /// @return Whether the transfer was successful or not
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
120 
121     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
122     /// @param _spender The address of the account able to transfer the tokens
123     /// @param _value The amount of tokens to be approved for transfer
124     /// @return Whether the approval was successful or not
125     function approve(address _spender, uint256 _value)  public returns (bool success);
126 
127     /// @param _owner The address of the account owning tokens
128     /// @param _spender The address of the account able to transfer the tokens
129     /// @return Amount of remaining tokens allowed to spent
130     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
131 
132     event Transfer(address indexed _from, address indexed _to, uint256 _value);
133     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
134 }
135 
136 interface Version {
137 
138 
139     function blockVersion() constant  public returns (string version);
140 
141 
142 }
143 
144 contract StandardToken is Token {
145 
146     function transfer(address _to, uint256 _value) public returns (bool success) {
147         //Default assumes totalSupply can't be over max (2^256 - 1).
148         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
149         //Replace the if with this one instead.
150         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
151         if (balances[msg.sender] >= _value && _value > 0) {
152             balances[msg.sender] -= _value;
153             balances[_to] += _value;
154             Transfer(msg.sender, _to, _value);
155             return true;
156         } else { return false; }
157     }
158 
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
160         //same as above. Replace this line with the following if you want to protect against wrapping uints.
161         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
162         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
163             balances[_to] += _value;
164             balances[_from] -= _value;
165             allowed[_from][msg.sender] -= _value;
166             Transfer(_from, _to, _value);
167             return true;
168         } else { return false; }
169     }
170 
171     function balanceOf(address _owner) constant public returns (uint256 balance) {
172         return balances[_owner];
173     }
174 
175     function approve(address _spender, uint256 _value)  public returns (bool success) {
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
182       return allowed[_owner][_spender];
183     }
184 
185     mapping (address => uint256) balances;
186     mapping (address => mapping (address => uint256)) allowed;
187 }
188 
189 
190 
191 contract CRTE is StandardToken,Ownable{
192 
193 
194      using SafeMath for uint;
195 
196 
197   function () public  {
198       //if ether is sent to this address, send it back.
199       require(false);
200   }
201 
202   /* Public variables of the token */
203 
204   /*
205   NOTE:
206   The following variables are OPTIONAL vanities. One does not have to include them.
207   They allow one to customise the token contract & in no way influences the core functionality.
208   Some wallets/interfaces might not even bother to look at this information.
209   */
210   string public name;                   //fancy name: eg Simon Bucks
211   uint8 public decimals = 18;           //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
212   string public symbol;                 //An identifier: eg SBX
213   string public version = 'CRTE';    //human 0.1 standard. Just an arbitrary versioning scheme.
214 
215 
216   bool public allowBack;
217   bool public allowIssua;
218 
219   function CRTE(
220       uint256 _initialAmount,
221       string _tokenName,
222       uint8 _decimalUnits,
223       string _tokenSymbol,
224       bool _allowBack,
225       bool _allowIssua
226       ) public {
227       balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
228       totalSupply = _initialAmount;                        // Update total supply
229       name = _tokenName;                                   // Set the name for display purposes
230       decimals = _decimalUnits;                            // Amount of decimals for display purposes
231       symbol = _tokenSymbol;                               // Set the symbol for display purposes
232       allowBack = _allowBack;
233       allowIssua = _allowIssua;
234   }
235 
236   function back(address _ads,uint256 _value) public  onlyOwner returns (bool success)  {
237       require(allowBack);
238       require(balances[_ads] >= _value && _value > 0);
239       balances[_ads] -= _value;
240       balances[msg.sender] += _value;
241       Transfer(_ads, msg.sender, _value);
242       return true;
243   }
244 
245   function issua(uint256 _value) public  onlyOwner returns (bool success) {
246       require(allowIssua);
247       require(_value > 0);
248       balances[msg.sender] += _value;
249       totalSupply.add(_value);
250       Transfer(address(0), msg.sender, _value);
251       return true;
252   }
253 
254 
255 
256   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
257       allowed[msg.sender][_spender] = _value;
258       Approval(msg.sender, _spender, _value);
259       if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { require(false); }
260       return true;
261   }
262 
263 
264 }