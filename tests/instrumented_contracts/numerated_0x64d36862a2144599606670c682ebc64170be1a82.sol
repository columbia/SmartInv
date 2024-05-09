1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         if (msg.sender != owner) {
12             revert();
13         }
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         if (newOwner != address(0)) {
19             owner = newOwner;
20         }
21     }
22 
23 }
24 
25 contract SafeMath {
26     function safeSub(uint a, uint b) pure internal returns (uint) {
27         sAssert(b <= a);
28         return a - b;
29     }
30 
31     function safeAdd(uint a, uint b) pure internal returns (uint) {
32         uint c = a + b;
33         sAssert(c>=a && c>=b);
34         return c;
35     }
36 
37     function sAssert(bool assertion) pure internal {
38         if (!assertion) {
39             revert();
40         }
41     }
42 }
43 
44 contract ERC20 {
45     uint public totalSupply;
46     function balanceOf(address who) public constant returns (uint);
47     function allowance(address owner, address spender) public constant returns (uint);
48 
49     function transfer(address to, uint value) public returns (bool ok);
50     function transferFrom(address from, address to, uint value) public returns (bool ok);
51     function approve(address spender, uint value) public returns (bool ok);
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 }
55 
56 contract StandardToken is ERC20, SafeMath {
57     mapping(address => uint) balances;
58     mapping (address => mapping (address => uint)) allowed;
59 
60     function transfer(address _to, uint _value) public returns (bool success) {
61         balances[msg.sender] = safeSub(balances[msg.sender], _value);
62         balances[_to] = safeAdd(balances[_to], _value);
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
68         var _allowance = allowed[_from][msg.sender];
69 
70         balances[_to] = safeAdd(balances[_to], _value);
71         balances[_from] = safeSub(balances[_from], _value);
72         allowed[_from][msg.sender] = safeSub(_allowance, _value);
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function balanceOf(address _owner) public constant returns (uint balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint _value) public returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
88         return allowed[_owner][_spender];
89     }
90 }
91 
92 contract CERTIToken is Ownable, StandardToken {
93     string public name = "SingleSource";
94     string public symbol = "CERTI";
95     uint public decimals = 18;
96 
97     uint public totalSupply = 2000000000 ether;
98 
99     function CERTIToken() {
100         balances[msg.sender] = totalSupply;
101     }
102 
103     function () public {
104     }
105 
106     function transferOwnership(address _newOwner) public onlyOwner {
107         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
108         balances[owner] = 0;
109         Ownable.transferOwnership(_newOwner);
110     }
111 
112     function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
113         return ERC20(tokenAddress).transfer(owner, amount);
114     }
115 }