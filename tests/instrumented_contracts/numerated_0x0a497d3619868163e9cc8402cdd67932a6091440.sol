1 /*
2 Implements MinerEdgetoken 2018
3 .*/
4 
5 
6 pragma solidity ^0.4.21;
7 
8 
9 contract MET20Interface {
10     uint256 public totalSupply;
11 
12     function balanceOf(address _owner) public view returns (uint256 balance);
13 
14     function transfer(address _to, uint256 _value) public returns (bool success);
15 
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 
18     function approve(address _spender, uint256 _value) public returns (bool success);
19 
20     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 }
25 
26 
27 
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34 
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39 
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47  
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     emit OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 contract MinerEdgeToken is MET20Interface, Ownable {
57 
58     uint256 constant private MAX_UINT256 = 2**256 - 1;
59     mapping (address => uint256) public balances;
60     mapping (address => mapping (address => uint256)) public allowed;
61    
62     string public name;                   
63     uint8 public decimals;                
64     string public symbol;                 
65     uint256 public totalSupply;
66     uint256 public tokenDecimal = 1000000000000000000;
67     uint256 public foundersTeam = 6000000 * tokenDecimal;
68     uint256 public bountyProgam = 1200000 * tokenDecimal;
69     uint256 public MinerEdgeCommunity = 49200000 * tokenDecimal;
70     uint256 public ResearchAndDevelopment = 3600000 * tokenDecimal;
71 
72     constructor() public {
73         totalSupply = 60000000 * tokenDecimal;
74         balances[msg.sender] = totalSupply;           
75         name = "MinerEdgeToken";                                   
76         decimals = 18;                            
77         symbol = "MET";                               
78     }
79 
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         require(balances[msg.sender] >= _value);
82         balances[msg.sender] -= _value;
83         balances[_to] += _value;
84         emit Transfer(msg.sender, _to, _value); 
85         return true;
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
89         require(balances[_from] >= _value);
90         balances[_to] += _value;
91         balances[_from] -= _value;
92 		allowed[_from][msg.sender] -= _value;
93         
94         emit Transfer(_from, _to, _value); 
95         return true;
96     }
97 
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value); 
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111     
112     function () payable {
113 		balances[msg.sender] += msg.value;
114 	}
115 }