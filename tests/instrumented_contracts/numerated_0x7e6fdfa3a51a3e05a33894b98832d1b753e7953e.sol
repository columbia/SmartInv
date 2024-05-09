1 pragma solidity ^0.4.24;
2  
3 /* Roman Lanskoj  
4    Limited/unlimited coin contract
5     Simpler version of ERC20 interface
6     see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14  
15 /*
16    ERC20 interface
17   see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
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
30     
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36  
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43  
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48  
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54   
55 }
56  
57 /*
58 Basic token
59  Basic version of StandardToken, with no allowances. 
60  */
61 contract BasicToken is ERC20Basic {
62     
63   using SafeMath for uint256;
64  
65   mapping(address => uint256) balances;
66  
67  function transfer(address _to, uint256 _value) returns (bool) {
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73  
74   /*
75   Gets the balance of the specified address.
76    param _owner The address to query the the balance of. 
77    return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82  
83 }
84  
85 /* Implementation of the basic standard token.
86   https://github.com/ethereum/EIPs/issues/20
87  */
88 contract StandardToken is ERC20, BasicToken {
89  
90   mapping (address => mapping (address => uint256)) allowed;
91  
92   /*
93     Transfer tokens from one address to another
94     param _from address The address which you want to send tokens from
95     param _to address The address which you want to transfer to
96     param _value uint256 the amout of tokens to be transfered
97    */
98   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
99     var _allowance = allowed[_from][msg.sender];
100  
101     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102     // require (_value <= _allowance);
103  
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110  
111   /*
112   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    param _spender The address which will spend the funds.
114    param _value The amount of Roman Lanskoj's tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) returns (bool) {
117  
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition described here:
121     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
123  
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128  
129   /*
130   Function to check the amount of tokens that an owner allowed to a spender.
131   param _owner address The address which owns the funds.
132   param _spender address The address which will spend the funds.
133   return A uint256 specifing the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137   }
138  
139 }
140  
141 /*
142 The Ownable contract has an owner address, and provides basic authorization control
143  functions, this simplifies the implementation of "user permissions".
144  */
145 contract Ownable {
146     
147   address public owner;
148  
149  
150   function Ownable() {
151     owner = msg.sender;
152   }
153  
154   /*
155   Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161  
162   /*
163   Allows the current owner to transfer control of the contract to a newOwner.
164   param newOwner The address to transfer ownership to.
165    */
166   function transferOwnership(address newOwner) onlyOwner {
167     require(newOwner != address(0));      
168     owner = newOwner;
169   }
170  
171 }
172  
173 contract TheLiquidToken is StandardToken, Ownable {
174     // mint can be finished and token become fixed for forever
175   event Mint(address indexed to, uint256 amount);
176   event MintFinished();
177   bool public mintingFinished = false;
178   modifier canMint() {
179     require(!mintingFinished);
180     _;
181   }
182  
183  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
184     totalSupply = totalSupply.add(_amount);
185     balances[_to] = balances[_to].add(_amount);
186     Mint(_to, _amount);
187     return true;
188   }
189  
190   /*
191   Function to stop minting new tokens.
192   return True if the operation was successful.
193    */
194   function finishMinting() onlyOwner returns (bool) {
195     mintingFinished = true;
196     MintFinished();
197     return true;
198   }
199   
200 }
201     
202 contract ITIX is TheLiquidToken {
203   string public constant name = "iTicket";
204       string public constant symbol = "ITIX";
205   uint public constant decimals = 0;
206   uint256 public initialSupply = 100000000;
207     
208   // Constructor
209   function ITIX () { 
210      totalSupply = 100000000;
211       balances[msg.sender] = totalSupply;
212       initialSupply = totalSupply; 
213         Transfer(0, this, totalSupply);
214         Transfer(this, msg.sender, totalSupply);
215   }
216 }