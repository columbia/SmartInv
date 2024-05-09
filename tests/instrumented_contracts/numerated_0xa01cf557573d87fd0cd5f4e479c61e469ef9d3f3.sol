1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner = msg.sender;
5 
6   /// @notice check if the caller is the owner of the contract
7   modifier onlyOwner {
8     if (msg.sender != owner) throw;
9     _;
10   }
11 
12   /// @notice change the owner of the contract
13   /// @param _newOwner the address of the new owner of the contract.
14   function changeOwner(address _newOwner)
15   onlyOwner
16   {
17     if(_newOwner == 0x0) throw;
18     owner = _newOwner;
19   }
20 }
21 
22 contract SafeMath{
23   function safeMul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function safeDiv(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 	
36 	function safeSub(uint a, uint b) internal returns (uint) {
37     	assert(b <= a);
38     	return a - b;
39   }
40 
41 	function safeAdd(uint a, uint b) internal returns (uint) {
42     	uint c = a + b;
43     	assert(c >= a);
44     	return c;
45   }
46 	function assert(bool assertion) internal {
47 	    if (!assertion) {
48 	      revert();
49 	    }
50 	}
51 }
52 
53 contract Token {
54 
55     function totalSupply() constant returns (uint256 supply) {}
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {}
58 
59     function transfer(address _to, uint256 _value) returns (bool success) {}
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
62 
63     function approve(address _spender, uint256 _value) returns (bool success) {}
64 
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 contract StandardToken is Token , SafeMath{
72 
73     function transfer(address _to, uint256 _value) returns (bool success) {
74         if (balances[msg.sender] >= _value && _value > 0) {
75             balances[msg.sender] = safeSub(balances[msg.sender], _value);
76             balances[_to] = safeAdd(balances[_to],_value);
77             Transfer(msg.sender, _to, _value);
78             return true;
79         } else { return false; }
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
83          if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
84             balances[_to] = safeAdd(balances[_to],_value);
85             balances[_from] = safeSub(balances[_from],_value);
86             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
87             Transfer(_from, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function balanceOf(address _owner) constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     function approve(address _spender, uint256 _value) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103       return allowed[_owner][_spender];
104     }
105 
106     mapping (address => uint256) balances;
107     mapping (address => mapping (address => uint256)) allowed;
108     uint256 public totalSupply;
109 }
110 
111 contract multiSend is Ownable, StandardToken {
112 
113 function multisend(address _tokenAddr, address[] dests, uint256[] values)
114     onlyOwner
115     returns (uint256) {
116         uint256 i = 0;
117         while (i < dests.length) {
118            StandardToken(_tokenAddr).transfer(dests[i], values[i]);
119            i += 1;
120         }
121         return(i);
122     }
123 }