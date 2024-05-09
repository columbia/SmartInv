1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       revert();
47     }
48   }
49 }
50 
51 contract ERC20Basic {
52   uint public totalSupply;
53   function balanceOf(address _owner) constant returns (uint balance);
54   function transfer(address _to, uint _value) returns (bool success);
55   event Transfer(address indexed _from, address indexed _to, uint _value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint;
60 
61   mapping(address => uint) balances;
62 
63   /**
64    * @dev Fix for the ERC20 short address attack.
65    */
66   modifier onlyPayloadSize(uint size) {
67      if(msg.data.length < size + 4) {
68        revert();
69      }
70      _;
71   }
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool){
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82 	
83 	return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of. 
89   * @return An uint representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) constant returns (uint balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 contract ERC20 is ERC20Basic {
98   function allowance(address _owner, address _spender) constant returns (uint remaining);
99   function transferFrom(address _from, address _to, uint _value) returns (bool success);
100   function approve(address _spender, uint _value) returns (bool success);
101   event Approval(address indexed _owner, address indexed _spender, uint _value);
102 }
103 
104 
105 contract StandardToken is BasicToken, ERC20 {
106 
107   mapping (address => mapping (address => uint)) allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint the amout of tokens to be transfered
115    */
116   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool){
117     var _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // if (_value > _allowance) throw;
121 
122     balances[_to] = balances[_to].add(_value);
123     balances[_from] = balances[_from].sub(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126 	
127 	return true;
128   }
129 
130   /**
131    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint _value) returns (bool){
136 
137     // To change the approve amount you first have to reduce the addresses`
138     //  allowance to zero by calling `approve(_spender, 0)` if it is not
139     //  already 0 to mitigate the race condition described here:
140     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
142 
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145 	
146 	return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens than an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint specifing the amount of tokens still avaible for the spender.
154    */
155   function allowance(address _owner, address _spender) constant returns (uint remaining) {
156     return allowed[_owner][_spender];
157   }
158 
159 }
160 
161 contract DTOToken is StandardToken {
162     string public constant name = "DTOCoin";
163     string public constant symbol = "DTO";
164     uint public constant decimals = 18;
165 
166     // Note: this will be initialized during the contract deployment.
167     address public target;    
168 
169     /**
170      * CONSTRUCTOR 
171      * 
172      * @dev Initialize the DTO Token
173      */
174     function DTOToken(address _target) {
175         target = _target;
176         totalSupply = 10 ** 27;
177         balances[target] = totalSupply;
178     }   
179 }