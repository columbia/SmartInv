1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract ERC20Basic {
64   uint256 public totalSupply;
65   function balanceOf(address who) constant returns (uint256);
66   function transfer(address to, uint256 value) returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) returns (bool) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of. 
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value) returns (bool);
101   function approve(address spender, uint256 value) returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amout of tokens to be transfered
115    */
116   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
117     var _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_to] = balances[_to].add(_value);
123     balances[_from] = balances[_from].sub(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) returns (bool) {
135 
136     // To change the approve amount you first have to reduce the addresses`
137     //  allowance to zero by calling `approve(_spender, 0)` if it is not
138     //  already 0 to mitigate the race condition described here:
139     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
141 
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifing the amount of tokens still avaible for the spender.
152    */
153   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
154     return allowed[_owner][_spender];
155   }
156 
157 }
158 
159 contract MintableToken is StandardToken, Ownable {
160   event Mint(address indexed to, uint256 amount);
161   event MintFinished();
162 
163   bool public mintingFinished = false;
164 
165 
166   modifier canMint() {
167     require(!mintingFinished);
168     _;
169   }
170 
171   /**
172    * @dev Function to mint tokens
173    * @param _to The address that will recieve the minted tokens.
174    * @param _amount The amount of tokens to mint.
175    * @return A boolean that indicates if the operation was successful.
176    */
177   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
178     totalSupply = totalSupply.add(_amount);
179     balances[_to] = balances[_to].add(_amount);
180     Mint(_to, _amount);
181     return true;
182   }
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner returns (bool) {
189     mintingFinished = true;
190     MintFinished();
191     return true;
192   }
193 }
194 
195 contract EMonero is MintableToken {
196   string public constant name = "eMonero";
197   string public constant symbol = "EXMR";
198   uint   public constant decimals = 18;
199   uint   public unlockTimeStamp = 0;  
200 
201   mapping (address => bool) private _lockByPass;
202   
203   function EMonero(uint unlockTs){
204     setUnlockTimeStamp(unlockTs);
205   }
206 
207   function setUnlockTimeStamp(uint _unlockTimeStamp) onlyOwner {
208     unlockTimeStamp = _unlockTimeStamp;
209   }
210 
211   function airdrop(address[] addresses, uint amount) onlyOwner{
212     require(amount > 0);
213     for (uint i = 0; i < addresses.length; i++) {
214        super.transfer(addresses[i], amount);
215     }
216   }
217 
218   function transfer(address _to, uint _value) returns (bool success) {
219     if (now < unlockTimeStamp && !_lockByPass[msg.sender]) return false;
220     return super.transfer(_to, _value);
221   }
222 
223   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
224     if (now < unlockTimeStamp && !_lockByPass[_from]) return false;
225     return super.transferFrom(_from, _to, _value);
226   }
227 
228   function setLockByPass(address[] addresses, bool locked) onlyOwner{
229     for (uint i = 0; i < addresses.length; i++) {
230        _lockByPass[addresses[i]] = locked;
231     }
232   }
233 }