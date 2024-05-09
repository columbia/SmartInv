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
54 contract MonLockupFund is Ownable {
55     using SafeMath for uint256;
56     ERC20Interface token;
57 
58     address public constant tokenAddress = 0x6242a2762F5a4DB46ef8132398CB6391519aBe21;
59     address public wallet_A = 0xC7bac67FbE48a8e1A0d37e6d6F0d3e34582be40f;
60     address public wallet_B = 0x2061cAC4460A3DE836728487e4A092b811b2fdA7;
61     address public wallet_C = 0x60aF1A04244868abc812a8C854a62598E7f43Fcd;
62     uint256 public lockupDate = 1557360000;
63     uint256 public initLockupAmt = 150000000e18;
64 
65     function MonLockupFund () public {
66         token = ERC20Interface(tokenAddress);
67     }
68 
69     function setLockupAmt(uint256 _amt) public onlyOwner {
70         initLockupAmt = _amt;
71     }
72 
73     function setLockupDate(uint _date) public onlyOwner {
74         lockupDate = _date;
75     }
76 
77     function setWallet(address[] _dest) public onlyOwner {
78         wallet_A = _dest[0];
79         wallet_B = _dest[1];
80         wallet_C = _dest[2];
81     }
82 
83     function withdraw() public {
84         uint256 currBalance = token.balanceOf(this);
85         uint256 currLocking = getCurrLocking();
86 
87         require(currBalance > currLocking);
88         uint256 available = currBalance.sub(currLocking);
89 
90         token.transfer(wallet_A, available.mul(60).div(100));
91         token.transfer(wallet_B, available.mul(30).div(100));
92         token.transfer(wallet_C, available.mul(10).div(100));
93     }
94 
95     function getCurrLocking()
96         public
97 		view
98         returns (uint256)
99 	{
100         uint256 diff = (now - lockupDate) / 2592000; // month diff
101         uint256 partition = 30;
102 
103         if (diff >= partition) 
104             return 0;
105         else
106             return initLockupAmt.mul(partition-diff).div(partition);
107     }
108 
109     function close() public onlyOwner {
110         selfdestruct(owner);
111     }
112 }