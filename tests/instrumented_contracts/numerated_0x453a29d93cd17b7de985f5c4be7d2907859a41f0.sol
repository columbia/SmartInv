1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20Interface {
48     // Send _value amount of tokens to address _to
49     function transfer(address _to, uint256 _value) returns (bool success);
50     // Get the account balance of another account with address _owner
51     function balanceOf(address _owner) constant returns (uint256 balance);
52 }
53 
54 contract SpnLockupAngel is Ownable {
55     using SafeMath for uint256;
56     ERC20Interface token;
57 
58     address public constant tokenAddress = 0x67bc56cAad630DC1719B14A540Adc8e9968325C3;
59     address public wallet = 0x92ae794F4FBA0db8Eab160a4369A3e2Dea262680;
60     uint256 public lockupDate = 1550106000;
61     uint256 public initLockupAmt = 40000000e18;
62 
63     function SpnLockupAngel () public {
64         token = ERC20Interface(tokenAddress);
65     }
66 
67     function setLockupAmt(uint256 _amt) public onlyOwner {
68         initLockupAmt = _amt;
69     }
70 
71     function setLockupDate(uint _date) public onlyOwner {
72         lockupDate = _date;
73     }
74 
75     function setWallet(address _dest) public onlyOwner {
76         wallet = _dest;
77     }
78 
79     function withdraw() public onlyOwner {
80         uint256 currBalance = token.balanceOf(this);
81         uint256 currLocking = getCurrLocking();
82 
83         require(currBalance > currLocking);
84 
85         token.transfer(wallet, currBalance-currLocking);
86     }
87 
88     function getCurrLocking()
89         public
90 		view
91         returns (uint256)
92 	{
93         uint256 diff = (now - lockupDate) / 2592000; // month diff
94         uint256 partition = 24;
95 
96         if (diff >= partition) 
97             return 0;
98         else
99             return initLockupAmt.mul(partition-diff).div(partition);
100     }
101 }