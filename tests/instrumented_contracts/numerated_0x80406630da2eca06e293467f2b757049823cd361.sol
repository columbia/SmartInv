1 //
2 //                    %(/************/#&
3 //               (**,                 ,**/#
4 //            %/*,                        **(&
5 //          (*,                              //%
6 //        %*,                                  /(
7 //       (*      ,************************/      /*%
8 //      //         /(                  (/,        ,/%
9 //     (*           //(               //            /%
10 //    //             */%             //             //
11 //    /*         (((((///(((( ((((((//(((((,         /(
12 //    /           ,/%   //        (/    /*           //
13 //    /             //   //(    %//   (/*            ,/
14 //    /              //   ,/%   //   (/,             (/
15 //    /             %(//%   / //    ///(             //
16 //    //          %(/, ,/(   /   %//  //(           /(
17 //    (/         (//     /#      (/,     //(        (/
18 //     ((     %(/,        (/    (/,        //(      /,
19 //      ((    /,           *(*#(/            /*   %/,
20 //      /((                 /*((                 ((/
21 //        *(%                                  #(
22 //          ((%                              #(,
23 //            *((%                        #((,
24 //               (((%                   ((/
25 //                   *(((###*#&%###((((*
26 //
27 //
28 //                   ROULETTE.GORGONA.IO
29 //
30 // Win 120% with 80% chance!
31 //
32 //
33 // HOW TO PLAY
34 // Just send 1 ETH to the contract.
35 // When there are 5 players, a rally will be made, 4 lucky players will receive 1.2 ETH each!
36 //
37 //
38 // For more information visit https://roulette.gorgona.io/
39 //
40 // Telegram chat (ru): https://t.me/gorgona_io
41 // Telegram chat (en): https://t.me/gorgona_io_en
42 //
43 // For support and requests telegram: @alex_gorgona_io
44 
45 
46 pragma solidity ^0.4.24;
47 
48 contract Roulette {
49 
50     event newRound(uint number);
51     event newPlayer(address addr, uint roundNumber);
52     event playerWin(address indexed addr);
53     event playerLose(address indexed addr, uint8 num);
54 
55     uint public roundNumber = 1;
56     address public feeAddr;
57 
58     address[] public players;
59 
60     constructor() public
61     {
62         feeAddr = msg.sender;
63     }
64 
65     function() payable public
66     {
67         // ensure that payment not from contract
68         if (isContract()) {
69             revert();
70         }
71 
72         require(msg.value == 1 ether, "Enter price 1 ETH");
73         // save player
74         players.push(msg.sender);
75 
76         emit newPlayer(msg.sender, roundNumber);
77 
78         // if we have all players
79         if (players.length == 5) {
80             distributeFunds();
81             return;
82         }
83     }
84 
85     function countPlayers() public view returns (uint256)
86     {
87         return players.length;
88     }
89 
90     // Send ETH to winners
91     function distributeFunds() internal
92     {
93         // determine who is lose
94         uint8 loser = uint8(getRandom() % players.length + 1);
95 
96         for (uint i = 0; i <= players.length - 1; i++) {
97             // if it is loser - skip
98             if (loser == i + 1) {
99                 emit playerLose(players[i], loser);
100                 continue;
101             }
102 
103             // pay prize
104             if (players[i].send(1200 finney)) {
105                 emit playerWin(players[i]);
106             }
107         }
108 
109         // gorgona fee
110         feeAddr.transfer(address(this).balance);
111 
112         players.length = 0;
113         roundNumber ++;
114 
115         emit newRound(roundNumber);
116     }
117 
118     function getRandom() internal view returns (uint256)
119     {
120         uint256 num = uint256(keccak256(abi.encodePacked(blockhash(block.number - players.length), now)));
121 
122         for (uint i = 0; i <= players.length - 1; i++)
123         {
124             num ^= uint256(keccak256(abi.encodePacked(blockhash(block.number - i), uint256(players[i]) ^ num)));
125         }
126 
127         return num;
128     }
129 
130     // check that there is no contract in the middle
131     function isContract() internal view returns (bool) {
132         return msg.sender != tx.origin;
133     }
134 }