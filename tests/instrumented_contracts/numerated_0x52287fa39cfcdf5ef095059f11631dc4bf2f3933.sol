1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.0;
4 
5 interface IERC20 {
6     function balanceOf(address who) external view returns (uint256);
7     function transfer(address to, uint256 value) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11 }
12 
13 contract Ownable {
14 
15   address private owner;
16 
17   event NewOwner(address oldOwner, address newOwner);
18 
19   constructor() {
20     owner = msg.sender;
21   }
22 
23   modifier onlyOwner() {
24     require(isOwner(), "Ownable: caller is not the owner");
25     _;
26   }
27 
28   function contractOwner() external view returns (address) {
29     return owner;
30   }
31 
32   function isOwner() public view returns (bool) {
33     return msg.sender == owner;
34   }
35 
36   function transferOwnership(address _newOwner) external onlyOwner {
37     require(_newOwner != address(0), 'Ownable: address is not valid');
38     owner = _newOwner;
39     emit NewOwner(msg.sender, _newOwner);
40   } 
41 }
42 
43 contract InitialD is IERC20, Ownable {
44 
45     string public name;
46     string public symbol;
47     uint8 public decimals;
48     uint256 public totalSupply;
49 
50     mapping (address => uint256) internal _balances;
51     mapping (address => mapping (address => uint256)) internal _allowed;
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 
56     constructor () {
57         symbol = "STT";
58         name = "Smart Trade Token";
59         decimals = 4;
60         totalSupply = 10000000000000;
61         _balances[msg.sender] = 1000000000000;
62     }
63 
64     function transfer(
65         address _to, 
66         uint256 _value
67     ) external override returns (bool) {
68         require(_to != address(0), 'ERC20: to address is not valid');
69         require(_value <= _balances[msg.sender], 'ERC20: insufficient balance');
70 
71         _balances[msg.sender] = _balances[msg.sender] - _value;
72         _balances[_to] = _balances[_to] + _value;
73         
74         emit Transfer(msg.sender, _to, _value);
75         
76         return true;
77     }
78 
79    function balanceOf(
80        address _owner
81     ) external override view returns (uint256 balance) {
82         return _balances[_owner];
83     }
84 
85     function approve(
86        address _spender, 
87        uint256 _value
88     ) external override returns (bool) {
89         _allowed[msg.sender][_spender] = _value;
90         
91         emit Approval(msg.sender, _spender, _value);
92         
93         return true;
94    }
95 
96    function transferFrom(
97         address _from, 
98         address _to, 
99         uint256 _value
100     ) external override returns (bool) {
101         require(_from != address(0), 'ERC20: from address is not valid');
102         require(_to != address(0), 'ERC20: to address is not valid');
103         require(_value <= _balances[_from], 'ERC20: insufficient balance');
104         require(_value <= _allowed[_from][msg.sender], 'ERC20: transfer from value not allowed');
105 
106         _allowed[_from][msg.sender] = _allowed[_from][msg.sender] - _value;
107         _balances[_from] = _balances[_from] - _value;
108         _balances[_to] = _balances[_to] + _value;
109         
110         emit Transfer(_from, _to, _value);
111         
112         return true;
113    }
114 
115     function allowance(
116         address _owner, 
117         address _spender
118     ) external override view returns (uint256) {
119         return _allowed[_owner][_spender];
120     }
121 
122     function increaseApproval(
123         address _spender, 
124         uint256 _addedValue
125     ) external returns (bool) {
126         _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender] + _addedValue;
127 
128         emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
129         
130         return true;
131     }
132 
133     function decreaseApproval(
134         address _spender, 
135         uint256 _subtractedValue
136     ) external returns (bool) {
137         uint256 oldValue = _allowed[msg.sender][_spender];
138         
139         if (_subtractedValue > oldValue) {
140             _allowed[msg.sender][_spender] = 0;
141         } else {
142             _allowed[msg.sender][_spender] = oldValue - _subtractedValue;
143         }
144         
145         emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
146         
147         return true;
148    }
149 
150     function mintTo(
151         address _to,
152         uint256 _amount
153     ) external onlyOwner returns (bool) {
154         require(_to != address(0), 'ERC20: to address is not valid');
155 
156         _balances[_to] = _balances[_to] + _amount;
157         totalSupply = totalSupply + _amount;
158 
159         emit Transfer(address(0), _to, _amount);
160 
161         return true;
162     }
163 
164     function burn(
165         uint256 _amount
166     ) external returns (bool) {
167         require(_balances[msg.sender] >= _amount, 'ERC20: insufficient balance');
168 
169         _balances[msg.sender] = _balances[msg.sender] - _amount;
170         totalSupply = totalSupply - _amount;
171 
172         emit Transfer(msg.sender, address(0), _amount);
173 
174         return true;
175     }
176 
177     function burnFrom(
178         address _from,
179         uint256 _amount
180     ) external returns (bool) {
181         require(_from != address(0), 'ERC20: from address is not valid');
182         require(_balances[_from] >= _amount, 'ERC20: insufficient balance');
183         require(_amount <= _allowed[_from][msg.sender], 'ERC20: burn from value not allowed');
184         
185         _allowed[_from][msg.sender] = _allowed[_from][msg.sender] - _amount;
186         _balances[_from] = _balances[_from] - _amount;
187         totalSupply = totalSupply - _amount;
188 
189         emit Transfer(_from, address(0), _amount);
190 
191         return true;
192     }
193 
194 }