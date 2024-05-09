1 pragma solidity ^0.4.24;
2 contract Ownable {
3   address public owner;
4   function Ownable() {
5     owner = msg.sender;
6   }
7 
8   modifier onlyOwner() {
9     require(msg.sender == owner);
10     _;
11   }
12 
13   function transferOwnership(address newOwner) onlyOwner {
14     require(newOwner != address(0));      
15     owner = newOwner;
16   } 
17 }
18 
19 contract Token is Ownable{
20     uint256 public totalSupply;
21 
22     function balanceOf(address _owner) constant returns (uint256 balance);
23 
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
27 
28     function approve(address _spender, uint256 _value) returns (bool success);
29 
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 contract StandardToken is Token {
38     function transfer(address _to, uint256 _value) returns (bool success) {
39         require(balances[msg.sender] >= _value);
40         balances[msg.sender] -= _value;
41         balances[_to] += _value;
42         Transfer(msg.sender, _to, _value);
43         return true;
44     }
45 
46 
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
48         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
49         balances[_to] += _value;
50         balances[_from] -= _value; 
51         allowed[_from][msg.sender] -= _value;
52         Transfer(_from, _to, _value); 
53         return true;
54     }
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59 
60     function approve(address _spender, uint256 _value) returns (bool success) {
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];
68     }
69     
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }
73 
74 contract WanChainToken is StandardToken { 
75 
76     string public name;                   
77     uint8 public decimals;               
78     string public symbol; 
79     uint256 public createTime;
80     uint public releaseAmount = 350000000;
81     mapping(uint => bool) public releaseMapping; 
82      
83 
84     function WanChainToken() {
85         balances[msg.sender] = 3000000000; 
86         totalSupply = 10000000000;         
87         name = "Wan Chain Token";                   
88         decimals = 1;           
89         symbol = "WLZJ";  
90         createTime = now;
91     }
92 
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
97         return true;
98     }
99     function release(uint month) onlyOwner{
100         require(month >=1 && month <= 20 );
101         require(now >= (month * 30 days) + createTime);
102         require(!releaseMapping[month]);
103         balances[owner] = balances[owner] + releaseAmount;
104         releaseMapping[month] = true;
105     }
106 
107 }