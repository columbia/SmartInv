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
14 	uint public startICO_20_December = 1513728060; // start ICO - 20 December 2017
15 	uint public stopICO_20_March = 1521504060; // end ICO - 20 March 2018
16 	uint public priceIncrease_20_January = 1516406460; // if time later than - 20 January 2018 - price +50%
17 	uint public priceIncrease_20_February = 1519084860; // if time later than - 20 February 2018 - price +100%
18 	string public price = "0.0035 Ether for 1 microBDSM";
19 	uint realPrice = 0.0035 * 1 ether; // ETH for 1 package of tokens
20 	uint coeff = 100000; // capacity of 1 package
21 	
22 	uint256 public tokenSold = 0; // tokens sold
23 	uint256 public tokenFree = 0; // tokens free
24 	bool public crowdsaleClosed = false;
25     bool public tokensWithdrawn = false;
26 	
27 	event TokenFree(uint256 value);
28 	event CrowdsaleClosed(bool value);
29     
30 	function BDSM_Crowdsale(address _tokenAddress, address _owner, address _stopScamHolder) {
31 		owner = _owner;
32 		sharesTokenAddress = token(_tokenAddress);
33 		safeContract = _stopScamHolder;
34 	}
35 
36 	function() payable {
37 	    
38 	    if(now > priceIncrease_20_February){
39 	        price = "0.007 Ether for 1 microBDSM";
40 	        realPrice = 0.007 * 1 ether; 
41 	    } 
42 	    else if(now > priceIncrease_20_January){
43 	        price = "0.00525 Ether for 1 microBDSM";
44 	        realPrice = 0.00525 * 1 ether;
45 	    } 
46 	    
47 		tokenFree = sharesTokenAddress.balanceOf(this); // free tokens count
48 		
49 		if (now < startICO_20_December) {
50 		    msg.sender.transfer(msg.value);
51 		}
52 		else if (now > stopICO_20_March) {
53 			msg.sender.transfer(msg.value); // if crowdsale closed - cash back
54 			if(!tokensWithdrawn){ // when crowdsale closed - unsold tokens transfer to stopScamHolder
55 			    sharesTokenAddress.transfer(safeContract, sharesTokenAddress.balanceOf(this));
56 			    tokenFree = sharesTokenAddress.balanceOf(this);
57 			    tokensWithdrawn = true;
58 			    crowdsaleClosed = true;
59 			}
60 		} 
61 		else if (crowdsaleClosed) {
62 			msg.sender.transfer(msg.value); // if no more tokens - cash back
63 		} 
64 		else {
65 			uint256 tokenToBuy = msg.value / realPrice * coeff; // tokens to buy
66 			if(tokenToBuy <= 0) msg.sender.transfer(msg.value); // mistake protector
67 			require(tokenToBuy > 0);
68 			uint256 actualETHTransfer = tokenToBuy * realPrice / coeff;
69 			if (tokenFree >= tokenToBuy) { // free tokens >= tokens to buy, sell tokens
70 				owner.transfer(actualETHTransfer);
71 				if (msg.value > actualETHTransfer){ // if more than need - cash back
72 					msg.sender.transfer(msg.value - actualETHTransfer);
73 				}
74 				sharesTokenAddress.transfer(msg.sender, tokenToBuy);
75 				tokenSold += tokenToBuy;
76 				tokenFree -= tokenToBuy;
77 				if(tokenFree==0) crowdsaleClosed = true;
78 			} else { // free tokens < tokens to buy 
79 				uint256 sendETH = tokenFree * realPrice / coeff; // price for all free tokens
80 				owner.transfer(sendETH); 
81 				sharesTokenAddress.transfer(msg.sender, tokenFree); 
82 				msg.sender.transfer(msg.value - sendETH); // more than need - cash back
83 				tokenSold += tokenFree;
84 				tokenFree = sharesTokenAddress.balanceOf(this);
85 				crowdsaleClosed = true;
86 			}
87 		}
88 		TokenFree(tokenFree);
89 		CrowdsaleClosed(crowdsaleClosed);
90 	}
91 }