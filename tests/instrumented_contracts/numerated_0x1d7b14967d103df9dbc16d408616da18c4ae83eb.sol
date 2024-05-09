1 pragma solidity ^0.4.23;
2 
3 contract Owned {
4 
5     event OwnerChanged(address indexed from, address indexed to);
6 
7     address public owner;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function _transferOwnership(address _from, address _to) internal {
19         owner = _to;
20         emit OwnerChanged(_from, _to);
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         _transferOwnership(owner, newOwner);
25     }
26 }
27 
28 contract Whitelisted is Owned {
29 
30     event WhitelistModified(address indexed who, bool inWhitelist);
31 
32     mapping(address => bool) public whitelist;
33 
34     constructor() public {
35         whitelist[msg.sender] = true;
36     }
37 
38     function addToWhitelist(address who) public onlyOwner {
39         whitelist[who] = true;
40         emit WhitelistModified(who, true);
41     }
42     
43     function removeFromWhitelist(address who) public onlyOwner {
44         whitelist[who] = false;
45         emit WhitelistModified(who, false);
46     }
47 
48     modifier whitelisted {
49         require(whitelist[msg.sender] == true);
50         _;
51     }
52 
53 }
54 
55 contract TokenERC20 {
56     // Public variables of the token
57     string public name;
58     string public symbol;
59     uint8 public decimals = 18;
60     // 18 decimals is the strongly suggested default, avoid changing it
61     uint256 public totalSupply;
62 
63     // This creates an array with all balances
64     mapping (address => uint256) public balanceOf;
65     mapping (address => mapping (address => uint256)) public allowance;
66 
67     // This generates a public event on the blockchain that will notify clients
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     
70     // This generates a public event on the blockchain that will notify clients
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 
73     // This notifies clients about the amount burnt
74     event Burn(address indexed from, uint256 value);
75 
76     /**
77      * Constructor function
78      *
79      * Initializes contract with initial supply tokens to the creator of the contract
80      */
81     constructor(
82         uint256 initialSupply,
83         string tokenName,
84         string tokenSymbol
85     ) public {
86         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
87         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
88         name = tokenName;                                   // Set the name for display purposes
89         symbol = tokenSymbol;                               // Set the symbol for display purposes
90     }
91 
92     /**
93      * Internal transfer, only can be called by this contract
94      */
95     function _transfer(address _from, address _to, uint _value) internal {
96         // Prevent transfer to 0x0 address. Use burn() instead
97         require(_to != 0x0);
98         // Check if the sender has enough
99         require(balanceOf[_from] >= _value);
100         // Check for overflows
101         require(balanceOf[_to] + _value >= balanceOf[_to]);
102         // Save this for an assertion in the future
103         uint previousBalances = balanceOf[_from] + balanceOf[_to];
104         // Subtract from the sender
105         balanceOf[_from] -= _value;
106         // Add the same to the recipient
107         balanceOf[_to] += _value;
108         emit Transfer(_from, _to, _value);
109         // Asserts are used to use static analysis to find bugs in your code. They should never fail
110         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
111     }
112 
113     /**
114      * Transfer tokens
115      *
116      * Send `_value` tokens to `_to` from your account
117      *
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transfer(address _to, uint256 _value) public returns (bool success) {
122         _transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127      * Transfer tokens from other address
128      *
129      * Send `_value` tokens to `_to` on behalf of `_from`
130      *
131      * @param _from The address of the sender
132      * @param _to The address of the recipient
133      * @param _value the amount to send
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         require(_value <= allowance[_from][msg.sender]);     // Check allowance
137         allowance[_from][msg.sender] -= _value;
138         _transfer(_from, _to, _value);
139         return true;
140     }
141 
142     /**
143      * Set allowance for other address
144      *
145      * Allows `_spender` to spend no more than `_value` tokens on your behalf
146      *
147      * @param _spender The address authorized to spend
148      * @param _value the max amount they can spend
149      */
150     function approve(address _spender, uint256 _value) public
151         returns (bool success) {
152         allowance[msg.sender][_spender] = _value;
153         emit Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens
159      *
160      * Remove `_value` tokens from the system irreversibly
161      *
162      * @param _value the amount of money to burn
163      */
164     function burn(uint256 _value) public returns (bool success) {
165         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
166         balanceOf[msg.sender] -= _value;            // Subtract from the sender
167         totalSupply -= _value;                      // Updates totalSupply
168         emit Burn(msg.sender, _value);
169         return true;
170     }
171 
172     /**
173      * Destroy tokens from other account
174      *
175      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
176      *
177      * @param _from the address of the sender
178      * @param _value the amount of money to burn
179      */
180     function burnFrom(address _from, uint256 _value) public returns (bool success) {
181         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
182         require(_value <= allowance[_from][msg.sender]);    // Check allowance
183         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
184         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
185         totalSupply -= _value;                              // Update totalSupply
186         emit Burn(_from, _value);
187         return true;
188     }
189 
190 }
191 
192 contract Ellobitz is TokenERC20, Owned, Whitelisted {
193 
194     uint256 public mineCount;
195     uint256 public minMineSize;
196     uint256 public maxMineSize;
197     uint256 public chipSize;
198     uint256 public firstChipBonus;
199     uint public chipSpeed;
200 
201     uint256 internal activeMine;
202     uint256 internal mineSize;
203     bool internal firstChip;
204     
205     mapping(address => uint) public lastChipTime;
206 
207     event MineFound(address indexed chipper, uint256 activeMine);
208     event MineChipped(address indexed chipper, uint256 indexed activeMine, uint256 amount);
209     event MineExausted(address indexed chipper, uint256 activeMine);
210 
211     modifier validMineParameters (
212         uint256 _mineCount,
213         uint256 _minMineSize,
214         uint256 _maxMineSize,
215         uint256 _chipSize,
216         uint256 _firstChipBonus,
217         uint _chipSpeed
218     ) {
219         require(_minMineSize <= _maxMineSize, "Smallest mine size smaller than largest mine size");
220         require(_chipSize + _firstChipBonus <= _minMineSize, "First chip would exhaust mine");
221         _;
222     }
223 
224     constructor(
225         string tokenName,
226         string tokenSymbol,
227         uint256 _mineCount,
228         uint256 _minMineSize,
229         uint256 _maxMineSize,
230         uint256 _chipSize,
231         uint256 _firstChipBonus,
232         uint _chipSpeed
233     ) TokenERC20(0, tokenName, tokenSymbol) validMineParameters(
234         _mineCount,
235         _minMineSize,
236         _maxMineSize,
237         _chipSize,
238         _firstChipBonus,
239         _chipSpeed
240     ) public {
241         
242         // variable setting
243         mineCount = _mineCount;
244         minMineSize = _minMineSize;
245         maxMineSize = _maxMineSize;
246         chipSize = _chipSize;
247         firstChipBonus = _firstChipBonus;
248         chipSpeed = _chipSpeed;
249 
250         // other variable initialization
251         activeMine = 0;
252         mineSize = minMineSize;
253         firstChip = true;
254     }
255 
256     function _resetMine() internal {
257         activeMine = random() % mineCount;
258         mineSize = random() % (maxMineSize - minMineSize + 1) + minMineSize;
259         firstChip = true;
260     }
261 
262     function chip(uint256 mineNumber) public whitelisted {
263         
264         require(mineNumber == activeMine, "Chipped wrong mine");
265         require(now >= lastChipTime[msg.sender] + chipSpeed, "Chipped too fast");
266         
267         uint256 thisChipNoCap = firstChip ? firstChipBonus + chipSize : chipSize;
268         uint256 thisChip = thisChipNoCap > mineSize ? mineSize : thisChipNoCap;
269 
270         if (firstChip) {
271             emit MineFound(msg.sender, activeMine);
272         }
273 
274         mineSize -= thisChip;
275         mintToken(msg.sender, thisChip);
276         lastChipTime[msg.sender] = now;
277         firstChip = false;
278         emit MineChipped(msg.sender, activeMine, thisChip);
279 
280         if (mineSize <= 0) {
281             emit MineExausted(msg.sender, activeMine);
282             _resetMine();
283         }
284     }
285 
286     function setParameters(
287         uint256 _mineCount,
288         uint256 _minMineSize,
289         uint256 _maxMineSize,
290         uint256 _chipSize,
291         uint256 _firstChipBonus,
292         uint _chipSpeed
293     ) onlyOwner validMineParameters(
294         _mineCount,
295         _minMineSize,
296         _maxMineSize,
297         _chipSize,
298         _firstChipBonus,
299         _chipSpeed
300     ) public {
301         mineCount = _mineCount;
302         minMineSize = _minMineSize;
303         maxMineSize = _maxMineSize;
304         chipSize = _chipSize;
305         firstChipBonus = _firstChipBonus;
306         chipSpeed = _chipSpeed;
307     }
308 
309     function mintToken(address target, uint256 mintedAmount) internal {
310         balanceOf[target] += mintedAmount;
311         totalSupply += mintedAmount;
312         emit Transfer(this, target, mintedAmount);
313     }
314 
315     // adapted from https://medium.com/@promentol/lottery-smart-contract-can-we-generate-random-numbers-in-solidity-4f586a152b27
316     function random() internal view returns (uint256) {
317         return uint256(keccak256(
318             abi.encodePacked(block.timestamp, block.difficulty)
319         ));
320     }
321 
322 }