1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract StandardTokenInterface {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8     function balanceOf(address _owner) public view returns (uint256 balance);
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11     function approve(address _spender, uint256 _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 contract StandardToken is StandardTokenInterface{
18     
19     mapping(address => uint256) public balances;
20     mapping(address => mapping(address => uint256)) internal allowed;
21     
22     function balanceOf(address _owner) public view returns (uint256 balance) {
23         
24         balance = balances[_owner];
25     }
26     
27     function transfer(address _to, uint256 _value) public returns (bool success) {
28         
29         require(_to != address(0x0));
30         require(balances[msg.sender] >= _value);
31         require(balances[_to] + _value >= balances[_to]);
32         
33         uint256 previous = balances[msg.sender] + balances[_to];
34         balances[msg.sender] -= _value;
35         balances[_to] += _value;
36         assert(balances[msg.sender] + balances[_to] == previous);
37         emit Transfer(msg.sender,_to,_value);
38         
39         success = true;
40     }
41     
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         
44         require(_from != address(0x0));
45         require(_to != address(0x0));
46         require(balances[_from] >= _value);
47         require(allowed[_from][msg.sender] >= _value);
48         require(balances[_to] + _value >= balances[_to]);
49         
50         balances[_from] -= _value;
51         balances[_to] += _value;
52         emit Transfer(_from,_to,_value);
53         
54         success = true;
55     }
56     
57     function approve(address _spender, uint256 _value) public returns (bool success) {
58         
59         require(_spender != address(0x0));
60         require(balances[msg.sender] >= _value);
61         
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender,_spender,_value);
64         success = true;
65     }
66     
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining){
68         
69         remaining = allowed[_owner][_spender];
70     }
71 }
72 
73 contract CustomToken is StandardToken{
74     constructor(string memory _name,string memory _symbol,uint8 _decimals,uint256 _totalSupply) public {
75         name = _name;
76         symbol = _symbol;
77         decimals = _decimals;
78         totalSupply = _totalSupply;
79         balances[msg.sender] = totalSupply;
80     }
81 }