1 pragma solidity ^0.4.11;
2 
3 contract Risk
4 {
5     address owner;
6     mapping (address => uint8 []) playerCountries;
7     address[178] ownerofCountry; // size must be fixed
8     address[] playerList;
9     uint256 totalmoney=0;
10     uint256 lastR=3;
11     address lastgameendWinner=address(0);   
12     uint8 winnerLimit=20;
13     
14     address[10] winnerloser; // first 5 represents winner last 5 loser
15 
16     function Risk() 
17     {
18         owner = msg.sender;
19     }
20     
21     function buyCountry(uint8 countryID) payable returns(bool)
22     {
23         assert(ownerofCountry[countryID]==0); //country unowned
24         assert(msg.value == 10 finney); //0.01 ether
25         
26         totalmoney +=msg.value;
27         playerCountries[msg.sender].push(countryID);
28         ownerofCountry[countryID]=msg.sender;
29         playerList.push(msg.sender);
30         
31         return true;
32     }
33     
34     function attackCountry(uint8 countryID)
35     {
36         assert(playerCountries[msg.sender].length!=0); //player owns county
37         assert(ownerofCountry[countryID]!=address(0)); //country owned
38         assert(msg.sender!=ownerofCountry[countryID]); //not attacking its own country
39         
40         address attacker = msg.sender;
41         address defender = ownerofCountry[countryID];
42         
43         uint a=playerCountries[attacker].length;
44         uint b=playerCountries[defender].length;
45 
46         for(uint256 i=9;i>=6;i--)
47             winnerloser[i]=winnerloser[i-1];
48         for(i=4;i>=1;i--)
49             winnerloser[i]=winnerloser[i-1];
50         
51         uint256 loopcount=0;
52         lastR=uint256(block.blockhash(block.number-1))%(a+b);
53         if(lastR<a) //attacker win
54         {
55             loopcount=playerCountries[defender].length;
56             for (i=0;i<loopcount;i++)
57             {
58                 playerCountries[attacker].push(playerCountries[defender][i]);
59                 ownerofCountry[playerCountries[defender][i]]=attacker;
60             }
61             playerCountries[defender].length=0;
62             winnerloser[0]=attacker;
63             winnerloser[5]=defender;
64         }
65         else //defender win
66         {
67             loopcount=playerCountries[attacker].length;
68             for (i=0;i<loopcount;i++)
69             {
70                 playerCountries[defender].push(playerCountries[attacker][i]);
71                 ownerofCountry[playerCountries[attacker][i]]=defender;
72             }
73             playerCountries[attacker].length=0;
74             winnerloser[0]=defender;
75             winnerloser[5]=attacker;
76         }
77         isGameEnd();
78     }
79     function isGameEnd()
80     {
81         uint256 loopcount=playerList.length;
82         address winner=owner;
83         
84         //require 15 country ownership for testing
85         bool del=false;
86         for (uint8 i=0; i<loopcount;i++)
87         {
88             if(playerCountries[playerList[i]].length>=winnerLimit) //iswinner
89             {
90                 winner=playerList[i];
91                 del=true;
92                 
93                 break;
94             }
95         }
96         //deleteeverything
97         if(del)
98         {
99             winner.transfer(totalmoney/10*9); //distribute 90%
100             owner.transfer(totalmoney/10);
101             totalmoney=0;
102             lastgameendWinner=winner;
103             for (i=0;i<178;i++)
104             {
105                 playerCountries[ownerofCountry[i]].length=0;
106                 ownerofCountry[i]=0;
107             }
108             playerList.length=0;
109             for(i=0;i<10;i++)
110                 winnerloser[i]=address(0);
111         }
112     }
113     function setwinnerLimit (uint8 x)
114     {
115         assert(msg.sender==owner);
116         winnerLimit=x;
117     }
118     function getCountryOwnershipList() constant returns (address[178])
119     {
120         return ownerofCountry;
121     }
122     function getTotalBet()constant returns (uint256)
123     {
124         return totalmoney;
125     }
126     function getaddr(address ax, uint8 bx) constant returns(address)
127     {
128         return playerCountries[ax][bx];
129     }
130     function len(address ax) constant returns(uint)
131     {
132         return playerCountries[ax].length;
133     }
134     function lastrandom() constant returns(uint256)
135     {
136         return lastR;
137     }
138     function getwinnerloser() constant returns(address[10])
139     {
140         return winnerloser;
141     }
142     function lastgamewinner() constant returns(address)
143     {
144         return lastgameendWinner;
145     }
146     
147 }