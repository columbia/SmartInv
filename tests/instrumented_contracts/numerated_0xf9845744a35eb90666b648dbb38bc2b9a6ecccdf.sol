1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 x, uint256 y) internal constant returns (uint256) {
5     uint256 z = x * y;
6     assert((x == 0) || (z / x == y));
7     return z;
8   }
9   
10   function div(uint256 x, uint256 y) internal constant returns (uint256) {
11     // assert(y > 0); // Solidity automatically throws when dividing by 0
12     uint256 z = x / y;
13     // assert(x == y * z + x % y); // There is no case in which this doesn't hold
14     return z;
15   }
16   
17   function sub(uint256 x, uint256 y) internal constant returns (uint256) {
18     assert(y <= x);
19     return x - y;
20   }
21   
22   function add(uint256 x, uint256 y) internal constant returns (uint256) {
23     uint256 z = x + y;
24     assert((z >= x) && (z >= y));
25     return z;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant returns (uint256);
67   function transfer(address to, uint256 value) returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint256);
73   function transferFrom(address from, address to, uint256 value) returns (bool);
74   function approve(address spender, uint256 value) returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) returns (bool) {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amout of tokens to be transfered
116    */
117   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
118     var _allowance = allowed[_from][msg.sender];
119 
120     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
121     // require (_value <= _allowance);
122 
123     balances[_to] = balances[_to].add(_value);
124     balances[_from] = balances[_from].sub(_value);
125     allowed[_from][msg.sender] = _allowance.sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) returns (bool) {
136 
137     // To change the approve amount you first have to reduce the addresses`
138     //  allowance to zero by calling `approve(_spender, 0)` if it is not
139     //  already 0 to mitigate the race condition described here:
140     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
142 
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifing the amount of tokens still avaible for the spender.
153    */
154   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 contract BaFa is StandardToken, Ownable {
161     string public constant name = "BaFa";
162     string public constant symbol = "BAFA";
163     uint8 public constant decimals = 8;
164     uint256 public constant INITIAL_SUPPLY = 8888800000000;
165    function BaFa() {
166       totalSupply = INITIAL_SUPPLY;
167       balances[msg.sender] = INITIAL_SUPPLY;
168       owner = msg.sender;
169   }
170 }