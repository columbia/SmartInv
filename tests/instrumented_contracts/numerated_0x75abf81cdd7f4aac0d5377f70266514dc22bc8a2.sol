1 pragma solidity ^0.4.8;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) public returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value) public returns   
10     (bool success);
11 
12     function approve(address _spender, uint256 _value) public returns (bool success);
13 
14     function allowance(address _owner, address _spender) public constant returns 
15     (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 
20     _value);
21 }
22 
23 contract StandardToken is Token {
24     function transfer(address _to, uint256 _value) public returns (bool success) {
25         require(balances[msg.sender] >= _value);
26         balances[msg.sender] -= _value;
27         balances[_to] += _value;
28         emit Transfer(msg.sender, _to, _value);
29         return true;
30     }
31 
32 
33     function transferFrom(address _from, address _to, uint256 _value) public returns 
34     (bool success) {
35         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
36         balances[_to] += _value;
37         balances[_from] -= _value;
38         allowed[_from][msg.sender] -= _value;
39         emit Transfer(_from, _to, _value);
40         return true;
41     }
42     function balanceOf(address _owner) public constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46 
47     function approve(address _spender, uint256 _value) public returns (bool success)   
48     {
49         allowed[msg.sender][_spender] = _value;
50         emit Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54 
55     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
56         return allowed[_owner][_spender];
57     }
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60 }
61 
62 contract HumanStandardToken is StandardToken { 
63 
64     string public name;
65     uint8 public decimals;
66     string public symbol;
67     string public version = "H0.1";
68 
69     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
70         balances[msg.sender] = _initialAmount;
71         totalSupply = _initialAmount;
72         name = _tokenName;
73         decimals = _decimalUnits;
74         symbol = _tokenSymbol;
75     }
76 
77     /* Approves and then calls the receiving contract */
78     
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
83         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
84         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
85         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
86         return true;
87     }
88 
89 }