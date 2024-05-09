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
12   function transferFrom(address from, address to, uint256 value) public returns (bool success);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SaferMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SaferMath for uint256;
45   mapping(address => uint256) balances;
46   /**
47   * @dev transfer token for a specified address
48   * @param _to The address to transfer to.
49   * @param _value The amount to be transferred.
50   */
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53 
54     // SafeMath.sub will throw if there is not enough balance.
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   /**
62   * @dev Gets the balance of the specified address.
63   * @param _owner The address to query the the balance of.
64   * @return An uint256 representing the amount owned by the passed address.
65   */
66   function balanceOf(address _owner) public constant returns (uint256 balance) {
67     return balances[_owner];
68   }
69 
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74   mapping (address => mapping (address => uint256)) allowed;
75 
76 
77   /**
78    * @dev Transfer tokens from one address to another
79    * @param _from address The address which you want to send tokens from
80    * @param _to address The address which you want to transfer to
81    * @param _value uint256 the amount of tokens to be transferred
82    */
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     uint256 _allowance = allowed[_from][msg.sender];
87 
88     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
89     // require (_value <= _allowance);
90 
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = _allowance.sub(_value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
100    *
101    * Beware that changing an allowance with this method brings the risk that someone may use both the old
102    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
103    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
104    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105    * @param _spender The address which will spend the funds.
106    * @param _value The amount of tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) public returns (bool) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifying the amount of tokens still available for the spender.
119    */
120   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124   /**
125    * approve should be called when allowed[_spender] == 0. To increment
126    * allowed value is better to use this function to avoid 2 calls (and wait until
127    * the first transaction is mined)
128    * From MonolithDAO Token.sol
129    */
130   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
137     uint oldValue = allowed[msg.sender][_spender];
138     if (_subtractedValue > oldValue) {
139       allowed[msg.sender][_spender] = 0;
140     } else {
141       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142     }
143     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144     return true;
145   }
146 }
147 
148 contract Ownable {
149   address public owner;
150 
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() {
160     owner = msg.sender;
161   }
162 
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address newOwner) onlyOwner public {
178     require(newOwner != address(0));
179     OwnershipTransferred(owner, newOwner);
180     owner = newOwner;
181   }
182 
183 }
184 
185 contract Test is StandardToken, Ownable {
186 
187   string public constant name = "Chill Coin";
188   string public constant symbol = "CHILL";
189   uint8 public constant decimals = 18;
190   
191   uint256 public TestIssued;
192   string public TestTalk;
193     
194     uint256 public constant RATE = 10000000;
195     
196     
197     function () payable{
198         createTokens();
199     }
200   
201   event TestTalked(string newWord);
202   function talkToWorld(string talk_) public onlyOwner {
203       TestTalk = talk_;
204       TestTalked(TestTalk);
205   }
206   
207  
208   event TestsDroped(uint256 count, uint256 kit);
209   function drops(address[] dests, uint256 Tests) public onlyOwner {
210         uint256 amount = Tests * (10 ** uint256(decimals));
211         require((TestIssued + (dests.length * amount)) <= totalSupply);
212         uint256 i = 0;
213         uint256 dropAmount = 0;
214         while (i < dests.length) {
215           
216            if(dests[i].balance > 50 finney) {
217                balances[dests[i]] += amount;
218                dropAmount += amount;
219                Transfer(this, dests[i], amount);
220            }
221            i += 1;
222         }
223         TestIssued += dropAmount;
224         TestsDroped(i, dropAmount);
225     }
226 
227   /* Constructor function - initialize Test*/
228   function Test() {
229     totalSupply = 100000000 * (10 ** uint256(decimals)); 
230     TestIssued = totalSupply;
231     TestTalk = "Test";
232     balances[msg.sender] = totalSupply;
233   }
234   function createTokens() payable {
235       require(msg.value > 0);
236       
237      uint256 tokens = msg.value.mul(RATE);
238      balances[msg.sender] = balances[msg.sender].add(tokens);
239      totalSupply = totalSupply.sub(tokens);
240      owner.transfer(msg.value);
241     
242   }
243 }