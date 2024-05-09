1 pragma solidity 0.5.4;
2 
3 
4 contract BLINKToken {
5     // Override due to ERC20 specification requirement
6     // solhint-disable-next-line const-name-snakecase
7     uint8 public constant decimals = 18;
8 
9     // Override due to ERC20 specification requirement
10     // solhint-disable-next-line const-name-snakecase
11     string public constant name = "BLOCKMASON LINK TOKEN";
12 
13     // Override due to ERC20 specification requirement
14     // solhint-disable-next-line const-name-snakecase
15     string public constant symbol = "BLINK";
16 
17     bool public mintingFinished = false;
18     address public owner;
19     uint256 public totalSupply;
20 
21     mapping (address => mapping (address => uint256)) private allowed;
22     mapping (address => uint256) private balances;
23 
24     event Approval(address indexed tokenholder, address indexed spender, uint256 value);
25     event Mint(address indexed to, uint256 amount);
26     event MintFinished();
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     function () external payable {
35         revert();
36     }
37 
38     function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {
39         return allowed[_tokenholder][_spender];
40     }
41 
42     function approve(address _spender, uint256 _value) public returns (bool) {
43         require(_spender != address(0));
44         require(_spender != msg.sender);
45 
46         allowed[msg.sender][_spender] = _value;
47 
48         emit Approval(msg.sender, _spender, _value);
49 
50         return true;
51     }
52 
53     function balanceOf(address _tokenholder) public view returns (uint256 balance) {
54         return balances[_tokenholder];
55     }
56 
57     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
58         require(_spender != address(0));
59         require(_spender != msg.sender);
60 
61         if (allowed[msg.sender][_spender] <= _subtractedValue) {
62             allowed[msg.sender][_spender] = 0;
63         } else {
64             allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;
65         }
66 
67         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
68 
69         return true;
70     }
71 
72     function finishMinting() public returns (bool) {
73         require(msg.sender == owner);
74         require(!mintingFinished);
75 
76         mintingFinished = true;
77 
78         emit MintFinished();
79 
80         return true;
81     }
82 
83     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
84         require(_spender != address(0));
85         require(_spender != msg.sender);
86         require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);
87 
88         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
89 
90         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
91 
92         return true;
93     }
94 
95     // Override for consistency with #transfer()
96     // solhint-disable-next-line no-simple-event-func-name
97     function mint(address _to, uint256 _amount) public returns (bool) {
98         require(msg.sender == owner);
99         require(!mintingFinished);
100         require(_to != address(0));
101         require(_to != address(this));
102         require(totalSupply <= totalSupply + _amount);
103         require(balances[_to] <= balances[_to] + _amount);
104 
105         totalSupply = totalSupply + _amount;
106         balances[_to] = balances[_to] + _amount;
107 
108         emit Mint(_to, _amount);
109         emit Transfer(address(0), _to, _amount);
110 
111         return true;
112     }
113 
114     // Override due to ERC20 specification requirement
115     // solhint-disable-next-line no-simple-event-func-name
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != msg.sender);
118         require(_to != address(0));
119         require(_to != address(this));
120         require(balances[msg.sender] - _value <= balances[msg.sender]);
121         require(balances[_to] <= balances[_to] + _value);
122         require(_value <= transferableTokens(msg.sender));
123 
124         balances[msg.sender] = balances[msg.sender] - _value;
125         balances[_to] = balances[_to] + _value;
126 
127         emit Transfer(msg.sender, _to, _value);
128 
129         return true;
130     }
131 
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133         require(_from != address(0));
134         require(_from != address(this));
135         require(_to != _from);
136         require(_to != address(0));
137         require(_to != address(this));
138         require(_value <= transferableTokens(_from));
139         require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);
140         require(balances[_from] - _value <= balances[_from]);
141         require(balances[_to] <= balances[_to] + _value);
142 
143         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
144         balances[_from] = balances[_from] - _value;
145         balances[_to] = balances[_to] + _value;
146 
147         emit Transfer(_from, _to, _value);
148 
149         return true;
150     }
151 
152     function transferOwnership(address _newOwner) public {
153         require(msg.sender == owner);
154         require(_newOwner != address(0));
155         require(_newOwner != address(this));
156         require(_newOwner != owner);
157 
158         address previousOwner = owner;
159         owner = _newOwner;
160 
161         emit OwnershipTransferred(previousOwner, _newOwner);
162     }
163 
164     function transferableTokens(address holder) public view returns (uint256) {
165         if (mintingFinished) {
166             return balanceOf(holder);
167         }
168         return 0;
169     }
170 }