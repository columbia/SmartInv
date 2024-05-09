1 pragma solidity ^0.4.11;
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
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) returns (bool);
87   function approve(address spender, uint256 value) returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
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
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amout of tokens to be transfered
109    */
110   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
111     var _allowance = allowed[_from][msg.sender];
112 
113     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
114     // require (_value <= _allowance);
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) returns (bool) {
129 
130     // To change the approve amount you first have to reduce the addresses`
131     //  allowance to zero by calling `approve(_spender, 0)` if it is not
132     //  already 0 to mitigate the race condition described here:
133     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
135 
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifing the amount of tokens still avaible for the spender.
146    */
147   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151 }
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner;
160 
161 
162   /**
163    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164    * account.
165    */
166   function Ownable() {
167     owner = msg.sender;
168   }
169 
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) onlyOwner {
185     if (newOwner != address(0)) {
186       owner = newOwner;
187     }
188   }
189 
190 }
191 
192 contract SynchroCoin is Ownable, StandardToken {
193 
194     string public constant symbol = "SYC";
195 
196     string public constant name = "SynchroCoin";
197 
198     uint8 public constant decimals = 12;
199     
200 
201     uint256 public STARTDATE;
202 
203     uint256 public ENDDATE;
204 
205     // 55% to distribute during CrowdSale
206     uint256 public crowdSale;
207 
208     // 20% to pool to reward
209     // 25% to other business operations
210     address public multisig;
211 
212     function SynchroCoin(
213     uint256 _initialSupply,
214     uint256 _start,
215     uint256 _end,
216     address _multisig) {
217         totalSupply = _initialSupply;
218         STARTDATE = _start;
219         ENDDATE = _end;
220         multisig = _multisig;
221         crowdSale = _initialSupply * 55 / 100;
222         balances[multisig] = _initialSupply;
223     }
224 
225     // crowdsale statuses
226     uint256 public totalFundedEther;
227 
228     //This includes the Ether raised during the presale.
229     uint256 public totalConsideredFundedEther = 338;
230 
231     mapping (address => uint256) consideredFundedEtherOf;
232 
233     mapping (address => bool) withdrawalStatuses;
234 
235     function calcBonus() public constant returns (uint256){
236         return calcBonusAt(now);
237     }
238 
239     function calcBonusAt(uint256 at) public constant returns (uint256){
240         if (at < STARTDATE) {
241             return 140;
242         }
243         else if (at < (STARTDATE + 1 days)) {
244             return 120;
245         }
246         else if (at < (STARTDATE + 7 days)) {
247             return 115;
248         }
249         else if (at < (STARTDATE + 14 days)) {
250             return 110;
251         }
252         else if (at < (STARTDATE + 21 days)) {
253             return 105;
254         }
255         else if (at <= ENDDATE) {
256             return 100;
257         }
258         else {
259             return 0;
260         }
261     }
262 
263 
264     function() public payable {
265         proxyPayment(msg.sender);
266     }
267 
268     function proxyPayment(address participant) public payable {
269         require(now >= STARTDATE);
270 
271         require(now <= ENDDATE);
272 
273         //require msg.value >= 0.1 ether
274         require(msg.value >= 100 finney);
275 
276         totalFundedEther = totalFundedEther.add(msg.value);
277 
278         uint256 _consideredEther = msg.value.mul(calcBonus()).div(100);
279         totalConsideredFundedEther = totalConsideredFundedEther.add(_consideredEther);
280         consideredFundedEtherOf[participant] = consideredFundedEtherOf[participant].add(_consideredEther);
281         withdrawalStatuses[participant] = true;
282 
283         // Log events
284         Fund(
285         participant,
286         msg.value,
287         totalFundedEther
288         );
289 
290         // Move the funds to a safe wallet
291         multisig.transfer(msg.value);
292     }
293 
294     event Fund(
295     address indexed buyer,
296     uint256 ethers,
297     uint256 totalEther
298     );
299 
300     function withdraw() public returns (bool success){
301         return proxyWithdraw(msg.sender);
302     }
303 
304     function proxyWithdraw(address participant) public returns (bool success){
305         require(now > ENDDATE);
306         require(withdrawalStatuses[participant]);
307         require(totalConsideredFundedEther > 1);
308 
309         uint256 share = crowdSale.mul(consideredFundedEtherOf[participant]).div(totalConsideredFundedEther);
310         participant.transfer(share);
311         withdrawalStatuses[participant] = false;
312         return true;
313     }
314 
315     /* Send coins */
316     function transfer(address _to, uint256 _amount) public returns (bool success) {
317         require(now > ENDDATE);
318         return super.transfer(_to, _amount);
319     }
320 
321     /* A contract attempts to get the coins */
322     function transferFrom(address _from, address _to, uint256 _amount) public
323     returns (bool success)
324     {
325         require(now > ENDDATE);
326         return super.transferFrom(_from, _to, _amount);
327     }
328 
329 }