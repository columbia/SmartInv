1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20Basic {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function transfer(address to, uint value);
13   event Transfer(address indexed from, address indexed to, uint value);
14 }
15 pragma solidity ^0.4.11;
16 
17 
18 /**
19  * Math operations with safety checks
20  */
21 library SafeMath {
22   function mul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint a, uint b) internal returns (uint) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a >= b ? a : b;
48   }
49 
50   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a < b ? a : b;
52   }
53 
54   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a >= b ? a : b;
56   }
57 
58   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a < b ? a : b;
60   }
61 
62   function assert(bool assertion) internal {
63     if (!assertion) {
64       revert();
65     }
66   }
67 }
68 
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint;
77 
78   mapping(address => uint) balances;
79 
80   /**
81    * @dev Fix for the ERC20 short address attack.
82    */
83   modifier onlyPayloadSize(uint size) {
84      require(msg.data.length >= size + 4);
85      _;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint);
117   function transferFrom(address from, address to, uint value);
118   function approve(address spender, uint value);
119   event Approval(address indexed owner, address indexed spender, uint value);
120 }
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implemantation of the basic standart token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is BasicToken, ERC20 {
132 
133   mapping (address => mapping (address => uint)) allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint the amout of tokens to be transfered
141    */
142   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
143     var _allowance = allowed[_from][msg.sender];
144 
145     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
146     // if (_value > _allowance) throw;
147 
148     balances[_to] = balances[_to].add(_value);
149     balances[_from] = balances[_from].sub(_value);
150     allowed[_from][msg.sender] = _allowance.sub(_value);
151     Transfer(_from, _to, _value);
152   }
153 
154   /**
155    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint _value) {
160 
161     // To change the approve amount you first have to reduce the addresses`
162     //  allowance to zero by calling `approve(_spender, 0)` if it is not
163     //  already 0 to mitigate the race condition described here:
164     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
166 
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens than an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint specifing the amount of tokens still avaible for the spender.
176    */
177   function allowance(address _owner, address _spender) constant returns (uint remaining) {
178     return allowed[_owner][_spender];
179   }
180 
181 }
182 
183 
184 /**
185 * WagaToken发行说明：
186 * 币总量为2100万个。市值拟定为100万。
187 * 根据waga域名消费金额，按照一定比例兑换Token。当分配总量趋近2100万时，WagaToken分配趋向于0。
188 *
189 */
190 contract WagaToken is StandardToken {
191 
192     string public constant LOVEYOUFOREVER = "LIANGZAI";
193     string public constant NAME = "WagaToken";
194     string public constant SYMBOL = "WGT";
195     uint public constant DECIMALS = 18;
196 
197     /// Emitted when a function is invocated by unauthorized addresses.
198     event InvalidCaller(address caller);
199 
200     /// Emitted for each sucuessful token purchase.
201     event Issue(uint issueIndex, address addr, uint tokenAmount);
202 
203     uint public issueIndex = 0;
204 
205     /// 余额
206     mapping(address => uint256) public balanceOf;
207     /// 发行总数
208     uint public issueAmount = 0.0;
209 
210     uint totalAmount = 21000000;
211     address owner;
212     uint currentFactor = 10 ** DECIMALS;
213 
214 
215     function WagaToken() {
216         owner = msg.sender;
217     }
218 
219     modifier onlyOwner {
220         if (owner == msg.sender) {
221             _;
222         } else {
223             InvalidCaller(msg.sender);
224             revert();
225         }
226     }
227 
228     /// @param addr 为发放token的钱包地址
229     /// @param fee 为购买域名的花费
230     function issueTo(address addr,uint fee) onlyOwner {
231         var tokenAmount =  21 * fee * getFactor();
232         balanceOf[addr] += tokenAmount;
233         issueAmount += tokenAmount;
234         Issue(issueIndex++, addr, tokenAmount);
235     }
236 
237 
238     function getFactor() internal returns (uint) {
239         if(2 * (totalAmount * 10 ** 18 - issueAmount) <= currentFactor * totalAmount) {
240             currentFactor /= 2;
241         }
242         return currentFactor;
243     }
244 
245 
246 }