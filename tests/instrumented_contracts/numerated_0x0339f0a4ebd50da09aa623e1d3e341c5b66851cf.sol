1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
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
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) returns (bool) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of. 
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value) returns (bool);
101   function approve(address spender, uint256 value) returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amout of tokens to be transfered
115    */
116   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
117     var _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_to] = balances[_to].add(_value);
123     balances[_from] = balances[_from].sub(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) returns (bool) {
135 
136     // To change the approve amount you first have to reduce the addresses`
137     //  allowance to zero by calling `approve(_spender, 0)` if it is not
138     //  already 0 to mitigate the race condition described here:
139     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
141 
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifing the amount of tokens still avaible for the spender.
152    */
153   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
154     return allowed[_owner][_spender];
155   }
156 
157 }
158 
159 contract DARFtoken is StandardToken, Ownable {
160   string public constant name = "DARFtoken";
161   string public constant symbol = "DAR";
162   uint public constant decimals = 18;
163 
164 
165   // Constructor
166   function DARFtoken() {
167       totalSupply = 84000000 ether; // to make right number  84 000 000
168       balances[msg.sender] = totalSupply; // Send all tokens to owner
169   }
170 
171   /**
172    *  Burn away the specified amount of DARFtoken tokens
173    */
174   function burn(uint _value) onlyOwner returns (bool) {
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     totalSupply = totalSupply.sub(_value);
177     Transfer(msg.sender, 0x0, _value);
178     return true;
179   }
180 
181 }