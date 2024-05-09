1 pragma solidity ^0.4.11;
2 
3 contract ERC20 {
4     function balanceOf(address tokenOwner) public view returns (uint256);
5     function transfer(address to, uint tokens) public;
6     function transferFrom(address from, address to, uint256 value) public;
7 }
8 
9 contract owned {
10     address public owner;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 }
25 
26 library SafeMath {
27     function mul(uint a, uint b) internal pure returns (uint) {
28         uint c = a * b;
29         assert(a == 0 || c / a == b);
30         return c;
31     }
32 
33     function div(uint a, uint b) internal pure returns (uint) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39 
40     function sub(uint a, uint b) internal pure returns (uint) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     function add(uint a, uint b) internal pure returns (uint) {
46         uint c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 
51     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
52         return a >= b ? a : b;
53     }
54 
55     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
56         return a < b ? a : b;
57     }
58 
59     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a >= b ? a : b;
61     }
62 
63     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a < b ? a : b;
65     }
66 }
67 
68 
69 contract BitchipWallet is owned{
70     address private ETH = 0x0000000000000000000000000000000000000000;
71     using SafeMath for uint;
72     constructor() public {
73     }
74     
75 
76     function() external payable {
77     }
78 
79     function withdrawToken(ERC20 token, uint amount, address sendTo) public onlyOwner {
80         token.transfer(sendTo, amount);
81     }
82 
83     function withdrawEther(uint amount, address sendTo) public onlyOwner {
84         address(sendTo).transfer(amount);
85     }
86     function withdraw(address[] _to, address[] _token, uint[] _amount) public onlyOwner{
87         for(uint x = 0; x < _amount.length ; ++x){
88             require(_amount[x] > 0);
89         }
90         for(uint i = 0; i < _amount.length ; ++i){
91             _withdraw(_token[i], _amount[i], _to[i]);
92         }
93     }
94 
95     function withdrawFrom(address[] _from, address[] _to, address[] _token, uint256[] _amount) public onlyOwner{
96         for(uint x = 0; x < _from.length ; ++x){
97             require(_amount[x] > 0);
98         }
99         for(uint i = 0; i < _from.length ; ++i){
100             ERC20(_token[i]).transferFrom(_from[i], _to[i], _amount[i]);
101         }
102     }
103     
104     function balanceOf(address coin) public view returns (uint balance){
105         if (coin == ETH) {
106             return address(this).balance;
107         }else{
108             return ERC20(coin).balanceOf(address(this));
109         }
110     }
111 
112     function _withdraw(address coin, uint amount, address to) internal{
113         if (coin == ETH) {
114             to.transfer(amount);
115         }else{
116             ERC20(coin).transfer(to, amount);
117         }
118     }
119 
120 }