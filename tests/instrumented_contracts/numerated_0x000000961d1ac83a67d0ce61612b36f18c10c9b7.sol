1 pragma solidity ^0.4.24;
2 
3 interface TokenReceiver {
4   function tokenFallback(address from, uint256 qty, bytes data) external;
5   function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
6 }
7 
8 library SafeMath {
9   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10     require(b <= a);
11     return a - b;
12   }
13   function add(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a + b;
15     require(c >= a);
16     return c;
17   }
18 }
19 
20 contract DSWP {
21   using SafeMath for uint256;
22   mapping (address => uint256) public balanceOf;
23   mapping (address => mapping (address => uint256)) public allowance;
24   uint256 public decimals = 18;
25   string public name = "Darkswap";
26   string public symbol = "DSWP";
27   uint256 public totalSupply = 10000e18;
28   event Transfer(address indexed from, address indexed to, uint256 qty);
29   event Approval(address indexed from, address indexed spender, uint256 qty);
30   constructor() public {
31     balanceOf[msg.sender] = totalSupply;
32   }
33   function isContract(address target) internal view returns (bool) {
34     uint256 codeLength;
35     assembly {
36       codeLength := extcodesize(target)
37     }
38     return codeLength > 0;
39   }
40   function transfer(address target, uint256 qty, bytes data) public returns (bool) {
41     balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);
42     balanceOf[target] = balanceOf[target].add(qty);
43     if (isContract(target)) {
44       TokenReceiver(target).tokenFallback(target, qty, data);
45     }
46     emit Transfer(msg.sender, target, qty);
47     return true;
48   }
49   function transfer(address target, uint256 qty) external returns (bool) {
50     return transfer(target, qty, "");
51   }
52   function transferFrom(address from, address to, uint256 qty) external returns (bool) {
53     allowance[from][msg.sender] = allowance[from][msg.sender].sub(qty);
54     balanceOf[from] = balanceOf[from].sub(qty);
55     balanceOf[to] = balanceOf[to].add(qty);
56     emit Transfer(from, to, qty);
57     return true;
58   }
59   function approve(address spender, uint256 qty) public returns (bool) {
60     allowance[msg.sender][spender] = qty;
61     emit Approval(msg.sender, spender, qty);
62     return true;
63   }
64   function approveAndCall(address spender, uint256 qty, bytes data) external returns (bool) {
65     require(approve(spender, qty));
66     TokenReceiver(spender).receiveApproval(msg.sender, qty, this, data);
67     return true;
68   }
69 }