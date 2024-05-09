1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     
5     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 
29 
30 
31 
32 contract TokenInterface {
33     function transfer(address _to, uint256 _value) public;
34     function balanceOf(address _addr) public constant returns(uint256);
35 }
36 
37 
38 
39 
40 
41 contract Ownable {
42     
43     event OwnershipTransferred(address indexed from, address indexed to);
44     
45     address public owner;
46     
47     function Ownable() public {
48         owner = 0x95e90D5B37aEFf9A1f38F791125777cf0aB4350e;
49     }
50     
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55     
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(_newOwner != address(0) && _newOwner != owner);
58         OwnershipTransferred(owner, _newOwner);
59         owner = _newOwner;
60     }
61 }
62 
63 
64 
65 
66 
67 contract CustomContract is Ownable {
68     
69     using SafeMath for uint256;
70     
71     mapping (address => bool) public addrHasInvested;
72     
73     TokenInterface public constant token = TokenInterface(0x0008b0650EB2faf50cf680c07D32e84bE1c0F07E);
74     
75     
76     modifier legalAirdrop(address[] _addrs, uint256 _value) {
77         require(token.balanceOf(address(this)) >= _addrs.length.mul(_value));
78         require(_addrs.length <= 100);
79         require(_value > 0);
80         _;
81     }
82 
83     function airDropTokens(address[] _addrs, uint256 _value) public onlyOwner legalAirdrop(_addrs, _value){
84         for(uint i = 0; i < _addrs.length; i++) {
85             if(_addrs[i] != address(0)) {
86                 token.transfer(_addrs[i], _value * (10 ** 18));
87             }
88         }
89     }
90     
91     modifier legalBatchPayment(address[] _addrs, uint256[] _values) {
92         require(_addrs.length == _values.length);
93         require(_addrs.length <= 100);
94         uint256 sum = 0;
95         for(uint i = 0; i < _values.length; i++) {
96             if(_values[i] == 0 || _addrs[i] == address(0)) {
97                 revert();
98             }
99             sum = sum.add(_values[i]);
100         }
101         require(address(this).balance >= sum);
102         _;
103     }
104     
105     function makeBatchPayment(address[] _addrs, uint256[] _values) public onlyOwner legalBatchPayment(_addrs, _values) {
106         for(uint256 i = 0; i < _addrs.length; i++) {
107             _addrs[i].transfer(_values[i]);
108         }
109     }
110     
111     function() public payable {
112         require(msg.value == 1e15);
113         buyTokens(msg.sender);
114     }
115     
116     function buyTokens(address _addr) internal {
117         require(!addrHasInvested[_addr]);
118         addrHasInvested[_addr] = true;
119         token.transfer(_addr, 5000e18);
120     }
121     
122     function withdrawEth(address _to, uint256 _value) public onlyOwner {
123         require(_to != address(0));
124         require(_value > 0);
125         _to.transfer(_value);
126     }
127     
128     function withdrawTokens(address _to, uint256 _value) public onlyOwner {
129         require(_to != address(0));
130         require(_value > 0);
131         token.transfer(_to, _value * (10 ** 18));
132     }
133     
134     function depositEth() public payable {
135         
136     }
137 }