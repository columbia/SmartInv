1 pragma solidity >= 0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function balanceOf(address tokenOwner) constant external returns (uint balance);
6 }
7 
8 contract againstFaucet {
9     mapping(address => uint) public lastdate;
10 	
11     string public  name = "AGAINST Faucet";
12     string public symbol = "AGAINST";
13     string public comment = "AGAINST Faucet Contract 2";
14     token public tokenReward = token(0xF7Be133620a7D944595683cE2B14156591EFe609);
15     address releaseWallet = address(0x4e0871dC93410305F83aEEB15741B2BDb54C3c5a);
16 	
17     function () payable external {        
18         uint stockSupply = tokenReward.balanceOf(address(this));
19         require(stockSupply >= 1000000*(10**18),"Faucet Ended");
20 	    require(now-lastdate[address(msg.sender)] >= 1 days,"Faucet enable once a day");
21 	    lastdate[address(msg.sender)] = now;		
22         tokenReward.transfer(msg.sender, 1000000*(10**18));
23         if (address(this).balance > 2*(10**15)) {
24           if (releaseWallet.send(address(this).balance)) {
25           }   
26         }     			
27     }
28 }