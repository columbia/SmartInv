1 /*
2     Its part of ethereum public blockchain.
3     Developed by RERF Student Development Team 2018.
4 */
5 
6 pragma solidity ^0.4.24;
7 
8 contract ERC20Interface {
9     uint256 public totalSupply;
10 
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 
13     function transfer(address _to, uint256 _value) public returns (bool success);
14 
15     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16 
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 
19     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 }
24 
25 
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38 
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46  
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     emit OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 contract FOODPass is ERC20Interface, Ownable {
56 
57     uint256 constant private MAX_UINT256 = 2**256 - 1;
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60    
61     string public name;                   
62     uint8 public decimals;                
63     string public symbol;                 
64     uint256 public totalSupply;
65     uint256 public tokenDecimal = 1000000000000000000;
66   
67 
68     constructor() public {
69         totalSupply = 3000000 * tokenDecimal;
70         balances[msg.sender] = totalSupply;           
71         name = "FoodPass";                                   
72         decimals = 18;                            
73         symbol = "FPASS";                               
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(balances[msg.sender] >= _value);
78         balances[msg.sender] -= _value;
79         balances[_to] += _value;
80         emit Transfer(msg.sender, _to, _value); 
81         return true;
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
85         require(balances[_from] >= _value);
86         balances[_to] += _value;
87         balances[_from] -= _value;
88 		allowed[_from][msg.sender] -= _value;
89         
90         emit Transfer(_from, _to, _value); 
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value); 
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
105         return allowed[_owner][_spender];
106     }
107     
108     function () payable public {
109 		balances[msg.sender] += msg.value;
110 	}
111 }