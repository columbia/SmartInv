1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4   address public owner;
5   
6   constructor() public {
7       owner = msg.sender;
8   }
9 
10   event OwnerUpdate(address _prevOwner, address _newOwner);
11 
12   modifier onlyOwner {
13     assert(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address _newOwner) public onlyOwner {
18     require(_newOwner != owner, "Cannot transfer to yourself");
19     owner = _newOwner;
20   }
21 }
22 
23 interface BurnableERC20 {
24     function burn(uint256 amount) external;
25     function balanceOf(address target) external returns (uint256);
26 }
27 
28 interface Marketplace {
29     function transferOwnership(address) external;
30     function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) external;
31     function pause() external;
32     function unpause() external;
33 }
34 
35 contract MANABurner is Ownable {
36 
37     Marketplace public marketplace;
38     BurnableERC20 public mana;
39 
40     constructor(address manaAddress, address marketAddress) public {
41         mana = BurnableERC20(manaAddress);
42         marketplace = Marketplace(marketAddress);
43     }
44 
45     function burn() public {
46         mana.burn(mana.balanceOf(this));
47     }
48 
49     function transferMarketplaceOwnership(address target) public onlyOwner {
50         marketplace.transferOwnership(target);
51     }
52 
53     function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) public onlyOwner {
54         marketplace.setOwnerCutPerMillion(_ownerCutPerMillion);
55     }
56 
57     function pause() public onlyOwner {
58         marketplace.pause();
59     }
60 
61     function unpause() public onlyOwner {
62         marketplace.unpause();
63     }
64 }