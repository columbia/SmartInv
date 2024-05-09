1 pragma solidity ^0.4.14;
2 
3 
4 //SatanCoin token buying contract
5 
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   /**
59   * @dev transfer token for a specified address
60   * @param _to The address to transfer to.
61   * @param _value The amount to be transferred.
62   */
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 //SatanCoin token buying contract
174 
175 contract SatanCoin is StandardToken {
176   
177   using SafeMath for uint;
178 
179   string public constant name = "SatanCoin";
180   string public constant symbol = "SATAN";
181   uint public constant decimals = 0;
182 
183   address public owner = msg.sender;
184   //.0666 ether = 1 SATAN
185   uint public constant rate = .0666 ether;
186 
187   uint public roundNum = 0;
188   uint public constant roundMax = 74;
189   uint public roundDeadline;
190   bool public roundActive = false;
191   uint tokenAmount;
192   uint roundBuyersNum;
193 
194   mapping(uint => address) buyers;
195 
196   event Raffled(uint roundNumber, address winner, uint amount);
197   event RoundStart(uint roundNumber);
198   event RoundEnd(uint roundNumber);
199 
200   modifier onlyOwner {
201       require(msg.sender == owner);
202       _;
203   }
204 
205   function ()
206     payable
207   {
208     createTokens(msg.sender);
209   }
210 
211   function createTokens(address receiver)
212     public
213     payable
214   {
215     //Make sure there is an active buying round
216     require(roundActive);
217     //Make sure greater than 0 was sent
218     require(msg.value > 0);
219     //Make sure the amount is a multiple of .0666 ether
220     require((msg.value % rate) == 0);
221 
222     tokenAmount = msg.value.div(rate);
223 
224     //Make sure no more than 74 Satancoins issued per round
225     require(tokenAmount <= getRoundRemaining());
226     //Make sure that no more than 666 SatanCoins can be issued.
227     require((tokenAmount+totalSupply) <= 666);
228     //Extra precaution to contract attack
229     require(tokenAmount >= 1);
230 
231     //Issue Tokens
232     totalSupply = totalSupply.add(tokenAmount);
233     balances[receiver] = balances[receiver].add(tokenAmount);
234 
235     //Record buyer per token bought this round 
236     for(uint i = 0; i < tokenAmount; i++)
237     {
238       buyers[i.add(getRoundIssued())] = receiver;
239     }
240 
241     //Send Ether to owner
242     owner.transfer(msg.value);
243   }
244 
245   function startRound()
246     public
247     onlyOwner
248     returns (bool)
249   {
250     require(!roundActive);//last round must have been ended
251     require(roundNum<9); //only 9 rounds may occur
252      
253     roundActive = true;
254     roundDeadline = now + 6 days;
255     roundNum++;
256 
257     RoundStart(roundNum);
258     return true;
259   }
260 
261   function endRound()
262     public
263     onlyOwner
264     returns (bool)
265   {
266      require(roundDeadline < now);
267      //If no tokens sold, give full amount to owner
268     if(getRoundRemaining() == 74)
269     {
270       totalSupply = totalSupply.add(74);
271       balances[owner] = balances[owner].add(74);
272     } //raffles off remaining tokens if any are left
273     else if(getRoundRemaining() != 0) assert(raffle(getRoundRemaining()));
274 
275     roundActive = false;
276 
277     RoundEnd(roundNum);
278     return true;
279   }
280 
281   function raffle(uint raffleAmount)
282     private
283     returns (bool)
284   {
285     //Assign random number to a token bought this round and make the buyer the winner
286     uint randomIndex = uint(block.blockhash(block.number))%(roundMax-raffleAmount)+1;
287     address receiver = buyers[randomIndex];
288 
289     totalSupply = totalSupply.add(raffleAmount);
290     balances[receiver] = balances[receiver].add(raffleAmount);
291 
292     Raffled(roundNum, receiver, raffleAmount);
293     return true;
294   }
295 
296   function getRoundRemaining()
297     public
298     constant
299     returns (uint)
300   {
301     return roundNum.mul(roundMax).sub(totalSupply);
302   }
303 
304    function getRoundIssued()
305     public
306     constant
307     returns (uint)
308   {
309     return totalSupply.sub((roundNum-1).mul(roundMax));
310   }
311 }