1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         require(b > 0);
17         uint256 c = a / b;
18 
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a);
24         uint256 c = a - b;
25 
26         return c;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a);
32 
33         return c;
34     }
35 }
36 
37 contract Mono {
38     using SafeMath for uint256;
39 
40     mapping (address => uint256) private balances;
41     mapping (address => mapping (address => uint256)) private allowed;
42     uint256 private _totalSupply = 8235000;
43 
44     string public constant name = "Mono";
45     string public constant symbol = "MMONO";
46     uint8 public constant decimals = 6;
47 
48     function totalSupply() public view returns (uint256) {
49         return _totalSupply;
50     }
51 
52     function balanceOf(address owner) public view returns (uint256) {
53         return balances[owner];
54     }
55 
56     function allowance(address owner, address spender) public view returns (uint256) {
57         return allowed[owner][spender];
58     }
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     function _transfer(address from, address to, uint256 value) internal {
62         require(to != address(0));
63 
64         balances[from] = balances[from].sub(value);
65         balances[to] = balances[to].add(value);
66         emit Transfer(from, to, value);
67     }
68 
69     function transfer(address to, uint256 value) public returns (bool) {
70         _transfer(msg.sender, to, value);
71         return true;
72     }
73 
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75     function approve(address spender, uint256 value) public returns (bool) {
76         require(spender != address(0));
77 
78         allowed[msg.sender][spender] = value;
79         emit Approval(msg.sender, spender, value);
80         return true;
81     }
82 
83     function transferFrom(address from, address to, uint256 value) public returns (bool) {
84         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
85         _transfer(from, to, value);
86         emit Approval(from, msg.sender, allowed[from][msg.sender]);
87         return true;
88     }
89 
90     constructor() public {
91         balances[0x4b09b4aeA5f9C616ebB6Ee0097B62998Cb332275] = 8235000000000;
92         emit Transfer(address(0x0), 0x4b09b4aeA5f9C616ebB6Ee0097B62998Cb332275, 8235000000000);
93     }
94 }