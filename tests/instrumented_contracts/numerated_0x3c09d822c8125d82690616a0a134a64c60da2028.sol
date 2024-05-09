1 pragma solidity ^0.4.23;
2 
3 contract TokenReceiver {
4     function tokenFallback(address _from, uint _value, bytes _data) public;
5 }
6 
7 contract EgeregToken {
8     address public owner;
9     string public name = "EgeregToken";
10     string public symbol = "MNG";
11     uint8 public decimals = 2;
12     uint public totalSupply = 0;
13     mapping(address => uint) balances;
14     mapping (address => mapping (address => uint)) internal allowed;
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     function subtr(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function addit(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function balanceOf(address _owner) external view returns (uint) {
37         return balances[_owner];
38     }
39 
40     function transfer(address _to, uint _value) external returns (bool) {
41         bytes memory empty;
42         transfer(_to, _value, empty);
43         return true;
44     }
45 
46     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
47         require(_value <= balances[msg.sender]);
48         balances[msg.sender] = subtr(balances[msg.sender], _value);
49         balances[_to] = addit(balances[_to], _value);
50         emit Transfer(msg.sender, _to, _value);
51         if (isContract(_to)) {
52             TokenReceiver receiver = TokenReceiver(_to);
53             receiver.tokenFallback(msg.sender, _value, _data);
54         }
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint _value) external returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[_from]);
61         require(_value <= allowed[_from][msg.sender]);
62         balances[_from] = subtr(balances[_from], _value);
63         balances[_to] = addit(balances[_to], _value);
64         allowed[_from][msg.sender] = subtr(allowed[_from][msg.sender], _value);
65         emit Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint _value) public returns (bool) {
70         allowed[msg.sender][_spender] = _value;
71         emit Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function approve(address _spender, uint _value, bytes _data) external returns (bool) {
76         approve(_spender, _value);
77         require(_spender.call(_data));
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) external view returns (uint) {
82         return allowed[_owner][_spender];
83     }
84 
85     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
86         allowed[msg.sender][_spender] = addit(allowed[msg.sender][_spender], _addedValue);
87         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
88         return true;
89     }
90 
91     function increaseApproval(address _spender, uint _addedValue, bytes _data) external returns (bool) {
92         increaseApproval(_spender, _addedValue);
93         require(_spender.call(_data));
94         return true;
95     }
96 
97     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
98         uint oldValue = allowed[msg.sender][_spender];
99         if (_subtractedValue > oldValue) {
100             allowed[msg.sender][_spender] = 0;
101         } else {
102             allowed[msg.sender][_spender] = subtr(oldValue, _subtractedValue);
103         }
104         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105         return true;
106     }
107 
108     function transferOwnership(address newOwner) external onlyOwner {
109         require(newOwner != address(0));
110         emit OwnershipTransferred(owner, newOwner);
111         owner = newOwner;
112     }
113 
114     function mint(address _to, uint _amount) onlyOwner external returns (bool) {
115         totalSupply = addit(totalSupply, _amount);
116         balances[_to] = addit(balances[_to], _amount);
117         emit Mint(_to, _amount);
118         emit Transfer(address(0), _to, _amount);
119         return true;
120     }
121 
122     function burn(uint _value) external {
123         require(_value <= balances[msg.sender]);
124         address burner = msg.sender;
125         balances[burner] = subtr(balances[burner], _value);
126         totalSupply = subtr(totalSupply, _value);
127         emit Burn(burner, _value);
128         emit Transfer(burner, address(0), _value);
129     }
130 
131     function isContract(address _addr) private view returns (bool) {
132         uint length;
133         assembly {
134             length := extcodesize(_addr)
135         }
136         return (length>0);
137     }
138 
139     event Transfer(address indexed from, address indexed to, uint value);
140     event Approval(address indexed owner, address indexed spender, uint value);
141     event Mint(address indexed to, uint amount);
142     event Burn(address indexed burner, uint value);
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 }