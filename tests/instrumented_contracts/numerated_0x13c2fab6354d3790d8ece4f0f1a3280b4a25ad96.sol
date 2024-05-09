1 pragma solidity ^0.4.18;
2 
3  /*
4  * Contract that is working with ERC223 tokens
5  * https://github.com/ethereum/EIPs/issues/223
6  */
7 
8 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
9 contract ERC223ReceivingContract {
10 
11     /// @dev Function that is called when a user or another contract wants to transfer funds.
12     /// @param _from Transaction initiator, analogue of msg.sender
13     /// @param _value Number of tokens to transfer.
14     /// @param _data Data containig a function signature and/or parameters
15     function tokenFallback(address _from, uint256 _value, bytes _data) public;
16 }
17 
18 /// @title Base Token contract - Functions to be implemented by token contracts.
19 contract Token {
20     /*
21      * Implements ERC 20 standard.
22      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
23      * https://github.com/ethereum/EIPs/issues/20
24      *
25      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
26      *  https://github.com/ethereum/EIPs/issues/223
27      */
28 
29     /*
30      * ERC 20
31      */
32     function balanceOf(address _owner) public constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35     function approve(address _spender, uint256 _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37     function burn(uint num) public;
38 
39     /*
40      * ERC 223
41      */
42     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
43 
44     /*
45      * Events
46      */
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49     event Burn(address indexed _burner, uint _value);
50 
51     // There is no ERC223 compatible Transfer event, with `_data` included.
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   /**
83   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /// @title PHI ERC223 Token with burn functionality
101 contract PhiToken is Token {
102 
103     /*
104      *  Terminology:
105      *  1 token unit = PHI
106      *  1 token = PHI = sphi * multiplier
107      *  multiplier set from token's number of decimals (i.e. 10 ** decimals)
108      */
109 
110     /*  
111      *  Section 1
112      *  - Variables
113      */
114     /// Token metadata
115     string constant public name = "PHI Token";
116     string constant public symbol = "PHI";
117     uint8 constant public decimals = 18;
118     using SafeMath for uint;
119     uint constant multiplier = 10 ** uint(decimals);
120 
121     mapping (address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123 
124     /*
125      * This is a slight change to the ERC20 base standard.
126      * function totalSupply() constant returns (uint256 supply);
127      * is replaced with:
128      * uint256 public totalSupply;
129      * This automatically creates a getter function for the totalSupply.
130      * This is moved to the base contract since public getter functions are not
131      * currently recognised as an implementation of the matching abstract
132      * function by the compiler.
133      *
134      * Hardcoded total supply (in sphi), it can be decreased only by burning tokens
135      */
136     uint256 public totalSupply =  24157817 * multiplier;
137 
138     /// Keep track of assigned tokens at deploy
139     bool initialTokensAssigned = false;
140 
141     /// Store pre-ico and ico address
142     address public PRE_ICO_ADDR;
143     address public ICO_ADDR;
144 
145     /// Where tokens for team will be sent, used also for function-auth
146     address public WALLET_ADDR;
147 
148     /// How long the tokens should be locked for transfers
149     uint public lockTime;
150 
151     /* 
152      *  Section 2
153      *  - modifiers
154      */
155     /// Do not allow transfers if lockTime is active, allow only
156     /// pre-ico and ico if it is (to distribute tokens)
157     modifier onlyIfLockTimePassed () {
158         require(now > lockTime || (msg.sender == PRE_ICO_ADDR || msg.sender == ICO_ADDR));
159         _;
160     }
161 
162     /* 
163      *  Section 3
164      *  - Events
165      */
166     event Deployed(uint indexed _total_supply);
167 
168     /*
169      *  Public functions
170      */
171     /// @dev Contract constructor function, assigns tokens to ico, pre-ico,
172     /// wallet address and pre sale investors.
173     /// @param ico_address Address of the ico contract.
174     /// @param pre_ico_address Address of the pre-ico contract.
175     /// @param wallet_address Address of tokens to be sent to the PHI team.
176     /// @param _lockTime Epoch Timestamp describing how long the tokens should be
177     /// locked for transfers.
178     function PhiToken(
179         address ico_address,
180         address pre_ico_address,
181         address wallet_address,
182         uint _lockTime)
183         public
184     {
185         // Check destination address
186         require(ico_address != 0x0);
187         require(pre_ico_address != 0x0);
188         require(wallet_address != 0x0);
189         require(ico_address != pre_ico_address && wallet_address != ico_address);
190         require(initialTokensAssigned == false);
191         // _lockTime should be in the future
192         require(_lockTime > now);
193         lockTime = _lockTime;
194 
195         WALLET_ADDR = wallet_address;
196 
197         // Check total supply
198         require(totalSupply > multiplier);
199 
200         // tokens to be assigned to pre-ico, ico and wallet address
201         uint initAssign = 0;
202 
203         // to be sold in the ico
204         initAssign += assignTokens(ico_address, 7881196 * multiplier);
205         ICO_ADDR = ico_address;
206         // to be sold in the pre-ico
207         initAssign += assignTokens(pre_ico_address, 3524578 * multiplier);
208         PRE_ICO_ADDR = pre_ico_address;
209         // Reserved for the team, airdrop, marketing, business etc..
210         initAssign += assignTokens(wallet_address, 9227465 * multiplier);
211 
212         // Pre sale allocations
213         uint presaleTokens = 0;
214         presaleTokens += assignTokens(address(0x72B16DC0e5f85aA4BBFcE81687CCc9D6871C2965), 230387 * multiplier);
215         presaleTokens += assignTokens(address(0x7270cC02d88Ea63FC26384f5d08e14EE87E75154), 132162 * multiplier);
216         presaleTokens += assignTokens(address(0x25F92f21222969BB0b1f14f19FBa770D30Ff678f), 132162 * multiplier);
217         presaleTokens += assignTokens(address(0xAc99C59D3353a34531Fae217Ba77139BBe4eDBb3), 443334 * multiplier);
218         presaleTokens += assignTokens(address(0xbe41D37eB2d2859143B9f1D29c7BC6d7e59174Da), 970826500000000000000000); // 970826.5 PHI
219         presaleTokens += assignTokens(address(0x63e9FA0e43Fcc7C702ed5997AfB8E215C5beE3c9), 970826500000000000000000); // 970826.5 PHI
220         presaleTokens += assignTokens(address(0x95c67812c5C41733419aC3b1916d2F282E7A15A4), 396486 * multiplier);
221         presaleTokens += assignTokens(address(0x1f5d30BB328498fF6E09b717EC22A9046C41C257), 20144 * multiplier);
222         presaleTokens += assignTokens(address(0x0a1ac564e95dAEDF8d454a3593b75CCdd474fc42), 19815 * multiplier);
223         presaleTokens += assignTokens(address(0x0C5448D5bC4C40b4d2b2c1D7E58E0541698d3e6E), 19815 * multiplier);
224         presaleTokens += assignTokens(address(0xFAe11D521538F067cE0B13B6f8C929cdEA934D07), 75279 * multiplier);
225         presaleTokens += assignTokens(address(0xEE51304603887fFF15c6d12165C6d96ff0f0c85b), 45949 * multiplier);
226         presaleTokens += assignTokens(address(0xd7Bab04C944faAFa232d6EBFE4f60FF8C4e9815F), 6127 * multiplier);
227         presaleTokens += assignTokens(address(0x603f39C81560019c8360F33bA45Bc1E4CAECb33e), 45949 * multiplier);
228         presaleTokens += assignTokens(address(0xBB5128f1093D1aa85F6d7D0cC20b8415E0104eDD), 15316 * multiplier);
229         
230         initialTokensAssigned = true;
231 
232         Deployed(totalSupply);
233 
234         assert(presaleTokens == 3524578 * multiplier);
235         assert(totalSupply == (initAssign.add(presaleTokens)));
236     }
237 
238     /// @dev Helper function to assign tokens (team, pre-sale, ico, pre-ico etc..).
239     /// @notice It will be automatically called on deploy.
240     /// @param addr Receiver of the tokens.
241     /// @param amount Tokens (in sphi).
242     /// @return Tokens assigned
243     function assignTokens (address addr, uint amount) internal returns (uint) {
244         require(addr != 0x0);
245         require(initialTokensAssigned == false);
246         balances[addr] = amount;
247         Transfer(0x0, addr, balances[addr]);
248         return balances[addr];
249     }
250 
251     /// @notice Allows `msg.sender` to simply destroy `_value` token units (sphi). This means the total
252     /// token supply will decrease.
253     /// @dev Allows to destroy token units (sphi).
254     /// @param _value Number of token units (sphi) to burn.
255     function burn(uint256 _value) public onlyIfLockTimePassed {
256         require(_value > 0);
257         require(balances[msg.sender] >= _value);
258         require(totalSupply >= _value);
259 
260         uint pre_balance = balances[msg.sender];
261         address burner = msg.sender;
262         balances[burner] = balances[burner].sub(_value);
263         totalSupply = totalSupply.sub(_value);
264         Burn(burner, _value);
265         Transfer(burner, 0x0, _value);
266         assert(balances[burner] == pre_balance.sub(_value));
267     }
268 
269     /*
270      * Token functions
271      */
272 
273     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
274     /// @dev Transfers sender's tokens to a given address. Returns success.
275     /// @param _to Address of token receiver.
276     /// @param _value Number of tokens to transfer.
277     /// @return Returns success of function call.
278     function transfer(address _to, uint256 _value) public onlyIfLockTimePassed returns (bool) {
279         require(_to != 0x0);
280         require(_to != address(this));
281         require(balances[msg.sender] >= _value);
282         require(balances[_to].add(_value) >= balances[_to]);
283 
284         balances[msg.sender] = balances[msg.sender].sub(_value);
285         balances[_to] = balances[_to].add(_value);
286 
287         Transfer(msg.sender, _to, _value);
288 
289         return true;
290     }
291 
292     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
293     /// tokenFallback if sender is a contract.
294     /// @dev Function that is called when a user or another contract wants to transfer funds.
295     /// @param _to Address of token receiver.
296     /// @param _value Number of tokens to transfer.
297     /// @param _data Data to be sent to tokenFallback
298     /// @return Returns success of function call.
299     function transfer(
300         address _to,
301         uint256 _value,
302         bytes _data)
303         public
304         onlyIfLockTimePassed
305         returns (bool)
306     {
307         require(transfer(_to, _value));
308 
309         uint codeLength;
310 
311         assembly {
312             // Retrieve the size of the code on target address, this needs assembly.
313             codeLength := extcodesize(_to)
314         }
315 
316         if (codeLength > 0) {
317             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
318             receiver.tokenFallback(msg.sender, _value, _data);
319         }
320 
321         return true;
322     }
323 
324     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
325     /// @dev Allows for an approved third party to transfer tokens from one
326     /// address to another. Returns success.
327     /// @param _from Address from where tokens are withdrawn.
328     /// @param _to Address to where tokens are sent.
329     /// @param _value Number of tokens to transfer.
330     /// @return Returns success of function call.
331     function transferFrom(address _from, address _to, uint256 _value)
332         public
333         onlyIfLockTimePassed
334         returns (bool)
335     {
336         require(_from != 0x0);
337         require(_to != 0x0);
338         require(_to != address(this));
339         require(balances[_from] >= _value);
340         require(allowed[_from][msg.sender] >= _value);
341         require(balances[_to].add(_value) >= balances[_to]);
342 
343         balances[_to] = balances[_to].add(_value);
344         balances[_from] = balances[_from].sub(_value);
345         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
346 
347         Transfer(_from, _to, _value);
348 
349         return true;
350     }
351 
352     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
353     /// @dev Sets approved amount of tokens for spender. Returns success.
354     /// @param _spender Address of allowed account.
355     /// @param _value Number of approved tokens.
356     /// @return Returns success of function call.
357     function approve(address _spender, uint256 _value) public onlyIfLockTimePassed returns (bool) {
358         require(_spender != 0x0);
359 
360         // To change the approve amount you first have to reduce the addresses`
361         // allowance to zero by calling `approve(_spender, 0)` if it is not
362         // already 0 to mitigate the race condition described here:
363         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
364         require(_value == 0 || allowed[msg.sender][_spender] == 0);
365 
366         allowed[msg.sender][_spender] = _value;
367         Approval(msg.sender, _spender, _value);
368         return true;
369     }
370 
371     /*
372      * Read functions
373      */
374     /// @dev Returns number of allowed tokens that a spender can transfer on
375     /// behalf of a token owner.
376     /// @param _owner Address of token owner.
377     /// @param _spender Address of token spender.
378     /// @return Returns remaining allowance for spender.
379     function allowance(address _owner, address _spender)
380         constant
381         public
382         returns (uint256)
383     {
384         return allowed[_owner][_spender];
385     }
386 
387     /// @dev Returns number of tokens owned by the given address.
388     /// @param _owner Address of token owner.
389     /// @return Returns balance of owner.
390     function balanceOf(address _owner) constant public returns (uint256) {
391         return balances[_owner];
392     }
393 
394 }