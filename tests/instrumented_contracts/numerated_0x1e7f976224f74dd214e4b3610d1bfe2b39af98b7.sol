1 pragma solidity ^0.4.18;
2  
3 /*
4   Etherniton
5  ERCO20 TOKEN which will give you 4 ways to earn Stake, Trade, Mine and Lending
6 
7  Ⓒ  ENN FIRST
8    2017
9 */
10 
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) constant returns (uint256);
14   function transfer(address to, uint256 value) returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17  
18 /*
19    ERC20 interface
20   see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) constant returns (uint256);
24   function transferFrom(address from, address to, uint256 value) returns (bool);
25   function approve(address spender, uint256 value) returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28  
29 /*  SafeMath - the lowest gas library
30   Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33     
34   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39  
40   function div(uint256 a, uint256 b) internal constant returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46  
47   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51  
52   function add(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57   
58 }
59  
60 /*
61 Basic token
62  Basic version of StandardToken, with no allowances. 
63  */
64 contract BasicToken is ERC20Basic {
65     
66   using SafeMath for uint256;
67  
68   mapping(address => uint256) balances;
69   
70    modifier onlyPayloadSize(uint size) {
71      if(msg.data.length < size + 4) {
72        throw;
73      }
74      _;
75   }
76  
77  function transfer(address _to, uint256 _value) returns (bool) {
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83  
84   /*
85   Gets the balance of the specified address.
86    param _owner The address to query the the balance of. 
87    return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92  
93 }
94  
95 /* Implementation of the basic standard token.
96   https://github.com/ethereum/EIPs/issues/20
97  */
98 contract StandardToken is ERC20, BasicToken {
99  
100   mapping (address => mapping (address => uint256)) allowed;
101  
102   /*
103     Transfer tokens from one address to another
104     param _from address The address which you want to send tokens from
105     param _to address The address which you want to transfer to
106     param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110  
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113  
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120  
121   /*
122   Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    param _spender The address which will spend the funds.
124    param _value The amount of Roman Lanskoj's tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127  
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133  
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138  
139   /*
140   Function to check the amount of tokens that an owner allowed to a spender.
141   param _owner address The address which owns the funds.
142   param _spender address The address which will spend the funds.
143   return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147 }
148 }
149  
150 /*
151 The Ownable contract has an owner address, and provides basic authorization control
152  functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155     
156   address public owner;
157  
158  
159   function Ownable() {
160     owner = 0xD1bF6f9AA810fB2a58798984371486F60636EC67;
161   }
162  
163   /*
164   Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(0xD1bF6f9AA810fB2a58798984371486F60636EC67 == owner);
168     _;
169   }
170  
171   /*
172   Allows the current owner to transfer control of the contract to a newOwner.
173   param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) onlyOwner {
176     require(newOwner != address(0));      
177     owner = newOwner;
178   }
179  
180 }
181  
182 contract TheLiquidToken is StandardToken, Ownable {
183     // mint can be finished and token become fixed for forever
184   event Mint(address indexed to, uint256 amount);
185   event MintFinished();
186   bool mintingFinished = false;
187   modifier canMint() {
188     require(!mintingFinished);
189     _;
190   }
191  
192  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
193     totalSupply = totalSupply.add(_amount);
194     balances[_to] = balances[_to].add(_amount);
195     Mint(_to, _amount);
196     return true;
197   }
198  
199   /*
200   Function to stop minting new tokens.
201   return True if the operation was successful.
202    */
203   function finishMinting() onlyOwner returns (bool) {}
204   
205   function burn(uint _value)
206         public
207     {
208         require(_value > 0);
209 
210         address burner = msg.sender;
211         balances[burner] = balances[burner].sub(_value);
212         totalSupply = totalSupply.sub(_value);
213         Burn(burner, _value);
214     }
215 
216     event Burn(address indexed burner, uint indexed value);
217   
218 }
219     
220 contract Etherniton is TheLiquidToken {
221   string public constant name = "Etherniton";
222   string public constant symbol = "ENN";
223   uint public constant decimals = 8;
224   uint256 public initialSupply;
225     
226   function Etherniton () { 
227      totalSupply = 180010000 * 10 ** decimals;
228       balances[0xD1bF6f9AA810fB2a58798984371486F60636EC67] = totalSupply;
229       initialSupply = totalSupply; 
230         Transfer(0, this, totalSupply);
231         Transfer(this, 0xD1bF6f9AA810fB2a58798984371486F60636EC67, totalSupply);
232   }
233 }
234 
235 
236 /*
237 Etherniton
238 ERCO20 TOKEN which will give you 4 ways to earn Stake, Trade, Mine and Lending
239  Ⓒ  ENN FIRST
240    2017
241 */