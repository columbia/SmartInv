1 // Hashed Time-Locked Contract transactions
2 // HashTimelocked contract for cross-chain atomic swaps
3 // @authors:
4 // Cody Burns <dontpanic@codywburns.com>
5 // license: Apache 2.0
6 
7 /* usage:
8 Victor (the "buyer") and Peggy (the "seller") exchange public keys and mutually agree upon a timeout threshold. 
9     Peggy provides a hash digest. Both parties can now
10         - construct the script and P2SH address for the HTLC.
11         - Victor sends funds to the P2SH address or contract.
12 Either:
13     Peggy spends the funds, and in doing so, reveals the preimage to Victor in the transaction; OR
14     Victor recovers the funds after the timeout threshold.
15 
16 Victor is interested in a lower timeout to reduce the amount of time that his funds are encumbered in the event that Peggy
17 does not reveal the preimage. Peggy is interested in a higher timeout to reduce the risk that she is unable to spend the
18 funds before the threshold, or worse, that her transaction spending the funds does not enter the blockchain before Victor's 
19 but does reveal the preimage to Victor anyway.
20 
21 script hash from BIP 199: Hashed Time-Locked Contract transactions for BTC like chains
22 
23 OP_IF
24     [HASHOP] <digest> OP_EQUALVERIFY OP_DUP OP_HASH160 <seller pubkey hash>            
25 OP_ELSE
26     <num> [TIMEOUTOP] OP_DROP OP_DUP OP_HASH160 <buyer pubkey hash>
27 OP_ENDIF
28 OP_EQUALVERIFY
29 OP_CHECKSIG
30 
31 */
32 
33 
34 pragma solidity ^0.4.18;
35 
36 contract HTLC {
37     
38 ////////////////
39 //Global VARS//////////////////////////////////////////////////////////////////////////
40 //////////////
41 
42     string public version = "0.0.1";
43     bytes32 public digest = 0x2e99758548972a8e8822ad47fa1017ff72f06f3ff6a016851f45c398732bc50c;
44     address public dest = 0x9552ae966A8cA4E0e2a182a2D9378506eB057580;
45     uint public timeOut = now + 1 hours;
46     address issuer = msg.sender; 
47 
48 /////////////
49 //MODIFIERS////////////////////////////////////////////////////////////////////
50 ////////////
51 
52     
53     modifier onlyIssuer {require(msg.sender == issuer); _; }
54 
55 //////////////
56 //Operations////////////////////////////////////////////////////////////////////////
57 //////////////
58 
59 /* public */   
60     //a string is subitted that is hash tested to the digest; If true the funds are sent to the dest address and destroys the contract    
61     function claim(string _hash) public returns(bool result) {
62        require(digest == sha256(_hash));
63        selfdestruct(dest);
64        return true;
65        }
66     
67     // allow payments
68     function () public payable {}
69 
70 /* only issuer */
71     //if the time expires; the issuer can reclaim funds and destroy the contract
72     function refund() onlyIssuer public returns(bool result) {
73         require(now >= timeOut);
74         selfdestruct(issuer);
75         return true;
76     }
77 }
78 
79 /////////////////////////////////////////////////////////////////////////////
80   // 88888b   d888b  88b  88 8 888888         _.-----._
81   // 88   88 88   88 888b 88 P   88   \)|)_ ,'         `. _))|)
82   // 88   88 88   88 88`8b88     88    );-'/             \`-:(
83   // 88   88 88   88 88 `888     88   //  :               :  \\   .
84   // 88888P   T888P  88  `88     88  //_,'; ,.         ,. |___\\
85   //    .           __,...,--.       `---':(  `-.___.-'  );----'
86   //              ,' :    |   \            \`. `'-'-'' ,'/
87   //             :   |    ;   ::            `.`-.,-.-.','
88   //     |    ,-.|   :  _//`. ;|              ``---\` :
89   //   -(o)- (   \ .- \  `._// |    *               `.'       *
90   //     |   |\   :   : _ |.-  :              .        .
91   //     .   :\: -:  _|\_||  .-(    _..----..
92   //         :_:  _\\_`.--'  _  \,-'      __ \
93   //         .` \\_,)--'/ .'    (      ..'--`'          ,-.
94   //         |.- `-'.-               ,'                (///)
95   //         :  ,'     .            ;             *     `-'
96   //   *     :         :           /
97   //          \      ,'         _,'   88888b   888    88b  88 88  d888b  88
98   //           `._       `-  ,-'      88   88 88 88   888b 88 88 88   `  88
99   //            : `--..     :        *88888P 88   88  88`8b88 88 88      88
100   //        .   |           |	        88    d8888888b 88 `888 88 88   ,  `"
101   //            |           | 	      88    88     8b 88  `88 88  T888P  88
102   /////////////////////////////////////////////////////////////////////////