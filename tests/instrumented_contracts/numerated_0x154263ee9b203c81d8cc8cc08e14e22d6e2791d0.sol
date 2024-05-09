1 pragma solidity 0.4.21;
2 
3 
4 contract Token {
5 
6     mapping (address => uint) balances;
7     mapping (address => mapping (address => uint)) allowed;
8     uint public totalSupply;
9 
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 
13     function transfer(address _to, uint _value) public returns (bool) {
14         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
15             balances[msg.sender] -= _value;
16             balances[_to] += _value;
17             emit Transfer(msg.sender, _to, _value);
18             return true;
19         } else { return false; }
20     }
21 
22     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
23         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
24             balances[_to] += _value;
25             balances[_from] -= _value;
26             allowed[_from][msg.sender] -= _value;
27             emit Transfer(_from, _to, _value);
28             return true;
29         } else { return false; }
30     }
31 
32     function balanceOf(address _owner) constant public returns (uint) {
33         return balances[_owner];
34     }
35 
36     function approve(address _spender, uint _value) public returns (bool) {
37         allowed[msg.sender][_spender] = _value;
38         emit Approval(msg.sender, _spender, _value);
39         return true;
40     }
41 
42     function allowance(address _owner, address _spender) constant public returns (uint) {
43         return allowed[_owner][_spender];
44     }
45 
46     
47 }
48 
49 contract ParisToken is Token {
50 
51     uint public totalSupply = 1*10**27;
52     uint8 constant public decimals = 18;
53     string constant public name = "ParisToken";
54     string constant public symbol = "PT";
55     uint constant MAX_UINT = 2**256 - 1;
56 
57     function ParisToken() public {
58         balances[msg.sender] = totalSupply;
59         emit Transfer(address(0), msg.sender, totalSupply);
60     }
61 
62     function transferFrom(address _from, address _to, uint _value)
63         public
64         returns (bool)
65     {
66         uint allowance = allowed[_from][msg.sender];
67         if (balances[_from] >= _value
68             && allowance >= _value
69             && balances[_to] + _value >= balances[_to]
70         ) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             if (allowance < MAX_UINT) {
74                 allowed[_from][msg.sender] -= _value;
75             }
76             emit Transfer(_from, _to, _value);
77             return true;
78         } else {
79             return false;
80         }
81     }
82 }