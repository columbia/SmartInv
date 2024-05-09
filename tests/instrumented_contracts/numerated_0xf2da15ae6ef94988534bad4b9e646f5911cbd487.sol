1 /**
2  *Submitted for verification at Etherscan.io on 2020-02-27
3 */
4 
5 pragma solidity 0.4.19;
6 
7 
8 contract RegularToken{
9 
10     function transfer(address _to, uint _value) public returns (bool) {
11         //Default assumes totalSupply can't be over max (2^256 - 1).
12         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
13             balances[msg.sender] -= _value;
14             balances[_to] += _value;
15             Transfer(msg.sender, _to, _value);
16             return true;
17         } else { revert(); }
18     }
19 
20     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
21         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
22             balances[_to] += _value;
23             balances[_from] -= _value;
24             allowed[_from][msg.sender] -= _value;
25             Transfer(_from, _to, _value);
26             return true;
27         } else { revert(); }
28     }
29 
30     function balanceOf(address _owner) constant public returns (uint) {
31         return balances[_owner];
32     }
33 
34     function approve(address _spender, uint _value) public returns (bool) {
35         allowed[msg.sender][_spender] = _value;
36         Approval(msg.sender, _spender, _value);
37         return true;
38     }
39 
40     function allowance(address _owner, address _spender) constant public returns (uint) {
41         return allowed[_owner][_spender];
42     }
43 
44 
45     mapping (address => uint) balances;
46     mapping (address => mapping (address => uint)) allowed;
47     uint public totalSupply;
48 
49     event Transfer(address indexed _from, address indexed _to, uint _value);
50     event Approval(address indexed _owner, address indexed _spender, uint _value);
51 }
52 
53 contract UnboundedRegularToken is RegularToken {
54 
55     uint constant MAX_UINT = 2**256 - 1;
56     
57     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
58     /// @param _from Address to transfer from.
59     /// @param _to Address to transfer to.
60     /// @param _value Amount to transfer.
61     /// @return Success of transfer.
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
76             Transfer(_from, _to, _value);
77             return true;
78         } else {
79             revert();
80         }
81     }
82 }
83 
84 contract FAMEToken is UnboundedRegularToken {
85 
86     uint8 constant public decimals = 8;
87     string constant public name = "FAME";
88     string constant public symbol = "FAME";
89 
90     function FAMEToken() public {
91         totalSupply = 100000000 * 10 ** uint256(decimals);
92         balances[msg.sender] = totalSupply;
93         Transfer(address(0), msg.sender, totalSupply);
94     }
95 }