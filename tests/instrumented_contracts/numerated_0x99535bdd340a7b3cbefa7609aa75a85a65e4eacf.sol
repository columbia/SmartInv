1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-05
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2018-06-12
7 */
8 pragma solidity ^0.4.24;
9 //**************************** INTERFACE ***************************************
10 interface ERC20 {
11 function transferFrom(address _from, address _to, uint256 _value)
12 external returns (bool);
13 function transfer(address _to, uint256 _value)
14 external returns (bool);
15 function balanceOf(address _owner)
16 external constant returns (uint256);
17 function allowance(address _owner, address _spender)
18 external returns (uint256);
19 function approve(address _spender, uint256 _value)
20 external returns (bool);
21 event Approval(address indexed _owner, address indexed _spender, uint256  _val);
22 event Transfer(address indexed _from, address indexed _to, uint256 _val);
23 }
24 //***************************** CONTRACT ***************************************
25 contract GBCToken is ERC20 {
26 uint256 public totalSupply;
27 uint public decimals;
28 string public symbol;
29 string public name;
30 mapping (address => mapping (address => uint256)) approach;
31 mapping (address => uint256) holders;
32 //***************************** REVERT IF ETHEREUM SEND ************************
33 function () public {
34 revert();
35 }
36 //***************************** CHECK BALANCE **********************************
37 function balanceOf(address _own)
38 public view returns (uint256) {
39 return holders[_own];
40 }
41 //***************************** TRANSFER TOKENS FROM YOUR ACCOUNT **************
42 function transfer(address _to, uint256 _val)
43 public returns (bool) {
44 require(holders[msg.sender] >= _val);
45 require(msg.sender != _to);
46 assert(_val <= holders[msg.sender]);
47 holders[msg.sender] = holders[msg.sender] - _val;
48 holders[_to] = holders[_to] + _val;
49 assert(holders[_to] >= _val);
50 emit Transfer(msg.sender, _to, _val);
51 return true;
52 }
53 //**************************** TRANSFER TOKENS FROM ANOTHER ACCOUNT ************
54 function transferFrom(address _from, address _to, uint256 _val)
55 public returns (bool) {
56 require(holders[_from] >= _val);
57 require(approach[_from][msg.sender] >= _val);
58 assert(_val <= holders[_from]);
59 holders[_from] = holders[_from] - _val;
60 assert(_val <= approach[_from][msg.sender]);
61 approach[_from][msg.sender] = approach[_from][msg.sender] - _val;
62 holders[_to] = holders[_to] + _val;
63 assert(holders[_to] >= _val);
64 emit Transfer(_from, _to, _val);
65 return true;
66 }
67 //***************************** APPROVE TOKENS TO SEND *************************
68 function approve(address _spender, uint256 _val)
69 public returns (bool) {
70 require(holders[msg.sender] >= _val);
71 approach[msg.sender][_spender] = _val;
72 emit Approval(msg.sender, _spender, _val);
73 return true;
74 }
75 //***************************** CHECK APPROVE **********************************
76 function allowance(address _owner, address _spender)
77 public view returns (uint256) {
78 return approach[_owner][_spender];
79 }
80 //***************************** CONSTRUCTOR CONTRACT ***************************
81 constructor() public {
82 symbol = "GBCT";
83 name = "GOD Beast CoinToken";
84 decimals = 18;
85 totalSupply = 330000000* 1000000000000000000;
86 holders[msg.sender] = totalSupply;
87 }
88 }