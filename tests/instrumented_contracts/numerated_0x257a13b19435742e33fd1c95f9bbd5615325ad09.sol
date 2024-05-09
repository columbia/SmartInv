1 // File: contracts/redemption.sol
2 
3 
4 //          .@@@                                                                  
5 //               ,@@@@@@@&,                  #@@%                                  
6 //                    @@@@@@@@@@@@@@.          @@@@@@@@@                           
7 //                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      
8 //                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                   
9 //                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                 
10 //                                    @@@@@@@    &@@@@@@@@@@@@@@@@@                
11 //                                        @@@/        &@@@@@@@@@@@@@,              
12 //                                            @            @@@@@@@@@@@             
13 //                                                             /@@@@@@@#           
14 //                                                                  @@@@@          
15 //                                                                      *@&   
16 //         RTFKT Studios (https://twitter.com/RTFKT)
17 //         Redemption Contract (made by @CardilloSamuel)
18 
19 pragma solidity ^0.8.7;
20 
21 abstract contract redeemableCollection {
22     function redeemBatch(address owner, address initialCollection, uint256[] calldata cloneXIds, uint256[] calldata wearableIds, uint256[] calldata amount) public virtual;
23 }
24 
25 contract RTFKTRedemption {
26     mapping (address => bool) authorizedOwners;
27     mapping (address => bool) authorizedContract;
28     mapping (uint256 => uint256) public redeemPrice;
29 
30     constructor() {
31         authorizedOwners[msg.sender] = true;
32     }
33 
34     /** 
35         MODIFIER 
36     **/
37 
38     modifier isAuthorizedOwner() {
39         require(authorizedOwners[msg.sender], "You are not authorized to perform this action");
40         _;
41     }
42 
43     /**
44         MAIN FUNCTION
45     **/
46 
47     function redeemBatch(address newCollection, address initialCollection, uint256[] calldata cloneXIds, uint256[] calldata wearableIds, uint256[] calldata amount) public payable {
48         require(tx.origin == msg.sender, "No contracts allowed");
49         require(cloneXIds.length == wearableIds.length, "Mismatch of length");
50         require(cloneXIds.length == amount.length, "Mismatch of length");
51         require(authorizedContract[newCollection], "This contract is not authorized");
52 
53         uint256 amountToReceive = 0;
54         for(uint256 i = 0; i < wearableIds.length; ++i) {
55             amountToReceive = amountToReceive + (redeemPrice[wearableIds[i]] * amount[i]);
56         }
57         require(msg.value == amountToReceive, "Not enough money sent");
58         redeemableCollection externalContract = redeemableCollection(newCollection);
59         
60         externalContract.redeemBatch(msg.sender, initialCollection, cloneXIds, wearableIds, amount);
61     }
62 
63     /** 
64         CONTRACT MANAGEMENT FUNCTIONS 
65     **/ 
66 
67     function changeRedeemPrice(uint256 tokenId, uint256 newPrice) public isAuthorizedOwner {
68         redeemPrice[tokenId] = newPrice;
69     }
70 
71     function toggleAuthorizedContract(address redeemableContract) public isAuthorizedOwner {
72         authorizedContract[redeemableContract] = !authorizedContract[redeemableContract];
73     }
74 
75     function toggleAuthorizedOwner(address newAddress) public isAuthorizedOwner {
76         require(msg.sender != newAddress, "You can't revoke your own access");
77 
78         authorizedOwners[newAddress] = !authorizedOwners[newAddress];
79     }
80 
81     function withdrawFunds(address withdrawalAddress) public isAuthorizedOwner {
82         payable(withdrawalAddress).transfer(address(this).balance);
83     }
84 
85 }