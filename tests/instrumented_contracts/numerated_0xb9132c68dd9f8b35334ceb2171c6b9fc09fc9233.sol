1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) constant returns (uint256);
7   function transfer(address to, uint256 value) returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) constant returns (uint256);
13   function transferFrom(address from, address to, uint256 value) returns (bool);
14   function approve(address spender, uint256 value) returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48 
49   function transfer(address _to, uint256 _value) returns (bool) {
50     balances[msg.sender] = balances[msg.sender].sub(_value);
51     balances[_to] = balances[_to].add(_value);
52     Transfer(msg.sender, _to, _value);
53     return true;
54   }
55 
56 
57   function balanceOf(address _owner) constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 contract StandardToken is ERC20, BasicToken {
63 
64   mapping (address => mapping (address => uint256)) allowed;
65 
66 
67  
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
69     var _allowance = allowed[_from][msg.sender];
70 
71     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
72     // require (_value <= _allowance);
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = _allowance.sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81 
82   function approve(address _spender, uint256 _value) returns (bool) {
83 
84    
85     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86 
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92 
93   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
94     return allowed[_owner][_spender];
95   }
96   
97 
98   function increaseApproval (address _spender, uint _addedValue) 
99     returns (bool success) {
100     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102     return true;
103   }
104 
105   function decreaseApproval (address _spender, uint _subtractedValue) 
106     returns (bool success) {
107     uint oldValue = allowed[msg.sender][_spender];
108     if (_subtractedValue > oldValue) {
109       allowed[msg.sender][_spender] = 0;
110     } else {
111       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112     }
113     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117 }
118 
119 contract Ownable {
120   address public owner;
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   function Ownable() {
128     owner = msg.sender;
129   }
130 
131 
132   /**
133    * @dev Throws if called by any account other than the owner.
134    */
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address newOwner) onlyOwner {
146     require(newOwner != address(0));
147     owner = newOwner;
148   }
149 
150 }
151 
152 contract StarToken is StandardToken,Ownable {
153 
154   string public constant name = "StarLight";
155   string public constant symbol = "STAR";
156   uint8 public constant decimals = 18;
157   
158   address public address1 = 0x08294159dE662f0Bd810FeaB94237cf3A7bB2A3D;
159   address public address2 = 0xAed27d4ecCD7C0a0bd548383DEC89031b7bBcf3E;
160   address public address3 = 0x41ba7eED9be2450961eBFD7C9Fb715cae077f1dC;
161   address public address4 = 0xb9cdb4CDC8f9A931063cA30BcDE8b210D3BA80a3;
162   address public address5 = 0x5aBF2CA9e7F5F1895c6FBEcF5668f164797eDc5D;
163  uint256 public weiRaised;
164 
165 
166 
167   uint public  price;
168     
169 
170  
171   function StarToken() {
172     
173     price = 1136;
174   }
175   
176   function () payable {
177       
178       buy();
179   }
180   
181   function buy() payable {
182 
183     require(msg.value >= 1 ether);
184     
185 
186 
187 
188       uint256 weiAmount = msg.value;
189 
190 
191         uint256 toto = totalSupply.div(1 ether);
192 
193       if ( toto> 3000000) {
194 
195           price = 558;
196         }
197 
198         if (toto > 9000000) {
199 
200           price = 277;
201         }
202 
203         if (toto > 23400000) {
204 
205             price = 136;
206         }
207 
208         if (toto > 104400000) {
209 
210             price = 0;
211         }
212 
213       // calculate token amount to be created
214       uint256 tokens = weiAmount.mul(price);
215 
216     // update state
217       weiRaised = weiRaised.add(weiAmount);
218 
219 
220       totalSupply = totalSupply.add(tokens);
221       balances[msg.sender] = balances[msg.sender].add(tokens);
222 
223 
224       address1.transfer(weiAmount.div(5));
225       address2.transfer(weiAmount.div(5));
226       address3.transfer(weiAmount.div(5));
227       address4.transfer(weiAmount.div(5));
228       address5.transfer(weiAmount.div(5));
229 
230   }
231 
232 
233   function setPrice(uint256 newPrice){
234 
235         price = newPrice;
236 
237   }
238   
239 
240 
241   function withdraw() onlyOwner
242     {
243         owner.transfer(this.balance);
244     }
245 
246 
247 
248 }