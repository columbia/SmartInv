1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4 
5 function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6 uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22 
23 }
24 
25 contract Token {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30     function approve(address _spender, uint256 _value) returns (bool success);
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40       if (balances[msg.sender] >= _value && _value > 0) {
41         balances[msg.sender] -= _value;
42         balances[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45       } else {
46         return false;
47       }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52         balances[_to] += _value;
53         balances[_from] -= _value;
54         allowed[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57       } else {
58         return false;
59       }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract Faceblock is StandardToken, SafeMath {
81 
82     // metadata
83     string public constant name = "Faceblock";
84     string public constant symbol = "FBL";
85     uint256 public constant decimals = 2;
86     string public version = "1.0";
87 
88     // contracts
89     address ethFundDeposit;      // deposit address for ETH for FBL
90     address FBLFounder;
91     address FBLFundDeposit1;      // deposit address for depositing tokens for owners
92     address FBLFundDeposit2;      // deposit address for depositing tokens for owners
93     uint256 public constant FBLFund = 5 * (10**6) * 10**decimals;   // Faceblock reserved for Owners
94     uint256 public constant FBLFounderFund = 5 * (10**6) * 10**decimals;   // Faceblock reserved for Owners
95     uint256 public constant tokenCreationCap =  10 * (10**6) * 10**decimals;
96 
97     /// @dev Accepts ether and creates new FBL tokens.
98     // events
99     event CreateFBL(address indexed _to, uint256 _value);
100 
101     // constructor
102     function Faceblock()
103     {
104       FBLFounder = '0x3A1F12A15f3159903f2EEbe1a2949A780911f695';
105       FBLFundDeposit1 = '0x2E109b1c58625F0770d885ADA419Df16621350bB';
106       FBLFundDeposit2 = '0xAeD77852D6810E5c36ED85Ad1beC9c2368F5400F';
107       totalSupply = safeMult(FBLFund,1);
108       totalSupply = safeAdd(totalSupply,FBLFounderFund);
109       balances[FBLFundDeposit1] = FBLFund;    // works with deposit
110       balances[FBLFundDeposit2] = FBLFund;    // works with deposit
111       transferFrom(0x0, 0x3A1F12A15f3159903f2EEbe1a2949A780911f695, 50 * (10**6) * 10**decimals);
112       transferFrom(0x0, 0xAeD77852D6810E5c36ED85Ad1beC9c2368F5400F, 50 * (10**6) * 10**decimals);
113     }
114 }