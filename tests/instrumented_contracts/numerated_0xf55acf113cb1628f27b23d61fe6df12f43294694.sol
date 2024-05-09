1 pragma solidity ^0.4.14;
2 
3 /* ©RomanLanskoj 2017
4 I can create the cryptocurrency Ethereum-token for you, with any total or initial supply,  enable the owner to create new tokens or without it,  custom currency rates (can make the token's value be backed by ether (or other tokens) by creating a fund that automatically sells and buys them at market value) and other features. 
5 Full support and privacy
6 
7 Only you will be able to issue it and only you will have all the copyrights!
8 
9 Price is only 0.33 ETH  (if you will gift me a small % of issued coins I will be happy:)).
10 
11 skype open24365
12 +35796229192 Cyprus
13 viber+telegram +375298563585
14 viber +375298563585
15 telegram +375298563585
16 gmail romanlanskoj@gmail.com
17 
18 
19 
20 the example: https://etherscan.io/address/0x178AbBC1574a55AdA66114Edd68Ab95b690158FC
21 
22 The information I need:
23 - name for your coin (token)
24 - short name
25 - total supply or initial supply
26 - minable or not (fixed)
27 - the number of decimals (0.001 = 3 decimals)
28 - any comments you wanna include in the code (no limits for readme)
29 
30 After send  please  at least 0.25-0.33 ETH to 0x4BCc85fa097ad0f5618cb9bb5bc0AFfbAEC359B5 
31 
32 Adding your coin to EtherDelta exchange, code-verification and github are included  
33 
34 There is no law stronger then the code
35 */
36 
37 library SafeMath {
38   function mul(uint a, uint b) internal returns (uint) {
39     uint c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43   function div(uint a, uint b) internal returns (uint) {
44     assert(b > 0);
45     uint c = a / b;
46     assert(a == b * c + a % b);
47     return c;
48   }
49   function sub(uint a, uint b) internal returns (uint) {
50     assert(b <= a);
51     return a - b;
52   }
53   function add(uint a, uint b) internal returns (uint) {
54     uint c = a + b;
55     assert(c >= a);
56     return c;
57   }
58   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
59     return a >= b ? a : b;
60   }
61   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
62     return a < b ? a : b;
63   }
64   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
65     return a >= b ? a : b;
66   }
67   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
68     return a < b ? a : b;
69   }
70   function assert(bool assertion) internal {
71     if (!assertion) {
72       throw;
73     }
74   }
75 }
76 
77 contract Ownable {
78     address public owner;
79     function Ownable() {
80         owner = msg.sender;
81     }
82     modifier onlyOwner {
83         if (msg.sender != owner) throw;
84         _;
85     }
86     function transferOwnership(address newOwner) onlyOwner {
87         if (newOwner != address(0)) {
88             owner = newOwner;
89         }
90     }
91 }
92 
93 contract ERC20Basic {
94   uint public totalSupply;
95   function balanceOf(address who) constant returns (uint);
96   function transfer(address to, uint value);
97   event Transfer(address indexed from, address indexed to, uint value);
98 }
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) constant returns (uint);
101   function transferFrom(address from, address to, uint value);
102   function approve(address spender, uint value);
103   event Approval(address indexed owner, address indexed spender, uint value);
104 }
105 
106 contract newToken is ERC20Basic {
107   
108   using SafeMath for uint;
109   
110   mapping(address => uint) balances;
111   
112 
113   modifier onlyPayloadSize(uint size) {
114      if(msg.data.length < size + 4) {
115        throw;
116      }
117      _;
118   }
119   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123   }
124   function balanceOf(address _owner) constant returns (uint balance) {
125     return balances[_owner];
126   }
127 }
128 
129 contract StandardToken is newToken, ERC20 {
130   mapping (address => mapping (address => uint)) allowed;
131   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
132     var _allowance = allowed[_from][msg.sender];
133     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
134     // if (_value > _allowance) throw;
135     balances[_to] = balances[_to].add(_value);
136     balances[_from] = balances[_from].sub(_value);
137     allowed[_from][msg.sender] = _allowance.sub(_value);
138     Transfer(_from, _to, _value);
139   }
140   function approve(address _spender, uint _value) {
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling approve(_spender, 0) if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148   }
149   function allowance(address _owner, address _spender) constant returns (uint remaining) {
150     return allowed[_owner][_spender];
151   }
152 }
153 
154 contract Order is StandardToken, Ownable {
155   string public constant name = "Order";
156   string public constant symbol = "ETH";
157   uint public constant decimals = 3;
158   uint256 public initialSupply;
159     
160   // Constructor
161   function Order () { 
162      totalSupply = 120000 * 10 ** decimals;
163       balances[msg.sender] = totalSupply;
164       initialSupply = totalSupply; 
165         Transfer(0, this, totalSupply);
166         Transfer(this, msg.sender, totalSupply);
167   }
168 }
169 
170 contract BuyToken is Ownable, Order {
171 
172 uint256 public constant sellPrice = 333 szabo;
173 uint256 public constant buyPrice = 333 finney;
174 
175     function buy() payable returns (uint amount)
176     {
177         amount = msg.value / buyPrice;
178         if (balances[this] < amount) throw; 
179         balances[msg.sender] += amount;
180         balances[this] -= amount;
181         Transfer(this, msg.sender, amount);
182     }
183 
184     function sell(uint256 amount) {
185         if (balances[msg.sender] < amount ) throw;
186         balances[this] += amount;
187         balances[msg.sender] -= amount;
188         if (!msg.sender.send(amount * sellPrice)) {
189             throw;
190         } else {
191             Transfer(msg.sender, this, amount);
192         }               
193     }
194     
195   function transfer(address _to, uint256 _value) {
196         require(balances[msg.sender] > _value);
197         require(balances[_to] + _value > balances[_to]);
198         balances[msg.sender] -= _value;
199         balances[_to] += _value;
200         Transfer(msg.sender, _to, _value);
201     }
202 
203    function mintToken(address target, uint256 mintedAmount) onlyOwner {
204         balances[target] += mintedAmount;
205         totalSupply += mintedAmount;
206         Transfer(0, this, mintedAmount);
207         Transfer(this, target, mintedAmount);
208     }
209    
210     function () payable {
211         buy();
212     }
213 }