1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // BokkyPooBah's Tricky Stick Leaderboard (Cancun)
5 //
6 // Deployed to 0xA0ecd8eF29750E7c3501C5568FDD9F4f5bCfe3d9
7 //
8 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 // ----------------------------------------------------------------------------
12 // BokkyPooBah's Tricky Stick Leaderboard (Cancun)
13 // ----------------------------------------------------------------------------
14 contract BokkyPooBahTrickyStickLeaderboard  {
15 
16     // ------------------------------------------------------------------------
17     // Event
18     // ------------------------------------------------------------------------
19     event Solved(address indexed account, string name, string timeToSolve);
20 
21 
22     // ------------------------------------------------------------------------
23     // Self-report the time it took you to solve (or not)
24     // ------------------------------------------------------------------------
25     function solved(string name, string timeToSolve) public {
26         Solved(msg.sender, name, timeToSolve);
27     }
28 
29 
30     // ------------------------------------------------------------------------
31     // Don't accept ethers - no payable modifier
32     // ------------------------------------------------------------------------
33     function () public {
34     }
35 }