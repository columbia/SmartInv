1 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
2 
3 contract Socrates {
4     string public version = '0.1';
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     address public owner;
9     uint256 public _totalSupply;
10 
11     mapping (address => uint256) public balances;
12     mapping (address => mapping (address => uint256)) public allowances;
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Burn(address indexed from, uint256 value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     function Socrates() {
19         balances[msg.sender] = 46900000000000000;
20         _totalSupply = 46900000000000000;
21         name = 'Socrates';
22         symbol = 'SAPIS';
23         decimals = 8;
24         owner = msg.sender;
25     }
26 
27     function balanceOf(address _owner) constant returns (uint256 balance) {
28         return balances[_owner];
29     }
30 
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
32         return allowances[_owner][_spender];
33     }
34 
35     function totalSupply() constant returns (uint256 totalSupply) {
36         return _totalSupply;
37     }
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40         if (_to == 0x0) return false;
41         if (balances[msg.sender] < _value) return false;
42         if (balances[_to] + _value < balances[_to]) return false;
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49     function approve(address _spender, uint256 _value) returns (bool success) {
50         allowances[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
56         tokenRecipient spender = tokenRecipient(_spender);
57         if (approve(_spender, _value)) {
58             spender.receiveApproval(msg.sender, _value, this, _extraData);
59             return true;
60         }
61     }        
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         if (_to == 0x0) return false;
65         if (balances[_from] < _value) return false;
66         if (balances[_to] + _value < balances[_to]) return false;
67         if (_value > allowances[_from][msg.sender]) return false;
68         balances[_from] -= _value;
69         balances[_to] += _value;
70         allowances[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function burn(uint256 _value) returns (bool success) {
76         if (balances[msg.sender] < _value) return false;
77         balances[msg.sender] -= _value;
78         _totalSupply -= _value;
79         Burn(msg.sender, _value);
80         return true;
81     }
82 
83     function burnFrom(address _from, uint256 _value) returns (bool success) {
84         if (balances[_from] < _value) return false;
85         if (_value > allowances[_from][msg.sender]) return false;
86         balances[_from] -= _value;
87         _totalSupply -= _value;
88         Burn(_from, _value);
89         return true;
90     }
91 }