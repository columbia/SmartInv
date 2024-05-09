1 pragma solidity ^0.4.18;
2 
3   contract ERC20 {
4     function totalSupply() public constant returns (uint256 returnedTotalSupply);
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12  }
13   
14   contract LTCD is ERC20 {
15     string public constant symbol = "LTCD";
16     string public constant name = "Litecoin Dark";
17     uint8 public constant decimals = 8;
18     uint256 _totalSupply = 8400000 * 10**8;
19 
20     address public owner;
21     mapping(address => uint256) balances;
22     mapping(address => mapping (address => uint256)) allowed;
23      
24   
25   	modifier notPaused{
26     	require(now > 1510700400 || msg.sender == owner);
27     	_;
28 	 }
29 
30     function LTCD() public {
31         owner = msg.sender;
32         balances[owner] = 8400000 * 10**8;
33     }
34      
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39   
40     function totalSupply() public constant returns (uint256 returnedTotalSupply) {
41         returnedTotalSupply = _totalSupply;
42     }
43   
44 
45     function balanceOf(address _owner) public constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48  
49     function transfer(address _to, uint256 _amount) public notPaused returns (bool success) {
50         if (balances[msg.sender] >= _amount 
51             && _amount > 0) {
52             balances[msg.sender] -= _amount;
53             balances[_to] += _amount;
54             Transfer(msg.sender, _to, _amount);
55             return true;
56         } else {
57             return false;
58         }
59     }
60      
61      
62     function transferFrom(
63         address _from,
64         address _to,
65         uint256 _amount
66     ) public notPaused returns (bool success) {
67         if (balances[_from] >= _amount
68             && allowed[_from][msg.sender] >= _amount
69             && _amount > 0
70             && balances[_to] + _amount > balances[_to]) {
71             balances[_from] -= _amount;
72             allowed[_from][msg.sender] -= _amount;
73             balances[_to] += _amount;
74             Transfer(_from, _to, _amount);
75             return true;
76         } else {
77             return false;
78         }
79     }
80  
81     function approve(address _spender, uint256 _amount) public returns (bool success) {
82         allowed[msg.sender][_spender] = _amount;
83         Approval(msg.sender, _spender, _amount);
84         return true;
85     }
86   
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90 }