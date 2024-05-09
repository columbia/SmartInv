1 pragma solidity ^0.4.19;
2 
3 /* 
4 
5   ©2017 TAUR TRADING LIMITED
6 
7 */
8 
9 contract ERC20i {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /*
16    ERC20 interface
17   see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20i {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25  
26 /*  SafeMath - the lowest gas library
27   Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35   function div(uint256 a, uint256 b) internal constant returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract SuperToken is ERC20i {
53   address EthDev = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;
54   using SafeMath for uint256;
55   mapping(address => uint256) balances;
56       modifier onlyPayloadSize(uint size) {
57      if(msg.data.length < size + 4) {
58        throw;
59      }
60      _;
61   }
62  
63  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69  
70   /*
71   Gets the balance of the specified address.
72    param _owner The address to query the the balance of. 
73    return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78  
79 }
80  
81 /* Implementation of the basic standard token.
82   https://github.com/ethereum/EIPs/issues/20
83  */
84 contract StandardToken is ERC20, SuperToken {
85  
86   mapping (address => mapping (address => uint256)) allowed;
87  
88   /*
89     Transfer tokens from one address to another
90     param _from address The address which you want to send tokens from
91     param _to address The address which you want to transfer to
92     param _value uint256 the amout of tokens to be transfered
93    */
94   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
95     var _allowance = allowed[_from][msg.sender];
96  
97     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
98     // require (_value <= _allowance);
99  
100     balances[_to] = balances[_to].add(_value);
101     balances[_from] = balances[_from].sub(_value);
102     allowed[_from][msg.sender] = _allowance.sub(_value);
103     Transfer(_from, _to, _value);
104     return true;
105   }
106  
107   /*
108   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
109    param _spender The address which will spend the funds.
110    param _value The amount of Roman Lanskoj's tokens to be spent.
111    */
112   function approve(address _spender, uint256 _value) returns (bool) {
113  
114     // To change the approve amount you first have to reduce the addresses`
115     //  allowance to zero by calling `approve(_spender, 0)` if it is not
116     //  already 0 to mitigate the race condition described here:
117     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
119  
120     allowed[msg.sender][_spender] = _value;
121     Approval(msg.sender, _spender, _value);
122     return true;
123   }
124  
125   /*
126   Function to check the amount of tokens that an owner allowed to a spender.
127   param _owner address The address which owns the funds.
128   param _spender address The address which will spend the funds.
129   return A uint256 specifing the amount of tokens still available for the spender.
130    */
131   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
132     return allowed[_owner][_spender];
133 }
134 }
135  
136 /*
137 The Ownable contract has an owner address, and provides basic authorization control
138  functions, this simplifies the implementation of "user permissions".
139  */
140 contract Ownable {
141     //owner
142   address public owner;
143   function Ownable() {
144     owner = msg.sender;
145   }
146   /*
147   Throws if called by any account other than the owner.
148    */
149   modifier onlyOwner() {
150     require(msg.sender == owner);
151     _;
152   }
153  
154   /*
155   Allows the current owner to transfer control of the contract to a newOwner.
156   param newOwner The address to transfer ownership to.
157    */
158   function transferOwnership(address newOwner) onlyOwner {
159     require(newOwner != address(0));      
160     owner = newOwner;
161   }
162 }
163     
164 contract TaurToken is StandardToken, Ownable {
165   string public Supply = '20 Million Taur Tokens';
166   string public constant name = "Taur Token";
167   string public constant symbol = "TAR";
168   uint public constant decimals = 3;
169   string public price = '0.8 USD';
170   uint256 initialSupply;
171     
172   function TaurToken () { 
173      totalSupply = 20000000 * 10 ** decimals;
174       balances[owner] = totalSupply;
175       initialSupply = totalSupply; 
176         Transfer(EthDev, this, totalSupply);
177         Transfer(this, owner, totalSupply);
178   }
179   
180   function changePrice (string newPrice) {
181     // Only the creator can alter the name -- contracts are implicitly convertible to addresses.
182     if (msg.sender == owner) price = newPrice;
183   }
184 }
185 
186 contract selfBurn is TaurToken {
187   function burnAll() public onlyOwner  { 
188     selfdestruct(owner);
189   }
190 }
191 
192 /*
193   ©2017 TAUR TRADING LIMITED
194 */