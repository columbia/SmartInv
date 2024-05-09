1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath 
7 {
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
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint);
73   function transferFrom(address from, address to, uint value);
74   function approve(address spender, uint value);
75   event Approval(address indexed owner, address indexed spender, uint value);
76 } 
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint; 
84 
85  mapping(address => uint) balances;
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
102   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
103    balances[msg.sender] = balances[msg.sender].sub(_value);
104    balances[_to] = balances[_to].add(_value);
105    Transfer(msg.sender, _to, _value);
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) constant returns (uint balance) {
114     return balances[_owner];
115   } 
116 
117 } 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is BasicToken, ERC20 { 
127 
128   mapping (address => mapping (address => uint)) allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint the amout of tokens to be transfered
136    */
137   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
138     var _allowance = allowed[_from][msg.sender]; 
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // if (_value > _allowance) throw;
142 
143     balances[_to] = balances[_to].add(_value);
144     balances[_from] = balances[_from].sub(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146     Transfer(_from, _to, _value);
147   }
148 
149   /**
150    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint _value) { 
155 
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender, 0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;  
161 
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens than an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint specifing the amount of tokens still avaible for the spender.
171    */
172   function allowance(address _owner, address _spender) constant returns (uint remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 /**
179  * @title Sophos ERC20 token
180  *
181  * @dev Implementation of the Sophos Token.
182  */
183 contract SophosToken is StandardToken {
184 
185     string public name = "Sophos";
186     string public symbol = "SOPH";
187     uint public decimals = 8 ;
188     uint public INITIAL_SUPPLY = 3000000000000000; // Initial supply is 30,000,000
189 
190     function SophosToken() {
191         totalSupply = INITIAL_SUPPLY;
192         balances[msg.sender] = INITIAL_SUPPLY;
193     }
194 }