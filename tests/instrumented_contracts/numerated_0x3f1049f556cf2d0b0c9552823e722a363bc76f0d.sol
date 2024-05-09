1 pragma solidity ^0.4.19;
2 
3 contract ERC20i {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 /*
10    ERC20 interface
11   see https://github.com/ethereum/EIPs/issues/20
12  */
13 contract ERC20 is ERC20i {
14   function allowance(address owner, address spender) constant returns (uint256);
15   function transferFrom(address from, address to, uint256 value) returns (bool);
16   function approve(address spender, uint256 value) returns (bool);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19  
20 /*  SafeMath - the lowest gas library
21   Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract SuperToken is ERC20i {
47   address EthDev = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;
48   using SafeMath for uint256;
49   mapping(address => uint256) balances;
50       modifier onlyPayloadSize(uint size) {
51      if(msg.data.length < size + 4) {
52        throw;
53      }
54      _;
55   }
56  
57  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63  
64   /*
65   Gets the balance of the specified address.
66    param _owner The address to query the the balance of. 
67    return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72  
73 }
74  
75 /* Implementation of the basic standard token.
76   https://github.com/ethereum/EIPs/issues/20
77  */
78 contract StandardToken is ERC20, SuperToken {
79  
80   mapping (address => mapping (address => uint256)) allowed;
81  
82   /*
83     Transfer tokens from one address to another
84     param _from address The address which you want to send tokens from
85     param _to address The address which you want to transfer to
86     param _value uint256 the amout of tokens to be transfered
87    */
88   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
89     var _allowance = allowed[_from][msg.sender];
90  
91     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
92     // require (_value <= _allowance);
93  
94     balances[_to] = balances[_to].add(_value);
95     balances[_from] = balances[_from].sub(_value);
96     allowed[_from][msg.sender] = _allowance.sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100  
101   /*
102   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    param _spender The address which will spend the funds.
104    param _value The amount of Roman Lanskoj's tokens to be spent.
105    */
106   function approve(address _spender, uint256 _value) returns (bool) {
107  
108     // To change the approve amount you first have to reduce the addresses`
109     //  allowance to zero by calling `approve(_spender, 0)` if it is not
110     //  already 0 to mitigate the race condition described here:
111     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
113  
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116     return true;
117   }
118  
119   /*
120   Function to check the amount of tokens that an owner allowed to a spender.
121   param _owner address The address which owns the funds.
122   param _spender address The address which will spend the funds.
123   return A uint256 specifing the amount of tokens still available for the spender.
124    */
125   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
126     return allowed[_owner][_spender];
127 }
128 }
129  
130 /*
131 The Ownable contract has an owner address, and provides basic authorization control
132  functions, this simplifies the implementation of "user permissions".
133  */
134 contract Ownable {
135     //owner
136   address public owner;
137   function Ownable() {
138     owner = 0x66C2E6dd4B83CA376EFA05809Ae8e0C26911f46B;
139   }
140   /*
141   Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147  
148   /*
149   Allows the current owner to transfer control of the contract to a newOwner.
150   param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner {
153     require(newOwner != address(0));      
154     owner = newOwner;
155   }
156 }
157     
158 contract OBOCOIN is StandardToken, Ownable {
159   string public constant name = "OBOCOIN";
160   string public constant symbol = "OBO";
161   uint public constant decimals = 0;
162    string public description = 'From Mt Aragona with love';
163   uint256 public initialSupply;
164   string public Supply = '100 Millions';
165     
166   function OBOCOIN () { 
167      totalSupply = 100000000 * 10 ** decimals;
168       balances[owner] = totalSupply;
169       initialSupply = totalSupply; 
170         Transfer(EthDev, this, totalSupply);
171         Transfer(this, owner, totalSupply);
172   }
173 }
174 
175 
176 /*
177   2017  OBOCOIN
178  */