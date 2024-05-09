1 pragma solidity ^0.4.16;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner()  {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         if (newOwner != address(0)) {
18             owner = newOwner;
19         }
20     }
21 
22 }
23 
24 contract SafeMath {
25     function safeSub(uint a, uint b) pure internal returns (uint) {
26         sAssert(b <= a);
27         return a - b;
28     }
29 
30     function safeAdd(uint a, uint b) pure internal returns (uint) {
31         uint c = a + b;
32         sAssert(c>=a && c>=b);
33         return c;
34     }
35 
36     function sAssert(bool assertion) internal pure {
37         if (!assertion) {
38             revert();
39         }
40     }
41 }
42 
43 contract ERC20 {
44     uint public totalSupply;
45     function balanceOf(address who) public constant returns (uint);
46     function allowance(address owner, address spender) public constant returns (uint);
47 
48     function transfer(address toAcct, uint value) public returns (bool ok);
49     function transferFrom(address fromAcct, address toAcct, uint value) public returns (bool ok);
50     function approve(address spender, uint value) public returns (bool ok);
51     event Transfer(address indexed fromAcct, address indexed toAcct, uint value);
52     event Approval(address indexed owner, address indexed spender, uint value);
53 }
54 
55 contract StandardToken is ERC20, SafeMath {
56 
57     mapping(address => uint) balances;
58     mapping (address => mapping (address => uint)) allowed;
59 
60     function transfer(address _toAcct, uint _value) public returns (bool success) {
61         balances[msg.sender] = safeSub(balances[msg.sender], _value);
62         balances[_toAcct] = safeAdd(balances[_toAcct], _value);
63         Transfer(msg.sender, _toAcct, _value);
64         return true;
65     }
66 
67     function transferFrom(address _fromAcct, address _toAcct, uint _value) public returns (bool success) {
68         var _allowance = allowed[_fromAcct][msg.sender];
69         balances[_toAcct] = safeAdd(balances[_toAcct], _value);
70         balances[_fromAcct] = safeSub(balances[_fromAcct], _value);
71         allowed[_fromAcct][msg.sender] = safeSub(_allowance, _value);
72         Transfer(_fromAcct, _toAcct, _value);
73         return true;
74     }
75 
76     function balanceOf(address _owner) public constant returns (uint balance) {
77         return balances[_owner];
78     }
79 
80     function approve(address _spender, uint _value) public  returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
87         return allowed[_owner][_spender];
88     }
89 
90 }
91 
92 contract BcbCoin is Ownable, StandardToken {
93 
94     string public name;
95     string public symbol;
96     uint public decimals;                  
97     uint public totalSupply;  
98 
99 
100     /// @notice Initializes the contract and allocates all initial tokens to the owner and agreement account
101     function BcbCoin() public {
102         totalSupply = 100 * (10**6) * (10**18); 
103         balances[msg.sender] = totalSupply;
104         name = "BCB";
105         symbol = "BCB";
106         decimals = 18;  
107     }
108 
109     function () payable public{
110     }
111 
112     /// @notice To transfer token contract ownership
113     /// @param _newOwner The address of the new owner of this contract
114     function transferOwnership(address _newOwner) public onlyOwner {
115         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
116         balances[owner] = 0;
117         Ownable.transferOwnership(_newOwner);
118     }
119 
120     // Owner can transfer out any ERC20 tokens sent in by mistake
121     function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success)
122     {
123         return ERC20(tokenAddress).transfer(owner, amount);
124     }
125 
126 }