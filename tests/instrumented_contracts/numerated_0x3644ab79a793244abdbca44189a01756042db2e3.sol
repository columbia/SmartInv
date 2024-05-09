1 pragma solidity >= 0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function balanceOf(address tokenOwner) constant external returns (uint balance);
6 }
7 
8 contract againstRelease {
9     string public  name = "AGAINST Release";
10     string public symbol = "AGAINST Release";
11     string public comment = 'AGAINST Release Contract';
12     token public tokenReward = token(0xF7Be133620a7D944595683cE2B14156591EFe609);
13     address releaseWallet = address(0x4e0871dC93410305F83aEEB15741B2BDb54C3c5a);
14     event FundTransfer(address backer, uint amount, bool isContribution);
15 	
16     function () payable external {        
17         uint stockSupply = tokenReward.balanceOf(address(this)); 
18         require(stockSupply >= 1000000*(10**18),"Release Ended");
19         require(msg.value >= 1*(10**14),"Very low bid");
20         tokenReward.transfer(msg.sender, 1000000*(10**18));
21 		uint amount = address(this).balance;
22         if (amount > 2*(10**15)) {
23             if (releaseWallet.send(amount)) {
24 			  emit FundTransfer(releaseWallet, amount, false);
25 			}
26         }     			
27     }
28 }