1 pragma solidity ^0.4.11;
2 contract FundariaToken {
3     uint public totalSupply;
4     uint public supplyLimit;
5     address public fundariaPoolAddress;
6     
7     function supplyTo(address, uint);
8     function tokenForWei(uint) returns(uint);
9     function weiForToken(uint) returns(uint);    
10          
11 }
12 
13 contract FundariaBonusFund {
14     function setOwnedBonus() payable {}    
15 }
16 
17 contract FundariaTokenBuy {
18         
19     address public fundariaBonusFundAddress;  // address of Fundaria 'bonus fund' contract
20     address public fundariaTokenAddress; // address of Fundaria token contract
21     
22     uint public bonusPeriod = 64 weeks; // bonus period from moment of this contract creating
23     uint constant bonusIntervalsCount = 9; // decreasing of bonus share with time
24     uint public startTimestampOfBonusPeriod; // when the bonus period starts
25     uint public finalTimestampOfBonusPeriod; // when the bonus period ends
26     
27     // for keeping of data to define bonus share at the moment of calling buy()    
28     struct bonusData {
29         uint timestamp;
30         uint shareKoef;
31     }
32     
33     // array to keep bonus related data
34     bonusData[9] bonusShedule;
35     
36     address creator; // creator address of this contract
37     // condition to be creator address to run some functions
38     modifier onlyCreator { 
39         if(msg.sender == creator) _;
40     }
41     
42     function FundariaTokenBuy(address _fundariaTokenAddress) {
43         fundariaTokenAddress = _fundariaTokenAddress;
44         startTimestampOfBonusPeriod = now;
45         finalTimestampOfBonusPeriod = now+bonusPeriod;
46         for(uint8 i=0; i<bonusIntervalsCount; i++) {
47             // define timestamps of bonus period intervals
48             bonusShedule[i].timestamp = finalTimestampOfBonusPeriod-(bonusPeriod*(bonusIntervalsCount-i-1)/bonusIntervalsCount);
49             // koef for decreasing bonus share
50             bonusShedule[i].shareKoef = bonusIntervalsCount-i;
51         }
52         creator = msg.sender;
53     }
54     
55     function setFundariaBonusFundAddress(address _fundariaBonusFundAddress) onlyCreator {
56         fundariaBonusFundAddress = _fundariaBonusFundAddress;    
57     } 
58     
59     // finish bonus if needed (if bonus system not efficient)
60     function finishBonusPeriod() onlyCreator {
61         finalTimestampOfBonusPeriod = now;    
62     }
63     
64     // if token bought successfuly
65     event TokenBought(address buyer, uint tokenToBuyer, uint weiForFundariaPool, uint weiForBonusFund, uint remnantWei);
66     
67     function buy() payable {
68         require(msg.value>0);
69         // use Fundaria token contract functions
70         FundariaToken ft = FundariaToken(fundariaTokenAddress);
71         // should be enough tokens before supply reached limit
72         require(ft.supplyLimit()-1>ft.totalSupply());
73         // tokens to buyer according to course
74         var tokenToBuyer = ft.tokenForWei(msg.value);
75         // should be enogh ether for at least 1 token
76         require(tokenToBuyer>=1);
77         // every second token goes to creator address
78         var tokenToCreator = tokenToBuyer;
79         uint weiForFundariaPool; // wei distributed to Fundaria pool
80         uint weiForBonusFund; // wei distributed to Fundaria bonus fund
81         uint returnedWei; // remnant
82         // if trying to buy more tokens then supply limit
83         if(ft.totalSupply()+tokenToBuyer+tokenToCreator > ft.supplyLimit()) {
84             // how many tokens are supposed to buy?
85             var supposedTokenToBuyer = tokenToBuyer;
86             // get all remaining tokens and devide them between reciepents
87             tokenToBuyer = (ft.supplyLimit()-ft.totalSupply())/2;
88             // every second token goes to creator address
89             tokenToCreator = tokenToBuyer; 
90             // tokens over limit
91             var excessToken = supposedTokenToBuyer-tokenToBuyer;
92             // wei to return to buyer
93             returnedWei = ft.weiForToken(excessToken);
94         }
95         
96         // remaining wei for tokens
97         var remnantValue = msg.value-returnedWei;
98         // if bonus period is over
99         if(now>finalTimestampOfBonusPeriod) {
100             weiForFundariaPool = remnantValue;            
101         } else {
102             uint prevTimestamp;
103             for(uint8 i=0; i<bonusIntervalsCount; i++) {
104                 // find interval to get needed bonus share
105                 if(bonusShedule[i].timestamp>=now && now>prevTimestamp) {
106                     // wei to be distributed into the Fundaria bonus fund
107                     weiForBonusFund = remnantValue*bonusShedule[i].shareKoef/(bonusIntervalsCount+1);    
108                 }
109                 prevTimestamp = bonusShedule[i].timestamp;    
110             }
111             // wei for Fundaria pool
112             weiForFundariaPool = remnantValue-weiForBonusFund;           
113         }
114         // use Fundaria token contract function to distribute tokens to creator address
115         ft.supplyTo(creator, tokenToCreator);
116         // transfer wei for bought tokens to Fundaria pool
117         (ft.fundariaPoolAddress()).transfer(weiForFundariaPool);
118         // if we have wei for buyer to be saved in bonus fund
119         if(weiForBonusFund>0) {
120             FundariaBonusFund fbf = FundariaBonusFund(fundariaBonusFundAddress);
121             // distribute bonus wei to bonus fund
122             fbf.setOwnedBonus.value(weiForBonusFund)();
123         }
124         // if have remnant, return it to buyer
125         if(returnedWei>0) msg.sender.transfer(returnedWei);
126         // use Fundaria token contract function to distribute tokens to buyer
127         ft.supplyTo(msg.sender, tokenToBuyer);
128         // inform about 'token bought' event
129         TokenBought(msg.sender, tokenToBuyer, weiForFundariaPool, weiForBonusFund, returnedWei);
130     }
131     
132     // Prevents accidental sending of ether
133     function () {
134 	    throw; 
135     }      
136 
137 }