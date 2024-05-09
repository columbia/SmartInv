1 pragma solidity ^0.4.24;
2 //**************************** INTERFACE ***************************************
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
17 //***************************** CONTRACT ***************************************
18 contract Vestchain is ERC20 {
19 uint256 public totalSupply;
20 uint public decimals;
21 string public symbol;
22 string public name;
23 mapping (address => mapping (address => uint256)) approach;
24 mapping (address => uint256) holders;
25 //***************************** REVERT IF ETHEREUM SEND ************************
26 function () public {
27 revert();
28 }
29 //***************************** CHECK BALANCE **********************************
30 function balanceOf(address _own)
31 public view returns (uint256) {
32 return holders[_own];
33 }
34 //***************************** TRANSFER TOKENS FROM YOUR ACCOUNT **************
35 function transfer(address _to, uint256 _val)
36 public returns (bool) {
37 require(holders[msg.sender] >= _val);
38 require(msg.sender != _to);
39 assert(_val <= holders[msg.sender]);
40 holders[msg.sender] = holders[msg.sender] - _val;
41 holders[_to] = holders[_to] + _val;
42 assert(holders[_to] >= _val);
43 emit Transfer(msg.sender, _to, _val);
44 return true;
45 }
46 //**************************** TRANSFER TOKENS FROM ANOTHER ACCOUNT ************
47 function transferFrom(address _from, address _to, uint256 _val)
48 public returns (bool) {
49 require(holders[_from] >= _val);
50 require(approach[_from][msg.sender] >= _val);
51 assert(_val <= holders[_from]);
52 holders[_from] = holders[_from] - _val;
53 assert(_val <= approach[_from][msg.sender]);
54 approach[_from][msg.sender] = approach[_from][msg.sender] - _val;
55 holders[_to] = holders[_to] + _val;
56 assert(holders[_to] >= _val);
57 emit Transfer(_from, _to, _val);
58 return true;
59 }
60 //***************************** APPROVE TOKENS TO SEND *************************
61 function approve(address _spender, uint256 _val)
62 public returns (bool) {
63 require(holders[msg.sender] >= _val);
64 approach[msg.sender][_spender] = _val;
65 emit Approval(msg.sender, _spender, _val);
66 return true;
67 }
68 //***************************** CHECK APPROVE **********************************
69 function allowance(address _owner, address _spender)
70 public view returns (uint256) {
71 return approach[_owner][_spender];
72 }
73 //***************************** CONSTRUCTOR CONTRACT ***************************
74 constructor() public {
75 symbol = "VEST";
76 name = "Vestchain";
77 decimals = 8;
78 totalSupply = 884800000000000000;
79 holders[msg.sender] = totalSupply;
80 }
81 }