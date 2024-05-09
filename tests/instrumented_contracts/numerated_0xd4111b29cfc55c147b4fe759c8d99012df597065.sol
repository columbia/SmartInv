1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7 	constructor() public {
8         owner = msg.sender;
9     }
10     
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19     
20 }
21 
22 contract Pausable is Ownable {
23     event Pause();
24     event Unpause();
25 
26     bool public paused = false;
27 
28     modifier whenNotPaused() {
29         require(!paused);
30         _;
31     }
32 
33     modifier whenPaused() {
34         require(paused);
35         _;
36     }
37 
38     function pause() onlyOwner whenNotPaused public {
39         paused = true;
40         emit Pause();
41     }
42 
43     function unpause() onlyOwner whenPaused public {
44         paused = false;
45         emit Unpause();
46     }
47     
48 }
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
51 
52 contract WHDCToken is Pausable{
53     
54     string public name;
55     string public symbol;
56     uint8 public decimals = 18;
57     uint256 public totalSupply;
58 
59     mapping (address => uint256) public balanceOf;
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     event Burn(address indexed from, uint256 value);
65 
66     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
67         totalSupply = initialSupply * 10 ** uint256(decimals);
68         balanceOf[msg.sender] = totalSupply;
69         name = tokenName;
70         symbol = tokenSymbol;
71     }
72 
73     function _transfer(address _from, address _to, uint _value) internal {
74         require(_to != 0x0);
75         require(balanceOf[_from] >= _value);
76         require(balanceOf[_to] + _value > balanceOf[_to]);
77         uint previousBalances = balanceOf[_from] + balanceOf[_to];
78         balanceOf[_from] -= _value;
79         balanceOf[_to] += _value;
80         emit Transfer(_from, _to, _value);
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]); 
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     function approve(address _spender, uint256 _value) public
96         returns (bool success) {
97         allowance[msg.sender][_spender] = _value;
98         return true;
99     }
100 
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108 
109     function burn(uint256 _value) public returns (bool success) {
110         require(balanceOf[msg.sender] >= _value);
111         balanceOf[msg.sender] -= _value;
112         totalSupply -= _value;
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116 
117     function burnFrom(address _from, uint256 _value) public returns (bool success) {
118         require(balanceOf[_from] >= _value);
119         require(_value <= allowance[_from][msg.sender]);
120         balanceOf[_from] -= _value;
121         allowance[_from][msg.sender] -= _value;
122         totalSupply -= _value;
123         emit Burn(_from, _value);
124         return true;
125     }
126     
127 }