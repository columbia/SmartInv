1 pragma solidity ^0.4.13;
2 
3 contract token { 
4     function transfer(address _to, uint256 _value);
5 	function balanceOf(address _owner) constant returns (uint256 balance);	
6 }
7 
8 contract Crowdsale {
9 
10 	token public sharesTokenAddress; // token address
11 
12 	uint public startICO = now; // start ICO
13 	uint public periodICO; // duration ICO
14 	uint public stopICO; // end ICO
15 	uint public price = 0.0035 * 1 ether; // ETH for 1 package of tokens
16 	uint coeff = 200000; // capacity of 1 package
17 	
18 	uint256 public tokenSold = 0; // tokens sold
19 	uint256 public tokenFree = 0; // tokens free
20 	bool public crowdsaleClosed = false;
21 
22 	address public owner;
23 	
24 	event TokenFree(uint256 value);
25 	event CrowdsaleClosed(bool value);
26     
27 	function Crowdsale(address _tokenAddress, address _owner, uint _timePeriod) {
28 		owner = _owner;
29 		sharesTokenAddress = token(_tokenAddress);
30 		periodICO = _timePeriod * 1 hours;
31 		stopICO = startICO + periodICO;
32 	}
33 
34 	function() payable {
35 		tokenFree = sharesTokenAddress.balanceOf(this); // free tokens count
36 		if (now < startICO) {
37 		    msg.sender.transfer(msg.value);
38 		}
39 		else if (now > (stopICO + 1)) {
40 			msg.sender.transfer(msg.value); // if crowdsale closed - cash back
41 			crowdsaleClosed = true;
42 		} 
43 		else if (crowdsaleClosed) {
44 			msg.sender.transfer(msg.value); // if no more tokens - cash back
45 		} 
46 		else {
47 			uint256 tokenToBuy = msg.value / price * coeff; // tokens to buy
48 			require(tokenToBuy > 0);
49 			uint256 actualETHTransfer = tokenToBuy * price / coeff;
50 			if (tokenFree >= tokenToBuy) { // free tokens >= tokens to buy, sell tokens
51 				owner.transfer(actualETHTransfer);
52 				if (msg.value > actualETHTransfer){ // if more than need - cash back
53 					msg.sender.transfer(msg.value - actualETHTransfer);
54 				}
55 				sharesTokenAddress.transfer(msg.sender, tokenToBuy);
56 				tokenSold += tokenToBuy;
57 				tokenFree -= tokenToBuy;
58 				if(tokenFree==0) crowdsaleClosed = true;
59 			} else { // free tokens < tokens to buy 
60 				uint256 sendETH = tokenFree * price / coeff; // price for all free tokens
61 				owner.transfer(sendETH); 
62 				sharesTokenAddress.transfer(msg.sender, tokenFree); 
63 				msg.sender.transfer(msg.value - sendETH); // more than need - cash back
64 				tokenSold += tokenFree;
65 				tokenFree = 0;
66 				crowdsaleClosed = true;
67 			}
68 		}
69 		TokenFree(tokenFree);
70 		CrowdsaleClosed(crowdsaleClosed);
71 	}
72 	
73 	function unsoldTokensBack(){ // after crowdsale we can take back all unsold tokens from crowdsale	    
74 	    require(crowdsaleClosed);
75 		require(msg.sender == owner);
76 	    sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this));
77 		tokenFree = 0;
78 	}	
79 }