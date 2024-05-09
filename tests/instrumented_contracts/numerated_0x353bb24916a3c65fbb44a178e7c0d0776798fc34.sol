1 pragma solidity ^0.4.19;
2 
3 /* taking ideas from OpenZeppelin, thanks*/
4 contract SafeMath {
5     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
12         assert(x >= y);
13         return x - y;
14     }
15 }
16 
17 contract Token {
18     uint256 public totalSupply;
19 
20     function balanceOf(address _owner) public view returns (uint256 balance);
21 
22     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
23 
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27 
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 
30     event LogTransfer(address indexed _from, address indexed _to, uint256 _value);
31     event LogApproval(address indexed _owner, address indexed _spender, uint256 _value);
32 }
33 
34 /* ERC 20 token */
35 contract StandardToken is Token, SafeMath {
36     mapping(address => uint256) public balances;
37     mapping(address => mapping(address => uint256)) allowed;
38 
39     // prvent from the ERC20 short address attack
40     modifier onlyPayloadSize(uint size) {
41         require(msg.data.length >= size + 4);
42         _;
43     }
44 
45     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
46         require(_to != 0x0);
47         balances[msg.sender] = safeSub(balances[msg.sender], _value);
48         balances[_to] = safeAdd(balances[_to], _value);
49         LogTransfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool success) {
54         balances[_from] = safeSub(balances[_from], _value);
55         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
56         balances[_to] = safeAdd(balances[_to], _value);
57         LogTransfer(_from, _to, _value);
58         return true;
59     }
60 
61     function approve(address _spender, uint256 _value) public returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         LogApproval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public view returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
72         return allowed[_owner][_spender];
73     }
74 }
75 
76 contract XCTToken is StandardToken {
77     //meta data
78     string public constant name = "XChain Token";
79     string public constant symbol = "NXCT";
80     uint8 public constant decimals = 18;
81 
82     function XCTToken() public {
83         // 3.2b Coins in total, destroyed 130m, left 3.07b
84         totalSupply = 307 * 10**25;
85         balances[msg.sender] = totalSupply;
86     }
87 }