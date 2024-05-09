1 pragma solidity ^0.4.14;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53   //Tracks Xmas tokens that have been used to claim from the giftPool
54   mapping(address => uint256) usedTokens;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     if(1 <= usedTokens[msg.sender]) { 
69         usedTokens[msg.sender] = usedTokens[msg.sender].sub(_value);
70         usedTokens[_to] = usedTokens[_to].add(_value);
71     }
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of.
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) public constant returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     usedTokens[_from] = usedTokens[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     usedTokens[_to] = usedTokens[_to].add(_value);
121     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
165     uint oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 
178 contract XmasCoin is StandardToken {
179   
180   using SafeMath for uint;
181 
182   string public constant name = "XmasCoin";
183   string public constant symbol = "XMAS";
184   uint public constant decimals = 0;
185   uint public constant totalSupply = 100;
186 
187   address public owner = msg.sender;
188   //Ether that will be gifted to all token holders after the deadline passes 
189   uint public giftPool;
190   //Ether that will be used for the next holiday gift pool after the deadline passes 
191   uint public timeToOpenPresents;
192 
193   event GiftPoolContribution(address giver, uint amountContributed);
194   event GiftClaimed(address claimant, uint amountClaimed, uint tokenAmountUsed);
195 
196   modifier onlyOwner {
197       require(msg.sender == owner);
198       _;
199   }
200 
201   function XmasCoin() {
202     //issue coins to owner for holiday distribution
203     balances[owner] = balances[owner].add(totalSupply);
204 
205     //gift time set to Christmas Day, December 25, 2017 12:00:00 AM GMT
206     timeToOpenPresents = 1514160000;
207   } 
208 
209   function claimXmasGift(address claimant)
210     public
211     returns (bool)
212   {
213     require(now > timeToOpenPresents);
214     require(1 <= validTokenBalance(claimant));
215     
216     uint amount = giftBalance(claimant);
217     uint tokenBalance = validTokenBalance(claimant);
218     usedTokens[claimant] += tokenBalance;
219     
220     claimant.transfer(amount);
221     GiftClaimed(claimant, amount, tokenBalance);
222     
223     return true;
224   }
225 
226   //all eth sent to fallback is added to the gift pool, stops accepting when presents open
227   function () 
228     public
229     payable
230   {
231     require(msg.value > 0);
232     require(now < timeToOpenPresents);
233     giftPool += msg.value;
234     GiftPoolContribution(msg.sender, msg.value);
235   } 
236   
237   function validTokenBalance (address _owner)
238     public
239     constant
240     returns (uint256)
241   {
242       return balances[_owner].sub(usedTokens[_owner]);
243   }
244   
245   function usedTokenBalance (address _owner)
246     public
247     constant
248     returns (uint256)
249   {
250       return usedTokens[_owner];
251   }
252   
253   function giftBalance(address claimant)
254     public
255     constant
256     returns (uint)
257   {
258     return giftPool.div(totalSupply).mul(validTokenBalance(claimant));    
259   }
260   
261   function selfDestruct()
262     public
263     onlyOwner
264   {
265      suicide(owner);
266   }
267   
268 }