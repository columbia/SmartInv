1 pragma solidity ^0.4.25;
2 
3 interface Snip3DInterface  {
4     function() payable external;
5    
6     function sendInSoldier(address masternode) external payable;
7     function fetchdivs(address toupdate) external;
8     function shootSemiRandom() external;
9 }
10 
11 // ----------------------------------------------------------------------------
12 // Owned contract
13 // ----------------------------------------------------------------------------
14 contract Owned {
15     address public owner;
16     address public newOwner;
17 
18     event OwnershipTransferred(address indexed _from, address indexed _to);
19 
20     constructor() public {
21         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     function transferOwnership(address _newOwner) public onlyOwner {
30         owner = _newOwner;
31     }
32     
33 }
34 // ----------------------------------------------------------------------------
35 // Safe maths
36 // ----------------------------------------------------------------------------
37 library SafeMath {
38     function add(uint a, uint b) internal pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     function sub(uint a, uint b) internal pure returns (uint c) {
43         require(b <= a);
44         c = a - b;
45     }
46     function mul(uint a, uint b) internal pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50     function div(uint a, uint b) internal pure returns (uint c) {
51         require(b > 0);
52         c = a / b;
53     }
54 }
55 // Snip3dbridge contract
56 contract Snip3D is  Owned {
57     using SafeMath for uint;
58     Snip3DInterface constant Snip3Dcontract_ = Snip3DInterface(0x6D534b48835701312ebc904d4b37e54D4f7D039f);
59     
60     function soldierUp () onlyOwner public payable {
61        
62         Snip3Dcontract_.sendInSoldier.value(0.1 ether)(msg.sender);
63     }
64     function shoot () onlyOwner public {
65        
66         Snip3Dcontract_.shootSemiRandom();
67     }
68     function fetchdivs () onlyOwner public {
69       
70         Snip3Dcontract_.fetchdivs(address(this));
71     }
72     function fetchBalance () onlyOwner public {
73       
74         msg.sender.transfer(address(this).balance);
75     }
76 }