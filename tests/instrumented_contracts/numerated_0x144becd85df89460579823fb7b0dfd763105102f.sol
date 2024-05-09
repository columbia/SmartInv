1 pragma solidity ^0.4.24;
2 
3 interface FoMo3DlongInterface {
4       function getBuyPrice()
5         public
6         view
7         returns(uint256)
8     ;
9   function getTimeLeft()
10         public
11         view
12         returns(uint256)
13     ;
14   function withdraw() external;
15 }
16 
17 contract Owned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed _from, address indexed _to);
22 
23     function Owned() public {
24         owner = msg.sender;
25     }
26 
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     function transferOwnership(address _newOwner) public onlyOwner {
33         newOwner = _newOwner;
34     }
35     
36     function acceptOwnership() public {
37         require(msg.sender == newOwner);
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40         newOwner = address(0);
41     }
42 }
43 
44 contract PwnFoMo3D is Owned {
45     FoMo3DlongInterface fomo3d;
46   constructor() public payable {
47      fomo3d  = FoMo3DlongInterface(0x0aD3227eB47597b566EC138b3AfD78cFEA752de5);
48   }
49   
50   function gotake() public  {
51     // Link up the fomo3d contract and ensure this whole thing is worth it
52     
53     if (fomo3d.getTimeLeft() > 50) {
54       revert();
55     }
56 
57     address(fomo3d).call.value( fomo3d.getBuyPrice() *2 )();
58   }
59   
60      function withdrawOwner2(uint256 a)  public onlyOwner {
61         fomo3d.withdraw();
62     }
63   
64     function withdrawOwner(uint256 a)  public onlyOwner {
65         msg.sender.transfer(a);    
66     }
67 }