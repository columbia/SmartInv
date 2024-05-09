1 pragma solidity ^0.4.24;
2 
3 contract IBancorConverter {
4     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);
5 }
6 
7 contract IExchange {
8     function ethToTokens(uint _ethAmount) public view returns(uint);
9     function tokenToEth(uint _amountOfTokens) public view returns(uint);
10     function tokenToEthRate() public view returns(uint);
11     function ethToTokenRate() public view returns(uint);
12 }
13 
14 contract Owned {
15     address public owner;
16     address public newOwner;
17 
18     event OwnershipTransferred(address indexed _from, address indexed _to);
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     function transferOwnership(address _newOwner) public onlyOwner {
30         newOwner = _newOwner;
31     }
32     function acceptOwnership() public {
33         require(msg.sender == newOwner);
34         emit OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36         newOwner = address(0);
37     }
38 }
39 
40 contract Exchange is Owned, IExchange {
41     using SafeMath for uint;
42 
43     IBancorConverter public bntConverter;
44     IBancorConverter public tokenConverter;
45 
46     address public ethToken;
47     address public bntToken;
48     address public token;
49 
50     event Initialized(address _bntConverter, address _tokenConverter, address _ethToken, address _bntToken, address _token);
51 
52     constructor() public { 
53     }
54 
55     function initialize(address _bntConverter, address _tokenConverter, address _ethToken, address _bntToken, address _token) external onlyOwner {
56        bntConverter = IBancorConverter(_bntConverter);
57        tokenConverter = IBancorConverter(_tokenConverter);
58 
59        ethToken = _ethToken;
60        bntToken = _bntToken;
61        token = _token;
62 
63        emit Initialized(_bntConverter, _tokenConverter, _ethToken, _bntToken, _token);
64     }
65 
66     function ethToTokens(uint _ethAmount) public view returns(uint) {
67         uint bnt = bntConverter.getReturn(ethToken, bntToken, _ethAmount);
68         uint amountOfTokens = tokenConverter.getReturn(bntToken, token, bnt);
69         return amountOfTokens;
70     }
71 
72     function tokenToEth(uint _amountOfTokens) public view returns(uint) {
73         uint bnt = tokenConverter.getReturn(token, bntToken, _amountOfTokens);
74         uint eth = bntConverter.getReturn(bntToken, ethToken, bnt);
75         return eth;
76     }
77 
78     function tokenToEthRate() public view returns(uint) {
79         uint eth = tokenToEth(1 ether);
80         return eth;
81     }
82 
83     function ethToTokenRate() public view returns(uint) {
84         uint tkn = ethToTokens(1 ether);
85         return tkn;
86     }
87 }
88 
89 library SafeMath {
90     function add(uint a, uint b) internal pure returns (uint c) {
91         c = a + b;
92         require(c >= a);
93     }
94     function sub(uint a, uint b) internal pure returns (uint c) {
95         require(b <= a);
96         c = a - b;
97     }
98     function mul(uint a, uint b) internal pure returns (uint c) {
99         c = a * b;
100         require(a == 0 || c / a == b);
101     }
102     function div(uint a, uint b) internal pure returns (uint c) {
103         require(b > 0);
104         c = a / b;
105     }
106 }