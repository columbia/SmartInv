1 pragma solidity ^0.4.6;
2 
3 contract CoinPaws {
4 
5   string public name = "CoinPaws";
6   string public symbol = "CPS";
7   uint public decimals = 10;
8   uint public INITIAL_SUPPLY = 88000000000000000000;
9   
10     mapping(address => uint) balances;
11   mapping (address => mapping (address => uint)) allowed;
12   uint256 public _totalSupply;
13   address public _creator;
14   bool bIsFreezeAll = false;
15   
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18   
19   function safeSub(uint a, uint b) internal pure returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint a, uint b) internal pure returns (uint) {
25     uint c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 
30   
31   function totalSupply() public constant returns (uint256 total) {
32 	total = _totalSupply;
33   }
34 
35   function transfer(address _to, uint _value) public returns (bool success) {
36     require(bIsFreezeAll == false);
37     balances[msg.sender] = safeSub(balances[msg.sender], _value);
38     balances[_to] = safeAdd(balances[_to], _value);
39     Transfer(msg.sender, _to, _value);
40     return true;
41   }
42 
43   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
44     require(bIsFreezeAll == false);
45     var _allowance = allowed[_from][msg.sender];
46     balances[_to] = safeAdd(balances[_to], _value);
47     balances[_from] = safeSub(balances[_from], _value);
48     allowed[_from][msg.sender] = safeSub(_allowance, _value);
49     Transfer(_from, _to, _value);
50     return true;
51   }
52 
53   function balanceOf(address _owner) public constant returns (uint balance) {
54     return balances[_owner];
55   }
56 
57   function approve(address _spender, uint _value) public returns (bool success) {
58 	require(bIsFreezeAll == false);
59     allowed[msg.sender][_spender] = _value;
60     Approval(msg.sender, _spender, _value);
61     return true;
62   }
63 
64   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
65     return allowed[_owner][_spender];
66   }
67 
68   function freezeAll() public 
69   {
70 	require(msg.sender == _creator);
71 	bIsFreezeAll = !bIsFreezeAll;
72   }
73   
74   function CoinPaws() public {
75     _totalSupply = INITIAL_SUPPLY;
76 	_creator = 0x370249e149b3A4eBfB3bf58A2D3eb858a88D734A;
77 	balances[_creator] = INITIAL_SUPPLY;
78 	bIsFreezeAll = false;
79   }
80   
81   function destroy() public  {
82 	require(msg.sender == _creator);
83 	selfdestruct(_creator);
84   }
85 
86 }