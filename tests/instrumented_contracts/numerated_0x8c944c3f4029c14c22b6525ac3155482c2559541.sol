1 pragma solidity ^0.4.13;
2 
3 contract token {
4     function transfer(address _to, uint256 _value);
5     function balanceOf(address _owner) constant returns (uint256 balance);	
6 }
7 
8 contract BDSM_Presale {
9     
10     token public sharesTokenAddress; // token address
11     address public owner;
12     address public safeContract;
13 
14 	uint public presaleStart_6_December = 1512518460; // start Presale - 6 December 2017
15 	uint public presaleStop_13_December = 1513123260; // end Presale - 13 December 2017
16 	string public price = "0.0035 Ether for 2 microBDSM";
17 	uint realPrice = 0.0035 * 1 ether; // ETH for 1 package of tokens
18 	uint coeff = 200000; // capacity of 1 package
19 	
20 	uint256 public tokenSold = 0; // tokens sold
21 	uint256 public tokenFree = 0; // tokens free
22 	bool public presaleClosed = false;
23     bool public tokensWithdrawn = false;
24 	
25 	event TokenFree(uint256 value);
26 	event PresaleClosed(bool value);
27     
28 	function BDSM_Presale(address _tokenAddress, address _owner, address _stopScamHolder) {
29 		owner = _owner;
30 		sharesTokenAddress = token(_tokenAddress);
31 		safeContract = _stopScamHolder;
32 	}
33 
34 	function() payable {
35 	    
36 		tokenFree = sharesTokenAddress.balanceOf(this); // free tokens count
37 		
38 		if (now < presaleStart_6_December) {
39 		    msg.sender.transfer(msg.value);
40 		}
41 		else if (now > presaleStop_13_December) {
42 			msg.sender.transfer(msg.value); // if presale closed - cash back
43 			if(!tokensWithdrawn){ // when presale closed - unsold tokens transfer to stopScamHolder
44 			    sharesTokenAddress.transfer(safeContract, sharesTokenAddress.balanceOf(this));
45 			    tokenFree = sharesTokenAddress.balanceOf(this);
46 			    tokensWithdrawn = true;
47 			    presaleClosed = true;
48 			}
49 		} 
50 		else if (presaleClosed) {
51 			msg.sender.transfer(msg.value); // if no more tokens - cash back
52 		} 
53 		else {
54 			uint256 tokenToBuy = msg.value / realPrice * coeff; // tokens to buy
55 			if(tokenToBuy <= 0) msg.sender.transfer(msg.value); // mistake protector
56 			require(tokenToBuy > 0);
57 			uint256 actualETHTransfer = tokenToBuy * realPrice / coeff;
58 			if (tokenFree >= tokenToBuy) { // free tokens >= tokens to buy, sell tokens
59 				owner.transfer(actualETHTransfer);
60 				if (msg.value > actualETHTransfer){ // if more than need - cash back
61 					msg.sender.transfer(msg.value - actualETHTransfer);
62 				}
63 				sharesTokenAddress.transfer(msg.sender, tokenToBuy);
64 				tokenSold += tokenToBuy;
65 				tokenFree -= tokenToBuy;
66 				if(tokenFree==0) presaleClosed = true;
67 			} else { // free tokens < tokens to buy 
68 				uint256 sendETH = tokenFree * realPrice / coeff; // price for all free tokens
69 				owner.transfer(sendETH); 
70 				sharesTokenAddress.transfer(msg.sender, tokenFree); 
71 				msg.sender.transfer(msg.value - sendETH); // more than need - cash back
72 				tokenSold += tokenFree;
73 				tokenFree = sharesTokenAddress.balanceOf(this);
74 				presaleClosed = true;
75 			}
76 		}
77 		TokenFree(tokenFree);
78 		PresaleClosed(presaleClosed);
79 	}
80 }