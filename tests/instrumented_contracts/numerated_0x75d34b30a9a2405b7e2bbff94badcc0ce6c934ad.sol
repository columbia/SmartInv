1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner {
54     if (newOwner != address(0)) {
55       owner = newOwner;
56     }
57   }
58 
59 }
60 
61 contract ERC20Basic {
62   uint256 public totalSupply;
63   function balanceOf(address who) constant returns (uint256);
64   function transfer(address to, uint256 value) returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) constant returns (uint256);
70   function transferFrom(address from, address to, uint256 value) returns (bool);
71   function approve(address spender, uint256 value) returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) returns (bool) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of. 
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amout of tokens to be transfered
113    */
114   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
115     var _allowance = allowed[_from][msg.sender];
116 
117     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118     // require (_value <= _allowance);
119 
120     balances[_to] = balances[_to].add(_value);
121     balances[_from] = balances[_from].sub(_value);
122     allowed[_from][msg.sender] = _allowance.sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) returns (bool) {
133 
134     // To change the approve amount you first have to reduce the addresses`
135     //  allowance to zero by calling `approve(_spender, 0)` if it is not
136     //  already 0 to mitigate the race condition described here:
137     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifing the amount of tokens still avaible for the spender.
150    */
151   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155 }
156 
157 
158 contract MintableToken is StandardToken, Ownable {
159   event Mint(address indexed to, uint256 amount);
160   event MintFinished();
161 
162   bool public mintingFinished = false;
163 
164 
165   modifier canMint() {
166     require(!mintingFinished);
167     _;
168   }
169 
170   /**
171    * @dev Function to mint tokens
172    * @param _to The address that will recieve the minted tokens.
173    * @param _amount The amount of tokens to mint.
174    * @return A boolean that indicates if the operation was successful.
175    */
176   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
177     totalSupply = totalSupply.add(_amount);
178     balances[_to] = balances[_to].add(_amount);
179     Mint(_to, _amount);
180     return true;
181   }
182 
183   /**
184    * @dev Function to stop minting new tokens.
185    * @return True if the operation was successful.
186    */
187   function finishMinting() onlyOwner returns (bool) {
188     mintingFinished = true;
189     MintFinished();
190     return true;
191   }
192 }
193 
194 
195 contract TGEToken is MintableToken {
196     string public name;       
197     uint8 public decimals = 18;                
198     string public symbol;                 
199     string public version = "H0.1";
200     
201     function TGEToken(
202         string _tokenName,
203         string _tokenSymbol
204         ) {
205         name = _tokenName;
206         symbol = _tokenSymbol;
207     }
208     
209     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212 
213         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
214         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
215         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
216         assert(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
217         return true;
218     }
219 
220     function burn(uint256 _value) returns (bool success) {
221         if (balances[msg.sender] >= _value && _value > 0) {
222             balances[msg.sender] -= _value;
223             totalSupply -= _value;
224             Transfer(msg.sender, 0x0, _value);
225             return true;
226         } else {
227             return false;
228         }
229     }
230 }