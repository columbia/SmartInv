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
67         require(msg.value == 1 ether, "Enter price 1 ETH");
68         // save player
69         players.push(msg.sender);
70 
71         emit newPlayer(msg.sender, roundNumber);
72 
73         // if we have all players
74         if (players.length == 5) {
75             distributeFunds();
76             return;
77         }
78     }
79 
80     function countPlayers() public view returns (uint256)
81     {
82         return players.length;
83     }
84 
85     // Send ETH to winners
86     function distributeFunds() internal
87     {
88         // determine who is lose
89         uint8 loser = uint8(getRandom() % players.length + 1);
90 
91         for (uint i = 0; i <= players.length - 1; i++) {
92             // if it is loser - skip
93             if (loser == i + 1) {
94                 emit playerLose(players[i], loser);
95                 continue;
96             }
97 
98             // pay prize
99             if (players[i].send(1200 finney)) {
100                 emit playerWin(players[i]);
101             }
102         }
103 
104         // gorgona fee
105         feeAddr.transfer(address(this).balance);
106 
107         players.length = 0;
108         roundNumber ++;
109 
110         emit newRound(roundNumber);
111     }
112 
113     function getRandom() internal view returns (uint256)
114     {
115         uint256 num = uint256(keccak256(abi.encodePacked(blockhash(block.number - players.length), now)));
116 
117         for (uint i = 0; i <= players.length - 1; i++)
118         {
119             num ^= uint256(keccak256(abi.encodePacked(blockhash(block.number - i), uint256(players[i]) ^ num)));
120         }
121 
122         return num;
123     }
124 }