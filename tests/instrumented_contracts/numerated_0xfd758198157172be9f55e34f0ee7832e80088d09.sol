1 pragma solidity ^0.4.21;
2 
3 contract BasicToken {
4     uint256 public totalSupply;
5     bool public allowTransfer;
6 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10     function approve(address _spender, uint256 _value) returns (bool success);
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15     event Burn(address indexed burner, uint256 value);
16 }
17 
18 
19 contract StandardToken is BasicToken {
20 
21     function transfer(address _to, uint256 _value) returns (bool success) {
22         require(allowTransfer);
23         require(balances[msg.sender] >= _value);
24         balances[msg.sender] -= _value;
25         balances[_to] += _value;
26         Transfer(msg.sender, _to, _value);
27         return true;
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
31         require(allowTransfer);
32         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
33         balances[_to] += _value;
34         balances[_from] -= _value;
35         allowed[_from][msg.sender] -= _value;
36         Transfer(_from, _to, _value);
37         return true;
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         require(allowTransfer);
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52         return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 
60 contract Token is StandardToken {
61 
62     string public name = "BlockStorage";
63     uint8 public decimals = 18;
64     string public symbol = "BLOCKS";
65     string public version = "2.1";
66     address public mintableAddress;
67 
68     function Token(address sale_address) {
69         balances[msg.sender] = 0;
70         totalSupply = 0;
71         name = name;
72         decimals = decimals;
73         symbol = symbol;
74         mintableAddress = sale_address;
75         allowTransfer = true;
76         createTokens();
77     }
78 
79     // creates all tokens 180 millions
80     // this address will hold all tokens
81     // all community contrubutions coins will be taken from this address
82     function createTokens() internal {
83         uint256 total = 180000000000000000000000000;
84         balances[this] = total;
85         totalSupply = total;
86     }
87 
88     function changeTransfer(bool allowed) external {
89         require(msg.sender == mintableAddress);
90         allowTransfer = allowed;
91     }
92 
93     function mintToken(address to, uint256 amount) external returns (bool success) {
94         require(msg.sender == mintableAddress);
95         require(balances[this] >= amount);
96         balances[this] -= amount;
97         balances[to] += amount;
98         Transfer(this, to, amount);
99         return true;
100     }
101 
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105 
106         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
107         return true;
108     }
109 
110     function burn(uint256 _value) public {
111         _burn(msg.sender, _value);
112     }
113 
114     function _burn(address _who, uint256 _value) internal {
115         require(_value <= balances[_who]);
116         // no need to require value <= totalSupply, since that would imply the
117         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
118 
119         balances[_who] -= _value;
120         totalSupply -= _value;
121         Burn(_who, _value);
122         Transfer(_who, address(0), _value);
123 
124     }
125 
126 }