1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     function transfer(address to, uint256 value) public returns (bool success);
5     function transferFrom(address from, address to, uint256 value) public returns (bool success);
6     function approve(address spender, uint256 value) public returns (bool success);
7 
8     function totalSupply() public pure returns (uint256) {}
9     function balanceOf(address owner) public constant returns (uint256 balance);
10     function allowance(address owner, address spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 contract StandardToken is Token {
17 
18     mapping (address => uint256) balances;
19     mapping (address => mapping (address => uint256)) allowed;
20     uint256 public totalSupply;
21 
22     function transfer(address _to, uint256 _value)
23         public
24         returns (bool)
25     {
26         require(balances[msg.sender] >= _value);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         Transfer(msg.sender, _to, _value);
30         return true;
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value)
34         public
35         returns (bool)
36     {
37         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
38         balances[_to] += _value;
39         balances[_from] -= _value;
40         allowed[_from][msg.sender] -= _value;
41         Transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function approve(address _spender, uint256 _value)
46         public
47         returns (bool)
48     {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender)
55         constant
56         public
57         returns (uint256)
58     {
59         return allowed[_owner][_spender];
60     }
61 
62     function balanceOf(address _owner)
63         constant
64         public
65         returns (uint256)
66     {
67         return balances[_owner];
68     }
69 }
70 
71 contract XiaoshiToken is StandardToken {
72 
73     string constant public name = "Xiaoshi Token";
74     string constant public symbol = "XSH";
75     uint8 constant public decimals = 18;
76 
77     function XiaoshiToken()
78         public
79     {
80         totalSupply = 200 * 1000000 * 10**18; // will not change
81         balances[msg.sender] = totalSupply;
82     }
83 }