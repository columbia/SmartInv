1 pragma solidity ^0.4.20;
2 
3 contract MB {
4 
5   string public name = "MircoChain";
6   string public symbol = "MB";
7   uint public decimals = 18;
8   uint public INITIAL_SUPPLY = 100000000000000000000000000000;
9     
10   mapping(address => uint) balances;
11   mapping (address => mapping (address => uint)) allowed;
12   uint256 public _totalSupply;
13   address public _creator;
14   bool bIsFreezeAll = false;
15   
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18   
19   function safeSub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29   
30   function totalSupply() public constant returns (uint256 total) {
31 	total = _totalSupply;
32   }
33 
34   function transfer(address _to, uint _value) public returns (bool success) {
35     require(bIsFreezeAll == false);
36     balances[msg.sender] = safeSub(balances[msg.sender], _value);
37     balances[_to] = safeAdd(balances[_to], _value);
38     Transfer(msg.sender, _to, _value);
39     return true;
40   }
41 
42   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
43     require(bIsFreezeAll == false);
44     var _allowance = allowed[_from][msg.sender];
45     balances[_to] = safeAdd(balances[_to], _value);
46     balances[_from] = safeSub(balances[_from], _value);
47     allowed[_from][msg.sender] = safeSub(_allowance, _value);
48     Transfer(_from, _to, _value);
49     return true;
50   }
51 
52   function balanceOf(address _owner) public constant returns (uint balance) {
53     return balances[_owner];
54   }
55 
56   function approve(address _spender, uint _value) public returns (bool success) {
57 	require(bIsFreezeAll == false);
58     allowed[msg.sender][_spender] = _value;
59     Approval(msg.sender, _spender, _value);
60     return true;
61   }
62 
63   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
64     return allowed[_owner][_spender];
65   }
66 
67   function freezeAll() public 
68   {
69 	require(msg.sender == _creator);
70 	bIsFreezeAll = !bIsFreezeAll;
71   }
72   
73   function MB() public {
74     _totalSupply = INITIAL_SUPPLY;
75 	_creator = 0xf2F91C1C681816eE275ce9b4366D5a906da6eBf5;
76 	balances[_creator] = INITIAL_SUPPLY;
77 	bIsFreezeAll = false;
78   }
79   
80   function destroy() public  {
81 	require(msg.sender == _creator);
82 	selfdestruct(_creator);
83   }
84 
85 }