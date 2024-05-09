1 pragma solidity >=0.4.0 <0.6.0;
2 
3 contract Token{
4     
5     uint256 public totalSupply;
6 
7     function balanceOf(address _owner) public view returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 
13     function approve(address _spender, uint256 _value)public returns (bool success);
14 
15     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18 
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 contract StandardToken is Token {
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
25         balances[msg.sender] -= _value;
26         balances[_to] += _value;
27         emit Transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value)public returns 
32     (bool success) {
33         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         allowed[_from][msg.sender] -= _value;
37         emit Transfer(_from, _to, _value);
38         return true;
39     }
40     function balanceOf(address _owner) public view returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value)public returns (bool success)   
45     {
46         allowed[msg.sender][_spender] = _value;
47         emit Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51 
52     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
53         return allowed[_owner][_spender];
54     }
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract ERC20 is StandardToken { 
60     
61     string public name;
62     uint8 public decimals;
63     string public symbol;
64 
65     constructor(uint256 _initialAmount, string memory  _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) public{
66         balances[msg.sender] = _initialAmount;
67         totalSupply = _initialAmount;
68         name = _tokenName;     
69         decimals = _decimalUnits;
70         symbol = _tokenSymbol;
71     }
72 }