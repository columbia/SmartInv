1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface
4 {
5     event Transfer(address indexed _from, address indexed _to, uint _value);
6     event Approval(address indexed _owner, address indexed _spender, uint _value);
7     
8     function totalSupply() constant public returns (uint _supply);
9     function balanceOf(address _who) constant public returns (uint _value);
10     function transfer(address _to, uint _value) public returns (bool _success);
11     function approve(address _spender, uint _value) public returns (bool _success);
12     function allowance(address _owner, address _spender) constant public returns (uint _allowance);
13     function transferFrom(address _from, address _to, uint _value) public returns (bool _success);
14 }
15 
16 contract Cashew is ERC20Interface
17 {
18     address public owner;
19     string public name;
20     uint public decimals;
21     string public symbol;
22     uint public totalSupply;
23     uint private E18 = 1000000000000000000;
24     
25     mapping (address => uint) public balanceOf;
26     mapping (address => mapping (address => uint)) public approvals;
27     
28     function Cashew() public
29     {
30         name ="Cashew";
31         decimals = 18;
32         symbol = "CSH";
33         totalSupply = 10000000000 * E18;
34         
35         owner = msg.sender;
36         
37         balanceOf[msg.sender] = totalSupply;
38     }
39     
40     function totalSupply() constant public returns (uint)
41     {
42         return totalSupply;
43     }
44     
45     function balanceOf(address _who) constant public returns (uint)
46     {
47         return balanceOf[_who];
48     }
49     
50     function transfer(address _to, uint _value) public returns (bool)
51     {
52         require(balanceOf[msg.sender] >= _value);
53         
54         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
55         balanceOf[_to] = balanceOf[_to] + _value;
56         
57         Transfer(msg.sender, _to, _value);
58         
59         return true;
60     }
61     
62     function approve(address _spender, uint _value) public returns (bool)
63     {
64         require(balanceOf[msg.sender] >= _value);
65         
66         approvals[msg.sender][_spender] = _value;
67         
68         Approval(msg.sender, _spender, _value);
69         
70         return true;
71     }
72     
73     function allowance(address _owner, address _spender) constant public returns (uint)
74     {
75         return approvals[_owner][_spender];
76     }
77     
78     function transferFrom(address _from, address _to, uint _value) public returns (bool)
79     {
80         require(balanceOf[_from] >= _value);
81         require(approvals[_from][msg.sender] >= _value);
82         
83         approvals[_from][msg.sender] = approvals[_from][msg.sender] - _value;
84         balanceOf[_from] = balanceOf[_from] - _value;
85         balanceOf[_to] = balanceOf[_to] + _value;
86         
87         Transfer(_from, _to, _value);
88         
89         return true;
90     }
91 }