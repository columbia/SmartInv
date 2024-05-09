1 pragma solidity ^0.4.11;
2 
3 contract Token {
4     function transfer(address to, uint256 value) returns (bool success);
5     function transferFrom(address from, address to, uint256 value) returns (bool success);
6     function approve(address spender, uint256 value) returns (bool success);
7 
8     function totalSupply() constant returns (uint256 totalSupply) {}
9     function balanceOf(address owner) constant returns (uint256 balance);
10     function allowance(address owner, address spender) constant returns (uint256 remaining);
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
26         if (balances[msg.sender] < _value) {
27             throw;
28         }
29         balances[msg.sender] -= _value;
30         balances[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value)
36         public
37         returns (bool)
38     {
39         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
40             throw;
41         }
42         balances[_to] += _value;
43         balances[_from] -= _value;
44         allowed[_from][msg.sender] -= _value;
45         Transfer(_from, _to, _value);
46         return true;
47     }
48 
49     function approve(address _spender, uint256 _value)
50         public
51         returns (bool)
52     {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     function allowance(address _owner, address _spender)
59         constant
60         public
61         returns (uint256)
62     {
63         return allowed[_owner][_spender];
64     }
65 
66     function balanceOf(address _owner)
67         constant
68         public
69         returns (uint256)
70     {
71         return balances[_owner];
72     }
73 }
74 
75 contract BacchusToken is StandardToken {
76 
77     string constant public name = "Bacchus Token";
78     string constant public symbol = "BCCS";
79     uint8 constant public decimals = 18;
80 
81     function BacchusToken()
82         public
83     {
84         totalSupply = 1000000000 * 10**18;
85         balances[msg.sender] = totalSupply;
86     }
87 }