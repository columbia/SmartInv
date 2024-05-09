1 pragma solidity ^0.4.18;
2 contract ERC721 {
3     function totalSupply() public view returns (uint256 total);
4     function balanceOf(address _owner) public view returns (uint256 balance);
5     function ownerOf(uint256 _tokenId) external view returns (address owner);
6     function approve(address _to, uint256 _tokenId) external;
7     function transfer(address _to, uint256 _tokenId) external;
8     function transferFrom(address _from, address _to, uint256 _tokenId) external;
9     event Transfer(address from, address to, uint256 tokenId);
10     event Approval(address owner, address approved, uint256 tokenId);
11     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
12 }
13 contract Owned {
14     address public owner;
15 
16     function Owned () public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         if (msg.sender != owner) {
22             revert();
23         }
24         _;
25     }
26     function changeOwner (address newOwner) public onlyOwner {
27         owner = newOwner;
28     }
29 }
30 contract Targeted is Owned {
31     ERC721 public target;
32     function changeTarget (address newTarget) public onlyOwner {
33         target = ERC721(newTarget);
34     }
35 }
36 contract CatHODL is Targeted {
37     uint public releaseDate;
38     mapping (uint => address) public catOwners;
39     function CatHODL () public {
40         releaseDate = now + 1 years;
41     }
42     function bringCat (uint catId) public {
43         require(now < releaseDate ); // If you can get it anytime, its not forced HODL!
44         catOwners[catId] = msg.sender; // Set the user as owner.
45         target.transferFrom(msg.sender, this, catId); // Get the cat, throws if fails
46     }
47     function getCat (uint catId) public {
48         require(catOwners[catId] == msg.sender);
49         require(now >= releaseDate);
50         catOwners[catId] = 0x0;
51         target.transfer(msg.sender, catId);
52     }
53     function doSuicide () public onlyOwner {
54         selfdestruct(owner);
55     }
56 }