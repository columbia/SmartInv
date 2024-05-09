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
12     uint8 winnerLimit=50;
13     
14     address[15] winnerloser; // first 5 represents attacker last 5 defender
15     //uint[5] winnerloserscore; //  attaker wins 2 attacker loses
16     
17     event attackhappened (address attacker, address defender);
18     event buyhappened (address buyer, uint countryID);
19 
20     function Risk() 
21     {
22         owner = msg.sender;
23     }
24     
25     function buyCountry(uint8 countryID) payable returns(bool)
26     {
27         assert(ownerofCountry[countryID]==0); //country unowned
28         assert(msg.value == 10 finney); //0.01 ether
29         
30         totalmoney +=msg.value;
31         playerCountries[msg.sender].push(countryID);
32         ownerofCountry[countryID]=msg.sender;
33         playerList.push(msg.sender);
34         
35         buyhappened(msg.sender,countryID);
36         
37         return true;
38     }
39     
40     function attackCountry(uint8 countryID)
41     {
42         assert(playerCountries[msg.sender].length!=0); //player owns county
43         assert(ownerofCountry[countryID]!=address(0)); //country owned
44         assert(msg.sender!=ownerofCountry[countryID]); //not attacking its own country
45         
46         address attacker = msg.sender;
47         address defender = ownerofCountry[countryID];
48         
49         uint a=playerCountries[attacker].length;
50         uint b=playerCountries[defender].length;
51         
52         if(a<=1)
53             a=1;
54         else if(a<=4)
55             a=2;
56         else if(a<=9)
57             a=3;
58         else if(a<=16)
59             a=4;
60         else if(a<=25)
61             a=5;
62         else if(a<=36)
63             a=6;
64         else if(a<=49)
65             a=7;
66         else if(a<=64)
67             a=8;
68         else if(a<=81)
69             a=9;
70         else
71             a=10;
72         
73         if(b<=1)
74             b=1;
75         else if(b<=4)
76             b=2;
77         else if(b<=9)
78             b=3;
79         else if(b<=16)
80             b=4;
81         else if(b<=25)
82             b=5;
83         else if(b<=36)
84             b=6;
85         else if(b<=49)
86             b=7;
87         else if(b<=64)
88             b=8;
89         else if(b<=81)
90             b=9;
91         else
92             b=10;
93 
94         for(uint256 i=14;i>=11;i--)
95             winnerloser[i]=winnerloser[i-1];
96         for(i=9;i>=6;i--)
97             winnerloser[i]=winnerloser[i-1];
98         for(i=4;i>=1;i--)
99             winnerloser[i]=winnerloser[i-1];
100         
101         uint256 loopcount=0;
102         lastR=uint256(block.blockhash(block.number-1))%(a+b);
103         if(lastR<a) //attacker win
104         {
105             loopcount=playerCountries[defender].length;
106             for (i=0;i<loopcount;i++)
107             {
108                 playerCountries[attacker].push(playerCountries[defender][i]);
109                 ownerofCountry[playerCountries[defender][i]]=attacker;
110             }
111             playerCountries[defender].length=0;
112             winnerloser[0]=attacker;
113             winnerloser[5]=defender;
114             winnerloser[10]=1; //attacker wins
115         }
116         else //defender win
117         {
118             loopcount=playerCountries[attacker].length;
119             for (i=0;i<loopcount;i++)
120             {
121                 playerCountries[defender].push(playerCountries[attacker][i]);
122                 ownerofCountry[playerCountries[attacker][i]]=defender;
123             }
124             playerCountries[attacker].length=0;
125             winnerloser[0]=attacker;
126             winnerloser[5]=defender;
127             winnerloser[10]=2; //attacker loses
128         }
129         attackhappened(attacker,defender);
130         isGameEnd();
131     }
132     function isGameEnd()
133     {
134         uint256 loopcount=playerList.length;
135         address winner=owner;
136         
137         //require 15 country ownership for testing
138         bool del=false;
139         for (uint8 i=0; i<loopcount;i++)
140         {
141             if(playerCountries[playerList[i]].length>=winnerLimit) //iswinner
142             {
143                 winner=playerList[i];
144                 del=true;
145                 
146                 break;
147             }
148         }
149         //deleteeverything
150         if(del)
151         {
152             winner.transfer(totalmoney/10*9); //distribute 90%
153             owner.transfer(totalmoney/10);
154             totalmoney=0;
155             lastgameendWinner=winner;
156             for (i=0;i<178;i++)
157             {
158                 playerCountries[ownerofCountry[i]].length=0;
159                 ownerofCountry[i]=0;
160             }
161             playerList.length=0;
162             for(i=0;i<10;i++)
163                 winnerloser[i]=address(0);
164         }
165     }
166     function setwinnerLimit (uint8 x)
167     {
168         assert(msg.sender==owner);
169         winnerLimit=x;
170     }
171     function getCountryOwnershipList() constant returns (address[178])
172     {
173         return ownerofCountry;
174     }
175     function getTotalBet()constant returns (uint256)
176     {
177         return totalmoney;
178     }
179     function getaddr(address ax, uint8 bx) constant returns(address)
180     {
181         return playerCountries[ax][bx];
182     }
183     function len(address ax) constant returns(uint)
184     {
185         return playerCountries[ax].length;
186     }
187     function lastrandom() constant returns(uint256)
188     {
189         return lastR;
190     }
191     function getwinnerloser() constant returns(address[15])
192     {
193         return winnerloser;
194     }
195     function lastgamewinner() constant returns(address)
196     {
197         return lastgameendWinner;
198     }
199     
200 }