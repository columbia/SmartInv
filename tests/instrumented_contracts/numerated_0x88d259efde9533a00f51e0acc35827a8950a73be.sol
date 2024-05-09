1 pragma solidity 0.4.19;
2 
3 contract Token {
4     function totalSupply() constant returns (uint supply) {}
5     function balanceOf(address _owner) constant returns (uint balance) {}
6     function transfer(address _to, uint _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
8     function approve(address _spender, uint _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract RegularToken is Token {
15 
16     function transfer(address _to, uint _value) returns (bool) {
17         //Default assumes totalSupply can't be over max (2^256 - 1).
18         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
19             balances[msg.sender] -= _value;
20             balances[_to] += _value;
21             Transfer(msg.sender, _to, _value);
22             return true;
23         } else { return false; }
24     }
25 
26     function transferFrom(address _from, address _to, uint _value) returns (bool) {
27         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
28             balances[_to] += _value;
29             balances[_from] -= _value;
30             allowed[_from][msg.sender] -= _value;
31             Transfer(_from, _to, _value);
32             return true;
33         } else { return false; }
34     }
35 
36     function balanceOf(address _owner) constant returns (uint) {
37         return balances[_owner];
38     }
39 
40     function approve(address _spender, uint _value) returns (bool) {
41         allowed[msg.sender][_spender] = _value;
42         Approval(msg.sender, _spender, _value);
43         return true;
44     }
45 
46     function allowance(address _owner, address _spender) constant returns (uint) {
47         return allowed[_owner][_spender];
48     }
49 
50     mapping (address => uint) balances;
51     mapping (address => mapping (address => uint)) allowed;
52     uint public totalSupply;
53 }
54 
55 contract UnboundedRegularToken is RegularToken {
56 
57     uint constant MAX_UINT = 2**256 - 1;
58     
59     /// @dev ERC20 交易, 修改为允许的最大值表示无限量.
60     function transferFrom(address _from, address _to, uint _value)
61         public
62         returns (bool)
63     {
64         uint allowance = allowed[_from][msg.sender];
65         if (balances[_from] >= _value
66             && allowance >= _value
67             && balances[_to] + _value >= balances[_to]
68         ) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             if (allowance < MAX_UINT) {
72                 allowed[_from][msg.sender] -= _value;
73             }
74             Transfer(_from, _to, _value);
75             return true;
76         } else {
77             return false;
78         }
79     }
80 }
81 
82 contract SendToken is UnboundedRegularToken {
83 
84     uint public totalSupply=100*10**26;  //一百亿代币
85     uint8 constant public decimals = 18;
86     string  public name;
87     string  public symbol;
88 
89     function SendToken(string _name,string _symbol) {
90         balances[msg.sender] = totalSupply;
91         name=_name;
92         symbol=_symbol;
93         Transfer(address(0), msg.sender, totalSupply);
94     }
95 }