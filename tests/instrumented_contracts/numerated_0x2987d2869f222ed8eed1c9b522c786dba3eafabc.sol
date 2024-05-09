1 pragma solidity ^0.5.1;
2 
3 contract SafeMath {
4  uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
5 
6  function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
7    if (x > MAX_UINT256 - y) revert();
8   return x + y;
9  }
10 
11  function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
12     if (x < y) revert();
13     return x - y;
14  }
15 
16  function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
17     if (y == 0) return 0;
18     if (x > MAX_UINT256 / y) revert();
19     return x * y;
20  }
21 }
22 
23 contract Unic is SafeMath {
24   mapping(address => uint) public balances;
25   string public name = "UNICORN";
26   string public symbol = "UNIC";
27   uint8 public decimals = 18;
28   uint256 public totalSupply = 210000000000000000000000000;
29 
30   event Transfer(address indexed from, address indexed to, uint value);
31     event Burn(address indexed from, uint256 value);
32 
33   constructor() public payable { balances[msg.sender] = totalSupply; }
34 
35   function isContract(address ethAddress) private view returns (bool) {
36     uint length;
37     assembly { length := extcodesize(ethAddress) }
38     return (length>0);
39   }
40 
41   function transfer(address to, uint value) public returns (bool success) {
42     balances[msg.sender] = safeSub(balances[msg.sender], value);
43     balances[to] = safeAdd(balances[to], value);
44     if(isContract(to)) {
45       ITokenRecipient receiver = ITokenRecipient(to);
46       receiver.tokenFallback(msg.sender, value);
47     }
48     emit Transfer(msg.sender, to, value);
49     return true;
50   }
51 
52   function burn(uint256 value) public returns (bool success) {
53     balances[msg.sender] = safeSub(balances[msg.sender], value);
54     totalSupply = safeSub(totalSupply,value); 
55     emit Burn(msg.sender, value);
56     return true;
57   }
58 
59   function balanceOf(address ethAddress) public view returns (uint balance) {
60     return balances[ethAddress];
61   }
62 }
63 
64 contract ITokenRecipient {
65   function tokenFallback(address from, uint value) public;
66 }