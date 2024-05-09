1 pragma solidity 0.4.23;
2 
3 contract ERC20 {
4     
5     //functions
6     function balanceOf(address _owner) public view returns (uint balance);
7     function transfer(address _to, uint _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
9     function approve(address _spender, uint _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public view returns (uint remaining);
11     function burn(uint _value) public returns (bool success);
12     
13     //events
14     event Transfer(address indexed _from, address indexed _to, uint _value);
15     event Approval(address indexed _owner, address indexed _spender, uint _value);
16     event Burn(address indexed _from, uint _value);
17 }
18 
19 contract RegularToken is ERC20 {
20 
21     function transfer(address _to, uint _value) public returns (bool) {
22         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             emit Transfer(msg.sender, _to, _value);
26             return true;
27         } else { return false; }
28     }
29 
30     function burn(uint _value) public returns (bool success) {
31         if (balances[msg.sender] >= _value) {
32             balances[msg.sender] -= _value;
33             totalSupply -= _value;
34             emit Burn(msg.sender, _value);
35             return true;
36         } else { return false; }
37     }
38     
39     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             emit Transfer(_from, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function balanceOf(address _owner) public view returns (uint) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint _value) public returns (bool) {
54         allowed[msg.sender][_spender] = _value;
55         emit Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) public view returns (uint) {
60         return allowed[_owner][_spender];
61     }
62 
63     mapping (address => uint) balances;
64     mapping (address => mapping (address => uint)) allowed;
65     uint public totalSupply;
66 }
67 
68 contract UnboundedRegularToken is RegularToken {
69 
70     uint constant MAX_UINT = 2**256 - 1;
71     
72     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
73         uint allowance = allowed[_from][msg.sender];
74         if (balances[_from] >= _value
75             && allowance >= _value
76             && balances[_to] + _value >= balances[_to]
77         ) {
78             balances[_to] += _value;
79             balances[_from] -= _value;
80             if (allowance < MAX_UINT) {
81                 allowed[_from][msg.sender] -= _value;
82             }
83             emit Transfer(_from, _to, _value);
84             return true;
85         } else {
86             return false;
87         }
88     }
89 }
90 
91 contract EON is UnboundedRegularToken {
92 
93     uint8 public constant decimals = 18;
94     string public constant name = "entertainment open network";
95     string public constant symbol = "EON";
96 
97     constructor() public {
98         totalSupply = 21*10**26;
99         balances[msg.sender] = totalSupply;
100         emit Transfer(address(0), msg.sender, totalSupply);
101     }
102 }