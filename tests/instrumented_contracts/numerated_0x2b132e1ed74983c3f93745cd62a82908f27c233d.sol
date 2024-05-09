1 pragma solidity ^0.4.19;
2 
3 // Created by your Messiah, you are just little multimedia goats
4 
5 contract ERC20i {
6   uint256 public totalSupply;
7   function balanceOf(address who) constant returns (uint256);
8   function transfer(address to, uint256 value) returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 /*
12    ERC20 interface
13   see https://github.com/ethereum/EIPs/issues/20
14  */
15 contract ERC20 is ERC20i {
16   function allowance(address owner, address spender) constant returns (uint256);
17   function transferFrom(address from, address to, uint256 value) returns (bool);
18   function approve(address spender, uint256 value) returns (bool);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21  
22 /*  SafeMath - the lowest gas library
23   Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract SuperToken is ERC20i {
49   address public EthDev = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;
50   using SafeMath for uint256;
51   mapping(address => uint256) balances;
52       modifier onlyPayloadSize(uint size) {
53      if(msg.data.length < size + 4) {
54        throw;
55      }
56      _;
57   }
58  
59  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65  
66   /*
67   Gets the balance of the specified address.
68    param _owner The address to query the the balance of. 
69    return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74  
75 }
76  
77 /* Implementation of the basic standard token.
78   https://github.com/ethereum/EIPs/issues/20
79  */
80 contract StandardToken is ERC20, SuperToken {
81  
82   mapping (address => mapping (address => uint256)) allowed;
83  
84   /*
85     Transfer tokens from one address to another
86     param _from address The address which you want to send tokens from
87     param _to address The address which you want to transfer to
88     param _value uint256 the amout of tokens to be transfered
89    */
90   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
91     var _allowance = allowed[_from][msg.sender];
92  
93     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
94     // require (_value <= _allowance);
95  
96     balances[_to] = balances[_to].add(_value);
97     balances[_from] = balances[_from].sub(_value);
98     allowed[_from][msg.sender] = _allowance.sub(_value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102  
103   /*
104   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    param _spender The address which will spend the funds.
106    param _value The amount of Roman Lanskoj's tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) returns (bool) {
109  
110     // To change the approve amount you first have to reduce the addresses`
111     //  allowance to zero by calling `approve(_spender, 0)` if it is not
112     //  already 0 to mitigate the race condition described here:
113     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
115  
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120  
121   /*
122   Function to check the amount of tokens that an owner allowed to a spender.
123   param _owner address The address which owns the funds.
124   param _spender address The address which will spend the funds.
125   return A uint256 specifing the amount of tokens still available for the spender.
126    */
127   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128     return allowed[_owner][_spender];
129 }
130 }
131  
132 /*
133 The Ownable contract has an owner address, and provides basic authorization control
134  functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137     //owner
138   address public owner;
139   function Ownable() {
140     owner = 0x66C2E6dd4B83CA376EFA05809Ae8e0C26911f46B;
141   }
142   /*
143   Throws if called by any account other than the owner.
144    */
145   modifier onlyOwner() {
146     require(msg.sender == owner);
147     _;
148   }
149  
150   /*
151   Allows the current owner to transfer control of the contract to a newOwner.
152   param newOwner The address to transfer ownership to.
153    */
154   function transferOwnership(address newOwner) onlyOwner {
155     require(newOwner != address(0));      
156     owner = newOwner;
157   }
158 }
159     
160 contract MARIADARIO is StandardToken, Ownable {
161   string public constant name = "MARIADARIO";
162   string public constant symbol = "MARIADARIO";
163   uint public constant decimals = 0;
164    string public description = 'From Mt Aragona with love';
165   uint256 public initialSupply;
166   string public Supply = '100 mil';
167     
168   function MARIADARIO () { 
169      totalSupply = 100000000 * 10 ** decimals;
170       balances[owner] = totalSupply;
171       initialSupply = totalSupply; 
172         Transfer(EthDev, this, totalSupply);
173         Transfer(this, owner, totalSupply);
174   }
175 }
176 
177 
178 /*
179   2017  MARIADARIO
180  */