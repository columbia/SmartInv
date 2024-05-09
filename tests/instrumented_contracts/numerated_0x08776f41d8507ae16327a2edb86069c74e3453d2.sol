1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is
33 greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns
68 (uint256);
69   function transferFrom(address from, address to, uint256 value) public
70 returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256
73 value);
74 }
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82   mapping(address => uint256) balances;
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood:
117 https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, BasicToken {
120 
121   mapping (address => mapping (address => uint256)) internal allowed;
122 
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param _from address The address which you want to send tokens from
127    * @param _to address The address which you want to transfer to
128    * @param _value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(address _from, address _to, uint256 _value) public
131 returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135 
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Approve the passed address to spend the specified amount of
145 tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk
148 that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One
150 possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set
152 the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a
165 spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for
169 the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns
172 (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and
181 wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public
188 returns (bool) {
189     allowed[msg.sender][_spender] =
190 allowed[msg.sender][_spender].add(_addedValue);
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To decrement
199    * allowed value is better to use this function to avoid 2 calls (and
200 wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance
205 by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public
208 returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 contract FartToken is StandardToken {
222     using SafeMath for uint256;
223     uint256 public totalSupply = 100000000;
224     string public name = "FartCoin";
225     string public symbol = "FART";
226     uint8 public decimals = 0;
227     address owner;
228     
229     // Floating FART supply
230     uint256 public remainingSupply;
231    
232     // Amount of free bundles left
233     uint256 public redeemed = 100;
234     uint256 public totalFartsReceived = 0;
235 
236     event Fart(string message);
237 
238     function FartToken(uint256 initialGrant) public payable {
239         remainingSupply = totalSupply;
240         balances[msg.sender] = initialGrant;
241         remainingSupply = remainingSupply.sub(initialGrant);
242         owner = msg.sender;
243     }
244 
245     function BuyToken(uint256 amount) public payable {
246         require(amount <= remainingSupply);
247         require(amount.mul(0.0001 ether) == msg.value);
248         remainingSupply = remainingSupply.sub(amount);
249         balances[msg.sender] = balances[msg.sender].add(amount);
250     }
251 
252     function SendFart(string message) public {
253         require(balances[msg.sender] > 0);
254         require(bytes(message).length < 100);
255 
256         balances[msg.sender] = balances[msg.sender].sub(1);
257         remainingSupply =  remainingSupply.add(1);
258         totalFartsReceived = totalFartsReceived.add(1);
259         Fart(message);
260     }
261 
262     function GetFreeTokens() public {
263         require(balances[msg.sender] == 0);
264         require(redeemed > 0);
265         require(remainingSupply > 10);
266 
267         redeemed = redeemed.add(1);
268         balances[msg.sender] = balances[msg.sender].add(10);
269         remainingSupply = remainingSupply.sub(10);
270     }
271 
272     function GetBank() public {
273         owner.transfer(this.balance);
274     }
275 }