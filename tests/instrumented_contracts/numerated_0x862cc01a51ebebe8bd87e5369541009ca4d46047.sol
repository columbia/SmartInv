1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 }
15 
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 contract BasicToken is ERC20Basic {
24   using SafeMath for uint256;
25 
26   mapping(address => uint256) internal balances;
27   uint256 internal totalSupply_;
28 
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   function balanceOf(address _owner) public view returns (uint256) {
34     return balances[_owner];
35   }
36 
37   function transfer(address _to, uint256 _value) public returns (bool) {
38     require(_to != address(0));
39     require(_value <= balances[msg.sender]);
40 
41     balances[msg.sender] = balances[msg.sender].sub(_value);
42     balances[_to] = balances[_to].add(_value);
43     emit Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 }
47 
48 contract DianGuWang is BasicToken {
49   string public name;
50   string public symbol;
51   uint8 public decimals;
52 
53   constructor() public {
54     name = "DianGuWang";
55     symbol = "DGW";
56     decimals = 18;
57     totalSupply_ = 1e24;
58     balances[msg.sender]=totalSupply_;
59     emit Transfer(address(0), msg.sender, totalSupply_);
60   }
61 }