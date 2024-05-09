1 /**
2   
3    In God We Trust
4    
5    God Bless the bearer of this token.
6    In the name of Jesus. Amen
7    
8    10 Commandments of God
9   
10    1.You shall have no other gods before Me.
11    2.You shall not make idols.
12    3.You shall not take the name of the LORD your God in vain.
13    4.Remember the Sabbath day, to keep it holy.
14    5.Honor your father and your mother.
15    6.You shall not murder.
16    7.You shall not commit adultery.
17    8.You shall not steal.
18    9.You shall not bear false witness against your neighbor.
19    10.You shall not covet.
20   
21    Our Mission
22    
23    1 Timothy 6:12 (NIV)
24   "Fight the good fight of the faith. 
25    Take hold of the eternal life to which you were called 
26    when you made your good confession in the presence of many witnesses."
27    
28    Matthew 24:14 (NKJV)
29   "And this gospel of the kingdom will be preached in all the world as a witness to all the nations,
30    and then the end will come."
31 
32    Verse for Good Health
33    
34    3 John 1:2
35   "Dear friend, I pray that you may enjoy good health and that all may go well with you, 
36    even as your soul is getting along well."
37  
38    Verse about Family
39    
40    Genesis 28:14
41    "Your offspring shall be like the dust of the earth, 
42    and you shall spread abroad to the west and to the east and to the north and to the south, 
43    and in you and your offspring shall all the families of the earth be blessed."
44 
45    
46 
47    Verse About Friends
48    
49    Proverbs 18:24
50    "One who has unreliable friends soon comes to ruin, but there is a friend who sticks closer than a brother."
51 
52 
53 
54 
55    God will Protect you
56    
57    Isaiah 43:2
58    "When you pass through the waters, I will be with you; and when you pass through the rivers,
59    they will not sweep over you. When you walk through the fire, you will not be burned; 
60    the flames will not set you ablaze."
61 
62    
63 
64    Trust in our GOD
65    
66    Proverbs 3:5-6
67  
68    "Trust in the LORD with all your heart and lean not on your own understanding; in all your ways submit to him,
69    and he will make your paths straight."
70    
71    
72    */  
73 
74 
75 pragma solidity ^0.4.16;
76 
77 
78 contract ForeignToken {
79     function balanceOf(address _owner) public constant returns (uint256);
80     function transfer(address _to, uint256 _value) public returns (bool);
81 }
82 
83 contract ERC20Basic {
84 
85   uint256 public totalSupply;
86   function balanceOf(address who) public constant returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 
90 }
91 
92 
93 
94 contract ERC20 is ERC20Basic {
95 
96   function allowance(address owner, address spender) public constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 
101 }
102 
103 library SaferMath {
104   function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
105     uint256 c = a * b;
106     assert(a == 0 || c / a == b);
107     return c;
108   }
109 
110   function divX(uint256 a, uint256 b) internal constant returns (uint256) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint256 c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   function add(uint256 a, uint256 b) internal constant returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 
130 
131 contract FaithCoin is ERC20 {
132     
133     address owner = msg.sender;
134 
135     mapping (address => uint256) balances;
136     mapping (address => mapping (address => uint256)) allowed;
137     
138     uint256 public totalSupply = 25000000 * 10**8;
139 
140     function name() public constant returns (string) { return "FaithCoin"; }
141     function symbol() public constant returns (string) { return "FAITH"; }
142     function decimals() public constant returns (uint8) { return 8; }
143 
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 
147     event DistrFinished();
148 
149     bool public distributionFinished = false;
150 
151     modifier canDistr() {
152     require(!distributionFinished);
153     _;
154     }
155 
156     function FaithCoin() public {
157         owner = msg.sender;
158         balances[msg.sender] = totalSupply;
159     }
160 
161     modifier onlyOwner { 
162         require(msg.sender == owner);
163         _;
164     }
165 
166     function transferOwnership(address newOwner) onlyOwner public {
167         owner = newOwner;
168     }
169 
170     function getEthBalance(address _addr) constant public returns(uint) {
171     return _addr.balance;
172     }
173 
174     function distributeFAITH(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
175          for (uint i = 0; i < addresses.length; i++) {
176 	     if (getEthBalance(addresses[i]) < _ethbal) {
177  	         continue;
178              }
179              balances[owner] -= _value;
180              balances[addresses[i]] += _value;
181              Transfer(owner, addresses[i], _value);
182          }
183     }
184     
185     function balanceOf(address _owner) constant public returns (uint256) {
186 	 return balances[_owner];
187     }
188 
189     // mitigates the ERC20 short address attack
190     modifier onlyPayloadSize(uint size) {
191         assert(msg.data.length >= size + 4);
192         _;
193     }
194     
195     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
196 
197          if (balances[msg.sender] >= _amount
198              && _amount > 0
199              && balances[_to] + _amount > balances[_to]) {
200              balances[msg.sender] -= _amount;
201              balances[_to] += _amount;
202              Transfer(msg.sender, _to, _amount);
203              return true;
204          } else {
205              return false;
206          }
207     }
208     
209     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
210 
211          if (balances[_from] >= _amount
212              && allowed[_from][msg.sender] >= _amount
213              && _amount > 0
214              && balances[_to] + _amount > balances[_to]) {
215              balances[_from] -= _amount;
216              allowed[_from][msg.sender] -= _amount;
217              balances[_to] += _amount;
218              Transfer(_from, _to, _amount);
219              return true;
220          } else {
221             return false;
222          }
223     }
224     
225     function approve(address _spender, uint256 _value) public returns (bool success) {
226         // mitigates the ERC20 spend/approval race condition
227         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
228         
229         allowed[msg.sender][_spender] = _value;
230         
231         Approval(msg.sender, _spender, _value);
232         return true;
233     }
234     
235     function allowance(address _owner, address _spender) constant public returns (uint256) {
236         return allowed[_owner][_spender];
237     }
238 
239     function finishDistribution() onlyOwner public returns (bool) {
240     distributionFinished = true;
241     DistrFinished();
242     return true;
243     }
244 
245     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
246         require(msg.sender == owner);
247         ForeignToken token = ForeignToken(_tokenContract);
248         uint256 amount = token.balanceOf(address(this));
249         return token.transfer(owner, amount);
250     }
251 
252 
253 }
254 
255 /**
256   
257    Verse for Wealth
258    
259    Deuteronomy 28:8
260   "The LORD will command the blessing upon you in your barns and in all that you put your hand to, 
261    and He will bless you in the land which the LORD your God gives you."
262    
263   
264    Philippians 4:19
265    And my God will meet all your needs according to the riches of his glory in Christ Jesus."
266    
267   
268    God Bless you all.
269    
270    
271   
272   
273   
274    FaithCoin MMXVIII
275    
276   
277    */