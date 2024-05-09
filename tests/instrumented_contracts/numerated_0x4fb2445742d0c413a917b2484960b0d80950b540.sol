1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract SafeMath {
6     function add(uint256 x, uint256 y) pure internal returns(uint256) {
7       uint256 z = x + y;
8       assert((z >= x) && (z >= y));
9       return z;
10     }
11 
12     function subtract(uint256 x, uint256 y) pure internal returns(uint256) {
13       assert(x >= y);
14       uint256 z = x - y;
15       return z;
16     }
17 }
18 
19 contract ERC20 {
20     function totalSupply() constant public returns (uint supply);
21     function balanceOf(address _owner) constant public returns (uint256 balance);
22     function transfer(address _to, uint256 _value) public returns (bool success);
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool balance);
24     function approve(address _spender, uint256 _value) public returns (bool balance);
25     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Burn(address indexed from, uint256 value);
28 }
29 
30 contract Bible is ERC20, SafeMath {
31 
32     string public name = "Bible";      //  token name
33     string public symbol = "GIB";           //  token symbol
34     uint256 public decimals = 18;            //  token digit
35     uint256 public totalSupply = 0;
36     string public version = "1.0.0";
37     address creator = 0x0;
38     /**
39      *  0 : init, 1 : limited, 2 : running, 3 : finishing
40      */
41     uint8 public tokenStatus = 0;
42       
43     mapping (address => uint256) public balanceOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45     
46     function Bible() public {
47         creator = msg.sender;
48         tokenStatus = 2;
49         totalSupply = 11000000000 * 10 ** uint256(decimals);
50         balanceOf[msg.sender] = totalSupply;
51     }
52 
53     modifier isCreator {
54         assert(creator == msg.sender);
55         _;
56     }
57 
58     modifier isRunning {
59         assert(tokenStatus == 2);
60         _;
61     }
62 
63     modifier validAddress {
64         assert(0x0 != msg.sender);
65         _;
66     }
67 
68     function status(uint8 _status) isCreator public {
69         tokenStatus = _status;
70     }
71     
72     function getStatus() constant public returns (uint8 _status) {
73         return tokenStatus;
74     }
75     
76     function totalSupply() constant public returns (uint supply) {
77         return totalSupply;
78     }
79 
80     function balanceOf(address _owner) constant public returns (uint256 balance) {
81         return balanceOf[_owner];
82     }
83     
84     function _transfer(address _from, address _to, uint _value) isRunning validAddress internal {
85         require(balanceOf[_from] >= _value);
86         require(balanceOf[_to] + _value >= balanceOf[_to]);
87         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
88         balanceOf[_from] = SafeMath.subtract(balanceOf[_from], _value);
89         balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
90         emit Transfer(_from, _to, _value);
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93     
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98     
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105     
106     function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
107         require(_value == 0 || allowance[msg.sender][_spender] == 0);
108         allowance[msg.sender][_spender] = _value;
109         return true;
110     }
111     
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
113         tokenRecipient spender = tokenRecipient(_spender);
114         if (approve(_spender, _value)) {
115             spender.receiveApproval(msg.sender, _value, this, _extraData);
116             return true;
117         }
118     }
119     
120     function burn(uint256 _value) public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
122         balanceOf[msg.sender] -= _value;            // Subtract from the sender
123         totalSupply -= _value;                      // Updates totalSupply
124         emit Burn(msg.sender, _value);
125         return true;
126     }
127     
128     function burnFrom(address _from, uint256 _value) public returns (bool success) {
129         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
130         require(_value <= allowance[_from][msg.sender]);    // Check allowance
131         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
132         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
133         totalSupply -= _value;                              // Update totalSupply
134         emit Burn(_from, _value);
135         return true;
136     }
137 }