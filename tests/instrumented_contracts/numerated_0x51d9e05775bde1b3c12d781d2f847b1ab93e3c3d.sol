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
31     uint public feeRate;
32     address public TechnicalRise = 0x7c0Bf55bAb08B4C1eBac3FC115C394a739c62538;
33     address public lastBidder;
34     
35     function EthAnte() public payable { 
36         lastBidder = msg.sender;
37 	    timeOut = now + 1 hours;
38 	    feeRate = 10; // i.e. 10%
39 	} 
40 	
41 	function fund() public payable {
42 	    require(msg.value >= 1 finney);
43 	    
44 	    // If the transaction is after the timer 
45 	    // runs out pay the winner
46 	    if (timeOut <= now) {
47 	        TechnicalRise.transfer((address(this).balance - msg.value) / feeRate);
48 	        lastBidder.transfer((address(this).balance - msg.value) - address(this).balance / feeRate);
49 	    }
50 	    
51 	    timeOut = now + 1 hours;
52 	    lastBidder = msg.sender;
53 	}
54 
55 	function () public payable {
56 		fund();
57 	}
58 }