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
71     Snip3DInterface constant Snip3Dcontract_ = Snip3DInterface(0xA76daa02C1A6411c6c368f3A59f4f2257a460006);
72     function harvestableBalance()
73         view
74         public
75         returns(uint256)
76     {
77         return ( address(this).balance)  ;
78     }
79     function unfetchedVault()
80         view
81         public
82         returns(uint256)
83     {
84         return ( Snip3Dcontract_.myEarnings())  ;
85     }
86     function sacUp () onlyOwner public payable {
87        
88         Snip3Dcontract_.offerAsSacrifice.value(0.1 ether)(msg.sender);
89     }
90     function validate () onlyOwner public {
91        
92         Snip3Dcontract_.tryFinalizeStage();
93     }
94     function fetchvault () onlyOwner public {
95       
96         Snip3Dcontract_.withdraw();
97     }
98     function fetchBalance () onlyOwner public {
99       
100         msg.sender.transfer(address(this).balance);
101     }
102 }