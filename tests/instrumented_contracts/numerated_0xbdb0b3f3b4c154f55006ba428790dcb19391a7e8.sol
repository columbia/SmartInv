1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 
48   function assert(bool assertion) internal {
49     if (!assertion) {
50       throw;
51     }
52   }
53 }
54 
55 
56 /*
57  * Ownable
58  *
59  * Base contract with an owner.
60  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
61  */
62 contract Ownable {
63   address public owner;
64 
65   function Ownable() {
66     owner = msg.sender;
67   }
68 
69   modifier onlyOwner() {
70     if (msg.sender != owner) {
71       throw;
72     }
73     _;
74   }
75 
76   function transferOwnership(address newOwner) onlyOwner {
77     if (newOwner != address(0)) {
78       owner = newOwner;
79     }
80   }
81 }
82 
83 
84 /*
85  * ERC20Basic
86  * Simpler version of ERC20 interface
87  * see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20Basic {
90   uint public totalSupply;
91   function balanceOf(address who) constant returns (uint);
92   function transfer(address to, uint value);
93   event Transfer(address indexed from, address indexed to, uint value);
94 }
95 
96 
97 /*
98  * Basic token
99  * Basic version of StandardToken, with no allowances
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint;
103 
104   mapping(address => uint) balances;
105 
106   /*
107    * Fix for the ERC20 short address attack  
108    */
109   modifier onlyPayloadSize(uint size) {
110      if(msg.data.length < size + 4) {
111        throw;
112      }
113      _;
114   }
115 
116   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120   }
121 
122   function balanceOf(address _owner) constant returns (uint balance) {
123     return balances[_owner];
124   }
125 }
126 
127 
128 /**
129  * @title FundableToken - accounts for funds to stand behind it
130  * @author Dmitry Kochin <k@ubermensch.store>
131  * We need to store this data to be able to know how much funds are standing behind the tokens
132  * It may come handy in token transformation. For example if prefund would not be successful we
133  * will be able to refund all the invested money
134  */
135 contract FundableToken is BasicToken {
136     ///Invested funds
137     mapping(address => uint) public funds;
138 
139     ///Total funds behind the tokens
140     uint public totalFunds;
141 
142     function FundableToken() {}
143 }
144 
145 
146 /**
147  * Transform agent transfers tokens to a new contract. It may transform them to another tokens or refund
148  * Transform agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
149  */
150 contract TransformAgent {
151     ///The original supply of tokens to be transformed
152     uint256 public originalSupply;
153     ///The original funds behind the tokens to be transformed
154     uint256 public originalFunds;
155 
156     /** Interface marker */
157     function isTransformAgent() public constant returns (bool) {
158         return true;
159     }
160 
161     function transformFrom(address _from, uint256 _tokens, uint256 _funds) public;
162 
163 }
164 
165 
166 /**
167  * A token transform mechanism where users can opt-in amount of tokens to the next smart contract revision.
168  *
169  * First envisioned by Golem and Lunyr projects.
170  */
171 contract TransformableToken is FundableToken, Ownable {
172 
173     /** The next contract where the tokens will be migrated. */
174     TransformAgent public transformAgent;
175 
176     /** How many tokens we have transformed by now. */
177     uint256 public totalTransformedTokens;
178 
179     /**
180      * Transform states.
181      *
182      * - NotAllowed: The child contract has not reached a condition where the transform can bgun
183      * - WaitingForAgent: Token allows transform, but we don't have a new agent yet
184      * - ReadyToTransform: The agent is set, but not a single token has been transformed yet, so we
185             still have a chance to reset agent to another value
186      * - Transforming: Transform agent is set and the balance holders can transform their tokens
187      *
188      */
189     enum TransformState {Unknown, NotAllowed, WaitingForAgent, ReadyToTransform, Transforming}
190 
191     /**
192      * Somebody has transformd some of his tokens.
193      */
194     event Transform(address indexed _from, address indexed _to, uint256 _tokens, uint256 _funds);
195 
196     /**
197      * New transform agent available.
198      */
199     event TransformAgentSet(address agent);
200 
201     /**
202      * Allow the token holder to transform all of their tokens to a new contract.
203      */
204     function transform() public {
205 
206         TransformState state = getTransformState();
207         require(state == TransformState.ReadyToTransform || state == TransformState.Transforming);
208 
209         uint tokens = balances[msg.sender];
210         uint investments = funds[msg.sender];
211         require(tokens > 0); // Validate input value.
212 
213         balances[msg.sender] = 0;
214         funds[msg.sender] = 0;
215 
216         // Take tokens out from circulation
217         totalSupply = totalSupply.sub(tokens);
218         totalFunds = totalFunds.sub(investments);
219 
220         totalTransformedTokens = totalTransformedTokens.add(tokens);
221 
222         // Transform agent reissues the tokens
223         transformAgent.transformFrom(msg.sender, tokens, investments);
224         Transform(msg.sender, transformAgent, tokens, investments);
225 
226         //Once transformation is finished the contract is not needed anymore
227         if(totalSupply == 0)
228             selfdestruct(owner);
229     }
230 
231     /**
232      * Set an transform agent that handles
233      */
234     function setTransformAgent(address agent) onlyOwner external {
235         require(agent != 0x0);
236         // Transform has already begun for an agent
237         require(getTransformState() != TransformState.Transforming);
238 
239         transformAgent = TransformAgent(agent);
240 
241         // Bad interface
242         require(transformAgent.isTransformAgent());
243         // Make sure that token supplies match in source and target
244         require(transformAgent.originalSupply() == totalSupply);
245         require(transformAgent.originalFunds() == totalFunds);
246 
247         TransformAgentSet(transformAgent);
248     }
249 
250     /**
251      * Get the state of the token transform.
252      */
253     function getTransformState() public constant returns(TransformState) {
254         if(address(transformAgent) == 0x00) return TransformState.WaitingForAgent;
255         else if(totalTransformedTokens == 0) return TransformState.ReadyToTransform;
256         else return TransformState.Transforming;
257     }
258 }
259 
260 
261 /**
262  * Mintable token
263  *
264  * Simple ERC20 Token example, with mintable token creation
265  * Issue:
266  * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
267  * Based on code by TokenMarketNet:
268  * https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
269  */
270 contract MintableToken is BasicToken {
271     /**
272       Crowdsale contract allowed to mint tokens
273     */
274 
275     function mint(address _to, uint _amount) internal {
276         totalSupply = totalSupply.add(_amount);
277         balances[_to] = balances[_to].add(_amount);
278         //Announce that we have minted some tokens
279         Transfer(0x0, _to, _amount);
280     }
281 }
282 
283 
284 /// @title Token contract - Implements Standard Token Interface with Ubermensch features.
285 /// @author Dmitry Kochin - <k@ubermensch.store>
286 contract UbermenschPrefundToken is MintableToken, TransformableToken {
287     string constant public name = "Ubermensch Prefund";
288     string constant public symbol = "UMP";
289     uint constant public decimals = 8;
290 
291     //The price of 1 token in Ether
292     uint constant public TOKEN_PRICE = 0.0025 * 1 ether;
293     //The maximum number of tokens to be sold in crowdsale
294     uint constant public TOKEN_CAP = 20000000 * (10 ** decimals);
295 
296     uint public investorCount;
297     address public multisigWallet;
298     bool public stopped;
299 
300     // A new investment was made
301     event Invested(address indexed investor, uint weiAmount, uint tokenAmount);
302 
303     function UbermenschPrefundToken(address multisig){
304         //We require that the owner should be multisig wallet
305         //Because owner can make important decisions like stopping prefund
306         //and setting TransformAgent
307         //However this contract can be created by any account. After creation
308         //it automatically transfers ownership to multisig wallet
309         transferOwnership(multisig);
310         multisigWallet = multisig;
311     }
312 
313     modifier onlyActive(){
314         require(!stopped);
315         //Setting the transfer agent effectively stops prefund
316         require(getTransformState() == TransformState.WaitingForAgent);
317         _;
318     }
319 
320     /**
321      * Returns bonuses based on the current totalSupply in percents
322      * An investor gets the bonus based on the current totalSupply value
323      * even if the resulting totalSupply after an investment corresponds to different bonus
324      */
325     function getCurrentBonus() public constant returns (uint){
326         if(totalSupply < 7000000 * (10 ** decimals))
327             return 180;
328         if(totalSupply < 14000000 * (10 ** decimals))
329             return 155;
330         return 140;
331     }
332 
333     /// @dev main function to buy tokens to specified address
334     /// @param to The address of token recipient
335     function invest(address to) onlyActive public payable {
336         uint amount = msg.value;
337         //Bonuses are in percents so the final value must be divided by 100
338         uint tokenAmount = getCurrentBonus().mul(amount).mul(10 ** decimals / 100).div(TOKEN_PRICE);
339 
340         require(tokenAmount >= 0);
341 
342         if(funds[to] == 0) {
343             // A new investor
344             ++investorCount;
345         }
346 
347         // Update investor
348         funds[to] = funds[to].add(amount);
349         totalFunds = totalFunds.add(amount);
350 
351         //mint tokens
352         mint(to, tokenAmount);
353 
354         //We also should not break the token cap
355         //This is exactly "require' and not 'assert' because it depends on msg.value - a user supplied parameters
356         //While 'assert' should correspond to a broken business logic
357         require(totalSupply <= TOKEN_CAP);
358 
359         // Pocket the money
360         multisigWallet.transfer(amount);
361 
362         // Tell us invest was success
363         Invested(to, amount, tokenAmount);
364     }
365 
366     function buy() public payable {
367         invest(msg.sender);
368     }
369 
370     function transfer(address _to, uint _value){
371         throw; //This prefund token can not be transferred
372     }
373 
374     //Stops the crowdsale forever
375     function stop() onlyOwner {
376         stopped = true;
377     }
378 
379     //We'll try to accept sending ether on the contract address, hope the gas supplied would be enough
380     function () payable{
381         buy();
382     }
383 }