1 pragma solidity ^0.4.21;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 contract ERC20 is ERC20Basic {
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 library SafeERC20 {
16     function safeTransfer(ERC20 token, address to, uint256 value) internal {
17         assert(token.transfer(to, value));
18     }
19     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal{
20         assert(token.transferFrom(from, to, value));
21     }
22 }
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a / b;
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract TOSPrivateHoldingContract {
49     using SafeERC20 for ERC20;
50     using SafeMath for uint;
51     string public constant name = "TOSPrivateHoldingContract";
52     uint[6] public releasePercentages = [
53         15,  //15%
54         35,   //20%
55         50,   //15%
56         65,   //15%
57         80,   //15%
58         100   //20%
59     ];
60 
61     uint256 public constant RELEASE_START               = 1541260800; //2018/11/4 0:0:0
62     uint256 public constant RELEASE_INTERVAL            = 30 days; // 30 days
63     uint256 public RELEASE_END                          = RELEASE_START.add(RELEASE_INTERVAL.mul(5));
64     ERC20 public tosToken = ERC20(0xFb5a551374B656C6e39787B1D3A03fEAb7f3a98E);
65     address public beneficiary = 0xbd9d16f47F061D9c6b1C82cb46f33F0aC3dcFB87;
66 
67 
68     uint256 public released = 0;
69     uint256 public totalLockAmount = 0; 
70     function TOSPrivateHoldingContract() public {}
71     function release() public {
72 
73         uint256 num = now.sub(RELEASE_START).div(RELEASE_INTERVAL);
74         if (totalLockAmount == 0) {
75             totalLockAmount = tosToken.balanceOf(this);
76         }
77 
78         if (num >= releasePercentages.length.sub(1)) {
79             tosToken.safeTransfer(beneficiary, tosToken.balanceOf(this));
80             released = 100;
81         }
82         else {
83             uint256 releaseAmount = totalLockAmount.mul(releasePercentages[num].sub(released)).div(100);
84             tosToken.safeTransfer(beneficiary, releaseAmount);
85             released = releasePercentages[num];
86         }
87     }
88 }