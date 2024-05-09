1 pragma solidity >=0.4.22 <0.7.0;
2 
3 library BalancesLib {
4     function move(mapping(address => uint) storage balances, address _from, address _to, uint _amount) internal {
5         require(balances[_from] >= _amount);
6         require(balances[_to] + _amount >= balances[_to]);
7         balances[_from] -= _amount;
8         balances[_to] += _amount;
9     }
10 }
11 
12 contract Token {
13     function balanceOf(address _owner) view public returns (uint balance);
14     function transfer(address _to, uint _value) public returns (bool success);
15     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
16     function approve(address _spender, uint _value) public returns (bool success);
17     function allowance(address _owner, address _spender) view public returns (uint remaining);
18     event Transfer(address indexed _from, address indexed _to, uint _value);
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20     }
21 
22 contract StandardERC20Token is Token {
23     uint totalSupplyValue;
24     address public owner;
25     
26     constructor() public {
27         owner = msg.sender;
28     }
29     
30      modifier onlyOwner {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function totalSupply() public view returns (uint _totalSupply) {
36         _totalSupply=totalSupplyValue;
37     }
38     
39     function transfer(address _to, uint _value) public returns (bool success) {
40         require(!frozenAccount[msg.sender]);
41         require(_to != address(0));
42         balances.move(msg.sender, _to, _value);
43         emit Transfer(msg.sender, _to, _value);
44 	    return true;
45     }
46     
47 
48     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
49         require(!frozenAccount[_from]);                         
50         require(!frozenAccount[_to]);                           
51         require(_to != address(0));
52         require(allowed[_from][msg.sender] >= _amount);
53         allowed[_from][msg.sender] -= _amount;
54         balances.move(_from, _to, _amount);
55         emit Transfer(_from, _to, _amount);
56         return true;
57     }
58 
59     function balanceOf(address _owner) public view returns (uint balance) {
60         return balances[_owner];
61     }
62 
63     function approve(address _spender, uint _tokens) public returns (bool success) {
64         require(allowed[msg.sender][_spender] == 0, "");
65         allowed[msg.sender][_spender] = _tokens;
66         emit Approval(msg.sender, _spender, _tokens);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) view public returns (uint remaining) {
71       return allowed[_owner][_spender];
72     }
73    
74     function freezeAccount(address _target, bool _freeze) public onlyOwner{
75         frozenAccount[_target] = _freeze;
76         emit FrozenFunds(_target, _freeze);
77     }
78     
79     // ------------------------------------------------------------------------
80     // Owner can transfer out any accidentally sent ERC20 tokens
81     // ------------------------------------------------------------------------
82     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
83         return Token(tokenAddress).transfer(owner, tokens);
84     }
85 
86     mapping (address => bool) public frozenAccount;
87     mapping (address => uint) balances;
88     mapping (address => mapping (address => uint)) allowed;
89     event FrozenFunds(address target, bool frozen);
90     using BalancesLib for *;
91 }
92 
93 contract AppUcoin is StandardERC20Token {
94 
95 function () external payable{
96         //if ether is sent to this address, send it back.
97         revert();
98 }
99     string public name;                 
100     uint8 public decimals;               
101     string public symbol;                
102     string public version = '1.0'; 
103     
104     constructor () public{
105         balances[msg.sender] = 1769520000000000;              
106         totalSupplyValue = 1769520000000000;                       
107         name = "AppUcoin";                                   
108         decimals = 8;                                               
109         symbol = "AU";      
110    }
111 }