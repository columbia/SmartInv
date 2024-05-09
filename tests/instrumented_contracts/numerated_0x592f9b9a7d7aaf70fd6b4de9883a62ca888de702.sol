1 pragma solidity ^0.4.24;
2 
3 contract WishingWell {
4 
5     event wishMade(address indexed wisher, string wish, uint256 amount);
6     
7     address owner;
8     
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(
15             msg.sender == owner,
16             "Only owner can call this function."
17         );
18         _;
19     }
20 
21     function changeOwner(address new_owner) public onlyOwner {
22         owner = new_owner;
23     }
24     
25     function makeWish(string wish) public payable {
26         emit wishMade(msg.sender, wish, msg.value);
27     }
28     
29     function withdrawAll() public onlyOwner {
30         address(owner).transfer(address(this).balance);
31     }
32     
33 }