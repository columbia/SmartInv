1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 contract owned {
37 
38     address public owner;
39 
40     function owned() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address newOwner) onlyOwner public {
50         owner = newOwner;
51     }
52 }
53 
54 contract saleOwned is owned{
55     mapping (address => bool) public saleContract;
56 
57     modifier onlySaleOwner {        
58         require(msg.sender == owner || true == saleContract[msg.sender]);
59         _;
60     }
61 
62     function addSaleOwner(address saleOwner) onlyOwner public {
63         saleContract[saleOwner] = true;
64     }
65 
66     function delSaleOwner(address saleOwner) onlyOwner public {
67         saleContract[saleOwner] = false;
68     }
69 }
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is saleOwned {
76     event Pause();
77     event Unpause();
78 
79     bool public paused = false;
80 
81 
82   /**
83    * @dev modifier to allow actions only when the contract IS paused
84    */
85     modifier whenNotPaused() {
86         require(false == paused);
87         _;
88     }
89 
90   /**
91    * @dev modifier to allow actions only when the contract IS NOT paused
92    */
93     modifier whenPaused {
94         require(true == paused);
95         _;
96     }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101     function pause() onlyOwner whenNotPaused public returns (bool) {
102         paused = true;
103         emit Pause();
104         return true;
105     }
106 
107   /**
108    * @dev called by the owner to unpause, returns to normal state
109    */
110     function unpause() onlyOwner whenPaused public returns (bool) {
111         paused = false;
112         emit Unpause();
113         return true;
114     }
115 }
116 
117 /******************************************/
118 /*       BASE TOKEN STARTS HERE       */
119 /******************************************/
120 contract BaseToken is Pausable{
121     using SafeMath for uint256;    
122     
123     string public name;
124     string public symbol;
125     uint8 public decimals;
126     uint256 public totalSupply;
127     mapping (address => uint256) public balanceOf;
128     mapping (address => mapping (address => uint256))  approvals;
129 
130     // This generates a public event on the blockchain that will notify clients
131     event Transfer(address indexed from, address indexed to, uint256 value);
132     event TransferFrom(address indexed approval, address indexed from, address indexed to, uint256 value);
133     event Approval( address indexed owner, address indexed spender, uint value);
134 
135     function BaseToken (
136         string tokenName,
137         string tokenSymbol
138     ) public {
139         decimals = 18;
140         name = tokenName;
141         symbol = tokenSymbol;
142     }    
143     
144     function _transfer(address _from, address _to, uint _value) internal {
145         require (_to != 0x0);
146         require (balanceOf[_from] >= _value);
147         require (balanceOf[_to] + _value > balanceOf[_to]);
148         balanceOf[_from] = balanceOf[_from].sub(_value);
149         balanceOf[_to] = balanceOf[_to].add(_value);
150         emit Transfer(_from, _to, _value);
151     }
152 
153     function transfer(address _to, uint256 _value) whenNotPaused public {
154         _transfer(msg.sender, _to, _value);
155     }
156 
157     function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {
158         assert(balanceOf[_from] >= _value);
159         assert(approvals[_from][msg.sender] >= _value);
160         
161         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
162         balanceOf[_from] = balanceOf[_from].sub(_value);
163         balanceOf[_to] = balanceOf[_to].add(_value);
164         
165         emit Transfer(_from, _to, _value);
166         
167         return true;
168     }
169 
170     function allowance(address src, address guy) public view returns (uint256) {
171         return approvals[src][guy];
172     }
173 
174     function approve(address guy, uint256 _value) public returns (bool) {
175         approvals[msg.sender][guy] = _value;
176         
177         emit Approval(msg.sender, guy, _value);
178         
179         return true;
180     }
181 }
182 
183 /******************************************/
184 /*       ADVANCED TOKEN STARTS HERE       */
185 /******************************************/
186 contract AdvanceToken is BaseToken {
187     string tokenName        = "XBTEN";       // Set the name for display purposes
188     string tokenSymbol      = "XBTEN";            // Set the symbol for display purposes
189 
190     struct frozenStruct {
191         uint startTime;
192         uint endTime;
193     }
194     
195     mapping (address => bool) public frozenAccount;
196     mapping (address => frozenStruct) public frozenTime;
197 
198     event FrozenFunds(address target, bool frozen, uint startTime, uint endTime);    
199     event Burn(address indexed from, uint256 value);
200     
201     function AdvanceToken() BaseToken(tokenName, tokenSymbol) public {}
202     
203     function _transfer(address _from, address _to, uint _value) internal {
204         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
205         require (balanceOf[_from] >= _value);               // Check if the sender has enough
206         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
207         require(false == isFrozen(_from));                  // Check if sender is frozen
208         if(saleContract[_from] == false)                    // for refund
209             require(false == isFrozen(_to));                // Check if recipient is frozen
210         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
211         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
212 
213         emit Transfer(_from, _to, _value);
214     }    
215 
216     function mintToken(uint256 mintedAmount) onlyOwner public {
217         uint256 mintSupply = mintedAmount.mul(10 ** uint256(decimals));
218         balanceOf[msg.sender] = balanceOf[msg.sender].add(mintSupply);
219         totalSupply = totalSupply.add(mintSupply);
220         emit Transfer(0, this, mintSupply);
221         emit Transfer(this, msg.sender, mintSupply);
222     }
223 
224     function isFrozen(address target) public view returns (bool success) {        
225         if(false == frozenAccount[target])
226             return false;
227 
228         if(frozenTime[target].startTime <= now && now <= frozenTime[target].endTime)
229             return true;
230         
231         return false;
232     }
233 
234     function freezeAccount(address target, bool freeze, uint startTime, uint endTime) onlySaleOwner public {
235         frozenAccount[target] = freeze;
236         frozenTime[target].startTime = startTime;
237         frozenTime[target].endTime = endTime;
238         emit FrozenFunds(target, freeze, startTime, endTime);
239     }
240 
241     function burn(uint256 _value) onlyOwner public returns (bool success) {
242         require(balanceOf[msg.sender] >= _value);
243         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
244         totalSupply = totalSupply.sub(_value);
245         emit Burn(msg.sender, _value);
246         return true;
247     }
248 
249     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
250         require(balanceOf[_from] >= _value);
251         balanceOf[_from] = balanceOf[_from].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         emit Burn(_from, _value);
254         return true;
255     }
256 }