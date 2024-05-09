1 pragma solidity ^0.4.25;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract CarbCorpToken {
6     string public version = '0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     address public owner;
11     uint256 public _totalSupply;
12 
13     mapping (address => uint256) public balances;
14     mapping (address => mapping (address => uint256)) public allowances;
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Burn(address indexed from, uint256 value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     function CarbCorpToken() public {
21         balances[msg.sender] = 10000000000;
22         _totalSupply = 10000000000;
23         name = 'CarbShare';
24         symbol = 'eCARB';
25         decimals = 8;
26         owner = msg.sender;
27     }
28 
29     function balanceOf(address _owner) public constant returns (uint256 balance) {
30         return balances[_owner];
31     }
32 
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
34         return allowances[_owner][_spender];
35     }
36 
37     function totalSupply() public constant returns (uint256 supply) {
38         return _totalSupply;
39     }
40 
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         if (_to == 0x0) return false;
43         if (balances[msg.sender] < _value) return false;
44         if (balances[_to] + _value < balances[_to]) return false;
45         balances[msg.sender] -= _value;
46         balances[_to] += _value;
47         Transfer(msg.sender, _to, _value);
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) public returns (bool success) {
52         allowances[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
58         tokenRecipient spender = tokenRecipient(_spender);
59         if (approve(_spender, _value)) {
60             spender.receiveApproval(msg.sender, _value, this, _extraData);
61             return true;
62         }
63     }        
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         if (_to == 0x0) return false;
67         if (balances[_from] < _value) return false;
68         if (balances[_to] + _value < balances[_to]) return false;
69         if (_value > allowances[_from][msg.sender]) return false;
70         balances[_from] -= _value;
71         balances[_to] += _value;
72         allowances[_from][msg.sender] -= _value;
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function burn(uint256 _value) public returns (bool success) {
78         if (balances[msg.sender] < _value) return false;
79         balances[msg.sender] -= _value;
80         _totalSupply -= _value;
81         Burn(msg.sender, _value);
82         return true;
83     }
84 
85     function burnFrom(address _from, uint256 _value) public returns (bool success) {
86         if (balances[_from] < _value) return false;
87         if (_value > allowances[_from][msg.sender]) return false;
88         balances[_from] -= _value;
89         _totalSupply -= _value;
90         Burn(_from, _value);
91         return true;
92     }
93 }