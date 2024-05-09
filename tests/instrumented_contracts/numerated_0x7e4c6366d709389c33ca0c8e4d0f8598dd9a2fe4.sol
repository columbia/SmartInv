1 pragma solidity ^0.4.24;
2 
3 
4 contract FiveElements{
5     
6     
7     uint[5] AvgGuesses;
8     address constant private Admin=0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
9     address constant private Adam=0x9640a35e5345CB0639C4DD0593567F9334FfeB8a;
10     address constant private Tummy=0x820090F4D39a9585a327cc39ba483f8fE7a9DA84;
11     address constant private Willy=0xA4757a60d41Ff94652104e4BCdB2936591c74d1D;
12     address constant private Nicky=0x89473CD97F49E6d991B68e880f4162e2CBaC3561;
13     address constant private Artem=0xA7e8AFa092FAa27F06942480D28edE6fE73E5F88;
14     address constant private FiveElementsAdministrationAddress=0x1f165ddAb085917437C6B15A5ed88E5B2c0B2dd9;
15     
16     
17     //event LiveRankAndPrizePool();
18     
19     
20     event ProofOfEntry(address indexed User,uint EntryPaid,uint GuessBTC,uint GuessETH,uint GuessLTC,uint GuessBCH,uint GuessXMR);
21     
22     
23     event WisdomOfCrowdsEntry(address indexed User,uint EntryPaid,uint AvgGuessBTC,uint AvgGuessETH,uint AvgGuessLTC,uint AvgGuessBCH,uint AvgGuessXMR,uint ActivationCount);
24     
25     
26     event ProofOfBettingMore(address indexed User,uint EtherPaid,uint NewEntryBalance);
27     
28     
29     event ProofOfQuitting(address indexed User,uint EtherRefund,uint TotalPaid);
30     
31     
32     event ReceivedFunds(address indexed Sender,uint Value);
33     
34     
35     function Join(uint GuessBTC,uint GuessETH,uint GuessLTC,uint GuessBCH,uint GuessXMR) public payable{
36         require(msg.value>0);
37         FiveElementsAdministration FEA=FiveElementsAdministration(FiveElementsAdministrationAddress);
38         uint Min=FEA.GetMinEntry();
39         if (msg.sender==Admin || msg.sender==Adam || msg.sender==Tummy || msg.sender==Willy || msg.sender==Nicky || msg.sender==Artem){
40         }else{
41             require(msg.value>=Min);
42         }
43         FiveElementsAdministrationAddress.transfer(msg.value);
44         FEA.UserJoin(msg.sender,msg.value,GuessBTC,GuessETH,GuessLTC,GuessBCH,GuessXMR);
45         emit ProofOfEntry(msg.sender,msg.value,GuessBTC,GuessETH,GuessLTC,GuessBCH,GuessXMR);
46     }
47     
48     
49     function BetMore() public payable{
50         require(msg.value>0);
51         FiveElementsAdministrationAddress.transfer(msg.value);
52         FiveElementsAdministration FEA=FiveElementsAdministration(FiveElementsAdministrationAddress);
53         FEA.UpdateBetAmount(msg.sender,msg.value);
54         emit ProofOfBettingMore(msg.sender,msg.value,FEA.GetBetAmount(msg.sender));
55     }
56     
57     
58     function WisdomOfTheCrowd() public payable{
59         require(msg.value>0);
60         FiveElementsAdministration FEA=FiveElementsAdministration(FiveElementsAdministrationAddress);
61         uint Min=FEA.GetMinEntry();
62         if (msg.sender==Admin || msg.sender==Adam || msg.sender==Tummy || msg.sender==Willy || msg.sender==Nicky || msg.sender==Artem){
63         }else{
64             require(msg.value>=Min);
65         }
66         AvgGuesses=FEA.AverageOfAllGuesses();
67         FiveElementsAdministrationAddress.transfer(msg.value);
68         FEA.UserJoin(msg.sender,msg.value,AvgGuesses[0],AvgGuesses[1],AvgGuesses[2],AvgGuesses[3],AvgGuesses[4]);
69         emit WisdomOfCrowdsEntry(msg.sender,msg.value,AvgGuesses[0],AvgGuesses[1],AvgGuesses[2],AvgGuesses[3],AvgGuesses[4],FEA.GetWisdomOfCrowdsActivationCount());
70         delete AvgGuesses;
71     }
72     
73     
74     function QuitGameAndRefund(){
75         FiveElementsAdministration FEA=FiveElementsAdministration(FiveElementsAdministrationAddress);
76         FEA.QuitAndRefund(msg.sender);
77         uint Amount=FEA.GetBetAmount(msg.sender);
78         uint FeePM=FEA.GetFeePerMillion();
79         emit ProofOfQuitting(msg.sender,Amount*(1000000-FeePM)/1000000,Amount);
80     }
81     
82     
83     function () payable{
84         FiveElementsAdministrationAddress.transfer(msg.value);
85         emit ReceivedFunds(msg.sender,msg.value);
86     }
87     
88     
89 }
90 
91 
92 contract FiveElementsAdministration{
93     
94     
95     function GetBetAmount(address User)public returns(uint Amount);
96     function UserJoin(address User,uint Value,uint GuessA,uint GuessB,uint GuessC,uint GuessD,uint GuessE);
97     function UpdateBetAmount(address User,uint Value);
98     function GetMinEntry()public returns(uint MinEntry);
99     function QuitAndRefund(address User);
100     function GetFeePerMillion()public returns(uint FeePerMillion);
101     function AverageOfAllGuesses()public returns(uint[5] AvgGuesses);
102     function GetWisdomOfCrowdsActivationCount()public returns(uint );
103     
104     
105 }