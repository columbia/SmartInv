1 pragma solidity 0.4.25;
2 
3 
4 // ----------------------------------------------------------------------------
5 // ERC Token Standard #20 Interface
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
7 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
8 // 
9 // ----------------------------------------------------------------------------
10 contract ERC20Interface {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function allowance(address approver, address spender) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17 
18     // solhint-disable-next-line no-simple-event-func-name
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed approver, address indexed spender, uint256 value);
21 }
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  *
28  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two numbers, throws on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         if (a == 0) {
36             return 0;
37         }
38         uint256 c = a * b;
39         assert(c / a == b);
40         return c;
41     }
42 
43     /**
44     * @dev Integer division of two numbers, truncating the quotient.
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // assert(b > 0); // Solidity automatically throws when dividing by 0
48         // uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return a / b;
51     }
52 
53     /**
54     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55     */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     /**
62     * @dev Adds two numbers, throws on overflow.
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         assert(c >= a);
67         return c;
68     }
69 }
70 
71 /**
72  * A version of the Trustee contract (https://www.investopedia.com/terms/r/regulationd.asp) with the
73  * added role of Transfer Agent to perform specialised actions.
74  *
75  * Part of the kycware.com ICO by Horizon-Globex.com of Switzerland.
76  *
77  * Author: Horizon Globex GmbH Development Team
78  */
79 contract Trustee {
80     using SafeMath for uint256;
81 
82     /**
83      * The details of the tokens bought.
84      */
85     struct Holding {
86         // The number of tokens purchased.
87         uint256 quantity;
88 
89         // The date and time when the tokens are no longer restricted.
90         uint256 releaseDate;
91 
92         // Whether the holder is an affiliate of the company or not.
93         bool isAffiliate;
94     }
95 
96     // Restrict functionality to the creator of the contract - the token issuer.
97     modifier onlyIssuer {
98         require(msg.sender == issuer, "You must be issuer/owner to execute this function.");
99         _;
100     }
101 
102     // Restrict functionaly to the official Transfer Agent.
103     modifier onlyTransferAgent {
104         require(msg.sender == transferAgent, "You must be the Transfer Agent to execute this function.");
105         _;
106     }
107 
108     // The creator/owner of this contract, set at contract creation to the address that created the contract.
109     address public issuer;
110 
111     // The collection of all held tokens by user.
112     mapping(address => Holding) public heldTokens;
113 
114     // The ERC20 Token contract, needed to transfer tokens back to their original owner when the holding
115     // period ends.
116     address public tokenContract;
117 
118     // The authorised Transfer Agent who performs specialist actions on this contract.
119     address public transferAgent;
120 
121     // Number of seconds in one standard year.
122     uint256 public oneYear = 0;//31536000;
123 
124     // Emitted when someone subject to Regulation D buys tokens and they are held here.
125     event TokensHeld(address indexed who, uint256 tokens, uint256 releaseDate);
126 
127     // Emitted when the tokens have passed their release date and have been returned to the original owner.
128     event TokensReleased(address indexed who, uint256 tokens);
129 
130     // The Transfer Agent moved tokens from an address to a new wallet, for escheatment obligations.
131     event TokensTransferred(address indexed from, address indexed to, uint256 tokens);
132 
133     // The Transfer Agent was unable to verify a token holder and needed to push out the release date.
134     event ReleaseDateExtended(address who, uint256 newReleaseDate);
135 
136     // Extra restrictions apply to company affiliates, notify when the status of an address changes.
137     event AffiliateStatusChanged(address who, bool isAffiliate);
138 
139     /**
140      * @notice Create this contract and assign the ERC20 contract where the tokens are returned once the
141      * holding period has complete.
142      *
143      * @param erc20Contract The address of the ERC20 contract.
144      */
145     constructor(address erc20Contract) public {
146         issuer = msg.sender;
147         tokenContract = erc20Contract;
148     }
149 
150     /**
151      * @notice Set the address of the Transfer Agent.
152      */
153     function setTransferAgent(address who) public onlyIssuer {
154         transferAgent = who;
155     }
156 
157     /**
158      * @notice Keep a US Citizen's tokens for one year.
159      *
160      * @param who           The wallet of the US Citizen.
161      * @param quantity      The number of tokens to store.
162      */
163     function hold(address who, uint256 quantity) public onlyIssuer {
164         require(who != 0x0, "The null address cannot own tokens.");
165         require(quantity != 0, "Quantity must be greater than zero.");
166         require(!isExistingHolding(who), "Cannot overwrite an existing holding, use a new wallet.");
167 
168         Holding memory holding = Holding(quantity, block.timestamp+oneYear, false);
169         heldTokens[who] = holding;
170         emit TokensHeld(who, holding.quantity, holding.releaseDate);
171     }
172 	
173     /**
174      * @notice Hold tokens post-ICO with a variable release date on those tokens.
175      *
176      * @param who           The wallet of the US Citizen.
177      * @param quantity      The number of tokens to store.
178 	 * @param addedTime		The number of seconds to add to the current date to calculate the release date.
179      */
180     function postIcoHold(address who, uint256 quantity, uint256 addedTime) public onlyTransferAgent {
181         require(who != 0x0, "The null address cannot own tokens.");
182         require(quantity != 0, "Quantity must be greater than zero.");
183         require(!isExistingHolding(who), "Cannot overwrite an existing holding, use a new wallet.");
184 
185         Holding memory holding = Holding(quantity, block.timestamp+addedTime, false);
186         heldTokens[who] = holding;
187         emit TokensHeld(who, holding.quantity, holding.releaseDate);
188     }
189 
190     /**
191     * @notice Check if a user's holding are eligible for release.
192     *
193     * @param who        The user to check the holding of.
194     * @return           True if can be released, false if not.
195     */
196     function canRelease(address who) public view returns (bool) {
197         Holding memory holding = heldTokens[who];
198         if(holding.releaseDate == 0 || holding.quantity == 0)
199             return false;
200 
201         return block.timestamp > holding.releaseDate;
202     }
203 
204     /**
205      * @notice Release the tokens once the holding period expires, transferring them back to the ERC20 contract to the holder.
206      *
207      * NOTE: This function preserves the isAffiliate flag of the holder.
208      *
209      * @param who       The owner of the tokens.
210      * @return          True on successful release, false on error.
211      */
212     function release(address who) public onlyTransferAgent returns (bool) {
213         Holding memory holding = heldTokens[who];
214         require(!holding.isAffiliate, "To release tokens for an affiliate use partialRelease().");
215 
216         if(block.timestamp > holding.releaseDate) {
217 
218             bool res = ERC20Interface(tokenContract).transfer(who, holding.quantity);
219             if(res) {
220                 heldTokens[who] = Holding(0, 0, holding.isAffiliate);
221                 emit TokensReleased(who, holding.quantity);
222                 return true;
223             }
224         }
225 
226         return false;
227     }
228 	
229     /**
230      * @notice Release some of an affiliate's tokens to a broker/trading wallet.
231      *
232      * @param who       		The owner of the tokens.
233 	 * @param tradingWallet		The broker/trader receiving the tokens.
234 	 * @param amount 			The number of tokens to release to the trading wallet.
235      */
236     function partialRelease(address who, address tradingWallet, uint256 amount) public onlyTransferAgent returns (bool) {
237         require(tradingWallet != 0, "The destination wallet cannot be null.");
238         require(!isExistingHolding(tradingWallet), "The destination wallet must be a new fresh wallet.");
239         Holding memory holding = heldTokens[who];
240         require(holding.isAffiliate, "Only affiliates can use this function; use release() for non-affiliates.");
241         require(amount <= holding.quantity, "The holding has less than the specified amount of tokens.");
242 
243         if(block.timestamp > holding.releaseDate) {
244 
245             // Send the tokens currently held by this contract on behalf of 'who' to the nominated wallet.
246             bool res = ERC20Interface(tokenContract).transfer(tradingWallet, amount);
247             if(res) {
248                 heldTokens[who] = Holding(holding.quantity.sub(amount), holding.releaseDate, holding.isAffiliate);
249                 emit TokensReleased(who, amount);
250                 return true;
251             }
252         }
253 
254         return false;
255     }
256 
257     /**
258      * @notice Under special circumstances the Transfer Agent needs to move tokens around.
259      *
260      * @dev As the release date is accurate to one second it is very unlikely release dates will
261      * match so an address that does not have a holding in this contract is required as the target.
262      *
263      * @param from      The current holder of the tokens.
264      * @param to        The recipient of the tokens - must be a 'clean' address.
265      * @param amount    The number of tokens to move.
266      */
267     function transfer(address from, address to, uint256 amount) public onlyTransferAgent returns (bool) {
268         require(to != 0x0, "Cannot transfer tokens to the null address.");
269         require(amount > 0, "Cannot transfer zero tokens.");
270         Holding memory fromHolding = heldTokens[from];
271         require(fromHolding.quantity >= amount, "Not enough tokens to perform the transfer.");
272         require(!isExistingHolding(to), "Cannot overwrite an existing holding, use a new wallet.");
273 
274         heldTokens[from] = Holding(fromHolding.quantity.sub(amount), fromHolding.releaseDate, fromHolding.isAffiliate);
275         heldTokens[to] = Holding(amount, fromHolding.releaseDate, false);
276 
277         emit TokensTransferred(from, to, amount);
278 
279         return true;
280     }
281 
282     /**
283      * @notice The Transfer Agent may need to add time to the release date if they are unable to verify
284      * the holder in a timely manner.
285      *
286      * @param who       The holder of the tokens.
287      * @param sconds    The number of seconds to add to the release date.  NOTE: 'seconds' appears to
288      *                  be a reserved word.
289      */
290     function addTime(address who, uint sconds) public onlyTransferAgent returns (bool) {
291         require(sconds > 0, "Time added cannot be zero.");
292 
293         Holding memory holding = heldTokens[who];
294         heldTokens[who] = Holding(holding.quantity, holding.releaseDate.add(sconds), holding.isAffiliate);
295 
296         emit ReleaseDateExtended(who, heldTokens[who].releaseDate);
297 
298         return true;
299     }
300 
301     /**
302      * @notice Company affiliates have added restriction, allow the Transfer Agent set/clear this flag
303      * as needed.
304      *
305      * @param who           The address being affiliated/unaffiliated.
306      * @param isAffiliate   Whether the address is an affiliate or not.
307      */
308     function setAffiliate(address who, bool isAffiliate) public onlyTransferAgent returns (bool) {
309         require(who != 0, "The null address cannot be used.");
310 
311         Holding memory holding = heldTokens[who];
312         require(holding.isAffiliate != isAffiliate, "Attempt to set the same affiliate status that is already set.");
313 
314         heldTokens[who] = Holding(holding.quantity, holding.releaseDate, isAffiliate);
315 
316         emit AffiliateStatusChanged(who, isAffiliate);
317 
318         return true;
319     }
320 
321     /**
322      * @notice Check if a wallet is already in use, only new/fresh/clean wallets can hold tokens.
323      *
324      * @param who   The wallet to check.
325      * @return      True if the wallet is in use, false otherwise.
326      */
327     function isExistingHolding(address who) public view returns (bool) {
328         Holding memory h = heldTokens[who];
329         return (h.quantity != 0 || h.releaseDate != 0);
330     }
331 }