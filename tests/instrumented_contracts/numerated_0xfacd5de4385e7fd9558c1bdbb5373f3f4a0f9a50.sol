1 pragma solidity ^0.4.16;
2  
3 /* 
4    Blockchain Forest Ltd
5 Blockchain DAPP . Decentralized Token Private Placement Programme (DTPPP) . Environmental Digital Assets . 
6 Fintech Facilitation Office:
7 CoPlace 1, 2270 Jalan Usahawan 2, Cyber 6, 63000 Cyberjaya. West Malaysia
8 Support Line: +603.9212.6666
9 dapp@blockchainforest.io
10 
11 Malaysia . Hong Kong . Amsterdam . UK.  China
12 
13 #treetoken
14  */
15 contract ERC20Basic {
16   uint256 public totalSupply;
17   function balanceOf(address who) constant returns (uint256);
18   function transfer(address to, uint256 value) returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21  
22 /*
23    ERC20 interface
24   see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address owner, address spender) constant returns (uint256);
28   function transferFrom(address from, address to, uint256 value) returns (bool);
29   function approve(address spender, uint256 value) returns (bool);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32  
33 /*  SafeMath - the lowest gas library
34   Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37     
38   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43  
44   function div(uint256 a, uint256 b) internal constant returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50  
51   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55  
56   function add(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61   
62 }
63  
64 /*
65 Basic token
66  Basic version of StandardToken, with no allowances. 
67  */
68 contract BasicToken is ERC20Basic {
69     
70   using SafeMath for uint256;
71  
72   mapping(address => uint256) balances;
73  
74  function transfer(address _to, uint256 _value) returns (bool) {
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
155  
156   function Ownable() {
157     owner = msg.sender;
158   }
159  
160   /*
161   Throws if called by any account other than the owner.
162    */
163   modifier onlyOwner() {
164     require(msg.sender == owner);
165     _;
166   }
167  
168   /*
169   Allows the current owner to transfer control of the contract to a newOwner.
170   param newOwner The address to transfer ownership to.
171    */
172   function transferOwnership(address newOwner) onlyOwner {
173     require(newOwner != address(0));      
174     owner = newOwner;
175   }
176  
177 }
178  
179 contract TheLiquidToken is StandardToken, Ownable {
180     // mint can be finished and token become fixed for forever
181   event Mint(address indexed to, uint256 amount);
182   event MintFinished();
183   bool mintingFinished = false;
184   modifier canMint() {
185     require(!mintingFinished);
186     _;
187   }
188  
189  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
190     totalSupply = totalSupply.add(_amount);
191     balances[_to] = balances[_to].add(_amount);
192     Mint(_to, _amount);
193     return true;
194   }
195  
196   /*
197   Function to stop minting new tokens.
198   return True if the operation was successful.
199    */
200   function finishMinting() onlyOwner returns (bool) {}
201   
202 }
203     
204 contract TREETOKEN is TheLiquidToken {
205   string public constant name = "TREE TOKEN";
206   string public constant symbol = "TREE";
207   uint public constant decimals = 2;
208   uint256 public initialSupply;
209     
210   function TREETOKEN () { 
211      totalSupply = 300000000 * 10 ** decimals;
212       balances[msg.sender] = totalSupply;
213       initialSupply = totalSupply; 
214         Transfer(0, this, totalSupply);
215         Transfer(this, msg.sender, totalSupply);
216   }
217 }