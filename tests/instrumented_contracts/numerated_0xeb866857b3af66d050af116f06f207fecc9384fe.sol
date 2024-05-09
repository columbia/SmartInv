1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 
22     
23 contract MultiSig is IERC20 {
24     address private addrA;
25     address private addrB;
26     address private addrToken;
27 
28     struct Permit {
29         bool addrAYes;
30         bool addrBYes;
31     }
32     
33     mapping (address => mapping (uint => Permit)) private permits;
34     
35      event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38     
39     uint public totalSupply = 10*10**26;
40     uint8 constant public decimals = 18;
41     string constant public name = "MutiSigPTN";
42     string constant public symbol = "MPTN";
43 
44  function approve(address spender, uint256 value) external returns (bool){
45      return false;
46  }
47 
48     function transferFrom(address from, address to, uint256 value) external returns (bool){
49         return false;
50     }
51 
52     function totalSupply() external view returns (uint256){
53           IERC20 token = IERC20(addrToken);
54           return token.totalSupply();
55     }
56 
57 
58     function allowance(address owner, address spender) external view returns (uint256){
59         return 0;
60     }
61     
62     constructor(address a, address b, address tokenAddress) public{
63         addrA = a;
64         addrB = b;
65         addrToken = tokenAddress;
66     }
67     function getAddrs() public view returns(address, address,address) {
68       return (addrA, addrB,addrToken);
69     }
70     function  transfer(address to,  uint amount)  public returns (bool){
71         IERC20 token = IERC20(addrToken);
72         require(token.balanceOf(this) >= amount);
73 
74         if (msg.sender == addrA) {
75             permits[to][amount].addrAYes = true;
76         } else if (msg.sender == addrB) {
77             permits[to][amount].addrBYes = true;
78         } else {
79             require(false);
80         }
81 
82         if (permits[to][amount].addrAYes == true && permits[to][amount].addrBYes == true) {
83             token.transfer(to, amount);
84             permits[to][amount].addrAYes = false;
85             permits[to][amount].addrBYes = false;
86         }
87         emit Transfer(msg.sender, to, amount);
88         return true;
89     }
90     function balanceOf(address _owner) public view returns (uint) {
91         IERC20 token = IERC20(addrToken);
92         if (_owner==addrA || _owner==addrB){
93             return token.balanceOf(this);
94         }
95         return 0;
96     }
97 }