1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-21
3 */
4 
5 pragma solidity >=0.4.0 <0.6.0;
6 
7 contract Token{
8     
9     uint256 public totalSupply;
10 
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 
13     function transfer(address _to, uint256 _value) public returns (bool success);
14 
15     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16 
17     function approve(address _spender, uint256 _value)public returns (bool success);
18 
19     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22 
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 }
25 
26 contract StandardToken is Token {
27     function transfer(address _to, uint256 _value) public returns (bool success) {
28         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
29         balances[msg.sender] -= _value;
30         balances[_to] += _value;
31         emit Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value)public returns 
36     (bool success) {
37         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
38         balances[_to] += _value;
39         balances[_from] -= _value;
40         allowed[_from][msg.sender] -= _value;
41         emit Transfer(_from, _to, _value);
42         return true;
43     }
44     function balanceOf(address _owner) public view returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value)public returns (bool success)   
49     {
50         allowed[msg.sender][_spender] = _value;
51         emit Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55 
56     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
57         return allowed[_owner][_spender];
58     }
59     mapping (address => uint256) balances;
60     mapping (address => mapping (address => uint256)) allowed;
61 }
62 
63 contract BLTC is StandardToken { 
64     
65     string public name;
66     uint8 public decimals;
67     string public symbol;
68 
69     constructor(uint256 _initialAmount, string memory  _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) public{
70         balances[msg.sender] = _initialAmount;
71         totalSupply = _initialAmount;
72         name = _tokenName;     
73         decimals = _decimalUnits;
74         symbol = _tokenSymbol;
75     }
76 }