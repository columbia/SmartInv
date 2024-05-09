1 contract Token{
2     uint256 public totalSupply;
3 	mapping (address => uint256) balances;
4     mapping (address => mapping (address => uint256)) allowed;
5 	
6 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
7     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8 
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns  (bool success);
14 
15     function approve(address _spender, uint256 _value) returns (bool success);
16 
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18 	
19 }
20 
21 contract DPNToken is Token {
22 
23    string public name;                   
24     uint8 public decimals;      
25     string public symbol;
26     string public version = '0.1';
27 
28     function DPNToken() {
29         totalSupply = 1000000000000000000;
30         balances[msg.sender] = totalSupply;
31         name = "DIPNetwork";
32         decimals = 8;
33         symbol = "DPN";
34     }
35 
36 	function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39 
40     function transfer(address _to, uint256 _value) returns (bool success) {
41         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         require(balances[_from] >= _value && allowed[_from][msg.sender] >=  _value && balances[_to] + _value > balances[_to]);
51         balances[_to] += _value;
52         balances[_from] -= _value;
53         allowed[_from][msg.sender] -= _value;
54         Transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value) returns (bool success)   
59     {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
66         return allowed[_owner][_spender];
67     }
68 }