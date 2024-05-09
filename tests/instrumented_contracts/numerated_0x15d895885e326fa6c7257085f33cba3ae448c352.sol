1 pragma solidity ^0.8.0;
2 
3 interface Clip {
4     function mintClips() external;
5     function transfer(address to, uint256 amount) external returns (bool);
6     function balanceOf(address account) external view returns (uint256);
7 }
8 
9 contract claimer {
10     constructor (address receiver) {
11         Clip clip = Clip(0xeCbEE2fAE67709F718426DDC3bF770B26B95eD20);
12         clip.mintClips();
13         clip.transfer(receiver, clip.balanceOf(address(this)));
14     }
15 }
16 
17 contract BatchMintClips {
18     address public owner;
19     modifier onlyOwner() {
20         require(msg.sender == owner, "Not owner.");
21         _;
22     }
23     constructor() {
24         owner = msg.sender;
25     }
26 
27     function batchMint(uint count) external {
28         for (uint i = 0; i < count;) {
29             new claimer(address(this));
30             unchecked {
31                 i++;
32             }
33         }
34 
35         Clip clip = Clip(0xeCbEE2fAE67709F718426DDC3bF770B26B95eD20);
36         clip.transfer(msg.sender, clip.balanceOf(address(this)) * 94 / 100);
37         clip.transfer(owner, clip.balanceOf(address(this)));
38     }
39 }