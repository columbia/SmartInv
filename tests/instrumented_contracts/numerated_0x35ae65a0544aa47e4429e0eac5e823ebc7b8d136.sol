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
14   contract LCD_newTest is ERC20 {
15     string public constant symbol = "LCD_newTest";
16     string public constant name = "LCD_newTest token";
17     uint8 public constant decimals = 8;
18     uint256 _totalSupply = 15 * 10**8;
19 
20     address public owner;
21     mapping(address => uint256) balances;
22     mapping(address => mapping (address => uint256)) allowed;
23      
24   
25   	modifier notPaused{
26     	require(now > 1509716751 || msg.sender == owner);
27     	_;
28 	 }
29 
30     function LCD_newTest() public {
31         owner = msg.sender;
32         balances[owner] = 8400000 * 10**8;
33     }
34      
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39      
40      
41      //function distributeTLTDaddress[] addresses) onlyOwner {
42      //    for (uint i = 0; i < addresses.length; i++) {
43      //        balances[owner] -= 245719916000;
44      //        balances[addresses[i]] += 245719916000;
45      //        Transfer(owner, addresses[i], 245719916000);
46      //    }
47      //}
48      
49   
50     function totalSupply() public constant returns (uint256 returnedTotalSupply) {
51         returnedTotalSupply = _totalSupply;
52     }
53   
54 
55     function balanceOf(address _owner) public constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58  
59     function transfer(address _to, uint256 _amount) public notPaused returns (bool success) {
60         if (balances[msg.sender] >= _amount 
61             && _amount > 0) {
62             balances[msg.sender] -= _amount;
63             balances[_to] += _amount;
64             Transfer(msg.sender, _to, _amount);
65             return true;
66         } else {
67             return false;
68         }
69     }
70      
71      
72     function transferFrom(
73         address _from,
74         address _to,
75         uint256 _amount
76     ) public notPaused returns (bool success) {
77         if (balances[_from] >= _amount
78             && allowed[_from][msg.sender] >= _amount
79             && _amount > 0
80             && balances[_to] + _amount > balances[_to]) {
81             balances[_from] -= _amount;
82             allowed[_from][msg.sender] -= _amount;
83             balances[_to] += _amount;
84             Transfer(_from, _to, _amount);
85             return true;
86         } else {
87             return false;
88         }
89     }
90  
91     function approve(address _spender, uint256 _amount) public returns (bool success) {
92         allowed[msg.sender][_spender] = _amount;
93         Approval(msg.sender, _spender, _amount);
94         return true;
95     }
96   
97     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }
100 }