1 /**
2  * Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
3  */
4 
5 
6 pragma solidity ^0.4.19;
7 
8 contract owned {
9     address public owner;
10 
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 contract Bet4Land is owned {
26 
27     /* Struct for one game */
28     struct Game {
29         uint gameId;            // Unique id for a game
30         bytes8 landKey;         // Unique key for a land, derived from longitude and latitude
31         uint seedBlock;         // Block number whose hash as random seed
32         uint userNum;           // Number of users joined this game, maximum 100
33         string content;         // Full content of one game
34     }
35 
36     uint gameNum;
37     /* This notes all games and a map from gameId to gameIdx */
38     mapping(uint => Game) games;
39     mapping(uint => uint) indexMap;
40 
41     /** constructor */
42     function Bet4Land() public {
43         gameNum = 1;
44     }
45 
46     /**
47      * Initialize a new game
48      */
49     function newGame(uint gameId, bytes8 landKey, uint seedBlock, uint userNum, string content) onlyOwner public returns (uint gameIndex) {
50         require(indexMap[gameId] == 0);             // gameId should be unique
51         gameIndex = gameNum++;
52         indexMap[gameId] = gameIndex;
53         games[gameIndex] = Game(gameId, landKey, seedBlock, userNum, content);
54     }
55 
56     /**
57      * Get game info by index
58      * Only can be called by newOwner
59      */
60     function getGameInfoByIndex(uint gameIndex) onlyOwner public view returns (uint gameId, bytes8 landKey, uint seedBlock, uint userNum, string content) {
61         require(gameIndex < gameNum);               // should exist
62         require(gameIndex >= 1);                    // should exist
63         gameId = games[gameIndex].gameId;
64         landKey = games[gameIndex].landKey;
65         seedBlock = games[gameIndex].seedBlock;
66         userNum = games[gameIndex].userNum;
67         content = games[gameIndex].content;
68     }
69 
70     /**
71      * Get game info by game id
72      * Only can be called by newOwner
73      */
74     function getGameInfoById(uint gameId) public view returns (uint gameIndex, bytes8 landKey, uint seedBlock, uint userNum, string content) {
75         gameIndex = indexMap[gameId];
76         require(gameIndex < gameNum);              // should exist
77         require(gameIndex >= 1);                   // should exist
78         landKey = games[gameIndex].landKey;
79         seedBlock = games[gameIndex].seedBlock;
80         userNum = games[gameIndex].userNum;
81         content = games[gameIndex].content;
82     }
83 
84     /**
85      * Get the number of games
86      */
87     function getGameNum() onlyOwner public view returns (uint num) {
88         num = gameNum - 1;
89     }
90 }