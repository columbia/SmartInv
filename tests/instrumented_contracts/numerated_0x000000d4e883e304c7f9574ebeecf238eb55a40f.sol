1 pragma solidity ^0.4.24;
2 
3 interface TokenReceiver {
4   function tokenFallback(address from, uint256 qty, bytes data) external;
5 }
6 
7 library SafeMath {
8   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9     require(b <= a);
10     return a - b;
11   }
12   function add(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a + b;
14     require(c >= a);
15     return c;
16   }
17 }
18 
19 contract DSWP {
20   using SafeMath for uint256;
21   mapping (address => uint256) public balanceOf;
22   mapping (address => mapping (address => uint256)) public allowance;
23   uint256 public decimals = 18;
24   string public name = "Darkswap";
25   string public symbol = "DSWP";
26   uint256 public totalSupply = 1e22;
27   event Transfer(address indexed from, address indexed to, uint256 qty);
28   event Approval(address indexed from, address indexed spender, uint256 qty);
29   constructor() public {
30     balanceOf[msg.sender] = totalSupply;
31   }
32   function isContract(address target) internal view returns (bool) {
33     uint256 codeLength;
34     assembly {
35       codeLength := extcodesize(target)
36     }
37     return codeLength > 0;
38   }
39   function transfer(address target, uint256 qty) external returns (bool) {
40     balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);
41     balanceOf[target] = balanceOf[target].add(qty);
42     if (isContract(target)) {
43       TokenReceiver(target).tokenFallback(target, qty, "");
44     }
45     emit Transfer(msg.sender, target, qty);
46     return true;
47   }
48   function transfer(address target, uint256 qty, bytes data) external returns (bool) {
49     balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);
50     balanceOf[target] = balanceOf[target].add(qty);
51     if (isContract(target)) {
52       TokenReceiver(target).tokenFallback(target, qty, data);
53     }
54     emit Transfer(msg.sender, target, qty);
55     return true;
56   }
57   function transferFrom(address from, address to, uint256 qty) external returns (bool) {
58     allowance[from][msg.sender] = allowance[from][msg.sender].sub(qty);
59     balanceOf[from] = balanceOf[from].sub(qty);
60     balanceOf[to] = balanceOf[to].add(qty);
61     emit Transfer(from, to, qty);
62     return true;
63   }
64   function approve(address spender, uint256 qty) external returns (bool) {
65     allowance[msg.sender][spender] = qty;
66     emit Approval(msg.sender, spender, qty);
67     return true;
68   }
69 }