1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address _owner) constant returns (uint balance);
62   function transfer(address _to, uint _value) returns (bool success);
63   event Transfer(address indexed _from, address indexed _to, uint _value);
64 }
65 
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address _owner, address _spender) constant returns (uint remaining);
73   function transferFrom(address _from, address _to, uint _value) returns (bool success);
74   function approve(address _spender, uint _value) returns (bool success);
75   event Approval(address indexed _owner, address indexed _spender, uint _value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances. 
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint;
84 
85   mapping(address => uint) balances;
86 
87   /**
88    * @dev Fix for the ERC20 short address attack.
89    */
90   modifier onlyPayloadSize(uint size) {
91      if(msg.data.length < size + 4) {
92        throw;
93      }
94      _;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool){
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106 	
107 	return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of. 
113   * @return An uint representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) constant returns (uint balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implemantation of the basic standart token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is BasicToken, ERC20 {
129 
130   mapping (address => mapping (address => uint)) allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint the amout of tokens to be transfered
138    */
139   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool){
140     var _allowance = allowed[_from][msg.sender];
141 
142     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143     // if (_value > _allowance) throw;
144 
145     balances[_to] = balances[_to].add(_value);
146     balances[_from] = balances[_from].sub(_value);
147     allowed[_from][msg.sender] = _allowance.sub(_value);
148     Transfer(_from, _to, _value);
149 	
150 	return true;
151   }
152 
153   /**
154    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint _value) returns (bool){
159 
160     // To change the approve amount you first have to reduce the addresses`
161     //  allowance to zero by calling `approve(_spender, 0)` if it is not
162     //  already 0 to mitigate the race condition described here:
163     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
165 
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168 	
169 	return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens than an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint specifing the amount of tokens still avaible for the spender.
177    */
178   function allowance(address _owner, address _spender) constant returns (uint remaining) {
179     return allowed[_owner][_spender];
180   }
181 
182 }
183 
184 // @title BTO Protocol Token.
185 // For more information about this token sale, please visit https://www.bottos.org/
186 
187 contract BTOToken is StandardToken {
188     string public constant name = "BTOCoin";
189     string public constant symbol = "BTO";
190     uint public constant decimals = 18;
191 
192     // Note: this will be initialized during the contract deployment.
193     address public target;    
194 
195     /**
196      * CONSTRUCTOR 
197      * 
198      * @dev Initialize the BTO Token
199      */
200     function BTOToken(address _target) {
201         target = _target;
202         totalSupply = 10 ** 27;
203         balances[target] = totalSupply;
204     }   
205 }