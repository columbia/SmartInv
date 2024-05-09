1 /**
2    In God We Trust
3    */
4 
5 /**
6    God Bless the bearer of this token.
7    In the name of Jesus. Amen
8    */
9    
10 /**
11    10 Commandments of God
12   
13    1.You shall have no other gods before Me.
14    2.You shall not make idols.
15    3.You shall not take the name of the LORD your God in vain.
16    4.Remember the Sabbath day, to keep it holy.
17    5.Honor your father and your mother.
18    6.You shall not murder.
19    7.You shall not commit adultery.
20    8.You shall not steal.
21    9.You shall not bear false witness against your neighbor.
22    10.You shall not covet.
23    */
24 
25 /**
26    Our Mission
27    
28    1 Timothy 6:12 (NIV)
29   “Fight the good fight of the faith. 
30    Take hold of the eternal life to which you were called 
31    when you made your good confession in the presence of many witnesses.”
32    
33    Matthew 24:14 (NKJV)
34   “And this gospel of the kingdom will be preached in all the world as a witness to all the nations,
35    and then the end will come.”
36    */
37    
38  /**
39    Verse for Good Health
40    
41    3 John 1:2
42    "Dear friend, I pray that you may enjoy good health and that all may go well with you, 
43    even as your soul is getting along well."
44    */     
45 
46 /**
47    Verse about Family
48    
49    Genesis 28:14
50    "Your offspring shall be like the dust of the earth, 
51    and you shall spread abroad to the west and to the east and to the north and to the south, 
52    and in you and your offspring shall all the families of the earth be blessed."
53    */  
54    
55 /**
56    Verse About Friends
57    
58    Proverbs 18:24
59    "One who has unreliable friends soon comes to ruin, but there is a friend who sticks closer than a brother."
60    */
61 
62 
63 /**
64    God will Protect you
65    
66    Isaiah 43:2
67    "When you pass through the waters, I will be with you; and when you pass through the rivers,
68    they will not sweep over you. When you walk through the fire, you will not be burned; 
69    the flames will not set you ablaze."
70    */  
71    
72 /**
73    Trust in our GOD
74    
75    Proverbs 3:5-6
76  
77    "Trust in the LORD with all your heart and lean not on your own understanding; in all your ways submit to him,
78    and he will make your paths straight."
79    */  
80 
81    
82 pragma solidity ^0.4.13;
83 
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public constant returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 contract Ownable {
99   address public owner;
100 
101   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103 
104 function Ownable() {
105     owner = msg.sender;
106   }
107 
108 
109 modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114 function transferOwnership(address newOwner) onlyOwner public {
115     require(newOwner != address(0));
116     OwnershipTransferred(owner, newOwner);
117     owner = newOwner;
118   }
119 }
120 
121 library SaferMath {
122   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
123     uint256 c = a * b;
124     assert(a == 0 || c / a == b);
125     return c;
126   }
127 
128   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   function add(uint256 a, uint256 b) internal constant returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 contract BasicToken is ERC20Basic {
148   using SaferMath for uint256;
149   mapping(address => uint256) balances;
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165 
166   function balanceOf(address _owner) public constant returns (uint256 balance) {
167     return balances[_owner];
168   }
169 
170 }
171 
172 contract StandardToken is ERC20, BasicToken {
173 
174   mapping (address => mapping (address => uint256)) allowed;
175 
176 
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179 
180     uint256 _allowance = allowed[_from][msg.sender];
181 
182     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
183     // require (_value <= _allowance);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = _allowance.sub(_value);
188     Transfer(_from, _to, _value);
189     return true;
190   }
191 
192 
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
200     return allowed[_owner][_spender];
201   }
202 
203   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 }
220 
221 contract FaithCoin is StandardToken, Ownable {
222 
223   string public constant name = "Faith Coin";
224   string public constant symbol = "FAITH";
225   uint8 public constant decimals = 8;
226 
227   uint256 public constant INITIAL_SUPPLY = 25000000 * (10 ** uint256(decimals));
228 
229   address NULL_ADDRESS = address(0);
230 
231   uint public nonce = 0;
232 
233 event NonceTick(uint nonce);
234   function incNonce() {
235     nonce += 1;
236     if(nonce > 100) {
237         nonce = 0;
238     }
239     NonceTick(nonce);
240   }
241 
242 
243   function FaithCoin() {
244     totalSupply = INITIAL_SUPPLY;
245     balances[msg.sender] = INITIAL_SUPPLY;
246   }
247 }
248 
249 /**
250    Verse for Wealth
251    
252    Deuteronomy 28:8
253 
254   "The LORD will command the blessing upon you in your barns and in all that you put your hand to, 
255    and He will bless you in the land which the LORD your God gives you."
256    */  
257    
258 /**
259    God Bless you all.
260    
261    Philippians 4:19
262 
263    And my God will meet all your needs according to the riches of his glory in Christ Jesus."
264    */