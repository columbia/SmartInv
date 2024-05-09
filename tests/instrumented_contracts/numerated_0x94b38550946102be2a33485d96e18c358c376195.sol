1 // Human token smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  *   @title SafeMath
8  *   @dev Math operations with safety checks that throw on error
9  */
10 
11 library SafeMath {
12 
13     function mul(uint a, uint b) internal constant returns (uint) {
14         if (a == 0) {
15             return 0;
16         }
17         uint c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     function div(uint a, uint b) internal constant returns(uint) {
23         assert(b > 0);
24         uint c = a / b;
25         assert(a == b * c + a % b);
26         return c;
27     }
28 
29     function sub(uint a, uint b) internal constant returns(uint) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint a, uint b) internal constant returns(uint) {
35         uint c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 /**
42  *   @title ERC20
43  *   @dev Standart ERC20 token interface
44  */
45 
46 contract ERC20 {
47     uint public totalSupply = 0;
48 
49     mapping(address => uint) balances;
50     mapping(address => mapping (address => uint)) allowed;
51 
52     function balanceOf(address _owner) constant returns (uint);
53     function transfer(address _to, uint _value) returns (bool);
54     function transferFrom(address _from, address _to, uint _value) returns (bool);
55     function approve(address _spender, uint _value) returns (bool);
56     function allowance(address _owner, address _spender) constant returns (uint);
57 
58     event Transfer(address indexed _from, address indexed _to, uint _value);
59     event Approval(address indexed _owner, address indexed _spender, uint _value);
60 
61 }
62 
63 
64 /**
65  *   @title HumanToken
66  *   @dev Human token smart-contract
67  */
68 contract HumanToken is ERC20 {
69     using SafeMath for uint;
70     string public name = "Human";
71     string public symbol = "Human";
72     uint public decimals = 18;
73     uint public voteCost = 10**18;
74 
75     // Owner address
76     address public owner;
77     address public eventManager;
78 
79     mapping (address => bool) isActiveEvent;
80             
81     //events        
82     event EventAdded(address _event);
83     event Contribute(address _event, address _contributor, uint _amount);
84     event Vote(address _event, address _contributor, bool _proposal);
85     
86     // Allows execution by the contract owner only
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     // Allows execution by the event manager only
93     modifier onlyEventManager {
94         require(msg.sender == eventManager);
95         _;
96     }
97 
98    // Allows contributing and voting only to human events 
99     modifier onlyActive(address _event) {
100         require(isActiveEvent[_event]);
101         _;
102     }
103 
104 
105    /**
106     *   @dev Contract constructor function sets owner address
107     *   @param _owner        owner address
108     */
109     function HumanToken(address _owner, address _eventManager) public {
110        owner = _owner;
111        eventManager = _eventManager;
112     }
113 
114 
115    /**
116     *   @dev Function to add a new event from TheHuman team
117     *   @param _event       a new event address
118     */   
119     function  addEvent(address _event) external onlyEventManager {
120         require (!isActiveEvent[_event]);
121         isActiveEvent[_event] = true;
122         EventAdded(_event);
123     }
124 
125    /**
126     *   @dev Function to change vote cost, by default vote cost equals 1 Human token
127     *   @param _voteCost     a new vote cost
128     */
129     function setVoteCost(uint _voteCost) external onlyEventManager {
130         voteCost = _voteCost;
131     }
132     
133    /**
134     *   @dev Function to donate for event
135     *   @param _event     address of event
136     *   @param _amount    donation amount    
137     */
138     function donate(address _event, uint _amount) public onlyActive(_event) {
139         require (transfer(_event, _amount));
140         require (HumanEvent(_event).contribute(msg.sender, _amount));
141         Contribute(_event, msg.sender, _amount);
142         
143     }
144 
145    /**
146     *   @dev Function voting for the success of the event
147     *   @param _event     address of event
148     *   @param _proposal  true - event completed successfully, false - otherwise
149     */
150     function vote(address _event, bool _proposal) public onlyActive(_event) {
151         require(transfer(_event, voteCost));
152         require(HumanEvent(_event).vote(msg.sender, _proposal));
153         Vote(_event, msg.sender, _proposal);
154     }
155     
156     
157 
158 
159    /**
160     *   @dev Function to mint tokens
161     *   @param _holder       beneficiary address the tokens will be issued to
162     *   @param _value        number of tokens to issue
163     */
164     function mintTokens(address _holder, uint _value) external onlyOwner {
165        require(_value > 0);
166        balances[_holder] = balances[_holder].add(_value);
167        totalSupply = totalSupply.add(_value);
168        Transfer(0x0, _holder, _value);
169     }
170 
171   
172    /**
173     *   @dev Get balance of tokens holder
174     *   @param _holder        holder's address
175     *   @return               balance of investor
176     */
177     function balanceOf(address _holder) constant returns (uint) {
178          return balances[_holder];
179     }
180 
181    /**
182     *   @dev Send coins
183     *   throws on any error rather then return a false flag to minimize
184     *   user errors
185     *   @param _to           target address
186     *   @param _amount       transfer amount
187     *
188     *   @return true if the transfer was successful
189     */
190     function transfer(address _to, uint _amount) public returns (bool) {
191         balances[msg.sender] = balances[msg.sender].sub(_amount);
192         balances[_to] = balances[_to].add(_amount);
193         Transfer(msg.sender, _to, _amount);
194         return true;
195     }
196 
197    /**
198     *   @dev An account/contract attempts to get the coins
199     *   throws on any error rather then return a false flag to minimize user errors
200     *
201     *   @param _from         source address
202     *   @param _to           target address
203     *   @param _amount       transfer amount
204     *
205     *   @return true if the transfer was successful
206     */
207     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
208         balances[_from] = balances[_from].sub(_amount);
209         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         Transfer(_from, _to, _amount);
212         return true;
213     }
214 
215 
216    /**
217     *   @dev Allows another account/contract to spend some tokens on its behalf
218     *   throws on any error rather then return a false flag to minimize user errors
219     *
220     *   also, to minimize the risk of the approve/transferFrom attack vector
221     *   approve has to be called twice in 2 separate transactions - once to
222     *   change the allowance to 0 and secondly to change it to the new allowance
223     *   value
224     *
225     *   @param _spender      approved address
226     *   @param _amount       allowance amount
227     *
228     *   @return true if the approval was successful
229     */
230     function approve(address _spender, uint _amount) public returns (bool) {
231         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
232         allowed[msg.sender][_spender] = _amount;
233         Approval(msg.sender, _spender, _amount);
234         return true;
235     }
236 
237    /**
238     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
239     *
240     *   @param _owner        the address which owns the funds
241     *   @param _spender      the address which will spend the funds
242     *
243     *   @return              the amount of tokens still avaible for the spender
244     */
245     function allowance(address _owner, address _spender) constant returns (uint) {
246         return allowed[_owner][_spender];
247     }
248 
249     /** 
250     *   @dev Allows owner to transfer out any accidentally sent ERC20 tokens
251     *   @param tokenAddress  token address
252     *   @param tokens        transfer amount
253     */
254     function transferAnyTokens(address tokenAddress, uint tokens) 
255         public
256         onlyOwner 
257         returns (bool success) {
258         return ERC20(tokenAddress).transfer(owner, tokens);
259     }
260 }
261 
262  contract HumanEvent {
263     using SafeMath for uint;    
264     uint public totalRaised;
265     uint public softCap;
266     uint public positiveVotes;
267     uint public negativeVotes;
268 
269     address public alternative;
270     address public owner;
271     HumanToken public human;
272 
273     mapping (address => uint) public contributions;
274     mapping (address => bool) public voted;
275     mapping (address => bool) public claimed;
276     
277 
278 
279     // Allows execution by the contract owner only
280     modifier onlyOwner {
281         require(msg.sender == owner);
282         _;
283     }
284 
285     // Allows execution by the contract owner only
286     modifier onlyHuman {
287         require(msg.sender == address(human));
288         _;
289     }
290 
291 
292     // Possible Event statuses
293     enum StatusEvent {
294         Created,
295         Fundraising,
296         Failed,
297         Evaluating,
298         Voting,
299         Finished
300     }
301     StatusEvent public statusEvent = StatusEvent.Created;
302 
303     
304     function HumanEvent(
305         address _owner, 
306         uint _softCap,
307         address _alternative,
308         address _human
309     ) public {
310         owner = _owner;
311         softCap = _softCap;
312         alternative = _alternative;
313         human = HumanToken(_human);
314     }
315 
316     function startFundraising() public onlyOwner {
317         require(statusEvent == StatusEvent.Created);
318         statusEvent = StatusEvent.Fundraising;
319         
320     }
321     
322 
323     function startEvaluating() public onlyOwner {
324         require(statusEvent == StatusEvent.Fundraising);
325         
326         if (totalRaised >= softCap) {
327             statusEvent = StatusEvent.Evaluating;
328         } else {
329             statusEvent = StatusEvent.Failed;
330         }
331     }
332 
333     function startVoting() public onlyOwner {
334         require(statusEvent == StatusEvent.Evaluating);
335         statusEvent = StatusEvent.Voting;
336     }
337 
338     function finish() public onlyOwner {
339         require(statusEvent == StatusEvent.Voting);
340         if (positiveVotes >= negativeVotes) {
341             statusEvent = StatusEvent.Finished;
342         } else {
343             statusEvent = StatusEvent.Failed;
344         }
345     }
346     
347     
348     function claim() public {
349         require(!claimed[msg.sender]);        
350         claimed[msg.sender] = true;
351         uint contribution;
352 
353         if (statusEvent == StatusEvent.Failed) {
354             contribution = contribution.add(contributions[msg.sender]);
355             contributions[msg.sender] = 0;
356         }
357 
358         if(voted[msg.sender] && statusEvent != StatusEvent.Voting) {
359             uint _voteCost = human.voteCost();
360             contribution = contribution.add(_voteCost);
361         }
362         require(contribution > 0);
363         require(human.transfer(msg.sender, contribution));
364     }
365 
366     
367     function vote(address _voter, bool _proposal) external onlyHuman returns (bool) {
368         require(!voted[_voter] && statusEvent == StatusEvent.Voting);
369         voted[_voter] = true;
370         
371         if (_proposal) {
372             positiveVotes++;
373         } else {
374             negativeVotes++;
375         }
376         return true;
377     }
378 
379 
380     function contribute(address _contributor, uint _amount) external onlyHuman returns(bool) {
381         require (statusEvent == StatusEvent.Fundraising);
382         contributions[_contributor] =  contributions[_contributor].add(_amount);
383         totalRaised = totalRaised.add(_amount);
384         return true;
385     }
386     
387     function  withdraw() external onlyOwner {
388         require (statusEvent == StatusEvent.Finished);
389         require (human.transfer(alternative, totalRaised));
390     }
391 
392 }