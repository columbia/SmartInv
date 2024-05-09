1 /**
2  *Submitted for verification at Etherscan.io on 2017-07-18
3 */
4 
5 pragma solidity ^0.4.11;
6 
7 contract Token {
8     function transfer(address to, uint256 value) returns (bool success);
9     function transferFrom(address from, address to, uint256 value) returns (bool success);
10     function approve(address spender, uint256 value) returns (bool success);
11 
12     function totalSupply() constant returns (uint256 totalSupply) {}
13     function balanceOf(address owner) constant returns (uint256 balance);
14     function allowance(address owner, address spender) constant returns (uint256 remaining);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 contract StandardToken is Token {
21 
22     mapping (address => uint256) balances;
23     mapping (address => mapping (address => uint256)) allowed;
24     uint256 public totalSupply;
25 
26     function transfer(address _to, uint256 _value)
27         public
28         returns (bool)
29     {
30         if (balances[msg.sender] < _value) {
31             throw;
32         }
33         balances[msg.sender] -= _value;
34         balances[_to] += _value;
35         Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value)
40         public
41         returns (bool)
42     {
43         if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
44             throw;
45         }
46         balances[_to] += _value;
47         balances[_from] -= _value;
48         allowed[_from][msg.sender] -= _value;
49         Transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function approve(address _spender, uint256 _value)
54         public
55         returns (bool)
56     {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender)
63         constant
64         public
65         returns (uint256)
66     {
67         return allowed[_owner][_spender];
68     }
69 
70     function balanceOf(address _owner)
71         constant
72         public
73         returns (uint256)
74     {
75         return balances[_owner];
76     }
77 }
78 
79 contract VNCToken is StandardToken {
80 
81     string constant public name = "VNC Token";
82     string constant public symbol = "VNC";
83     uint8 constant public decimals = 18;
84 
85     function VNCToken()
86         public
87     {
88         totalSupply = 661000000 * 10**18; 
89         balances[msg.sender] = totalSupply;
90     }
91 }