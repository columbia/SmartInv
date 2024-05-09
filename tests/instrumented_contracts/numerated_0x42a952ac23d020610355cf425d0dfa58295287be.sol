1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a==0) {
6             return 0;
7         }
8         uint c = a * b;
9         require(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b > 0);
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a);
24         return c;
25     }
26 }
27 
28 contract owned {
29     address public owner;
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         owner = newOwner;
42     }
43 }
44 
45 
46 contract DBTBase {
47     using SafeMath for uint256;
48     // Public variables of the token
49     string public name;
50     string public symbol;
51     uint8 public decimals = 12;
52     // 18 decimals is the strongly suggested default, avoid changing it
53     uint256 public totalSupply;
54 
55     // This creates an array with all balances
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     // This generates a public event on the blockchain that will notify clients
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     // This notifies clients about the amount burnt
63     event Burn(address indexed from, uint256 value);
64     
65     event Approved(address indexed from,address spender, uint256 value);
66     /**
67      * Constrctor function
68      *
69      * Initializes contract with initial supply tokens to the creator of the contract
70      */
71     constructor(
72         uint256 initialSupply,
73         string tokenName,
74         string tokenSymbol
75     ) public {
76         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
78         name = tokenName;                                   // Set the name for display purposes
79         symbol = tokenSymbol;                               // Set the symbol for display purposes
80     }
81 
82     /**
83      * Internal transfer, only can be called by this contract
84      */
85     function _transfer(address _from, address _to, uint _value) internal {
86         // Prevent transfer to 0x0 address. Use burn() instead
87         require(_to != 0x0);
88         // Save this for an assertion in the future
89         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
90         // Subtract from the sender
91         balanceOf[_from] = balanceOf[_from].sub(_value);
92         // Add the same to the recipient
93         balanceOf[_to] = balanceOf[_to].add(_value);
94         emit Transfer(_from, _to, _value);
95         // Asserts are used to use static analysis to find bugs in your code. They should never fail
96         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
97     }
98 
99     /**
100      * Transfer tokens
101      *
102      * Send `_value` tokens to `_to` from your account
103      *
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transfer(address _to, uint256 _value) public {
108         _transfer(msg.sender, _to, _value);
109     }
110 
111     /**
112      * Transfer tokens from other address
113      *
114      * Send `_value` tokens to `_to` in behalf of `_from`
115      *
116      * @param _from The address of the sender
117      * @param _to The address of the recipient
118      * @param _value the amount to send
119      */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
121         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
122         _transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      */
134     function approve(address _spender, uint256 _value) public
135         returns (bool success) {
136         allowance[msg.sender][_spender] = _value;
137         emit Approved(msg.sender,_spender,_value);
138         return true;
139     }
140 
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
151         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
152         emit Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);    // Check allowance
167         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
168         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
169         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
170         emit Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /******************************************/
176 /*       ADVANCED TOKEN STARTS HERE       */
177 /******************************************/
178 
179 contract DBToken is owned, DBTBase {
180 
181     /* Lock allcoins */
182     mapping (address => bool) public frozenAccount;
183     /* Lock specified number of coins */
184     mapping (address => uint256) public balancefrozen;
185     /*Lock acccout with time and value */
186     mapping (address => uint256[][]) public frozeTimeValue;
187     /* Locked total with time and value*/
188     mapping (address => uint256) public balancefrozenTime;
189 
190 
191     bool public isPausedTransfer = false;
192 
193 
194     /* This generates a public event on the blockchain that will notify clients */
195     event FrozenFunds(address target, bool frozen);
196 
197     event FronzeValue(address target,uint256 value);
198 
199     event FronzeTimeValue(address target,uint256 value);
200 
201     event PauseChanged(bool ispause);
202 
203     /* Initializes contract with initial supply tokens to the creator of the contract */
204     constructor(
205         uint256 initialSupply,
206         string tokenName,
207         string tokenSymbol
208     ) DBTBase(initialSupply, tokenName, tokenSymbol) public {
209         
210     }
211 
212     /* Internal transfer, only can be called by this contract */
213     function _transfer(address _from, address _to, uint _value) internal {
214         require(!isPausedTransfer);
215         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
216         require(balanceOf[_from]>=_value);
217         require(!frozenAccount[_from]);                     // Check if sender is frozen
218         require(!frozenAccount[_to]);                       // Check if recipient is frozen
219         //Check FronzenValue
220         require(balanceOf[_from].sub(_value)>=balancefrozen[_from]);
221 
222         require(accountNoneFrozenAvailable(_from) >=_value);
223 
224         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
225         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
226         emit Transfer(_from, _to, _value);
227     }
228 
229     function pauseTransfer(bool ispause) onlyOwner public {
230         isPausedTransfer = ispause;
231         emit PauseChanged(ispause);
232     }
233 
234     /// @notice Create `mintedAmount` tokens and send it to `target`
235     /// @param target Address to receive the tokens
236     /// @param mintedAmount the amount of tokens it will receive
237     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
238         uint256 newmint=mintedAmount.mul(10 ** uint256(decimals));
239         balanceOf[target] = balanceOf[target].add(newmint);
240         totalSupply = totalSupply.add(newmint);
241        emit Transfer(0, this, mintedAmount);
242        emit Transfer(this, target, mintedAmount);
243     }
244 
245     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
246     /// @param target Address to be frozen
247     /// @param freeze either to freeze it or not
248     function freezeAccount(address target, bool freeze) onlyOwner public {
249         frozenAccount[target] = freeze;
250         emit FrozenFunds(target, freeze);
251     }
252     
253     function freezeAccountTimeAndValue(address target, uint256[] times, uint256[] values) onlyOwner public {
254         require(times.length >=1 );
255         require(times.length == values.length);
256         require(times.length<=10);
257         uint256[2][] memory timevalue=new uint256[2][](10);
258         uint256 lockedtotal=0;
259         for(uint i=0;i<times.length;i++)
260         {
261             uint256 value=values[i].mul(10 ** uint256(decimals));
262             timevalue[i]=[times[i],value];
263             lockedtotal=lockedtotal.add(value);
264         }
265         frozeTimeValue[target] = timevalue;
266         balancefrozenTime[target]=lockedtotal;
267         emit FronzeTimeValue(target,lockedtotal);
268     }
269 
270     function unfreezeAccountTimeAndValue(address target) onlyOwner public {
271 
272         uint256[][] memory lockedTimeAndValue=frozeTimeValue[target];
273         
274         if(lockedTimeAndValue.length>0)
275         {
276            delete frozeTimeValue[target];
277         }
278         balancefrozenTime[target]=0;
279     }
280 
281     function freezeByValue(address target,uint256 value) public onlyOwner {
282        balancefrozen[target]=value.mul(10 ** uint256(decimals));
283        emit FronzeValue(target,value);
284     }
285 
286     function increaseFreezeValue(address target,uint256 value)  onlyOwner public {
287        balancefrozen[target]= balancefrozen[target].add(value.mul(10 ** uint256(decimals)));
288        emit FronzeValue(target,value);
289     }
290 
291     function decreaseFreezeValue(address target,uint256 value) onlyOwner public {
292             uint oldValue = balancefrozen[target];
293             uint newvalue=value.mul(10 ** uint256(decimals));
294             if (newvalue >= oldValue) {
295                 balancefrozen[target] = 0;
296             } else {
297                 balancefrozen[target] = oldValue.sub(newvalue);
298             }
299             
300         emit FronzeValue(target,value);      
301     }
302 
303      function accountNoneFrozenAvailable(address target) public returns (uint256)  {
304         
305         uint256[][] memory lockedTimeAndValue=frozeTimeValue[target];
306 
307         uint256 avail=0;
308        
309         if(lockedTimeAndValue.length>0)
310         {
311            uint256 unlockedTotal=0;
312            uint256 now1 = block.timestamp;
313            uint256 lockedTotal=0;           
314            for(uint i=0;i<lockedTimeAndValue.length;i++)
315            {
316                
317                uint256 unlockTime = lockedTimeAndValue[i][0];
318                uint256 unlockvalue=lockedTimeAndValue[i][1];
319                
320                if(now1>=unlockTime && unlockvalue>0)
321                {
322                   unlockedTotal=unlockedTotal.add(unlockvalue);
323                }
324                if(unlockvalue>0)
325                {
326                    lockedTotal=lockedTotal.add(unlockvalue);
327                }
328            }
329            //checkunlockvalue
330 
331            if(lockedTotal > unlockedTotal)
332            {
333                balancefrozenTime[target]=lockedTotal.sub(unlockedTotal);
334            }
335            else 
336            {
337                balancefrozenTime[target]=0;
338            }
339            
340            if(balancefrozenTime[target]==0)
341            {
342               delete frozeTimeValue[target];
343            }
344            if(balanceOf[target]>balancefrozenTime[target])
345            {
346                avail=balanceOf[target].sub(balancefrozenTime[target]);
347            }
348            else
349            {
350                avail=0;
351            }
352            
353         }
354         else
355         {
356             avail=balanceOf[target];
357         }
358 
359         return avail ;
360     }
361 
362 
363 }