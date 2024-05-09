1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract Ownable {
44     address public owner;
45     function Ownable() {
46         owner = msg.sender;
47     }
48     modifier onlyOwner {
49         if (msg.sender != owner) throw;
50         _;
51     }
52     function transferOwnership(address newOwner) onlyOwner {
53         if (newOwner != address(0)) {
54             owner = newOwner;
55         }
56     }
57 }
58 
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) constant returns (uint);
67   function transferFrom(address from, address to, uint value);
68   function approve(address spender, uint value);
69   event Approval(address indexed owner, address indexed spender, uint value);
70 }
71 
72 contract newToken is ERC20Basic {
73   
74   using SafeMath for uint;
75   
76   mapping(address => uint) balances;
77   
78 
79   modifier onlyPayloadSize(uint size) {
80      if(msg.data.length < size + 4) {
81        throw;
82      }
83      _;
84   }
85   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89   }
90   function balanceOf(address _owner) constant returns (uint balance) {
91     return balances[_owner];
92   }
93 }
94 
95 contract BestToken is newToken, ERC20 {
96   mapping (address => mapping (address => uint)) allowed;
97   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
98     var _allowance = allowed[_from][msg.sender];
99     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
100     // if (_value > _allowance) throw;
101     balances[_to] = balances[_to].add(_value);
102     balances[_from] = balances[_from].sub(_value);
103     allowed[_from][msg.sender] = _allowance.sub(_value);
104     Transfer(_from, _to, _value);
105   }
106   function approve(address _spender, uint _value) {
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling approve(_spender, 0) if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114   }
115   function allowance(address _owner, address _spender) constant returns (uint remaining) {
116     return allowed[_owner][_spender];
117   }
118 }
119 
120  contract RomanLanskoj is BestToken, Ownable {
121   string public constant name = "YourCoin";
122   string public constant symbol = "ICO";
123   uint public constant decimals = 2;
124   mapping (address => uint256) public balanceOf;
125     uint minBalanceForAccounts;
126     uint initialSupply;
127     
128   // Constructor
129   function RomanLanskoj() { 
130       balances[msg.sender] = totalSupply;
131       totalSupply = 2809199000;
132       initialSupply = totalSupply;
133 }
134 }
135 
136 contract ETH033 is Ownable, RomanLanskoj {
137 
138     /* Initializes contract with initial supply tokens to the creator of the contract */
139    function ETH033() RomanLanskoj () {}
140   mapping (address => mapping (address => uint)) allowed;
141   
142   function transfer(address _to, uint256 _value) {
143         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
144         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
145         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
146         balanceOf[_to] += _value;                            // Add the same to the recipient
147         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
148     }
149   
150 
151   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
152     var _allowance = allowed[_from][msg.sender];
153     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
154     // if (_value > _allowance) throw;
155     balances[_to] = balances[_to].add(_value);
156     balances[_from] = balances[_from].sub(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159   }
160   function approve(address _spender, uint _value) {
161     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165   }
166    function mintToken(address target, uint256 mintedAmount) onlyOwner {
167         balanceOf[target] += mintedAmount;
168         totalSupply += mintedAmount;
169         Transfer(0, this, mintedAmount);
170         Transfer(this, target, mintedAmount);
171     }
172   function allowance(address _owner, address _spender) constant returns (uint remaining) {
173     return allowed[_owner][_spender];
174   }
175   
176   uint256 public sellPrice;
177 uint256 public buyPrice;
178 
179 function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
180     sellPrice = 3;
181     buyPrice = 100;
182 }
183   
184   function buy() payable returns (uint amount){
185     amount = msg.value / buyPrice;                     // calculates the amount
186     if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
187     balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
188     balanceOf[this] -= amount;                         // subtracts amount from seller's balance
189     Transfer(this, msg.sender, amount);                // execute an event reflecting the change
190     return amount;                                     // ends function and returns
191 }
192 
193 function sell(uint amount) returns (uint revenue){
194     if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
195     balanceOf[this] += amount;                         // adds the amount to owner's balance
196     balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
197     revenue = amount * sellPrice;
198     if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
199         throw;                                         // to do this last to prevent recursion attacks
200     } else {
201         Transfer(msg.sender, this, amount);             // executes an event reflecting on the change
202         return revenue;                                 // ends function and returns
203     }
204 }
205   
206 }