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
19     function sendInSoldier(address masternode, uint256 amount) external payable;
20     function fetchdivs(address toupdate) external;
21     function shootSemiRandom() external;
22     function vaultToWallet(address toPay) external;
23 }
24 
25 // ----------------------------------------------------------------------------
26 // Owned contract
27 // ----------------------------------------------------------------------------
28 contract Owned {
29     address public owner;
30     address public newOwner;
31 
32     event OwnershipTransferred(address indexed _from, address indexed _to);
33 
34     constructor() public {
35         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address _newOwner) public onlyOwner {
44         owner = _newOwner;
45     }
46     
47 }
48 // ----------------------------------------------------------------------------
49 // Safe maths
50 // ----------------------------------------------------------------------------
51 library SafeMath {
52     function add(uint a, uint b) internal pure returns (uint c) {
53         c = a + b;
54         require(c >= a);
55     }
56     function sub(uint a, uint b) internal pure returns (uint c) {
57         require(b <= a);
58         c = a - b;
59     }
60     function mul(uint a, uint b) internal pure returns (uint c) {
61         c = a * b;
62         require(a == 0 || c / a == b);
63     }
64     function div(uint a, uint b) internal pure returns (uint c) {
65         require(b > 0);
66         c = a / b;
67     }
68 }
69 // Snip3dbridge contract
70 contract Snip3dbridgecontract is  Owned {
71     using SafeMath for uint;
72     Snip3DInterface constant Snip3Dcontract_ = Snip3DInterface(0x31cF8B6E8bB6cB16F23889F902be86775bB1d0B3);//0x31cF8B6E8bB6cB16F23889F902be86775bB1d0B3);
73     uint256 public toSnipe;
74     function harvestableBalance()
75         view
76         public
77         returns(uint256)
78     {
79         uint256 tosend = address(this).balance.sub(toSnipe);
80         return ( tosend)  ;
81     }
82     function unfetchedVault()
83         view
84         public
85         returns(uint256)
86     {
87         return ( Snip3Dcontract_.myEarnings())  ;
88     }
89     function sacUp ()  public payable {
90        
91         toSnipe = toSnipe.add(msg.value);
92     }
93     function sacUpto (address masternode, uint256 amount)  public  {
94        require(toSnipe>amount.mul(0.1 ether));
95         toSnipe = toSnipe.sub(amount.mul(0.1 ether));
96         Snip3Dcontract_.sendInSoldier.value(amount.mul(0.1 ether))(masternode , 1);
97     }
98     function fetchvault ()  public {
99       
100         Snip3Dcontract_.vaultToWallet(address(this));
101     }
102     function shoot ()  public {
103       
104         Snip3Dcontract_.shootSemiRandom();
105     }
106     function fetchBalance () onlyOwner public {
107       uint256 tosend = address(this).balance.sub(toSnipe);
108         msg.sender.transfer(tosend);
109     }
110     function () external payable{} // needs for divs
111 }