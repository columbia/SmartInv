1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 library SafeMath {
5   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function add(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a + b;
12     assert(c >= a);
13     return c;
14   }
15 }
16 
17 contract ERC20 {
18   using SafeMath for uint256;
19 
20   string public constant name = "Dorayaki";
21   string public constant symbol = "DORA";
22   uint256 public constant decimals = 18;
23   uint256 _totalSupply = 10000000 ether;
24 
25   mapping (address => uint256) internal _balances;
26   mapping (address => mapping (address => uint256)) internal _allowed;
27 
28   event Transfer(address indexed _from, address indexed _to, uint256 _value);
29   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31   constructor(address _founder) {
32     _balances[_founder] = _totalSupply;
33   }
34 
35   function totalSupply() public view returns (uint256 supply) {
36     return _totalSupply;
37   }
38 
39   function balanceOf(address _owner) public view returns (uint256 balance) {
40     return _balances[_owner];
41   }
42 
43   function transfer(address _to, uint256 _value) public returns (bool success) {
44     require (_to != address(0), "");
45     _balances[msg.sender] = _balances[msg.sender].sub(_value);
46     _balances[_to] = _balances[_to].add(_value);
47     emit Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52     require (_to != address(0), "");
53     _balances[_from] = _balances[_from].sub(_value);
54     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
55     _balances[_to] = _balances[_to].add(_value);
56     emit Transfer(_from, _to, _value);
57     return true;
58   }
59 
60   function approve(address _spender, uint256 _value) public returns (bool success) {
61     require(_allowed[msg.sender][_spender] == 0 || _value == 0);
62     _allowed[msg.sender][_spender] = _value;
63     emit Approval(msg.sender, _spender, _value);
64     return true;
65   }
66 
67   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
68     return _allowed[_owner][_spender];
69   }
70 }