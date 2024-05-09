1 // Xryptos Token source code
2 // Visit us at www.xryptos.io
3 
4 pragma solidity ^0.4.19;
5 
6 /**
7  * Math operations with safety checks
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 contract Ownable {
37   address public owner;
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   function Ownable() {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     if (newOwner != address(0)) {
64       owner = newOwner;
65     }
66   }
67 
68 }
69 
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20Basic {
77   uint public totalSupply;
78   function balanceOf(address who) constant returns (uint);
79   function transfer(address to, uint value);
80   event Transfer(address indexed from, address indexed to, uint value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) constant returns (uint);
89   function transferFrom(address from, address to, uint value);
90   function approve(address spender, uint value);
91   event Approval(address indexed owner, address indexed spender, uint value);
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint;
100 
101   mapping(address => uint) balances;
102 
103   /**
104    * @dev Fix for the ERC20 short address attack.
105    */
106   modifier onlyPayloadSize(uint size) {
107      if(msg.data.length < size + 4) {
108        throw;
109      }
110      _;
111   }
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) constant returns (uint balance) {
130     return balances[_owner];
131   }
132 
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implemantation of the basic standart token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is BasicToken, ERC20 {
143 
144   mapping (address => mapping (address => uint)) allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint the amout of tokens to be transfered
152    */
153   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
154     var _allowance = allowed[_from][msg.sender];
155 
156     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
157     // if (_value > _allowance) throw;
158 
159     balances[_to] = balances[_to].add(_value);
160     balances[_from] = balances[_from].sub(_value);
161     allowed[_from][msg.sender] = _allowance.sub(_value);
162     Transfer(_from, _to, _value);
163   }
164 
165   /**
166    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint _value) {
171 
172     // To change the approve amount you first have to reduce the addresses`
173     //  allowance to zero by calling `approve(_spender, 0)` if it is not
174     //  already 0 to mitigate the race condition described here:
175     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
177 
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens than an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint specifing the amount of tokens still avaible for the spender.
187    */
188   function allowance(address _owner, address _spender) constant returns (uint remaining) {
189     return allowed[_owner][_spender];
190   }
191 
192 }
193 
194 /**
195  * @title Xryptos Token
196  * Visit us at www.xryptos.io
197  * @dev Implementation of the Xryptos token using ERC20 Standard
198  */
199 contract Xryptos is StandardToken, Ownable{
200 
201     string public constant name = "Xryptos";
202     string public constant symbol = "XRS";
203     uint public constant decimals = 8;
204     uint public INITIAL_SUPPLY = 10000000000000000; // Initial supply is 100,000,000 XRS
205 
206     function Xryptos() {
207         totalSupply = INITIAL_SUPPLY;
208         balances[msg.sender] = INITIAL_SUPPLY;
209     }
210 }