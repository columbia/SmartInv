1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-21
3 */
4 
5 pragma solidity ^0.4.6;
6 
7 contract SprintBit {
8 
9   string public name = "SprintBit";
10   string public symbol = "SBT";
11   uint public decimals = 18;
12   uint public INITIAL_SUPPLY = 100000000000000000000000000;
13 
14   mapping(address => uint) balances;
15   mapping (address => mapping (address => uint)) allowed;
16   uint256 public _totalSupply;
17   address public _creator;
18   bool bIsFreezeAll = false;
19   
20   event Transfer(address indexed from, address indexed to, uint value);
21   event Approval(address indexed owner, address indexed spender, uint value);
22   
23   function safeSub(uint a, uint b) internal returns (uint) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function safeAdd(uint a, uint b) internal returns (uint) {
29     uint c = a + b;
30     assert(c>=a && c>=b);
31     return c;
32   }
33   
34   function totalSupply() public constant returns (uint256 total) {
35 	total = _totalSupply;
36   }
37 
38   function transfer(address _to, uint _value) public returns (bool success) {
39     require(bIsFreezeAll == false);
40     balances[msg.sender] = safeSub(balances[msg.sender], _value);
41     balances[_to] = safeAdd(balances[_to], _value);
42     Transfer(msg.sender, _to, _value);
43     return true;
44   }
45 
46   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
47     require(bIsFreezeAll == false);
48     var _allowance = allowed[_from][msg.sender];
49     balances[_to] = safeAdd(balances[_to], _value);
50     balances[_from] = safeSub(balances[_from], _value);
51     allowed[_from][msg.sender] = safeSub(_allowance, _value);
52     Transfer(_from, _to, _value);
53     return true;
54   }
55 
56   function balanceOf(address _owner) public constant returns (uint balance) {
57     return balances[_owner];
58   }
59 
60   function approve(address _spender, uint _value) public returns (bool success) {
61 	require(bIsFreezeAll == false);
62     allowed[msg.sender][_spender] = _value;
63     Approval(msg.sender, _spender, _value);
64     return true;
65   }
66 
67   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
68     return allowed[_owner][_spender];
69   }
70 
71   function freezeAll() public 
72   {
73 	require(msg.sender == _creator);
74 	bIsFreezeAll = !bIsFreezeAll;
75   }
76   
77   function SprintBit() public {
78         _totalSupply = INITIAL_SUPPLY;
79 	_creator = 0xc66c4A406ff17E976C06025a750ED3723EDA174c;
80 	balances[_creator] = INITIAL_SUPPLY;
81 	bIsFreezeAll = false;
82   }
83   
84   function destroy() public  {
85 	require(msg.sender == _creator);
86 	selfdestruct(_creator);
87   }
88 
89 }