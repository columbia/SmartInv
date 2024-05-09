1 /*
2 Implements RAM-TOKEN-DEVELOPER 2018
3 .*/
4 
5 pragma solidity ^0.4.21;
6 
7 contract ERC20Interface {
8     uint256 public totalSupply;
9 
10     function balanceOf(address _owner) public view returns (uint256 balance);
11 
12     function transfer(address _to, uint256 _value) public returns (bool success);
13 
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 
16     function approve(address _spender, uint256 _value) public returns (bool success);
17 
18     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22 }
23 
24 
25 
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33   constructor() public {
34     owner = msg.sender;
35   }
36 
37 
38 
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45  
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 contract ETHLightToken is ERC20Interface, Ownable {
55 
56     uint256 constant private MAX_UINT256 = 2**256 - 1;
57     mapping (address => uint256) public balances;
58     mapping (address => mapping (address => uint256)) public allowed;
59    
60     string public name;                   
61     uint8 public decimals;                
62     string public symbol;                 
63     uint256 public totalSupply;
64     uint256 public tokenDecimal = 1000000000000000000;
65   
66 
67     constructor() public {
68         totalSupply = 2000000000 * tokenDecimal;
69         balances[msg.sender] = totalSupply;           
70         name = "ETH Light";                                   
71         decimals = 18;                            
72         symbol = "ELT";                               
73     }
74 
75     function transfer(address _to, uint256 _value) public returns (bool success) {
76         require(balances[msg.sender] >= _value);
77         balances[msg.sender] -= _value;
78         balances[_to] += _value;
79         emit Transfer(msg.sender, _to, _value); 
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
84         require(balances[_from] >= _value);
85         balances[_to] += _value;
86         balances[_from] -= _value;
87 		allowed[_from][msg.sender] -= _value;
88         
89         emit Transfer(_from, _to, _value); 
90         return true;
91     }
92 
93     function balanceOf(address _owner) public view returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) public returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value); 
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
104         return allowed[_owner][_spender];
105     }
106     
107     function () payable public {
108 		balances[msg.sender] += msg.value;
109 	}
110 }