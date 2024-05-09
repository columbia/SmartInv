1 pragma solidity ^0.4.23;
2 
3 
4 
5 contract bettingGenerator{
6     address[] public deployedSportEvent;
7     address _teamAccount = 0x1b2a07BE84d8914526b51ce72bEDDB312656058e;
8     function createSportEvent(string _nameEvent,uint8 _feePercentage,uint _endTime) public {
9         require(msg.sender == _teamAccount);
10         deployedSportEvent.push(new sportEvent(_nameEvent,_feePercentage,_teamAccount,_endTime));       
11     }
12 
13     function getDeployedEvents() public view returns (address[]){
14         return deployedSportEvent;
15     }
16     
17 }
18 
19 contract sportEvent{
20     bool eventEnded = false;
21     uint256 endTime;
22     address public manager ;
23     uint8 public devPercentage;
24     string public name;
25     mapping(address => uint) public index;
26 
27     struct Player{
28         
29         uint[12] betsValue;
30         address playerAddress;
31         uint totalPlayerBet;
32         
33     }
34     Player[] private Bettors;
35     constructor(string nameEvent,uint8 feePercentage,address teamAccount,uint eventEndTime) public{
36         manager = teamAccount;
37         name = nameEvent;
38         devPercentage = feePercentage;
39         Bettors.push(
40             Player(
41                 [uint256 (0),0,0,0,0,0,0,0,0,0,0,0],
42                 address(this),
43                 0
44         ));
45         endTime = eventEndTime;
46 
47     }
48     function enterEvent(uint[12] playerValue) external payable{
49         require(validPurchase());
50         require(
51             msg.value == (playerValue[0] + playerValue[1]+playerValue[2]+playerValue[3]+playerValue[4]+playerValue[5]+playerValue[6]+playerValue[7]+playerValue[8]+playerValue[9]+playerValue[10]+playerValue[11])
52         );
53         
54         Bettors[0].totalPlayerBet += msg.value;
55         for(uint a = 0;a<12;a++){
56             Bettors[0].betsValue[a] += playerValue[a];    
57         }
58         
59         
60         if(index[msg.sender] == 0){ 
61             Bettors.push(Player(playerValue,msg.sender,msg.value));
62             index[msg.sender] = Bettors.length-1;
63         }
64         else{ 
65             Player storage bettor = Bettors[index[msg.sender]];
66             bettor.totalPlayerBet += msg.value;
67             for(uint b = 0;b<12;b++){
68                 bettor.betsValue[b] += playerValue[b];    
69             }
70 
71         }
72    
73     }
74 
75 
76     function splitWinnings(uint winnerIndex) public {
77         require(!eventEnded);
78         require(msg.sender == manager);
79         uint devFee = devPercentage*Bettors[0].totalPlayerBet/100;
80         manager.transfer(devFee);
81         uint newBalance = address(this).balance;
82         uint16 winnersCount;
83         uint share = 0;
84         for(uint l = 1; l<Bettors.length ;l++){
85             if(Bettors[l].betsValue[winnerIndex]>0){
86                 share = Bettors[l].betsValue[winnerIndex]*newBalance/Bettors[0].betsValue[winnerIndex];
87                 (Bettors[l].playerAddress).transfer(share);
88                 winnersCount++;
89             }
90         }
91         if(winnersCount==0){
92             for(uint g = 1; g<Bettors.length ;g++){
93                 
94                 share=Bettors[g].totalPlayerBet*newBalance/Bettors[0].totalPlayerBet;
95                 (Bettors[g].playerAddress).transfer(share);
96         }
97         }
98         eventEnded = true;
99 
100     }
101     
102     function getDetails() public view returns(string ,uint,uint8){
103         return (
104                 name,
105                 address(this).balance,
106                 devPercentage
107             );
108     }
109     function validPurchase()  internal  view
110         returns(bool) 
111     {
112         bool withinPeriod = now <= endTime;
113         bool nonZeroPurchase = msg.value != 0;
114         bool nonInvalidAccount = msg.sender != 0;
115         return withinPeriod && nonZeroPurchase && nonInvalidAccount;
116     }
117 }