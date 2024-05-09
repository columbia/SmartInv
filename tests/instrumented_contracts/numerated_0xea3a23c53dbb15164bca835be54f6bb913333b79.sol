1 pragma solidity ^0.4.13;
2 /* 
3 * From OpenZeppelin project: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
4 */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /*
37  * ERC20 interface
38  * see https://github.com/ethereum/EIPs/issues/20
39  */
40 contract ERC20 {
41   uint public totalSupply;
42   function balanceOf(address who) constant returns (uint);
43   function allowance(address owner, address spender) constant returns (uint);
44 
45   function transfer(address to, uint value) returns (bool);
46   function transferFrom(address from, address to, uint value) returns (bool);
47   function approve(address spender, uint value) returns (bool ok);
48   event Transfer(address indexed from, address indexed to, uint value);
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 
52 
53 /**
54  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
55  *
56  * Based on code by FirstBlood:
57  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
58  */
59 contract StandardToken is ERC20 {
60 
61   using SafeMath for uint;
62 
63   /* Actual balances of token holders */
64   mapping (address => uint) balances;
65 
66   /* approve() allowances */
67   mapping (address => mapping (address => uint)) allowed;
68 
69   /* Interface declaration */
70   function isToken() public constant returns (bool) {
71     return true;
72   }
73 
74   /**
75    *
76    * Fix for the ERC20 short address attack
77    *
78    * http://vessenes.com/the-erc20-short-address-attack-explained/
79    */
80   modifier onlyPayloadSize(uint size) {
81     assert(msg.data.length >= size + 4);
82     _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool) {
91     require(balances[msg.sender] >= _value);
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Transfer tokens from one address to another
100    * @param _from address The address which you want to send tokens from
101    * @param _to address The address which you want to transfer to
102    * @param _value uint256 the amount of tokens to be transferred
103    */
104   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool) {
105     require(balances[_from] >= _value && allowed[_from][_to] >= _value);
106     allowed[_from][_to] = allowed[_from][_to].sub(_value);
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of. 
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) constant returns (uint balance) {
119     return balances[_owner];
120   }
121   
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint _value) returns (bool success) {
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner = msg.sender;
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) onlyOwner {
174     require(newOwner != address(0));
175     owner = newOwner;
176   }
177 
178 }
179 
180 
181 contract EmeraldToken is StandardToken, Ownable {
182 
183   string public name;
184   string public symbol;
185   uint public decimals;
186 
187   mapping (address => bool) public producers;
188 
189   bool public released = false;
190 
191   /*
192   * Only producer allowed
193   */
194   modifier onlyProducer() {
195     require(producers[msg.sender] == true);
196     _;
197   }
198 
199   /**
200    * Limit token transfer until the distribution is over.
201    * Owner can transfer tokens anytime
202    */
203   modifier canTransfer(address _sender) {
204     if (_sender != owner)
205       require(released);
206     _;
207   }
208 
209   modifier inProduction() {
210     require(!released);
211     _;
212   }
213 
214   function EmeraldToken(string _name, string _symbol, uint _decimals) {
215     require(_decimals > 0);
216     name = _name;
217     symbol = _symbol;
218     decimals = _decimals;
219 
220     // Make owner a producer of Emeralds
221     producers[msg.sender] = true;
222   }
223 
224   /*
225   * Sets a producer's status
226   * Distribution contract can be a producer
227   */
228   function setProducer(address _addr, bool _status) onlyOwner {
229     producers[_addr] = _status;
230   }
231 
232   /*
233   * Creates new Emeralds
234   */
235   function produceEmeralds(address _receiver, uint _amount) onlyProducer inProduction {
236     balances[_receiver] = balances[_receiver].add(_amount);
237     totalSupply = totalSupply.add(_amount);
238     Transfer(0, _receiver, _amount);
239   }
240 
241   /**
242    * One way function to release the tokens to the wild. No more tokens can be created.
243    */
244   function releaseTokenTransfer() onlyOwner {
245     released = true;
246   }
247 
248   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool) {
249     // Call StandardToken.transfer()
250     return super.transfer(_to, _value);
251   }
252 
253   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool) {
254     // Call StandardToken.transferForm()
255     return super.transferFrom(_from, _to, _value);
256   }
257 
258 }