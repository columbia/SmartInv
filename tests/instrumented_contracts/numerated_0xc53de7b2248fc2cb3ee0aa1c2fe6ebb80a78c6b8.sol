1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.4;
3 
4 /*
5 -----------------------------------------------
6  __   __   __         ___ ___         __   __  
7 |__) |__) /  \  |\/| |__   |  |__| | /  \ /__` 
8 |    |  \ \__/  |  | |___  |  |  | | \__/ .__/ 
9                                                
10 -----------------------------------------------
11 * AirdropSignal.sol
12 */
13 
14 /**
15  * README Documentation
16  * This Contract is to signal which chain users would like to receive their airdrop.
17  * The airdrop itself will be calculated off-chain and deployed separately.
18  * To receive the airdrop users **MUST** be on the snapshot **AND** call claimOn from their address.
19  * ***No on can claim your airdrop address for you.***
20 
21  * To receive the referral bonus, a user must:
22  *   1. Set a referralENS. It can be any valid ENS!
23  *   2. The owner of the ENS must also set their preferred chain from the address that owns the ENS.
24  *
25  * Note: Both addresses must set their preferred chain for either to receive their bonus.
26  *
27  * Although the function is open for any address to call claimON, we will verify they are in the snapshot off-chain
28  * and resolve the ENS owner's address before launch. We will deploy the airdrop separately.
29  * 
30  */
31 
32 contract AirdropSignal {
33     enum PreferredChain {
34         None,
35         Arbitrum,
36         Optimism
37     }
38 
39     struct Claimr {
40         PreferredChain chain;
41         string referralENS; //Any valid ENS
42     }
43 
44     mapping(address => Claimr) public claimrs;
45 
46     event ClaimSet(address user, PreferredChain chain, string referralENS);
47 
48     /*
49      *  Signal where you'd like to receive your airdrop.
50      *   - PreferredChain = Arbitrum or Optimism
51      *   - referralENS = The ENS you want to refer. It can be any valid ENS!
52      *
53      * Setting a referral ENS is optional to recieving your aidrop.
54      */
55     function claimOn(PreferredChain chain, string memory friendENS) external {
56         claimrs[msg.sender].chain = chain;
57         claimrs[msg.sender].referralENS = friendENS;
58 
59         emit ClaimSet(msg.sender, chain, friendENS);
60     }
61 
62     /*
63      * Set your preferred chain. You can call this again if you change your mind before launch.
64      */
65     function setChain(PreferredChain chain) external returns (bool success) {
66         claimrs[msg.sender].chain = chain;
67 
68         emit ClaimSet(msg.sender, claimrs[msg.sender].chain, claimrs[msg.sender].referralENS);
69 
70         return true;
71     }
72 
73     /*
74      * Set a referralENS. Remember, they **MUST** also submit a claim from the address that owns that ENS.
75      * We will resolve the ENS off chain before launch.
76      */
77     function setReferralENS(string memory friendENS) external returns (bool success) {
78         claimrs[msg.sender].referralENS = friendENS;
79 
80         emit ClaimSet(msg.sender, claimrs[msg.sender].chain, claimrs[msg.sender].referralENS);
81 
82         return true;
83     }
84 }
85 
86 /* MIT License
87  * ===========
88  *
89  * Copyright (c) 2023 Promethios
90  *
91  * Permission is hereby granted, free of charge, to any person obtaining a copy
92  * of this software and associated documentation files (the "Software"), to deal
93  * in the Software without restriction, including without limitation the rights
94  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
95  * copies of the Software, and to permit persons to whom the Software is
96  * furnished to do so, subject to the following conditions:
97  *
98  * The above copyright notice and this permission notice shall be included in all
99  * copies or substantial portions of the Software.
100  *
101  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
102  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
103  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
104  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
105  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
106  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
107  */