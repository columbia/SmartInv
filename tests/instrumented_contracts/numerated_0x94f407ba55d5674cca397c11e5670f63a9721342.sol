1 pragma solidity ^0.4.26;
2 
3 interface ERC20 {
4 function transferFrom(address _from, address _to, uint256 _value)
5 external returns (bool);
6 function transfer(address _to, uint256 _value)
7 external returns (bool);
8 function balanceOf(address _owner)
9 external constant returns (uint256);
10 function allowance(address _owner, address _spender)
11 external returns (uint256);
12 function approve(address _spender, uint256 _value)
13 external returns (bool);
14 event Approval(address indexed _owner, address indexed _spender, uint256  _val);
15 event Transfer(address indexed _from, address indexed _to, uint256 _val);
16 }
17 
18 contract Facility is ERC20 {
19 uint256 public totalSupply;
20 uint public decimals;
21 string public symbol;
22 string public name;
23 mapping (address => mapping (address => uint256)) approach;
24 mapping (address => uint256) holders;
25 
26 constructor() public {
27     name = "Facility Token";
28     symbol = "FACILITY";
29     decimals = 18;
30     totalSupply = 360000000 * 10**uint(decimals);
31     holders[msg.sender] = totalSupply;
32 }
33 
34 function () public {
35 revert();
36 }
37 
38 function balanceOf(address _own)
39 public view returns (uint256) {
40 return holders[_own];
41 }
42 
43 function transfer(address _to, uint256 _val)
44 public returns (bool) {
45 require(holders[msg.sender] >= _val);
46 require(msg.sender != _to);
47 assert(_val <= holders[msg.sender]);
48 holders[msg.sender] = holders[msg.sender] - _val;
49 holders[_to] = holders[_to] + _val;
50 assert(holders[_to] >= _val);
51 emit Transfer(msg.sender, _to, _val);
52 return true;
53 }
54 
55 function transferFrom(address _from, address _to, uint256 _val)
56 public returns (bool) {
57 require(holders[_from] >= _val);
58 require(approach[_from][msg.sender] >= _val);
59 assert(_val <= holders[_from]);
60 holders[_from] = holders[_from] - _val;
61 assert(_val <= approach[_from][msg.sender]);
62 approach[_from][msg.sender] = approach[_from][msg.sender] - _val;
63 holders[_to] = holders[_to] + _val;
64 assert(holders[_to] >= _val);
65 emit Transfer(_from, _to, _val);
66 return true;
67 }
68 
69 function approve(address _spender, uint256 _val)
70 public returns (bool) {
71 require(holders[msg.sender] >= _val);
72 approach[msg.sender][_spender] = _val;
73 emit Approval(msg.sender, _spender, _val);
74 return true;
75 }
76 
77 function allowance(address _owner, address _spender)
78 public view returns (uint256) {
79 return approach[_owner][_spender];
80 }
81 }