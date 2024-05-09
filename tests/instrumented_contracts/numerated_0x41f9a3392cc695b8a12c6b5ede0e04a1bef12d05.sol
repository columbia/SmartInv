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
17 contract owned {
18     address public owner;
19     
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     function owned() public {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 
43 contract allowMonthly is owned {
44   uint public unlockTime;
45 
46   function allowMonthly() {
47     unlockTime = now;
48   }
49 
50   function isUnlocked() internal returns (bool) {
51     return now >= unlockTime;
52   }
53   
54   modifier onlyWhenUnlocked() { require(isUnlocked()); _; }
55 
56   function useMonthlyAccess() onlyOwner onlyWhenUnlocked {
57     unlockTime = now + 4 weeks;
58   }
59 }
60 
61 library SaferMath {
62   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
63     uint256 c = a * b;
64     assert(a == 0 || c / a == b);
65     return c;
66   }
67 
68   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   function add(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 contract BasicToken is ERC20Basic {
88   using SaferMath for uint256;
89   mapping(address => uint256) balances;
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104   
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) allowed;
119 
120 
121   /**
122    * @dev Transfer tokens from one address to another
123    * @param _from address The address which you want to send tokens from
124    * @param _to address The address which you want to transfer to
125    * @param _value uint256 the amount of tokens to be transferred
126    */
127   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129 
130     uint256 _allowance = allowed[_from][msg.sender];
131 
132     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
133     // require (_value <= _allowance);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = _allowance.sub(_value);
138     Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    *
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153     allowed[msg.sender][_spender] = _value;
154     Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
165     return allowed[_owner][_spender];
166   }
167 
168   /**
169    * approve should be called when allowed[_spender] == 0. To increment
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    */
174   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 }
191 
192 contract Ether2x is StandardToken, owned, allowMonthly {
193 
194   string public constant name = "Ethereum 2x";
195   string public constant symbol = "E2X";
196   uint8 public constant decimals = 8;
197 
198   bool public initialDrop;
199   uint256 public inititalSupply = 10000000 * (10 ** uint256(decimals));
200   uint256 public totalSupply;
201 
202   address NULL_ADDRESS = address(0);
203 
204   uint public nonce = 0;
205 
206   event NonceTick(uint _nonce);
207   
208   function incNonce() public {
209     nonce += 1;
210     if(nonce > 100) {
211         nonce = 0;
212     }
213     NonceTick(nonce);
214   }
215 
216   // Note intended to act as a source of authorized messaging from development team
217   event NoteChanged(string newNote);
218   string public note = "Earn from your Ether with Ease.";
219   function setNote(string note_) public onlyOwner {
220     note = note_;
221     NoteChanged(note);
222   }
223   
224   event PerformingDrop(uint count);
225   /// @notice Buy tokens from contract by sending ether
226   function distributeRewards(address[] addresses) public onlyOwner {
227     assert(addresses.length > 499);                  // Rewards start after 500 addresses have signed up
228     uint256 totalAmt;
229     if (initialDrop) {
230         totalAmt = totalSupply / 4;
231         initialDrop = false;
232     } else {
233         totalAmt = totalSupply / 100;
234     }
235     uint256 baseAmt = totalAmt / addresses.length;
236     assert(baseAmt > 0);
237     PerformingDrop(addresses.length);
238     uint256 holdingBonus = 0;
239     uint256 reward = 0;
240     
241     for (uint i = 0; i < addresses.length; i++) {
242       address recipient = addresses[i];
243       if(recipient != NULL_ADDRESS) {
244         holdingBonus = balanceOf(recipient) / 500;
245         reward = baseAmt + holdingBonus;
246         balances[recipient] += reward;
247         totalSupply += reward;
248         Transfer(0, owner, reward);
249         Transfer(owner, recipient, reward);
250       }
251     }
252     
253     useMonthlyAccess(); // restrict use of reward function for 4 weeks
254   }  
255 
256   /**
257    * @dev Constructor that gives msg.sender all of existing tokens..
258    */
259   function Ether2x() public {
260     totalSupply = inititalSupply;
261     balances[msg.sender] = totalSupply;
262     initialDrop = true;
263   }
264 }