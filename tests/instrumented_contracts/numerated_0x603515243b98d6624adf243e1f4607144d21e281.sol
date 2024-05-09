1 pragma solidity ^0.4.16;
2 
3 contract ERC20Token {
4 
5     uint256 public totalSupply;
6     string public name;
7     uint8 public decimals;
8     string public symbol;
9     mapping (address => uint256) balances;
10     mapping (address => mapping (address => uint256)) allowed;
11     
12     function balanceOf(address _owner) public constant returns (uint256 balance);
13     function transfer(address _to, uint256 _value) public returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15     function approve(address _spender, uint256 _value) public returns (bool success);
16     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract ZToken is ERC20Token {
22 
23 	function () public {
24         require(false);
25     }
26 
27 	function ZToken(
28         uint256 _initialAmount,
29         string _tokenName,
30         uint8 _decimalUnits,
31         string _tokenSymbol
32         ) public {
33         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
34         balances[msg.sender] = totalSupply;
35         name = _tokenName;
36         decimals = _decimalUnits;
37         symbol = _tokenSymbol;
38     }
39 
40     function transfer(address _to, uint256 _value) public returns (bool success) {
41         if (balances[msg.sender] >= _value && _value > 0) {
42             balances[msg.sender] -= _value;
43             balances[_to] += _value;
44             Transfer(msg.sender, _to, _value);
45             return true;
46         } else { 
47 	    return false; 
48 	}
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { 
59 	    return false; 
60 	}
61     }
62 
63     function balanceOf(address _owner) public constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint256 _value) public returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 }