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
62     function isSaleOwner() public view returns (bool success) {     
63         if(msg.sender == owner || true == saleContract[msg.sender])
64             return true;
65         return false;
66     }
67 
68     function addSaleOwner(address saleOwner) onlyOwner public {
69         saleContract[saleOwner] = true;
70     }
71 
72     function delSaleOwner(address saleOwner) onlyOwner public {
73         saleContract[saleOwner] = false;
74     }
75 }
76 
77 /**
78  * @title Pausable
79  * @dev Base contract which allows children to implement an emergency stop mechanism.
80  */
81 contract Pausable is saleOwned {
82     event Pause();
83     event Unpause();
84 
85     bool public paused = false;
86 
87 
88   /**
89    * @dev modifier to allow actions only when the contract IS paused
90    */
91     modifier whenNotPaused() {
92         require(false == paused);
93         _;
94     }
95 
96   /**
97    * @dev modifier to allow actions only when the contract IS NOT paused
98    */
99     modifier whenPaused {
100         require(true == paused);
101         _;
102     }
103 
104   /**
105    * @dev called by the owner to pause, triggers stopped state
106    */
107     function pause() onlyOwner whenNotPaused public returns (bool) {
108         paused = true;
109         emit Pause();
110         return true;
111     }
112 
113   /**
114    * @dev called by the owner to unpause, returns to normal state
115    */
116     function unpause() onlyOwner whenPaused public returns (bool) {
117         paused = false;
118         emit Unpause();
119         return true;
120     }
121 }
122 
123 /******************************************/
124 /*       BASE TOKEN STARTS HERE       */
125 /******************************************/
126 contract BaseToken is Pausable{
127     using SafeMath for uint256;    
128     
129     string public name;
130     string public symbol;
131     uint8 public decimals;
132     uint256 public totalSupply;
133     mapping (address => uint256) public balanceOf;
134     mapping (address => mapping (address => uint256))  approvals;
135 
136     // This generates a public event on the blockchain that will notify clients
137     event Transfer(address indexed from, address indexed to, uint256 value);
138     event TransferFrom(address indexed approval, address indexed from, address indexed to, uint256 value);
139     event Approval( address indexed owner, address indexed spender, uint value);
140 
141     function BaseToken(
142         string tokenName,
143         string tokenSymbol
144     ) public {
145         decimals = 18;
146         name = tokenName;
147         symbol = tokenSymbol;
148     }    
149     
150     function _transfer(address _from, address _to, uint _value) internal {
151         require (_to != 0x0);
152         require (balanceOf[_from] >= _value);
153         require (balanceOf[_to] + _value > balanceOf[_to]);
154         balanceOf[_from] = balanceOf[_from].sub(_value);
155         balanceOf[_to] = balanceOf[_to].add(_value);
156         emit Transfer(_from, _to, _value);
157     }
158 
159     function transfer(address _to, uint256 _value) whenNotPaused public {
160         _transfer(msg.sender, _to, _value);
161     }
162 
163     function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {
164         assert(balanceOf[_from] >= _value);
165         assert(approvals[_from][msg.sender] >= _value);
166         
167         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
168         _transfer(_from, _to, _value);
169         
170         emit TransferFrom(msg.sender, _from, _to, _value);
171         
172         return true;
173     }
174 
175     function allowance(address src, address guy) public view returns (uint256) {
176         return approvals[src][guy];
177     }
178 
179     function approve(address guy, uint256 _value) public returns (bool) {
180         approvals[msg.sender][guy] = _value;
181         
182         emit Approval(msg.sender, guy, _value);
183         
184         return true;
185     }
186 }
187 
188 /******************************************/
189 /*       ADVANCED TOKEN STARTS HERE       */
190 /******************************************/
191 contract AdvanceToken is BaseToken {
192     string tokenName        = "8ENCORE";       // Set the name for display purposes
193     string tokenSymbol      = "8EN";           // Set the symbol for display purposes
194 
195     struct frozenStruct {        
196         uint startTime;
197         uint endTime;
198     }
199     
200     mapping (address => bool) public frozenAccount;
201     mapping (address => frozenStruct) public frozenTime;   
202     
203     frozenStruct public allFrozenTime;          // all frozenTime
204 
205     event AllFrozenFunds(uint startTime, uint endTime);
206     event FrozenFunds(address target, bool frozen, uint startTime, uint endTime);    
207     event Burn(address indexed from, uint256 value);
208     
209     function AdvanceToken() BaseToken(tokenName, tokenSymbol) public {
210         allFrozenTime.startTime = 0;
211         allFrozenTime.endTime = 0;
212     }
213     
214     function _transfer(address _from, address _to, uint _value) internal {
215         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
216         require (balanceOf[_from] >= _value);               // Check if the sender has enough
217         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
218         
219         if(false == isSaleOwner())                          // for refund
220             require(false == isAllFrozen());                // Check is Allfrozen
221 
222         require(false == isFrozen(_from));                  // Check if sender is frozen        
223 
224         if(false == isSaleOwner())                          // for refund
225             require(false == isFrozen(_to));                // Check if recipient is frozen
226 
227         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
228         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
229 
230         emit Transfer(_from, _to, _value);
231     }
232 
233     function mintToken(uint256 mintedAmount) onlyOwner public {
234         uint256 mintSupply = mintedAmount.mul(10 ** uint256(decimals));
235         balanceOf[msg.sender] = balanceOf[msg.sender].add(mintSupply);
236         totalSupply = totalSupply.add(mintSupply);
237         emit Transfer(0, this, mintSupply);
238         emit Transfer(this, msg.sender, mintSupply);
239     }
240 
241     function isAllFrozen() public view returns (bool success) {
242         if(0 == allFrozenTime.startTime && 0 == allFrozenTime.endTime)
243             return true;
244 
245         if(allFrozenTime.startTime <= now && now <= allFrozenTime.endTime)
246             return true;
247         
248         return false;
249     }
250 
251     function isFrozen(address target) public view returns (bool success) {        
252         if(false == frozenAccount[target])
253             return false;
254 
255         if(frozenTime[target].startTime <= now && now <= frozenTime[target].endTime)
256             return true;
257         
258         return false;
259     }
260 
261     function setAllFreeze(uint startTime, uint endTime) onlyOwner public {           
262         allFrozenTime.startTime = startTime;
263         allFrozenTime.endTime = endTime;
264         emit AllFrozenFunds(startTime, endTime);
265     }
266 
267     function freezeAccount(address target, bool freeze, uint startTime, uint endTime) onlySaleOwner public {
268         frozenAccount[target] = freeze;
269         frozenTime[target].startTime = startTime;
270         frozenTime[target].endTime = endTime;
271         emit FrozenFunds(target, freeze, startTime, endTime);
272     }
273 
274     function burn(uint256 _value) onlyOwner public returns (bool success) {
275         require(balanceOf[msg.sender] >= _value);
276         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
277         totalSupply = totalSupply.sub(_value);
278         emit Burn(msg.sender, _value);
279         return true;
280     }
281 
282     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
283         require(balanceOf[_from] >= _value);
284         balanceOf[_from] = balanceOf[_from].sub(_value);
285         totalSupply = totalSupply.sub(_value);
286         emit Burn(_from, _value);
287         return true;
288     }
289 }