1 pragma solidity ^0.4.24;
2 contract Ownable{
3     address public owner;
4     event ownerTransfer(address indexed oldOwner, address indexed newOwner);
5     event ownerGone(address indexed oldOwner);
6 
7     constructor(){
8         owner = msg.sender;
9     }
10     modifier onlyOwner(){
11         require(msg.sender == owner);
12         _;
13     }
14     function changeOwner(address _newOwner) public onlyOwner{
15         require(_newOwner != address(0x0));
16         emit ownerTransfer(owner, _newOwner);
17         owner = _newOwner;
18     }
19 }
20 contract Haltable is Ownable{
21     bool public paused;
22     event ContractPaused(address by);
23     event ContractUnpaused(address by);
24 
25     /**
26      * @dev Paused by default.
27      */
28     constructor(){
29         paused = true;
30     }
31     function pause() public onlyOwner {
32         paused = true;
33         emit ContractPaused(owner);
34     }
35     function unpause() public onlyOwner {
36         paused = false;
37         emit ContractUnpaused(owner);
38     }
39     modifier stopOnPause(){
40         require(paused == false);
41         _;
42     }
43 }
44 interface ABIO_Token {
45     function owner() external returns (address);
46     function transfer(address receiver, uint amount) external;
47     function burnMyBalance() external;
48 }
49 interface ABIO_ICO{
50     function deadline() external returns (uint);
51     function weiRaised() external returns (uint);
52 }
53 
54 contract ABIO_BaseICO is Haltable{
55     mapping(address => uint256) ethBalances;
56 
57     uint public weiRaised;//total raised in wei
58     uint public abioSold;//amount of ABIO sold
59     uint public volume; //total amount of ABIO selling in this preICO
60 
61     uint public startDate;
62     uint public length;
63     uint public deadline;
64     bool public restTokensBurned;
65 
66     uint public weiPerABIO; //how much wei one ABIO costs
67     uint public minInvestment;
68     uint public fundingGoal;
69     bool public fundingGoalReached;
70     address public treasury;
71 
72     ABIO_Token public abioToken;
73 
74     event ICOStart(uint volume, uint weiPerABIO, uint minInvestment);
75     event SoftcapReached(address recipient, uint totalAmountRaised);
76     event FundsReceived(address backer, uint amount);
77     event FundsWithdrawn(address receiver, uint amount);
78 
79     event ChangeTreasury(address operator, address newTreasury);
80     event ChangeMinInvestment(address operator, uint oldMin, uint newMin);
81 
82          /**
83          * @notice allows owner to change the treasury in case of hack/lost keys.
84          * @dev Marked external because it is never called from this contract.
85          */
86          function changeTreasury(address _newTreasury) external onlyOwner{
87              treasury = _newTreasury;
88              emit ChangeTreasury(msg.sender, _newTreasury);
89          }
90 
91          /**
92          * @notice allows owner to change the minInvestment in case of extreme price jumps of ETH price.
93          */
94          function changeMinInvestment(uint _newMin) external onlyOwner{
95              emit ChangeMinInvestment(msg.sender, minInvestment, _newMin);
96              minInvestment = _newMin;
97          }
98 
99          /**
100           * @notice Called everytime we receive a contribution in ETH.
101           * @dev Tokens are immediately transferred to the contributor, even if goal doesn't get reached.
102           */
103          function () payable stopOnPause{
104              require(now < deadline);
105              require(msg.value >= minInvestment);
106              uint amount = msg.value;
107              ethBalances[msg.sender] += amount;
108              weiRaised += amount;
109              if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();}
110 
111              uint ABIOAmount = amount / weiPerABIO ;
112              abioToken.transfer(msg.sender, ABIOAmount);
113              abioSold += ABIOAmount;
114              emit FundsReceived(msg.sender, amount);
115          }
116 
117          /**
118          * @notice We implement tokenFallback in case someone decides to send us tokens or we want to increase ICO Volume.
119          * @dev If someone sends random tokens transaction is reverted.
120          * @dev If owner of token sends tokens, we accept them.
121          * @dev Crowdsale opens once this contract gets the tokens.
122          */
123          function tokenFallback(address _from, uint _value, bytes _data) external{
124              require(_from == abioToken.owner() || _from == owner);
125              volume = _value;
126              paused = false;
127              deadline = now + length;
128              emit ICOStart(_value, weiPerABIO, minInvestment);
129          }
130 
131          /**
132          * @notice Burns tokens leftover from an ICO round.
133          * @dev This can be called by anyone after deadline since it's an essential and inevitable part.
134          */
135          function burnRestTokens() afterDeadline{
136                  require(!restTokensBurned);
137                  abioToken.burnMyBalance();
138                  restTokensBurned = true;
139          }
140 
141          function isRunning() view returns (bool){
142              return (now < deadline);
143          }
144 
145          function goalReached() internal;
146 
147          modifier afterDeadline() { if (now >= deadline) _; }
148 }
149 contract ABIO_preICO is ABIO_BaseICO{
150     address ICOAddress;
151     ABIO_ICO ICO;
152     uint finalDeadline;
153 
154     constructor(address _abioAddress, uint _lenInMins, uint _minWeiInvestment, address _treasury, uint _priceInWei, uint _goalInWei){
155         treasury = _treasury;
156         abioToken = ABIO_Token(_abioAddress);
157 
158         weiPerABIO = _priceInWei;
159         fundingGoal = _goalInWei;
160         minInvestment = _minWeiInvestment;
161 
162         startDate = now;
163         length = _lenInMins * 1 minutes;
164      }
165      /**
166      * @notice Called by dev to supply the address of the ICO (which is created after the PreICO)
167      * @dev We check if `fundingGoal` is reached again, because this MIGHT be called after it is reached, so `extGoalReached()` will never be called after.
168      */
169     function supplyICOContract(address _addr) public onlyOwner{
170         require(_addr != 0x0);
171         ICOAddress = _addr;
172         ICO = ABIO_ICO(_addr);
173         if(!fundingGoalReached && weiRaised + ICO.weiRaised() >= fundingGoal){goalReached();}
174         finalDeadline = ICO.deadline();
175     }
176 
177     function goalReached() internal{
178         fundingGoalReached = true;
179         emit SoftcapReached(treasury, fundingGoal);
180     }
181 
182     /**
183     * @notice supposed to be called by ICO Contract IF `fundingGoal` wasn't reached during PreICO to notify it
184     * @dev !!Funds can't be deposited to treasury if `fundingGoal` isn't called before main ICO ends!!
185     * @dev This is, at max., called once! If this contract doesn't know ICOAddress by that time, we rely on the check in `supplyICOContract()`
186     */
187     function extGoalReached() afterDeadline external{
188         require(ICOAddress != 0x0); //ICO was supplied
189         require(msg.sender == ICOAddress);
190         goalReached();
191     }
192 
193     /**
194      * @notice Lets participants withdraw the funds if `fundingGoal` was missed.
195      * @notice Lets treasury collect the funds if `fundingGoal` was reached.
196      * @dev The contract is obligated to return the ETH to contributors if `fundingGoal` isn't reached,
197      *      so we have to wait until the end for a user withdrawal.
198      * @dev The treasury can withdraw right after `fundingGoal` is reached.
199      */
200     function safeWithdrawal() afterDeadline stopOnPause{
201         if (!fundingGoalReached && now >= finalDeadline) {
202             uint amount = ethBalances[msg.sender];
203             ethBalances[msg.sender] = 0;
204             if (amount > 0) {
205                 if (msg.sender.send(amount)) {
206                     emit FundsWithdrawn(msg.sender, amount);
207                 } else {
208                     ethBalances[msg.sender] = amount;
209                 }
210             }
211         }
212         else if (fundingGoalReached && treasury == msg.sender) {
213             if (treasury.send(weiRaised)) {
214                 emit FundsWithdrawn(treasury, weiRaised);
215             } else if (treasury.send(address(this).balance)){
216                 emit FundsWithdrawn(treasury, address(this).balance);
217             }
218         }
219     }
220 
221 }