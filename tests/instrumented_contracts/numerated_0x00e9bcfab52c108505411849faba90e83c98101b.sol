1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /**
57  * @title ERC20Basic
58  * @dev Simpler version of ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20Basic {
62   uint public totalSupply;
63   function balanceOf(address who) constant returns (uint);
64   function transfer(address to, uint value);
65   event Transfer(address indexed from, address indexed to, uint value);
66 }
67 
68 contract DestoryBasic {
69     address destoryAddress;
70     
71     function setDestoryAddress(address _destory) {
72         destoryAddress = _destory;
73     }
74     
75     function ifDestory(address from) returns (bool) {
76         if (from == destoryAddress) {
77             return true;
78         }
79         return false;
80     }
81 }
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances.
86  */
87 contract BasicToken is ERC20Basic,DestoryBasic {
88   using SafeMath for uint;
89 
90   mapping(address => uint) balances;
91 
92   /**
93    * @dev Fix for the ERC20 short address attack.
94    */
95   modifier onlyPayloadSize(uint size) {
96      if(msg.data.length < size + 4) {
97        throw;
98      }
99      _;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
108     if(ifDestory(msg.sender)) throw;
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     Transfer(msg.sender, _to, _value);
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) constant returns (uint);
132   function transferFrom(address from, address to, uint value);
133   function approve(address spender, uint value);
134   event Approval(address indexed owner, address indexed spender, uint value);
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implemantation of the basic standart token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is BasicToken, ERC20 {
146 
147   mapping (address => mapping (address => uint)) allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint the amout of tokens to be transfered
155    */
156   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
157     if(ifDestory(msg.sender)) throw;
158     var _allowance = allowed[_from][msg.sender];
159 
160     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
161     // if (_value > _allowance) throw;
162 
163     balances[_to] = balances[_to].add(_value);
164     balances[_from] = balances[_from].sub(_value);
165     allowed[_from][msg.sender] = _allowance.sub(_value);
166     Transfer(_from, _to, _value);
167   }
168 
169   /**
170    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint _value) {
175 
176     // To change the approve amount you first have to reduce the addresses`
177     //  allowance to zero by calling `approve(_spender, 0)` if it is not
178     //  already 0 to mitigate the race condition described here:
179     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw ;
181 
182     allowed[msg.sender][_spender] = _value;
183     Approval(msg.sender, _spender, _value);
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens than an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint specifing the amount of tokens still avaible for the spender.
191    */
192   function allowance(address _owner, address _spender) constant returns (uint remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196 }
197 
198 
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205   address public owner;
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210   modifier onlyOwner() {
211     if (msg.sender != owner) {
212       throw;
213     }
214     _;
215   }
216 
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) onlyOwner {
223     if (newOwner != address(0)) {
224       owner = newOwner;
225     }
226   }
227 
228 }
229 
230 
231 /**
232  * @title GTSTOKEN
233  */
234 contract GTSTOKEN is StandardToken,Ownable {
235   using SafeMath for uint;
236 
237   string public name = "GTSTOKEN";
238   string public symbol = "GTS";
239   uint public decimals = 9;
240   uint public totalSupply = 10000000000 * (10 ** decimals);
241   uint lockTotal = 4000000000 * (10 ** decimals);
242   uint public releaseTotal = 500000000 * (10 ** decimals);
243   
244   uint lockTime = 0;//last lock time 
245  
246   function GTSTOKEN (address admin_) {
247       lockTime = 1518192000;//2018/2/10 0:0:0
248       owner = admin_;
249       setDestoryAddress(address(0x0));
250       balances[admin_] = totalSupply - lockTotal;
251   }
252   
253   function release() onlyOwner {
254       if (lockTime + 1 years > now) {
255           throw;
256       }
257       if ( lockTotal == 0 ) {
258         throw;
259       }
260       lockTotal = lockTotal.sub(releaseTotal);
261       balances[owner] = balances[owner].add(releaseTotal);
262       lockTime = lockTime + 1 years;
263       return;
264   }
265 
266 
267   
268 }