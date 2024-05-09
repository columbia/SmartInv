1 pragma solidity 0.6.12;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Ownable {
55     address public _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () public {
60         _owner = msg.sender;
61         emit OwnershipTransferred(address(0), msg.sender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 abstract contract LamdenTau  {
86     function transferFrom(address _from, address _to, uint256 _value) external virtual returns (bool);
87     function transfer(address recipient, uint256 amount) external virtual returns (bool);
88     function balanceOf(address account) external virtual view returns (uint256);
89 
90 }
91 
92 contract TAUSwap is Ownable {
93     using SafeMath for uint256;
94 
95     LamdenTau tau = LamdenTau(0xc27A2F05fa577a83BA0fDb4c38443c0718356501);
96     mapping(address => uint256) swappedBalances;
97 
98     event Swap(address sender, string receiver, uint256 value);
99 
100     function swap(string memory mainnetAddress, uint256 amount) public {
101         tau.transferFrom(msg.sender, address(this), amount);
102 
103         swappedBalances[msg.sender] = swappedBalances[msg.sender].add(amount);
104 
105         emit Swap(msg.sender, mainnetAddress, amount);
106     }
107 
108     function sweep(address owner, uint256 amount) public onlyOwner {
109         if (amount == 0) {
110             amount = swappedBalances[owner];
111         }
112 
113         swappedBalances[owner] = swappedBalances[owner].sub(amount);
114         tau.transfer(address(0x0), amount);
115     }
116 
117     function tauRevert(address owner, uint256 amount) public onlyOwner {
118         swappedBalances[owner] = swappedBalances[owner].sub(amount);
119         tau.transfer(owner, amount);
120     }
121 }