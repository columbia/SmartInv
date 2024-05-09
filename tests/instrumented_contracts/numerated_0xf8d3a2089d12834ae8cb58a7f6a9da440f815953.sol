1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.16;
3 
4 //they lucky eslamaio aint in this omm or we takin all stock
5 contract FlipBattle {
6     mapping(address => bool) blacklistedAddresses;
7     address owner;
8 
9     uint256 public maxSupply = 0;
10     uint public totalMinted = 0;
11     uint public mintedAstra = 0;
12     uint public mintedThunder = 0;
13     uint public mintedGrabber = 0;
14     uint public mintedCustom = 0;
15     uint public mintedSensei = 0;
16     uint public mintedMS = 0;
17     uint public mintedMintech = 0;
18 
19 
20     constructor () payable {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner() {
25         require(msg.sender == owner, "it seems you are not eslam");
26         _;
27     }
28 
29     modifier isBlacklisted(address _address) {
30         require(!blacklistedAddresses[_address], "not allowed to test");
31         _;
32     }
33 
34     function mintAstra() external isBlacklisted(msg.sender){
35         require(totalMinted++ < maxSupply, "youre too slow");
36         mintedAstra++;
37     }
38 
39     function mintCustom() external isBlacklisted(msg.sender){
40         require(totalMinted++ < maxSupply, "youre too slow");
41         mintedCustom++;
42     }
43 
44     function mintSensei() external isBlacklisted(msg.sender){
45         require(totalMinted++ < maxSupply, "youre too slow");
46         mintedSensei++;
47     }
48 
49     function startRound() public onlyOwner{
50         maxSupply = maxSupply+10;
51     }
52 
53 
54     function mintThunder() external isBlacklisted(msg.sender){
55         require(totalMinted++ < maxSupply, "youre too slow");
56         mintedThunder++;
57     }
58 
59     function mintGrabber() external isBlacklisted(msg.sender){
60         require(totalMinted++ < maxSupply, "youre too slow");
61         mintedGrabber++;
62     }
63 
64     function mintMS() external isBlacklisted(msg.sender){
65         require(totalMinted++ < maxSupply, "youre too slow");
66         mintedMS++;
67     }
68     
69     function mintMintech() external isBlacklisted(msg.sender){
70         require(totalMinted++ < maxSupply, "youre too slow");
71         mintedMintech++;
72     }
73     
74     function addBadPeople(address[] memory wallets) public onlyOwner {
75         for (uint i = 0; i < wallets.length; i++) { 
76         blacklistedAddresses[wallets[i]] = true;
77     }
78     }
79 
80     function isBadPerson(address wallet) public view returns(bool) {
81         bool userisBlacklisted = blacklistedAddresses[wallet];
82         return userisBlacklisted;
83     }
84 }