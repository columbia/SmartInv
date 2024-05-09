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
48 contract TOSInstitutionsIncentiveContract {
49     using SafeERC20 for ERC20;
50     using SafeMath for uint;
51     string public constant name = "TOSInstitutionsIncentiveContract";
52 
53 
54     uint256 public constant RELEASE_START               = 1541347200; //2018/11/5 0:0:0
55     uint256 public constant RELEASE_INTERVAL            = 30 days; // 30 days
56     address public constant beneficiary = 0x34F7747e0A4375FC6A0F22c3799335E9bE3A18fF;
57     ERC20 public constant tosToken = ERC20(0xFb5a551374B656C6e39787B1D3A03fEAb7f3a98E);
58     
59 
60     uint[6] public releasePercentages = [
61         15,  //15%
62         35,   //20%
63         50,   //15%
64         65,   //15%
65         80,   //15%
66         100   //20%
67     ];
68 
69 
70     uint256 public released = 0;
71     uint256 public totalLockAmount = 0; 
72     function TOSInstitutionsIncentiveContract() public {}
73 
74     function release() public {
75 
76         uint256 num = now.sub(RELEASE_START).div(RELEASE_INTERVAL);
77         if (totalLockAmount == 0) {
78             totalLockAmount = tosToken.balanceOf(this);
79         }
80 
81         if (num >= releasePercentages.length.sub(1)) {
82             tosToken.safeTransfer(beneficiary, tosToken.balanceOf(this));
83             released = 100;
84         }
85         else {
86             uint256 releaseAmount = totalLockAmount.mul(releasePercentages[num].sub(released)).div(100);
87             tosToken.safeTransfer(beneficiary, releaseAmount);
88             released = releasePercentages[num];
89         }
90     }
91 }