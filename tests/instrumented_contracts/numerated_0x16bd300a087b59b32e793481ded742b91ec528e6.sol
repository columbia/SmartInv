1 contract Token {
2 
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9 
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract StandardERC20 is Token {
15 
16     function transfer(address _to, uint256 _value) returns (bool success) {
17         if (balances[msg.sender] >= _value && _value > 0) {
18             balances[msg.sender] -= _value;
19             balances[_to] += _value;
20             emit Transfer(msg.sender, _to, _value);
21             return true;
22         } else { return false; }
23     }
24 
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
26         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
27             balances[_to] += _value;
28             balances[_from] -= _value;
29             allowed[_from][msg.sender] -= _value;
30             emit Transfer(_from, _to, _value);
31             return true;
32         } else { return false; }
33     }
34 
35     function balanceOf(address _owner) constant returns (uint256 balance) {
36         return balances[_owner];
37     }
38 
39     function approve(address _spender, uint256 _value) returns (bool success) {
40         allowed[msg.sender][_spender] = _value;
41         emit Approval(msg.sender, _spender, _value);
42         return true;
43     }
44 
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
46       return allowed[_owner][_spender];
47     }
48 
49     mapping (address => uint256) balances;
50     mapping (address => mapping (address => uint256)) allowed;
51     uint256 public totalSupply;
52 }
53 
54 contract EXM20 is StandardERC20 {
55 
56     //if ether is sent to this address, send it back.
57     function () {
58         revert();
59     }
60 
61     string public name;
62     uint8 public decimals;
63     string public symbol;
64     string public version = 'H0.1';
65 
66     function constuctor() {
67         name = "EXM20";
68         decimals = 8;
69         symbol = "EXM";
70         totalSupply = 100 * 10**uint(6) * 10**uint(decimals);
71         balances[msg.sender] = totalSupply;
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
78         return true;
79     }
80 }