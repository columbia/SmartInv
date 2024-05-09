1 pragma solidity ^0.4.21;
2 
3 
4 /*
5 
6 ERC20 
7 
8 Create this Token contract AFTER you already have the Sale contract created.
9 
10    Token(address sale_address)   // creates token and links the Sale contract
11 
12 @author Hunter Long
13 @repo https://github.com/hunterlong/ethereum-ico-contract
14 
15 */
16 
17 
18 contract BasicToken {
19     uint256 public totalSupply;
20     bool public allowTransfer;
21 
22     function balanceOf(address _owner) constant public returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25     function approve(address _spender, uint256 _value) public returns (bool success);
26     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 contract StandardToken is BasicToken {
33 
34     function transfer(address _to, uint256 _value) public returns (bool success) {
35         require(allowTransfer);
36         require(balances[msg.sender] >= _value);
37         balances[msg.sender] -= _value;
38         balances[_to] += _value;
39         emit Transfer(msg.sender, _to, _value);
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         require(allowTransfer);
45         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
46         balances[_to] += _value;
47         balances[_from] -= _value;
48         allowed[_from][msg.sender] -= _value;
49         emit Transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function balanceOf(address _owner) constant public returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) public returns (bool success) {
58         require(allowTransfer);
59         allowed[msg.sender][_spender] = _value;
60         emit Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66     }
67 
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70 }
71 
72 
73 contract Token is StandardToken {
74 
75     string public name = "Build Network";
76     uint8 public decimals = 18;
77     string public symbol = "XBN";
78     string public version = 'XBN 0.1';
79     address public mintableAddress;
80 
81     function Token(address sale_address) public {
82         balances[msg.sender] = 0;
83         totalSupply = 0;
84         name = name;
85         decimals = decimals;
86         symbol = symbol;
87         mintableAddress = sale_address;
88         allowTransfer = true;
89         createTokens();
90     }
91 
92     // creates all tokens 99 B
93     // this address will hold all tokens
94     // all community contrubutions coins will be taken from this address
95     function createTokens() internal {
96         uint256 total = 99000000000000000000000000000;
97         balances[this] = total;
98         totalSupply = total;
99     }
100 
101     function changeTransfer(bool allowed) external {
102         require(msg.sender == mintableAddress);
103         allowTransfer = allowed;
104     }
105 
106     function mintToken(address to, uint256 amount) external returns (bool success) {
107         require(msg.sender == mintableAddress);
108         require(balances[this] >= amount);
109         balances[this] -= amount;
110         balances[to] += amount;
111         emit Transfer(this, to, amount);
112         return true;
113     }
114 
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118 
119         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
120         return true;
121     }
122 }