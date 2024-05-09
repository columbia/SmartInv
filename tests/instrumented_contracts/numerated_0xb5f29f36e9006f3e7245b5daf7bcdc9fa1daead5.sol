1 /*
2 *
3 * ███████╗████████╗██╗  ██╗     █████╗ ███╗   ██╗████████╗███████╗
4 * ██╔════╝╚══██╔══╝██║  ██║    ██╔══██╗████╗  ██║╚══██╔══╝██╔════╝
5 * █████╗     ██║   ███████║    ███████║██╔██╗ ██║   ██║   █████╗  
6 * ██╔══╝     ██║   ██╔══██║    ██╔══██║██║╚██╗██║   ██║   ██╔══╝  
7 * ███████╗   ██║   ██║  ██║    ██║  ██║██║ ╚████║   ██║   ███████╗
8 * ╚══════╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
9 *                 
10 * //*** This Game Pays The Last One To Bid Before The Time Runs Out
11 *
12 * "Now I am become Death, the destroyer of worlds"
13 *  
14 * //*** Developed By:
15 *   _____       _         _         _ ___ _         
16 *  |_   _|__ __| |_  _ _ (_)__ __ _| | _ (_)___ ___ 
17 *    | |/ -_) _| ' \| ' \| / _/ _` | |   / (_-</ -_)
18 *    |_|\___\__|_||_|_||_|_\__\__,_|_|_|_\_/__/\___|
19 *   
20 *   © 2018 TechnicalRise.  Written in March 2018.  
21 *   All rights reserved.  Do not copy, adapt, or otherwise use without permission.
22 *   https://www.reddit.com/user/TechnicalRise/
23 *  
24 */
25 
26 pragma solidity ^0.4.20;
27 
28 contract EthAnte {
29     
30     uint public timeOut;
31     uint public kBalance;
32     uint public feeRate;
33     address public TechnicalRise = 0x7c0Bf55bAb08B4C1eBac3FC115C394a739c62538;
34     address public lastBidder;
35     
36     function EthAnte() public payable { 
37         lastBidder = msg.sender;
38 		kBalance = msg.value;
39 	    timeOut = now + 10 minutes;
40 	    feeRate = 100; // i.e. 1%
41 	} 
42 	
43 	function fund() public payable {
44 		uint _fee = msg.value / feeRate;
45 	    uint _val = msg.value - _fee;
46 	    kBalance += _val;
47 	    TechnicalRise.transfer(_fee);
48 	    
49 	    // If they sent nothing or almost nothing, 
50 	    // merely extend the time but don't make them
51 	    // eligible to win (Note that there is a trick 
52 	    // play available here)
53 	    if(_val < 9900 szabo) {
54 	        timeOut += 2 minutes;
55 	        return;
56 	    }
57 	    
58 	    // If the transaction is after the timer 
59 	    // runs out pay the winner
60 	    if (timeOut <= now) {
61 	        lastBidder.transfer(kBalance - _val);
62 	        kBalance = _val;
63 	        timeOut = now;
64 	    }
65 	    
66 	    // The more you put in the less time you add
67 	    timeOut += (10 minutes) * (9900 szabo) / _val;
68 	    lastBidder = msg.sender;
69 	}
70 
71 	function () public payable {
72 		fund();
73 	}
74 }