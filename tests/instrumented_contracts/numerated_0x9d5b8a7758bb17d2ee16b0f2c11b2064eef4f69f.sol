1 pragma solidity ^0.4.18;
2  
3 /* 0X444
4  */
5 contract ERC20Basic {
6   uint256 public totalSupply;
7   function balanceOf(address who) constant returns (uint256);
8   function transfer(address to, uint256 value) returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11  
12 /*
13    ERC20 interface
14   
15  */
16 contract ERC20 is ERC20Basic {
17   function allowance(address owner, address spender) constant returns (uint256);
18   function transferFrom(address from, address to, uint256 value) returns (bool);
19   function approve(address spender, uint256 value) returns (bool);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22  
23 /*  SafeMath - the lowest gas library
24   Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27     
28   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33  
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40  
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45  
46   function add(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51   
52 }
53  
54 /*
55 Basic token
56  Basic version of StandardToken, with no allowances. 
57  */
58 contract BasicToken is ERC20Basic {
59     
60   using SafeMath for uint256;
61  
62   mapping(address => uint256) balances;
63  
64  function transfer(address _to, uint256 _value) returns (bool) {
65     balances[msg.sender] = balances[msg.sender].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     Transfer(msg.sender, _to, _value);
68     return true;
69   }
70  
71   /*
72   Gets the balance of the specified address.
73    param _owner The address to query the the balance of. 
74    return An uint256 representing the amount owned by the passed address.
75   */
76   function balanceOf(address _owner) constant returns (uint256 balance) {
77     return balances[_owner];
78   }
79  
80 }
81  
82 /* Implementation of the basic standard token.
83   https://github.com/ethereum/EIPs/issues/20
84  */
85 contract StandardToken is ERC20, BasicToken {
86  
87   mapping (address => mapping (address => uint256)) allowed;
88  
89   /*
90     Transfer tokens from one address to another
91     param _from address The address which you want to send tokens from
92     param _to address The address which you want to transfer to
93     param _value uint256 the amout of tokens to be transfered
94    */
95   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
96     var _allowance = allowed[_from][msg.sender];
97  
98     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
99     // require (_value <= _allowance);
100  
101     balances[_to] = balances[_to].add(_value);
102     balances[_from] = balances[_from].sub(_value);
103     allowed[_from][msg.sender] = _allowance.sub(_value);
104     Transfer(_from, _to, _value);
105     return true;
106   }
107  
108   /*
109   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
110    param _spender The address which will spend the funds.
111    param _value The amount of Roman Lanskoj's tokens to be spent.
112    */
113   function approve(address _spender, uint256 _value) returns (bool) {
114  
115     // To change the approve amount you first have to reduce the addresses`
116     //  allowance to zero by calling `approve(_spender, 0)` if it is not
117     //  already 0 to mitigate the race condition described here:
118     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
120  
121     allowed[msg.sender][_spender] = _value;
122     Approval(msg.sender, _spender, _value);
123     return true;
124   }
125  
126   /*
127   Function to check the amount of tokens that an owner allowed to a spender.
128   param _owner address The address which owns the funds.
129   param _spender address The address which will spend the funds.
130   return A uint256 specifing the amount of tokens still available for the spender.
131    */
132   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
133     return allowed[_owner][_spender];
134   }
135  
136 }
137  
138 /*
139 The Ownable contract has an owner address, and provides basic authorization control
140  functions, this simplifies the implementation of "user permissions".
141  */
142 contract Ownable {
143     
144   address public owner;
145  
146  
147   function Ownable() {
148     owner = msg.sender;
149   }
150  
151   /*
152   Throws if called by any account other than the owner.
153    */
154   modifier onlyOwner() {
155     require(msg.sender == owner);
156     _;
157   }
158  
159   /*
160   Allows the current owner to transfer control of the contract to a newOwner.
161   param newOwner The address to transfer ownership to.
162    */
163   function transferOwnership(address newOwner) onlyOwner {
164     require(newOwner != address(0));      
165     owner = newOwner;
166   }
167  
168 }
169  
170 contract TheLiquidToken is StandardToken, Ownable {
171     // mint can be finished and token become fixed for forever
172   event Mint(address indexed to, uint256 amount);
173   event MintFinished();
174   bool public mintingFinished = false;
175   modifier canMint() {
176     require(!mintingFinished);
177     _;
178   }
179  
180  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
181     totalSupply = totalSupply.add(_amount);
182     balances[_to] = balances[_to].add(_amount);
183     Mint(_to, _amount);
184     return true;
185   }
186  
187   /*
188   Function to stop minting new tokens.
189   return True if the operation was successful.
190    */
191   function finishMinting() onlyOwner returns (bool) {
192     mintingFinished = true;
193     MintFinished();
194     return true;
195   }
196   
197 }
198     
199 contract EXHO is TheLiquidToken {
200   string public constant name = "EXHO Coin";
201       string public constant symbol = "EXHO";
202   uint public constant decimals = 18;
203   uint256 public initialSupply = 100000000000000000000000000000;
204     
205   // Constructor
206   function EXHO () { 
207      totalSupply = 100000000000000000000000000000;
208       balances[msg.sender] = totalSupply;
209       initialSupply = totalSupply; 
210         Transfer(0, this, totalSupply);
211         Transfer(this, msg.sender, totalSupply);
212   }
213 }