1 pragma solidity ^0.4.10;
2 contract ERC20 {
3   uint public totalSupply;
4   function balanceOf(address who) constant returns (uint);
5   function allowance(address owner, address spender) constant returns (uint);
6 
7   function transfer(address to, uint value) returns (bool ok);
8   function transferFrom(address from, address to, uint value) returns (bool ok);
9   function approve(address spender, uint value) returns (bool ok);
10   event Transfer(address indexed from, address indexed to, uint value);
11   event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 /**
14  * Provides methods to safely add, subtract and multiply uint256 numbers.
15  */
16 contract SafeMath {
17   uint256 constant private MAX_UINT256 =
18     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
19 
20   /**
21    * Add two uint256 values, throw in case of overflow.
22    *
23    * @param x first value to add
24    * @param y second value to add
25    * @return x + y
26    */
27   function safeAdd (uint256 x, uint256 y)
28   constant internal
29   returns (uint256 z) {
30     if (x > MAX_UINT256 - y) throw;
31     return x + y;
32   }
33 
34   /**
35    * Subtract one uint256 value from another, throw in case of underflow.
36    *
37    * @param x value to subtract from
38    * @param y value to subtract
39    * @return x - y
40    */
41   function safeSub (uint256 x, uint256 y)
42   constant internal
43   returns (uint256 z) {
44     if (x < y) throw;
45     return x - y;
46   }
47 
48   /**
49    * Multiply two uint256 values, throw in case of overflow.
50    *
51    * @param x first value to multiply
52    * @param y second value to multiply
53    * @return x * y
54    */
55   function safeMul (uint256 x, uint256 y)
56   constant internal
57   returns (uint256 z) {
58     if (y == 0) return 0; // Prevent division by zero at the next line
59     if (x > MAX_UINT256 / y) throw;
60     return x * y;
61   }
62 }
63 
64 contract Vote is ERC20, SafeMath{
65 
66 	mapping (address => uint) balances;
67 	mapping (address => mapping (address => uint)) allowed;
68 
69 	uint public totalSupply;
70 	uint public initialSupply;
71 	string public name;
72 	string public symbol;
73 	uint8 public decimals;
74 
75 	function Vote(){
76 		initialSupply = 100000;
77 		totalSupply = initialSupply;
78 		balances[msg.sender] = initialSupply;
79 		name = "EthTaipei Logo Vote";
80 		symbol = "EthTaipei Logo";
81 		decimals = 0;
82 	}
83 
84 	function transfer(address _to, uint _value) returns (bool) {
85 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
86 	    balances[_to] = safeAdd(balances[_to], _value);
87 	    Transfer(msg.sender, _to, _value);
88 	    return true;
89   	}
90 
91   	function transferFrom(address _from, address _to, uint _value) returns (bool) {
92 	    var _allowance = allowed[_from][msg.sender];	    
93 	    balances[_to] = safeAdd(balances[_to], _value);
94 	    balances[_from] = safeSub(balances[_from], _value);
95 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
96 	    Transfer(_from, _to, _value);
97 	    return true;
98   	}
99 
100   	function approve(address _spender, uint _value) returns (bool) {
101     	allowed[msg.sender][_spender] = _value;
102     	Approval(msg.sender, _spender, _value);
103     	return true;
104   	}
105 
106   	function balanceOf(address _address) constant returns (uint balance) {
107   		return balances[_address];
108   	}
109 
110   	function allowance(address _owner, address _spender) constant returns (uint remaining) {
111     	return allowed[_owner][_spender];
112   	}
113 
114 }