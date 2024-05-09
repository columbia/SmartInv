1 pragma solidity ^0.4.23;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardToken is Token {
15 
16     function balanceOf(address _owner) public constant returns (uint256 balance) {
17         return balances[_owner];
18     }
19 
20     function transfer(address _to, uint256 _value) public returns (bool success) {
21         require(_value > 0);
22         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             emit Transfer(msg.sender, _to, _value);
26             return true;
27         } else { return false; }
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         require(_value > 0);
32         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
33             balances[_to] += _value;
34             balances[_from] -= _value;
35             allowed[_from][msg.sender] -= _value;
36             emit Transfer(_from, _to, _value);
37             return true;
38         } else { return false; }
39     }
40 
41     function approve(address _spender, uint256 _value) public returns (bool success) {
42         require(_value > 0);
43         allowed[msg.sender][_spender] = _value;
44         emit Approval(msg.sender, _spender, _value);
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
49       return allowed[_owner][_spender];
50     }
51 
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54 }
55 
56 contract Currency is StandardToken {
57 
58     string public name;
59     uint8 public decimals = 18;
60     string public symbol;
61 
62     constructor (address _to, uint256 initialSupply, string _tokenName, string _tokenSymbol) public {
63         totalSupply = initialSupply * 10 ** uint256(decimals);
64         balances[_to] = totalSupply;
65         name = _tokenName;
66         symbol = _tokenSymbol;
67     }
68 
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72 
73         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
74         return true;
75     }
76 }