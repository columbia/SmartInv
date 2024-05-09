1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns (bool);
5     function balanceOf(address tokenOwner) external returns (uint);
6 }
7 
8 contract CucuSale {
9     address public beneficiary;
10     uint public amountRaised;
11     uint public price;
12     uint public dynamicLocktime; // tokens are locked for this number of minutes since purchase
13     uint public globalLocktime;
14     /*
15     * 0 - locktime depends on time of token purchase
16     * 1 - same locktime for all investers
17     * 2 - no locktimes
18     */
19     uint public lockType = 0;
20     token public tokenReward;
21     uint public exchangeRate;
22 
23     mapping(address => uint256) public balanceOf;
24     mapping(address => uint256) public tokenBalanceOf;
25     mapping(address => uint256) public timelocksOf;
26 
27     address[] public founders;
28     address public owner;
29 
30     event FundTransfer(address backer, uint amount, uint exchangeRate, uint token, uint time, uint timelock, bool isContribution);
31     event IsCharged(bool isCharged);
32     event TokensClaimed(address founder, uint tokens);
33     event TransferOwnership();
34     event ChangeExchangeRate(uint oldExchangeRate, uint newExchangeRate);
35     event NewGlobalLocktime(uint timelockUntil);
36     event NewDynamicLocktime(uint timelockUntil);
37     uint public tokenAvailable = 0;
38     bool public charged = false;
39     uint lastActionId = 0;
40 
41 
42     /**
43      * Constructor function
44      *
45      * Setup the owner
46      */
47     constructor(
48         address _beneficiary,
49         address _addressOfTokenUsedAsReward,
50         uint _globalLocktime,
51         uint _dynamicLocktime,
52         uint _exchangeRate
53     ) public {
54         beneficiary = _beneficiary;
55         dynamicLocktime = _dynamicLocktime;//now + dynamicTimeLockInMinutes * 1 minutes;
56         tokenReward = token(_addressOfTokenUsedAsReward);
57         globalLocktime = now + _globalLocktime * 1 minutes;
58         exchangeRate = _exchangeRate;
59         owner = msg.sender;
60     }
61 
62     /**
63      * Fallback function
64      *
65      * The function without name is the default function that is called whenever anyone sends funds to a contract
66      */
67     function () payable public {
68           require(charged);
69           require(msg.value >= 10000000000); // min allowed pay since token has only 8 decimals
70           uint am = (msg.value* exchangeRate * 100000000)/(1 ether); // 8 decimals for cocon token
71           require( tokenAvailable >= am);
72           uint amount = msg.value;
73           balanceOf[msg.sender] += amount;
74           amountRaised += amount;
75           tokenBalanceOf[msg.sender] += am;
76           tokenAvailable -= am;
77 
78           if(timelocksOf[msg.sender] == 0){
79             timelocksOf[msg.sender] = now + dynamicLocktime * 1 minutes;
80           }
81 
82           emit FundTransfer(msg.sender, amount, exchangeRate, am, now, timelocksOf[msg.sender], true);
83           founders.push(msg.sender);
84     }
85 
86     // modifier onlyOwner
87     modifier onlyOwner(){
88       require(msg.sender == owner || msg.sender == beneficiary);
89       _;
90     }
91 
92     // function to charge the crowdsale
93     function doChargeCrowdsale(uint act) public onlyOwner{
94       lastActionId = act;
95       tokenAvailable = tokenReward.balanceOf(address(this));
96       if(tokenAvailable > 0){
97         charged = true;
98         emit IsCharged(charged);
99       }
100     }
101 
102     /*
103       Function that allows to claim tokens after timelock has expired
104     */
105     function claimTokens(address adr) public{
106       require(tokenBalanceOf[adr] > 0);
107 
108       if(lockType == 0){ // lock by address
109         require(now >= timelocksOf[adr]);
110       }else if(lockType == 1){ // global lock
111         require(now >= globalLocktime);
112       } // else there is no lock
113 
114       if(tokenReward.transfer(adr, tokenBalanceOf[adr])){
115         emit TokensClaimed(adr, tokenBalanceOf[adr]);
116         tokenBalanceOf[adr] = 0;
117         balanceOf[adr] = 0;
118       }
119     }
120 
121     //  Allows owner to transfer raised amount
122     function transferRaisedFunds(uint act) public onlyOwner {
123         lastActionId = act;
124         if (beneficiary.send(amountRaised)) {
125            emit FundTransfer(beneficiary, amountRaised, exchangeRate, 0, now, 0, false);
126         }
127     }
128 
129     // to transfer ownership of the contract
130     function transferOwnership(address newOwner) public onlyOwner{
131       owner = newOwner;
132       emit TransferOwnership();
133     }
134 
135     // changing exchangeRate
136     function setExchangeRate(uint newExchangeRate) public onlyOwner{
137       emit ChangeExchangeRate(exchangeRate, newExchangeRate);
138       exchangeRate = newExchangeRate;
139     }
140 
141     // set new globalLocktime
142     function setGlobalLocktime(uint mins) public onlyOwner{
143       globalLocktime = now + mins * 1 minutes;
144       emit NewGlobalLocktime(globalLocktime);
145     }
146 
147     // set new dynamicLocktime
148     function setDynamicLocktime(uint mins) public onlyOwner{
149       dynamicLocktime = now + mins * 1 minutes;
150       emit NewDynamicLocktime(dynamicLocktime);
151     }
152 
153     // setting new locktype
154     function setLockType(uint newType) public onlyOwner{
155         require(newType == 0 || newType == 1 || newType == 2);
156         lockType = newType;
157     }
158 
159     // unlock tokens for address makes tokens unlockable even for the future token purchases
160     function unlockTokensFor(address adr) public onlyOwner{
161       timelocksOf[adr] = 1;
162     }
163 
164     // reset lock for address makes tokens lockable for address again
165     function resetLockFor(address adr) public onlyOwner{
166       timelocksOf[adr] = 0;
167     }
168 
169     // get all tokens that were left from token sale
170     function getLeftOver(uint act) public onlyOwner{
171       lastActionId = act;
172       if(tokenReward.transfer(beneficiary, tokenAvailable)){
173         emit TokensClaimed(beneficiary, tokenAvailable);
174         tokenAvailable = 0;
175       }
176     }
177 }