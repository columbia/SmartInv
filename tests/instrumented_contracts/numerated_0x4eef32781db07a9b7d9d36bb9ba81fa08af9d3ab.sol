1 pragma solidity ^0.4.23;
2 
3 // ================= Ownable Contract start =============================
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11   address public owner;
12 
13   constructor() public {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     if (newOwner != address(0)) {
24       owner = newOwner;
25     }
26   }
27 }
28 // ================= Ownable Contract end ===============================
29 
30 // ================= Safemath Lib ============================
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 // ================= Safemath Lib end ==============================
73 
74 // ================= ERC20 Token Contract start =========================
75 /*
76  * ERC20 interface
77  * see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 {
80   function totalSupply() public view returns (uint256);
81   function balanceOf(address who) public view returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   function allowance(address owner, address spender) public view returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   function burn(uint256 _value) public returns (bool);
87 
88   event Transfer(address indexed from, address indexed to, uint256 value);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90   
91   // This notifies clients about the amount burnt
92   event Burn(address indexed from, uint256 value);
93 }
94 // ================= ERC20 Token Contract end ===========================
95 
96 // ================= Standard Token Contract start ======================
97 contract StandardToken is ERC20 {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182 
183     /**
184      * Destroy tokens
185      *
186      * Remove `_value` tokens from the system irreversibly
187      *
188      * @param _value the amount of money to burn
189      */
190   function burn(uint256 _value) public returns (bool success) {
191       require(balances[msg.sender] >= _value);   // Check if the sender has enough
192       balances[msg.sender] -= _value;            // Subtract from the sender
193       totalSupply_ -= _value;                      // Updates totalSupply
194       emit Burn(msg.sender, _value);
195       return true;
196   }
197   
198 }
199 // ================= Standard Token Contract end ========================
200 
201 // ================= Pausable Token Contract start ======================
202 /**
203  * @title Pausable
204  * @dev Base contract which allows children to implement an emergency stop mechanism.
205  */
206 contract Pausable is Ownable {
207   event Pause();
208   event Unpause();
209 
210   bool public paused = false;
211 
212 
213   /**
214   * @dev modifier to allow actions only when the contract IS paused
215   */
216   modifier whenNotPaused() {
217     require (!paused);
218     _;
219   }
220 
221   /**
222   * @dev modifier to allow actions only when the contract IS NOT paused
223   */
224   modifier whenPaused {
225     require (paused) ;
226     _;
227   }
228 
229   /**
230   * @dev called by the owner to pause, triggers stopped state
231   */
232   function pause() public onlyOwner whenNotPaused returns (bool) {
233     paused = true;
234     emit Pause();
235     return true;
236   }
237 
238   /**
239   * @dev called by the owner to unpause, returns to normal state
240   */
241   function unpause() public onlyOwner whenPaused returns (bool) {
242     paused = false;
243     emit Unpause();
244     return true;
245   }
246 }
247 // ================= Pausable Token Contract end ========================
248 
249 // ================= RVTCoin  start =======================
250 contract RVTCoin is StandardToken, Pausable {
251   string public constant name = 'Renvale Token';
252   string public constant symbol = 'RVT';
253   uint256 public constant decimals = 18;
254   address public rvDepositAddress; 
255 
256   uint256 public constant rvDeposit = 2000000000 * 10**decimals;
257 
258   constructor(address _rvDepositAddress) public { 
259     rvDepositAddress = _rvDepositAddress;
260 
261     balances[rvDepositAddress] = rvDeposit;
262     emit Transfer(0x0, rvDepositAddress, rvDeposit);
263     totalSupply_ = rvDeposit;
264   }
265 
266   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
267     return super.transfer(_to,_value);
268   }
269 
270   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
271     return super.approve(_spender, _value);
272   }
273 
274   function balanceOf(address _owner) public view returns (uint256 balance) {
275     return super.balanceOf(_owner);
276   }
277 
278   function burn(uint256 _value) public returns (bool success){
279      return super.burn(_value);
280   }
281 }
282 // ================= Token Contract end =======================