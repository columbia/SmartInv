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
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) returns (bool);
53   function approve(address spender, uint256 value) returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) returns (bool) {
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
99 
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108     var _allowance = allowed[_from][msg.sender];
109 
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = _allowance.sub(_value);
116     Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) returns (bool) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
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
144   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147   
148     /*
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until 
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) 
155     returns (bool success) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   function decreaseApproval (address _spender, uint _subtractedValue) 
162     returns (bool success) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 
176 /**
177  * @title G5
178  *
179  * @dev Great token to buy.
180  * @dev Maximum 5% risk, potentially infinite upside.
181  */
182  
183 contract G5 is StandardToken {
184     uint256 ceiling;
185     uint256 floor;
186     uint256 lastUpdate;
187     
188     string public name = "G5";
189     string public symbol = "G5";
190     uint8 public decimals = 8;
191     
192     function getFloor() returns(uint256) {
193         return floor;
194     }
195     
196     function getCeiling() returns(uint256) {
197         return ceiling;
198     }
199     
200     function updateCeiling() private {
201         // ceiling is always 5% above the value of the floor
202         ceiling = floor*21/20;
203     }
204     
205     function G5() {
206         // 9523 tokens per ETH to start
207         floor = 1 ether / 10000 / 1e8;
208         updateCeiling();
209         lastUpdate = block.number;
210     }
211     
212     function() payable {
213         buy();
214     }
215     
216     function buy() payable {
217         require (msg.value > 0);
218         
219         // buy at the ceiling
220         uint256 _amount = msg.value / ceiling;
221 
222         // mint token            
223         totalSupply = totalSupply.add(_amount);
224         balances[msg.sender] = balances[msg.sender].add(_amount);
225         Mint(msg.sender, _amount);
226         Transfer(0x0, msg.sender, _amount);
227     
228         // set floor and ceiling if it's been at least 3 blocks since last update
229         if (block.number >= lastUpdate+3) {
230             floor = this.balance / totalSupply;
231             updateCeiling();
232             lastUpdate = block.number;
233         }
234     }
235     
236     function sell(uint _value) {
237         require(_value > 0);
238         require(_value <= balances[msg.sender]);
239         
240         balances[msg.sender] = balances[msg.sender].sub(_value);
241         totalSupply = totalSupply.sub(_value);
242         Burn(msg.sender, _value);
243         
244         // sell at the floor
245         msg.sender.transfer(_value * floor);
246     }
247 
248     event Mint(address indexed to, uint256 amount);
249     event Burn(address indexed burner, uint indexed value);
250 }