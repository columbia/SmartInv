1 pragma solidity 0.4.23;
2 
3 contract Token {
4 
5     function balanceOf(address _owner) public view returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint remaining);
10     
11     //event
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     event Approval(address indexed _owner, address indexed _spender, uint _value);
14 }
15 
16 contract RegularToken is Token {
17 
18     function transfer(address _to, uint _value) public returns (bool) {
19         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             emit Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             emit Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) public view returns (uint) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint _value) public returns (bool) {
42         allowed[msg.sender][_spender] = _value;
43         emit Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) public view returns (uint) {
48         return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint) balances;
52     mapping (address => mapping (address => uint)) allowed;
53     uint public totalSupply;
54 }
55 
56 contract UnboundedRegularToken is RegularToken {
57 
58     uint constant MAX_UINT = 2**256 - 1;
59     
60     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
61         uint allowance = allowed[_from][msg.sender];
62         if (balances[_from] >= _value
63             && allowance >= _value
64             && balances[_to] + _value >= balances[_to]
65         ) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             if (allowance < MAX_UINT) {
69                 allowed[_from][msg.sender] -= _value;
70             }
71             emit Transfer(_from, _to, _value);
72             return true;
73         } else {
74             return false;
75         }
76     }
77 }
78 
79 contract DHToken is UnboundedRegularToken {
80 
81     uint public constant totalSupply = 525*10**25;
82     uint8 public constant decimals = 18;
83     string public constant name = "DHToken";
84     string public constant symbol = "DHT";
85 
86     constructor() public {
87         balances[msg.sender] = totalSupply;
88         emit Transfer(address(0), msg.sender, totalSupply);
89     }
90 }