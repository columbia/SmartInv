1 pragma solidity ^0.4.18;
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
50       revert();
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
63   function balanceOf(address _owner) constant returns (uint balance);
64   function transfer(address _to, uint _value) returns (bool success);
65   event Transfer(address indexed _from, address indexed _to, uint _value);
66 }
67 
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances. 
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint;
76 
77   mapping(address => uint) balances;
78 
79   /**
80    * @dev Fix for the ERC20 short address attack.
81    */
82   modifier onlyPayloadSize(uint size) {
83      if(msg.data.length < size + 4) {
84        revert();
85      }
86      _;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool){
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98 	
99 	return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of. 
105   * @return An uint representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) constant returns (uint balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address _owner, address _spender) constant returns (uint remaining);
122   function transferFrom(address _from, address _to, uint _value) returns (bool success);
123   function approve(address _spender, uint _value) returns (bool success);
124   event Approval(address indexed _owner, address indexed _spender, uint _value);
125 }
126 
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implemantation of the basic standart token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is BasicToken, ERC20 {
138 
139   mapping (address => mapping (address => uint)) allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint the amout of tokens to be transfered
147    */
148   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool){
149     var _allowance = allowed[_from][msg.sender];
150 
151     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
152     // if (_value > _allowance) throw;
153 
154     balances[_to] = balances[_to].add(_value);
155     balances[_from] = balances[_from].sub(_value);
156     allowed[_from][msg.sender] = _allowance.sub(_value);
157     Transfer(_from, _to, _value);
158 	
159 	return true;
160   }
161 
162   /**
163    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint _value) returns (bool){
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177 	
178 	return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens than an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint specifing the amount of tokens still avaible for the spender.
186    */
187   function allowance(address _owner, address _spender) constant returns (uint remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191 }
192 
193 
194 contract PCTToken is StandardToken {
195     string public constant name = "PCTCoin";
196     string public constant symbol = "PCT";
197     uint public constant decimals = 18;
198 	
199     address public target;    
200 
201     function PCTToken(address _target) {
202         target = _target;
203         totalSupply = 2*(10 ** 27);
204         balances[target] = totalSupply;
205     }   
206 }