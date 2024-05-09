1 pragma solidity ^0.4.15;
2 
3 
4 contract Token {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 
50 contract AbstractSingularDTVToken is Token {
51 
52 }
53 
54 
55 /// @title Token Creation contract - Implements token creation functionality.
56 /// @author Stefan George - <stefan.george@consensys.net>
57 /// @author Razvan Pop - <razvan.pop@consensys.net>
58 /// @author Milad Mostavi - <milad.mostavi@consensys.net>
59 contract SingularDTVLaunch {
60     string public version = "0.1.0";
61 
62     event Contributed(address indexed contributor, uint contribution, uint tokens);
63 
64     /*
65      *  External contracts
66      */
67     AbstractSingularDTVToken public singularDTVToken;
68     address public workshop;
69     address public SingularDTVWorkshop = 0xc78310231aA53bD3D0FEA2F8c705C67730929D8f;
70     uint public SingularDTVWorkshopFee;
71 
72     /*
73      *  Constants
74      */
75     uint public CAP; // in wei scale of tokens
76     uint public DURATION; // in seconds
77     uint public TOKEN_TARGET; // Goal threshold in wei scale of tokens
78 
79     /*
80      *  Enums
81      */
82     enum Stages {
83         Deployed,
84         GoingAndGoalNotReached,
85         EndedAndGoalNotReached,
86         GoingAndGoalReached,
87         EndedAndGoalReached
88     }
89 
90     /*
91      *  Storage
92      */
93     address public owner;
94     uint public startDate;
95     uint public fundBalance;
96     uint public valuePerToken; //in wei
97     uint public tokensSent;
98 
99     // participant address => value in Wei
100     mapping (address => uint) public contributions;
101 
102     // participant address => token amount in wei scale
103     mapping (address => uint) public sentTokens;
104 
105     // Initialize stage
106     Stages public stage = Stages.Deployed;
107 
108     modifier onlyOwner() {
109         // Only owner is allowed to do this action.
110         if (msg.sender != owner) {
111             revert();
112         }
113         _;
114     }
115 
116     modifier atStage(Stages _stage) {
117         if (stage != _stage) {
118             revert();
119         }
120         _;
121     }
122 
123     modifier atStageOR(Stages _stage1, Stages _stage2) {
124         if (stage != _stage1 && stage != _stage2) {
125             revert();
126         }
127         _;
128     }
129 
130     modifier timedTransitions() {
131         uint timeElapsed = now - startDate;
132 
133         if (timeElapsed >= DURATION) {
134             if (stage == Stages.GoingAndGoalNotReached) {
135                 stage = Stages.EndedAndGoalNotReached;
136             } else if (stage == Stages.GoingAndGoalReached) {
137                 stage = Stages.EndedAndGoalReached;
138             }
139         }
140         _;
141     }
142 
143     /*
144      *  Contract functions
145      */
146     /// dev Validates invariants.
147     function checkInvariants() constant internal {
148         if (fundBalance > this.balance) {
149             revert();
150         }
151     }
152 
153     /// @dev Can be triggered if an invariant fails.
154     function emergencyCall()
155         public
156         returns (bool)
157     {
158         if (fundBalance > this.balance) {
159             if (this.balance > 0 && !SingularDTVWorkshop.send(this.balance)) {
160                 revert();
161             }
162             return true;
163         }
164         return false;
165     }
166 
167     /// @dev Allows user to create tokens if token creation is still going and cap not reached. Returns token count.
168     function fund()
169         public
170         timedTransitions
171         atStageOR(Stages.GoingAndGoalNotReached, Stages.GoingAndGoalReached)
172         payable
173         returns (uint)
174     {
175         uint tokenCount = (msg.value * (10**18)) / valuePerToken; // Token count in wei is rounded down. Sent ETH should be multiples of valuePerToken.
176         require(tokenCount > 0);
177         if (tokensSent + tokenCount > CAP) {
178             // User wants to create more tokens than available. Set tokens to possible maximum.
179             tokenCount = CAP - tokensSent;
180         }
181         tokensSent += tokenCount;
182 
183         uint contribution = (tokenCount * valuePerToken) / (10**18); // Ether spent by user.
184         // Send change back to user.
185         if (msg.value > contribution && !msg.sender.send(msg.value - contribution)) {
186             revert();
187         }
188         // Update fund and user's balance and total supply of tokens.
189         fundBalance += contribution;
190         contributions[msg.sender] += contribution;
191         sentTokens[msg.sender] += tokenCount;
192         if (!singularDTVToken.transfer(msg.sender, tokenCount)) {
193             // Tokens could not be issued.
194             revert();
195         }
196         // Update stage
197         if (stage == Stages.GoingAndGoalNotReached) {
198             if (tokensSent >= TOKEN_TARGET) {
199                 stage = Stages.GoingAndGoalReached;
200             }
201         }
202         // not an else clause for the edge case that the CAP and TOKEN_TARGET are reached in one call
203         if (stage == Stages.GoingAndGoalReached) {
204             if (tokensSent == CAP) {
205                 stage = Stages.EndedAndGoalReached;
206             }
207         }
208         checkInvariants();
209 
210         Contributed(msg.sender, contribution, tokenCount);
211 
212         return tokenCount;
213     }
214 
215     /// @dev Allows user to withdraw ETH if token creation period ended and target was not reached. Returns contribution.
216     function withdrawContribution()
217         public
218         timedTransitions
219         atStage(Stages.EndedAndGoalNotReached)
220         returns (uint)
221     {
222         // We get back the tokens from the contributor before giving back his contribution
223         uint tokensReceived = sentTokens[msg.sender];
224         sentTokens[msg.sender] = 0;
225         if (!singularDTVToken.transferFrom(msg.sender, owner, tokensReceived)) {
226             revert();
227         }
228 
229         // Update fund's and user's balance and total supply of tokens.
230         uint contribution = contributions[msg.sender];
231         contributions[msg.sender] = 0;
232         fundBalance -= contribution;
233         // Send ETH back to user.
234         if (contribution > 0) {
235             msg.sender.transfer(contribution);
236         }
237         checkInvariants();
238         return contribution;
239     }
240 
241     /// @dev Withdraws ETH to workshop address. Returns success.
242     function withdrawForWorkshop()
243         public
244         timedTransitions
245         atStage(Stages.EndedAndGoalReached)
246         returns (bool)
247     {
248         uint value = fundBalance;
249         fundBalance = 0;
250 
251         require(value > 0);
252 
253         uint networkFee = value * SingularDTVWorkshopFee / 100;
254         workshop.transfer(value - networkFee);
255         SingularDTVWorkshop.transfer(networkFee);
256 
257         uint remainingTokens = CAP - tokensSent;
258         if (remainingTokens > 0 && !singularDTVToken.transfer(owner, remainingTokens)) {
259             revert();
260         }
261 
262         checkInvariants();
263         return true;
264     }
265 
266     /// @dev Allows owner to get back unsent tokens in case of launch failure (EndedAndGoalNotReached).
267     function withdrawUnsentTokensForOwner()
268         public
269         timedTransitions
270         atStage(Stages.EndedAndGoalNotReached)
271         returns (uint)
272     {
273         uint remainingTokens = CAP - tokensSent;
274         if (remainingTokens > 0 && !singularDTVToken.transfer(owner, remainingTokens)) {
275             revert();
276         }
277 
278         checkInvariants();
279         return remainingTokens;
280     }
281 
282     /// @dev Sets token value in Wei.
283     /// @param valueInWei New value.
284     function changeValuePerToken(uint valueInWei)
285         public
286         onlyOwner
287         atStage(Stages.Deployed)
288         returns (bool)
289     {
290         valuePerToken = valueInWei;
291         return true;
292     }
293 
294     // updateStage allows calls to receive correct stage. It can be used for transactions but is not part of the regular token creation routine.
295     // It is not marked as constant because timedTransitions modifier is altering state and constant is not yet enforced by solc.
296     /// @dev returns correct stage, even if a function with timedTransitions modifier has not yet been called successfully.
297     function updateStage()
298         public
299         timedTransitions
300         returns (Stages)
301     {
302         return stage;
303     }
304 
305     function start()
306         public
307         onlyOwner
308         atStage(Stages.Deployed)
309         returns (uint)
310     {
311         if (!singularDTVToken.transferFrom(msg.sender, this, CAP)) {
312             revert();
313         }
314 
315         startDate = now;
316         stage = Stages.GoingAndGoalNotReached;
317 
318         checkInvariants();
319         return startDate;
320     }
321 
322     /// @dev Contract constructor function sets owner and start date.
323     function SingularDTVLaunch(
324         address singularDTVTokenAddress,
325         address _workshop,
326         address _owner,
327         uint _total,
328         uint _unit_price,
329         uint _duration,
330         uint _threshold,
331         uint _singulardtvwoskhop_fee
332         ) {
333         singularDTVToken = AbstractSingularDTVToken(singularDTVTokenAddress);
334         workshop = _workshop;
335         owner = _owner;
336         CAP = _total; // Total number of tokens (wei scale)
337         valuePerToken = _unit_price; // wei per token
338         DURATION = _duration; // in seconds
339         TOKEN_TARGET = _threshold; // Goal threshold
340         SingularDTVWorkshopFee = _singulardtvwoskhop_fee;
341     }
342 
343     /// @dev Fallback function acts as fund() when stage GoingAndGoalNotReached
344     /// or GoingAndGoalReached. And act as withdrawFunding() when EndedAndGoalNotReached.
345     /// otherwise throw.
346     function ()
347         public
348         payable
349     {
350         if (stage == Stages.GoingAndGoalNotReached || stage == Stages.GoingAndGoalReached)
351             fund();
352         else if (stage == Stages.EndedAndGoalNotReached)
353             withdrawContribution();
354         else
355             revert();
356     }
357 }