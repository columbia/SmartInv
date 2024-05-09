1 pragma solidity 0.4.11;
2 
3 contract Token {
4     function transfer(address to, uint256 value) returns (bool success);
5     function transferFrom(address from, address to, uint256 value) returns (bool success);
6     function approve(address spender, uint256 value) returns (bool success);
7 
8     function totalSupply() constant returns (uint256 supply) {}
9     function balanceOf(address owner) constant returns (uint256 balance);
10     function allowance(address owner, address spender) constant returns (uint256 remaining);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 contract WOCoinToken is Token {
18 
19     mapping (address => uint256) balances;
20     mapping (address => mapping (address => uint256)) allowed;
21     uint256 public totalSupply;
22 
23     string constant public name = "WOC Global Foundation Limited";
24     string constant public symbol = "WOC";
25     uint8 constant public decimals = 18;
26 
27     function WOCoinToken()
28         public
29     {
30         totalSupply = 980000000 * 10**18;
31         balances[msg.sender] = totalSupply;
32     }
33 
34     function transfer(address _to, uint256 _value)
35         public
36         returns (bool)
37     {
38         if (balances[msg.sender] < _value) {
39             throw;
40         }
41         balances[msg.sender] -= _value;
42         balances[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value)
48         public
49         returns (bool)
50     {
51         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
52             throw;
53         }
54         balances[_to] += _value;
55         balances[_from] -= _value;
56         allowed[_from][msg.sender] -= _value;
57         Transfer(_from, _to, _value);
58         return true;
59     }
60 
61     function approve(address _spender, uint256 _value)
62         public
63         returns (bool)
64     {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender)
71         constant
72         public
73         returns (uint256)
74     {
75         return allowed[_owner][_spender];
76     }
77 
78     function balanceOf(address _owner)
79         constant
80         public
81         returns (uint256)
82     {
83         return balances[_owner];
84     }
85 }