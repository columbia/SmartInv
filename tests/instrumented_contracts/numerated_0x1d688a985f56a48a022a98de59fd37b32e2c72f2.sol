1 pragma solidity ^0.4.16;
2 
3 
4 contract ERC20Token {
5     event Transfer(address indexed from, address indexed _to, uint256 _value);
6 	event Approval(address indexed owner, address indexed _spender, uint256 _value);
7 
8     mapping (address => uint256) public balanceOf;
9     mapping (address => mapping (address => uint256)) public allowance;
10 
11     /**
12      * Internal transfer, only can be called by this contract
13      */
14     function _transfer(address _from, address _to, uint _value) internal {
15         require(_to != 0x0 && _to != address(this));
16         require(balanceOf[_from] >= _value);
17         require(balanceOf[_to] + _value > balanceOf[_to]);
18         uint previousBalances = balanceOf[_from] + balanceOf[_to];
19         balanceOf[_from] -= _value;
20         balanceOf[_to] += _value;
21         Transfer(_from, _to, _value);
22         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
23     }
24 
25     /**
26      * Transfer tokens
27      *
28      * Send `_value` tokens to `_to` from your account
29      *
30      * @param _to The address of the recipient
31      * @param _value the amount to send
32      */
33     function transfer(address _to, uint256 _value) public returns (bool success) {
34         _transfer(msg.sender, _to, _value);
35         return true;
36     }
37 
38     /**
39      * Transfer tokens from other address
40      *
41      * Send `_value` tokens to `_to` in behalf of `_from`
42      *
43      * @param _from The address of the sender
44      * @param _to The address of the recipient
45      * @param _value the amount to send
46      */
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48         require(_value <= allowance[_from][msg.sender]);
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }
53 
54     /**
55      * Set allowance for other address
56      *
57      * Allows `_spender` to spend no more than `_value` tokens in your behalf
58      *
59      * @param _spender The address authorized to spend
60      * @param _value the max amount they can spend
61      */
62     function approve(address _spender, uint256 _value) public returns (bool success) {
63         allowance[msg.sender][_spender] = _value;
64         return true;
65     }
66 }
67 
68 
69 contract Owned {
70     address public owner;
71 
72     /**
73      * Construct the Owned contract and
74      * make the sender the owner
75      */
76     function Owned() public {
77         owner = msg.sender;
78     }
79 
80     /**
81      * Restrict to the owner only
82      */
83     modifier onlyOwner {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     /**
89      * Transfer the ownership to another address
90      *
91      * @param newOwner the new owner's address
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         owner = newOwner;
95     }
96 }
97 
98 
99 contract Beercoin is ERC20Token, Owned {
100     event Produce(uint256 value, string caps);
101 	event Burn(uint256 value);
102 
103     string public name = "Beercoin";
104     string public symbol = "?";
105 	uint8 public decimals = 18;
106 	uint256 public totalSupply = 15496000000 * 10 ** uint256(decimals);
107 
108     // In addition to the initial total supply of 15496000000 Beercoins,
109     // more Beercoins will only be added by scanning bottle caps.
110     // 20800000000 bottle caps will be eventually produced.
111     //
112     // Within 10000 bottle caps,
113     // 1 (i.e. every 10000th cap in total) has a value of 10000 ("Diamond") Beercoins,
114     // 9 (i.e. every 1000th cap in total) have a value of 100 ("Gold") Beercoins,
115     // 990 (i.e. every 10th cap in total) have a value of 10 ("Silver") Beercoins,
116     // 9000 (i.e. every remaining cap) have a value of 1 ("Bronze") Beercoin.
117     //
118     // Therefore one bottle cap has an average Beercoin value of
119     // (1 * 10000 + 9 * 100 + 990 * 10 + 9000 * 1) / 10000 = 2.98.
120     //
121     // This means the Beercoin value of all bottle caps that
122     // will be produced in total is 20800000000 * 2.98 = 61984000000.
123     uint256 public unproducedCaps = 20800000000;
124     uint256 public producedCaps = 0;
125 
126     // Stores whether users disallow the owner to
127     // pull Beercoins for the use of redemption.
128     mapping (address => bool) public redemptionLocked;
129 
130     /**
131      * Construct the Beercoin contract and
132      * assign the initial supply to the owner.
133      */
134     function Beercoin() public {
135 		balanceOf[owner] = totalSupply;
136     }
137 
138     /**
139      * Lock or unlock the redemption functionality
140      *
141      * If a user doesn't want to redeem Beercoins on the owner's
142      * website and doesn't trust the owner, the owner's capability
143      * of pulling Beercoin from the user's account can be locked
144      *
145      * @param lock whether to lock the redemption capability or not
146      */
147     function lockRedemption(bool lock) public returns (bool success) {
148         redemptionLocked[msg.sender] = lock;
149         return true;
150     }
151 
152     /**
153      * Generate a sequence of bottle cap values to be used
154      * for production and send the respective total Beercoin
155      * value to the contract for keeping until a scan is recognized
156      *
157      * We hereby declare that this function is called if and only if
158      * we need to generate codes intended for beer bottle production
159      *
160      * @param numberOfCaps the number of bottle caps to be produced
161      */
162 	function produce(uint256 numberOfCaps) public onlyOwner returns (bool success) {
163         require(numberOfCaps <= unproducedCaps);
164 
165         uint256 value = 0;
166         bytes memory caps = bytes(new string(numberOfCaps));
167         
168         for (uint256 i = 0; i < numberOfCaps; ++i) {
169             uint256 currentCoin = producedCaps + i;
170 
171             if (currentCoin % 10000 == 0) {
172                 value += 10000;
173                 caps[i] = "D";
174             } else if (currentCoin % 1000 == 0) {
175                 value += 100;
176                 caps[i] = "G";
177             } else if (currentCoin % 10 == 0) {
178                 value += 10;
179                 caps[i] = "S";
180             } else {
181                 value += 1;
182                 caps[i] = "B";
183             }
184         }
185 
186         unproducedCaps -= numberOfCaps;
187         producedCaps += numberOfCaps;
188 
189         value = value * 10 ** uint256(decimals);
190         totalSupply += value;
191         balanceOf[this] += value;
192         Produce(value, string(caps));
193 
194         return true;
195 	}
196 
197 	/**
198      * Grant Beercoins to a user who scanned a bottle cap code
199      *
200      * We hereby declare that this function is called if and only if
201 	 * our server registers a valid code scan by the given user
202      *
203      * @param user the address of the user who scanned a codes
204      * @param cap a bottle cap value ("D", "G", "S", or "B")
205      */
206 	function scan(address user, byte cap) public onlyOwner returns (bool success) {
207         if (cap == "D") {
208             _transfer(this, user, 10000 * 10 ** uint256(decimals));
209         } else if (cap == "G") {
210             _transfer(this, user, 100 * 10 ** uint256(decimals));
211         } else if (cap == "S") {
212             _transfer(this, user, 10 * 10 ** uint256(decimals));
213         } else {
214             _transfer(this, user, 1 * 10 ** uint256(decimals));
215         }
216         
217         return true;
218 	}
219 
220     /**
221      * Grant Beercoins to users who scanned bottle cap codes
222      *
223      * We hereby declare that this function is called if and only if
224 	 * our server registers valid code scans by the given users
225      *
226      * @param users the addresses of the users who scanned a codes
227      * @param caps bottle cap values ("D", "G", "S", or "B")
228      */
229 	function scanMany(address[] users, byte[] caps) public onlyOwner returns (bool success) {
230         require(users.length == caps.length);
231 
232         for (uint16 i = 0; i < users.length; ++i) {
233             scan(users[i], caps[i]);
234         }
235 
236         return true;
237 	}
238 
239 	/**
240      * Redeem tokens when the will to do so has been
241 	 * stated within the user interface of a Beercoin
242 	 * redemption system
243 	 *
244 	 * The owner calls this on behalf of the redeeming user
245 	 * so the latter does not need to pay transaction fees
246 	 * when redeeming
247 	 *
248 	 * We hereby declare that this function is called if and only if
249      * a user deliberately wants to redeem Beercoins
250      *
251      * @param user the address of the user who wants to redeem
252      * @param value the amount to redeem
253      */
254     function redeem(address user, uint256 value) public onlyOwner returns (bool success) {
255         require(redemptionLocked[user] == false);
256         _transfer(user, owner, value);
257         return true;
258     }
259 
260     /**
261      * Redeem tokens when the will to do so has been
262 	 * stated within the user interface of a Beercoin
263 	 * redemption system
264 	 *
265 	 * The owner calls this on behalf of the redeeming users
266 	 * so the latter do not need to pay transaction fees
267 	 * when redeeming
268 	 *
269 	 * We hereby declare that this function is called if and only if
270      * users deliberately want to redeem Beercoins
271      *
272      * @param users the addresses of the users who want to redeem
273      * @param values the amounts to redeem
274      */
275     function redeemMany(address[] users, uint256[] values) public onlyOwner returns (bool success) {
276         require(users.length == values.length);
277 
278         for (uint16 i = 0; i < users.length; ++i) {
279             redeem(users[i], values[i]);
280         }
281 
282         return true;
283     }
284 
285     /**
286      * Transfer Beercoins to multiple recipients
287      *
288      * @param recipients the addresses of the recipients
289      * @param values the amounts to send
290      */
291     function transferMany(address[] recipients, uint256[] values) public onlyOwner returns (bool success) {
292         require(recipients.length == values.length);
293 
294         for (uint16 i = 0; i < recipients.length; ++i) {
295             transfer(recipients[i], values[i]);
296         }
297 
298         return true;
299     }
300 
301     /**
302      * Destroy Beercoins by removing them from the system irreversibly
303      *
304      * @param value the amount of Beercoins to burn
305      */
306     function burn(uint256 value) public onlyOwner returns (bool success) {
307         require(balanceOf[msg.sender] >= value);
308         balanceOf[msg.sender] -= value;
309         totalSupply -= value;
310 		Burn(value);
311         return true;
312     }
313 }