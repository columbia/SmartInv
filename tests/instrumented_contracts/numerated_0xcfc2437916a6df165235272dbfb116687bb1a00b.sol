1 pragma solidity ^0.4.23;
2 
3 /**
4 * @title PlusCoin Contract
5 * @dev The main token contract
6 */
7 
8 
9 
10 contract PlusCoin {
11     address public owner; // Token owner address
12     mapping (address => uint256) public balances;
13     mapping (address => mapping (address => uint256)) allowed;
14 
15     string public standard = 'PlusCoin 2.0';
16     string public constant name = "PlusCoin";
17     string public constant symbol = "PLCN";
18     uint   public constant decimals = 18;
19     uint public totalSupply;
20 
21     address public allowed_contract;
22 
23     //
24     // Events
25     // This generates a publics event on the blockchain that will notify clients
26     
27     event Sent(address from, address to, uint amount);
28     event Buy(address indexed sender, uint eth, uint fbt);
29     event Withdraw(address indexed sender, address to, uint eth);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     //
34     // Modifiers
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41 
42     modifier onlyAllowedContract() {
43         require(msg.sender == allowed_contract);
44         _;
45     }
46 
47     //
48     // Functions
49     // 
50 
51     // Constructor
52     constructor() public {
53         owner = msg.sender;
54         totalSupply = 28272323624 * 1000000000000000000;
55         balances[owner] = totalSupply;
56     }
57 
58     /**
59     * @dev Allows the current owner to transfer control of the contract to a newOwner.
60     * @param newOwner The address to transfer ownership to.
61     */
62     function transferOwnership(address newOwner) public onlyOwner {
63       if (newOwner != address(0)) {
64         owner = newOwner;
65       }
66     }
67 
68     function safeMul(uint a, uint b) internal pure returns (uint) {
69         uint c = a * b;
70         require(a == 0 || c / a == b);
71         return c;
72     }
73 
74     function safeSub(uint a, uint b) internal pure returns (uint) {
75         require(b <= a);
76         return a - b;
77     }
78 
79     function safeAdd(uint a, uint b) internal pure returns (uint) {
80         uint c = a + b;
81         require(c>=a && c>=b);
82         return c;
83     }
84 
85  
86 
87 	function setAllowedContract(address _contract_address) public
88         onlyOwner
89         returns (bool success)
90     {
91         allowed_contract = _contract_address;
92         return true;
93     }
94 
95 
96     function withdrawEther(address _to) public 
97         onlyOwner
98     {
99         _to.transfer(address(this).balance);
100     }
101 
102 
103 
104     /**
105      * ERC 20 token functions
106      *
107      * https://github.com/ethereum/EIPs/issues/20
108      */
109     
110     function transfer(address _to, uint256 _value) public
111         returns (bool success) 
112     {
113         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
114             balances[msg.sender] -= _value;
115             balances[_to] += _value;
116             emit Transfer(msg.sender, _to, _value);
117             return true;
118         } else { return false; }
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public
122         returns (bool success)
123     {
124         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
125             balances[_to] += _value;
126             balances[_from] -= _value;
127             allowed[_from][msg.sender] -= _value;
128             emit Transfer(_from, _to, _value);
129             return true;
130         } else { return false; }
131     }
132 
133     function balanceOf(address _owner) constant public returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function approve(address _spender, uint256 _value) public
138         returns (bool success)
139     {
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145     function allowance(address _owner, address _spender) public
146         constant returns (uint256 remaining)
147     {
148       return allowed[_owner][_spender];
149     }
150 
151 }