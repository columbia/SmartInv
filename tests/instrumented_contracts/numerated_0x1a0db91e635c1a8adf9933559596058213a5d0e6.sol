1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint8 public decimals = 8;
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75     if (a == 0) {
76       return 0;
77     }
78     uint256 c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108   
109   address daka_holder = 0x2bC44Bca631B28d4B946b6b8db770d781f21a716;
110   address community_holder = 0x8E05824c064559672d42b5d81720d36E3A1955D3;
111   address dev_holder = 0xBfC89c5adA79002EbA7831F29bCf58e804cA418D;
112   address support_holder = 0x33bF69EB5E4315F96aE8799f463FE577bDE77e4f;
113   address consultant_holder = 0x6A8800307b4CC9283C25a23ee9440b8b02295214;
114   address early_contributes_holder = 0xa5A34aA597279a646154D4054F87a705Bf1007e7;
115   address reserved_holder = 0xB8b93ce61251338bbAeEB971b89FF5df7bcAf95C;
116 
117   
118   uint256 daka_award = 6700000 * (10 ** 8);
119   uint256 community_award = 1000000 * 10 ** 8;
120   uint256 dev_group_award = 700000 * 10 ** 8;
121   uint256 support_group_award = 700000 * 10 ** 8;
122   uint256 group_consult = 300000 * 10 ** 8;
123   uint256 early_contributes = 300000 * 10 ** 8;
124   uint256 reserved_amount = 300000 * 10 ** 8;
125   mapping(address => uint256) balances;
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balanceOf(msg.sender));
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149           uint256 date_2019_6_1 = 1559318400;
150           uint256 date_2020_1_1 = 1577808000;
151           uint256 date_2020_6_1 = 1590940800;
152           uint256 date_2021_6_1 = 1622476800;
153           uint256 date_2022_1_1 = 1640966400;
154           uint256 date_2022_6_1 = 1654012800;
155           uint256 date_2023_6_1 = 1685548800;
156       if (_owner == daka_holder) {
157           uint256 remain_amount = 0;
158           if (now < date_2019_6_1) {
159               remain_amount = 6700000 * 10 ** 8;
160           } else if (now < date_2020_6_1) {
161               remain_amount = 4700000 * 10 ** 8;
162           } else if (now < date_2021_6_1) {
163               remain_amount = 3000000 * 10 ** 8;
164           } else if (now < date_2022_6_1) {
165               remain_amount = 1700000 * 10 ** 8;
166           } else if (now < date_2023_6_1) {
167               remain_amount = 700000 * 10 ** 8;
168           } else {
169               remain_amount = 0;
170           }
171           return balances[_owner] - remain_amount;
172       }
173       if (_owner == dev_holder) {
174           if (now < date_2020_1_1) {
175               return 0;
176           }
177       }
178       if (_owner == support_holder) {
179           if (now < date_2020_1_1) {
180               return 0;
181           }
182       }
183       if (_owner == reserved_holder) {
184           if (now < date_2022_1_1) {
185               return 0;
186           }
187       }
188       return balances[_owner];
189   }
190 
191 }
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * @dev https://github.com/ethereum/EIPs/issues/20
198  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
212     require(_to != address(0));
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219     Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    *
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(address _owner, address _spender) public view returns (uint256) {
246     return allowed[_owner][_spender];
247   }
248 
249   /**
250    * @dev Increase the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _addedValue The amount of tokens to increase the allowance by.
258    */
259   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
260     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
261     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265   /**
266    * @dev Decrease the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To decrement
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _subtractedValue The amount of tokens to decrease the allowance by.
274    */
275   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
276     uint oldValue = allowed[msg.sender][_spender];
277     if (_subtractedValue > oldValue) {
278       allowed[msg.sender][_spender] = 0;
279     } else {
280       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281     }
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286 }
287 
288 
289 
290 contract VariableSupplyToken is StandardToken, Ownable {
291     event Burn(address indexed burner, uint256 value);
292 
293     /*
294      * @dev Burns a specific amount of the sender's tokens
295      * @param _value The amount of tokens to be burned
296      */
297     function burn(uint256 _amount) public {
298         // Must not burn more than the sender owns
299         require(_amount <= balances[msg.sender]);
300 
301         address burner = msg.sender;
302         balances[burner] = balances[burner].sub(_amount);
303         totalSupply = totalSupply.sub(_amount);
304 
305         Burn(burner, _amount);
306     }
307 }
308 
309 contract IDakaToken is ERC20, Ownable {
310     function burn(uint256 _amount) public;
311 }
312 
313 contract DakaToken is IDakaToken, VariableSupplyToken {
314     string public name = "iDaka Token";
315     string public symbol = "IDK";
316     string public version = "1.0";
317     function DakaToken() {
318         totalSupply = daka_award + community_award + dev_group_award + support_group_award + group_consult + early_contributes + reserved_amount;
319         balances[daka_holder] = daka_award;
320         balances[community_holder] = community_award;
321         balances[dev_holder] = dev_group_award;
322         balances[support_holder] = support_group_award;
323         balances[consultant_holder] = group_consult;
324         balances[early_contributes_holder] = early_contributes;
325         balances[reserved_holder] = reserved_amount;
326     }
327 }