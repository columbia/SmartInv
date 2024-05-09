1 /**
2  *Submitted for verification at Etherscan.io on 2019-12-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-12
7 */
8 
9 pragma solidity ^0.4.8;
10 contract Token{
11     uint256 public totalSupply;
12 
13     function balanceOf(address _owner) constant returns (uint256 balance);
14 
15     function transfer(address _to, uint256 _value) returns (bool success);
16 
17     function transferFrom(address _from, address _to, uint256 _value) returns   
18     (bool success);
19 
20     function approve(address _spender, uint256 _value) returns (bool success);
21 
22     function allowance(address _owner, address _spender) constant returns 
23     (uint256 remaining);
24 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     event Approval(address indexed _owner, address indexed _spender, uint256 
28     _value);
29 }
30 
31 contract StandardToken is Token {
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         require(balances[msg.sender] >= _value);
34         balances[msg.sender] -= _value;
35         balances[_to] += _value;
36         Transfer(msg.sender, _to, _value);
37         return true;
38     }
39 
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns 
42     (bool success) {
43         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
44         balances[_to] += _value;
45         balances[_from] -= _value; 
46         allowed[_from][msg.sender] -= _value;
47         Transfer(_from, _to, _value);
48         return true;
49     }
50     function balanceOf(address _owner) constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54 
55     function approve(address _spender, uint256 _value) returns (bool success)   
56     {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64         return allowed[_owner][_spender];
65     }
66     mapping (address => uint256) balances;
67     mapping (address => mapping (address => uint256)) allowed;
68 }
69 
70 contract TokenOGCC is StandardToken { 
71 
72     /* Public variables of the token */
73     string public name;                   
74     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
75     string public symbol;               //token简称: eg SBX
76     string public version = 'H0.1';    //版本
77 
78     function TokenOGCC(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
79         balances[msg.sender] = _initialAmount; 
80         totalSupply = _initialAmount;         // 设置初始总量
81         name = _tokenName;                   // token名称
82         decimals = _decimalUnits;           // 小数位数
83         symbol = _tokenSymbol;             // token简称
84     }
85 
86     /* Approves and then calls the receiving contract */
87     
88     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
92         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
93         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
94         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
95         return true;
96     }
97 
98 }