1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // Safe maths
4 // ----------------------------------------------------------------------------
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
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
43         newOwner = _newOwner;
44     }
45     function acceptOwnership() public {
46         require(msg.sender == newOwner);
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49         newOwner = address(0);
50     }
51 }
52 
53 contract Crowdfund is Owned {
54      using SafeMath for uint;
55      
56     //mapping
57     mapping(address => uint256) public Holdings;
58     mapping(uint256 => address) public ContributorsList;
59     uint256 listPointer;
60     uint256 totalethfunded;
61     mapping(address => bool) public isInList;
62     bool crowdSaleOpen;
63     bool crowdSaleFail;
64     uint256 CFTsToSend;
65     
66     constructor() public{
67         crowdSaleOpen = true;
68     }
69     
70     modifier onlyWhenOpen() {
71         require(crowdSaleOpen == true);
72         _;
73     }
74     function amountOfCFTtoSend(address Holder)
75         view
76         public
77         returns(uint256)
78     {
79         uint256 amount = CFTsToSend.mul( Holdings[Holder]).div(1 ether).div(totalethfunded);
80         return ( amount)  ;
81     }
82     function setAmountCFTsBought(uint256 amount) onlyOwner public{
83         CFTsToSend = amount;
84     }
85     function() external payable onlyWhenOpen {
86         require(msg.value > 0);
87         Holdings[msg.sender].add(msg.value);
88         if(isInList[msg.sender] == false){
89             ContributorsList[listPointer] = msg.sender;
90             listPointer++;
91             isInList[msg.sender] = true;
92         }
93     }
94     function balanceToOwner() onlyOwner public{
95         require(crowdSaleOpen == false);
96         totalethfunded = address(this).balance;
97         owner.transfer(address(this).balance);
98     }
99     function CloseCrowdfund() onlyOwner public{
100         crowdSaleOpen = false;
101     }
102     function failCrowdfund() onlyOwner public{
103         crowdSaleFail = true;
104     }
105     function retreiveEthuponFail () public {
106         require(crowdSaleFail == true);
107         require(Holdings[msg.sender] > 0);
108         uint256 getEthback = Holdings[msg.sender];
109         Holdings[msg.sender] = 0;
110         msg.sender.transfer(getEthback);
111     }
112 }