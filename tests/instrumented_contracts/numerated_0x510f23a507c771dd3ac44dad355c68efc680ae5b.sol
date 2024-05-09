1 // INTERFACE FOR TOKEN
2 contract ERC20Interface {
3     function totalSupply() public constant returns (uint256 totalSupply) {}
4     function balanceOf(address _owner) public constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _amount) public returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {}
7     function approve(address _spender, uint256 _amount) public returns (bool success) {}
8     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 ///////////////////////////////////
14 //                               //
15 //        FORTUNITY PRESALE      //
16 //                               //
17 ///////////////////////////////////
18 
19 contract FortunityPresale is ERC20Interface {
20     string public constant symbol = "FTPS";
21     string public constant name = "FORTUNITY PRESALE";
22     uint8 public constant decimals = 18;
23     uint256 _totalSupply = 1000000000000000000000000;
24     mapping(address => uint256) balances;
25     mapping(address => mapping (address => uint256)) allowed;
26     
27     address public owner;
28     
29     //CONSTRUCTOR
30     function FortunityPresale() public {
31         owner               = msg.sender;
32         balances[owner]     = _totalSupply;
33     }
34     
35     //WHEN ETH IS RECEIVED DIRECTLY
36     function() payable {
37         owner.transfer(this.balance);
38     }
39     
40 
41     // Get total supply
42     function totalSupply() public constant returns (uint256 totalSupply) {
43         totalSupply = _totalSupply;
44     }
45   
46     // What is the balance of a particular account?
47     function balanceOf(address _owner) public constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50   
51     // Transfer the balance from owner's account to another account
52     function transfer(address _to, uint256 _amount) public returns (bool success) {
53         if (balances[msg.sender] >= _amount 
54             && _amount > 0
55             && balances[_to] + _amount > balances[_to]) {
56             balances[msg.sender] -= _amount;
57             balances[_to] += _amount;
58             Transfer(msg.sender, _to, _amount);
59             return true;
60         } else {
61             return false;
62         }
63     }
64   
65     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
66         if (balances[_from] >= _amount
67             && allowed[_from][msg.sender] >= _amount
68             && _amount > 0
69             && balances[_to] + _amount > balances[_to]) {
70             balances[_from] -= _amount;
71             allowed[_from][msg.sender] -= _amount;
72             balances[_to] += _amount;
73             Transfer(_from, _to, _amount);
74             return true;
75         } else {
76             return false;
77         }
78     }
79     
80     function approve(address _spender, uint256 _amount) public returns (bool success) {
81         allowed[msg.sender][_spender] = _amount;
82         Approval(msg.sender, _spender, _amount);
83         return true;
84     }
85     
86  
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90 }