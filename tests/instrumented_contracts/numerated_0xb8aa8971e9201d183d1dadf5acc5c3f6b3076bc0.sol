1 pragma solidity ^0.4.18;
2 
3 contract HTLC {
4 ////////////////
5 //Global VARS//////////////////////////////////////////////////////////////////////////
6 //////////////
7     string public version;
8     bytes32 public digest;
9     address public dest;
10     uint public timeOut;
11     address issuer; 
12 /////////////
13 //MODIFIERS////////////////////////////////////////////////////////////////////
14 ////////////
15     modifier onlyIssuer {assert(msg.sender == issuer); _; }
16 //////////////
17 //Operations////////////////////////////////////////////////////////////////////////
18 //////////////
19 /*constructor */
20     //require all fields to create the contract
21     function HTLC(bytes32 _hash, address _dest, uint _timeLimit) public {
22         assert(digest != 0 || _dest != 0 || _timeLimit != 0);
23         digest = _hash;
24         dest = _dest;
25         timeOut = now + (_timeLimit * 1 hours);
26         issuer = msg.sender; 
27     }
28  /* public */   
29     //a string is subitted that is hash tested to the digest; If true the funds are sent to the dest address and destroys the contract    
30     function claim(string _hash) public returns(bool result) {
31        require(digest == sha256(_hash));
32        selfdestruct(dest);
33        return true;
34        }
35        //allow payments
36     function () public payable {}
37 
38 /* only issuer */
39     //if the time expires; the issuer can reclaim funds and destroy the contract
40     function refund() onlyIssuer public returns(bool result) {
41         require(now >= timeOut);
42         selfdestruct(issuer);
43         return true;
44     }
45 }
46 
47 
48 contract xcat {
49     string public version = "v1";
50     
51     struct txLog{
52         address issuer;
53         address dest;
54         string chain1;
55         string chain2;
56         uint amount1;
57         uint amount2;
58         uint timeout;
59         address crtAddr;
60         bytes32 hashedSecret; 
61     }
62     
63     event newTrade(string onChain, string toChain, uint amount1, uint amount2);
64     
65     mapping(bytes32 => txLog) public ledger;
66     
67     function testHash(string yourSecretPhrase) public returns (bytes32 SecretHash) {return(sha256(yourSecretPhrase));}
68     
69     function newXcat(bytes32 _SecretHash, address _ReleaseFundsTo, string _chain1, uint _amount1, string _chain2, uint _amount2, uint _MaxTimeLimit) public returns (address newContract) {
70         txLog storage tl = ledger[sha256(msg.sender,_ReleaseFundsTo,_SecretHash)];
71     //make the contract
72         HTLC h = new HTLC(_SecretHash, _ReleaseFundsTo, _MaxTimeLimit);
73     
74     //store info
75         tl.issuer = msg.sender;
76         tl.dest = _ReleaseFundsTo;
77         tl.chain1 = _chain1;
78         tl.chain2 = _chain2;
79         tl.amount1 = _amount1;
80         tl.amount2 = _amount2;
81         tl.timeout = _MaxTimeLimit;
82         tl.hashedSecret = _SecretHash; 
83         tl.crtAddr = h;
84         newTrade (tl.chain1, tl.chain2, tl.amount1, tl.amount2);
85         return h;
86     }
87 
88     //avoid taking funds
89     function() public { assert(0>1);} 
90 
91     // allow actors to view their tx
92     function viewXCAT(address _issuer, address _ReleaseFundsTo, bytes32 _SecretHash) public returns (address issuer, address receiver, uint amount1, string onChain, uint amount2, string toChain, uint atTime, address ContractAddress){
93         txLog storage tl = ledger[sha256(_issuer,_ReleaseFundsTo,_SecretHash)];
94         return (tl.issuer, tl.dest, tl.amount1, tl.chain1, tl.amount2, tl.chain2,tl.timeout, tl.crtAddr);
95     }
96 }
97 
98 /////////////////////////////////////////////////////////////////////////////
99   // 88888b   d888b  88b  88 8 888888         _.-----._
100   // 88   88 88   88 888b 88 P   88   \)|)_ ,'         `. _))|)
101   // 88   88 88   88 88`8b88     88    );-'/             \`-:(
102   // 88   88 88   88 88 `888     88   //  :               :  \\   .
103   // 88888P   T888P  88  `88     88  //_,'; ,.         ,. |___\\
104   //    .           __,...,--.       `---':(  `-.___.-'  );----'
105   //              ,' :    |   \            \`. `'-'-'' ,'/
106   //             :   |    ;   ::            `.`-.,-.-.','
107   //     |    ,-.|   :  _//`. ;|              ``---\` :
108   //   -(o)- (   \ .- \  `._// |    *               `.'       *
109   //     |   |\   :   : _ |.-  :              .        .
110   //     .   :\: -:  _|\_||  .-(    _..----..
111   //         :_:  _\\_`.--'  _  \,-'      __ \
112   //         .` \\_,)--'/ .'    (      ..'--`'          ,-.
113   //         |.- `-'.-               ,'                (///)
114   //         :  ,'     .            ;             *     `-'
115   //   *     :         :           /
116   //          \      ,'         _,'   88888b   888    88b  88 88  d888b  88
117   //           `._       `-  ,-'      88   88 88 88   888b 88 88 88   `  88
118   //            : `--..     :        *88888P 88   88  88`8b88 88 88      88
119   //        .   |           |	        88    d8888888b 88 `888 88 88   ,  `"
120   //            |           | 	      88    88     8b 88  `88 88  T888P  88
121   /////////////////////////////////////////////////////////////////////////