1 pragma solidity ^0.4.19;
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
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20Basic {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function transfer(address to, uint value);
64   event Transfer(address indexed from, address indexed to, uint value);
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint;
74 
75   mapping(address => uint) balances;
76 
77   /**
78    * @dev Fix for the ERC20 short address attack.
79    */
80   modifier onlyPayloadSize(uint size) {
81      if(msg.data.length < size + 4) {
82        throw;
83      }
84      _;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) constant returns (uint);
116   function transferFrom(address from, address to, uint value);
117   function approve(address spender, uint value);
118   event Approval(address indexed owner, address indexed spender, uint value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implemantation of the basic standart token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is BasicToken, ERC20 {
130 
131   mapping (address => mapping (address => uint)) allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint the amout of tokens to be transfered
139    */
140   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
141     var _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // if (_value > _allowance) throw;
145 
146     balances[_to] = balances[_to].add(_value);
147     balances[_from] = balances[_from].sub(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150   }
151 
152   /**
153    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint _value) {
158 
159     // To change the approve amount you first have to reduce the addresses`
160     //  allowance to zero by calling `approve(_spender, 0)` if it is not
161     //  already 0 to mitigate the race condition described here:
162     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens than an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint specifing the amount of tokens still avaible for the spender.
174    */
175   function allowance(address _owner, address _spender) constant returns (uint remaining) {
176     return allowed[_owner][_spender];
177   }
178 
179 }
180 
181 contract SharkToken is StandardToken {
182   using SafeMath for uint256;
183 
184   string public name = "Shark Fund";
185   string public symbol = "SAK";
186   uint public decimals = 18;
187   
188   function SharkToken() {
189     totalSupply = 400000000000000000000000000;
190     balances[msg.sender] = totalSupply;
191   }
192 
193 }