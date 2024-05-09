1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
4 
5 contract owned {
6     address public owner;
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 contract Token {
23     function totalSupply() public constant returns (uint256 supply);
24 
25     function balanceOf(address _owner) public constant returns (uint256 balance);
26 
27     function transferTo(address _to, uint256 _value) public returns (bool);
28 
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
30 
31     function approve(address _spender, uint256 _value) public returns (bool success);
32 
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36 
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39     event Burn(address indexed _burner, uint256 _value);
40 }
41 
42 contract StdToken is Token {
43     mapping(address => uint256) balances;
44     mapping(address => mapping(address => uint256)) allowed;
45     uint public supply;
46 
47     function _transfer(address _from, address _to, uint _value) internal {
48         require(_to != 0x0);
49         require(balances[_from] >= _value);
50         require(balances[_to] + _value >= balances[_to]);
51         uint previousBalances = balances[_from] + balances[_to];
52         balances[_from] -= _value;
53         balances[_to] += _value;
54         emit Transfer(_from, _to, _value);
55         assert(balances[_from] + balances[_to] == previousBalances);
56     }
57 
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         _transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferTo(address _to, uint256 _value) public returns (bool) {
64         _transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69         _transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function totalSupply() public constant returns (uint256) {
74         return supply;
75     }
76 
77     function balanceOf(address _owner) public constant returns (uint256) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool) {
82         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
83 
84         allowed[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86 
87         return true;
88     }
89 
90     function _burn(address _burner, uint256 _value) internal returns (bool) {
91         require(_value > 0);
92         require(balances[_burner] > 0);
93         balances[_burner] -= _value;
94         supply -= _value;
95         emit Burn(_burner, _value);
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) public constant returns (uint256) {
100         return allowed[_owner][_spender];
101     }
102 }
103 
104 contract RVG is owned, StdToken {
105 
106     string public name = "Revolution Global";
107     string public symbol = "RVG";
108     string public website = "www.rvgtoken.io";
109     uint public decimals = 18;
110 
111     uint256 public totalSupplied;
112     uint256 public totalBurned;
113 
114     constructor(uint256 _totalSupply) public {
115         supply = _totalSupply * (1 ether / 1 wei);
116         totalBurned = 0;
117         totalSupplied = 0;
118         balances[address(this)] = supply;
119     }
120 
121     function transferTo(address _to, uint256 _value) public onlyOwner returns (bool) {
122         totalSupplied += _value;
123         _transfer(address(this), _to, _value);
124         return true;
125     }
126 
127     function burn() public onlyOwner returns (bool) {
128         uint256 remainBalance = supply - totalSupplied;
129         uint256 burnAmount = remainBalance / 10;
130         totalBurned += burnAmount;
131         _burn(address(this), burnAmount);
132         return true;
133     }
134 
135     function burnByValue(uint256 _value) public onlyOwner returns (bool) {
136         totalBurned += _value;
137         _burn(address(this), _value);
138         return true;
139     }
140 }