1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18   using SaferMath for uint256;
19   mapping(address => uint256) balances;
20   /**
21   * @dev transfer token for a specified address
22   * @param _to The address to transfer to.
23   * @param _value The amount to be transferred.
24   */
25   function transfer(address _to, uint256 _value) public returns (bool) {
26     require(_to != address(0));
27 
28     // SafeMath.sub will throw if there is not enough balance.
29     balances[msg.sender] = balances[msg.sender].sub(_value);
30     balances[_to] = balances[_to].add(_value);
31     Transfer(msg.sender, _to, _value);
32     return true;
33   }
34 
35   /**
36   * @dev Gets the balance of the specified address.
37   * @param _owner The address to query the the balance of.
38   * @return An uint256 representing the amount owned by the passed address.
39   */
40   function balanceOf(address _owner) public constant returns (uint256 balance) {
41     return balances[_owner];
42   }
43 
44 }
45 
46 contract StandardToken is ERC20, BasicToken {
47 
48   mapping (address => mapping (address => uint256)) allowed;
49 
50 
51   /**
52    * @dev Transfer tokens from one address to another
53    * @param _from address The address which you want to send tokens from
54    * @param _to address The address which you want to transfer to
55    * @param _value uint256 the amount of tokens to be transferred
56    */
57   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59 
60     uint256 _allowance = allowed[_from][msg.sender];
61 
62     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
63     // require (_value <= _allowance);
64 
65     balances[_from] = balances[_from].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     allowed[_from][msg.sender] = _allowance.sub(_value);
68     Transfer(_from, _to, _value);
69     return true;
70   }
71 
72   /**
73    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
74    *
75    * Beware that changing an allowance with this method brings the risk that someone may use both the old
76    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
77    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
78    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79    * @param _spender The address which will spend the funds.
80    * @param _value The amount of tokens to be spent.
81    */
82   function approve(address _spender, uint256 _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   /**
89    * @dev Function to check the amount of tokens that an owner allowed to a spender.
90    * @param _owner address The address which owns the funds.
91    * @param _spender address The address which will spend the funds.
92    * @return A uint256 specifying the amount of tokens still available for the spender.
93    */
94   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95     return allowed[_owner][_spender];
96   }
97 
98   /**
99    * approve should be called when allowed[_spender] == 0. To increment
100    * allowed value is better to use this function to avoid 2 calls (and wait until
101    * the first transaction is mined)
102    * From MonolithDAO Token.sol
103    */
104   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 }
121 
122 contract Ownable {
123   address public owner;
124 
125   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127   /**
128    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
129    * account.
130    */
131   function Ownable() {
132     owner = msg.sender;
133   }
134 
135   /**
136    * @dev Throws if called by any account other than the owner.
137    */
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 
143   /**
144    * @dev Allows the current owner to transfer control of the contract to a newOwner.
145    * @param newOwner The address to transfer ownership to.
146    */
147   function transferOwnership(address newOwner) onlyOwner public {
148     require(newOwner != address(0));
149     OwnershipTransferred(owner, newOwner);
150     owner = newOwner;
151   }
152 }
153 
154 contract BitcoinCoreCoin is StandardToken, Ownable {
155 
156   string public constant name = "Bitcoin Core";
157   string public constant symbol = "BTCC";
158   uint8 public constant decimals = 8;
159 
160   uint256 public constant SUPPLY_CAP = 21000000000 * (10 ** uint256(decimals));
161 
162   address NULL_ADDRESS = address(0);
163 
164   uint public nonce = 0;
165 
166 event NonceTick(uint nonce);
167   function incNonce() {
168     nonce += 1;
169     if(nonce > 100) {
170         nonce = 0;
171     }
172     NonceTick(nonce);
173   }
174 
175   // Note intended to act as a source of authorized messaging from development team
176   event NoteChanged(string newNote);
177   string public note = "Welcome to the future of cryptocurrency.";
178   function setNote(string note_) public onlyOwner {
179       note = note_;
180       NoteChanged(note);
181   }
182   
183   event PerformingDrop(uint count);
184   function drop(address[] addresses, uint256 amount) public onlyOwner {
185     uint256 amt = amount * 10**8;
186     require(amt <= SUPPLY_CAP);
187     PerformingDrop(addresses.length);
188     
189     // Maximum drop is 1000 addresses
190     assert(addresses.length <= 1000);
191     assert(balances[owner] >= amt * addresses.length);
192     for (uint i = 0; i < addresses.length; i++) {
193       address recipient = addresses[i];
194       if(recipient != NULL_ADDRESS) {
195         balances[owner] -= amt;
196         balances[recipient] += amt;
197         Transfer(owner, recipient, amt);
198       }
199     }
200   }
201 
202   /**
203    * @dev Constructor that gives msg.sender all of existing tokens..
204    */
205   function BTCCCoin() {
206     totalSupply = SUPPLY_CAP;
207     balances[msg.sender] = SUPPLY_CAP;
208   }
209 }
210 
211 library SaferMath {
212   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
213     uint256 c = a * b;
214     assert(a == 0 || c / a == b);
215     return c;
216   }
217 
218   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
219     // assert(b > 0); // Solidity automatically throws when dividing by 0
220     uint256 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222     return c;
223   }
224 
225   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
226     assert(b <= a);
227     return a - b;
228   }
229 
230   function add(uint256 a, uint256 b) internal constant returns (uint256) {
231     uint256 c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }