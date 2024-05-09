1 pragma solidity ^0.4.25;
2 
3 /*
4     Lambo Lotto Win | Dapps game for real crypto human
5     site: https://llotto.win/
6     telegram: https://t.me/Lambollotto/
7     discord: https://discord.gg/VWV5jeW/
8     
9     win 122%, bet 0.15 ETH, 5 players 4 winners
10     win 131%, bet 0.10 ETH, 4 players 3 winners
11     win 144%, bet 0.05 ETH, 3 players 2 winners
12     win 194%, bet 0.01 ETH, 2 players 1 winners
13 */    
14     
15 contract umbrellaLlotto {
16     
17     address public tech = msg.sender;
18     address public promo = msg.sender;
19 
20     uint private techGet = 0;
21     uint private promoGet = 0;
22     
23     address[] public placesFirst;
24     address[] public placesSecond;
25     address[] public placesThird;
26     address[] public placesFour;
27     
28     uint private seed;
29     
30     uint public totalIn;
31     
32     uint public roundPlacesFirst = 1;
33     uint public roundPlacesSecond = 1;
34     uint public roundPlacesThird = 1;
35     uint public roundPlacesFour = 1;
36 
37     event playerFirstEvent(uint numpl, address pl, uint indexed round);
38     event playerSecondEvent(uint numpl, address pl, uint indexed round);
39     event playerThirdEvent(uint numpl, address pl, uint indexed round);
40     event playerFourEvent(uint numpl, address pl, uint indexed round);
41 
42     event placesFirstEvent(address indexed pl, uint round, bool win);
43     event placesSecondEvent(address indexed pl, uint round, bool win);
44     event placesThirdEvent(address indexed pl, uint round, bool win);
45     event placesFourEvent(address indexed pl, uint round, bool win);
46     
47     // returns a pseudo-random number
48     function random(uint lessThan) internal returns (uint) {
49         return uint(sha256(abi.encodePacked(
50             blockhash(block.number - lessThan - 1),
51             msg.sender,
52             seed += (block.difficulty % lessThan)
53         ))) % lessThan;
54     }
55     
56     function() external payable {
57         
58         require(msg.sender == tx.origin);
59         require(msg.value == 0.15 ether || msg.value == 0.1 ether || msg.value == 0.05 ether || msg.value == 0.01 ether);
60         
61         totalIn += msg.value;
62         
63         if(msg.value == 0.01 ether) // 1 from 2 players get 194%
64         {
65             placesFirst.push(msg.sender);
66             emit playerFirstEvent(placesFirst.length , msg.sender, roundPlacesFirst);
67             
68             if (placesFirst.length == 2) {
69                 uint loserF = random(placesFirst.length);
70                 for (uint iF = 0; iF < placesFirst.length; iF++) {
71                     if (iF != loserF) {
72                         placesFirst[iF].transfer(0.0194 ether);
73                         emit placesFirstEvent(placesFirst[iF], roundPlacesFirst, true);
74                     }else{
75                         emit placesFirstEvent(placesFirst[iF], roundPlacesFirst, false);
76                     }
77                 }
78                 
79                 promoGet += 0.0004 ether;
80                 techGet += 0.0002 ether;
81                 
82                 delete placesFirst;
83                 roundPlacesFirst++;
84             }
85         }
86 
87         if(msg.value == 0.05 ether) // 2 from 3 players get 144%
88         {
89             placesSecond.push(msg.sender);
90             emit playerSecondEvent(placesSecond.length, msg.sender, roundPlacesSecond);
91             
92             if (placesSecond.length == 3) {
93                 uint loserS = random(placesSecond.length);
94                 for (uint iS = 0; iS < placesSecond.length; iS++) {
95                     if (iS != loserS) {
96                         placesSecond[iS].transfer(0.072 ether);
97                         emit placesSecondEvent(placesSecond[iS], roundPlacesSecond, true);
98                     }else{
99                         emit placesSecondEvent(placesSecond[iS], roundPlacesSecond, false);
100                     }
101                 }
102 
103                 promoGet += 0.004 ether;
104                 techGet += 0.002 ether;
105                 
106                 delete placesSecond;
107                 roundPlacesSecond++;
108             }
109         }
110         
111         if(msg.value == 0.1 ether) // 3 from 4 players get 131%
112         {
113             placesThird.push(msg.sender);
114             emit playerThirdEvent(placesThird.length, msg.sender, roundPlacesThird);
115             
116             if (placesThird.length == 4) {
117                 uint loserT = random(placesThird.length);
118                 for (uint iT = 0; iT < placesThird.length; iT++) {
119                     if (iT != loserT) {
120                         placesThird[iT].transfer(0.131 ether);
121                         emit placesThirdEvent(placesThird[iT], roundPlacesThird, true);
122                     }else{
123                         emit placesThirdEvent(placesThird[iT], roundPlacesThird, false);
124                     }
125                 }
126 
127                 promoGet += 0.004 ether;
128                 techGet += 0.003 ether;
129                 
130                 delete placesThird;
131                 roundPlacesThird++;
132             }
133         } 
134         
135         if(msg.value == 0.15 ether) // 4 from 5 players get 122%
136         {
137             placesFour.push(msg.sender);
138             emit playerFourEvent(placesFour.length, msg.sender, roundPlacesFour);
139             
140             if (placesFour.length == 5) {
141                 uint loserFr = random(placesFour.length);
142                 for (uint iFr = 0; iFr < placesFour.length; iFr++) {
143                     if (iFr != loserFr) {
144                         placesFour[iFr].transfer(0.183 ether);
145                         emit placesFourEvent(placesFour[iFr], roundPlacesFour, true);
146                     }else{
147                         emit placesFourEvent(placesFour[iFr], roundPlacesFour, false);
148                     }
149                 }
150 
151                 promoGet += 0.012 ether;
152                 techGet += 0.006 ether;
153                 
154                 delete placesFour;
155                 roundPlacesFour++;
156             }
157         }        
158 
159     }
160     
161     function promoGetGift() public{
162         require(msg.sender == promo);
163         if(promo.send(promoGet)){
164             promoGet = 0;
165         }    
166     } 
167     
168     function techGetGift() public{
169         require(msg.sender == tech);
170         if(tech.send(techGet)){
171             techGet = 0;
172         }
173     }   
174     
175     function setPromoGet(address _newPromoGet)
176         public{
177         require(msg.sender == tech);
178         require(msg.sender == tx.origin);
179         promo =  _newPromoGet;
180     }    
181 }