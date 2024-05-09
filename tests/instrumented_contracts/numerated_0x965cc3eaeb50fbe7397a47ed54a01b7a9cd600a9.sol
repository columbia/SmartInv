1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface collectible {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Swap {
8     collectible public swapaddress;
9     mapping(address => uint256) public balanceOf;
10     mapping(address => bool) public check;
11     uint256 cancel = 0;
12     uint256 count = 0;
13     event FundTransfer(address backer, uint amount, bool isContribution);
14 
15     /**
16      * Constructor
17      *
18      * Setup the owner
19      */
20     constructor(
21         address addressOfCollectibleUsedAsReward
22     ) public {
23         swapaddress = collectible(addressOfCollectibleUsedAsReward);
24     }
25 
26     
27     function () payable external {
28         require(check[msg.sender] == false);
29         if (count <= 10000000) {
30         count += 1;
31         msg.sender.send(msg.value);
32         balanceOf[msg.sender] += 50000000;
33         swapaddress.transfer(msg.sender, 50000000);
34         check[msg.sender] = true;
35         } else {
36         require(cancel == 1);
37         selfdestruct(swapaddress);
38         }
39     }
40 
41 }