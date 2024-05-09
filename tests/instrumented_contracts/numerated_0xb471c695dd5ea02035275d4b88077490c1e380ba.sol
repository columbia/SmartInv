1 contract ERC20xVariables {
2     address public creator;
3     address public lib;
4 
5     uint256 constant public MAX_UINT256 = 2**256 - 1;
6     mapping(address => uint) public balances;
7     mapping(address => mapping(address => uint)) public allowed;
8 
9     uint8 public constant decimals = 18;
10     string public name;
11     string public symbol;
12     uint public totalSupply;
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 
17     event Created(address creator, uint supply);
18 
19     function balanceOf(address _owner) public view returns (uint256 balance) {
20         return balances[_owner];
21     }
22 
23     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
24         return allowed[_owner][_spender];
25     }
26 }
27 
28 contract ERC20x is ERC20xVariables {
29 
30     function transfer(address _to, uint256 _value) public returns (bool success) {
31         _transferBalance(msg.sender, _to, _value);
32         emit Transfer(msg.sender, _to, _value);
33         return true;
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         uint256 allowance = allowed[_from][msg.sender];
38         require(allowance >= _value);
39         _transferBalance(_from, _to, _value);
40         if (allowance < MAX_UINT256) {
41             allowed[_from][msg.sender] -= _value;
42         }
43         emit Transfer(_from, _to, _value);
44         return true;
45     }
46 
47     function approve(address _spender, uint256 _value) public returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         emit Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function transferToContract(address _to, uint256 _value, bytes data) public returns (bool) {
54         _transferBalance(msg.sender, _to, _value);
55         bytes4 sig = bytes4(keccak256("receiveTokens(address,uint256,bytes)"));
56         require(_to.call(sig, msg.sender, _value, data));
57         emit Transfer(msg.sender, _to, _value);
58         return true;
59     }
60 
61     function _transferBalance(address _from, address _to, uint _value) internal {
62         require(balances[_from] >= _value);
63         balances[_from] -= _value;
64         balances[_to] += _value;
65     }
66 }
67 
68 contract VariableSupplyToken is ERC20x {
69     function grant(address to, uint256 amount) public {
70         require(msg.sender == creator);
71         require(balances[to] + amount >= amount);
72         balances[to] += amount;
73         totalSupply += amount;
74     }
75 
76     function burn(address from, uint amount) public {
77         require(msg.sender == creator);
78         require(balances[from] >= amount);
79         balances[from] -= amount;
80         totalSupply -= amount;
81     }
82 }
83 
84 // we don't store much state here either
85 contract Token is VariableSupplyToken {
86     constructor() public {
87         creator = msg.sender;
88         name = "Decentralized Settlement Facility Token";
89         symbol = "DSF";
90 
91         // this needs to be here to avoid zero initialization of token rights.
92         totalSupply = 1;
93         balances[0x0] = 1;
94     }
95 }