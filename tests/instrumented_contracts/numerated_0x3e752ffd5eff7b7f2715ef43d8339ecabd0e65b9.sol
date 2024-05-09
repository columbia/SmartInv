1 pragma solidity ^0.4.25;
2 
3 interface Snip3DInterface  {
4     function() payable external;
5    function offerAsSacrifice(address MN)
6         external
7         payable
8         ;
9          function withdraw()
10         external
11         ;
12         function myEarnings()
13         external
14         view
15        
16         returns(uint256);
17         function tryFinalizeStage()
18         external;
19     function sendInSoldier(address masternode) external payable;
20     function fetchdivs(address toupdate) external;
21     function shootSemiRandom() external;
22 }
23 
24 // ----------------------------------------------------------------------------
25 // Owned contract
26 // ----------------------------------------------------------------------------
27 contract Owned {
28     address public owner;
29     address public newOwner;
30 
31     event OwnershipTransferred(address indexed _from, address indexed _to);
32 
33     constructor() public {
34         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address _newOwner) public onlyOwner {
43         owner = _newOwner;
44     }
45     
46 }
47 // ----------------------------------------------------------------------------
48 // Safe maths
49 // ----------------------------------------------------------------------------
50 library SafeMath {
51     function add(uint a, uint b) internal pure returns (uint c) {
52         c = a + b;
53         require(c >= a);
54     }
55     function sub(uint a, uint b) internal pure returns (uint c) {
56         require(b <= a);
57         c = a - b;
58     }
59     function mul(uint a, uint b) internal pure returns (uint c) {
60         c = a * b;
61         require(a == 0 || c / a == b);
62     }
63     function div(uint a, uint b) internal pure returns (uint c) {
64         require(b > 0);
65         c = a / b;
66     }
67 }
68 // Snip3dbridge contract
69 contract Slaughter3D is  Owned {
70     using SafeMath for uint;
71     Snip3DInterface constant Snip3Dcontract_ = Snip3DInterface(0xb172BB8BAae74F27Ade3211E0c145388d3b4f8d8);// change to real address
72     uint256 public toSlaughter;
73     function harvestableBalance()
74         view
75         public
76         returns(uint256)
77     {
78         uint256 toReturn = address(this).balance.sub(toSlaughter);
79         return ( toReturn)  ;
80     }
81     function unfetchedVault()
82         view
83         public
84         returns(uint256)
85     {
86         return ( Snip3Dcontract_.myEarnings())  ;
87     }
88     function sacUp ()  public payable {
89        
90         toSlaughter = toSlaughter.add(msg.value);
91     }
92     function sacUpto (address masternode)  public {
93         require(toSlaughter> 0.1 ether);
94         toSlaughter = toSlaughter.sub(0.1 ether);
95         Snip3Dcontract_.offerAsSacrifice.value(0.1 ether)(masternode);
96     }
97     function validate ()  public {
98        
99         Snip3Dcontract_.tryFinalizeStage();
100     }
101     function fetchvault () public {
102       
103         Snip3Dcontract_.withdraw();
104     }
105     function fetchBalance () onlyOwner public {
106       uint256 tosend = address(this).balance.sub(toSlaughter);
107         msg.sender.transfer(tosend);
108     }
109     function () external payable{} // needs for divs
110 }