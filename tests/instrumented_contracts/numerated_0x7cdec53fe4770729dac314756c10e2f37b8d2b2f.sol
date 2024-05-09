1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
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
14   contract BOLD is ERC20 {
15     string public constant symbol = "BOLD";
16     string public constant name = "Bold";
17     uint8 public constant decimals = 8;
18     uint256 _totalSupply = 7777777 * 10**8;
19 
20     address public owner;
21     mapping(address => uint256) balances;
22     mapping(address => mapping (address => uint256)) allowed;
23      
24   
25    function BOLD() public {
26         owner = msg.sender;
27         balances[owner] = 7777777 * 10**8;
28     }
29      
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34   
35     function totalSupply() public constant returns (uint256 returnedTotalSupply) {
36         returnedTotalSupply = _totalSupply;
37     }
38   
39 
40     function balanceOf(address _owner) public constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43  
44     function transfer(address _to, uint256 _amount) returns (bool success) {
45         if (balances[msg.sender] >= _amount 
46             && _amount > 0) {
47             balances[msg.sender] -= _amount;
48             balances[_to] += _amount;
49             Transfer(msg.sender, _to, _amount);
50             return true;
51         } else {
52             return false;
53         }
54     }     
55      
56     function transferFrom(
57         address _from,
58         address _to,
59         uint256 _amount
60     ) returns (bool success) {
61         if (balances[_from] >= _amount
62             && allowed[_from][msg.sender] >= _amount
63             && _amount > 0
64             && balances[_to] + _amount > balances[_to]) {
65             balances[_from] -= _amount;
66             allowed[_from][msg.sender] -= _amount;
67             balances[_to] += _amount;
68             Transfer(_from, _to, _amount);
69             return true;
70         } else {
71             return false;
72         }
73     }
74  
75     function approve(address _spender, uint256 _amount) public returns (bool success) {
76         allowed[msg.sender][_spender] = _amount;
77         Approval(msg.sender, _spender, _amount);
78         return true;
79     }
80   
81     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
82         return allowed[_owner][_spender];
83     }
84 }