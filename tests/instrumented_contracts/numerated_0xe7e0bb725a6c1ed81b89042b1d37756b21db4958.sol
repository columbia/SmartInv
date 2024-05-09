1 pragma solidity ^0.4.13;
2 
3 contract token {
4     function transfer(address _to, uint256 _value);
5     function balanceOf(address _owner) constant returns (uint256 balance);	
6 }
7 
8 contract BDSM_Crowdsale {
9     
10     token public sharesTokenAddress; // token address
11     address public owner;
12     address public safeContract;
13 
14 	uint public startICO = 1513728000; // start ICO - 20 December 2017
15 	uint public stopICO = 1521504000; // end ICO - 20 March 2018
16 	uint public price = 0.0035 * 1 ether; // ETH for 1 package of tokens
17 	uint coeff = 100000; // capacity of 1 package
18 	
19 	uint256 public tokenSold = 0; // tokens sold
20 	uint256 public tokenFree = 0; // tokens free
21 	bool public crowdsaleClosed = false;
22     bool public tokenWithdraw = false;
23 	
24 	event TokenFree(uint256 value);
25 	event CrowdsaleClosed(bool value);
26     
27 	function BDSM_Crowdsale(address _tokenAddress, address _owner, address _stopScamHolder) {
28 		owner = _owner;
29 		sharesTokenAddress = token(_tokenAddress);
30 		safeContract = _stopScamHolder;
31 	}
32 
33 	function() payable {
34 	    
35 	    if(now > 1519084800) price = 0.0105 * 1 ether; // if time later than - 20 February 2018 - price x3
36 	    else if(now > 1516406400) price = 0.0070 * 1 ether; // if time later than - 20 January 2018 - price x2
37 	    
38 		tokenFree = sharesTokenAddress.balanceOf(this); // free tokens count
39 		
40 		if (now < startICO) {
41 		    msg.sender.transfer(msg.value);
42 		}
43 		else if (now > stopICO) {
44 			msg.sender.transfer(msg.value); // if crowdsale closed - cash back
45 			if(!tokenWithdraw){ // when crowdsale closed - unsold tokens transfer to stopScamHolder
46 			    sharesTokenAddress.transfer(safeContract, sharesTokenAddress.balanceOf(this));
47 			    tokenFree = sharesTokenAddress.balanceOf(this);
48 			    tokenWithdraw = true;
49 			    crowdsaleClosed = true;
50 			}
51 		} 
52 		else if (crowdsaleClosed) {
53 			msg.sender.transfer(msg.value); // if no more tokens - cash back
54 		} 
55 		else {
56 			uint256 tokenToBuy = msg.value / price * coeff; // tokens to buy
57 			if(tokenToBuy <= 0) msg.sender.transfer(msg.value); // mistake protector
58 			require(tokenToBuy > 0);
59 			uint256 actualETHTransfer = tokenToBuy * price / coeff;
60 			if (tokenFree >= tokenToBuy) { // free tokens >= tokens to buy, sell tokens
61 				owner.transfer(actualETHTransfer);
62 				if (msg.value > actualETHTransfer){ // if more than need - cash back
63 					msg.sender.transfer(msg.value - actualETHTransfer);
64 				}
65 				sharesTokenAddress.transfer(msg.sender, tokenToBuy);
66 				tokenSold += tokenToBuy;
67 				tokenFree -= tokenToBuy;
68 				if(tokenFree==0) crowdsaleClosed = true;
69 			} else { // free tokens < tokens to buy 
70 				uint256 sendETH = tokenFree * price / coeff; // price for all free tokens
71 				owner.transfer(sendETH); 
72 				sharesTokenAddress.transfer(msg.sender, tokenFree); 
73 				msg.sender.transfer(msg.value - sendETH); // more than need - cash back
74 				tokenSold += tokenFree;
75 				tokenFree = sharesTokenAddress.balanceOf(this);
76 				crowdsaleClosed = true;
77 			}
78 		}
79 		TokenFree(tokenFree);
80 		CrowdsaleClosed(crowdsaleClosed);
81 	}
82 }