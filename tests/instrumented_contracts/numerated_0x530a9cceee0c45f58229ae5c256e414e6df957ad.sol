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
40         if(msg.sender != owner){
41             require(paused == false);
42         }
43         _;
44     }
45 }
46 interface ABIO_Token {
47     function owner() external returns (address);
48     function transfer(address receiver, uint amount) external;
49     function burnMyBalance() external;
50 }
51 interface ABIO_preICO{
52     function weiRaised() external returns (uint);
53     function fundingGoal() external returns (uint);
54     function extGoalReached() external returns (uint);
55 }
56 contract ABIO_BaseICO is Haltable{
57     mapping(address => uint256) ethBalances;
58 
59     uint public weiRaised;//total raised in wei
60     uint public abioSold;//amount of ABIO sold
61     uint public volume; //total amount of ABIO selling in this preICO
62 
63     uint public startDate;
64     uint public length;
65     uint public deadline;
66     bool public restTokensBurned;
67 
68     uint public weiPerABIO; //how much wei one ABIO costs
69     uint public minInvestment;
70     uint public fundingGoal;
71     bool public fundingGoalReached;
72     address public treasury;
73 
74     ABIO_Token public abioToken;
75 
76     event ICOStart(uint volume, uint weiPerABIO, uint minInvestment);
77     event SoftcapReached(address recipient, uint totalAmountRaised);
78     event FundsReceived(address backer, uint amount);
79     event FundsWithdrawn(address receiver, uint amount);
80 
81     event ChangeTreasury(address operator, address newTreasury);
82     event PriceAdjust(address operator, uint multipliedBy ,uint newMin, uint newPrice);
83 
84          /**
85          * @notice allows owner to change the treasury in case of hack/lost keys.
86          * @dev Marked external because it is never called from this contract.
87          */
88          function changeTreasury(address _newTreasury) external onlyOwner{
89              treasury = _newTreasury;
90              emit ChangeTreasury(msg.sender, _newTreasury);
91          }
92 
93          /**
94          * @notice allows owner to adjust `minInvestment` and `weiPerABIO` in case of extreme jumps of Ether's dollar-value.
95          * @param _multiplier Both `minInvestment` and `weiPerABIO` will be multiplied by `_multiplier`. It is supposed to be close to oldEthPrice/newEthPrice
96          * @param _multiplier MULTIPLIER IS SUPPLIED AS PERCENTAGE
97          */
98          function adjustPrice(uint _multiplier) external onlyOwner{
99              require(_multiplier < 400 && _multiplier > 25);
100              minInvestment = minInvestment * _multiplier / 100;
101              weiPerABIO = weiPerABIO * _multiplier / 100;
102              emit PriceAdjust(msg.sender, _multiplier, minInvestment, weiPerABIO);
103          }
104 
105          /**
106           * @notice Called everytime we receive a contribution in ETH.
107           * @dev Tokens are immediately transferred to the contributor, even if goal doesn't get reached.
108           */
109          function () payable stopOnPause{
110              require(now < deadline);
111              require(msg.value >= minInvestment);
112              uint amount = msg.value;
113              ethBalances[msg.sender] += amount;
114              weiRaised += amount;
115              if(!fundingGoalReached && weiRaised >= fundingGoal){goalReached();}
116 
117              uint ABIOAmount = amount / weiPerABIO ;
118              abioToken.transfer(msg.sender, ABIOAmount);
119              abioSold += ABIOAmount;
120              emit FundsReceived(msg.sender, amount);
121          }
122 
123          /**
124          * @notice We implement tokenFallback in case someone decides to send us tokens or we want to increase ICO Volume.
125          * @dev If someone sends random tokens transaction is reverted.
126          * @dev If owner of token sends tokens, we accept them.
127          * @dev Crowdsale opens once this contract gets the tokens.
128          */
129          function tokenFallback(address _from, uint _value, bytes) external{
130              require(msg.sender == address(abioToken));
131              require(_from == abioToken.owner() || _from == owner);
132              volume = _value;
133              paused = false;
134              deadline = now + length;
135              emit ICOStart(_value, weiPerABIO, minInvestment);
136          }
137 
138          /**
139          * @notice Burns tokens leftover from an ICO round.
140          * @dev This can be called by anyone after deadline since it's an essential and inevitable part.
141          */
142          function burnRestTokens() afterDeadline{
143                  require(!restTokensBurned);
144                  abioToken.burnMyBalance();
145                  restTokensBurned = true;
146          }
147 
148          function isRunning() view returns (bool){
149              return (now < deadline);
150          }
151 
152          function goalReached() internal;
153 
154          modifier afterDeadline() { if (now >= deadline) _; }
155 }
156 
157 
158 contract ABIO_ICO is ABIO_BaseICO{
159     ABIO_preICO PICO;
160     uint weiRaisedInPICO;
161     uint abioSoldInPICO;
162 
163     event Prolonged(address oabiotor, uint newDeadline);
164     bool didProlong;
165     constructor(address _abioAddress, address _treasury, address _PICOAddr, uint _lenInMins,uint _minInvestment, uint _priceInWei){
166          abioToken = ABIO_Token(_abioAddress);
167          treasury = _treasury;
168 
169          PICO = ABIO_preICO(_PICOAddr);
170          weiRaisedInPICO = PICO.weiRaised();
171          fundingGoal = PICO.fundingGoal();
172          if (weiRaisedInPICO >= fundingGoal){
173              goalReached();
174          }
175          minInvestment = _minInvestment;
176 
177          startDate = now;
178          length = _lenInMins * 1 minutes;
179          weiPerABIO = _priceInWei;
180          fundingGoal = PICO.fundingGoal();
181     }
182 
183     /**
184     * @notice a function that changes state if goal reached. If the PICO didn't reach goal, it reports back to it.
185     */
186     function goalReached() internal {
187         emit SoftcapReached(treasury, fundingGoal);
188         fundingGoalReached = true;
189         if (weiRaisedInPICO < fundingGoal){
190             PICO.extGoalReached();
191         }
192     }
193 
194     /**
195      * @notice Lets participants withdraw the funds if goal was missed.
196      * @notice Lets treasury collect the funds if goal was reached.
197      * @dev The contract is obligated to return the ETH to contributors if goal isn't reached,
198      *      so we have to wait until the end for a withdrawal.
199      */
200     function safeWithdrawal() afterDeadline stopOnPause{
201         if (!fundingGoalReached) {
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
212         else if (fundingGoalReached) {
213             require(treasury == msg.sender);
214             if (treasury.send(weiRaised)) {
215                 emit FundsWithdrawn(treasury, weiRaised);
216             } else if (treasury.send(address(this).balance)){
217                 emit FundsWithdrawn(treasury, address(this).balance);
218             }
219         }
220     }
221 
222     /**
223     * @notice Is going to be called in an extreme case where we need to prolong the ICO (e.g. missed Softcap by a few ETH)/
224     * @dev It's only called once, has to be called at least 4 days before ICO end and prolongs the ICO for no more than 3 weeks.
225     */
226     function prolong(uint _timeInMins) external onlyOwner{
227         require(!didProlong);
228         require(now <= deadline - 4 days);
229         uint t = _timeInMins * 1 minutes;
230         require(t <= 3 weeks);
231         deadline += t;
232         length += t;
233 
234         didProlong = true;
235         emit Prolonged(msg.sender, deadline);
236     }
237 }