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
23     
24     function transfer(address _to, uint256 _value) public returns (bool success) {
25         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
26         balances[msg.sender] -= _value;
27         balances[_to] += _value;
28         emit Transfer(msg.sender, _to, _value);
29         return true;
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value)public returns 
33     (bool success) {
34         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
35         balances[_to] += _value;
36         balances[_from] -= _value;
37         allowed[_from][msg.sender] -= _value;
38         emit Transfer(_from, _to, _value);
39         return true;
40     }
41     
42     function balanceOf(address _owner) public view returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value)public returns (bool success)   
47     {
48         allowed[msg.sender][_spender] = _value;
49         emit Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
54         return allowed[_owner][_spender];
55     }
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58 }
59 
60 contract CYO is StandardToken { 
61     
62     string public constant name = "CYO";
63     string public constant symbol = "CYO";
64     uint8 public constant decimals = 18;
65 
66     constructor(uint256 _initialAmount) public{
67         balances[msg.sender] = _initialAmount*10**18;
68         totalSupply =  _initialAmount*10**18;
69         emit Transfer(address(0), msg.sender, _initialAmount);
70     }
71 }