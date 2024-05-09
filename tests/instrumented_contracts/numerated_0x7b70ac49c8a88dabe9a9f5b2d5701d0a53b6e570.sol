1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract ERC20Interface {
21     function totalSupply() public constant returns (uint);
22     function balanceOf(address tokenOwner) public constant returns (uint256);
23     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
24     function transfer(address to, uint256 tokens) public returns (bool success);
25     function approve(address spender, uint tokens) public returns (bool success);
26     function transferFrom(address from, address to, uint tokens) public returns (bool success);
27 
28     event Transfer(address indexed from, address indexed to, uint tokens);
29     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30 }
31 
32 contract VanityToken is owned, ERC20Interface {
33     // Public variables of the token
34     string  public name = "Vanity Token";
35     string  public symbol = "VNT";
36     uint8   public decimals = 18;
37     
38     uint256 public currentSupply = 0;
39     uint256 public maxSupply = 1333337;
40     uint256 public bonusAmtThreshold = 20000;
41     uint256 public bonusSignalValue = 0.001 ether;
42     uint256 public _totalSupply;
43     uint256 public tokenXchangeRate ;
44     uint    public icoStartTime;
45     bool    public purchasingAllowed = false;
46     bool    public demo = false;
47 
48     uint    public windowBonusMax = 43200 seconds;
49     uint    public windowBonusMin = 10800 seconds; 
50     uint    public windowBonusStep1 = 21600 seconds;
51     uint    public windowBonusStep2 = 28800 seconds;
52 
53     // This creates an array with all balances
54     mapping (address => uint256) public _balanceOf;
55     mapping (address => uint256) public bonusOf;
56     mapping (address => uint) public timeBought;
57     mapping (address => uint256) public transferredAtSupplyValue;
58     mapping (address => mapping (address => uint256)) public _allowance;
59 
60 
61     function setBonuses(bool _d) onlyOwner public {
62         if (_d == true) {
63             windowBonusMax = 20 minutes;
64             windowBonusMin = 30 seconds;
65             windowBonusStep1 = 60 seconds;
66             windowBonusStep2 = 120 seconds;
67             bonusAmtThreshold = 500;
68             maxSupply = 13337;
69         } else {
70             windowBonusMax = 12 hours;
71             windowBonusMin = 3 hours;
72             windowBonusStep1 = 6 hours;
73             windowBonusStep2 = 8 hours;
74             bonusAmtThreshold = 20000;
75             maxSupply = 1333337;
76         }
77         demo = _d;
78     }
79 
80     // This generates a public event on the blockchain that will notify clients
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
83 
84 
85     // This notifies clients about the amount burnt
86     event Burn(address indexed from, uint256 value);
87 
88      modifier onlyPayloadSize(uint size) {
89         assert(msg.data.length >= size + 4 || msg.data.length == 4);
90         _;
91     }
92  
93 
94     /**
95      * Constrctor function
96      *
97      * Initializes contract with initial supply tokens to the creator of the contract
98      */
99     function VanityToken() public payable {
100         tokenXchangeRate = 300;
101         _balanceOf[address(this)] = 0;
102         owner = msg.sender;     
103         setBonuses(false);      
104         //enablePurchasing();              
105         _totalSupply = maxSupply * 10 ** uint256(decimals);  
106     }
107 
108     function totalSupply() public constant returns (uint) {
109         return _totalSupply;
110     }
111 
112     function balanceOf(address _owner) public constant returns (uint256) { return _balanceOf[_owner] ; }
113 
114     function allowance(address tokenOwner, address spender) onlyPayloadSize(2 * 32) public constant returns (uint remaining) {
115         return _allowance[tokenOwner][spender];
116     }
117 
118     function kill() public {
119         if (msg.sender == owner) 
120             selfdestruct(owner);
121     }
122 
123     /**
124      * Internal transfer, only can be called by this contract
125      */
126     function _transfer(address _from, address _to, uint256 _value, uint256 _bonusValue) onlyPayloadSize(4*32) internal returns (bool) {
127 
128         if (_value == 0 && _bonusValue == 0) {return false;}
129         if (_value!=0&&_bonusValue!=0) {return false;}  
130 
131         require(_to != 0x0);
132        
133         // Check for overflows[]       
134         require(_balanceOf[_to] + _value >= _balanceOf[_to]);
135         require(bonusOf[_to] + _bonusValue >= bonusOf[_to]);
136         
137         if (_value > 0) {
138             _balanceOf[_from] += _value;
139             _balanceOf[_to] += _value;
140             timeBought[_to] = now;
141             Transfer(_from, _to, _value);
142         } else if (_bonusValue > 0) {
143             _balanceOf[_from] += _bonusValue;
144             _balanceOf[_to] += _bonusValue;
145             bonusOf[_to] += _bonusValue;     
146             timeBought[_to] = 0;
147             Transfer(_from, _to, _bonusValue);
148         }
149 
150         return true;
151     }
152 
153 
154     function buy() public payable {
155         require(purchasingAllowed);
156         require(msg.value > 0);
157         require(msg.value >= 0.01 ether || msg.value == bonusSignalValue);
158         _buy(msg.value);
159     }
160 
161     function() public payable {
162         buy();
163     }
164 
165     function _buy(uint256 value) internal {
166 
167         uint tPassed = now - icoStartTime;
168         if (tPassed <= 3 days) {
169             tokenXchangeRate = 300;
170         } else if (tPassed <= 5 days) {
171             tokenXchangeRate = 250;
172         } else if (tPassed <= 7 days) {
173             tokenXchangeRate = 200;
174         } else if (tPassed >= 10 days) {
175           tokenXchangeRate = 100;
176         }
177 
178         bool requestedBonus = false;
179         uint256 amount = value * tokenXchangeRate;
180         
181         if (value == bonusSignalValue) {
182             require (timeBought[msg.sender] > 0 && transferredAtSupplyValue[msg.sender] > 0);
183 
184             uint dif = now - timeBought[msg.sender];
185             //verify window
186             require (dif <= windowBonusMax && dif >= windowBonusMin); 
187             requestedBonus = true;
188             amount = _balanceOf[msg.sender] - bonusOf[msg.sender];
189             assert (amount > 0);
190 
191             if (dif >= windowBonusStep2) {
192                 amount = amount * 3;
193             } else if (dif >= windowBonusStep1) {
194                 amount = amount * 2;
195             } 
196 
197             if (_balanceOf[address(this)] - transferredAtSupplyValue[msg.sender] < bonusAmtThreshold) {
198                 owner.transfer(value);
199                 return;
200            }
201         }
202 
203         uint256 newBalance = _balanceOf[address(this)] + amount;
204         require (newBalance <= _totalSupply); 
205         owner.transfer(value);
206 
207         currentSupply = newBalance;
208         transferredAtSupplyValue[msg.sender] = currentSupply;
209 
210         if (requestedBonus == false) {
211             _transfer(address(this), msg.sender, amount, 0);
212         } else {
213             _transfer(address(this), msg.sender, 0, amount);
214         }
215        
216     }
217     
218  
219    /**
220      * Transfer tokens
221      *
222      * Send `_value` tokens to `_to` from your account
223      *
224      * @param _to The address of the recipient
225      * @param _value the amount to send
226      */
227     function transfer(address _to, uint256 _value) public returns (bool success) {
228        return _transfer(msg.sender, _to, _value, 0);
229     }
230 
231     /**
232      * Transfer tokens from other address
233      *
234      * Send `_value` tokens to `_to` in behalf of `_from`
235      *
236      * @param _from The address of the sender
237      * @param _to The address of the recipient
238      * @param _value the amount to send
239      */
240     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
241         require(_value <= _allowance[_from][msg.sender]);     // Check _allowance
242         _allowance[_from][msg.sender] -= _value;
243         return _transfer(_from, _to, _value, 0);
244     }
245 
246     /**
247      * Set _allowance for other address
248      *
249      * Allows `_spender` to spend no more than `_value` tokens in your behalf
250      *
251      * @param _spender The address authorized to spend
252      * @param _value the max amount they can spend
253      */
254     function approve(address _spender, uint256 _value) public
255         returns (bool success) {
256         _allowance[msg.sender][_spender] = _value;
257         Approval(msg.sender, _spender, _value);
258         return true;
259     }
260 
261     /**
262      * Destroy tokens
263      *
264      * Remove `_value` tokens from the system irreversibly
265      *
266      * @param _value the amount of money to burn
267      */
268     function burn(uint256 _value) public returns (bool success) {
269         require(_balanceOf[msg.sender] >= _value);   // Check if the sender has enough
270         _balanceOf[msg.sender] -= _value;            // Subtract from the sender
271         _totalSupply -= _value;                      // Updates _totalSupply
272         Burn(msg.sender, _value);
273         return true;
274     }
275 
276     function burnTokens(uint256 _value) onlyOwner public returns (bool success) {
277         require(_balanceOf[address(this)] >= _value);   // Check if the sender has enough
278         _balanceOf[address(this)] -= _value;            // Subtract from the sender
279         _totalSupply -= _value;                      // Updates _totalSupply
280         if (currentSupply > _totalSupply) {
281             currentSupply = _totalSupply;
282         }
283         Burn(address(this), _value);
284         return true;
285     }
286 
287     /**
288      * Destroy tokens from other account
289      *
290      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
291      *
292      * @param _from the address of the sender
293      * @param _value the amount of money to burn
294      */
295     function burnFrom(address _from, uint256 _value) public returns (bool success) {
296         require(_balanceOf[_from] >= _value);                // Check if the targeted balance is enough
297         require(_value <= _allowance[_from][msg.sender]);    // Check _allowance
298         _balanceOf[_from] -= _value;                         // Subtract from the targeted balance
299         _allowance[_from][msg.sender] -= _value;             // Subtract from the sender's _allowance
300         _totalSupply -= _value;                              // Update _totalSupply
301         Burn(_from, _value);
302         return true;
303     }
304 
305      function enablePurchasing() onlyOwner public {
306         purchasingAllowed = true;
307         icoStartTime = now;
308     }
309 
310     function disablePurchasing() onlyOwner public {
311         purchasingAllowed = false;
312     }
313 
314     
315 
316 }