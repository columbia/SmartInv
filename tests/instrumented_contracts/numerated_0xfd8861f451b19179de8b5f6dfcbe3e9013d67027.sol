1 pragma solidity ^0.4.18;
2  
3 /*
4    Ⓒ2017 Invacio Coin
5 
6 Invacio Coin [INV] is a Cryptocurrency (private digital currency), that has a value based on the current market.
7 
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15  
16 /*
17    ERC20 interface
18   see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26  
27 /*  SafeMath - the lowest gas library
28   Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37  
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44  
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49  
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57  
58 /*
59 Basic token
60  Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65  
66   mapping(address => uint256) balances;
67       modifier onlyPayloadSize(uint size) {
68      if(msg.data.length < size + 4) {
69        throw;
70      }
71      _;
72   }
73  
74  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80  
81   /*
82   Gets the balance of the specified address.
83    param _owner The address to query the the balance of. 
84    return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89  
90 }
91  
92 /* Implementation of the basic standard token.
93   https://github.com/ethereum/EIPs/issues/20
94  */
95 contract StandardToken is ERC20, BasicToken {
96  
97   mapping (address => mapping (address => uint256)) allowed;
98  
99   /*
100     Transfer tokens from one address to another
101     param _from address The address which you want to send tokens from
102     param _to address The address which you want to transfer to
103     param _value uint256 the amout of tokens to be transfered
104    */
105   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
106     var _allowance = allowed[_from][msg.sender];
107  
108     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109     // require (_value <= _allowance);
110  
111     balances[_to] = balances[_to].add(_value);
112     balances[_from] = balances[_from].sub(_value);
113     allowed[_from][msg.sender] = _allowance.sub(_value);
114     Transfer(_from, _to, _value);
115     return true;
116   }
117  
118   /*
119   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    param _spender The address which will spend the funds.
121    param _value The amount of Roman Lanskoj's tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) returns (bool) {
124  
125     // To change the approve amount you first have to reduce the addresses`
126     //  allowance to zero by calling `approve(_spender, 0)` if it is not
127     //  already 0 to mitigate the race condition described here:
128     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
130  
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135  
136   /*
137   Function to check the amount of tokens that an owner allowed to a spender.
138   param _owner address The address which owns the funds.
139   param _spender address The address which will spend the funds.
140   return A uint256 specifing the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
143     return allowed[_owner][_spender];
144 }
145 }
146  
147 /*
148 The Ownable contract has an owner address, and provides basic authorization control
149  functions, this simplifies the implementation of "user permissions".
150  */
151 contract Ownable {
152     
153   address public owner;
154  
155   function Ownable() {
156     owner = 0x5eD4EC6e970222997D850C82543E30C9291c1065;
157   }
158  
159   /*
160   Throws if called by any account other than the owner.
161    */
162   modifier onlyOwner() {
163     require(msg.sender == owner);
164     _;
165   }
166  
167   /*
168   Allows the current owner to transfer control of the contract to a newOwner.
169   param newOwner The address to transfer ownership to.
170    */
171   function transferOwnership(address newOwner) onlyOwner {
172     require(newOwner != address(0));      
173     owner = newOwner;
174   }
175  
176 }
177     
178 contract Invacio is StandardToken, Ownable {
179   string public constant name = "Invacio Coin";
180   string public constant symbol = "INV";
181   uint public constant decimals = 8;
182   uint256 public initialSupply;
183     
184   function Invacio () { 
185      totalSupply = 450000000 * 10 ** decimals;
186       balances[0x5eD4EC6e970222997D850C82543E30C9291c1065] = totalSupply;
187       initialSupply = totalSupply; 
188         Transfer(0, this, totalSupply);
189         Transfer(this, 0x5eD4EC6e970222997D850C82543E30C9291c1065, totalSupply);
190   }
191 }